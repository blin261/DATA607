USE assignment2;
SET foreign_key_checks = 0;
DROP TABLE IF EXISTS Movie;
DROP TABLE IF EXISTS Rating;
DROP TABLE IF EXISTS Reviewer;

CREATE TABLE Movie(
	Movie_ID INTEGER NOT NULL AUTO_INCREMENT,
	Movie_Name VARCHAR(100) NOT NULL,
    Release_Date DATE NOT NULL,
    PRIMARY KEY (Movie_ID)
);

INSERT INTO Movie(Movie_Name, Release_Date)
	VALUES ("Captain America: Civil War", "2016-05-06"),
			("Zootopia", "2016-03-04"),
			("Deadpool", "2016-02-12"),
			("Room", "2016-01-22"),
			("Star Wars: The Force Awakens", "2015-12-18"),
			("Inside Out", "2015-06-19");
       

CREATE TABLE Reviewer (
	Name_ID INTEGER NOT NULL AUTO_INCREMENT,
	Name_Initial VARCHAR(100) NOT NULL ,
    PRIMARY KEY (Name_ID)
); 

INSERT INTO Reviewer(Name_Initial)
VALUES ("AF"),
	   ("MJ"),
       ("TY"),
       ("YZ"),
       ("XJ"),
       ("JZ"); 


CREATE TABLE Rating (
	Rating_ID INTEGER NOT NULL AUTO_INCREMENT,
    Movie_ID INTEGER,
    Name_ID INTEGER,
    Rating INTEGER NOT NULL,
    PRIMARY KEY (Rating_ID),
    FOREIGN KEY (Movie_ID) REFERENCES Movie(Movie_ID) ON UPDATE CASCADE,
FOREIGN KEY (Name_ID) REFERENCES Reviewer(Name_ID) ON UPDATE CASCADE
);

       
INSERT INTO Rating(Movie_ID, Name_ID, Rating)
VALUES (1, 1, 5),
		(1, 2, 4),
        (1, 3, 3),
        (1, 4, 4),
        (1, 5, 2),
        (1, 6, 4),
        (2, 1, 4),
        (2, 2, 5),
        (2, 3, 4),
        (2, 4, 5),
        (2, 5, 2),
        (2, 6, 3),
        (3, 1, 5),
        (3, 2, 5),
        (3, 3, 5),
        (3, 4, 4),
        (3, 5, 3),
        (3, 6, 5),
        (4, 1, 5),
		(4, 2, 4),
        (4, 3, 5),
        (4, 4, 5),
        (4, 5, 5),
        (4, 6, 5),
        (5, 1, 3),
        (5, 2, 4),
        (5, 3, 5),
        (5, 4, 4),
        (5, 5, 3),
        (5, 6, 5),
        (6, 1, 3),
        (6, 2, 5),
        (6, 3, 3),
        (6, 4, 5),
        (6, 5, 4),
        (6, 6, 5);
        
SELECT * FROM Movie;
SELECT * FROM Reviewer;
SELECT * FROM Rating;


CREATE TABLE MovieRating AS SELECT Movie.Movie_ID, Movie.Movie_Name, Movie.Release_Date, Reviewer.Name_Initial, Rating.Rating FROM Movie
INNER JOIN Rating
ON Movie.Movie_ID = Rating.Movie_ID
INNER JOIN Reviewer
ON Reviewer.Name_ID = Rating.Name_ID;

SELECT * FROM MovieRating;
