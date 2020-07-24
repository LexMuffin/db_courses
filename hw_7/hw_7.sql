#Задание 1
#Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

#Таблицы надо подкорректировать и создать внешние ключи(связи)
#потому что в некоторых столбцах типы данных не сходятся

USE shop;

ALTER TABLE orders
	CHANGE COLUMN user_id user_id BIGINT UNSIGNED NOT NULL;

ALTER TABLE orders 
	ADD CONSTRAINT orders_user_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT;
		
ALTER TABLE orders_products
	CHANGE COLUMN order_id order_id BIGINT UNSIGNED NOT NULL,
	CHANGE COLUMN product_id product_id BIGINT UNSIGNED NOT NULL;

ALTER TABLE orders_products
	ADD CONSTRAINT orders_products_order_id_fk
		FOREIGN KEY (order_id) REFERENCES orders(id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
	ADD CONSTRAINT orders_products_product_id_fk
		FOREIGN KEY (product_id) REFERENCES products(id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT;

ALTER TABLE products
	CHANGE COLUMN catalog_id catalog_id BIGINT UNSIGNED NOT NULL;

ALTER TABLE products
	ADD CONSTRAINT products_catalog_id_fk
		FOREIGN KEY (catalog_id) REFERENCES catalogs(id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT;

ALTER TABLE orders_products DROP id;		
ALTER TABLE orders_products
	ADD PRIMARY KEY(order_id, product_id);

INSERT INTO orders (user_id) VALUES
(1), # Геннадий
(3), # Александр
(5); # Иван

INSERT INTO orders_products (order_id, product_id) VALUES
(1, 2),
(1, 7),
(2, 1),
(2, 6),
(3, 3);

# Сначала Иван заказал 1 процессор, после чего решил заказать еще процессор своему другу(к примеру)
UPDATE orders_products SET total = 2 
WHERE order_id = (SELECT id FROM orders WHERE user_id = (SELECT id FROM users WHERE name = "Иван"));

# Составляем запросы на поиск пользователей, которые совершали заказы

SELECT name, orders.id 
FROM users RIGHT JOIN orders ON users.id = orders.user_id;# непосредственно выводит пользователя и его номер заказа

SELECT name
FROM users
WHERE EXISTS (SELECT 1 FROM orders WHERE users.id = orders.user_id);# выводит имена пользователей которые существуют в таблице orders

# Задание 2
# Выведите список товаров products и разделов catalogs, который соответствует товару.

SELECT p.name AS Наименование, price AS Цена, c.id AS Артикул, c.name AS Категория 
FROM products AS p INNER JOIN catalogs AS c ON p.catalog_id = c.id;

#SELECT p.name , price, c.name 
#FROM products AS p RIGHT JOIN catalogs AS c ON p.catalog_id = c.id;
# данным запросом также выводятся категории товаров, которых например нет, вместо наименования и цены NULL

# Задание 3
#(по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
#Поля from, to и label содержат английские названия городов, поле name — русское. 
#Выведите список рейсов flights с русскими названиями городов.

CREATE TABLE flights (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
`from` VARCHAR(50) NOT NULL,
`to` VARCHAR(50) NOT NULL
);

CREATE TABLE cities (
label VARCHAR(50) NOT NULL,
name VARCHAR(50) NOT NULL
);

INSERT INTO flights (`from`, `to`) VALUES
('moscow', 'omsk'),
('novgorod', 'kazan'),
('irkutsk', 'moscow'),
('omsk', 'irkutsk'),
('moscow', 'kazan');

INSERT INTO cities (label, name) VALUES
('moscow', 'Москва'),
('irkutsk','Иркутск'),
('novgorod','Новгород'),
('kazan','Казань'),
('omsk','Омск');

SELECT id AS Номер_рейса,
	   (SELECT name FROM cities WHERE label = `from`) AS Откуда,
	   (SELECT name FROM cities WHERE label = `to`) AS Куда
FROM flights
ORDER BY Номер_рейса;