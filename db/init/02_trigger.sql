CREATE OR REPLACE FUNCTION trg_update_stats()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
DECLARE
    v_cat INT;
    v_stat_date DATE;
BEGIN
    -- 1. узнаём категорию товара
    SELECT category_id
        INTO v_cat
        FROM products
        WHERE id = NEW.product_id;

    -- дата покупки = дата заказа
    SELECT created_at::date
      INTO v_stat_date
      FROM orders
     WHERE id = NEW.order_id;
    
    -- 2. обновляем статистику
    INSERT INTO stats (stat_date, category_id, items_sold, total_sum)
    VALUES (v_stat_date,
            v_cat,
            NEW.qty,
            NEW.qty * NEW.price_snapshot)
    ON CONFLICT (stat_date, category_id) DO 
        UPDATE SET
            items_sold = stats.items_sold + EXCLUDED.items_sold,
            total_sum = stats.total_sum + EXCLUDED.total_sum;
    
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS order_items_ai ON order_items;
CREATE TRIGGER order_items_ai
AFTER INSERT ON order_items
FOR EACH ROW
EXECUTE FUNCTION trg_update_stats();