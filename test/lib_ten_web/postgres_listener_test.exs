defmodule LibTenWeb.PostgresListenerTest do
  use LibTen.DataCase
  alias LibTenWeb.PostgresListener

  # TODO: Write tests which hit database and tiggers callbacks
  test "notifies product channels on product_updated" do
    PostgresListener.on_record_change("product_updated", "1")
  end

  test "notifies category channel on category_updated" do
    PostgresListener.on_record_change("category_updated", "1")
  end

end
