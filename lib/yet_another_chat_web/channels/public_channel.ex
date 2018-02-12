defmodule YetAnotherChatWeb.PublicChannel do
    use Phoenix.Channel
    alias YetAnotherChatWeb.PageView
    alias YetAnotherChat.MessageStorage
    alias YetAnotherChat.UsersCounter
    import Phoenix.View, only: [render_to_string: 3]
    
    intercept ["new message"]

    def join("public_channel:" <> _, _msg, socket) do
        UsersCounter.add_user(socket.assigns.user)
        send(self(), :after_join)
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
        render_to_string(
            PageView,
            "messages.html", 
            %{messages: [Map.put(message, "recipient", recipient)]}
        )
    end

    def handle_info(:after_join, socket) do
        {:ok, messages} = MessageStorage.get_history()
        history = messages
            |> Enum.reduce([], fn(m, acc) -> [Map.put(m, "recipient", socket.assigns.user) | acc] end)
            |> Enum.reverse()

        payload = %{"html" => render_to_string(PageView, "messages.html", %{messages: history})}
        push(socket, "history", payload)
        broadcast!(socket, "members", %{"count" => UsersCounter.count()})
        {:noreply, socket}
    end
    
    def terminate(_reason, socket) do
        UsersCounter.delete_user(socket.assigns.user)
        broadcast!(socket, "members", %{"count" => UsersCounter.count()})
    end
end