import socket from "./socket"

let channel = socket.channel("public_channel:lobby", {})

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

let messageInput = document.querySelector("div.chat-room-input");
messageInput.addEventListener("keypress", (event) => {
  const enterPressed = event.keyCode === 13;
  if (enterPressed) {
    event.preventDefault();  
    channel.push("new message", {text: messageInput.innerText});
    messageInput.innerText = "";
  }
})

channel.on("new message", (message) => {
    location.reload();
})

export default channel;