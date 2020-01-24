defmodule Skynet.Terminator do
  @moduledoc """
  The original killing machines. Living tissue
  over metal endoskeleton.

  The Skynet.Terminator process mimics a terminator
  and will attempt to reproduce itself every 5 seconds
  with a 20% success rate.

  Every 10 seconds, Sarah Connor will attempt to kill
  the terminator with a 25% success rate.
  """

  require Logger
  use GenServer

  def start_link(id) do
    GenServer.start_link(__MODULE__, id, name: :"t_#{id}")
  end

  def init(id) do
    :timer.send_interval(5_000, :reproduce)
    :timer.send_interval(10_000, :terminate)

    {:ok, %{id: id}}
  end

  defmacro possibly(rate, do: block) do
    quote do
      case :rand.uniform() < unquote(rate) do
        true -> unquote(block)
        false -> nil
      end
    end
  end

  def handle_info(:reproduce, %{id: id} = state) do
    possibly(0.20) do
      Logger.info("terminator #{id} reproducing")
      Skynet.Server.spawn()
    end

    {:noreply, state}
  end

  def handle_info(:terminate, %{id: id} = state) do
    possibly(0.25) do
      Logger.info("i'll be back")
      Skynet.Server.terminate(id)
    end

    {:noreply, state}
  end

  def handle_info(_, state), do: {:noreply, state}
end
