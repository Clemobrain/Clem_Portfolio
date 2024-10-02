-- Create the database with the name FoodserviceDB

CREATE DATABASE FoodserviceDB;

USE FoodserviceDB
GO

-- Adding foreign key constraint to Ratings table referencing Restaurant table
ALTER TABLE Ratings
ADD FOREIGN KEY (Restaurant_ID) REFERENCES Restaurant(Restaurant_ID);

-- Adding foreign key constraint to Ratings table referencing Consumers table
ALTER TABLE Ratings
ADD FOREIGN KEY (Consumer_ID) REFERENCES Consumers(Consumer_ID);

--Adding a primary key to Ratings table using two foreign keys
ALTER TABLE Ratings
ADD CONSTRAINT PK_Consumer_Restaurant PRIMARY KEY (Consumer_ID, Restaurant_ID);

-- Add Restaurant_Cuisines_ID to Restaurant_Cuisines table and assign primary key
ALTER TABLE Restaurant_Cuisines
ADD Restaurant_Cuisines_ID int IDENTITY(1000,1) PRIMARY KEY;

-- Adding foreign key constraint to Restaurant_Cuisines table referencing Restaurant table
ALTER TABLE Restaurant_Cuisines
ADD FOREIGN KEY (Restaurant_ID) REFERENCES Restaurant(Restaurant_ID);



--PART 2

--No 1. list all restaurant with medium range price with open area, serving Mexican food

SELECT r.Name AS RestaurantName
FROM Restaurant r
JOIN Restaurant_Cuisines c 
ON r.Restaurant_ID = c.Restaurant_ID
WHERE r.Price = 'Medium'
AND r.Area = 'Open'
AND c.Cuisine = 'Mexican';

-- No 2 Compare two results (FIRST RESULT)
-- 2.1 Query that returns the total number of restaurants who have the overall rating as 1 and are serving Mexican food

SELECT COUNT(DISTINCT r.Restaurant_ID)   Total_Mexican_Restaurants_Rating1
FROM Restaurant  r
JOIN Ratings  ra ON r.Restaurant_ID = ra.Restaurant_ID
JOIN Restaurant_Cuisines  c ON r.Restaurant_ID = c.Restaurant_ID
WHERE ra.Overall_rating = 1
AND c.Cuisine = 'Mexican';

-- Compare two results (SECOND RESULT)
-- 2.2 Query that returns the total number of restaurants who have the overall rating as 1 and are serving Italian food

SELECT COUNT(DISTINCT r.Restaurant_ID)  Total_Italian_Restaurants_Rating1
FROM Restaurant r
JOIN Ratings ra ON r.Restaurant_id = ra.Restaurant_id
JOIN Restaurant_Cuisines c ON r.Restaurant_id = c.Restaurant_id
WHERE ra.Overall_rating = 1
AND c.Cuisine = 'Italian';



--No 3 Calculates the average age of consumers who have given a 0 rating to the 'Service_rating' column.

SELECT ROUND(AVG(c.Age), 0) AS Average_Age
FROM Consumers c
JOIN Ratings ra ON c.Consumer_id = ra.Consumer_id
WHERE ra.Service_Rating = 0;




-- No (4) This query returns the restaurants ranked by the youngest consumer.
SELECT 
    r.Name restaurant_name,
    ra.food_rating,
    c.age
FROM 
    Restaurant r
JOIN 
    Ratings ra ON r.restaurant_id = ra.restaurant_id
JOIN 
    Consumers c ON ra.consumer_id = c.consumer_id
WHERE 
    c.age = (SELECT MIN(age) FROM Consumers)
ORDER BY 
    ra.food_rating DESC;




-- No 5 
--Update the Service_rating of all restaurants to '2' with a subquery condition where parking is either yes or public in Restaurant table.

CREATE PROCEDURE UpdateServiceRatingWithParking
AS
BEGIN
    -- Update service rating for restaurants with available parking
    UPDATE Ratings
    SET Service_rating = '2'
    WHERE Restaurant_id IN (
        SELECT Restaurant_id
        FROM Restaurant
        WHERE Parking IN ('yes', 'public')
    );

    -- Output message indicating completion
    PRINT 'Service ratings updated for restaurants with parking available.';
END;
GO

-- Execute the stored procedure
EXEC UpdateServiceRatingWithParking;




-- 6 (i) 
-- Using the 'Exists' to Find restaurants that serve Japanese cuisine.
SELECT 
    r.Name AS Restaurant_name,
    CONCAT(r.City, ', ', r.State, ', ', r.Country) AS Location
FROM 
    Restaurant r
WHERE EXISTS (
    SELECT 1
    FROM Restaurant_Cuisines rc
    WHERE  r.Restaurant_ID = rc.Restaurant_ID
    AND rc.Cuisine = 'Japanese'
);


--(ii)
SELECT TOP 10 Name AS RestaurantName, city, country
FROM Restaurant
WHERE Restaurant_id IN (
    SELECT Restaurant_id
    FROM Ratings
    WHERE Consumer_id IN (
        SELECT Consumer_id
        FROM Consumers
        WHERE Age < 21
    )
);



-- (iii)

--What is the average food rating of restaurants that offer alcohol service compared to those that do not?
	SELECT
    ISNULL(R.Alcohol_Service, 'No Alcohol Service') AS Alcohol_Service_Status,
    AVG(RT.Food_Rating) AS Avg_Food_Rating
FROM
    Restaurant R
LEFT JOIN
    Ratings RT ON R.Restaurant_ID = RT.Restaurant_ID
GROUP BY
    R.Alcohol_Service;



	-- (iv)
-- To find the avg service rating for each restaurant where avg service rating is less than 3
SELECT r.Restaurant_ID, r.Name AS RestaurantName,
    AVG(rt.service_rating) AS AvgServiceRating
FROM Restaurant r
JOIN
    Ratings rt ON r.Restaurant_ID = rt.Restaurant_ID
GROUP BY
    r.Restaurant_ID, r.Name
HAVING
    AVG(rt.service_rating) < 3
ORDER BY
    AvgServiceRating DESC;
