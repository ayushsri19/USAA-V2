const chatWindow = document.getElementById("chat-window");
const input = document.getElementById("user-input");
const sendBtn = document.getElementById("send-btn");
const status = document.getElementById("status");

function typingIndicatorElement(){
  const el = document.createElement('div');
  el.className = 'msg bot-msg';
  const span = document.createElement('span');
  span.className = 'typing';
  span.innerHTML = '<span class="dot"></span><span class="dot"></span><span class="dot"></span>';
  el.appendChild(span);
  return el;
}

function bubble(text, type){
  const el = document.createElement('div');
  el.className = type === 'user' ? 'msg user-msg' : 'msg bot-msg';
  el.innerText = text;
  return el;
}

function push(el){
  chatWindow.appendChild(el);
  chatWindow.scrollTop = chatWindow.scrollHeight;
}

async function sendMessage(ev){
  if(ev) ev.preventDefault();
  const txt = input.value.trim();
  if(!txt) return;
  push(bubble(txt,'user'));
  input.value = '';
  const typing = typingIndicatorElement();
  push(typing);

  try{
    const res = await fetch('http://127.0.0.1:8000/ask', {
      method: 'POST',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({ text: txt })
    });

    if(!res.ok) throw new Error('Network response not ok');
    const data = await res.json();
    typing.remove();
    push(bubble(data.reply || 'No reply', 'bot'));
    if(status) status.innerText = 'online';
  }catch(err){
    typing.remove();
    push(bubble('Unable to reach backend. Make sure server is running.', 'bot'));
    if(status) status.innerText = 'offline';
    console.error('Send error', err);
  }
}

sendBtn?.addEventListener('click', sendMessage);
document.getElementById('input-form')?.addEventListener('submit', sendMessage);
input?.addEventListener('keydown', e => { if(e.key === 'Enter' && !e.shiftKey){ e.preventDefault(); sendMessage(); } });

// welcome
push(bubble('Hello! I am USSA — ask anything.', 'bot'));
