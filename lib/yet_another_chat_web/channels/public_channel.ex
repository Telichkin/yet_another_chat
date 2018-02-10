defmodule YetAnotherChatWeb.PublicChannel do
    use Phoenix.Channel
    alias YetAnotherChat.MessageStorage

    def join("public_channel:" <> _, _msg, socket) do
      {:ok, socket}
    end
    
    def handle_in("new message", %{"text" => text}, socket) do
        now = DateTime.utc_now() |> DateTime.to_iso8601()
        message = %{"text" => text, "author" => socket.assigns.user, "time" => now}
        MessageStorage.save(message)

        broadcast!(socket, "new message", message)
        {:noreply, socket}
    end
end