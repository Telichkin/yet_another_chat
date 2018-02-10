defmodule YetAnotherChat.MessageStorageTest do
    use ExUnit.Case
    alias YetAnotherChat.MessageStorage

    setup do
        case MessageStorage.start_link() do
            {:ok, _} ->
                 :ok
            {:error, {:already_started, _}} ->
                GenServer.stop(MessageStorage)
                MessageStorage.start_link()
                :ok
        end
    end

    test "can save one message" do
        :ok = MessageStorage.save("test message")
        {:ok, ["test message"]} = MessageStorage.get_history()
    end

    test "can save many messages" do
        :ok = MessageStorage.save("message 1")
        :ok = MessageStorage.save("message 2")
        
        {:ok, ["message 1", "message 2"]} = MessageStorage.get_history()
    end

    test "drop all messages" do
        :ok = MessageStorage.save("message")

        :ok = MessageStorage.drop_history()
        
        {:ok, []} = MessageStorage.get_history()
    end
end