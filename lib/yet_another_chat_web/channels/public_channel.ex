defmodule YetAnotherChatWeb.PublicChannel do
    use Phoenix.Channel
    alias YetAnotherChat.MessageStorage
    alias YetAnotherChatWeb.PageView
    import Phoenix.View, only: [render_to_string: 3]

    def join("public_channel:" <> _, _msg, socket) do
      {:ok, socket}
    end
    
    def handle_in("new message", %{"text" => text}, socket) do
        now = DateTime.utc_now() |> DateTime.to_iso8601()
        message = %{"text" => text, "author" => socket.assigns.user, "time" => now}
        MessageStorage.save(message)
        
        broadcast!(socket, "new message", %{"html" => render_to_string(PageView, "message.html", %{message: message})})
        {:noreply, socket}
    end
end