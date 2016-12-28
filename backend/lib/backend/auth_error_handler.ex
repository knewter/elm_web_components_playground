defmodule Backend.AuthErrorHandler do
  @moduledoc """
  Our Guardian Auth Error Handler.
  """
  import Plug.Conn
  import Phoenix.Controller, only: [{:json, 2}]

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> json("Authentication required")
  end
end
