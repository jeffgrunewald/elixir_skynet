defmodule SkynetWeb.TerminatorLiveViewTest do
  use ExUnit.Case, async: true
  use Phoenix.ConnTest
  import Phoenix.LiveViewTest
  @endpoint SkynetWeb.Endpoint

  setup config do
    conn = Plug.Test.init_test_session(build_conn(), config[:plug_session] || %{})
    {:ok, conn: conn}
  end

  test "connected mount", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")
    assert html =~ "<h2>Units in operation</h2>"
  end

  test "displays spawned unit", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    assert render_submit(view, "spawn") =~
             ~s(<div class="terminator"><button data-confirm="Confirm termination" data-method="get" data-to="#" phx-click="terminate")
  end

  test "removes terminator", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    Skynet.Server.spawn()
    [id | _] = Skynet.Server.inventory()
    button_fragment = ~s(phx-value-unit="#{id}">#{id}</button>)
    assert render(view) =~ button_fragment

    assert render_click(view, "terminate", %{"unit" => "#{id}"}) != button_fragment
  end
end
