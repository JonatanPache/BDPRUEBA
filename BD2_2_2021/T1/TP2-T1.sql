/*
	TP2-T1 (Programación de Funciones en Transact SQL)

	AUTOR:YONATAN JEREMIAS CONDORI PACHECO
*/

--1. Hacer una funcion denominada "Suma", que reciba dos numeros y 
--retorne la suma de ambos numeros

	CREATE FUNCTION Suma(
		@x INT,
		@y INT)
	RETURNS INT
	AS
	BEGIN
		RETURN @x+@y;
	END;
--2. Hacer una funcion denominada "GetCiudad", que reciba como parámetro 
--el código del proveedor y retorne la ciudad donde vive el proveedor.
	
	CREATE FUNCTION GetCiudad(
		@cprv INT)
	RETURNS CHAR(2)
	AS 
	BEGIN
		RETURN (SELECT ciud FROM Demo_Tienda.dbo.prov WHERE prov.cprv=@cprv);
	END;

--3. Hacer una funcion denominada "GetNombre", que reciba el codigo del 
--proveedor y retorne su nombre

	CREATE FUNCTION GetNombre(
		@cprv INT)
	RETURNS CHAR(10)
	AS 
	BEGIN
		RETURN (SELECT prov.nomb FROM Demo_Tienda.dbo.prov WHERE prov.cprv=@cprv);
	END;

--4. Hacer una funcion denominada "CalcularPuntos", que reciba el codigo del 
--proveedor y calcule los puntos de bonificacion en base a los siguientes criterios:
--      Si el proveedor suministro entre 1 y 20 bs se le asigna 10 puntos.
--      Si el proveedor suministro entre 11 y 50 bs se le asigna 15 puntos.      
--      Si el proveedor suministro mas de 51 bs se le asigna 20 puntos.

	CREATE FUNCTION Calcularpuntos(
		@cprv INT)
	RETURNS INT
	AS
	BEGIN
		DECLARE @cant DECIMAL
		DECLARE @puntos INT
		SELECT @cant=sum(cant) FROM Demo_Tienda.dbo.sumi WHERE cprv=@cprv
		IF (@cant>=1 AND @cant<=20)
			SET @puntos=10
		IF (@cant>=11 AND @cant<=50)
			SET @puntos=15
		IF (@cant>51)
			SET @puntos=20
		RETURN @puntos
	END

--5. Hacer una funcion denominada "GetStock", que devuelva el Stock existente 
--de un producto que se encuentra en una ciudad en particular.

	CREATE FUNCTION GetStock(
		@cproducto INT,
		@ciudad CHAR(2)
		)
	RETURNS INT
	AS
	BEGIN 
		DECLARE @stock INT
		SELECT @stock=ISNULL(SUM(cant),0) FROM sumi,alma WHERE sumi.calm=alma.calm and cprd=@cproducto and ciud=@ciudad;
		RETURN @stock;
	END;

	PRINT Demo.dbo.GetStock(1,'SC')

	--v2 

	CREATE FUNCTION GetStock2(
		@cprod INT,
		@ciuda CHAR(2)
		)
	RETURNS INT
	AS
	BEGIN
		RETURN (SELECT ISNULL(SUM(cant),0) FROM sumi,alma WHERE sumi.calm=alma.calm and alma.ciud=@ciuda and sumi.cprd=@cprod);
	END;

	PRINT Demo.dbo.GetStock2(1,'SC')

--6. Hacer una funcion denominada "GetInven", que devuelva el Inventario 
--Valorado de un producto.
	
	ALTER FUNCTION GetInven(
		@cprd INT)
	RETURNS DECIMAL(8,2)
	AS 
	BEGIN
		RETURN ( SELECT SUM(impt) FROM sumi WHERE sumi.cprd=@cprd);
	END;

	PRINT Demo.dbo.GetInven(1)

