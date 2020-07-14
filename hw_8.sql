USE vk;

# Задание 1
# Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT gender, COUNT(gender) AS Всего_лайков
FROM likes INNER JOIN profiles ON likes.user_id = profiles.user_id
GROUP BY gender;


# Задание 2
# Подсчитать общее количество лайков десяти самым молодым пользователям 
# (сколько лайков получили 10 самых молодых пользователей).

SELECT SUM(Суммарно_у_каждого) AS Итог
FROM
(SELECT COUNT(*) AS Суммарно_у_каждого
FROM profiles AS p RIGHT JOIN likes AS l ON p.user_id = l.target_id
INNER JOIN target_types AS tt ON l.target_type_id = tt.id
GROUP BY l.target_id 
ORDER BY p.birthday DESC LIMIT 10) AS user_likes;

# Задание 3
# Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети
# (критерии активности необходимо определить самостоятельно).

SELECT u.id, CONCAT(first_name, ' ', last_name) AS Имя_Фамилия,
COUNT(m.from_user_id) + COUNT(p.user_id) + COUNT(l.user_id) + COUNT(m2.user_id) AS Активность
FROM users u 
LEFT JOIN messages m ON u.id = m.from_user_id 
LEFT JOIN posts p ON u.id = p.user_id
LEFT JOIN likes l ON u.id = l.user_id
LEFT JOIN media m2 ON u.id = m2.user_id 
GROUP BY u.id
ORDER BY Активность LIMIT 10;