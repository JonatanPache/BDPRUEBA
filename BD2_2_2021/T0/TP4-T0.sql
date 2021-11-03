/*
	TP4-T0 (Practica de Programación de Consultas SQL - Parte II)
	AUTOR: YONATAN JEREMIAS CONDORI PACHECO
	NREG: 217013252
	DATE:10/19/2021
*/

--REUNION NATURAL

--Listar los productos suministrados hasta la fecha, se debe mostrar: Código Producto, 
--Nombre del Producto y Cantidad. La lista debe estar ordenado por el Nombre del Producto.

	SELECT PROD.CPRD,PROD.NOMP,SUMI.CANT FROM PROD,SUMI WHERE PROD.CPRD=SUMI.CPRD AND SUMI.FTRA<=GETDATE() ORDER BY NOMP

--Listar los productos suministrados a la ciudad de Santa Cruz, Cochabamba y Beni se debe 
--mostrar: Código Producto, Nombre del Producto, Cantidad, Fecha, Precio, Nombre del Almacén.
--La lista debe estar ordenado por el Nombre del Almacen seguido por Nombre del Producto.

	SELECT PROD.CPRD,PROD.NOMP,SUMI.CANT,SUMI.FTRA,SUMI.PREC,ALMA.NOMA,ALMA.CIUD FROM PROD,SUMI,ALMA 
	WHERE PROD.CPRD=SUMI.CPRD AND ALMA.CALM=SUMI.CALM AND ALMA.CIUD IN ('CB','SC','BE')

--Listar los productos suministrados por los proveedores de la ciudad de La Paz a la ciudad de Santa Cruz,
--se debe mostrar: Código Producto, Nombre del Producto, Cantidad, Precio, Fecha, Nombre del Almacén, Nombre 
--del Proveedor. La lista debe estar ordenado por el Nombre del Proveedor, Nombre del Almacen y Nombre del Producto.

	select prod.nomp,prov.nomb,alma.ciud as almaciud,prov.ciud as provciud from Demo_Tienda.dbo.prod,Demo_Tienda.dbo.prov,Demo_Tienda.dbo.sumi,Demo_Tienda.dbo.alma 
	where sumi.cprv=prov.cprv and prov.ciud='LP' and alma.ciud='SC' and prod.cprd=sumi.cprd and sumi.calm=alma.calm

--Listar los productos suministrados por el proveedor  PRV2 cuyos importes superen a 10 Bs, se debe mostrar: 
--Código del Producto, Nombre del Producto, Fecha, Cantidad, Precio, Importe e Importe de Descuento. El Importe 
--de Descuento equivale al 10% del Importe por cada producto. La lista debe estar ordenado por el Nombre del Proveedor, 
--Nombre del Almacen y Nombre del Producto.

	select prod.cprd,prod.nomp,prov.nomb,sumi.ftra,sumi.cant,sumi.prec,sumi.impt,sumi.impt-sumi.impt*0.1 as descuento from Demo_Tienda.dbo.prod,Demo_Tienda.dbo.prov,Demo_Tienda.dbo.sumi,Demo_Tienda.dbo.alma 
	where sumi.cprv=prov.cprv and prov.nomb='PROV2' and alma.calm=sumi.calm and prod.cprd=sumi.cprd and sumi.impt>10


--USO DE LA CLAUSULA IN / EXISTS

--Listar los Productos Existentes en los almacenes de la ciudad de Santa Cruz

	select * from Demo_Tienda.dbo.prod where cprd 
in (select cprd from Demo_Tienda.dbo.sumi,Demo_Tienda.dbo.alma where sumi.calm=alma.calm and alma.ciud='SC')

--Listar los Proveedores que Suministraron algún Producto

	select prov.cprv,prov.nomb,prod.nomp from Demo_Tienda.dbo.prov,Demo_Tienda.dbo.sumi,Demo_Tienda.dbo.prod
where prov.cprv=sumi.cprv and prod.cprd=sumi.cprd and sumi.cant>0 group by prov.nomb

--Listar los Proveedores que todavía no suministraron productos.

	select * from Demo_Tienda.dbo.prov where cprv 
	not in (select sumi.cprv from Demo_Tienda.dbo.sumi where sumi.cprv=prov.cprv and sumi.cant>0) 

--Listar los Productos Suministrados por el Proveedor PRV3

	select * from Demo_Tienda.dbo.prod where cprd
	in (select sumi.cprd from Demo_Tienda.dbo.sumi,Demo_Tienda.dbo.prov where prov.cprv=sumi.cprv and prov.nomb='PROV3')

