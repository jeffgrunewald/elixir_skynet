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
    case Skynet.Server.terminate(id) do
      :ok -> json(conn, %{result: "unit #{id} terminated"})
      _ -> send_resp(conn, 400, "unable to satisfy your request")
    end
  end
end
