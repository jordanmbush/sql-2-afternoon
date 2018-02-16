-- ============================ PRACTICE JOINS ===============================
SELECT * FROM Invoice
JOIN InvoiceLine ON Invoice.InvoiceId = InvoiceLine.InvoiceID
WHERE InvoiceLine.UnitPrice > .99;

SELECT InvoiceDate, Customer.FirstName, Customer.LastName, Total
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId;

SELECT Customer.FirstName as Customer_First, Customer.LastName as Customer_Last, Employee.FirstName, Employee.Lastname
FROM Customer
JOIN Employee ON Customer.SupportRepId = EmployeeId;

SELECT Title, Artist.Name
From Album
JOIN Artist ON Album.ArtistId = Artist.ArtistId;

SELECT TrackID
From PlaylistTrack PLT
JOIN Playlist PL ON PLT.PlaylistId = PL.PlaylistId
WHERE PL.Name = 'Music';

SELECT Name as Track_Name
From Track T
JOIN PlaylistTrack PLT ON T.TrackId = PLT.TrackId
WHERE PLT.PlaylistId = 5;

SELECT T.Name as Track_Name, PL.Name as Pl_Name
FROM Track T
JOIN PlaylistTrack PLT ON T.TrackId = PLT.TrackId
JOIN Playlist PL ON PL.PlaylistId = PLT.PlaylistId;

SELECT T.Name, A.Title
FROM Track T
JOIN Album A ON T.AlbumId = A.AlbumId
JOIN Genre G on T.GenreId = G.GenreId
WHERE T.GenreId = (SELECT GenreId FROM Genre WHERE Name = 'Alternative');

SELECT T.Name, G.Name as Genre, A.Title, Art.Name
FROM Track T
JOIN Genre G ON T.GenreId = G.GenreId
JOIN Album A ON T.AlbumId = A.AlbumId
JOIN Artist Art ON A.ArtistId = Art.ArtistId
JOIN PlaylistTrack PLT ON T.TrackId = PLT.TrackId
JOIN Playlist PL ON PL.PlaylistId = PLT.PlaylistId
WHERE PL.Name = 'Music';

-- ============================ PRACTICE NESTED QUERIES ===============================
SELECT * 
FROM Invoice I
JOIN InvoiceLine IL ON I.InvoiceId = IL.InvoiceId
WHERE IL.UnitPrice > .99;

SELECT *
FROM PlaylistTrack PLT
WHERE PLT.PlaylistId = (SELECT PlaylistId FROM Playlist WHERE Name = 'Music');

SELECT Name
FROM Track
WHERE TrackId IN (SELECT TrackId FROM PlaylistTrack WHERE PlaylistId = 5);

SELECT * 
FROM Track T
WHERE GenreId = (SELECT GenreId from Genre WHERE Name = 'Comedy');

SELECT *
FROM Track T
WHERE AlbumId IN (SELECT AlbumId from Album WHERE Title = 'Fireball');

SELECT *
FROM Track
WHERE AlbumId IN (SELECT AlbumId FROM Album WHERE ArtistId IN (SELECT ArtistId FROM Artist WHERE Name = 'Queen'));

-- ============================ PRACTICE UPDATING ROWS ===============================
UPDATE Customer
SET Fax = null
WHERE Fax IS NOT null;

UPDATE Customer
SET Company = 'Self'
WHERE Company IS null;

UPDATE Customer
SET LastName = 'Thompson'
WHERE FirstName = 'Julia' AND Lastname = 'Barnett';

UPDATE Customer
SET SupportRepId = 4
WHERE Email = 'luisrojas@yahoo.cl';

UPDATE Track
SET Composer = 'The darkness around us'
WHERE GenreId IN (SELECT GenreId FROM Genre WHERE Name = 'Metal')
AND Composer IS null;

-- ============================ GROUP BY ===============================
SELECT COUNT() as Count, G.Name
FROM Track
JOIN Genre G ON Track.GenreId = G.GenreId
GROUP BY G.Name;

SELECT COUNT(*), G.Name
FROM Track T
JOIN Genre G ON T.GenreId = G.GenreId
WHERE G.Name = 'Pop' OR G.Name = 'Rock'
GROUP BY G.Name;

SELECT A.Name, COUNT(Alb.AlbumId)
FROM Artist A
JOIN Album Alb ON A.ArtistId = Alb.ArtistId
GROUP BY A.Name;

-- ============================ USE DISTINCT ===============================
SELECT DISTINCT(Composer)
FROM Track;

SELECT DISTINCT(BillingPostalCode)
FROM Invoice;

SELECT DISTINCT(Company)
FROM Customer;


-- ============================ DELETE ROWS ===============================
DELETE FROM practice_delete WHERE Type = 'bronze';

DELETE FROM practice_delete WHERE Type = 'silver';

DELETE FROM practice_delete WHERE Value = 150;

-- ============================ eCommerce Simulation ===============================
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Users;


CREATE TABLE Users (
  	id INTEGER PRIMARY KEY,
  	Name VARCHAR(60),
  	Email VARCHAR(60)
  );
  
INSERT INTO Users (Name, Email)
VALUES ('Jordan', 'jordanmbush@gmail.com'),
        ('Jim', 'jim@gmail.com'),
        ('Jerry', 'jerry@gmail.com');
  
CREATE TABLE Products (
  	id INTEGER PRIMARY KEY,
  	Name VARCHAR(60),
  	Price DECIMAL
  );
INSERT INTO Products (Name, Price)
VALUES ('Prod1', 10),
		('Prod2', 11),
        ('Prod3', 12);

CREATE TABLE Orders (
  	id INTEGER PRIMARY KEY,
  	OrderId INTEGER,
  	ProductId INTEGER REFERENCES Products(id),
  	UserId INTEGER REFERENCES Users(id)
  );
INSERT INTO Orders (OrderId, ProductId, UserId)
VALUES (1, 1, 1), (1, 2, 1), (2, 3, 2), (3, 2, 3), (3, 3, 2), (3, 3, 1);

SELECT *
FROM Products
JOIN Orders ON Orders.ProductId = Products.id
WHERE OrderId= 1;

SELECT * FROM Orders O
JOIN Products P ON P.id = O.ProductId;

SELECT SUM(P.Price) as Order_Total, O.OrderId
FROM Orders O
JOIN Products P ON P.id = O.ProductId
GROUP BY O.OrderId;

SELECT U.Name, O.OrderId, P.Name FROM Orders O
JOIN Users U ON O.UserId = U.id
JOIN Products P ON O.ProductId = P.id
WHERE O.UserId = (SELECT id from Users WHERE Name = 'Jordan');

SELECT COUNT(O.id) as Num_Of_Orders, U.Name
FROM Users U
JOIN Orders O ON O.UserId = U.id
GROUP BY U.Name;

SELECT SUM(P.Price), O.UserId
FROM Products P
JOIN Orders O ON P.id = O.ProductId
GROUP BY O.UserId; 