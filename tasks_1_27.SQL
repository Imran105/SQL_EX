# Task 1

SELECT model, ram, screen FROM Laptop
WHERE price > 1000

# Task 2

SELECT DISTINCT maker FROM Product
WHERE type LIKE 'Printer'

# Task 3

SELECT model, ram, screen FROM Laptop
WHERE price > 1000

# Task 4

SELECT * FROM Printer
WHERE color LIKE 'y'

# Task 5

SELECT model, speed, hd FROM pc
WHERE price < 600
AND (cd = '12x' OR cd = '24x')

# Task 6

SELECT DISTINCT maker, speed
FROM Laptop
LEFT JOIN Product
ON Laptop.model = Product.model
WHERE hd>=10 AND type = 'laptop'

# Task 7


SELECT DISTINCT SP.model, Price_Table.price FROM Product AS SP
LEFT JOIN
(SELECT  model, price FROM Laptop
  UNION ALL
  SELECT  model, price FROM PC
  UNION ALL
  SELECT model, price FROM Printer) AS Price_Table
ON SP.model = Price_Table.model
WHERE maker = 'B'


# Task 8

SELECT DISTINCT maker FROM Product
WHERE type = 'Pc'
EXCEPT
SELECT DISTINCT maker FROM Product
WHERE type = 'Laptop'

# Task 9 

SELECT DISTINCT maker
FROM Product
LEFT JOIN Pc
ON  Product.model = PC.model
WHERE speed >= 450


# Task 10

SELECT model, price FROM Printer
WHERE price = (SELECT MAX(Price) FROM Printer)


# Task 11

SELECT AVG(speed) FROM Pc

# Task 12

SELECT AVG(speed) FROM Laptop
WHERE price > 1000


# Task 13

SELECT  AVG(speed)
FROM Pc
LEFT JOIN Product
ON Pc.model = Product.model
WHERE maker = 'A'


# Task 14

SELECT maker, MAX(type) AS type
FROM Product
GROUP BY maker
HAVING (COUNT(DISTINCT type) = 1) AND (COUNT(DISTINCT model) > 1)


# task 15

SELECT hd
FROM Pc
GROUP BY hd
HAVING (COUNT(model) > 1)


# Task 17

SELECT DISTINCT type,Laptop.model,  speed FROM Laptop
LEFT JOIN Product
ON Laptop.model = Product.model
WHERE speed < (SELECT MIN(speed) FROM Pc) AND (product.type = 'laptop')



# Task 18
SELECT DISTINCT maker, price FROM Printer
LEFT JOIN  Product
ON Printer.model = Product.model
WHERE (color = 'y') AND (price = (SELECT MIN(price) FROM Printer WHERE (color = 'y') ))


# Task 19

SELECT  maker,AVG(screen) FROM Laptop
LEFT JOIN Product
ON  Laptop.model = Product.model 
GROUP BY maker


# Task 20

SELECT maker, count(model) AS cm
FROM Product
WHERE type = 'Pc'
GROUP BY maker
HAVING ( COUNT(DISTINCT model) > 2)

# Task 21 

SELECT maker, max(price) from PC
LEFT JOIN
Product
ON Pc.model = Product.model
GROUP BY maker


# TASK 22

SELECT speed, avg(price) FROM Pc
WHERE speed > 600
GROUP BY speed


# Task 23


SELECT   maker FROM Product
LEFT JOIN
((SELECT model, speed FROM Pc)
UNION
(SELECT model, speed FROM Laptop)) AS important_models
ON Product.model = important_models.model
WHERE SPEED >= 750
GROUP BY maker
HAVING (COUNT(DISTINCT type) = 2)



# Task 24

SELECT model FROM 
(SELECT price, model FROM Pc
UNION
SELECT price, model FROM Laptop
UNION
SELECT price, model FROM Printer) AS Total_List
WHERE price = (SELECT max(price) 
FROM (SELECT price, model FROM Pc
UNION
SELECT price, model FROM Laptop
UNION
SELECT price, model FROM Printer) AS Maximal_Price)


# Task 26

SELECT avg(price) FROM Product
RIGHT JOIN 
(SELECT model, price from Laptop
UNION ALL
SELECT model, price from Pc) AS tools
ON Product.model = tools.model
WHERE (type != 'Printer') AND (maker = 'A')


# Task 27
SELECT maker,avg(hd) from Pc
LEFT JOIN
Product
ON Pc.model = Product.model
WHERE maker IN 
(SELECT maker FROM Product
WHERE type != 'Laptop'
GROUP BY maker
HAVING (COUNT(DISTINCT type) = 2))
GROUP BY maker