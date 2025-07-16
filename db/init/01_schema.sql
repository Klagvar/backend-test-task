-- Table: categories
CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

-- Table: products
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    price DECIMAL(12, 2) NOT NULL,
    category_id INT NOT NULL REFERENCES categories(id)
);

-- Table: orders
CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT now()
);

-- Table: order_items
CREATE TABLE IF NOT EXISTS order_items (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(id),
    product_id INT NOT NULL REFERENCES products(id),
    qty INT NOT NULL DEFAULT 1,
    price_snapshot DECIMAL(12,2) NOT NULL
);

-- Table: stats
CREATE TABLE IF NOT EXISTS stats (
  stat_date   DATE NOT NULL,
  category_id INT  NOT NULL REFERENCES categories(id),
  items_sold  INT  NOT NULL,
  total_sum   DECIMAL(14,2) NOT NULL,
  PRIMARY KEY (stat_date, category_id)
);
