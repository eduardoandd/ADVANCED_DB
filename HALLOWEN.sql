CREATE DATABASE HALLOWEEN;
USE HALLOWEEN;

CREATE TABLE TABELA_USUARIOS (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    NOME VARCHAR(100) NOT NULL,
    EMAIL VARCHAR(100) NOT NULL,
    IDADE INT NOT NULL
);


DELIMITER $$

CREATE PROCEDURE INSERT_RANDOM_USERS ()
BEGIN
    DECLARE i INT DEFAULT 0;
    
   
    WHILE i < 10000 DO
        
        SET @nome := CONCAT('Usuario', i);
        SET @email := CONCAT('usuario', i, '@exemplo.com');
        SET @idade := FLOOR(RAND() * 80) + 18;  
        
       
        INSERT INTO tabela_usuarios (nome, email, idade) VALUES (@nome, @email, @idade);
        
        SET i = i + 1;
    END WHILE;
END$$ 
CALL INSERT_RANDOM_USERS()
SELECT * FROM tabela_usuarios

DELIMITER ;