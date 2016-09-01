# Task 1
# Find the model number, speed and hard drive capacity for all the PCs with prices below $500.
# Result set: model, speed, hd.

SELECT model,
       ram,
       screen
FROM Laptop
WHERE price > 1000

# Task 2
# List all printer makers. Result set: maker.

SELECT DISTINCT maker
FROM Product
WHERE type LIKE 'Printer'

# Task 3
# Find the model number, RAM and screen size of the laptops with prices over $1000.

SELECT model,
       ram,
       screen 
FROM Laptop
WHERE price > 1000

# Task 4
# Find all records from the Printer table containing data about color printers.

SELECT * 
FROM Printer
WHERE color LIKE 'y'

# Task 5
# Find the model number, speed and hard drive capacity of PCs cheaper than $600 having a 12x or a 24x CD drive.

SELECT model,
       speed,
       hd
FROM pc
WHERE price < 600
  AND (cd = '12x'
       OR cd = '24x')

# Task 6
# For each maker producing laptops with a hard drive capacity of 10 Gb or higher, find the speed of such laptops.
# Result set: maker, speed.

SELECT DISTINCT maker,
                speed
FROM Laptop
LEFT JOIN Product ON Laptop.model = Product.model
WHERE hd >= 10
  AND type = 'laptop'

# Task 7
# Find out the models and prices for all the products (of any type) produced by maker B.

SELECT DISTINCT SP.model,
                Price_Table.price
FROM Product AS SP
LEFT JOIN
  (SELECT model,
          price
   FROM Laptop
   UNION ALL SELECT model,
                    price
   FROM PC
   UNION ALL SELECT model,
                    price
   FROM Printer) AS Price_Table ON SP.model = Price_Table.model
WHERE maker = 'B'

# Task 8
# Find the makers producing PCs but not laptops.

SELECT DISTINCT maker 
FROM Product
WHERE type = 'Pc'
EXCEPT
SELECT DISTINCT maker 
FROM Product
WHERE type = 'Laptop'

# Task 9 
# Find the makers of PCs with a processor speed of 450 MHz or more. Result set: maker.

SELECT DISTINCT maker
FROM Product
LEFT JOIN Pc ON  Product.model = PC.model
WHERE speed >= 450

# Task 10
# Find the printer models having the highest price. Result set: model, price.

SELECT model,
       price
FROM Printer
WHERE price =
    (SELECT MAX(Price)
     FROM Printer)


# Task 11
# Find out the average speed of PCs.

SELECT AVG(speed)
FROM Pc

# Task 12
# Find out the average speed of the laptops priced over $1000.

SELECT AVG(speed)
FROM Laptop
WHERE price > 1000


# Task 13
# Find out the average speed of the PCs produced by maker A.

SELECT AVG(speed)
FROM Pc
LEFT JOIN Product ON Pc.model = Product.model
WHERE maker = 'A'

# Task 14
# Get the makers who produce only one product type and more than one model.
# Output: maker, type.

SELECT maker,
       MAX(TYPE) AS x
FROM Product
GROUP BY maker
HAVING (COUNT(DISTINCT TYPE) = 1)
AND (COUNT(DISTINCT model) > 1)

# Task 15
# Get hard drive capacities that are identical for two or more PCs. 
# Result set: hd.

SELECT hd
FROM Pc
GROUP BY hd
HAVING (COUNT(model) > 1)

# Task 17
# Get the laptop models that have a speed smaller than the speed of any PC. 
# Result set: type, model, speed.

SELECT DISTINCT type,
                Laptop.model,
                speed
FROM Laptop
LEFT JOIN Product ON Laptop.model = Product.model
WHERE speed <
    (SELECT MIN(speed)
     FROM Pc)
  AND (product.type = 'laptop')

# Task 18
# Find the makers of the cheapest color printers.
# Result set: maker, price.

SELECT DISTINCT maker,
                price
FROM Printer
LEFT JOIN Product ON Printer.model = Product.model
WHERE (color = 'y')
  AND (price =
         (SELECT MIN(price)
          FROM Printer
          WHERE (color = 'y') ))

