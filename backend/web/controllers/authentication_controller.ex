defmodule Backend.AuthenticationController do
  use Backend.Web, :controller
  alias Backend.{User, Services.Authentication}

  def create(conn, %{"email" => email, "password" => password}) do
    case Authentication.find_and_confirm_password(email, password) do
      {:ok, user} ->
         conn
           |> Guardian.Plug.api_sign_in(user)
           |> add_jwt_header()
           |> put_status(200)
           |> text("")
      {:error, reason} ->
        conn
          |> put_status(401)
          |> render("error.json", message: "Could not login: #{reason}")
    end
  end

  defp add_jwt_header(conn) do
     jwt = Guardian.Plug.current_token(conn)
     {:ok, claims} = Guardian.Plug.claims(conn)
     exp = Map.get(claims, "exp")

     conn
       |> put_resp_header("authorization", "Bearer #{jwt}")
       |> put_resp_header("x-expires", "#{exp}")
  end
end
