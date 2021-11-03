-- A Basic Guide to SQL Server Stored Procedures

--Creating a simple stored procedure
 
CREATE PROCEDURE uspProductList
AS
BEGIN
    SELECT 
        product_name, 
        list_price
    FROM 
        production.products
    ORDER BY 
        product_name;
END;

EXEC uspProductList;

-- Alterando un Store Procedure

ALTER PROCEDURE uspProductList
AS
BEGIN
	SELECT
		product_name,
		list_price
	FROM 
		production.products
	ORDER BY
		list_price
END;