defmodule LibTen.Factory do
  use ExMachina.Ecto, repo: LibTen.Repo

  def user_factory do
    %LibTen.Accounts.User{
      name: "Ruslan Savenok",
      avatar_url: "http://google.com/test_avatar_url.png",
      email: sequence(:email, &"email-#{&1}@10clouds.com")
    }
  end

  def product_factory do
    %LibTen.Products.Product{
      author: sequence(:author, &"some author #{&1}"),
      title: sequence(:title, &"some title #{&1}"),
      url: sequence(:url, &"http://google-#{&1}.com")
    }
  end

  def category_factory do
    {text_color, background_color} =
      LibTen.Categories.Category.get_available_color_for_category()

    %LibTen.Categories.Category{
      name: sequence(:name, &"category-#{&1}"),
      text_color: text_color,
      background_color: background_color
    }
  end
end
