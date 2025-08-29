/* ===== chat.js (방 전환 + beforeId/afterId + DB시간 표시) ===== */

(function () {
  // ===== DOM & data =====
  const root = document.getElementById('chat-root');
  if (!root) {
    console.error('[chat] #chat-root 요소가 없습니다. JSP에 data-* 속성을 넣어주세요.');
    return;
  }

  // 로그인/환경 값
  const loginUserId   = parseInt(root.dataset.userId  || '0', 10);   // number
  const loginUserName = String(root.dataset.userName  || 'Me');
  let   currentRoomId = parseInt(root.dataset.roomId  || '1', 10) || 1;

  const wsEndpoint = root.dataset.wsEndpoint || '/stomp/chat';
  const pubDest    = root.dataset.pubDest    || '/pub/chat/send';
  const SUB_PREFIX = root.dataset.subPrefix  || '/sub/room.';

  // 아바타 경로 (외부 JS에서는 c:url 사용 불가 → JSP에서 data-*로 전달)
  const AVATAR_ME   = root.dataset.avatarMe   || '/HTML/Admin/dist/assets/images/users/avatar-1.jpg';
  const AVATAR_USER = root.dataset.avatarUser || '/HTML/Admin/dist/assets/images/users/avatar-5.jpg';

  // ===== state =====
  let stomp = null;
  let subs  = null;

  // 히스토리 로딩 상태
  let loadingOlder   = false;
  let loadingNewer   = false;
  let noMoreOlder    = false;

  // ===== 시간 포맷 유틸 =====
  function fmtTime(ts) {
    try {
      if (ts == null) {
        return new Date().toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' });
      }
      let d;
      if (typeof ts === 'number') {
        // 초 단위(epoch seconds)와 밀리초(epoch ms) 모두 케어
        d = ts < 1e12 ? new Date(ts * 1000) : new Date(ts);
      } else {
        // ISO 문자열 또는 'yyyy-MM-dd HH:mm:ss' 같은 문자열 시도
        d = new Date(ts);
        if (isNaN(d.getTime())) {
          // 'yyyy-MM-dd HH:mm:ss' → 'T' 넣어 ISO 비슷하게 재시도
          d = new Date(String(ts).replace(' ', 'T'));
        }
      }
      if (isNaN(d.getTime())) {
        return new Date().toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' });
      }
      return d.toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' });
    } catch {
      return new Date().toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' });
    }
  }

  // ===== UI =====
  function appendToChat(senderId, content, displayName, msgId, position, createdAt) {
    const ul = document.querySelector('ul.chat-list');
    if (!ul) { console.log('[' + senderId + '] ' + content); return; }

    const isSys = String(senderId).toUpperCase() === 'SYS';
    const mine  = !isSys && String(senderId) === String(loginUserId);
    const name  = isSys ? 'System' : (mine ? 'You.' : (displayName || 'User'));
    const time  = fmtTime(createdAt); // ★ DB 시간(or 전달된 시간)으로 표시

    const li = document.createElement('li');
    li.className = 'chat-group' + (mine ? ' odd' : '');
    if (msgId != null) li.dataset.mid = String(msgId); // ★ 커서용 message id 저장

    li.innerHTML =
      '<img src="' + (mine ? AVATAR_ME : AVATAR_USER) + '" class="avatar-sm rounded-circle" alt="">' +
      '<div class="chat-body">' +
        '<div>' +
          '<h6 class="d-inline-flex">' + name + '</h6>' +
          '<h6 class="d-inline-flex text-muted">' + time + '</h6>' +
        '</div>' +
        '<div class="chat-message"><p></p></div>' +
      '</div>';

    li.querySelector('.chat-message p').textContent = content || '';

    const wrap = ul.closest('[data-simplebar]') || ul.parentElement;

    if (position === 'top') {
      // 위로 끼워넣기(과거 로드)
      const prevScrollBottom = wrap ? (wrap.scrollHeight - wrap.scrollTop) : 0;
      ul.insertBefore(li, ul.firstChild);
      if (wrap) wrap.scrollTop = wrap.scrollHeight - prevScrollBottom; // 스크롤 위치 유지
    } else {
      // 기본: 맨 아래로
      ul.appendChild(li);
      if (wrap) wrap.scrollTop = wrap.scrollHeight;
    }
  }

  function setHeaderTitle(title) {
    const el = document.querySelector('.card.chat-content .card-header a.text-reset');
    if (el && title) el.textContent = title;
    const rid = document.getElementById('rid');
    if (rid) rid.textContent = String(currentRoomId);
  }

  function clearChat() {
    const ul = document.querySelector('ul.chat-list');
    if (ul) ul.innerHTML = '';
    noMoreOlder = false;
  }

  // ===== 커서 유틸 =====
  function getOldestMessageId() {
    const ul = document.querySelector('ul.chat-list');
    if (!ul) return null;
    let min = null;
    ul.querySelectorAll('li.chat-group[data-mid]').forEach(function (li) {
      const v = parseInt(li.dataset.mid, 10);
      if (!isNaN(v)) {
        if (min == null || v < min) min = v;
      }
    });
    return min; // 없으면 null
  }

  function getNewestMessageId() {
    const ul = document.querySelector('ul.chat-list');
    if (!ul) return null;
    let max = null;
    ul.querySelectorAll('li.chat-group[data-mid]').forEach(function (li) {
      const v = parseInt(li.dataset.mid, 10);
      if (!isNaN(v)) {
        if (max == null || v > max) max = v;
      }
    });
    return max; // 없으면 null
  }

  // ===== WebSocket / STOMP =====
  function connect() {
    const sock = new SockJS(wsEndpoint);
    stomp = Stomp.over(sock);
    stomp.debug = null;
    stomp.connect({}, onConnected, onWsError);
    sock.onclose = function () { appendToChat('SYS', 'WS CLOSED'); };
  }

  function onConnected() {
    appendToChat('SYS', 'CONNECTED');
    resubscribe();
  }

  function resubscribe() {
    try { if (subs && typeof subs.unsubscribe === 'function') subs.unsubscribe(); } catch (e) {}
    if (stomp && stomp.connected) {
      subs = stomp.subscribe(SUB_PREFIX + currentRoomId, onMessage);
    }
  }

  function onMessage(msg) {
    try {
      const d = JSON.parse(msg.body || '{}');   // 서버는 JSON 문자열을 푸시
      const senderId = (d && d.senderId != null) ? d.senderId : '';
      const text     = (d && (d.chatContent || d.message || d.content)) || '';
      const name     = (d && d.senderName) || '';
      const mid      = (d && (d.chatMessageId || d.id || d.messageId)) ?? null; // ★ push에도 id 있으면 좋음
      const at       =  d && (d.createdAt || d.created_at || d.time || d.timestamp); // ★ DB 시간 받기

      if (!senderId && !text) appendToChat('SYS', '(empty payload)', '', mid, undefined, at);
      else appendToChat(senderId || '-', text, name, mid, undefined, at);
    } catch (e) {
      appendToChat('SYS', msg.body || '');
    }
  }

  function onWsError() {
    appendToChat('SYS', 'WS ERROR');
  }

  // ===== REST 히스토리 =====
  function buildHistoryUrl(params) {
    // 서버 구현: GET /api/chat/rooms/{roomId}/messages?limit=&beforeId=&afterId=
    const q = new URLSearchParams();
    if (params && params.limit)    q.set('limit', String(params.limit));
    if (params && params.beforeId != null) q.set('beforeId', String(params.beforeId));
    if (params && params.afterId  != null) q.set('afterId',  String(params.afterId));
    return '/api/chat/rooms/' + currentRoomId + '/messages' + (q.toString() ? ('?' + q.toString()) : '');
  }

  async function loadHistory(params = {}) {
    const isOlder = params.beforeId != null; // 과거 로딩 모드
    const isNewer = params.afterId  != null; // 최신 로딩 모드

    if (isOlder) {
      if (loadingOlder || noMoreOlder) return;
      loadingOlder = true;
    }
    if (isNewer) {
      if (loadingNewer) return;
      loadingNewer = true;
    }

    try {
      const url = buildHistoryUrl(params);
      const res = await fetch(url, { headers: { 'Accept': 'application/json' }});
      if (!res.ok) throw new Error('HTTP ' + res.status);
      const list = await res.json();

      if (!Array.isArray(list) || list.length === 0) {
        if (isOlder) {
          noMoreOlder = true;
          appendToChat('SYS', '더 이상 불러올 메세지가 없습니다.');
        }
        return;
      }

      if (isOlder) {
        // 보통 API가 최신→오래된 순으로 줄 수 있으므로, 오래된 것부터 위에 끼워넣기 위해 역순
        list.slice().reverse().forEach(function (m) {
          const at = m.createdAt || m.created_at || m.time || m.timestamp;
          appendToChat(
            m.senderId,
            m.chatContent || m.message || '',
            m.senderName,
            m.chatMessageId || m.id || m.messageId,
            'top',
            at
          );
        });
      } else if (isNewer) {
        // 최신 로딩: 자연스런 시간 흐름대로 아래에 붙이기
        list.forEach(function (m) {
          const at = m.createdAt || m.created_at || m.time || m.timestamp;
          appendToChat(
            m.senderId,
            m.chatContent || m.message || '',
            m.senderName,
            m.chatMessageId || m.id || m.messageId,
            undefined,
            at
          );
        });
      } else {
        // 초기 로드(파라미터 없이 호출): 가장 최근 N개를 아래부터 표시
        // 서버가 최신→오래된 순이라면 여기서는 역순으로 그려 자연스럽게 만듦
        list.slice().reverse().forEach(function (m) {
          const at = m.createdAt || m.created_at || m.time || m.timestamp;
          appendToChat(
            m.senderId,
            m.chatContent || m.message || '',
            m.senderName,
            m.chatMessageId || m.id || m.messageId,
            undefined,
            at
          );
        });
      }
    } catch (e) {
      console.warn('history load failed', e);
    } finally {
      loadingOlder = false;
      loadingNewer = false;
    }
  }

  function bindInfiniteScroll() {
    const wrap = document.querySelector('[data-apps-chat="messages-scroll-wrapper"]');
    if (!wrap) return;
    wrap.addEventListener('scroll', function () {
      // 최상단에 닿으면 과거 로드(beforeId)
      if (wrap.scrollTop <= 0) {
        const beforeId = getOldestMessageId();
        loadHistory({ limit: 50, beforeId: beforeId }); // beforeId 없으면 서버가 최신 N개 반환
      }
      // (선택) 바닥 근처에서 최신 로드(afterId) 하고 싶으면 아래 주석 해제
      // const nearBottom = (wrap.scrollHeight - wrap.scrollTop - wrap.clientHeight) < 10;
      // if (nearBottom) {
      //   const afterId = getNewestMessageId();
      //   if (afterId != null) loadHistory({ limit: 50, afterId: afterId });
      // }
    });
  }

  // ===== actions =====
  function sendMsg() {
    const textEl = document.getElementById('text');
    const body   = (textEl && textEl.value ? textEl.value : '').trim();
    if (!body || !stomp || !stomp.connected) return;

    const payload = {
      chatRoomId:  currentRoomId,
      messageType: 'TEXT',
      chatContent: body,
      senderId:    loginUserId
    };

    stomp.send(pubDest, {}, JSON.stringify(payload));
    if (textEl) { textEl.value = ''; textEl.focus(); }
  }

  async function switchRoom(newRoomId, title) {
    const id = parseInt(newRoomId, 10);
    if (!id || id === currentRoomId) return;

    currentRoomId = id;
    root.dataset.roomId = String(id);

    clearChat();
    setHeaderTitle(title || '');
    appendToChat('SYS', 'ENTER ROOM #' + id);

    resubscribe();

    // 초기 히스토리 1회(최근 N개)
    loadHistory({ limit: 50 });
  }

  // ===== boot =====
  window.addEventListener('load', function () {
    connect();
    bindInfiniteScroll();

    const input = document.getElementById('text');
    if (input) input.addEventListener('keydown', function (e) {
      if (e.key === 'Enter') { e.preventDefault(); sendMsg(); }
    });

    const form = document.getElementById('chat-form');
    if (form) form.addEventListener('submit', function (e) {
      e.preventDefault();
      sendMsg();
    });

    // 좌측 리스트 클릭 → 방 전환 (data-room-id, data-title 필요)
    document.addEventListener('click', function (e) {
      const a = e.target.closest('.js-room');
      if (!a) return;
      e.preventDefault();
      const id    = parseInt(a.dataset.roomId || '0', 10);
      const title = a.dataset.title || '';
      switchRoom(id, title);
    });
  });

  // 외부에서 수동으로 최신 동기화가 필요하면 호출:
  // 예) window.ChatLoadNewer();
  window.ChatLoadNewer = function (limit = 50) {
    const afterId = getNewestMessageId();
    if (afterId != null) loadHistory({ limit, afterId });
  };

  // 필요하면 전역에서 방 전환도 호출 가능
  window.ChatSwitchRoom = switchRoom;

})();
