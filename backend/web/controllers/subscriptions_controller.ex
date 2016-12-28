defmodule Backend.SubscriptionsController do
  use Backend.Web, :controller

  def create(conn, %{"token" => token, "plan" => plan, "email" => email}) do
    # NOTE: I'm not under the impression that this is fantastically elegant code
    # :)
    # TODO: Associate customer id with user
    {:ok, customer} =
      Stripe.Customer.create(%{
        email: email
      })

    # TODO: Associate card id with user
    {:ok, card} =
      Stripe.Card.create(:customer, customer.id, token)

    # TODO: Associate subscription id with user
    {:ok, subscription} =
      Stripe.Subscription.create(%{
        customer: customer.id,
        plan: plan,
        quantity: 1,
      })
    json conn, subscription
  end
end
