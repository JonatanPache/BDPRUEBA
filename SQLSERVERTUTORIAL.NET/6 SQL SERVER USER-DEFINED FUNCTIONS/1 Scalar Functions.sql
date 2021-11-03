-- SQL Server Scalar Functions

/*
SQL Server scalar functions and how to use them to encapsulate 
formulas or business logic and reuse them in the queries.
*/

CREATE FUNCTION sales.udfNetSale(
	@quantity INT,
	@list_price DEC(10,2),
	@discount DEC(4,2)
)
RETURNS DEC(10,2)
AS
BEGIN
	RETURN	@quantity*@list_price*(1-@discount);
END;

SELECT sales.udfNetSale(10,100,0.1) netSale;

SELECT 
	order_id,
	sales.udfNetSale(quantity,list_price,discount) netAmount
FROM 
	sales.order_items
ORDER BY
	order_id DESC;