defmodule LibTen.Products.Emails do
  import Bamboo.Email

  use Bamboo.Phoenix, view: LibTenWeb.ProductsView

  alias LibTen.Products.Product
  alias LibTen.Accounts.User

  @default_from "books@10clouds.com"
  @default_endpoint LibTenWeb.Endpoint

  def product_has_been_returned(%Product{} = product, %User{} = user) do
    new_email()
    |> to(user.email)
    |> from(@default_from)
    |> subject("📚 \"#{product.title}\" is now available")
    |> render("product_has_been_returned.html", %{
      product: product,
      conn: @default_endpoint
    })
  end

  def request_product_return(%Product{} = product) do
    new_email()
    |> to(product.used_by.user.email)
    |> from(@default_from)
    |> subject("🚨🚨 Please return \"#{product.title}\" 🚨🚨")
    |> render("request_product_return.html", %{
      product: product,
      return_subscribers_count: length(product.used_by.return_subscribers)
    })
  end
end
