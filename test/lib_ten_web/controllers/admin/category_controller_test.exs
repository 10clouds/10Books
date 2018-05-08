defmodule LibTenWeb.Admin.CategoryControllerTest do
  use LibTenWeb.ConnCase

  alias LibTen.Accounts.Users
  alias LibTen.Categories

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:category) do
    {:ok, category} = Categories.create_category(@create_attrs)
    category
  end

  setup %{conn: conn} do
    {:ok, user} = Users.create(%{
      email: "user@user.com",
      name: "Test",
      is_admin: true
    })
    signed_in_conn = sign_in(conn, user)
    {:ok, %{
      conn: signed_in_conn,
      current_user: user
    }}
  end

  describe "index" do
    test "renders 404 unless admin",
      %{conn: conn, current_user: current_user}
    do
      Users.update(current_user, %{is_admin: false})
      conn = get conn, admin_category_path(conn, :index)
      assert html_response(conn, 404) =~ "not found"
    end

    test "lists all categories", %{conn: conn} do
      conn = get conn, admin_category_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Categories"
    end
  end


  describe "new category" do
    test "renders 404 unless admin",
      %{conn: conn, current_user: current_user}
    do
      Users.update(current_user, %{is_admin: false})
      conn = get conn, admin_category_path(conn, :new)
      assert html_response(conn, 404) =~ "not found"
    end

    test "renders form", %{conn: conn} do
      conn = get conn, admin_category_path(conn, :new)
      assert html_response(conn, 200) =~ "New Category"
    end
  end


  describe "create category" do
    test "renders 404 unless admin",
      %{conn: conn, current_user: current_user}
    do
      Users.update(current_user, %{is_admin: false})
      conn = post conn, admin_category_path(conn, :create)
      assert html_response(conn, 404) =~ "not found"
    end

    test "redirects to index when data is valid", %{conn: conn} do
      conn = post conn, admin_category_path(conn, :create), category: @create_attrs

      assert redirected_to(conn) == admin_category_path(conn, :index)

      conn = get conn, admin_category_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Categories"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, admin_category_path(conn, :create), category: @invalid_attrs
      assert html_response(conn, 200) =~ "New Category"
    end
  end


  describe "edit category" do
    setup [:create_category]

    test "renders 404 unless admin",
      %{conn: conn, current_user: current_user, category: category}
    do
      Users.update(current_user, %{is_admin: false})
      conn = get conn, admin_category_path(conn, :edit, category)
      assert html_response(conn, 404) =~ "not found"
    end

    test "renders form for editing chosen category", %{conn: conn, category: category} do
      conn = get conn, admin_category_path(conn, :edit, category)
      assert html_response(conn, 200) =~ "Edit Category"
    end
  end


  describe "update category" do
    setup [:create_category]

    test "renders 404 unless admin",
      %{conn: conn, current_user: current_user, category: category}
    do
      Users.update(current_user, %{is_admin: false})
      conn = put conn, admin_category_path(conn, :update, category)
      assert html_response(conn, 404) =~ "not found"
    end

    test "redirects when data is valid", %{conn: conn, category: category} do
      conn = put conn, admin_category_path(conn, :update, category), category: @update_attrs
      assert redirected_to(conn) == admin_category_path(conn, :index)

      conn = get conn, admin_category_path(conn, :index)
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, category: category} do
      conn = put conn, admin_category_path(conn, :update, category), category: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Category"
    end
  end


  describe "delete category" do
    setup [:create_category]

    test "renders 404 unless admin",
      %{conn: conn, current_user: current_user, category: category}
    do
      Users.update(current_user, %{is_admin: false})
      conn = delete conn, admin_category_path(conn, :delete, category)
      assert html_response(conn, 404) =~ "not found"
    end

    test "deletes chosen category", %{conn: conn, category: category} do
      conn = delete conn, admin_category_path(conn, :delete, category)
      assert redirected_to(conn) == admin_category_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, admin_category_path(conn, :edit, category)
      end
    end
  end


  defp create_category(_) do
    category = fixture(:category)
    {:ok, category: category}
  end
end
