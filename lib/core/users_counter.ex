defmodule Core.UsersCounter do
    use GenServer
    @server __MODULE__

    def start_link(), do: GenServer.start_link(__MODULE__, [], [name: @server])

    def add_user(user_name), do: GenServer.call(@server, {:add, user_name})

    def delete_user(user_name), do: GenServer.call(@server, {:delete, user_name})

    def count(), do: GenServer.call(@server, :count)

    def init([]) do
        users = MapSet.new()
        {:ok, users}
    end

    def handle_call({:add, user_name}, _from, users) do
      {:reply, :ok, MapSet.put(users, user_name)}
    end
    
    def handle_call(:count, _from, users) do
        {:reply, MapSet.size(users), users}
    end

    def handle_call({:delete, user_name}, _from, users) do
        {:reply, :ok, MapSet.delete(users, user_name)}
    end
end