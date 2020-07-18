# Практическое задание по теме “Транзакции, переменные, представления”

# Задание 1
# В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
# Переместите запись id = 1 из таблицы shop.users в таблицу sample.users.
# Используйте транзакции.

# заходим в терминал и прописываем
# mysql -e 'CREATE DATABASE shop'
# mysql -u root -p shop < shop.sql
# mysql -e 'CREATE DATABASE sample'
# mysql -u root -p sample < shop.sql
DELETE FROM sample.users;

START TRANSACTION;

SELECT * FROM users WHERE id = 1;

INSERT INTO sample.users 
SELECT * FROM shop.users WHERE id = 1;

# проверяем наличие строчки (у меня в DBeaver)
SELECT * FROM sample.users;

# перед тем как сделать комммит, заходим в терминал
# mysql
#	mysql> SELECT * FROM sample.users;
#	Empty set (0.00 sec)
# сохранений в рамке транзакций не было произведено(поэтому записи и не появилось)

COMMIT;

# после транзакции проверяем ее наличие(этой строки)
SELECT * FROM sample.users;

# Задание 2
# Создайте представление, которое выводит название name товарной позиции из таблицы products 
# и соответствующее название каталога name из таблицы catalogs.

CREATE OR REPLACE VIEW cat (name, category) AS
SELECT p.name, c.name FROM products AS p INNER JOIN catalogs AS c ON p.catalog_id = c.id;

SELECT * FROM cat;

# Задание 3
# Пусть имеется таблица с календарным полем created_at.
# В ней размещены разряженые календарные записи за август 2018 года '2018-08-01',
# '2016-08-04', '2018-08-16' и 2018-08-17. Составьте запрос,
# который выводит полный список дат за август, выставляя в соседнем поле значение 1,
# если дата присутствует в исходном таблице и 0, если она отсутствует.

DROP TABLE IF EXISTS date_test;
CREATE TABLE date_test (
created_at DATE
);

INSERT INTO date_test (created_at) VALUES 
('2018-08-01'),
('2018-08-04'),
('2018-08-16'),
('2018-04-17');

SELECT * FROM date_test;

SELECT 
	`time`.selected_day AS day,
	(SELECT EXISTS(SELECT * FROM date_test WHERE created_at = `day`)) AS is_happened
FROM
	(SELECT v.* FROM 
		(SELECT ADDDATE('1970-01-01',t4.i*10000 + t3.i*1000 + t2.i*100 + t1.i*10 + t0.i) selected_day FROM
			(SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t0,
		    (SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
		    (SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
		    (SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t3,
		    (SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t4) v
	WHERE selected_day BETWEEN '2018-08-01' AND '2018-08-31') AS `time`
	ORDER BY `day`;


# Задание 4
# Пусть имеется любая таблица с календарным полем created_at.
# Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.

DROP TABLE IF EXISTS date_test_2;
CREATE TABLE date_test_2 (
created_at DATE
);

INSERT INTO date_test_2 (created_at) VALUES
('2018-08-01'),
('2018-08-04'),
('2018-08-05'),
('2018-08-07'),
('2018-08-09'),
('2018-08-11'),
('2018-08-14'),
('2018-08-18'),
('2018-08-20'),
('2018-08-22'),
('2018-08-24'),
('2018-08-26'),
('2018-08-29');

# все даты, которые не входят в 5 самых свежих
SELECT created_at FROM date_test_2
WHERE created_at NOT IN (
	SELECT * 
	FROM (
		SELECT created_at FROM date_test_2 
		ORDER BY created_at DESC LIMIT 5) AS temp);

# запрос оказался удачным, теперь удаляем
DELETE FROM date_test_2 
WHERE created_at NOT IN (
	SELECT * 
	FROM (
		SELECT created_at FROM date_test_2 
		ORDER BY created_at DESC LIMIT 5) AS temp);
	
SELECT * FROM date_test_2;


# Практическое задание по теме “Хранимые процедуры и функции, триггеры"

# Задание 1
# Создайте хранимую функцию hello(), которая будет возвращать приветствие,
# в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
# с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер",
# с 00:00 до 6:00 — "Доброй ночи".

DROP PROCEDURE IF EXISTS hello;

DELIMITER //

CREATE PROCEDURE hello() 
BEGIN
	CASE
		WHEN CURTIME() BETWEEN '06:00:00' AND '12:00:00' THEN
			SELECT 'Доброе утро';
		WHEN CURTIME() BETWEEN '12:00:00' AND '18:00:00' THEN
			SELECT 'Добрый день';
		WHEN CURTIME() BETWEEN '18:00:00' AND '00:00:00' THEN
			SELECT 'Добрый вечер';
		ELSE
			SELECT 'Доброй ночи';
	END CASE;
END//

DELIMITER ;

CALL hello();


# Или же использовать хранимую функцию и оператор IF, ELSEIF
DROP FUNCTION IF EXISTS hello;

DELIMITER //

CREATE FUNCTION hello() 
RETURNS TINYTEXT DETERMINISTIC
BEGIN
		IF (CURTIME() BETWEEN '06:00:00' AND '12:00:00') THEN
			RETURN 'Доброе утро';
		ELSEIF (CURTIME() BETWEEN '12:00:00' AND '18:00:00') THEN
			RETURN 'Добрый день';
		ELSEIF (CURTIME() BETWEEN '18:00:00' AND '00:00:00') THEN
			RETURN 'Добрый вечер';
		ELSE
			RETURN 'Доброй ночи';
	END IF;
END//

DELIMITER ;

SELECT hello() AS Приветствие;

# Задание 2
# В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
# Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема.
# Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены.
# При попытке присвоить полям NULL-значение необходимо отменить операцию.

SELECT * FROM products;

DROP TRIGGER IF EXISTS not_null;

DELIMITER //

CREATE TRIGGER not_null BEFORE INSERT ON products
FOR EACH ROW 
BEGIN 
	IF (ISNULL(NEW.name) AND ISNULL(NEW.description)) THEN 
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Значение NULL в обоих столбцах недопустимо';
	END IF;
END//

DELIMITER ;

INSERT INTO products (name, description, price, catalog_id) VALUES
(NULL, NULL, 5000, 3);

INSERT INTO products (name, description, price, catalog_id) VALUES
('Z490 MSI MPG', NULL, 2000, 2);

# Задание 3
# Напишите хранимую функцию для вычисления произвольного числа Фибоначчи.
# Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел.
# Вызов функции FIBONACCI(10) должен возвращать число 55.

DROP PROCEDURE IF EXISTS fibonacci;

DELIMITER //

CREATE PROCEDURE fibonacci (IN value INT)
BEGIN
	DECLARE i INT DEFAULT 0;
	DECLARE a INT DEFAULT 1;
	DECLARE b INT DEFAULT 0;
	DECLARE c INT DEFAULT 0;
	WHILE value > i DO
		SET c = a + b;
		SET a = b;
		SET b = c;
		SET i = i + 1;
		SELECT c;
	END WHILE;	
END//

DELIMITER ;

CALL fibonacci(10);
# возможно это не то что подразумевалось от поставленной задачи, но это что-то приближенное к этому
