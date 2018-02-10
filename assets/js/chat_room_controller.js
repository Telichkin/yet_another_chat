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
        channel.on("new message", () => Turbolinks.visit("/"));
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