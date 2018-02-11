defmodule YetAnotherChatWeb.PublicChannel do
    use Phoenix.Channel
    alias YetAnotherChatWeb.PageView
    alias YetAnotherChat.MessageStorage
    import Phoenix.View, only: [render_to_string: 3]
    
    intercept ["new message"]

    def join("public_channel:" <> _, _msg, socket) do
      {:ok, socket}
    end
    
    def handle_in("new message", %{"text" => text}, socket) do
        message = create_message(socket, text)
        MessageStorage.save(message)
        
        broadcast!(socket, "new message", %{"author_html" => message_to_html(message, is_author: true),
                                            "others_html" => message_to_html(message, is_author: false),
                                            "author_name" => socket.assigns.user})
        {:noreply, socket}
    end

    def handle_out("new message" = event, message, socket) do
        case socket.assigns.user === message["author_name"] do
            true ->     
                push(socket, event, %{"html" => message["author_html"]})
            false ->                
                push(socket, event, %{"html" => message["others_html"]})
        end
        {:noreply, socket}
    end

    defp create_message(socket, text) do
        now = DateTime.utc_now() |> DateTime.to_iso8601()
        %{"text" => text, "author" => socket.assigns.user, "time" => now}
    end

    defp message_to_html(message, is_author: is_author) do
        recipient = case is_author do
            true -> message["author"]
            false -> nil
        end
        render_to_string(PageView, "message.html", %{message: Map.put(message, "recipient", recipient)})
    end
end