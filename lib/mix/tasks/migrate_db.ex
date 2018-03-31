defmodule Mix.Tasks.MigrateDb do
  use Mix.Task

  import Ecto.Query, warn: false

  alias Ecto.Changeset
  alias LibTen.Repo
  alias LibTen.Categories.Category
  alias LibTen.Accounts.User
  alias LibTen.Products.{Product, ProductUse, ProductRating, ProductVote}

  def from_timestamp(timestamp) do
    {:ok, date} = DateTime.from_unix(round(timestamp), :millisecond)
    date
  end

  def run(_) do
    Application.ensure_all_started(:mongodb)
    Application.ensure_all_started(:postgrex)
    Application.ensure_all_started(:ecto)
    LibTen.Repo.start_link
    {:ok, conn} = Mongo.start_link(database: "bookDB")
    users_cursor = Mongo.find(conn, "users", %{})
    books_cursor = Mongo.find(conn, "books", %{})
    book_votes_cursor =  Mongo.find(conn, "book_votes", %{})
    categories_cursor = Mongo.find(conn, "categories", %{})

    # Migrate Categories
    Repo.delete_all(ProductRating)
    Repo.delete_all(ProductUse)
    Repo.delete_all(ProductVote)
    Repo.delete_all(Product)
    Repo.delete_all(Category)
    Repo.delete_all(User)

    # Migrate Categories
    categories = Enum.to_list(categories_cursor)
      |> Enum.map(fn category ->
        {:ok, ecto_category} =
          %Category{}
          |> Category.changeset(%{name: category["name"]})
          |> Repo.insert()
        %{
          mongo_id: category["_id"],
          ecto: ecto_category
        }
      end)

    # Migrate Users
    users = Enum.to_list(users_cursor)
      |> Enum.map(fn user ->
        if user["createdAt"] do
          is_admin = cond do
            user["roles"] == ["admin"] -> true
            user["roles"]["__global_roles__"] == ["admin"] -> true
            true -> nil
          end

          changeset = %{
            inserted_at: user["createdAt"],
            updated_at:  user["createdAt"],
            email:       Enum.at(user["emails"], 0)["address"],
            avatar_url:  user["services"]["google"]["picture"],
            name:        user["profile"]["name"],
            is_admin:    is_admin
          }

          {:ok, ecto_user} =
            %User{}
            |> Changeset.cast(changeset, [
              :inserted_at, :updated_at, :name, :email, :is_admin, :avatar_url
            ])
            |> Changeset.validate_required([:name, :email])
            |> Changeset.unique_constraint(:email)
            |> Repo.insert

          %{
            mongo_id: user["_id"],
            ecto: ecto_user
          }
        else
          false
        end
      end)
      |> Enum.filter(fn user -> user end)

    # Migrate Products
    product_statuses_map = %{
      "taken"      => "IN_LIBRARY",
      "in_library" => "IN_LIBRARY",
      "requested"  => "REQUESTED",
      "accepted"   => "ORDERED",
      "rejected"   => "DELETED",
      "ordered"    => "ORDERED",
      "lost"       => "LOST"
    }

    products = Enum.to_list(books_cursor)
    |> Enum.sort(fn prev, next ->
      round(prev["created_at"]) < round(next["created_at"])
    end)
    |> Enum.map(fn product ->
      return_subscribers = if product["subscribers"] != nil and Enum.count(product["subscribers"]) > 0 do
        Enum.map(product["subscribers"], fn id ->
          case Enum.find(users, fn user -> user.mongo_id == id end) do
            nil -> nil
            user -> user.ecto.id
          end
        end)
      else
        []
      end

      category = Enum.find(categories, fn (category) ->
        category.ecto.name == product["category"]
      end)

      used_by = if product["taken_by"] do
        user = Enum.find(users, fn user -> user.mongo_id == product["taken_by"] end)
        %{
          user_id: user.ecto.id,
          inserted_at: from_timestamp(product["taken_date"]),
          updated_at: from_timestamp(product["taken_date"]),
          return_subscribers: return_subscribers
        }
      else
        nil
      end

      user_id = if product["requested_by"] do
        user = Enum.find(users, fn user -> user.mongo_id == product["requested_by"] end)

        if user do
          user.ecto.id
        else
          Repo.get_by(User, email: "ruslan.savenok@10clouds.com").id
        end
      end

      changeset = %{
        inserted_at:          from_timestamp(product["created_at"]),
        updated_at:           from_timestamp(product["created_at"]),
        author:               product["author"],
        status:               product_statuses_map[product["status"]],
        title:                product["name"],
        url:                  product["url"],
        category_id:          (if category, do: category.ecto.id, else: nil),
        requested_by_user_id: user_id
      }

      {:ok, ecto_product} =
        %Product{}
        |> Changeset.cast(changeset, [
          :title, :url, :author, :status, :category_id, :requested_by_user_id, :inserted_at, :updated_at
        ])
        |> Changeset.put_assoc(:used_by, used_by)
        |> Changeset.validate_required([:title, :status])
        |> Repo.insert()

      %{
        mongo_id: product["_id"],
        ecto: ecto_product
      }
    end)

    # Migrate Product Votes
    Enum.to_list(book_votes_cursor)
    |> Enum.map(fn vote ->
      product = Enum.find(products, fn product ->
        product.mongo_id == vote["book_id"]
      end)
      user = Enum.find(users, fn user -> user.mongo_id == vote["user_id"] end)

      if product && user do
        changeset = %{
          product_id: product.ecto.id,
          user_id: user.ecto.id,
          is_upvote: vote["vote"] == 1
        }

        %ProductVote{}
        |> ProductVote.changeset(changeset)
        |> Repo.insert()
      end
    end)
  end
end
