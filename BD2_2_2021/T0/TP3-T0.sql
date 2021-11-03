/*
Elaborar la consulta SQL correspondiente  para cada uno de los 
siguientes requerimientos a la Base de Datos "demo"

	Autor: Yonatan Jeremias Condori Pacheco
	N Reg:217013252

*/

-- 1. Listar todos los proveedores

	Select * from dbo.prov

-- 2. Listar todos los alamcenes

	Select * from dbo.alma

-- 3. Listar todos los productos

	Select * from dbo.prod

-- 4. Listar toda la informacion existente en la tabla sumi

	Select * from dbo.sumi

-- 5. Listar todos los productos de color amarillo

	Select * from dbo.prod where prod.colo='AMARILLO'

-- 6. Listar el codigo del producto, nombre del producto y fecha de los productos suministrados por el PROV1

-- Usando la Reunion Natural (JOIN)

	Select prod.cprd,prod.nomp,sumi.ftra,sumi.cprv From dbo.prod,dbo.sumi Inner Join prov On prov.nomb='PROV1' and prov.cprv=sumi.cprv

-- Usando la clausula IN (sub consultas)

	Select prod.cprd,prod.nomp,sumi.ftra,sumi.cprv From dbo.prod,dbo.sumi,dbo.prov Where prod.cprd=sumi.cprd and sumi.cprv IN (SELECT cprv FROM PROV Where prov.nomb='PROV1')

-- Usando la clausula EXISTS

	Select prod.cprd,prod.nomp,sumi.ftra,sumi.cprv From dbo.prod,dbo.sumi,dbo.prov Where prod.cprd=sumi.cprd and EXISTS (SELECT cprv FROM PROV Where prov.nomb='PROV1' and sumi.cprv=prov.cprv)

-- 7. Listar los proveedores que suministraron algun producto

-- Usando la clausula IN

	SELECT * FROM prov WHERE cprv IN (SELECT cprv FROM sumi)

-- Usando la clausula EXISTS

	SELECT * FROM prov WHERE EXISTS (SELECT cprv FROM sumi WHERE sumi.cprv=prov.cprv)

-- 8. Listar los proveedores que no suministraron producto

-- Usando la clausula IN

	SELECT * FROM prov WHERE cprv NOT IN (SELECT cprv FROM sumi)

-- Usando la clausula EXISTS

	SELECT * FROM prov WHERE NOT EXISTS (SELECT cprv FROM sumi WHERE sumi.cprv=prov.cprv)

-- 9. Listar los proveedores que suministraron productos de color rojo
-- hacer JOIN, EXISTS y COUNT

 SELECT prov.cprv,prod.colo FROM prov,sumi,prod WHERE sumi.cprd=prod.cprd AND sumi.cprv=prov.cprv AND prod.colo='ROJO'