# Task 19
# For each maker having models in the Laptop table, find out the average screen size of the laptops he produces. 
# Result set: maker, average screen size.

SELECT  maker, 
       AVG(screen)
FROM Laptop
LEFT JOIN Product ON  Laptop.model = Product.model 
GROUP BY maker

# Task 20
# Find the makers producing at least three distinct models of PCs.
# Result set: maker, number of PC models.

SELECT maker,
       COUNT(model) AS cm
FROM Product
WHERE type = 'Pc'
GROUP BY maker
HAVING (COUNT(DISTINCT model) > 2)

# Task 21 
# Find out the maximum PC price for each maker having models in the PC table.
# Result set: maker, maximum price.

SELECT maker,
       MAX(price)
from Pc
LEFT JOIN Product ON Pc.model = Product.model
GROUP BY maker

# Task 22
# For each value of PC speed that exceeds 600 MHz, find out the average price of PCs with identical speeds.
# Result set: speed, average price.

SELECT speed,
       AVG(price)
FROM Pc
WHERE speed > 600
GROUP BY speed

# Task 23
# Get the makers producing both PCs having a speed of 750 MHz or higher and laptops with a speed of 750 MHz or higher. 
# Result set: maker

SELECT maker
FROM Product
LEFT JOIN (
             (SELECT model,
                     speed
              FROM Pc)
           UNION
             (SELECT model,
                     speed
              FROM Laptop)) AS important_models ON Product.model = important_models.model
WHERE SPEED >= 750
GROUP BY maker
HAVING (COUNT(DISTINCT TYPE) = 2)

# Task 24
# List the models of any type having the highest price of all products present in the database.

SELECT model
FROM
  (SELECT price,
          model
   FROM Pc
   UNION SELECT price,
                model
   FROM Laptop
   UNION SELECT price,
                model
   FROM Printer) AS tab_1
WHERE price =
    (SELECT max(price)
     FROM
       (SELECT price,
               model
        FROM Pc
        UNION SELECT price,
                     model
        FROM Laptop
        UNION SELECT price,
                     model
        FROM Printer) AS tab_2)

# Task 26
# Find out the average price of PCs and laptops produced by maker A.
# Result set: one overall average price for all items.

SELECT AVG(price)
FROM Product
RIGHT JOIN
  (SELECT model,
          price
   FROM Laptop
   UNION ALL SELECT model,
                    price
   FROM Pc) AS tools ON Product.model = tools.model
WHERE (TYPE != 'Printer')
  AND (maker = 'A')

# Task 27
# Find out the average hard disk drive capacity of PCs produced by makers who also manufacture printers.
# Result set: maker, average HDD capacity.

SELECT maker,
       AVG(hd)
FROM Pc
LEFT JOIN Product ON Pc.model = Product.model
WHERE maker IN
    (SELECT maker
     FROM Product
     WHERE TYPE != 'Laptop'
     GROUP BY maker
     HAVING (COUNT(DISTINCT type) = 2))
GROUP BY maker

# Task 29
# Under the assumption that receipts of money (inc) and payouts (out) are registered not more than once a day for each 
# collection point [i.e. the primary key consists of (point, date)], write a query displaying cash flow data 
# (point, date, income, expense). Use Income_o and Outcome_o tables.

SELECT COALESCE(Income_o.point, Outcome_o.point) AS point,
       COALESCE(Income_o.date, Outcome_o.date) AS date,
       inc,
       out
FROM Income_o
FULL OUTER JOIN Outcome_o ON (Outcome_o.date = Income_o.date) AND (Outcome_o.point = Income_o.point)

# Task 30
# Under the assumption that receipts of money (inc) and payouts (out) can be registered any number of times a day for each
# collection point [i.e. the code column is the primary key], display a table with one corresponding row for each operating
# date of each collection point.
# Result set: point, date, total payout per day (out), total money intake per day (inc). 
# Missing values are considered to be NULL.

SELECT
  point,
  date,
  SUM(out) AS Outcome,
  SUM(inc) AS Income
