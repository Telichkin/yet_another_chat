defmodule YetAnotherChat.MessageStorage do
    use GenServer
    @server __MODULE__

    # Client
    def start_link(), do: GenServer.start_link(__MODULE__, [], [name: @server])

    def save(message), do: GenServer.call(@server, {:save, message})

    def get_history() do
        GenServer.call(@server, :history)
    end

    def drop_history() do
        GenServer.call(@server, :drop_history)
    end

    # Server
    def init([]) do
        {:ok, :queue.new()}
    end

    def handle_call({:save, message}, _from, messages) do
        {:reply, :ok, :queue.in(message, messages)}
    end
    
    def handle_call(:history, _from, messages) do
        {:reply, {:ok, :queue.to_list(messages)}, messages}
    end

    def handle_call(:drop_history, _from, _messages) do
        {:reply, :ok, :queue.new()}
    end
    
end