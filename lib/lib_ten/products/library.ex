defmodule LibTen.Products.Library do
  import Ecto.Query, warn: false
  alias Ecto.Changeset
  alias LibTen.Repo
  alias LibTen.Products.{Emails, Product, ProductUse, ProductRating}
  alias LibTen.Accounts

  def list do
    library_query()
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def get(product_id, with_preloads \\ true) do
    library_query(with_preloads)
    |> Repo.get(product_id)
  end

  def update(product_id, attrs) do
    product = get(product_id)

    if product do
      product
      |> Changeset.cast(attrs, [:category_id])
      |> Repo.update()
    else
      nil
    end
  end

  def take(product_id, user_id) do
    product = get(product_id, false)

    if product do
      %ProductUse{}
      |> ProductUse.changeset(%{product_id: product_id, user_id: user_id})
      |> Repo.insert()
    else
      nil
    end
  end

  def return(product_id, user_id) do
    product = get(product_id, false)

    if product do
      curr_use =
        ProductUse
        |> where(product_id: ^product_id, user_id: ^user_id)
        |> where([p], is_nil(p.ended_at))
        |> Repo.one()

      curr_use = if curr_use do
        curr_use
        |> ProductUse.changeset(%{ended_at: DateTime.utc_now()})
        |> Repo.update()
      end

      with {:ok, curr_use} <- curr_use do
        for user <- Accounts.list_users(curr_use.return_subscribers) do
          Emails.product_has_been_returned(product, user)
          |> LibTen.Mailer.deliver_later
        end
      end

      curr_use
    else
      nil
    end
  end

  def rate(product_id, user_id, value) do
    product = get(product_id, false)

    if product do
      %ProductRating{}
      |> ProductRating.changeset(%{
        product_id: product_id,
        user_id: user_id,
        value: value
      })
      |> Repo.insert()
    else
      nil
    end
  end

  def subscribe_user_to_return_notification(product_id, user_id) do
    product_use =
      ProductUse
      |> where(product_id: ^product_id)
      |> where([p_use], fragment("? != ALL(?)", ^user_id, p_use.return_subscribers))
      |> where([p_use], is_nil(p_use.ended_at))
      |> Repo.one()

    if product_use do
      ProductUse
      |> where(id: ^product_use.id)
      |> Repo.update_all(push: [return_subscribers: user_id])

      {:ok, product_use}
    else
      nil
    end
  end

  def unsubscribe_user_from_return_notification(product_id, user_id) do
    product_use =
      ProductUse
      |> where(product_id: ^product_id)
      |> where([p_use], fragment("? = ANY(?)", ^user_id, p_use.return_subscribers))
      |> where([p_use], is_nil(p_use.ended_at))
      |> Repo.one()

    if product_use do
      ProductUse
      |> where(id: ^product_use.id)
      |> Repo.update_all(pull: [return_subscribers: user_id])

      {:ok, product_use}
    else
      nil
    end
  end

  def remind_users_to_return_products do
    max_date =
      Timex.today
      |> Timex.shift(days: -60)
      |> Timex.to_naive_datetime

    products =
      library_query()
      |> where([_, used_by], used_by.inserted_at < ^max_date)
      |> Repo.all()

    for product <- products do
      Emails.request_product_return(product)
      |> LibTen.Mailer.deliver_later
    end
  end

  defp library_query(with_preloads \\ true) do
    query = where(Product, [p], p.status in ^Product.library_statuses())

    case with_preloads do
      true ->
        query
        |> join(:left, [p], used_by in assoc(p, :used_by), is_nil(used_by.ended_at))
        |> preload(
          [_, used_by],
          used_by: {used_by, :user},
          ratings: :user
        )

      false ->
        query
    end
  end
end
