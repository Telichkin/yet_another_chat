defmodule YetAnotherChatWeb.PageView do
  use YetAnotherChatWeb, :view

  def message_tag(message, conn) do
    render("message.html", message: Map.put(message, "recipient", conn.assigns.user))
  end
end