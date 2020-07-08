USE vk;

SHOW TABLES;

#задание 1
#Создать все необходимые внешние ключи и диаграмму отношений.

DESC profiles;
SELECT * FROM profiles;

ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES media(id)
      ON DELETE SET NULL;

DESC media;
DESC users;

ALTER TABLE media 
	ADD CONSTRAINT media_users_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
			ON DELETE NO ACTION,
	ADD CONSTRAINT media_media_types_id_fk
		FOREIGN KEY (media_type_id) REFERENCES media_types(id)
			ON DELETE NO ACTION;
		
ALTER TABLE communities_users
	ADD CONSTRAINT communities_users_user_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
			ON DELETE NO ACTION,
	ADD CONSTRAINT communities_users_community_id_fk
		FOREIGN KEY (community_id) REFERENCES communities(id)
			ON DELETE NO ACTION;

ALTER TABLE friendship
	ADD CONSTRAINT friendship_user_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
			ON DELETE NO ACTION,
	ADD CONSTRAINT friendship_friend_id_fk
		FOREIGN KEY (friend_id) REFERENCES users(id)
			ON DELETE NO ACTION,
	ADD CONSTRAINT friendship_status_id_fk
		FOREIGN KEY (status_id) REFERENCES friendship_statuses(id)
			ON DELETE NO ACTION;

ALTER TABLE messages
	ADD CONSTRAINT messages_from_user_id_fk
		FOREIGN KEY (from_user_id) REFERENCES users(id)
			ON DELETE NO ACTION,
	ADD CONSTRAINT messages_to_user_id_fk
		FOREIGN KEY (to_user_id) REFERENCES users(id)
			ON DELETE NO ACTION;

#Задание 2
#Создать и заполнить таблицы лайков и постов.

DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  target_id INT UNSIGNED NOT NULL,
  target_type_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO target_types (name) VALUES 
  ('messages'),
  ('users'),
  ('media'),
  ('posts');
 
 INSERT INTO likes 
  SELECT 
    id, 
    FLOOR(1 + (RAND() * 100)), 
    FLOOR(1 + (RAND() * 100)),
    FLOOR(1 + (RAND() * 4)),
    CURRENT_TIMESTAMP 
  FROM messages;
 
CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  community_id INT UNSIGNED,
  head VARCHAR(255),
  body TEXT NOT NULL,
  media_id INT UNSIGNED,
  is_public BOOLEAN DEFAULT TRUE,
  is_archived BOOLEAN DEFAULT FALSE,
  views_counter INT UNSIGNED DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (1, 77, 8, 'owxz', 'Amet in fugit qui quod unde esse qui rerum. Et ducimus consequatur sit natus eligendi. Numquam sunt odio ut in vero id odio.', 67, 1, 1, 441, '2006-03-13 20:38:56', '1971-12-05 06:21:22');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (2, 20, 6, 'kpof', 'Deserunt repellendus et corrupti voluptas omnis. Molestiae laboriosam sint facere fugit voluptatem et incidunt. Veritatis ratione provident omnis iste velit velit maiores. Mollitia voluptatum consequuntur ut recusandae.', 47, 1, 1, 432, '2009-04-01 13:09:24', '1971-04-05 20:35:00');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (3, 72, 6, 'qmym', 'Tempora sunt nesciunt unde eveniet. Tempora aut aperiam qui voluptate atque. Nemo omnis itaque voluptas autem et recusandae.', 96, 0, 1, 827, '1984-01-09 07:45:47', '1984-09-02 22:57:36');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (4, 35, 3, 'hloq', 'Sunt est nam illum consectetur qui. Omnis ea autem est nulla aliquid cupiditate porro et. Quia molestias similique voluptate adipisci et a incidunt.', 41, 0, 1, 37, '1998-05-24 09:16:55', '1995-04-27 11:55:50');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (5, 16, 5, 'avwe', 'Sit et qui occaecati minus qui. Voluptatem odit et blanditiis voluptatem perspiciatis inventore.', 29, 0, 0, 437, '1988-02-28 08:25:02', '1997-11-13 19:57:44');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (6, 68, 8, 'zzln', 'Est ipsum voluptate animi ea modi pariatur. Ab atque corrupti blanditiis. Sed suscipit et rerum eos. In natus reiciendis mollitia.', 25, 0, 0, 536, '1996-01-12 07:30:45', '1986-12-09 16:20:39');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (7, 18, 7, 'wiqj', 'Illum qui atque aut est rem ut. Quis provident fugit omnis. Repellendus sint consectetur laborum. A ipsa a asperiores delectus illum quis numquam.', 66, 1, 0, 992, '1994-07-17 13:02:40', '1982-03-23 22:06:00');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (8, 49, 7, 'mkpw', 'Sit reprehenderit quia commodi qui quasi. Explicabo a et molestiae. Necessitatibus odio nostrum officiis. Impedit provident est architecto placeat ullam tempora.', 72, 0, 0, 120, '2020-01-13 15:34:15', '1997-06-16 19:20:33');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (9, 19, 8, 'tjwg', 'Dolor et tenetur alias a. Tenetur tempora dolores inventore minus. Et et quis omnis quia non qui tenetur occaecati. Aut porro cupiditate est error. Vel voluptatem eum omnis eligendi hic voluptas et.', 14, 0, 1, 810, '1989-10-23 06:02:56', '1983-06-21 19:21:05');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (10, 71, 7, 'qaxz', 'Repudiandae accusamus tempora sint tempora temporibus eos. Soluta ut amet aperiam id voluptates minima. Amet et tempore ipsam qui illum at aspernatur. Cumque veritatis vel voluptas possimus amet dolorem aut.', 89, 0, 1, 630, '1991-11-07 10:18:32', '2002-04-16 05:02:39');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (11, 16, 2, 'kqqm', 'Facere sunt autem quis deleniti est. Voluptatem aliquid voluptate aut molestiae sapiente inventore veniam. Hic est est odit consequatur. Rerum consequatur sit et voluptatem dolores id.', 90, 0, 1, 58, '1998-12-20 05:04:47', '1971-02-10 07:04:24');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (12, 76, 5, 'xqfu', 'Ab est iure autem eum et. Unde qui quasi amet cupiditate suscipit molestiae. Voluptas porro nostrum voluptate explicabo totam quo.', 94, 0, 1, 456, '1997-04-04 11:00:47', '1996-07-21 17:38:03');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (13, 77, 4, 'lgob', 'Incidunt sunt sed eum non nemo ullam quasi. Sapiente sint fuga officiis enim exercitationem atque. Sit incidunt neque error ratione.', 78, 0, 1, 870, '1974-11-10 22:00:38', '1995-04-04 15:44:34');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (14, 48, 4, 'uisw', 'Nesciunt consequuntur in sapiente. Reiciendis autem aut in cumque consequuntur quis.', 49, 1, 1, 83, '1984-10-05 12:01:49', '2009-03-10 13:37:39');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (15, 48, 6, 'rpgy', 'Aut esse et dignissimos est possimus laboriosam. Maiores quia nobis velit unde sed qui incidunt quasi. Dolore nihil aliquam autem non voluptas blanditiis ab. Odio ea laudantium eos praesentium cum.', 21, 1, 0, 609, '2006-10-15 13:32:35', '1990-07-19 19:39:24');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (16, 67, 6, 'eubg', 'Nobis commodi repellat laboriosam sed pariatur ea sit. Quisquam nobis voluptatem voluptatem est. Dolores eaque numquam quo. Minus consequatur tenetur porro incidunt.', 44, 1, 0, 555, '1997-02-13 14:30:58', '2014-12-28 16:00:00');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (17, 57, 6, 'noff', 'Quasi aut porro quis. Sint et voluptas beatae facilis autem impedit. Minus incidunt quae et. Temporibus ut similique reprehenderit ut consectetur veniam explicabo. Dolorem aut rem nam at.', 55, 1, 0, 505, '1993-08-30 15:17:01', '1970-09-20 08:27:11');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (18, 49, 5, 'stac', 'Aliquid fugiat est assumenda facilis ex voluptate nam. Commodi illum aut qui quo dignissimos. Aut molestiae itaque quos doloribus et expedita et. Perferendis et deserunt tempora totam non voluptates aspernatur.', 88, 1, 1, 727, '2018-12-18 18:07:59', '1974-10-23 23:51:19');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (19, 32, 3, 'oqmw', 'Laudantium minima velit reiciendis earum odit dolor error molestiae. Numquam beatae ipsum atque. Eos molestiae in voluptatem adipisci eum.', 69, 1, 1, 697, '2011-03-07 14:35:53', '2014-12-27 19:55:08');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (20, 74, 8, 'pjha', 'Vel aut et quasi omnis magnam voluptatibus. Suscipit atque nemo quia officiis. Velit porro rerum est laborum ut quia et. Maiores numquam illum veniam omnis.', 86, 0, 1, 724, '1972-09-30 07:14:13', '2002-07-12 07:23:59');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (21, 34, 3, 'wbyx', 'Tempora et id consectetur officia consectetur id. Et et voluptatibus culpa esse. Eligendi amet mollitia eaque laborum deleniti temporibus. Voluptatem omnis ut quis.', 42, 0, 1, 167, '1981-03-29 21:04:45', '2004-09-22 09:18:20');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (22, 58, 6, 'qcnr', 'Labore voluptatem ut ipsum error voluptas alias modi. Blanditiis porro ducimus laboriosam porro. Et quo nesciunt perferendis quasi aliquid aut. Sequi et dolor rerum error fugit.', 79, 1, 1, 976, '1987-04-10 19:55:58', '1998-08-04 22:01:35');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (23, 48, 6, 'jstx', 'Mollitia dolor veritatis eum unde expedita qui omnis quasi. Commodi officiis aut nesciunt maxime. Sint eos dignissimos cum quod sunt. Sed est aut ab veniam adipisci ut dolore in.', 92, 0, 1, 373, '2005-09-02 04:00:34', '1993-03-24 11:15:32');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (24, 66, 6, 'dsdj', 'Eaque nihil omnis vero quis harum consectetur. Quia accusamus et ut voluptatem omnis laudantium. Occaecati magnam aperiam qui rerum ullam. Rerum aperiam sunt vero.', 53, 0, 1, 182, '1989-04-19 09:07:12', '1975-01-14 08:44:57');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (25, 88, 5, 'bfey', 'Quis quae sequi ullam et accusantium ut. Dolorem dolore sequi aut et.', 47, 1, 0, 108, '2013-09-17 08:52:30', '2011-05-16 19:05:30');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (26, 97, 5, 'mjnz', 'Nobis aut qui voluptas ea. Dicta quis dicta modi alias minima ducimus quia. Omnis aut omnis reiciendis iure impedit quisquam temporibus deserunt. Blanditiis est nobis sed minima.', 43, 1, 0, 508, '2014-09-30 10:12:04', '1976-02-01 23:34:09');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (27, 4, 1, 'kxpc', 'Quia laboriosam animi asperiores architecto eos eveniet. Suscipit architecto doloremque rem. Aut maiores est suscipit rem placeat laudantium.', 31, 1, 0, 954, '1971-12-26 21:39:35', '1986-02-08 05:21:55');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (28, 2, 4, 'hjsy', 'Laboriosam magni laudantium facilis qui a enim. Et qui sint animi nisi et aperiam nam. Et ab dolorem et et et pariatur.', 75, 1, 1, 578, '1970-10-31 19:22:50', '1997-01-21 09:56:39');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (29, 91, 4, 'znae', 'Officia perspiciatis corporis alias illo. Asperiores molestiae quibusdam molestiae voluptas placeat sequi suscipit. Voluptatem aut alias explicabo dolores mollitia.', 71, 1, 1, 697, '2018-04-16 12:57:04', '1985-06-03 09:44:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (30, 75, 6, 'krla', 'Voluptates voluptatem est est ipsa rerum veritatis. Sit ex aut et neque magni est. Est iusto cumque totam voluptatem dolores. Sunt dolor blanditiis et ab quia et quasi odio.', 77, 1, 0, 652, '1984-12-31 20:11:17', '1991-07-30 01:13:10');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (31, 74, 4, 'ikjh', 'Odit recusandae sed voluptatem reprehenderit consequuntur et aut in. Omnis nisi et omnis et consequatur vel. Occaecati eveniet et molestiae debitis quia voluptas aut. Ut et officia ut est tempora et perspiciatis neque. Tenetur repellendus autem nam numquam ratione neque nihil esse.', 45, 1, 0, 743, '2005-05-11 07:49:54', '1990-10-29 07:49:35');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (32, 98, 3, 'ajpw', 'Sapiente enim harum sit harum ducimus consequatur quis. Soluta quaerat sint modi dolores occaecati recusandae tempora.', 50, 1, 1, 485, '1981-11-07 07:04:10', '2007-10-13 21:53:53');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (33, 23, 5, 'lvur', 'Nesciunt deleniti iste voluptas atque voluptas sit impedit. Quas qui quis nam in ab corrupti consequatur in. Nisi officiis et est.', 17, 1, 0, 867, '1983-05-04 11:25:12', '2012-04-26 18:30:10');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (34, 39, 2, 'dhyu', 'Odio quis aut repellat cupiditate. Odit modi dolorem voluptatem ut qui omnis delectus. Aut perferendis sequi reiciendis. Sit odit animi temporibus sunt. Accusantium non omnis perferendis omnis necessitatibus qui.', 22, 0, 1, 5, '1989-02-03 08:07:02', '1997-05-02 04:51:22');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (35, 22, 1, 'dfhu', 'Eveniet facilis necessitatibus sequi minus. Cum temporibus eos illum inventore. Omnis quos nulla asperiores dignissimos id libero. Dolore enim quas consectetur.', 81, 1, 1, 244, '1987-06-29 12:46:34', '2011-08-22 23:28:45');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (36, 91, 6, 'ghdu', 'Tempore et vitae vitae culpa eius. Ut temporibus incidunt cumque animi delectus molestiae et nesciunt. Vitae illum eaque consequatur quidem veniam voluptatum.', 3, 0, 1, 154, '2020-02-01 16:59:50', '1975-12-11 07:30:05');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (37, 8, 6, 'iaeg', 'Molestiae ipsum non aut laboriosam commodi. Impedit quae neque aliquid voluptatem. Aut beatae animi consequatur. Natus error et enim rerum.', 5, 0, 1, 188, '1978-05-07 18:25:48', '1981-07-18 13:21:10');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (38, 53, 2, 'ntrw', 'Enim aut est repellat quasi ea iusto accusamus iusto. Nihil nam occaecati ipsum et. Quam aspernatur debitis vero dicta asperiores molestiae. Dolorum cumque temporibus recusandae qui perspiciatis animi.', 40, 1, 0, 433, '2005-02-22 18:31:57', '1983-08-28 23:50:56');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (39, 23, 3, 'zemz', 'Velit rerum explicabo laborum iste est. Non totam aut possimus in fuga veritatis. Quo voluptas asperiores assumenda ducimus dolorem molestiae et commodi. Suscipit tempora excepturi molestiae et.', 31, 1, 1, 799, '1985-11-03 15:38:36', '1977-04-28 20:48:36');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (40, 29, 6, 'zlru', 'Molestias occaecati maiores deleniti expedita. Corrupti vel doloribus fugiat. Velit non illum consequatur. Commodi quia suscipit et ex illo deleniti voluptate.', 4, 0, 1, 142, '1993-01-18 12:38:21', '1976-10-16 03:59:21');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (41, 45, 5, 'jszz', 'Sit fugiat minima omnis autem aperiam. Numquam et nulla sunt repellendus sit error. Molestias maiores sunt et omnis nostrum. Et mollitia qui fugit molestiae et incidunt occaecati et. Sint quae sit aspernatur cupiditate.', 13, 1, 1, 918, '2005-05-21 16:15:23', '2005-03-20 10:12:22');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (42, 30, 5, 'gdsa', 'Est id esse ratione rerum et nihil. Voluptates voluptatibus architecto rerum iure odio. Ratione non nisi dolorem similique sit sint aut recusandae. Enim numquam quo consequatur laborum fugiat laudantium repudiandae.', 34, 1, 1, 623, '1972-10-27 06:38:45', '1984-07-05 12:36:42');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (43, 63, 1, 'wqye', 'Neque esse enim voluptas pariatur. Saepe adipisci in error nostrum et incidunt veniam. Eius aut nam dolorum.', 58, 1, 1, 358, '2016-07-15 22:48:49', '1974-12-14 22:01:19');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (44, 88, 4, 'gzvc', 'Vel quia reiciendis doloremque. Iure quas provident est sint quia soluta aperiam.', 34, 1, 1, 411, '2004-07-18 01:22:50', '2008-10-22 00:28:08');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (45, 41, 5, 'byje', 'Assumenda amet ut tempore quidem molestiae aut omnis nisi. Consequatur aperiam expedita veritatis vero sed. Laborum et fugiat reiciendis tenetur error.', 52, 0, 0, 708, '1993-07-11 01:08:21', '1983-11-24 06:31:57');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (46, 66, 1, 'ermy', 'Voluptatem laudantium quos facere impedit iusto ex molestiae. Laboriosam nemo molestiae perspiciatis quibusdam cupiditate.', 32, 1, 0, 137, '1987-03-17 00:50:00', '1991-04-23 01:22:58');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (47, 27, 5, 'whwd', 'Velit et earum asperiores. Nostrum quia maxime ut praesentium quidem rerum rerum. Est iusto ullam mollitia sint. Doloribus quasi et molestias enim perspiciatis quasi ab hic.', 35, 1, 0, 548, '2020-04-15 09:38:47', '1981-01-09 09:25:15');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (48, 69, 3, 'xqak', 'Sit vero quia numquam et expedita qui aut illum. Ratione est ipsam praesentium consectetur natus tenetur dolorum. Sed ut temporibus aut ea id. Excepturi sequi expedita quasi nihil aut necessitatibus.', 67, 0, 1, 735, '1971-11-24 20:26:00', '1976-07-08 10:27:30');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (49, 11, 5, 'bbnb', 'Fugiat cum ratione similique et. Mollitia aut repellat quasi et inventore. Ut laborum assumenda est neque voluptatem sit. Numquam rem perspiciatis aut ut amet temporibus dolorum.', 2, 0, 1, 315, '1983-08-14 10:21:18', '2008-09-03 09:55:43');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (50, 8, 8, 'qneg', 'Quidem dolorum dicta voluptates rem a ipsa qui libero. Blanditiis impedit aut fugit libero est. Perspiciatis a rerum illo fuga dolorem.', 29, 1, 0, 32, '1985-10-29 15:55:15', '1987-11-23 00:55:24');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (51, 75, 8, 'ozla', 'Voluptatum eius unde et qui. Aut dolor voluptatum iste mollitia. Placeat quia omnis minima debitis. Ea rerum pariatur aliquid reiciendis.', 16, 0, 0, 299, '1974-03-21 07:12:43', '1997-06-09 04:05:03');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (52, 91, 2, 'pdqk', 'Cupiditate nostrum sequi aut sed quia. Vel et officiis necessitatibus odit totam et architecto dolores. Quas iste assumenda assumenda aspernatur expedita praesentium. Et deleniti maiores accusamus eum ratione perferendis.', 82, 1, 0, 846, '1975-02-10 23:22:47', '1978-11-17 11:28:15');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (53, 23, 8, 'mehh', 'Qui voluptatem voluptas nulla maiores sint deleniti. Non animi et et inventore. Sit culpa est in excepturi cum et. Non eum quasi reprehenderit laboriosam.', 59, 0, 0, 206, '1995-11-27 23:52:35', '2001-04-04 06:33:34');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (54, 85, 6, 'yynw', 'Quis rem voluptas cum. Omnis qui natus non placeat. Velit in voluptatibus consectetur repellendus magnam est soluta sit. Est at sint nemo saepe.', 8, 1, 0, 138, '2007-08-01 22:50:15', '2013-09-16 22:28:14');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (55, 81, 4, 'txwz', 'Perferendis rerum sapiente impedit ut. Numquam magnam incidunt nesciunt et. Ratione id doloremque vitae illo. Id ratione reprehenderit et recusandae est quibusdam.', 96, 0, 1, 292, '2013-12-20 17:51:43', '1976-04-07 18:01:40');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (56, 58, 7, 'laex', 'Provident impedit non quidem quae sunt voluptas odit. Quia minus labore exercitationem dolorem ullam voluptatibus. Et qui omnis alias quia. Amet aut voluptatum nobis molestias.', 75, 0, 1, 960, '2017-09-29 14:52:35', '1984-07-02 02:54:55');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (57, 16, 2, 'keix', 'Ut quo dicta eum aliquid eum. A vel aliquam in sapiente veritatis animi inventore. Delectus hic voluptas deleniti et ipsa ullam sapiente. Explicabo voluptatem suscipit consectetur molestiae omnis veritatis suscipit.', 67, 0, 0, 850, '1982-11-28 11:39:30', '1985-03-12 02:48:50');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (58, 75, 5, 'rqge', 'Alias rerum molestiae sed enim eaque minus. Architecto assumenda cupiditate neque quidem odio exercitationem ut. Debitis voluptas autem reprehenderit aliquam ea impedit aspernatur est.', 73, 0, 0, 529, '1972-11-30 04:06:15', '2007-12-31 23:37:01');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (59, 62, 1, 'qwbc', 'A omnis in aut est non. Explicabo rerum aut omnis ut nihil. Laborum culpa accusantium autem dolore.', 91, 0, 1, 410, '2017-04-01 23:26:25', '1990-09-17 17:39:55');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (60, 29, 2, 'ljpb', 'Quisquam dolorem ratione quod. Omnis illo sint illo fuga molestias voluptate aspernatur. Quos sit consequatur dignissimos possimus qui. Tempora voluptatem vitae quis necessitatibus.', 11, 1, 0, 220, '1984-02-19 18:00:54', '1970-12-21 07:47:58');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (61, 68, 5, 'jamh', 'Inventore ab aliquid accusantium corrupti consequatur. Quasi voluptas iure sequi atque voluptatibus nisi vitae. Et ipsum nesciunt et eum. Qui autem tenetur dignissimos sed ipsum laudantium.', 55, 0, 0, 857, '2005-02-03 13:48:45', '1979-12-24 17:52:13');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (62, 22, 4, 'tlqb', 'Aut sed cum consequatur et dolores et autem. Quod sit minus laudantium velit inventore rerum ducimus. Laborum ea est dignissimos pariatur molestiae nemo.', 36, 0, 1, 701, '1989-02-12 20:39:57', '2014-03-08 07:11:55');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (63, 60, 4, 'hwyd', 'Rerum aut rerum et aperiam. Mollitia vitae laboriosam ut quaerat et id. Dignissimos repellendus in aut.', 64, 1, 1, 614, '1984-01-16 09:21:02', '1986-11-14 11:33:16');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (64, 37, 8, 'tjof', 'Nisi a molestias culpa et sed reprehenderit nobis autem. Ut illo et possimus quo qui. Ipsum ab commodi nobis dolores repellendus. Ut ut eveniet quia voluptatem rem.', 7, 1, 1, 317, '1993-01-06 13:02:03', '1983-02-13 06:46:00');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (65, 100, 8, 'jjtq', 'Minus quis corporis rerum doloremque. Ullam nam voluptatem libero omnis omnis dolorem ut sint. Soluta dolor et harum totam rerum id.', 67, 1, 1, 589, '1986-03-04 13:38:11', '1989-12-01 13:55:45');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (66, 47, 5, 'qqqi', 'Reprehenderit asperiores in a dolores. Eius culpa alias vel odit. Repudiandae perferendis voluptatem et sint.', 20, 1, 0, 865, '2016-04-04 20:27:41', '2017-03-26 10:56:00');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (67, 86, 4, 'youz', 'Ratione cum et deleniti nobis consequatur minus ab est. Animi qui et doloribus ad. Est exercitationem laboriosam repellendus ut reiciendis.', 39, 0, 1, 881, '1999-05-31 10:35:52', '1987-03-08 01:41:54');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (68, 85, 5, 'xpxs', 'Voluptatem et assumenda fugiat fugit. Ea totam at officia minima id.', 97, 1, 1, 844, '1988-07-11 12:36:41', '2011-06-11 03:18:50');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (69, 31, 5, 'vwgj', 'Asperiores voluptatem et quae nemo voluptates qui labore. Sequi nobis aut qui voluptates tempora nesciunt. Ratione ut ipsam eos voluptatem. Dolor ut porro nemo qui et natus quo.', 23, 0, 0, 488, '2006-03-05 05:12:58', '2014-07-28 21:20:15');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (70, 31, 4, 'tuzx', 'Sint optio qui ut et veritatis. Reiciendis perspiciatis fugiat eius quo quas et fugiat. Sed quo et iste rerum veniam ratione. Possimus quisquam iste veritatis veritatis sed reiciendis rem vel.', 78, 1, 1, 72, '1973-01-21 22:06:24', '1979-10-31 09:47:13');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (71, 13, 7, 'tlna', 'Voluptas sapiente labore qui quaerat blanditiis aut sequi. Consequatur maiores quae molestias. Quis exercitationem ipsa est qui illum mollitia. Est aut ullam alias velit voluptates est.', 76, 0, 1, 707, '2015-10-02 08:45:43', '2013-05-22 11:40:46');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (72, 87, 2, 'itmx', 'Et ex tempore eum veniam vitae. Natus voluptatibus et et minima illo adipisci. Sed iste id repellendus inventore reprehenderit qui. Dolores accusantium impedit ut vel sed corrupti temporibus.', 39, 1, 0, 47, '2003-09-11 10:49:34', '1972-12-18 08:24:00');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (73, 61, 2, 'qupu', 'Eveniet iste id dignissimos. Deserunt consequuntur ut sed. Ad et beatae rerum in non. Natus provident enim in consequatur et.', 88, 1, 0, 746, '1972-02-15 01:10:59', '1983-09-02 20:41:05');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (74, 100, 3, 'jrsx', 'Fuga debitis et maiores in vero ea qui. Perferendis et rerum id.', 47, 0, 0, 930, '1989-12-01 12:40:57', '1999-05-19 15:23:32');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (75, 73, 8, 'jkbf', 'Vel provident et quisquam quis consequatur officia. Occaecati libero assumenda ut eveniet.', 66, 1, 0, 872, '1997-11-08 00:45:49', '1984-05-02 12:07:33');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (76, 41, 8, 'cqph', 'Deleniti velit dolorem est aut inventore nesciunt pariatur omnis. Harum enim fugit iure blanditiis.', 23, 1, 0, 885, '1983-03-22 04:51:46', '1989-07-25 19:53:17');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (77, 99, 3, 'xzzp', 'Quis sint dolor molestiae ut et modi. Quia magni qui blanditiis laudantium ut. A magnam assumenda et corrupti incidunt eos cumque est. Illo ea beatae nulla voluptatem.', 68, 0, 1, 494, '2007-07-18 00:54:01', '2002-03-07 16:51:14');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (78, 68, 8, 'pvkq', 'In dolorum autem dicta aut ad in quo. Quia odit omnis quis provident consequuntur. Alias ipsam nemo eos aut.', 45, 1, 0, 336, '2012-04-21 23:21:56', '1991-07-28 05:48:10');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (79, 95, 7, 'pnpa', 'Quos minima aliquam quis magnam a voluptate mollitia tempora. Eligendi dolor aut dolorum qui earum perspiciatis veniam. Molestiae molestias neque doloribus velit quo necessitatibus quis. Optio fugiat necessitatibus quos praesentium.', 44, 1, 1, 907, '1973-10-08 21:14:21', '1976-10-24 09:16:15');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (80, 41, 8, 'nsdo', 'Magnam cumque quos et qui quae itaque. Laudantium veritatis ut nihil corporis ut et. Ipsam quae nihil asperiores minus. Molestiae pariatur voluptas aliquam cum velit itaque doloribus.', 55, 1, 0, 311, '1989-12-11 11:37:25', '2016-10-12 04:04:20');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (81, 42, 6, 'htop', 'Voluptatum odit vel et non et illum. Consequatur nemo expedita unde deserunt omnis quisquam ea.', 16, 1, 1, 116, '1994-01-28 13:27:37', '1991-07-28 04:26:31');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (82, 22, 1, 'gpax', 'Nobis quae provident id debitis quia eaque. Accusamus officia earum quaerat id aspernatur. Quasi labore magni aut qui aspernatur rerum laboriosam repellendus. Officia assumenda dolores laborum rerum quo dolor voluptatem labore. Repudiandae et inventore quidem cum laborum.', 87, 1, 1, 128, '2000-10-30 09:12:31', '2010-01-14 20:22:33');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (83, 91, 8, 'corg', 'Ducimus quidem aliquid vel possimus temporibus qui reiciendis. Ipsa vel recusandae sed facilis odit sit. Debitis molestias provident tempora ut ea harum voluptatem.', 8, 0, 0, 698, '2009-02-12 04:18:08', '1983-11-13 17:00:55');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (84, 96, 2, 'fytj', 'Eveniet praesentium quis omnis autem. Iure neque esse praesentium non voluptatem atque. Aut voluptatem omnis alias ratione ipsum distinctio doloremque.', 62, 0, 0, 982, '1973-01-08 15:25:15', '2000-12-01 07:00:09');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (85, 14, 3, 'iejc', 'Unde nesciunt temporibus quas doloribus maiores dolor reiciendis. Eveniet similique mollitia error sint. Placeat tenetur iste velit atque voluptates. Consequuntur molestiae tenetur expedita est sapiente dolorum dolores.', 75, 0, 0, 685, '1987-09-15 09:39:32', '2017-12-08 02:25:13');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (86, 87, 7, 'zohp', 'Eligendi animi nesciunt eius nulla veniam consectetur. At ut est voluptatem consequatur veniam voluptatem saepe animi. Fuga quia earum eos. Tenetur placeat ipsum aperiam et cumque et ut.', 19, 1, 0, 280, '1985-09-02 01:03:06', '2002-10-13 18:19:31');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (87, 100, 3, 'uvrp', 'Provident est id necessitatibus placeat deserunt. Et ut non asperiores hic. Non cum distinctio voluptatum tempora. Error earum ex sed quo officia aut.', 58, 1, 0, 650, '2005-11-30 15:36:48', '1974-03-22 12:22:09');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (88, 52, 4, 'ellg', 'Architecto hic eum quibusdam eos doloremque blanditiis ut. Dignissimos maxime et aut maiores temporibus. Dolores alias dolor suscipit ut voluptatem.', 44, 1, 0, 831, '1995-10-05 09:40:14', '2000-01-01 04:34:34');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (89, 71, 7, 'koxw', 'Sequi occaecati numquam hic autem consequatur. Ut laboriosam quia id facilis consequatur repellendus. Tempora quia quis labore pariatur. Molestiae voluptas consequuntur necessitatibus recusandae rerum natus nesciunt repudiandae.', 10, 0, 0, 329, '2005-02-11 01:22:08', '2009-11-11 16:09:20');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (90, 17, 5, 'tzfh', 'Distinctio quae omnis debitis optio ea omnis aspernatur. Numquam sed dolor est. Illum sunt modi deserunt odit est.', 66, 0, 1, 483, '1975-12-21 17:29:37', '1994-10-02 21:31:38');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (91, 27, 2, 'erfv', 'Vero beatae eos nihil velit nihil. Provident delectus sed occaecati error.', 2, 1, 0, 276, '1979-01-12 12:05:59', '1991-10-04 21:50:50');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (92, 86, 5, 'xmsg', 'Sit rerum unde provident quis nesciunt. Itaque ullam nobis et. Qui itaque laborum repellat vitae.', 8, 1, 0, 638, '1998-02-24 19:28:12', '1978-12-23 21:08:38');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (93, 49, 4, 'qnnd', 'Minima exercitationem temporibus eum rerum dicta reprehenderit. Inventore velit molestias officia voluptatem.', 13, 0, 1, 2, '2008-05-22 18:47:35', '1985-04-25 14:50:33');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (94, 19, 2, 'zrcp', 'Ea illum molestiae veniam tempore. Fuga in soluta distinctio maiores. Aut nesciunt eum similique enim porro sequi qui.', 56, 0, 1, 507, '2006-02-05 16:53:05', '2007-10-22 02:26:11');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (95, 61, 3, 'trbi', 'Vel mollitia ut sunt ut explicabo magni. Debitis cumque ducimus velit necessitatibus. Odit ut sit voluptas eveniet dolorem fugiat autem.', 15, 1, 0, 499, '2012-09-16 09:39:48', '2015-06-13 23:57:49');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (96, 7, 4, 'xfxr', 'Enim omnis porro harum quaerat est porro culpa voluptatem. Est harum ut optio ut dolor non.', 17, 0, 1, 229, '1981-03-28 15:12:16', '1981-03-31 11:49:04');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (97, 49, 1, 'jrpu', 'Explicabo maxime modi explicabo odit ullam ipsam enim quaerat. Illum et alias harum. Accusamus sed sunt officia fuga.', 22, 1, 1, 324, '1992-08-27 21:35:44', '1973-09-14 18:33:37');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (98, 53, 1, 'yhpd', 'Et praesentium at non modi similique maiores cupiditate. Et a officiis neque voluptas dolore fugiat. Consequuntur eum rem sapiente sint quasi.', 32, 1, 1, 133, '1992-03-28 20:06:00', '1983-12-12 03:40:57');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (99, 71, 3, 'uyjb', 'Hic rem ex accusamus odio et cumque. Maxime est nihil nemo. Odio modi rem sunt non molestias. Distinctio dolor eaque suscipit cum quidem magni.', 28, 1, 1, 307, '2004-10-30 21:52:23', '1976-12-19 18:13:55');
INSERT INTO `posts` (`id`, `user_id`, `community_id`, `head`, `body`, `media_id`, `is_public`, `is_archived`, `views_counter`, `created_at`, `updated_at`) VALUES (100, 63, 8, 'qqez', 'Cumque aut repudiandae distinctio commodi sed facilis. Debitis sint reprehenderit nostrum earum reiciendis.', 27, 0, 0, 194, '2004-11-29 22:29:00', '1975-03-19 14:06:41');

ALTER TABLE likes
	ADD CONSTRAINT likes_user_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
			ON DELETE NO ACTION,
	ADD CONSTRAINT likes_target_type_id_fk
		FOREIGN KEY (target_type_id) REFERENCES target_types(id)
			ON DELETE NO ACTION;


ALTER TABLE posts
	ADD CONSTRAINT posts_user_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
			ON DELETE SET DEFAULT,
	ADD CONSTRAINT posts_community_id_fk
		FOREIGN KEY (community_id) REFERENCES communities(id)
			ON DELETE SET DEFAULT,
	ADD CONSTRAINT posts_media_id_fk
		FOREIGN KEY (media_id) REFERENCES media(id)
			ON DELETE SET DEFAULT;
		
#Задание 3
#Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT * FROM likes;

SELECT gender, COUNT(gender)
FROM profiles
WHERE user_id IN (SELECT user_id FROM likes)
GROUP BY gender;

#Задание 4
#Подсчитать общее количество лайков десяти самым молодым пользователям 
#(сколько лайков получили 10 самых молодых пользователей).

SELECT * FROM likes;

SELECT target_id AS Номер_поста , COUNT(target_id) AS Количество_лайков
FROM likes
GROUP BY target_id;# количество лайков , которые набрали посты

SELECT user_id
FROM profiles
ORDER BY birthday DESC LIMIT 10;

SELECT SUM(likes) 
FROM (SELECT 
	(SELECT COUNT(id) FROM likes WHERE user_id = profiles.user_id) AS young_likes
	FROM profiles
	ORDER BY birthday DESC LIMIT 10) AS res;


# Задание 5
#Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети
#(критерии активности необходимо определить самостоятельно).

SELECT id, first_name, last_name
FROM users
WHERE id NOT IN (SELECT from_user_id FROM messages)
ORDER BY id;# по наличию отправителей сообщения

SELECT id, first_name, last_name
FROM users
WHERE id NOT IN (SELECT user_id FROM posts)# те кто не выкладывал посты
