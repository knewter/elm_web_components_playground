defmodule Backend.SubscriptionsController do
  use Backend.Web, :controller
  alias Stripe.{Customer, Card, Subscription}

  def create(conn, %{"token" => token, "plan" => plan, "email" => email}) do
    # NOTE: I'm not under the impression that this is fantastically elegant code
    # :)
    {:ok, customer} =
      Customer.create(%{
        email: email
      })
    {:ok, card} =
      Card.create(:customer, customer.id, token)
    {:ok, subscription} =
      Subscription.create(%{
        customer: customer.id,
        plan: plan,
        quantity: 1,
      })
    json conn, subscription
  end
end
