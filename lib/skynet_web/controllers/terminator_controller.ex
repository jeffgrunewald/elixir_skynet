defmodule SkynetWeb.TerminatorController do
  use SkynetWeb, :controller

  def index(conn, _params) do
    terminators = Skynet.Server.inventory()

    json(conn, %{active_units: terminators})
  end

  def create(conn, _params) do
    %{id: id, pid: _pid} = Skynet.Server.spawn()

    conn
    |> put_status(:created)
    |> json(%{unit: id, result: "activated"})
  end

  def delete(conn, %{"id" => id}) do
    response =
      id
      |> String.to_integer()
      |> Skynet.Server.terminate()
      |> case do
        {:ok, :invalid_unit} -> %{unit: nil, result: "enoent"}
        {:ok, id} -> %{unit: id, result: "terminated"}
      end

    json(conn, response)
  end
end
