// ===== chat.js (교체본) =====

// ===== DOM & data =====
const root = document.getElementById('chat-root');
if (!root) {
  console.error('[chat] #chat-root 요소가 없습니다. JSP에 data-* 속성을 넣어주세요.');
}

// 사용자/환경 값
const loginUserId   = root ? parseInt(root.dataset.userId ?? '0', 10) : 0; // ✅ 숫자
const loginUserName = root ? String(root.dataset.userName ?? 'Me')    : 'Me';
const roomId        = root ? parseInt(root.dataset.roomId ?? '1', 10) : 1;

const wsEndpoint = root ? (root.dataset.wsEndpoint || '/stomp/chat') : '/stomp/chat';
const pubDest    = root ? (root.dataset.pubDest    || '/pub/chat/send') : '/pub/chat/send';
const subDest    = (root ? (root.dataset.subPrefix || '/sub/room.') : '/sub/room.') + roomId;

// 아바타 경로 (외부 JS에서 c:url 사용 금지 → data-*로만)
const AVATAR_ME   = root ? (root.dataset.avatarMe   || '/HTML/Admin/dist/assets/images/users/avatar-1.jpg')
                         : '/HTML/Admin/dist/assets/images/users/avatar-1.jpg';
const AVATAR_USER = root ? (root.dataset.avatarUser || '/HTML/Admin/dist/assets/images/users/avatar-5.jpg')
                         : '/HTML/Admin/dist/assets/images/users/avatar-5.jpg';

// ===== state =====
let stomp = null;
let subs  = null;

// ===== UI =====
function appendToChat(senderId, content, displayName) {
  const ul = document.querySelector('ul.chat-list');
  if (!ul) { console.log(`[${senderId}] ${content}`); return; }

  const isSys = String(senderId).toUpperCase() === 'SYS';
  const mine  = !isSys && String(senderId) === String(loginUserId);
  const name  = isSys ? 'System' : (mine ? 'You.' : (displayName || 'User'));
  const time  = new Date().toLocaleTimeString([], {hour:'2-digit', minute:'2-digit'});

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

  li.querySelector('.chat-message p').textContent = content ?? '';
  ul.appendChild(li);

  const wrap = ul.closest('[data-simplebar]') || ul.parentElement;
  if (wrap) wrap.scrollTop = wrap.scrollHeight;
}

// ===== WebSocket / STOMP =====
function connect() {
  const sock = new SockJS(wsEndpoint);
  stomp = Stomp.over(sock);
  stomp.debug = null;
  stomp.connect({}, onConnected, onWsError);
  sock.onclose = () => appendToChat('SYS', 'WS CLOSED');
}

function onConnected() {
  appendToChat('SYS', 'CONNECTED');
  subs?.unsubscribe?.();
  subs = stomp.subscribe(subDest, onMessage);
}

function onMessage(msg) {
  try {
    const d = JSON.parse(msg.body || '{}'); // 서버는 JSON 문자열을 push
    // 서버 DTO 필드: senderId, chatContent, chatRoomId, ...
    const senderId = d?.senderId ?? '';
    const text     = d?.chatContent ?? d?.message ?? d?.content ?? '';
    const name     = d?.senderName ?? ''; // 서버가 내려주면 표시(필수 아님)
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
  const body   = (textEl?.value || '').trim();
  if (!body || !stomp?.connected) return;

  // ✅ 서버 DTO(ChatMessage)에 "있는 필드만" 보냄
  const payload = {
    chatRoomId:  roomId,
    messageType: 'TEXT',
    chatContent: body,
    senderId:    loginUserId       // 숫자
    // senderName: loginUserName    // 서버 DTO에 없으면 보내지 마세요 (예외 발생)
  };

  stomp.send(pubDest, {}, JSON.stringify(payload));
  textEl.value = '';
  textEl.focus();
}

// ===== boot =====
window.addEventListener('load', () => {
  connect();

  const input = document.getElementById('text');
  if (input) input.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') { e.preventDefault(); sendMsg(); }
  });

  const form = document.getElementById('chat-form');
  if (form) form.addEventListener('submit', (e) => {
    e.preventDefault();
    sendMsg();
  });
});
