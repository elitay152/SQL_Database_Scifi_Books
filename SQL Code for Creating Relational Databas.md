SQL Code for Creating Relational Database

---in command line with posgresql---

postgres=# CREATE DATABASE science_fiction;
CREATE DATABASE

---the \l command lists all databases---

postgres=# \l
                                                                   List of databases
      Name       |  Owner   | Encoding |          Collate           |           Ctype            | ICU Locale | Locale Provider |   Access privileges
-----------------+----------+----------+----------------------------+----------------------------+------------+-----------------+-----------------------
 Covid_Dashboard | postgres | UTF8     | English_United States.1252 | English_United States.1252 |            | libc            |
 d211            | postgres | UTF8     | English_United States.1252 | English_United States.1252 |            | libc            |
 postgres        | postgres | UTF8     | English_United States.1252 | English_United States.1252 |            | libc            |
 science_fiction | postgres | UTF8     | English_United States.1252 | English_United States.1252 |            | libc            |
 template0       | postgres | UTF8     | English_United States.1252 | English_United States.1252 |            | libc            | =c/postgres          +
                 |          |          |                            |                            |            |
        | postgres=CTc/postgres
 template1       | postgres | UTF8     | English_United States.1252 | English_United States.1252 |            | libc            | =c/postgres          +
                 |          |          |                            |                            |            |
        | postgres=CTc/postgres
(6 rows)

---\c command connects to specific database

postgres=# \c science_fiction
You are now connected to database "science_fiction" as user "postgres".

---create first table, specifying data types and primary key---

science_fiction=# CREATE TABLE languages (
science_fiction(# lang_id SERIAL NOT NULL PRIMARY KEY,
science_fiction(# language VARCHAR(20) NOT NULL UNIQUE
);

---view table contents---

science_fiction=# \d languages
                                       Table "public.languages"
  Column  |         Type          | Collation | Nullable |                  Default
----------+-----------------------+-----------+----------+--------------------------------------------
 lang_id  | integer               |           | not null | nextval('languages_lang_id_seq'::regclass)
 language | character varying(20) |           | not null |
Indexes:
    "languages_pkey" PRIMARY KEY, btree (lang_id)
    "languages_language_key" UNIQUE CONSTRAINT, btree (language)

science_fiction=# CREATE TABLE authors (
science_fiction(# auth_id SERIAL NOT NULL PRIMARY KEY,
science_fiction(# authors VARCHAR(50) NOT NULL UNIQUE);
CREATE TABLE

science_fiction=# CREATE TABLE genres (
science_fiction(# genre_id SERIAL NOT NULL PRIMARY KEY,
science_fiction(# genre VARCHAR(50) NOT NULL UNIQUE);
CREATE TABLE

---now I can set up the books table, which has foreign keys that reference the above tables---

science_fiction=# CREATE TABLE books (
science_fiction(# book_id BIGSERIAL NOT NULL PRIMARY KEY,
science_fiction(# book_title VARCHAR(200) NOT NULL,
science_fiction(# auth_id INT NOT NULL REFERENCES authors(auth_id),
science_fiction(# genre_id INT REFERENCES genres(genre_id),
science_fiction(# lang_id INT REFERENCES languages(lang_id),
science_fiction(# year_published INT,
science_fiction(# url VARCHAR(500) NOT NULL UNIQUE);
CREATE TABLE

---then I can add the last two tables, both of which reference the books table---

science_fiction=# CREATE TABLE descriptions (
science_fiction(# book_id INT NOT NULL REFERENCES books(book_id),
science_fiction(# description TEXT);
CREATE TABLE

science_fiction=# CREATE TABLE ratings (
science_fiction(# book_id INT NOT NULL REFERENCES books(book_id),
science_fiction(# rating_score NUMERIC,
science_fiction(# rating_votes INT,
science_fiction(# num_ratings INT);

---view database contents---

science_fiction=# \d
                  List of relations
 Schema |         Name          |   Type   |  Owner
--------+-----------------------+----------+----------
 public | authors               | table    | postgres
 public | authors_auth_id_seq   | sequence | postgres
 public | books                 | table    | postgres
 public | books_book_id_seq     | sequence | postgres
 public | descriptions          | table    | postgres
 public | genres                | table    | postgres
 public | genres_genre_id_seq   | sequence | postgres
 public | languages             | table    | postgres
 public | languages_lang_id_seq | sequence | postgres
 public | ratings               | table    | postgres
(10 rows)

---import data from CSV files---

science_fiction=# \COPY authors FROM 'C:/Users/user/Documents/Authors_Table.csv' (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY 3973

science_fiction=# \COPY languages FROM 'C:/Users/user/Documents/Languages_Table.csv' (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY 15

science_fiction=# \COPY genres FROM 'C:/Users/user/Documents/Genres_Table.csv' (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY 11

science_fiction=# \COPY books FROM 'C:/Users/user/Documents/Books_Table.csv' (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY 11104

science_fiction=# \COPY descriptions FROM 'C:/Users/user/Documents/Descriptions_Table.csv' (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY 11104

science_fiction=# COPY ratings FROM 'C:/Users/user/Documents/Ratings_Table.csv' (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY 11104