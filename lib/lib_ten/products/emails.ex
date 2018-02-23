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

  def request_product_return(%Product{} = product) do
    return_subscribers_count = length(product.used_by.return_subscribers)

    new_email()
    |> to(product.used_by.user.email)
    |> from("noreply@books.10clouds.com")
    |> subject("10Books: 🚨🚨 Please return #{product.title}")
    |> text_body(
      """
      Hey there,

      You took "#{product.title}" #{Timex.from_now(product.used_by.inserted_at)}

      #{if return_subscribers_count > 1,
          do: "#{return_subscribers_count} are people waiting",
          else: ""}

      Please return it ASAP
      """
    )
  end
end
