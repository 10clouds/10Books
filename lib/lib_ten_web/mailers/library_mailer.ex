defmodule LibTenWeb.LibraryMailer do
  use Bamboo.Phoenix, view: LibTenWeb.EmailView

  alias LibTen.Products.Product
  alias LibTen.Accounts.User

  def product_has_been_returned(%Product{} = product, %User{} =user) do
    new_email
    |> to(user.email)
    |> from("noreply@books.10clouds.com")
    |> subject("Test")
    |> text_body("test")
  end
end
