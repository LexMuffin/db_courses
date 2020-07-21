# Задание 1

# 1.Проанализировать какие запросы могут выполняться наиболее
# часто в процессе работы приложения и добавить необходимые индексы.

# 1) чаще всего запросы из базы данных ВК проводятся используя возраст пользователей, например средний возраст пользователей,
# также может быть сортировка по датам рождения birthday в таблице profiles.
# Также часто могут использоваться названия сообществ name в таблице communities. 
# 2) уникальные индексы могут быть созданы по столбцу email таблицы users
# 3) составной индекс может быть создан на столбцы года рождения и пола birthday и gender в таблице profiles,
# столбцов получателя и отправителя from_user_id и to_user_id в messages, по имени и фамилии first_name и last_name в таблице users.
# Столбцы user_id и community_id в таблице posts ( для того, чтобы можно было производить сортировки по конкретным пользователям и группам одновременно)

USE vk;

CREATE INDEX profiles_birthday_idx ON profiles(birthday);

CREATE INDEX communities_name_idx ON communities(name);

CREATE UNIQUE INDEX users_email_uq ON users(email);

CREATE INDEX profiles_birthday_gender_idx ON profiles(birthday, gender);

CREATE INDEX messages_from_user_id_to_user_id_idx ON messages(from_user_id, to_user_id);

CREATE INDEX users_first_name_last_name_idx ON users(first_name, last_name);

CREATE INDEX posts_user_id_community_id_idx ON posts(user_id, community_id);

# Задание 2
# 2. Задание на оконные функции
# Построить запрос, который будет выводить следующие столбцы:
# имя группы
# среднее количество пользователей в группах
# самый молодой пользователь в группе
# самый старший пользователь в группе
# общее количество пользователей в группе
# всего пользователей в системе
# отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100

SELECT 
	DISTINCT c.name AS group_name, 
	COUNT(cu.user_id) OVER () / (SELECT COUNT(c.id) FROM communities c) AS average,
	FIRST_VALUE(cu.user_id) OVER (PARTITION BY cu.community_id ORDER BY p.birthday) AS the_youngest_id,
	FIRST_VALUE(cu.user_id) OVER (PARTITION BY cu.community_id ORDER BY p.birthday DESC) AS the_oldest_id,
	COUNT(cu.user_id) OVER w AS total_in_group,
	COUNT(p.user_id) OVER () AS total_users,
	COUNT(cu.user_id) OVER w / COUNT(p.user_id) OVER () * 100 AS '%'
FROM 
	communities AS c LEFT JOIN communities_users AS cu ON c.id = cu.community_id 
	INNER JOIN profiles AS p USING(user_id)
	INNER JOIN users AS u ON p.user_id = u.id
WINDOW w AS (PARTITION BY cu.community_id);