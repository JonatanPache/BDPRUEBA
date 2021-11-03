/*
SQL Server Stored Procedure Parameters
*/

CREATE PROC uspFindProducts
AS
BEGIN
	SELECT
		product_name,
		list_price
	FROM 
		production.products
	ORDER BY	
		list_price;
END;

EXEC uspFindProducts;

ALTER PROC uspFindProducts(@min_list_price AS DECIMAL)
AS
BEGIN
	SELECT 
		product_name,
		list_price
	FROM
		production.products
	WHERE
		list_price>=@min_list_price
	ORDER BY
		list_price;
END;

EXEC uspFindProducts 200;

ALTER PROC uspFindProducts(
	@min_list_price AS DECIMAL,
	@max_list_price AS DECIMAL
)
AS
BEGIN
	SELECT
		product_name,
		list_price
	FROM
		production.products
	WHERE
		list_price>=@min_list_price AND
		list_price<=@max_list_price
	ORDER BY
		list_price;
END;

EXEC uspFindProducts 200,290;
EXECUTE uspFindProducts 
    @min_list_price = 900, 
    @max_list_price = 1000;

ALTER PROC uspFindProducts(
	@min_list_price AS DECIMAL,
	@max_list_price AS DECIMAL,
	@name AS VARCHAR(max)
)
AS
BEGIN
	SELECT
		product_name,
		list_price
	FROM
		production.products
	WHERE
		list_price>=@min_list_price AND
		list_price<=@max_list_price AND
		product_name LIKE '%' + @name +'%'
	ORDER BY
		list_price;
END;

EXECUTE uspFindProducts 
    @min_list_price = 1000, 
    @max_list_price = 1100,
    @name = 'Trek';

ALTER PROC uspFindProducts(
	@min_list_price AS DECIMAL=0,
	@max_list_price AS DECIMAL=NULL,
	@name AS VARCHAR(max)
)
AS
BEGIN
	SELECT
		product_name,
		list_price
	FROM
		production.products
	WHERE
		list_price>=@min_list_price AND
		(@max_list_price IS NULL OR list_price<=@max_list_price) AND
		product_name LIKE '%' + @name +'%'
	ORDER BY
		list_price;
END;

EXECUTE uspFindProducts 
    @min_list_price = 200,
    @name = 'Haro';
