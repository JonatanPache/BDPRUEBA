/*
	VARIABLES
*/

DECLARE @model_year AS SMALLINT;
SET @model_year=2017

SELECT 
	product_name,
	model_year,
	list_price
FROM 
	production.products
WHERE
	model_year=@model_year
ORDER BY
	product_name;

-- Storing query result in a variable

DECLARE @count_products INT;

SET @count_products=(
	SELECT 
		COUNT(*)
	FROM
		production.products
);
SET NOCOUNT ON;    

PRINT 'The number of products is ' + CAST(@count_products AS VARCHAR(MAX));

SELECT @count_products

PRINT @count_products

--Selecting a record into variables

DECLARE
	@product_name VARCHAR(MAX),
	@list_price DECIMAL(10,2);

SELECT 
	@product_name=product_name,
	@list_price=list_price
FROM
	production.products
WHERE
	product_id=100;

SELECT 
	@product_name AS producto,
	@list_price AS Precio;

-- Accumulating values into a variable

CREATE PROC uspGetProductList(
	@model_year SMALLINT
)
AS
BEGIN
	DECLARE @product_list VARCHAR(MAX);
	SET @product_list='';
	SELECT
		@product_list+=product_name+CHAR(10)
	FROM
		production.products
	WHERE
		model_year=@model_year
	ORDER BY
		product_name;
	PRINT @product_list;
END;

EXEC uspGetProductList 2018;