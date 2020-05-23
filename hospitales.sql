USE [asir-ander]

--Crear esquema de hospitales--

create schema hospitales

--Crear tabla pacientes--

Create table hospitales.pacientes
(
    numeroSeguridadSocial char(15) not null,
    nombre varchar(15) not null,
    apellidos varchar(30) not null,
    domicilio varchar(30) not null,
    poblacion varchar(25) not null,
    provincia varchar(15) not null,
    codigoPostal char(5) not null,
    telefono char(12) not null,
    numeroHistorial char(9) not null PRIMARY KEY,
    sexo char(1) not null CHECK(sexo = 'H' or sexo = 'M')
);

--Codigo de tabla medicos--

Create table hospitales.medicos
(
    medicosId char(4) not null PRIMARY KEY,
    nombre varchar(15) not null,
    apellido varchar(30) not null,
    Especialidad varchar(25) not null,
    fechaIngreso date not null,
    cargo varchar(25) not null,
    numeroColegiado int not null,
    observaciones varchar(500) null
);

--Codigo de tabla ingesos--

create TABLE hospitales.ingresos
(
    ingresoID int IDENTITY(1,1) PRIMARY KEY,
    numeroHistorial char(9) not null,
    fechaIngreso date not null,
    medicosId char(4) not null,
    numeroPlanta int not null,
    numeroCama int not null,
    alergico char(2) not null,
    observaciones varchar(500) null,
    costeTratamiento int not null,
    diagnostico varchar(40) not NULL
);

--Insertar datos--

--MEDICOS--
INSERT INTO hospitales.medicos (medicosId, nombre, apellido, especialidad, fechaIngreso, cargo, numeroColegiado, observaciones)
VALUES ('AJH','Antonio','Jaen Hernandez','Pediatria','12-08-82','Adjunto',2113,'Esta proxima su retirada')
INSERT INTO hospitales.medicos (medicosId, nombre, apellido, especialidad, fechaIngreso, cargo, numeroColegiado)
VALUES ('CEM','Carmen','Esterill Manrique','Psiquiatria','13-02-92','Jefe de seccion',1231)
INSERT INTO hospitales.medicos (medicosId, nombre, apellido, especialidad, fechaIngreso, cargo, numeroColegiado)
VALUES ('RLQ','Rocio','Lopez Quijada','Medico de familia','23-09-94','Titular',1331)

--PACIENTES--
INSERT INTO hospitales.pacientes (numeroSeguridadSocial, nombre, apellido, domicilio, poblacion, provincia, codigoPostal, telefono, numeroHistorial, sexo)
VALUES ('08/7888888','Jose Eduardo','Romerales Pinto','C/ Azorin, 34 3o','Mostoles','Madrid',28935,913458745,'10203-F','H')
INSERT INTO hospitales.pacientes (numeroSeguridadSocial, nombre, apellido, domicilio, poblacion, provincia, codigoPostal, telefono, numeroHistorial, sexo)
VALUES ('08/7234823','angel','Ruiz Picasso','C/ Salmeron, 212','Madrid','Madrid',28028,915653433,'11454-L','H')
INSERT INTO hospitales.pacientes (numeroSeguridadSocial, nombre, apellido, domicilio, poblacion, provincia, codigoPostal, telefono, numeroHistorial, sexo)
VALUES ('08/7333333','Mercedes','Romero Carvajal','C/ Malaga, 13','Mostoles','Madrid',28935,914556745,'14546-E','M')
INSERT INTO hospitales.pacientes (numeroSeguridadSocial, nombre, apellido, domicilio, poblacion, provincia, codigoPostal, telefono, numeroHistorial, sexo)
VALUES ('08/7555555','Martin','Fendendez Lopez','C/ Sastres, 21','Madrid','Madrid',28028,913333333,'15413-S','H')

