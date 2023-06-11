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
    book_id INT NOT NULL REFERENCES books(book_id) ON DELETE CASCADE,
    description TEXT);

CREATE TABLE ratings (
    book_id INT NOT NULL REFERENCES books(book_id) ON DELETE CASCADE,
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

# once data is populated, I want the book_id primary key to start acting like a serial and auto increment
CREATE SEQUENCE book_id_sequence START 11063 OWNED BY books.book_id;
ALTER TABLE books ALTER COLUMN book_id SET DEFAULT NEXTVAL('book_id_sequence'::regclass);

# now I can query based on conditions such as
SELECT book_title 
FROM books 
LEFT JOIN genres 
    ON books.genre_id = genres.genre_id
WHERE year_published = 1980 AND genre = 'Science Fiction (Aliens)';
# returns two titles:  'The Restaurant at the End of the Universe' and 'Sundiver'

# Try searching for a specific author. Will look for books by N.K. Jemisin:
SELECT book_title FROM books LEFT JOIN authors ON books.auth_id = authors.auth_id WHERE authors LIKE '%Jemisin';

# 7 titles returned
 #How Long 'til Black Future Month
 #The Hundred Thousand Kingdoms
 #The Fifth Season
 #The Stone Sky
 #The Obelisk Gate
 #The City We Became
 #Emergency Skin

# Try searching for an author to see if their newest book is in the database
SELECT book_title FROM books LEFT JOIN authors ON books.auth_id = authors.auth_id WHERE authors LIKE '%Paolini';

# returns all but his newest release 'Fractal Noise' from 2023
# Try adding a book to the database 
INSERT INTO books (book_id, book_title, auth_id, genre_id, lang_id, year_published, url) 
VALUES (DEFAULT, 'Fractal Noise', 
    (SELECT auth_id FROM authors WHERE authors = 'Christopher Paolini'), 
    (SELECT genre_id FROM genres WHERE genre = 'Science Fiction (Aliens)'), 
    (SELECT lang_id FROM languages WHERE language = 'English'), 
    2023, 'https://www.goodreads.com/book/show/62711641-fractal-noise');

# add book description
INSERT INTO descriptions (book_id, description) VALUES (
    (SELECT book_id FROM books WHERE book_title =
    'Fractal Noise' AND year_published = 2023), 
    'On the seemingly uninhabited planet Talos VII:a circular pit, 50 kilometers wide. Its curve not of nature, 
    but design. Now, a small team must land and journey on foot across the surface to learn who built the hole and why. 
    But they all carry the burdens of lives carved out on disparate colonies in the cruel cold of space. 
    For some the mission is the dream of the lifetime, for others a risk not worth taking, 
    and for one it is a desperate attempt to find meaning in an uncaring universe. 
    Each step they take toward the mysterious abyss is more punishing than the last. And the ghosts of their past follow.');

# add ratings info
INSERT INTO ratings (book_id, rating_score, rating_votes, num_ratings) VALUES (
    (SELECT book_id FROM books WHERE book_title = 'Fractal Noise' AND year_published = 2023), 3.60, 1499, 392);

# what is the earliest publication year in the database?
SELECT MIN(year_published) FROM books;
    # returns 1516

# what are the 5 oldest books?
SELECT book_title, year_published 
FROM books 
ORDER BY year_published LIMIT 5;
    # returns Utopia (1516), 
        # Gulliver's Travels (1726), 
        # Frankenstein: The 1818 Text (1818), 
        # The Last Man (1826), 
        # A Christmas Carol (1843)

# which books have the highest rating?
SELECT book_title, rating_score 
FROM books 
    LEFT JOIN ratings ON books.book_id = ratings.book_id 
ORDER BY rating_score DESC LIMIT 5;
    # returns The Unofficial Master Annual 2074 (5.0),
        # Tibar and the Mysteries of Surplicity (5.0),
        # The Complete Alpha Dreamer (5.0),
        # Brynin the War (Brynin War, #2) (5.0), 
        # Come In, Collins (4.93)

# which have been read the most?
SELECT book_title, rating_votes 
FROM books 
    LEFT JOIN ratings ON books.book_id = ratings.book_id 
ORDER BY rating_votes DESC LIMIT 5;
    # returns Harry Potter and the Sorcerer's Stone (7336299),
        # The Hunger Games (6572148),  
        # 1984 (3276673),
        # Divergent (3008156),
        # The Hobbit, or There and Back Again (2990501)

# which authors have written the most books?
SELECT authors, COUNT(DISTINCT book_id) 
FROM authors 
    LEFT JOIN books ON authors.auth_id = books.auth_id
GROUP BY authors 
ORDER BY COUNT(DISTINCT book_id) DESC LIMIT 5;
    # returns Harry Turledove (79),
        # David Weber (73),
        # Ruby Dixon (63),
        # Eric Flint (56),
        # Lindsay Buroker (52)
