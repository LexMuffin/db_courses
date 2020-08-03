USE project_comp_shop;

# 1) при добалении заказа в таблицу orders,
# должна добавляться строка 'Оплата' в order_steps с текущей датой добавления заказа.

DROP TRIGGER new_order_insert;

DELIMITER //

CREATE TRIGGER new_order_insert AFTER INSERT ON orders
FOR EACH ROW 
BEGIN
	DECLARE new_id INT;
	DECLARE reg_date DATE;
	SELECT id INTO new_id FROM orders ORDER BY id DESC LIMIT 1;
	SELECT created_at INTO reg_date FROM orders ORDER BY id DESC LIMIT 1;
	INSERT INTO order_steps (order_id, step_id, date_step_reg, date_step_end) VALUES (new_id, 1, reg_date, NULL);
END //

DELIMITER ;

INSERT INTO orders (id, client_id, seller_id, total_price, created_at) VALUES (51, 10, 3, 10500.05, NOW());

# 2) При удалении заказа из orders, по данному идентификатору удаляется запись из order_steps

DELIMITER //

CREATE TRIGGER order_delete AFTER DELETE ON orders
FOR EACH ROW
BEGIN
	DELETE FROM order_lines WHERE order_lines.order_id = OLD.id;
	DELETE FROM order_steps WHERE order_steps.order_id = OLD.id;
END//

DELIMITER ;

DELETE FROM orders WHERE id = 52;

# 3) Создать хранимую процедуру, которая будет выводить номера заказов, полный адрес(улицу, дом, квартиру),
# имена заказчиков для определенного, задаваемого города.
# впринципе еще можно сюда добавить дату оформления заказа и сколько времени прошло с момента например когда товар был оплачен

DESC cities;

DROP PROCEDURE get_customers;

DELIMITER //

CREATE PROCEDURE get_customers (city_arg VARCHAR(120))
BEGIN
	SELECT o.id AS Номер_заказа, CONCAT(c.first_name, ' ', c.last_name) AS Клиент, s.name AS Улица, a.house AS Дом, a.flat AS Квартира
	FROM orders AS o INNER JOIN clients AS c ON o.client_id = c.id
		 INNER JOIN addresses AS a ON c.address_id = a.id
		 INNER JOIN cities AS c2 ON a.city_id = c2.id
		 INNER JOIN streets AS s ON a.street_id = s.id
	WHERE c2.name = city_arg;
END //

DELIMITER ;

SELECT * FROM cities;

CALL get_customers("Пушкино");

# 4) Создать хранимую процедуру, которая будет выводить лучшего продавца
# и его должность по суммарному значению продаж за определенный период времени

DELIMITER //

CREATE PROCEDURE best_sellers (d1 DATE, d2 DATE)
BEGIN
	SELECT CONCAT(s.first_name, ' ', s.last_name) AS Сотрудник, p.name AS Должность, SUM(o.total_price) AS Суммарные_продажи
	FROM orders AS o INNER JOIN sellers AS s ON o.seller_id = s.id AND created_at BETWEEN d1 AND d2
		 INNER JOIN positions AS p ON s.position_id = p.id
	GROUP BY o.seller_id
	ORDER BY Суммарные_продажи DESC
	LIMIT 1;
END //

DELIMITER ;

CALL best_sellers('1990-01-15', '2001-01-15');



