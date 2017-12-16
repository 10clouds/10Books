defmodule LibTen.Factory do
  use ExMachina.Ecto, repo: LibTen.Repo

  def user_factory do
    %LibTen.Accounts.User{
      name: "Ruslan Savenok",
      email: sequence(:email, &"email-#{&1}@example.com")
    }
  end

  def product_factory do
    %LibTen.Products.Product{
      author: "some author",
      status: "IN_LIBRARY",
      title: sequence(:title, &"some title #{&1}"),
      url: "http://google.com"
    }
  end

  def category_factory do
    %LibTen.Categories.Category{
      name: sequence(:name, &"category-#{&1}")
    }
  end
end
