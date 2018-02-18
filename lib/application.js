import "phoenix_html";
import { Application } from "stimulus";
import Turbolinks from "turbolinks";

import socket from "./yet_another_chat/socket";

import ChatController from "./yet_another_chat/chat/js/chat_controller";

Turbolinks.start();
const application = Application.start();
application.register("chat", ChatController);
