defmodule Web.PublicChannelTest do
    use Web.ChannelCase, async: false
    alias Web.PublicChannel
    alias Core.MessageStorage

    setup do
        :ok = MessageStorage.drop_history()        
        {:ok, _, socket} = 
            socket(nil, %{user: "Roman"})
            |> subscribe_and_join(PublicChannel, "public_channel:lobby")
        
        assert_push("history", %{"html" => _})        
        {:ok, %{socket: socket}}
    end

    test "update number of members on join" do
        socket(nil, %{user: "Julia"})
        |> subscribe_and_join(PublicChannel, "public_channel:lobby")

        assert_broadcast("members", %{"count" => 2})
    end

    test "upload chat history on join", %{socket: socket} do
        push(socket, "new message", %{"text" => "First"})
        push(socket, "new message", %{"text" => "Second"})
        assert_broadcast("new message", _)
        assert_broadcast("new message", _)

        socket(nil, %{user: "Julia"})
        |> subscribe_and_join(PublicChannel, "public_channel:lobby")

        assert_push("history", %{"html" => html})
        assert html =~ "First"
        assert html =~ "Second"        
    end

    test "update number of members on disconnect" do
        {:ok, _, socket} = socket(nil, %{user: "Julia"})
        |> subscribe_and_join(PublicChannel, "public_channel:lobby")
        assert_broadcast("members", %{"count" => 2})        

        leave(socket)

        assert_broadcast("members", %{"count" => 1})        
    end

    test "can send message to the public channel", %{socket: socket} do
        push(socket, "new message", %{"text" => "Hello, World!"})

        assert_push("new message", %{"html" => html})
        assert html =~ "Roman"
        assert html =~ "Hello, World"
        assert html =~ "<div class=\"message-container my-message\">"
    end
end