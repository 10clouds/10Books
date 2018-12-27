defmodule LibTen.Products.RefreshDb do
  import Ecto.Query, warn: false
  alias LibTen.Repo
  alias LibTen.Products.{Product, ProductRating, ProductUse, ProductVote}

  @target_date ~N[2018-12-20 00:00:00]

  def perform do
    ProductRating
    |> where([r], r.inserted_at > ^@target_date)
    |> Repo.delete_all()

    ProductVote
    |> where([r], r.inserted_at > ^@target_date)
    |> Repo.delete_all()

    ProductUse
    |> where([r], r.inserted_at > ^@target_date)
    |> Repo.delete_all()

    Product
    |> where([r], r.inserted_at > ^@target_date)
    |> Repo.delete_all()
  end
end
