defmodule YetAnotherChatWeb.PublicChannel do
    use Phoenix.Channel

    def join("public_channel:" <> _, _msg, socket) do
      {:ok, socket}
    end
    
    def handle_in("new message", %{"body" => body}, socket) do
        broadcast! socket, "new message", %{body: body}
        {:noreply, socket}
    end
end