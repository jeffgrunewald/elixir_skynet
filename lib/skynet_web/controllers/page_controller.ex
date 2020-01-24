defmodule SkynetWeb.PageController do
  use SkynetWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
