defmodule ChatClient do
  def start(name) do
    spawn(fn ->
      {:ok, client_id} = ChatServer.register_client(self(), name)
      IO.puts("#{name} connected with ID #{client_id}")
      chat_loop(name, client_id)
    end)
  end

  defp chat_loop(name, client_id) do
    receive do
      {:message, sender, message} ->
        IO.puts("\n[Message from #{sender}]: #{message}")
    after
      0 -> :ok
    end

    input = IO.gets("#{name} (type message or 'exit'): ")

    case String.trim(input) do
      "exit" ->
        IO.puts("#{name} disconnected.")
        exit(:normal)

      message when message != "" ->
        ChatServer.send_message(client_id, message)

      _ ->
        :ok
    end

    chat_loop(name, client_id)
  end
end
