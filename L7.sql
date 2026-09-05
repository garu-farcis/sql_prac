-- Active: 1787069770352@@localhost@3306@sakila
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'sakila'
ORDER BY 1;
