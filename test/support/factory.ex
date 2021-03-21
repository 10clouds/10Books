defmodule LibTen.Factory do
  use ExMachina.Ecto, repo: LibTen.Repo

  def user_factory do
    %LibTen.Accounts.User{
      name: "Ruslan Savenok",
      avatar_url: "http://google.com/test_avatar_url.png",
      email: sequence(:email, &"email-#{&1}@10clouds.com"),
      google_uid: "12345"
    }
  end

  def product_factory do
    %LibTen.Products.Product{
      author: sequence(:author, &"some author #{&1}"),
      title: sequence(:title, &"some title #{&1}"),
      url: sequence(:url, &"http://google-#{&1}.com")
    }
  end

  def product_use_factory do
    %LibTen.Products.ProductUse{}
  end

  def category_factory do
    {text_color, background_color} = LibTen.Categories.Category.get_available_color()

    %LibTen.Categories.Category{
      name: sequence(:name, &"category-#{&1}"),
      text_color: text_color,
      background_color: background_color
    }
  end

  def settings_factory do
    %LibTen.Admin.Settings{logo: "test.png"}
  end
end