--7. Hacer una funcion denominada "GetProdxCiud", que devuelva en una 
--tabla los Productos existentes en una ciudad en particular

	CREATE FUNCTION GetProdxCiud(
		@ciud CHAR(2)
		)
	RETURNS TABLE
	AS
	RETURN (
		SELECT * FROM prod WHERE cprd IN (
		SELECT cprd FROM sumi,alma 
		WHERE prod.cprd=sumi.cprd and alma.calm=sumi.calm and alma.ciud=@ciud)
	)

	SELECT * FROM GetProdxCiud('LP')

--8. Hacer una funcion denominada "GetProvxProd", que devuelva en una tabla 
--los Proveedores que suministraron algún Producto

	ALTER FUNCTION GetProvxProd()
	RETURNS TABLE
	AS 
		RETURN (SELECT * FROM prov 
				WHERE cprv 
				IN (SELECT cprv 
					FROM sumi 
					WHERE prov.cprv=sumi.cprv));

	SELECT * FROM dbo.GetProvxProd()

--9. Hacer una funcion denominada "GetProvNoSumi", que devuelva en una 
--tabla los Proveedores que todavía no suministraron productos.

	CREATE FUNCTION GetProvNoSumi()
	RETURNS TABLE
	AS
		RETURN (SELECT * 
				FROM prov 
				WHERE cprv 
				NOT IN (SELECT cprv 
						FROM sumi))

	SELECT * FROM dbo.GetProvNoSumi()

--10. Hacer una funcion denominada "GetProvSumi", que devuelva en 
--una tabla los nombres de los proveedores que suministraron algún 
--producto color rojo

	CREATE FUNCTION GetProvSumi()
	RETURNS TABLE
	AS
		RETURN (SELECT nomb 
				FROM prov 
				WHERE cprv 
				IN (SELECT cprv 
						FROM sumi,prod 
						WHERE sumi.cprd=prod.cprd and prod.colo='ROJO'))

	SELECT * FROM dbo.GetProvSumi()
	SELECT * FROM SUMI
--11. Hacer una funcion denominada "GetProdxProv", que devuelva en 
--una tabla productos existente en un almacen y que fueron suministrado 
--por un proveedor en particular

	CREATE FUNCTION GetProdxProv(
		@calm INT,
		@cprv INT
	)
	RETURNS TABLE
	AS
		RETURN (SELECT * 
				FROM prod 
				WHERE cprd 
				IN (SELECT cprd 
					FROM sumi 
					WHERE sumi.calm=@calm and sumi.cprv=@cprv))

	SELECT * FROM dbo.GetProdxProv(1,1)

--12. Hacer una funcion denominada "GetProdxColor", que devuelva 
--en una tabla productos de color rojo suministrados por un proveedor

	CREATE FUNCTION GetProdxColor(
		@cprv INT
	)
	RETURNS TABLE
	AS
	RETURN (SELECT prod.*,sumi.cprv 
			FROM prod,sumi 
			WHERE prod.cprd 
			IN (SELECT cprd 
				FROM sumi 
				WHERE cprv=@cprv) 
				and prod.colo='ROJO')

	SELECT * FROM DBO.GetProdxColor(1)

--13. Hacer una funcion denominada "GetProvTodo", que devuelva en una 
--tabla los nombres de los proveedores que suministraron todos los productos.

	CREATE FUNCTION GetProvTodo()
	RETURNS TABLE
	AS 
		RETURN (SELECT nomb 
				FROM prov 
				WHERE cprv 
				IN (SELECT cprv 
					FROM sumi));

	SELECT * FROM dbo.GetProvTodo()

--14. Hacer una funcion denominada "GetProvTres", que devuelva en una tabla 
--los nombres de los proveedores que suministraron por lo menos dos productos diferentes

	CREATE FUNCTION GetProvTres()
	RETURNS TABLE
	AS
		RETURN (SELECT nomb 
				FROM prov 
				WHERE (SELECT COUNT(DISTINCT sumi.cprd) 
						FROM sumi 
						WHERE sumi.cprv=prov.cprv)>1)
	
	SELECT * FROM dbo.GetProvTres()

