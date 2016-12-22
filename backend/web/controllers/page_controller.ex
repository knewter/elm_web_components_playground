defmodule Backend.PageController do
  use Backend.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
