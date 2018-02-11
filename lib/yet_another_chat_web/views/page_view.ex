defmodule YetAnotherChatWeb.PageView do
  use YetAnotherChatWeb, :view

  def put_is_author_field(message, conn) do
    Map.put(message, "is_author", conn.assigns.user === message["author"])
  end
end