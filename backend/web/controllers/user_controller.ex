defmodule Backend.UserController do
  use Backend.Web, :controller
  alias Backend.{User, Repo, ChangesetView}

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
          |> Guardian.Plug.api_sign_in(user)
          |> put_status(:created)
          |> put_resp_header("location", user_path(conn, :show, user))
          |> add_jwt_header()
          |> render("show.json", user: user)
      {:error, changeset} ->
        conn
          |> put_status(:unprocessable_entity)
          |> render(ChangesetView, "error.json", changeset: changeset)
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

