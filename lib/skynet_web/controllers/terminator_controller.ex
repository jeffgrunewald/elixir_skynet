defmodule SkynetWeb.TerminatorController do
  use SkynetWeb, :controller

  def index(conn, _params) do
    terminators = Skynet.Server.inventory()

    json(conn, %{active_units: terminators})
  end

  def create(conn, _params) do
    %{id: id, pid: _pid} = Skynet.Server.spawn()

    json(conn, %{result: "unit #{id} online"})
  end

  def delete(conn, %{"id" => id}) do
    response =
      id
      |> String.to_integer()
      |> Skynet.Server.terminate()
      |> case do
        {:ok, :invalid_unit} -> "requested unit does not exist"
        {:ok, id} -> "unit #{id} terminated"
      end

    json(conn, %{result: response})
  end
end
