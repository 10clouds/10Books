defmodule LibTen.Products.EmailsTest do
  use LibTen.DataCase
  use Bamboo.Test

  import LibTen.Factory

  test "shit should work" do
    [subscriber1, subscriber2] = insert_pair(:user)
    product = insert(:product, %{
      status: "IN_LIBRARY",
      used_by: %{
        user: insert(:user),
        inserted_at: ~N[2000-01-01 00:01:00.000000],
        return_subscribers: [subscriber1.id, subscriber2.id]
      }
    })

    IO.inspect LibTen.Products.Emails.request_product_return(product)
    assert 1 == 1
  end
end
