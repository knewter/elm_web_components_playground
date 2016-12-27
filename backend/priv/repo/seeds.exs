# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Backend.Repo.insert!(%Backend.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Backend.{Repo, User}

user = fn(email, password) ->
  %User{
    name: email,
    email: email,
    username: email,
    password: password,
  }
end

admin = fn(email, password) ->
  user.(email, password)
    |> Map.put(:is_superuser, true)
end

[
  admin.("josh@dailydrip.com", "password")
] |> Enum.map(&Repo.insert!/1)


