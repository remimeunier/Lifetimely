# Lifetimely

## Ruby challenge

To launch the script (change data inside the file) :
```
  ruby main.rb
```
to run test : 
```
  ruby test_daily_cost.rb
```

## SQL CHALLENGE

Was tested with PostgreSQL 11 : https://www.db-fiddle.com/f/o67W3PGzLwGXAwyZEGkqh9/0

SCHEMA SQL with provided data : 
```
CREATE TABLE orders (
    id serial PRIMARY KEY,
    customer_id INTEGER,
    cost DECIMAL(10,2),
    date DATE
);

INSERT INTO 
    orders (customer_id, date, cost)
VALUES
  	(1, '2020-01-05', 10),
    (2, '2018-01-05', 10),
    (4, '2019-01-05', 10),
    (2, '2019-01-05', 10),
    (3, '2017-01-05', 10),
    (1, '2020-01-05', 10),
    (4, '2019-01-05', 10),
    (1, '2019-01-05', 10),
    (1, '2018-01-05', 10)
RETURNING *;
```

Querry : 
```
SELECT
   CASE
      WHEN numberOfOrders > 2 THEN 3 
      ELSE numberOfOrders 
   END number_of_orders, 
   CASE
      WHEN (DATE_PART('years', NOW()) - DATE_PART('years', MAX(date))) > 2 THEN 3 
      ELSE (DATE_PART('years', NOW()) - DATE_PART('years', MAX(date))) 
   END date_diff,
  SUM(cost) as total_revenue 
FROM
   orders 
   INNER JOIN
      (
         SELECT COUNT(DISTINCT id) AS numberOfOrders, customer_id 
         FROM
            orders 
         GROUP BY
            customer_id
      ) orderNumber ON orderNumber.customer_id = orders.customer_id 
GROUP BY
   number_of_orders 
ORDER BY
   number_of_orders DESC;
