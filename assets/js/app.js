import "phoenix_html";
import { Application } from "stimulus";
import Turbolinks from "turbolinks";

import socket from "./socket";

import ChatController from "./chat_controller";

Turbolinks.start();
const application = Application.start();
application.register("chat", ChatController);
