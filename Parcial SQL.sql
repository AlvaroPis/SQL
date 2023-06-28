CREATE DATABASE BBDDTP2
USE [BBDDTP2]

CREATE TABLE tipos_comprobantes (
      id_tipo_comprobante INT PRIMARY KEY,
      descrip_comprobante VARCHAR(50)
   );

CREATE TABLE tipos_documentos (
      id_tipo_documento INT PRIMARY KEY,
      descrip_documento VARCHAR(50)
   );


CREATE TABLE Clientes (
      id_cliente INT IDENTITY(1,1) PRIMARY KEY,
      Razon_Social VARCHAR(50),
      id_tipo_documento INT,
      nro_documento VARCHAR(50) 
   );


CREATE TABLE Comprobantes (
   nro_comprobante INT IDENTITY(1,1) PRIMARY KEY,
   fecha DATE,
   id_tipo_comprobante INT,
   id_cliente INT,
   importe NUMERIC(10, 2)
);



   ALTER TABLE Clientes
   ADD CONSTRAINT fk_clientes_tipos_documentos
   FOREIGN KEY (id_tipo_documento) REFERENCES tipos_documentos(id_tipo_documento);


   ALTER TABLE Comprobantes
   ADD CONSTRAINT fk_comprobantes_tipos_comprobantes
   FOREIGN KEY (id_tipo_comprobante) REFERENCES tipos_comprobantes(id_tipo_comprobante);


   ALTER TABLE Comprobantes
   ADD CONSTRAINT fk_comprobantes_clientes
   FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente);



INSERT INTO tipos_documentos (id_tipo_documento, descrip_documento) VALUES (0, 'Ningun Documento');
INSERT INTO tipos_documentos (id_tipo_documento, descrip_documento) VALUES (1, 'D.N.I.');
INSERT INTO tipos_documentos (id_tipo_documento, descrip_documento) VALUES (2, 'C.U.I.L.');
INSERT INTO tipos_documentos (id_tipo_documento, descrip_documento) VALUES (3, 'C.U.I.T.');
INSERT INTO tipos_documentos (id_tipo_documento, descrip_documento) VALUES (4, 'Cedula de Identificacion');
INSERT INTO tipos_documentos (id_tipo_documento, descrip_documento) VALUES (5, 'Pasaporte');
INSERT INTO tipos_documentos (id_tipo_documento, descrip_documento) VALUES (6, 'Libreta Civica');
INSERT INTO tipos_documentos (id_tipo_documento, descrip_documento) VALUES (7, 'Libreta de Enrolamiento');



INSERT INTO tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) VALUES (1, 'Factura A');
INSERT INTO tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) VALUES (2, 'Nota Debito A');
INSERT INTO tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) VALUES (3, 'Nota Credito A');
INSERT INTO tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) VALUES (4, 'Recibos A');
INSERT INTO tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) VALUES (5, 'Nota Venta Contado A');
INSERT INTO tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) VALUES (6, 'Factura B');
INSERT INTO tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) VALUES (7, 'Nota Debito B');
INSERT INTO tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) VALUES (8, 'Nota Credito B');
INSERT INTO tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) VALUES (9, 'Recibo B');
INSERT INTO tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) VALUES (10, 'Nota Venta Contado B');
INSERT INTO tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) VALUES (11, 'Facturas C');
INSERT INTO tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) VALUES (12, 'Nota Debito C');
INSERT INTO tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) VALUES (13, 'Nota Credito C');
INSERT INTO tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) VALUES (15, 'Recibo C');
INSERT INTO tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) VALUES (16, 'Nota Venta Contado C');
INSERT INTO tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) VALUES (81, 'Tique Factura A');
INSERT INTO tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) VALUES (82, 'Tique Factura B');
INSERT INTO tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) VALUES (83, 'Tique');
INSERT INTO tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) VALUES (111, 'Tique Factura C');
INSERT INTO tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) VALUES (112, 'Tique Nota Credito A');
INSERT INTO tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) VALUES (113, 'Tique Nota Credito B');
INSERT INTO tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) VALUES (114, 'Tique Nota Credito C');



