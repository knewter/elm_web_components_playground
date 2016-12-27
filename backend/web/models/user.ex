defmodule Backend.User do
  @moduledoc """
  Users of our system.
  """

  use Backend.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :username, :string
    field :password, :string
    field :is_superuser, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :name,
      :email,
      :username,
      :password,
      :is_superuser,
    ])
    |> validate_required([
      :name,
      :email,
      :username,
      :password,
      :is_superuser,
    ])
    |> unique_constraint(:name)
  end
end
