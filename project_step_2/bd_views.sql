USE project_comp_shop;

# 1) Представление с полным описанием товара и его количества на складе

CREATE OR REPLACE VIEW products_description (Идентификатор, Наименование, Описание, Производитель, Страна, Категория, Цена, Количество) AS
SELECT p.id, p.name, p.description, p2.name, p2.country, c.name, p.price, sp.amount
FROM storehouse_products AS sp INNER JOIN products AS p ON sp.product_id = p.id 
INNER JOIN producers AS p2 ON p.producer_id = p2.id 
INNER JOIN catalogs AS c ON p.catalog_id = c.id;

SELECT * FROM products_description;

# 2) Номера заказов и время доставки, которое больше среднего

CREATE OR REPLACE VIEW bigger_than_avg (Номер_заказа, Время_доставки) AS
SELECT o.id, HOUR(TIMEDIFF(os.date_step_end, os.date_step_reg)) AS Время_доставки
FROM orders AS o INNER JOIN order_steps AS os ON o.id = os.order_id
WHERE os.step_id = (SELECT id FROM steps WHERE name_step = 'Доставка') 
	  AND HOUR(TIMEDIFF(os.date_step_end, os.date_step_reg)) > (SELECT AVG(HOUR(TIMEDIFF(os.date_step_end, os.date_step_reg))) 
	  																   FROM order_steps AS os
	  																   WHERE step_id = (SELECT id 
	  																   					FROM steps 
	  																   					WHERE name_step = 'Доставка'))
ORDER BY Время_доставки;

SELECT * FROM bigger_than_avg;

# 3) Вывести номер сотрудника, имя, должность и количество продаж топ 3 лучших по количеству продажам сотрудника

CREATE OR REPLACE VIEW best_3_employee (Номер_сотрудника, Имя, Должность, Количество_продаж) AS
SELECT s.id, CONCAT(first_name, ' ', last_name), p.name, COUNT(o.seller_id)
FROM sellers AS s INNER JOIN orders AS o ON s.id = o.seller_id
	 INNER JOIN positions AS p ON s.position_id = p.id
GROUP BY o.seller_id
ORDER BY COUNT(o.seller_id) DESC LIMIT 3;

SELECT * FROM best_3_employee;