INSERT INTO Clientes ( Razon_Social, id_tipo_documento, nro_documento) VALUES ('MARIA LUZ DAL BELLO', 1, 16053181);
INSERT INTO Clientes ( Razon_Social, id_tipo_documento, nro_documento) VALUES ('FRANCO PISTELLI', 1, 36662602);
INSERT INTO Clientes ( Razon_Social, id_tipo_documento, nro_documento) VALUES ('OSCAR PISTELLI', 1, 14999215);
INSERT INTO Clientes ( Razon_Social, id_tipo_documento, nro_documento) VALUES ('GUILLERMO PISTELLI', 1, 41489284);
INSERT INTO Clientes ( Razon_Social, id_tipo_documento, nro_documento) VALUES ('ALVARO PISTELLII', 1, 41489288);

SELECT * FROM CLIENTES

ALTER TABLE Clientes ADD acumulado_compras  NUMERIC(10, 2) NOT NULL DEFAULT 0;





CREATE TRIGGER tr_actualizar_acumulado_compras
ON Comprobantes
AFTER INSERT
AS
BEGIN
	declare @monto numeric (10,2)
	SELECT @monto = importe FROM inserted

    UPDATE c SET c.acumulado_compras = c.acumulado_compras + @monto
    FROM Clientes c
    INNER JOIN inserted i ON c.id_cliente = i.id_cliente
END;





INSERT INTO Comprobantes (id_tipo_comprobante, fecha, id_cliente, importe)
VALUES ( 2, CONVERT(DATE, GETDATE()), 13, 10000);





create FUNCTION mostrar_comprobante (@comprobante_id INT)
RETURNS TABLE
AS
RETURN (
    SELECT nro_comprobante, fecha, id_tipo_comprobante, id_cliente, importe, importe / 1.21 AS base_imponible
    FROM comprobantes
    WHERE @comprobante_id = nro_comprobante
);


SELECT * FROM dbo.mostrar_comprobante(2);



CREATE PROCEDURE mostrar_total_facturado ( @fecha_desde DATE,  @fecha_hasta DATE)
AS
BEGIN
    SELECT SUM(importe) AS total_facturado
    FROM Comprobantes
    WHERE fecha BETWEEN @fecha_desde AND @fecha_hasta;
END;

EXEC mostrar_total_facturado '2000/01/01', '2023/07/30';





CREATE VIEW vista_comprobantes AS
SELECT c.nro_comprobante, c.fecha, t.descrip_comprobante, cl.Razon_Social, c.importe
FROM Comprobantes c
INNER JOIN tipos_comprobantes t ON c.id_tipo_comprobante = t.id_tipo_comprobante
INNER JOIN Clientes cl ON c.id_cliente = cl.id_cliente;


select * from vista_comprobantes;







CREATE PROCEDURE GeneradorDeArchivos
AS
BEGIN
	SET NOCOUNT ON;
	DROP TABLE TempArchivo;
	SELECT concat(
		(CONVERT(NVARCHAR(8), c.fecha, 112)),
		(RIGHT('000' + CONVERT(NVARCHAR(3), c.id_tipo_comprobante),3)), 
		(RIGHT('00000000000000000000' + CONVERT(NVARCHAR(20), c.nro_comprobante),20) ),
		(RIGHT('00000000000000000000' + CONVERT(NVARCHAR(20), c.id_cliente), 20)),
		(RIGHT('00' + CONVERT(NVARCHAR(2), r.id_tipo_documento),2) ), 
		(RIGHT('00000000000000000000' + CONVERT(NVARCHAR(20), r.nro_documento), 20) ),
		(LEFT ( CONVERT (NVARCHAR(30),r.Razon_Social)+'                              ', 30)),
		(RIGHT ('000000000000000' + (replace (convert (varchar(15),c.importe,15),'.','')),15))
		) AS registro
		INTO TempArchivo
FROM Comprobantes c
INNER JOIN Clientes r ON c.id_cliente = r.id_cliente
INNER JOIN tipos_comprobantes t ON c.id_tipo_comprobante = t.id_tipo_comprobante
ORDER BY fecha;
END;


exec GeneradorDeArchivos

EXEC xp_cmdshell 'bcp "SELECT * FROM dbo.TempArchivo" queryout "c:\BBDDTP2\REGINFO_UAI_CBTE.txt" -c -T -S DESKTOP-M6BEUD9 -d BBDDTP2'

select * from dbo.TempArchivo


EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE;