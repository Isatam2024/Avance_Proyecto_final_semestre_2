CREATE DATABASE Huella_de_carbono_Universitaria;

USE Huella_de_carbono_Universitaria;

CREATE TABLE Universidades (
  ID INT PRIMARY KEY,
  Nombre VARCHAR(255) NOT NULL,
  Direccion VARCHAR(255) NOT NULL,
  Ciudad VARCHAR(100) NOT NULL,
  Pais VARCHAR(100) NOT NULL
);

CREATE TABLE Bloque (
  ID INT PRIMARY KEY,
  Nombre VARCHAR(255) NOT NULL,
  Universidad_ID INT NOT NULL,
  Direccion VARCHAR(255) NOT NULL,
  Area_bloque FLOAT NOT NULL,
  FOREIGN KEY (Universidad_ID) REFERENCES Universidades(ID)
);

ALTER TABLE Bloque
DROP COLUMN Direccion;

CREATE TABLE Fuentes_emisiones (
  ID INT PRIMARY KEY,
  Nombre VARCHAR(255) NOT NULL,
  Unidad_medida VARCHAR(100) NOT NULL
);

CREATE TABLE Consumos (
  ID INT PRIMARY KEY,
  Bloque_ID INT NOT NULL,
  Fuente_emision_ID INT NOT NULL,
  Fecha DATE NOT NULL,
  Valor FLOAT NOT NULL,
  FOREIGN KEY (Bloque_ID) REFERENCES Bloque(ID),
  FOREIGN KEY (Fuente_emision_ID) REFERENCES Fuentes_emisiones(ID)
);

CREATE TABLE Emisiones (
  ID INT PRIMARY KEY,
  Consumos_ID INT NOT NULL,
  co2equivalente FLOAT NOT NULL,
  Otros_gases FLOAT NOT NULL,
  FOREIGN KEY (Consumos_ID ) REFERENCES Consumos(ID)
);

DELIMITER $$
DROP PROCEDURE IF EXISTS Detalles_Fuente_Emisiones;

CREATE PROCEDURE Detalles_Fuente_Emisiones()
BEGIN
    SELECT * FROM Fuentes_emisiones;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE insertarfuenteemision(
    IN p_ID INT,
    IN p_Nombre VARCHAR(255),
    IN p_Unidad_medida VARCHAR(100)
)
BEGIN
    INSERT INTO Fuentes_emisiones (ID, Nombre, Unidad_medida)
    VALUES (p_id, p_nombre, p_unidad_medida);
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE actualizarNombreFuenteEmision(
    IN p_id INT,
    IN p_nombre VARCHAR(255)
)
BEGIN
    UPDATE Fuentes_emisiones
    SET Nombre = p_nombre
    WHERE ID = p_id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE BorrarFuenteEmision(
    IN p_id INT
)
BEGIN
    DELETE FROM Fuentes_emisiones
    WHERE ID = p_id;
END$$

DELIMITER ;



