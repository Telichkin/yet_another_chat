defmodule YetAnotherChatWeb.PageController do
  use YetAnotherChatWeb, :controller
  alias YetAnotherChat.MessageStorage

  def index(conn, _params) do
    {:ok, messages} = MessageStorage.get_history()
    render(conn, :index, %{messages: messages})
  end
end
