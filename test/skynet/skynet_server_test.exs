defmodule Skynet.ServerTest do
  use ExUnit.Case

  setup do
    on_exit(fn ->
      for terminator <- Skynet.Server.inventory do
        Skynet.Server.terminate(terminator)
      end
    end)
    :ok
  end

  test "retrieves an empty inventory" do
    assert Skynet.Server.inventory() == []
  end

  test "spawns a terminator" do
    %{id: id, pid: pid} = Skynet.Server.spawn()

    assert is_integer(id)
    assert is_pid(pid)
    assert [id] == Skynet.Server.inventory()
  end

  test "kills a terminator by id" do
    %{id: id, pid: _pid} = Skynet.Server.spawn()

    assert [id] == Skynet.Server.inventory()
    assert {:ok, id} == Skynet.Server.terminate(id)
    assert [] == Skynet.Server.inventory()
  end
end
