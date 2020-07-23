# Практическое задание по теме “Оптимизация запросов”

USE shop;

# Задание 1
# Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users,
# catalogs и products в таблицу logs помещается время и дата создания записи,
# название таблицы, идентификатор первичного ключа и содержимое поля name.

DROP TABLE IF EXISTS logs;

CREATE TABLE logs (
created_at DATETIME NOT NULL, 
table_name VARCHAR(100) NOT NULL,
str_id INT NOT NULL,
name_value VARCHAR(100) NOT NULL
) ENGINE = ARCHIVE;


# создаем триггер на таблицу users, которая будет срабатывать после добавления новой записи

DROP TRIGGER IF EXISTS log_users;

DELIMITER //

CREATE TRIGGER log_users AFTER INSERT ON users
FOR EACH ROW 
BEGIN 
	INSERT INTO logs (created_at, table_name, str_id, name_value)
	VALUES (NOW(), 'users', NEW.id, NEW.name);
END //

DELIMITER ;

# создаем триггер на таблицу catalogs, которая будет срабатывать после добавления новой записи

DROP TRIGGER IF EXISTS log_catalogs;

DELIMITER //

CREATE TRIGGER log_catalogs AFTER INSERT ON catalogs
FOR EACH ROW 
BEGIN 
	INSERT INTO logs (created_at, table_name, str_id, name_value)
	VALUES (NOW(), 'catalogs', NEW.id, NEW.name);
END //

DELIMITER ;

# создаем триггер на таблицу products, который будет срабатывать при добавлении новой записи

DROP TRIGGER IF EXISTS log_products;

DELIMITER //

CREATE TRIGGER log_products AFTER INSERT ON products
FOR EACH ROW 
BEGIN 
	INSERT INTO logs (created_at, table_name, str_id, name_value)
	VALUES (NOW(), 'products', NEW.id, NEW.name);
END //

DELIMITER ;

# проверяем

SELECT * FROM users;
INSERT INTO users (name, birthday_at) VALUES ('Никита', '1994-04-16');
SELECT * FROM logs;

SELECT * FROM catalogs;
INSERT INTO catalogs (name) VALUES ('Блоки питания');
SELECT * FROM logs;

SELECT * FROM products;
INSERT INTO products (name, description, price, catalog_id) VALUES ('Intel Core i5-10400', 'Процессор настольный', 15500, 1);
SELECT * FROM logs;

# Задание 2
# Создайте SQL-запрос, который помещает в таблицу users миллион записей.

DROP TABLE IF EXISTS users_mill;

DESC users;

CREATE TABLE users_mill (
id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL,
birthday_at DATE NOT NULL,
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DROP PROCEDURE IF EXISTS insert_users;

DELIMITER //

CREATE PROCEDURE insert_users ()
BEGIN
	DECLARE i INT DEFAULT 1000;
	DECLARE j INT DEFAULT 1;
	WHILE i > 0 DO
		INSERT INTO users_mill (name, birthday_at) VALUES (CONCAT('unnamed_', j), FROM_UNIXTIME(RAND() * 2147483647));
		SET i = i - 1;
		SET j = j + 1;
	END WHILE;
END //

DELIMITER ;

CALL insert_users();

SELECT * FROM users_mill ORDER BY id DESC LIMIT 5;


# Практическое задание по теме “NoSQL”

# Задание 1
# В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.

SADD ip '127.0.0.1' '192.168.0.1' '192.168.0.2'

SMEMBERS ip

SCARD ip

# Задание 2
# При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот,
# поиск электронного адреса пользователя по его имени.

SET mike@test.com mike

SET mike mike@test.com

GET mike@test.com

GET mike

# Задание 3
# Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.

# с этим вопросом немного не разобрался