--15. Hacer una funcion denominada "GetProvOutCiud", que devuelva en una tabla los 
--nombres de los proveedores que suministraron algún producto fuera de su ciudad.

	CREATE FUNCTION GetProvOutCiud()
	RETURNS TABLE
	AS
		RETURN (SELECT nomb 
				FROM prov 
				WHERE cprv 
				IN (SELECT cprv 
					FROM sumi,alma 
					WHERE prov.ciud<>alma.ciud and sumi.calm=alma.calm))

	SELECT * FROM dbo.GetProvOutCiud()

--16. Hacer una funcion denominada "GetMaxCantxCiud", que devuelva la cantidad más 
--alta suministrada de un producto en una ciudad en particular.

	CREATE FUNCTION GetMaxCantxCiud(
		@nomp CHAR(10),
		@ciud CHAR(2)
	)
	RETURNS INT
	AS
	BEGIN
		DECLARE @Maxi INT
		SET @Maxi=0
		SELECT @Maxi=MAX(sumi.cant) 
			FROM prod,sumi,alma
			WHERE alma.calm=sumi.calm and alma.ciud=@ciud and prod.cprd=sumi.cprd and prod.nomp=@nomp
		RETURN @Maxi;
	END;

	PRINT dbo.GetMaxCantxCiud('PRD3','SC')

--17. Hacer una funcion denominada "GetUltFecxProv", que devuelva la ultima fecha 
--que se suministró un producto por un proveedor en particular.

	ALTER FUNCTION GetUltFecxProv(
		@cprv INT)
	RETURNS DATE
	AS
	BEGIN
		DECLARE @fec DATE
		SET @fec=(SELECT MAX(ftra) 
				  FROM sumi 
				  WHERE sumi.cprv=@cprv)
		RETURN @fec;
	END;

	PRINT dbo.GetUltFecxProv(3)
	SELECT * FROM SUMI

--18. Hacer una funcion denominada "GetPrimFecxColor", que devuelva la en qué fecha 
--que por primera vez suministró algún producto de color Rojo.

	CREATE FUNCTION GetPrimFecxColor()
	RETURNS DATE
	AS
	BEGIN
		DECLARE @fec DATE
		SET @fec=(SELECT MIN(ftra) 
				  FROM sumi,prod 
		          WHERE sumi.cprd=prod.cprd and prod.colo='ROJO');
		RETURN @fec;
	END;

	PRINT dbo.GetPrimFecxColor()
	SELECT * FROM SUMI
--19. Hacer una funcion denominada "GetPromxProv", que devuelva el importe promedio 
--de productos suministrados por un proveedor.

	CREATE FUNCTION GetPromxProv(
		@cprv INT
	)
	RETURNS FLOAT
	AS
	BEGIN
		DECLARE @ImpT FLOAT
		DECLARE @Cant FLOAT
		SELECT @Cant=count(sumi.impt) 
			FROM sumi,prod 
			WHERE cprv=@cprv 
		SELECT @ImpT=sum(sumi.impt) 
			FROM sumi,prod 
			WHERE cprv=@cprv 
		RETURN @Impt/@Cant
	END;

	PRINT dbo.GetPromxProv(4)
--20. Hacer una funcion denominada "HayStock", que devuelva 1 si un producto tiene 
--stock disponibles en un determinado almacen, de lo contrario que devuelva 0

	CREATE FUNCTION HayStock(
		@cprd INT,
		@calm INT
	)
	RETURNS INT
	AS
	BEGIN
		DECLARE @stock DECIMAL,@flag INT
		SELECT @stock=ISNULL(SUM(cant),0) 
		FROM sumi 
		WHERE cprd=@cprd and calm=@calm
		IF @stock>0 SET @flag=1
		ELSE SET @flag=0
		RETURN @flag;
	END;

	PRINT dbo.HayStock(2,1)