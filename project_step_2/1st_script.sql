USE project_comp_shop;

SHOW TABLES;

DROP TABLE IF EXISTS catalogs;

CREATE TABLE catalogs (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(120) NOT NULL
) COMMENT = 'Каталог товара';

DROP TABLE IF EXISTS producers;

CREATE TABLE producers (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(120) NOT NULL,
country VARCHAR(120) NOT NULL
) COMMENT = 'Производитель товара';

DROP TABLE IF EXISTS products;

CREATE TABLE products (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(120) NOT NULL,
description TEXT,
price DECIMAL(11, 2) UNSIGNED,
catalog_id INT UNSIGNED NOT NULL,
producer_id INT UNSIGNED NOT NULL,
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) COMMENT = 'Товар каталога';

DROP TABLE IF EXISTS order_lines;

CREATE TABLE order_lines (
order_id INT UNSIGNED NOT NULL,
product_id INT UNSIGNED NOT NULL,
amount TINYINT UNSIGNED NOT NULL,
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) COMMENT = 'Строка заказа';

DROP TABLE IF EXISTS `orders`;

CREATE TABLE `orders` (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
client_id INT UNSIGNED NOT NULL,
seller_id INT UNSIGNED NOT NULL,
total_price DECIMAL(11, 2) UNSIGNED NOT NULL,
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) COMMENT = 'Заказ';

DROP TABLE IF EXISTS clients;

CREATE TABLE clients (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
address_id INT NOT NULL,
phone VARCHAR(50) NOT NULL,
email VARCHAR(100) DEFAULT NULL,
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) COMMENT = 'Информация о покупателе';

DROP TABLE IF EXISTS sellers;

CREATE TABLE sellers (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
position_id INT UNSIGNED NOT NULL
) COMMENT = 'Сотрудник магазина';

DROP TABLE IF EXISTS positions;

CREATE TABLE positions (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL
) COMMENT = 'Должности в магазине';

DROP TABLE IF EXISTS addresses;

CREATE TABLE addresses (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
city_id INT UNSIGNED NOT NULL,
street_id INT UNSIGNED NOT NULL,
house SMALLINT UNSIGNED NOT NULL,
flat SMALLINT UNSIGNED NOT NULL
) COMMENT = 'Адресс клиента';

DROP TABLE IF EXISTS streets;

CREATE TABLE streets (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL
) COMMENT = 'Улицы';

DROP TABLE IF EXISTS cities;

CREATE TABLE cities (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(120) NOT NULL
) COMMENT = 'Города проживания пользователей';

DROP TABLE IF EXISTS discounts;

CREATE TABLE discounts (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
client_id INT UNSIGNED NOT NULL,
product_id INT UNSIGNED NOT NULL,
discount TINYINT UNSIGNED DEFAULT NULL,
started_at DATETIME DEFAULT NULL,
finished_at DATETIME DEFAULT NULL,
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) COMMENT = 'Скидки для покупателей';

DROP TABLE IF EXISTS storehouse_products;

CREATE TABLE storehouse_products (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
product_id INT UNSIGNED NOT NULL,
amount TINYINT UNSIGNED,
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) COMMENT = 'Товар на складе';

DROP TABLE IF EXISTS order_steps;

CREATE TABLE order_steps (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
order_id INT UNSIGNED NOT NULL,
step_id INT UNSIGNED NOT NULL,
date_step_reg DATETIME,
date_step_end DATETIME DEFAULT NULL
) COMMENT = 'Статус заказа';

DROP TABLE IF EXISTS steps;

CREATE TABLE steps (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name_step VARCHAR(120) NOT NULL
) COMMENT = 'Состояния заказа';


# создание внешних ключей
USE project_comp_shop;

ALTER TABLE products
	ADD CONSTRAINT products_catalog_id_fk
		FOREIGN KEY (catalog_id) REFERENCES catalogs(id) 
			ON DELETE RESTRICT,
	ADD CONSTRAINT products_producer_id_fk
		FOREIGN KEY (producer_id) REFERENCES producers(id)
			ON DELETE RESTRICT;

ALTER TABLE order_lines 
	ADD CONSTRAINT order_line_product_id_fk
		FOREIGN KEY (product_id) REFERENCES products(id)
			ON DELETE CASCADE;
ALTER TABLE order_lines 
	ADD CONSTRAINT order_line_order_id_fk
		FOREIGN KEY (order_id) REFERENCES `orders`(id)
			ON DELETE CASCADE;
			
ALTER TABLE storehouse_products
	ADD CONSTRAINT storehouse_products_product_id_fk
		FOREIGN KEY (product_id) REFERENCES products(id)
			ON DELETE CASCADE;

ALTER TABLE discounts
	ADD CONSTRAINT discounts_product_id_fk
		FOREIGN KEY (product_id) REFERENCES products(id)
			ON DELETE NO ACTION,
	ADD CONSTRAINT discounts_client_id_fk
		FOREIGN KEY (client_id) REFERENCES clients(id)
			ON DELETE NO ACTION;
			
ALTER TABLE `orders` 
	ADD CONSTRAINT order_client_id_fk
		FOREIGN KEY (client_id) REFERENCES clients(id)
			ON DELETE NO ACTION,
	ADD CONSTRAINT order_seller_id_fk
		FOREIGN KEY (seller_id) REFERENCES sellers(id)
			ON DELETE NO ACTION;

ALTER TABLE order_steps
	ADD CONSTRAINT order_step_order_id_fk
		FOREIGN KEY (order_id) REFERENCES `orders`(id)
			ON DELETE CASCADE,
	ADD CONSTRAINT order_step_step_id_fk
		FOREIGN KEY (step_id) REFERENCES steps(id)
			ON DELETE NO ACTION;

ALTER TABLE clients
MODIFY COLUMN address_id INT UNSIGNED NOT NULL;
ALTER TABLE clients
	ADD CONSTRAINT client_adress_id_fk
		FOREIGN KEY (address_id) REFERENCES addresses(id)
			ON DELETE NO ACTION;

ALTER TABLE addresses
	ADD CONSTRAINT address_city_id_fk
		FOREIGN KEY (city_id) REFERENCES cities(id)
			ON DELETE NO ACTION,
	ADD CONSTRAINT address_street_id_fk
		FOREIGN KEY (street_id) REFERENCES streets(id)
			ON DELETE NO ACTION;

ALTER TABLE sellers
	ADD CONSTRAINT sellers_posts_id_fk
		FOREIGN KEY (position_id) REFERENCES positions(id)
			ON DELETE RESTRICT;


# создание индексов

CREATE INDEX order_steps_reg_end_idx ON order_steps (order_id, date_step_reg, date_step_end);

CREATE INDEX producers_name_idx ON producers (name);

CREATE INDEX orders_seller_id_total_price_idx ON orders (seller_id, total_price);

CREATE UNIQUE INDEX cities_name_uqidx ON cities (name);

CREATE UNIQUE INDEX catalogs_name_uqidx ON catalogs (name);

CREATE UNIQUE INDEX steps_name_step_uqidx ON steps (name_step);

CREATE INDEX products_catalog_id_price_name_idx ON products (catalog_id, price, name);

CREATE INDEX discounts_product_id_discount_idx ON discounts (product_id, discount);
