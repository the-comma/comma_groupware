/* ===== chat.js (방 전환 지원 버전) ===== */

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

  // ===== UI =====
  function appendToChat(senderId, content, displayName) {
    const ul = document.querySelector('ul.chat-list');
    if (!ul) { console.log('[' + senderId + '] ' + content); return; }

    const isSys = String(senderId).toUpperCase() === 'SYS';
    const mine  = !isSys && String(senderId) === String(loginUserId);
    const name  = isSys ? 'System' : (mine ? 'You.' : (displayName || 'User'));
    const time  = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

    const li = document.createElement('li');
    li.className = 'chat-group' + (mine ? ' odd' : '');
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
    ul.appendChild(li);

    const wrap = ul.closest('[data-simplebar]') || ul.parentElement;
    if (wrap) wrap.scrollTop = wrap.scrollHeight;
  }

  function setHeaderTitle(title) {
    // 우측 채팅 헤더에 표시되는 상대 이름 갱신(있을 때만)
    const el = document.querySelector('.card.chat-content .card-header a.text-reset');
    if (el && title) el.textContent = title;
    // 단순 페이지에서 쓰는 #rid 갱신(있으면)
    const rid = document.getElementById('rid');
    if (rid) rid.textContent = String(currentRoomId);
  }

  function clearChat() {
    const ul = document.querySelector('ul.chat-list');
    if (ul) ul.innerHTML = '';
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
      if (!senderId && !text) appendToChat('SYS', '(empty payload)');
      else appendToChat(senderId || '-', text, name);
    } catch (e) {
      appendToChat('SYS', msg.body || '');
    }
  }

  function onWsError() {
    appendToChat('SYS', 'WS ERROR');
  }

  // ===== actions =====
  function sendMsg() {
    const textEl = document.getElementById('text');
    const body   = (textEl && textEl.value ? textEl.value : '').trim();
    if (!body || !stomp || !stomp.connected) return;

    // 서버 DTO(ChatMessage)에 맞춰 필드만 전송
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

    // (선택) 과거 메시지 불러오기: 서버에 REST API가 있다면 사용
    // try {
    //   const res = await fetch('/api/chat/rooms/' + id + '/messages?limit=50');
    //   if (res.ok) {
    //     const list = await res.json();
    //     list.forEach(function (m) {
    //       appendToChat(m.senderId, m.chatContent || m.message || '', m.senderName);
    //     });
    //   }
    // } catch (e) { console.warn('history load failed', e); }
  }

  // ===== boot =====
  window.addEventListener('load', function () {
    connect();

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

  // 필요하면 전역에서 호출할 수 있게 공개
  window.ChatSwitchRoom = switchRoom;

})();
