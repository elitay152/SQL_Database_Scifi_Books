# Code for setting up relational database
# in command line with posgresql

CREATE DATABASE science_fiction;

# \c command connects to specific database
\c science_fiction

# create first table, specifying data types and primary key
CREATE TABLE languages (
    lang_id SERIAL NOT NULL PRIMARY KEY,
    language VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE authors (
    auth_id SERIAL NOT NULL PRIMARY KEY,
    authors VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE genres (
    genre_id SERIAL NOT NULL PRIMARY KEY,
    genre VARCHAR(50) NOT NULL UNIQUE
);

# now I can set up the books table, which has foreign keys that reference the above tables
CREATE TABLE books (
    book_id BIGSERIAL NOT NULL PRIMARY KEY,
    book_title VARCHAR(200) NOT NULL,
    auth_id INT NOT NULL REFERENCES authors(auth_id),
    genre_id INT REFERENCES genres(genre_id),
    lang_id INT REFERENCES languages(lang_id),
    year_published INT,
    url VARCHAR(500) NOT NULL UNIQUE
);

# then I can add the last two tables, both of which reference the books table
CREATE TABLE descriptions (
    book_id INT NOT NULL REFERENCES books(book_id),
    description TEXT);

CREATE TABLE ratings (
    book_id INT NOT NULL REFERENCES books(book_id),
    rating_score NUMERIC,
    rating_votes INT,
    num_ratings INT
);

# import data from CSV files
\COPY authors FROM 'C:/Users/user/Documents/Authors_Table.csv' (
    FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\COPY languages FROM 'C:/Users/user/Documents/Languages_Table.csv' (
    FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\COPY genres FROM 'C:/Users/user/Documents/Genres_Table.csv' (
    FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\COPY books FROM 'C:/Users/user/Documents/Books_Table.csv' (
    FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\COPY descriptions FROM 'C:/Users/user/Documents/Descriptions_Table.csv' (
    FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\COPY ratings FROM 'C:/Users/user/Documents/Ratings_Table.csv' (
    FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');