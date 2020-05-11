defmodule Skynet.TerminatorTest do
  use ExUnit.Case
  use Placebo

  setup do
    allow(Skynet.Terminator.handle_info(any(), %{id: 1}),
      return: {:noreply, %{id: 1}},
      meck_options: [:passthrough]
    )

    {:ok, _pid} = Skynet.Terminator.start_link(1)

    :ok
  end

  test "attempts to reproduce itself" do
    Process.sleep(6_000)

    assert_called(Skynet.Terminator.handle_info(:reproduce, %{id: 1}))
  end

  test "sarah conner attempts to kill it" do
    Process.sleep(11_000)

    assert_called(Skynet.Terminator.handle_info(:terminate, %{id: 1}))
  end
end
