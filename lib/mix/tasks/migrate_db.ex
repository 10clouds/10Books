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
    Repo.delete_all(ProductUse)
    Repo.delete_all(ProductVote)
    Repo.delete_all(Product)
    Repo.delete_all(Category)
    Repo.delete_all(User)

    categories = Enum.to_list(categories_cursor)
    categories = Enum.map(categories, fn (category) ->
      {:ok, ecto_category} = %Category{}
        |> Category.changeset(%{name: category["name"]})
        |> Repo.insert()

      %{
        mongo_id: category["_id"],
        ecto: ecto_category
      }
    end)

    # Migrate Users
    users = Enum.to_list(users_cursor)
    users = Enum.map(users, fn (user) ->
      if user["createdAt"] do
        is_admin = if user["roles"] do
          cond do
            user["roles"] == ["admin"] ->
              true
            user["roles"]["__global_roles__"] == ["admin"] ->
              true
            true ->
              nil
          end
        else
          nil
        end

        changeset = %{
          inserted_at: user["createdAt"],
          updated_at:  user["createdAt"],
          email:       Enum.at(user["emails"], 0)["address"],
          name:        user["profile"]["name"],
          is_admin:    is_admin
        }

        {:ok, ecto_user} = %User{}
          |> Changeset.cast(changeset, [:name, :email, :is_admin])
          |> Changeset.validate_required([:name, :email])
          |> Changeset.unique_constraint(:email)
          |> Repo.insert

        %{
          mongo_id: user["_id"],
          ecto: ecto_user
        }
      else
        nil
      end
    end)

    # Migrate Products
    product_statuses_map = %{
      "taken"      => Product.library_statuses[:in_library],
      "in_library" => Product.library_statuses[:in_library],
      "requested"  => Product.order_statuses[:requested],
      "accepted"   => Product.order_statuses[:accepted],
      "rejected"   => Product.order_statuses[:rejected],
      "ordered"    => Product.order_statuses[:ordered],
      "lost"       => Product.library_statuses[:lost]
    }
    products = Enum.to_list(books_cursor)
    products = Enum.sort(products, fn (prev, next) ->
      round(prev["created_at"]) < round(next["created_at"])
    end)

    products = Enum.map(products, fn (product) ->
      if product["subscribers"] != nil and Enum.count(product["subscribers"]) > 0 do
        # TODO: Build subscribers
      end

      category = Enum.find(categories, fn (category) ->
        category.ecto.name == product["category"]
      end)

      category_id = if category do
        category.ecto.id
      else
        nil
      end

      product_use = if product["taken_by"] do
        user = Enum.find(users, fn (user) ->
          if user do
            user.mongo_id == product["taken_by"]
          else
            false
          end
        end)

        unless user == nil do
          %{
            user_id: user.ecto.id,
            inserted_at: from_timestamp(product["taken_date"]),
            updated_at: from_timestamp(product["taken_date"])
          }
        else
          nil
        end
      else
        nil
      end

      user_id = if product["requested_by"] do
        user = Enum.find(users, fn (user) ->
          if user do
            user.mongo_id == product["requested_by"]
          else
            false
          end
        end)

        if user do
          user.ecto.id
        else
          nil
        end
      end

      changeset = %{
        inserted_at:   from_timestamp(product["created_at"]),
        updated_at:    from_timestamp(product["created_at"]),
        author:        product["author"],
        status:        product_statuses_map[product["status"]],
        title:         product["name"],
        url:           product["url"],
        category_id:   category_id,
        user_id:       user_id,
        product_use:   product_use
      }

      {:ok, ecto_product} = %Product{}
        |> Changeset.cast(changeset, [:title, :url, :author, :status, :category_id, :user_id, :inserted_at, :updated_at])
        |> Changeset.put_assoc(:product_use, product_use)
        |> Changeset.validate_required([:title, :status])
        |> Repo.insert()

      %{
        mongo_id: product["_id"],
        ecto: ecto_product
      }
    end)

    # Migrate Product Votes
    product_votes = Enum.to_list(book_votes_cursor)
    product_votes = Enum.map(product_votes, fn (product_vote) ->
      product = Enum.find(products, fn (product) ->
        product.mongo_id == product_vote["book_id"]
      end)
      user = Enum.find(users, fn (user) ->
        if user do
          user.mongo_id == product_vote["user_id"]
        else
          nil
        end
      end)
      user_id = if user do
        user.ecto.id
      else
        nil
      end
      is_upvote = if product_vote["vote"] == 1 do
        true
      else
        false
      end

      unless user_id == nil or product == nil do
        changeset = %{
          product_id: product.ecto.id,
          user_id: user_id,
          is_upvote: is_upvote
        }

        %ProductVote{}
        |> ProductVote.changeset(changeset)
        |> Repo.insert()
      end

      product
    end)
  end
end
