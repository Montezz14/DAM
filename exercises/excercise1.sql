
USE EXcerciseVideogames;
CREATE TABLE users (
id INT8,
name Text,
email Text,
nick Text,
login Text,
password Text,
birthdate Date, 
PRIMARY KEY (id)
);
CREATE TABLE games(
id INT8,
code text,
name text,
description text,
rules text,
PRIMARY KEY(id)
);
CREATE TABLE avatars(

id INT8,
user_id INT8,
game_id INT8,
appereance text,
level INT4,
PRIMARY KEY(id)
);
CREATE TABLE matches(
id INT8,
game_id INT8,
name text,
password text,
created_at date,
status text,
creator_avatar_id int8,
PRIMARY KEY (id));
CREATE TABLE confrontations(     
id INT8,
match_id INT8,
avatar1_id INT8,
avatar2_id INT8,
result text,
PRIMARY KEY (id));
CREATE TABLE match_participants(
match_id INT8,
avatar_id INT8,
PRIMARY KEY(avatar_id,match_id)
);
SELECT  users.id
FROM users
JOIN avatars
ON avatars.user_id;
select games.id
From games
JOIN avatars
ON avatars.game_id;
SELECT games.id
From games
JOIN matches
ON matches.games_id;
SELECT avatars.id
From avatars 
Join matches
ON matches.id;
SELECT avatars.id
From avatars 
Join matches
ON matches.creator_avatar_id;
select matches.id
From matches
JOIN match_participants
ON avatar_id;
select matches.id
From matches
JOIN match_participants
ON  match_id;
select matches.id
From matches
JOIN confrontations
ON match_id;
select matches.creator_avatar_id
From matches
Join confrontations
ON avatar1_id;
select matches.creator_avatar_id
From matches
Join confrontations
ON avatar2_id;



