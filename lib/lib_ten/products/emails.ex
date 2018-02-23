defmodule LibTen.Products.Emails do
  import Bamboo.Email

  alias LibTen.Products.Product
  alias LibTen.Accounts.User

  def product_has_been_returned(%Product{} = product, %User{} = user) do
    new_email()
    |> to(user.email)
    |> from("noreply@books.10clouds.com")
    |> subject("10Books: #{product.title} is now available")
    |> text_body(
      """
      Hey there,

      #{product.title} has been returned to the library.
      """
    )
  end
end
