# Тестовое задание (PHP + Redis + PostgreSQL + Docker)

## Стек
- Docker Compose (latest) – управление несколькими контейнерами  
- PHP 8.2 CLI: скрипт с Redis-блокировкой  
- Redis latest: in-memory key-value для «замка»  
- PostgreSQL latest: четыре таблицы + триггер + сид-данные  
- Все миграции и сид выполняются автоматически из `db/init/*.sql`

## Быстрый старт

```bash
git clone https://github.com/Klagvar/backend-test-task
cd backend-test-task
docker compose up --build          # первый запуск
```

При первом старте:
1. Собирается PHP-образ.  
2. Подтягиваются образы Redis и Postgres.  
3. Postgres применяет `01_schema.sql` -> `02_trigger.sql` -> `03_seed.sql`.

## Задание 1 — PHP-скрипт с блокировкой Redis

Запуск и проверка:

```bash
docker compose exec php php script.php     # терминал 1 (работа ≈ 5 с)
docker compose exec php php script.php     # терминал 2 (покажет «already running»)
```

1-й терминал выведет «Lock acquired, working...», будет работать 5 с.  
2-й терминал, запущенный параллельно, напишет «Another instance is already running – exiting.» — блокировка сработала.

## Задание 2 — Триггер статистики в Postgres

Быстро посмотреть содержимое таблицы статистики (без psql):

```bash
docker compose exec postgres psql -U app -d appdb -c "TABLE stats;"
```

Ручная проверка из psql:

```bash
docker compose exec postgres psql -U app -d appdb
-- в интерактивном режиме:
INSERT INTO orders DEFAULT VALUES;
INSERT INTO order_items (order_id, product_id, qty, price_snapshot)
VALUES (currval('orders_id_seq'), 1, 2, 699.99);  -- +2 смартфона
SELECT * FROM stats WHERE stat_date = CURRENT_DATE;
\q
```