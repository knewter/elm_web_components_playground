defmodule TimeTrackerBackend.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :username, :string
      add :password, :string
      add :is_superuser, :boolean, default: false

      timestamps()
    end

    create unique_index(:users, :email)
  end
end