--INGRESOS--
INSERT INTO hospitales.ingresos (numeroHistorial, fechaIngreso, medicosId, numeroPlanta, numeroCama, alergico, observaciones)
VALUES ('10203-F','23/01/2009','AJH',5,121,'No','Epileptico')
INSERT INTO hospitales.ingresos (numeroHistorial, fechaIngreso, medicosId, numeroPlanta, numeroCama, alergico, observaciones)
VALUES ('15413-S','13/03/2009','RLQ',2,5,'Si','Alergico a la penicilina')
INSERT INTO hospitales.ingresos (numeroHistorial, fechaIngreso, medicosId, numeroPlanta, numeroCama, alergico)
VALUES ('11454-L','25/05/2009','RLQ',3,31,'No')
INSERT INTO hospitales.ingresos (numeroHistorial, fechaIngreso, medicosId, numeroPlanta, numeroCama, alergico)
VALUES ('15413-S','29/01/2010','CEM',2,13,'No')
INSERT INTO hospitales.ingresos (numeroHistorial, fechaIngreso, medicosId, numeroPlanta, numeroCama, alergico, observaciones)
VALUES ('14546-E','24/02/2010','AJH',1,5,'Si','Alergico al Paidoterin')

--Consulta 1--

SELECT nombre, fechaIngreso
FROM hospitales.medicos

--Consulta 2--

SELECT nombre
from hospitales.pacientes
WHERE poblacion = 'Madrid'

--Consulta 3--

SELECT nombre
from hospitales.medicos as m
INNER JOIN hospitales.ingresos as i on m.medicosId = i.medicosId
WHERE i.fechaIngreso BETWEEN '01-01-2010' and '28-02-2010'

--Consulta 4--

SELECT nombre
FROM hospitales.pacientes as p
INNER JOIN hospitales.ingresos as i on p.numeroHistorial = i.numeroHistorial
WHERE (i.fechaIngreso BETWEEN '01-01-2009' and '31-05-2009') and alergico = 'Si'

--Consulta 5--

SELECT p.*
from hospitales.pacientes as p
INNER JOIN hospitales.ingresos as i on p.numeroHistorial = i.numeroHistorial
INNER JOIN hospitales.medicos as m on i.medicosId = m.medicosId
where i.medicosId = 'AJH'

--Preocedimiento para Introducir un medico--

Create PROCEDURE hospitales.pr_fechaIngreso
    @p_medicosId char(4),
    @p_nombre varchar(15),
    @p_apellido varchar(30),
    @p_Especialidad varchar(25),
    @p_fechaIngreso date,
    @p_cargo varchar(25),
    @p_numeroColegiado int,
    @p_observaciones varchar(500)
AS
BEGIN

    IF @p_numeroColegiado < 1000
    PRINT 'El numero de colegiado tiene que ser superior a 999'
        ELSE
            BEGIN
                INSERT INTO hospitales.medicos (medicosId, nombre, apellido, especialidad, fechaIngreso, cargo, numeroColegiado, observaciones)
                VALUES (@p_medicosId, @p_nombre, @p_apellido, @p_Especialidad, @p_fechaIngreso, @p_cargo, @p_numeroColegiado, @p_observaciones)
            end
        END

--Procedimiento para sacar datos de dos fechas--
CREATE PROCEDURE hospitales.fechasPacientes
    @p_fechaInicio DATE,
    @p_fechaFinal DATE
AS
BEGIN
    select p.*
    from hospitales.pacientes AS p
    inner join hospitales.ingresos as i on p.numeroHistorial = i.numeroHistorial
    where fechaIngreso BETWEEN @p_fechaInicio and @p_fechaFinal
END

--Contar el numero de pacientes en el sistema--

CREATE FUNCTION hospitales.fn_contarPacientes()
RETURNS INT
as
BEGIN
    DECLARE @numeroTotal INT
    select @numeroTotal = COUNT(numeroHistorial) from hospitales.pacientes
    RETURN @numeroTotal
END

--Contar los pacientes Hombres y Mujeres--

create function hospitales.fn_generoPacientes(@genero char)
returns int
AS
BEGIN
    declare @numeroTotal INT
    select @numeroTotal = count(sexo) from hospitales.pacientes
    return @numeroTotal
END
