defmodule ChatApp do
  def start do
    {:ok, _} = ChatServer.start_link()
    Process.sleep(:infinity)
  end

  def start_alice do
    spawn(fn ->
      ChatClient.start("Alice")
      # Keep the process alive
      Process.sleep(:infinity)
    end)
  end

  def start_bob do
    spawn(fn ->
      ChatClient.start("Bob")
      # Keep the process alive
      Process.sleep(:infinity)
    end)
  end
end
