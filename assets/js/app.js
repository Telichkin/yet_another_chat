import "phoenix_html";
import { Application } from "stimulus";
import Turbolinks from "turbolinks";

import socket from "./socket";

import ChatRoomController from "./chat_room_controller";

Turbolinks.start();
const application = Application.start();
application.register("chat-room", ChatRoomController);
