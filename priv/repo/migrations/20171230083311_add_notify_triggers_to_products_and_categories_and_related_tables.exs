defmodule LibTen.Repo.Migrations.AddNotifyTriggersToProductsAndCategoriesAndRelatedTables do
  use Ecto.Migration

  def change do
    execute """
      CREATE FUNCTION notify_about_update()
      RETURNS TRIGGER AS $$
      DECLARE
        product_id text;
        col_name text := quote_ident(TG_ARGV[1]);
      BEGIN
        EXECUTE format('SELECT ($1).%s::text', col_name)
        USING
          CASE
            WHEN TG_OP = 'DELETE' THEN OLD
            ELSE NEW
          END
        INTO product_id;

        PERFORM pg_notify(TG_ARGV[0], product_id::char);
        RETURN NULL;
      END;
      $$ LANGUAGE plpgsql;
    """

    execute """
      CREATE TRIGGER nofity_about_product_update
      AFTER INSERT OR UPDATE OR DELETE ON products
      FOR EACH ROW
      EXECUTE PROCEDURE notify_about_update("product_updated", "id");
    """

    execute """
      CREATE TRIGGER nofity_about_product_update
      AFTER INSERT OR UPDATE OR DELETE ON product_ratings
      FOR EACH ROW
      EXECUTE PROCEDURE notify_about_update("product_updated", "product_id");
    """

    execute """
      CREATE TRIGGER nofity_about_product_update
      AFTER INSERT OR UPDATE OR DELETE ON product_uses
      FOR EACH ROW
      EXECUTE PROCEDURE notify_about_update("product_updated", "product_id");
    """

    execute """
      CREATE TRIGGER nofity_about_product_update
      AFTER INSERT OR UPDATE OR DELETE ON product_votes
      FOR EACH ROW
      EXECUTE PROCEDURE notify_about_update("product_updated", "product_id");
    """

    execute """
      CREATE TRIGGER nofity_about_category_update
      AFTER INSERT OR UPDATE OR DELETE ON categories
      FOR EACH ROW
      EXECUTE PROCEDURE notify_about_update("category_updated", "id");
    """
  end
end
