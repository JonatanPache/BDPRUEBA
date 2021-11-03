-- Stored Procedure Output Parameters
--Creating output parameters

CREATE PROC uspFindProductByModel(
	@model_year SMALLINT,
	@product_count INT OUTPUT
)
AS
BEGIN
	SELECT
		product_name,
		list_price
	FROM
		production.products
	WHERE 
		model_year=@model_year;

	SELECT @product_count=@@ROWCOUNT;
END;

DECLARE @prod_count INT;
EXEC uspFindProductByModel
	@model_year=2018,
	@product_count=@prod_count OUTPUT;

SELECT @prod_count AS 'Numero de productos encontrados';


	