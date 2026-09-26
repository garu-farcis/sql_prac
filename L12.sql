================================================================================
5 ADVANCED INTERVIEW-STYLE PRACTICE QUESTIONS
MySQL + Sakila Sample Database
Focus: Advanced Analytics • Window Functions • Complex Logic
(Questions only – no solution hints)
================================================================================

USE sakila;

-- 1. For each customer, calculate their total spending and assign them a
--    lifetime value segment using NTILE(5). Then, within each segment, rank
--    the customers by the number of distinct films they have rented.
--    Display customer full name, total spent, segment number, distinct film
--    count, and the rank inside the segment.

-- 2. Identify every rental that is more than two standard deviations above
--    the average payment amount for that customer. Show customer full name,
--    payment amount, payment date, the customer’s average payment, and the
--    standard deviation of their payments.

-- 3. Build a month-over-month retention report for 2005: for each month show
--    the number of customers who rented in that month, the number who also
--    rented in the previous month, and the retention percentage.
--    Months with no prior activity should still appear.

-- 4. For every film, show its title, the total revenue it generated, and a
--    cumulative revenue percentage of the entire catalog when films are
--    ordered from highest to lowest revenue (i.e., a running contribution
--    to 100 %).

-- 5. Find the longest streak of consecutive days in which at least one
--    rental occurred in 2005. Return the start date of the streak, the end
--    date of the streak, and the length of the streak in days.