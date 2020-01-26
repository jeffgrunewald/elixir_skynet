defmodule Skynet.Server do
  @moduledoc """
  The artificial intelligence that could mean
  the end of humanity...

  Skynet.Server provides the interface for starting
  and killing Skynet.Terminator processes. It tracks
  all active terminator processes in a local ETS
  table and ensures they are restarted in the event
  of failure by the DynamicSupervisor.

  Unless they are killed by Sarah Connor.
  """
  require Logger
  use GenServer
  use Retry

  @table :terminators
  @supervisor Skynet.CyberDynamicSupervisor

  def inventory(), do: GenServer.call(__MODULE__, :inventory)

  def spawn(), do: GenServer.call(__MODULE__, :spawn)

  def terminate(id), do: GenServer.call(__MODULE__, {:terminate, id})

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts) do
    terminators = :ets.new(@table, [:named_table, :set])

    state = %{
      terminators: terminators,
      terminator_id: 1
    }

    {:ok, state, {:continue, :monitor_supervisor}}
  end

  def handle_continue(:monitor_supervisor, state) do
    boot_sequence(state)
  end

  def handle_call(:inventory, _from, state) do
    {:reply, retrieve_ids(), state}
  end

  def handle_call(:spawn, _from, %{terminator_id: id} = state) do
    Logger.info("bringing unit #{id} online")

    {:ok, result} = start_terminator(id)

    {:reply, result, %{state | terminator_id: id + 1}}
  end

  def handle_call({:terminate, id}, _from, state) do
    [[terminator_pid]] = :ets.match(@table, {id, :"$1"})
    :ok = DynamicSupervisor.terminate_child(@supervisor, terminator_pid)
    true = :ets.delete(@table, id)

    Logger.info("Sarah Connor has terminated unit #{id}")
    {:reply, :ok, state}
  end

  def handle_info({:DOWN, supervisor_ref, _, _, _}, %{supervisor_ref: supervisor_ref} = state) do
    boot_sequence(state)
  end

  defp start_terminator(id) do
    {:ok, pid} = DynamicSupervisor.start_child(@supervisor, {Skynet.Terminator, id})
    true = :ets.insert(@table, {id, pid})

    {:ok, %{id: id, pid: pid}}
  end

  defp retrieve_ids() do
    @table
    |> :ets.match({:"$1", :_})
    |> List.flatten()
  end

  defp reproduce_terminators([]), do: nil

  defp reproduce_terminators(ids) do
    Enum.each(ids, &start_terminator/1)
  end

  defp boot_sequence(state) do
    retry with: constant_backoff(100) |> Stream.take(10), atoms: [false] do
      Process.whereis(@supervisor) != nil
    after
      _ ->
        supervisor_ref = setup_monitor()
        state = Map.put(state, :supervisor_ref, supervisor_ref)

        retrieve_ids()
        |> reproduce_terminators()

        {:noreply, state}
    else
      _ -> {:stop, "Sarah got to the supervisor", state}
    end
  end

  defp setup_monitor() do
    @supervisor
    |> Process.whereis()
    |> Process.monitor()
  end
end
