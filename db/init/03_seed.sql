-- 1. категории
INSERT INTO categories (name) VALUES
    ('Electronics'),
    ('Clothing');

-- 2. продукты
INSERT INTO products (category_id, name, price) VALUES
    ((SELECT id FROM categories WHERE name = 'Electronics'), 'Smartphone', 699.99),
    ((SELECT id FROM categories WHERE name = 'Electronics'), 'Laptop',     1199.50),
    ((SELECT id FROM categories WHERE name = 'Clothing'),    'T-Shirt',      19.99),
    ((SELECT id FROM categories WHERE name = 'Clothing'),    'Hat',           9.99);


-- Заказ 1 (вчера): 2 смартфона + 1 кепка
INSERT INTO orders (created_at) VALUES (CURRENT_DATE - INTERVAL '1 day');

-- 2 смартфона
INSERT INTO order_items (order_id, product_id, qty, price_snapshot)
SELECT currval('orders_id_seq'), id, 2, price
FROM products WHERE name = 'Smartphone';

-- 1 кепка
INSERT INTO order_items (order_id, product_id, qty, price_snapshot)
SELECT currval('orders_id_seq'), id, 1, price
FROM products WHERE name = 'Hat';

-- Заказ 2: 3 смартфона + 2 футболки
INSERT INTO orders DEFAULT VALUES;                     

INSERT INTO order_items (order_id, product_id, qty, price_snapshot)
SELECT currval('orders_id_seq'), id, 3, price
FROM products WHERE name = 'Smartphone';

INSERT INTO order_items (order_id, product_id, qty, price_snapshot)
SELECT currval('orders_id_seq'), id, 2, price
FROM products WHERE name = 'T-Shirt';


-- Заказ 3: 1 ноутбук + 4 кепки
INSERT INTO orders DEFAULT VALUES;

INSERT INTO order_items (order_id, product_id, qty, price_snapshot)
SELECT currval('orders_id_seq'), id, 1, price
FROM products WHERE name = 'Laptop';

INSERT INTO order_items (order_id, product_id, qty, price_snapshot)
SELECT currval('orders_id_seq'), id, 4, price
FROM products WHERE name = 'Hat';




