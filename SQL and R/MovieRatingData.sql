
CREATE TABLE MovieRating(
	Movie_ID INTEGER,
	Movie_Name VARCHAR(100),
    Release_Date DATE,
	Name_Initial VARCHAR(100),
	Rating INTEGER,
);


LOAD DATA LOCAL INFILE 'c:/Users/blin261/Documents/SQL/Movie_Rating/MovieRating.csv' 
INTO TABLE MovieRating
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS