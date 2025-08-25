<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <title>WS Basic</title>

  <!-- SockJS / STOMP (브라우저 전역에 SockJS, Stomp 제공) -->
  <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

  <style>
    body { font-family: system-ui, sans-serif; }
    #log { height: 340px; overflow: auto; border:1px solid #ddd; padding:8px; white-space: pre-wrap; }
    .row { margin-top: 8px; display: flex; gap: 8px; }
    input[type="text"] { flex: 1; padding: 6px 8px; }
    input[type="number"] { width: 70px; padding: 6px 8px; }
    button { padding: 6px 12px; cursor: pointer; }
  </style>
</head>
<body>
  <h3>Room #<span id="rid">1</span></h3>
  <div id="log"></div>

  <div class="row">
    <input id="sender" type="number" value="1">
    <input id="text" type="text" placeholder="메시지">
    <button onclick="sendMsg()">보내기</button>
  </div>

  <script>
    // ====== config ======
    const roomId = 1;              // 필요시 서버에서 모델로 내려받아 대체
    const wsEndpoint = '/stomp/chat';     // WebSocket(STOMP) 엔드포인트
    const pubDest    = '/pub/chat/send';  // 서버 @MessageMapping("/chat/send")
    const subDest    = '/sub/room.' + roomId; // 서버 convertAndSend("/sub/room.{id}")

    // ====== state ======
    let stomp = null;
    let subs  = null;

    // ====== utils ======
    function addMessage(sender, content) {
      const box  = document.getElementById('log');
      const line = document.createElement('div');
      line.textContent = '[' + sender + '] ' + content;
      box.appendChild(line);
      box.scrollTop = box.scrollHeight;
    }

    // ====== ws ======
    function connect() {
      const sock = new SockJS(wsEndpoint);
      stomp = Stomp.over(sock);
      stomp.debug = null; // 로그 보고싶으면 주석처리

      stomp.connect({}, onConnected, onWsError);
    }

    function onConnected(frame) {
      addMessage('SYS', 'CONNECTED');

     
      subs = stomp.subscribe(subDest, onMessage);
    }

    function onMessage(msg) {
      // 서버가 JSON 문자열을 push한다는 전제 (그렇지 않으면 그대로 표시)
      let senderId = '', content = '';
      try {
        const d = JSON.parse(msg.body);
        senderId = (d && d.senderId != null) ? d.senderId : '';
        content  = (d && d.chatContent) ? d.chatContent : '';
      } catch (e) {
        content = msg.body || '';
      }
      if (!senderId && !content) {
        addMessage('?', '(empty) ' + (msg.body || ''));
      } else {
        addMessage(senderId || '-', content);
      }
    }

    function onWsError(err) {
      addMessage('SYS', 'WS ERROR');
      // 재연결 원하면 아래 주석 해제
      // setTimeout(connect, 3000);
    }

    // ====== actions ======
    function sendMsg() {
      const textEl   = document.getElementById('text');
      const senderEl = document.getElementById('sender');
      const body     = textEl.value.trim();
      const senderId = parseInt(senderEl.value, 10) || 0;

      if (!body || !stomp || !stomp.connected) return;

      const payload = {
        chatRoomId: roomId,
        messageType: 'TEXT',
        chatContent: body,
        senderId: senderId
      };

      console.log('[SEND]', payload);
      stomp.send(pubDest, {}, JSON.stringify(payload));

      
      
      textEl.value = '';
      textEl.focus();
    }

    // Enter로 보내기
    window.addEventListener('load', () => {
      connect();
      document.getElementById('text').addEventListener('keydown', (e) => {
        if (e.key === 'Enter') sendMsg();
      });
    });
  </script>
</body>
</html>
