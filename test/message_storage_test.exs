defmodule Core.MessageStorageTest do
    use ExUnit.Case
    alias Core.MessageStorage

    setup do
        case MessageStorage.start_link() do
            {:ok, _} -> nil
            {:error, {:already_started, _}} ->
                GenServer.stop(MessageStorage)
                MessageStorage.start_link()
        end
        MessageStorage.drop_history()

        on_exit fn -> 
            MessageStorage.start_link()
            MessageStorage.drop_history()
            GenServer.stop(MessageStorage)
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

    test "messages are available after storage restart" do
        :ok = MessageStorage.save("message 1")
        :ok = MessageStorage.save("message 2")
        :ok = GenServer.stop(MessageStorage)
        MessageStorage.start_link()
        
        {:ok, ["message 1", "message 2"]} = MessageStorage.get_history()
    end
end