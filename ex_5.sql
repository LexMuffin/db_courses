# Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение»

# Задание первое
UPDATE users SET created_at = CURRENT_TIMESTAMP() , updated_at = CURRENT_TIMESTAMP();
UPDATE users SET created_at = NOW(), updated_at = NOW(); # Второй вариант (покороче)


# Задание второе
ALTER TABLE users modify created_at DATETIME;
ALTER TABLE users modify updated_at DATETIME;


# Задание третье
CREATE TABLE storehouses_products (
id INT PRIMARY KEY AUTO_INCREMENT,
value INT NOT NULL
);

INSERT INTO storehouses_products (value) VALUES (0), (2500), (0), (30), (500), (1);

SELECT value
FROM storehouses_products
ORDER BY CASE WHEN value = 0 THEN 9999 ELSE value END;


# Задание четвертое
# не совсем понял откуда в таблице users брать дату рождения
# поэтому взял нашу учебную БД vk, объеденил users и profiles, вывел Имя и Фамилию и отдельным столбцом дату
# надеюсь я правильно понял задание
USE vk;

SELECT CONCAT(first_name, " ", last_name), birthday AS Пользователь 
FROM users AS u INNER JOIN profiles AS p ON u.id = p.user_id
WHERE MONTH(birthday) IN (5, 8);


# Задание пятое
# опять же взял таблицу communities из ученбной БД vk
SELECT *
FROM communities
WHERE id IN (5, 1, 2)
ORDER BY FIELD(id, 5, 1, 2);


# Практическое задание теме «Агрегация данных»

# Задание первое

SELECT FLOOR(AVG(TIMESTAMPDIFF(YEAR, birthday, NOW()))) AS Средний_возраст FROM profiles;

# Задание второе

SELECT * FROM profiles;

SELECT WEEKDAY(birthday) + 1 AS Дни_недели, COUNT(birthday) AS Количество_ДР 
FROM profiles
GROUP BY WEEKDAY(birthday) + 1
WITH ROLLUP;

# Задание третье

CREATE TABLE test_1 (
id INT PRIMARY KEY AUTO_INCREMENT,
value INT
);

INSERT INTO test_1 (value) VALUES (1), (2), (3), (4), (5);

SELECT EXP(SUM(LN(value))) FROM test_1;



