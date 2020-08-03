USE project_comp_shop;
# 1) Вывести тех клиентов, которые оформили заказы, но при этом не произведена оплата(например, покупатель оформил заказ и передумал).

SELECT CONCAT(first_name, ' ',last_name) AS Имя_клиента
FROM clients
WHERE id IN (SELECT client_id 
			 FROM orders
			 WHERE id IN (SELECT order_id AS Номер_заказа
						  FROM order_steps
						  WHERE date_step_reg IS NOT NULL AND date_step_end IS NULL));

# 2) Вывести имена клиентов, которые сделали заказ, но не оплатили.

SELECT o.id AS Номер_заказа, CONCAT(first_name, ' ', last_name) AS Клиент
FROM clients AS c INNER JOIN orders AS o ON c.id = o.client_id
	 INNER JOIN order_steps AS os ON o.id = os.order_id
WHERE date_step_reg IS NOT NULL AND date_step_end IS NULL;

# 3) Вывести названия 3 производителей, продукции которых заказывают чаще всего.

# Также для полезной аналитики можно вывести наоборот продукцию производителей,
# которую покупают не очень охотно и часто, чтобы в дальнейшем сделать какие-нибдуь скидки или акции на данную категорию товаров(убрать DESC в запросе)

SELECT p.name, COUNT(p.name) AS Количество
FROM producers AS p INNER JOIN products AS p2 ON p.id = p2.producer_id 
	 LEFT JOIN order_lines AS ol ON p2.id = ol.product_id
GROUP BY p.name
ORDER BY Количество DESC LIMIT 3;

# 4) Вывести имя и фамилию самого успешного продавца, у которого больше всего продаж(чтобы его поощрить премией, например)

SELECT CONCAT(first_name, ' ', last_name) AS Имя_сотрудника
FROM sellers
WHERE id = (SELECT seller_id
			FROM orders
			GROUP BY seller_id
			ORDER BY COUNT(seller_id) DESC LIMIT 1);

# 5) Вывести имя клиента, на Доставку чьего заказа потратили меньше всего времени.

SELECT CONCAT(first_name, ' ', last_name) AS Имя_клиента
FROM sellers
WHERE id = (SELECT client_id FROM orders
			WHERE id = (SELECT order_id
							  FROM order_steps
							  WHERE step_id = (SELECT id FROM steps WHERE name_step = 'Доставка')
							  ORDER BY HOUR(TIMEDIFF(date_step_end, date_step_reg)) LIMIT 1));

# Номер заказа и количество часов сколько на обслуживание и завершение потратили

SELECT order_id, HOUR(TIMEDIFF(date_step_end, date_step_reg)) AS Часы
FROM order_steps
WHERE step_id = (SELECT id FROM steps WHERE name_step = 'Доставка')
ORDER BY Часы LIMIT 1;

# 6) Вывести продавцов, количество заказов и на какую сумму они продали

SELECT DISTINCT CONCAT(first_name, ' ', last_name) AS Имя_сотрудника,
	   COUNT(seller_id) OVER (PARTITION BY o.seller_id) AS Количество_продаж,
	   SUM(total_price) OVER (PARTITION BY o.seller_id) AS Сумма_продаж
FROM sellers AS s LEFT JOIN orders AS o ON s.id = o.seller_id
ORDER BY Сумма_продаж;


