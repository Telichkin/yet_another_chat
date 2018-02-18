import { Controller } from "stimulus";
import channel from "./public_chat";

export default class extends Controller {
    static targets = [ "message", "allMessages", "membersCount", "messageDate" ];

    connect() {
        this.listenMessageHistrory();
        this.listenNewMessages();
        this.listenMembersCount();
        this.scrollToLastMessage();     
    }

    listenNewMessages() {
        channel.on("new message", ({html: htmlMessage}) => {
            this.appendMessage(htmlMessage);
            this.lastMessageDate = this.normalizeDateString(this.lastMessageDate)
            this.scrollToLastMessage();
        });
    }
    
    get lastMessageDate() {
        return this.messageDateTargets.slice(-1).pop().innerText;
    }

    set lastMessageDate(dateString) {
        this.messageDateTargets.slice(-1).pop().innerText = dateString;
    }

    listenMessageHistrory() {
        channel.on("history", ({html: htmlHistory}) => {
            this.allMessagesTarget.innerHTML = "";
            this.appendMessage(htmlHistory);
            this.messageDateTargets.forEach((date) => {
                date.innerText = this.normalizeDateString(date.innerText);
            })
            this.scrollToLastMessage();
        });
    }

    normalizeDateString(dateString) {
        return new Date(dateString).toLocaleDateString("en-GB", {
            year: "numeric", month: "2-digit", day: "2-digit", 
            hour: "2-digit", minute: "2-digit"
        })
    }

    appendMessage(htmlMessage) {
        let tempDiv = document.createElement("div");
        tempDiv.innerHTML = htmlMessage.trim();
        for (let child of tempDiv.childNodes) {
            this.allMessagesTarget.appendChild(child);
        }
    }

    sendMessage(event) {
        const enterPressed = event.keyCode === 13;
        const shiftNotPressed = !event.shiftKey;
        if (enterPressed && shiftNotPressed) {
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
        return this.messageTarget.innerHTML;
    }

    set message(text) {
        this.messageTarget.innerText = text;
    }

    listenMembersCount() {
        channel.on("members", ({count: count}) => {
            this.membersCount = count
        })
    }

    set membersCount(count) {
        this.membersCountTargets.forEach(membersCount => {
            membersCount.innerText = count > 1 ? `${count} members` : `only you`
        });
    }
}