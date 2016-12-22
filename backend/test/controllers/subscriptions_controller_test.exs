defmodule Backend.SubscriptionsControllerTest do
  use Backend.ConnCase

  test "creating a subscription", %{conn: conn} do
    {:ok, token} =
      Stripe.request(:post, "tokens", %{
        card: %{
          number: "4111111111111111",
          exp_month: "11",
          exp_year: "21",
          cvc: "111",
        }
      }, %{}, [])
    conn =
      post(
        conn,
        "/api/subscriptions",
        %{
          "token" => token["id"],
          "plan" => "basic",
          "email" => "foo@example.com"
        }
      )
    result = json_response(conn, 200)
    assert %{"id" =>  _} = result
  end
end
