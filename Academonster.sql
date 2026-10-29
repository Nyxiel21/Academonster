-- Trabalho de Banco de Dados
-- Tema: Sistema de uma Academia
-- Este banco foi feito para guardar informações dos alunos,
-- dos planos oferecidos e das matrículas realizadas.

-- Apaga o banco caso já exista e cria novamente.
DROP DATABASE IF EXISTS AcademiaDB;
CREATE DATABASE AcademiaDB;
USE AcademiaDB;

-- Tabela para cadastrar os alunos da academia.
CREATE TABLE Aluno (
    idAluno INT UNSIGNED NOT NULL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    dataNascimento DATE NOT NULL,
    telefone VARCHAR(20)
);

-- Tabela com os planos que a academia oferece.
CREATE TABLE Plano (
    idPlano INT UNSIGNED NOT NULL PRIMARY KEY,
    nomePlano VARCHAR(60) NOT NULL,
    valor DECIMAL(8,2) NOT NULL,
    duracaoDias INT UNSIGNED NOT NULL
);

-- Tabela que registra as matrículas dos alunos.
-- O idAluno indica quem fez a matrícula.
-- O idPlano indica qual plano foi escolhido.
CREATE TABLE Matricula (
    idMatricula INT UNSIGNED NOT NULL PRIMARY KEY,
    dataMatricula DATE NOT NULL,
    dataFim DATE NOT NULL,
    statusMatricula VARCHAR(20) NOT NULL,
    idAluno INT UNSIGNED NOT NULL,
    idPlano INT UNSIGNED NOT NULL,

    -- Relaciona a matrícula com um aluno cadastrado.
    CONSTRAINT fk_matricula_aluno
        FOREIGN KEY (idAluno) REFERENCES Aluno(idAluno),

    -- Relaciona a matrícula com um plano cadastrado.
    CONSTRAINT fk_matricula_plano
        FOREIGN KEY (idPlano) REFERENCES Plano(idPlano)
);

-- Cadastro de alguns alunos para testar o banco.
INSERT INTO Aluno (idAluno, nome, cpf, dataNascimento, telefone) VALUES
(1, 'Carlos Eduardo Silva', '12345678901', '2002-04-15', '(84) 99999-1111'),
(2, 'Maria Fernanda Oliveira', '23456789012', '2004-08-22', '(84) 98888-2222'),
(3, 'Joao Pedro Santos', '34567890123', '2001-12-03', '(84) 97777-3333'),
(4, 'Ana Beatriz Costa', '45678901234', '2003-06-10', NULL);

-- Cadastro dos planos e seus valores.
INSERT INTO Plano (idPlano, nomePlano, valor, duracaoDias) VALUES
(1, 'Mensal', 89.90, 30),
(2, 'Trimestral', 239.90, 90),
(3, 'Anual', 799.90, 365);

-- Cadastro das matrículas dos alunos.
INSERT INTO Matricula
    (idMatricula, dataMatricula, dataFim, statusMatricula, idAluno, idPlano)
VALUES
(101, '2026-01-10', '2026-02-09', 'Encerrada', 1, 1),
(102, '2026-03-01', '2026-05-30', 'Ativa', 1, 2),
(103, '2026-03-05', '2027-03-05', 'Ativa', 2, 3),
(104, '2026-02-15', '2026-03-17', 'Encerrada', 3, 1);

-- Consulta para ver todos os alunos cadastrados.
SELECT * FROM Aluno;

-- Consulta para ver os planos e seus preços.
SELECT * FROM Plano;

-- Consulta para ver todas as matrículas.
SELECT * FROM Matricula;

-- Mostra as matrículas junto com o nome do aluno e o plano escolhido.
-- O INNER JOIN junta as informações que estão relacionadas nas tabelas.
SELECT
    m.idMatricula AS 'Codigo da Matricula',
    a.nome AS 'Nome do Aluno',
    p.nomePlano AS 'Plano',
    p.valor AS 'Valor',
    m.dataMatricula AS 'Data da Matricula',
    m.dataFim AS 'Data de Termino',
    m.statusMatricula AS 'Situacao'
FROM Matricula m
INNER JOIN Aluno a ON m.idAluno = a.idAluno
INNER JOIN Plano p ON m.idPlano = p.idPlano;

-- Mostra todos os alunos, mesmo os que ainda não fizeram matrícula.
-- Quando não existe matrícula, os campos correspondentes aparecem como NULL.
SELECT
    a.idAluno AS 'Codigo do Aluno',
    a.nome AS 'Nome do Aluno',
    m.idMatricula AS 'Matricula',
    p.nomePlano AS 'Plano',
    m.statusMatricula AS 'Situacao'
FROM Aluno a
LEFT JOIN Matricula m ON a.idAluno = m.idAluno
LEFT JOIN Plano p ON m.idPlano = p.idPlano;

-- Mostra somente os alunos que estão com matrícula ativa.
SELECT
    a.nome AS 'Nome do Aluno',
    p.nomePlano AS 'Plano',
    m.dataFim AS 'Fim da Matricula'
FROM Matricula m
INNER JOIN Aluno a ON m.idAluno = a.idAluno
INNER JOIN Plano p ON m.idPlano = p.idPlano
WHERE m.statusMatricula = 'Ativa';

-- Exemplo de matrícula inválida:
-- Este comando daria erro porque o aluno de código 99 não está cadastrado.
-- A chave estrangeira impede esse tipo de cadastro.
-- INSERT INTO Matricula
-- (idMatricula, dataMatricula, dataFim, statusMatricula, idAluno, idPlano)
-- VALUES (105, '2026-04-01', '2026-05-01', 'Ativa', 99, 1);
