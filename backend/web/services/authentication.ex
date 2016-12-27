defmodule Backend.Services.Authentication do
  @moduledoc """
  A module for handling authentication logic.
  """

  alias Backend.{User, Repo}
  import Ecto.Query

  @doc """
  Verify login acceptability.
  """
  @spec find_and_confirm_password(String.t, String.t) :: {:ok, User.t} | {:error, String.t}
  def find_and_confirm_password(email, password) do
    found_user =
      User
        |> where([u], u.email == ^email)
        |> Repo.all
        |> hd

    case found_user do
      nil -> {:error, "No such user"}
      user ->
        # lol don't store plaintext passwords ok?
        # imagine this is checking a hashed pw
        case user.password == password do
          true ->
            {:ok, user}
          false ->
            {:error, "No such user"}
        end
    end
  end
end
