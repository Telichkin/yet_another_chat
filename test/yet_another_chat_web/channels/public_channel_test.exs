defmodule YetAnotherChatWeb.PublicChannelTest do
    use YetAnotherChatWeb.ChannelCase
    alias YetAnotherChatWeb.PublicChannel
    alias YetAnotherChat.MessageStorage

    setup do
        {:ok, _, socket} = 
            socket(nil, %{user: "Roman"})
            |> subscribe_and_join(PublicChannel, "public_channel:lobby")
        :ok = MessageStorage.drop_history()
        {:ok, %{socket: socket}}
    end

    test "can send message to the public channel", %{socket: socket} do
        push(socket, "new message", %{"text" => "Hello, World!"})

        assert_push("new message", %{"html" => html})
        assert html =~ "Roman"
        assert html =~ "Hello, World"
        assert html =~ "<div class=\"message-container my-message\">"
    end

    test "save broadcasted messages", %{socket: socket, conn: conn} do
        push(socket, "new message", %{"text" => "First Message"})
        push(socket, "new message", %{"text" => "Second Message"})

        assert_broadcast("new message", _)
        assert_broadcast("new message", _)        

        conn = get(conn, "/")

        assert html_response(conn, 200) =~ "First Message"
        assert html_response(conn, 200) =~ "Second Message"        
    end
end