FROM (SELECT
  COALESCE(Income.point, Outcome.point) AS point,
  COALESCE(Income.date, Outcome.date) AS date,
  inc,
  out
FROM Income
FULL JOIN Outcome
  ON (Outcome.code = Income.code)
  AND (Outcome.date = Income.date)) AS final_tab

GROUP BY date,
         point
ORDER BY point, date

# Task 31
# For ship classes with a gun caliber of 16 in. or more, display the class and the country.

SELECT class,
       country
FROM  Classes
WHERE bore >= 16

# Task 32
# One of the characteristics of a ship is one-half the cube of the calibre of its main guns (mw). 
# Determine the average ship mw with an accuracy of two decimal places for each country having ships in the database.

SELECT
  country,
  CAST(AVG((bore * bore * bore) / 2) AS decimal(18, 2)) AS Weight
FROM Ships
FULL OUTER JOIN Classes
  ON Ships.class = Classes.class
WHERE bore IS NOT NULL
GROUP BY country

# Task 33
# Get the ships sunk in the North Atlantic battle. 
# Result set: ship.

SELECT ship 
FROM Outcomes
LEFT JOIN Battles ON Battles.name = Outcomes.battle
WHERE (Battles.name = 'North Atlantic') AND (result = 'sunk')

# Task 34

SELECT DISTINCT name
FROM Ships
LEFT JOIN Classes ON Ships.class = Classes.class
WHERE (displacement > 35000) AND (launched > 1921) AND (launched IS NOT NULL) AND (type = 'bb')

# task 35

SELECT model, type 
FROM Product 
WHERE model NOT LIKE '%[^A-Z]%' OR model NOT LIKE '%[^0-9]%'

# Task 38
SELECT country FROM Classes
GROUP BY country
HAVING (COUNT( DISTINCT type) = 2)


# Task 40

SELECT  Ships.class,name, country FROm Ships
LEFT JOIN
Classes
ON Ships.class = Classes.class
WHERE numGuns >= 10

# Task 41

SELECT * FROM PC
WHERE code = ( SELECT max(code) FROm PC)
# task 42

SELECT ship, battle FROM Outcomes
WHERE result = 'sunk'

# Task 44

SELECT name from Ships
WHERE lower(name) like 'r%'
UNION
SELECT ship FROM Outcomes
WHERE lower(ship) like 'r%'


# Task 45

SELECT Distinct name FROM (
SELECT name, LEN(name)-LEN(REPLACE(name, ' ', '')) as joe  from Ships
UNION ALL
SELECT ship as name, LEN(ship)-LEN(REPLACE(ship, ' ', '')) as joe from Outcomes
) as dock
where JOE > 1


# Task 48

SELECT DISTINCT class FROM Outcomes 
LEFT JOIN (
SELECT name,class FROM SHIPS
UNION
(SELECT class as name, class FROM Classes)) AS JOE
ON Outcomes.ship = JOE.name
WHERE result = 'sunk' AND class IS NOT NULL


# TASK 49

SELECT name FROM Classes
RIGHT JOIN (
SELECT ship as name, ship as class FROM Outcomes
UNION
SELECT  name, class  FROM Ships) AS shiplist
ON Classes.class = shiplist.class
WHERE bore = 16.00

# TASK 50

SELECT DISTINCT battle FROM Outcomes
LEFT JOIN 
Ships
on Outcomes.ship = Ships.name
WHERE class = 'Kongo'


# Task 51

SELECT DISTINCT name FROm Ships
LEFT JOIn Classes
on Ships.class = Classes.class
Where (Country = 'japan' OR Country IS NULL) AND (displacement <=65000 OR Displacement IS NULL) AND (bore <19 OR bore IS NULL) and (numGuns >=9 OR Numguns IS NULL) and (type = 'bb' OR type IS NULL)


# Task 53

SELECT CAST(avg(CAST(numGuns AS Decimal(16,2)))AS Decimal(16,2))  FROM Classes
where type = 'bb'


# Task 55

SELECT  Classes.class,min(launched) FROm CLasses
LEFT JOIN
SHIPS
on Classes.class = Ships.Class
GROUP BY Classes.class
