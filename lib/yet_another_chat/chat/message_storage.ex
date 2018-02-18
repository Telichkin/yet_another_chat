defmodule YetAnotherChat.MessageStorage do
    use GenServer
    @server __MODULE__

    # Client
    def start_link(), do: GenServer.start_link(__MODULE__, [], [name: @server])

    def save(message), do: GenServer.call(@server, {:save, message})

    def get_history(), do: GenServer.call(@server, :history)

    def drop_history(), do: GenServer.call(@server, :drop_history)

    # Server
    def init([]) do
        {:ok, name} = :dets.open_file(:messages, [access: :read_write, type: :bag])
        {:ok, name}
    end

    def handle_call({:save, message}, _from, messages) do
        :dets.insert(messages, {message})
        {:reply, :ok, messages}
    end
    
    def handle_call(:history, _from, messages) do
        history = 
            :dets.match_object(messages, :"_")
            |> Enum.reduce([], fn({message}, acc) -> [message | acc] end)
        {:reply, {:ok, history}, messages}
    end

    def handle_call(:drop_history, _from, messages) do
        :dets.delete_all_objects(messages)
        {:reply, :ok, messages}
    end
    
end