--Listar los nombres de los proveedores que suministraron algún producto color rojo

	select * from Demo_Tienda.dbo.prov where cprv
	in (select sumi.cprv from Demo_Tienda.dbo.sumi,Demo_Tienda.dbo.prod where prod.colo='ROJO')

--Listar los Productos existente en el Almacén 1,que fueron suministrado por el Proveedor PRV1
	
	select * from Demo_Tienda.dbo.prod where cprd
in (select sumi.cprd from Demo_Tienda.dbo.alma,Demo_Tienda.dbo.sumi,Demo_Tienda.dbo.prov 
	where prov.cprv=sumi.cprv and sumi.calm=alma.calm and alma.noma='ALM1' and prov.nomb='PROV1')

--Listar los Productos de color Amarillo suministrados por el Proveedor PRV2

--Listar los nombres de proveedores que suministraron todos los productos.

	select prov.nomb from Demo_Tienda.dbo.prov where cprv 
	in (select sumi.cprv from Demo_Tienda.dbo.sumi where sumi.cprv=prov.cprv and sumi.cant>0) 

--Listar los nombres de los proveedores que suministraron algún producto fuera de su ciudad.

	select prov.nomb from Demo_Tienda.dbo.prov where cprv 
	in (select sumi.cprv from Demo_Tienda.dbo.sumi,Demo_Tienda.dbo.alma where prov.ciud<>alma.ciud and sumi.calm=alma.calm)

--Listar los nombres de los proveedores que suministraron producto en todos los almacenes de la ciudad de Santa Cruz.

	select * from Demo_Tienda.dbo.prov where cprv 
in (select sumi.cprv from Demo_Tienda.dbo.sumi,Demo_Tienda.dbo.alma where sumi.calm=alma.calm and alma.ciud='SC')

--USO DE FUNCIONES AGREGADAS SUM, AVG, COUNT, MAX y MIN

/*Mostrar el Stock existente del producto PRD1 en la ciudad de Santa ruz.
Mostrar el Inventario Valorado del producto PRD2.
Mostrar la cantidad más alta suministrada del producto PRD1 en la ciudad de La Paz.*/
--Mostrar la última fecha que se suministró el producto PRD1 por el proveedor PRV3.

	select max(sumi.ftra) from Demo_Tienda.dbo.sumi,Demo_Tienda.dbo.prov,Demo_Tienda.dbo.prod 
	where sumi.cprd=prod.cprd and sumi.cprv=prov.cprv and prod.nomp='PRD1' and prov.nomb='PROV3' 

--Mostrar en qué fecha por primera vez suministró algún producto de color Rojo el proveedor PRV1.

	select min(sumi.ftra) from Demo_Tienda.dbo.sumi,Demo_Tienda.dbo.prov,Demo_Tienda.dbo.prod 
	where sumi.cprd=prod.cprd and sumi.cprv=prov.cprv and prod.colo='ROJO' and prov.nomb='PROV1' 

--Mostrar el importe promedio de productos suministrados por el proveedor PRV3.

	select avg(sumi.impt) as prom from Demo_Tienda.dbo.sumi,Demo_Tienda.dbo.prov
	where sumi.cprv=prov.cprv and prov.nomb='PROV3'

--Mostrar el Stock existente de cada producto existente en la ciudad de Santa Cruz.
--Mostrar el Inventario Valorado existente por cada almacén.

--Mostrar la cantidad más alta suministrada de cada producto en la ciudad de La Paz, siempre que la cantidad total de cada producto supere a 20.

--Mostrar la última fecha de cada producto suministrada por el proveedor PRV3.

	select sumi.cprd,sumi.cprv,sumi.ftra from Demo_Tienda.dbo.prov,Demo_Tienda.dbo.sumi 
	where prov.cprv=sumi.cprv and prov.nomb='PROV3' 

--Mostrar por cada proveedor cual fue la fecha que por primera vez suministró algún producto.

	select * from Demo_Tienda.dbo.sumi,Demo_Tienda.dbo.prov 
	where prov.cprv=sumi.cprv group by nomb

--Mostrar el importe promedio en cada almacén y por cada producto suministrado.Debe enviar
	
	select sumi.calm,alma.calm,alma.noma from Demo_Tienda.dbo.alma,Demo_Tienda.dbo.sumi
	where sumi.calm=alma.calm 