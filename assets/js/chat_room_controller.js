import { Controller } from "stimulus";
import Turbolinks from "turbolinks";
import channel from "./chat";

export default class extends Controller {
    static targets = [ "message", "allMessages" ];

    connect() {
        this.listenNewMessages();
        this.scrollToLastMessage();     
    }

    listenNewMessages() {
        channel.on("new message", ({html: htmlMessage}) => {
            this.appendMessage(htmlMessage);
            this.scrollToLastMessage();
        });
    }
    
    appendMessage(htmlMessage) {
        let tempDiv = document.createElement("div");
        tempDiv.innerHTML = htmlMessage.trim();
        this.allMessagesTarget.appendChild(tempDiv.firstChild);
    }

    sendMessage(event) {
        const enterPressed = event.keyCode === 13;
        if (enterPressed) {
            event.preventDefault();
            channel.push("new message", {text: this.message});
            this.message = "";
            this.scrollToLastMessage();
        }
    }
    
    scrollToLastMessage() {
        this.allMessagesTarget.scrollTop = this.allMessagesTarget.scrollHeight;        
    }

    get message() {
        return this.messageTarget.innerText;
    }

    set message(text) {
        this.messageTarget.innerText = text;
    }
}