defmodule SkynetWeb.TerminatorControllerTest do
  use SkynetWeb.ConnCase


  setup %{conn: conn} do
    for terminator <- Skynet.Server.inventory do
      Skynet.Server.terminate(terminator)
    end

    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "GET /api/terminators", %{conn: conn} do
    conn = get(conn, "/api/terminators")
    assert response(conn, 200) == %{active_units: []} |> Jason.encode!()
  end

  test "POST /api/terminators", %{conn: conn} do
    conn = post(conn, "/api/terminators")
    assert %{"unit" => id, "result" => result} = response(conn, 201) |> Jason.decode!()
    assert result == "activated"
    assert is_integer(id)

    conn = get(conn, "/api/terminators")
    assert %{"active_units" => units} = response(conn, 200) |> Jason.decode!()
    assert Enum.count(units) > 0
  end

  test "DELETE /api/terminators/:id", %{conn: conn} do
    Skynet.Server.spawn()
    [id | _] = Skynet.Server.inventory()

    conn = get(conn, "/api/terminators")
    assert %{"active_units" => units} = response(conn, 200) |> Jason.decode!()
    assert Enum.count(units) > 0

    conn = delete(conn, "/api/terminators/#{id}")
    assert %{"unit" => id, "result" => result} = response(conn, 200) |> Jason.decode!()
    assert result == "terminated"
    assert is_integer(id)


    conn = get(conn, "/api/terminators")
    assert %{"active_units" => []} = response(conn, 200) |> Jason.decode!()
  end
end
