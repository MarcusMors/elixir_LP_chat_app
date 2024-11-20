defmodule ChatServer do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, %{clients: %{}, messages: []}}
  end

  def register_client(pid, name) do
    GenServer.call(__MODULE__, {:register, pid, name})
  end

  def send_message(sender, message) do
    GenServer.call(__MODULE__, {:broadcast, sender, message})
  end

  def handle_call({:register, client_pid, name}, _from, state) do
    client_id = map_size(state.clients) + 1
    new_clients = Map.put(state.clients, client_id, {client_pid, name})
    {:reply, {:ok, client_id}, %{state | clients: new_clients}}
  end

  def handle_call({:broadcast, sender, message}, _from, state) do
    {_, sender_name} = state.clients[sender]

    Enum.each(state.clients, fn {id, {pid, name}} ->
      if id != sender do
        send(pid, {:message, sender_name, message})
      end
    end)

    {:reply, :ok, %{state | messages: [message | state.messages]}}
  end
end
