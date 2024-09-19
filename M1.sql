use clinica_;

CREATE TABLE Pacientes (
    id_paciente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    especie VARCHAR(50),
    idade INT
);

CREATE TABLE Veterinarios (
    id_veterinario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    especialidade VARCHAR(50)
);

CREATE TABLE Consultas (
    id_consulta INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente INT,
    id_veterinario INT,
    data_consulta DATE,
    custo DECIMAL(10, 2),
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente),
    FOREIGN KEY (id_veterinario) REFERENCES Veterinarios(id_veterinario)
);

CREATE TABLE Log_Consultas (
    id_log INT PRIMARY KEY AUTO_INCREMENT,
    id_consulta INT,
    custo_antigo DECIMAL(10, 2),
    custo_novo DECIMAL(10, 2)
);

INSERT INTO Pacientes (nome, especie, idade) 
VALUES 
('Zeca', 'Cachorro', 5),
('Mingau', 'Gato', 3),
('Bobby', 'Cachorro', 7),
('Tico', 'Cavalo', 8),
('Pingo', 'Pássaro', 2),
('Luna', 'Gato', 4),
('Fiona', 'Cachorro', 6),
('Zeus', 'Cavalo', 10),
('Mel', 'Pássaro', 3),
('Max', 'Cachorro', 9),
('Tarantula', 'Coelho', 2),
('Sushi', 'Gato', 1),
('Nina', 'Cachorro', 4),
('Apolo', 'Cavalo', 5),
('Bidu', 'Cachorro', 6);

INSERT INTO Veterinarios (nome, especialidade) 
VALUES 
('Dr. Ana', 'Cardiologia'),
('Dr. Carlos', 'Dermatologia'),
('Dr. Beatriz', 'Cirurgia'),
('Dr. João', 'Oftalmologia'),
('Dr. Marina', 'Endocrinologia'),
('Dr. Felipe', 'Fisiterapeuta'),
('Dr. Júlia', 'Neurologia'),
('Dr. Pedro', 'Reprodução Animal'),
('Dr. Paula', 'Oncologia'),
('Dr. Bruna', 'Comportamento Animal'),
('Dr. Clara', 'Fisioterapia'),
('Dr. Tiago', 'Imunologia'),
('Dr. Sofia', 'Odontologia'),
('Dr. Gabriel', 'Nefrologia'),
('Dr. Roberto', 'Ginecologista');

INSERT INTO Consultas (id_paciente, id_veterinario, data_consulta, custo) 
VALUES
(1, 1, '2024-09-25', 250.00), 
(2, 2, '2024-09-26', 150.00), 
(3, 3, '2024-09-27', 300.00), 
(4, 4, '2024-09-28', 400.00),
(5, 5, '2024-09-29', 120.00), 
(6, 6, '2024-09-30', 500.00), 
(7, 7, '2024-10-01', 200.00), 
(8, 8, '2024-10-02', 600.00),
(9, 9, '2024-10-03', 100.00), 
(10, 10, '2024-10-04', 250.00), 
(11, 11, '2024-10-05', 350.00), 
(12, 12, '2024-10-06', 450.00),
(13, 13, '2024-10-07', 300.00), 
(14, 14, '2024-10-08', 200.00), 
(15, 15, '2024-10-09', 500.00);

DELIMITER //
CREATE PROCEDURE agendar_consulta(
    IN p_id_paciente INT,
    IN p_id_veterinario INT,
    IN p_data_consulta DATE,
    IN p_custo DECIMAL(10, 2)
)
BEGIN
    INSERT INTO Consultas (id_paciente, id_veterinario, data_consulta, custo)
    VALUES (p_id_paciente, p_id_veterinario, p_data_consulta, p_custo);
END;



DELIMITER //
CREATE PROCEDURE atualizar_paciente(
    IN p_id_paciente INT,
    IN p_novo_nome VARCHAR(100),
    IN p_nova_especie VARCHAR(50),
    IN p_nova_idade INT
)
BEGIN
    UPDATE Pacientes
    SET nome = p_novo_nome, especie = p_nova_especie, idade = p_nova_idade
    WHERE id_paciente = p_id_paciente;
END;


DELIMITER //

CREATE PROCEDURE remover_consulta(
    IN p_id_consulta INT
)
BEGIN
    DELETE FROM Consultas
    WHERE id_consulta = p_id_consulta;
END;



DELIMITER $$

CREATE FUNCTION total_gasto_paciente(
    p_id_paciente INT
)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10, 2);
    
    SELECT SUM(custo) INTO total
    FROM Consultas
    WHERE id_paciente = p_id_paciente;
    
    RETURN IFNULL(total, 0);
END$$

DELIMITER ;



CREATE TRIGGER atualizar_custo_consulta
AFTER UPDATE ON Consultas
FOR EACH ROW
BEGIN
    IF OLD.custo <> NEW.custo THEN
        INSERT INTO Log_Consultas (id_consulta, custo_antigo, custo_novo)
        VALUES (NEW.id_consulta, OLD.custo, NEW.custo);
    END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER verificar_idade_paciente
BEFORE INSERT ON Pacientes
FOR EACH ROW
BEGIN
    IF NEW.idade <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Idade inválida. Deve ser um número positivo.';
    END IF;
END$$

DELIMITER ;


DELIMITER $$

