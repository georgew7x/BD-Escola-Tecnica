----------------------------------------- BD -----------------------------------------

CREATE DATABASE ESCOLA_TECNICA

USE ESCOLA_TECNICA

----------------------------------------- Tabelas -----------------------------------------

CREATE TABLE INSTRUTOR(
CodInstrutor INT IDENTITY NOT NULL,
RGInstrutor VARCHAR(14) NOT NULL,
NomeInstrutor VARCHAR(50) NOT NULL,
DataNascimentoInstrutor DATE NOT NULL,
TitulacaoInstrutor VARCHAR(20) NOT NULL,
TelefoneInstrutor VARCHAR(20),
PRIMARY KEY(CodInstrutor));

CREATE TABLE TURMA(
CodTurma INT IDENTITY NOT NULL,
HorarioAula TIME NOT NULL,
DuracaoAula TIME NOT NULL,
DataInicial DATE NOT NULL,
DataFinal DATE NOT NULL,
CursoTurma VARCHAR(20) NOT NULL,
INSTRUTOR INT NOT NULL,
PRIMARY KEY(CodTurma),
FOREIGN KEY (INSTRUTOR) REFERENCES INSTRUTOR(CodInstrutor));

CREATE TABLE ALUNO(
CodMatricula INT IDENTITY NOT NULL,
DataMatricula SMALLDATETIME NOT NULL,
NomeAluno VARCHAR(50) NOT NULL,
EnderecoAluno VARCHAR(100) NOT NULL,
TelefoneAluno VARCHAR (20),
DataNascimentoAluno DATE NOT NULL,
AlturaAluno FLOAT NOT NULL,
PesoAluno FLOAT NOT NULL,
FaltasAluno INT,
TURMAS INT NOT NULL,
FOREIGN KEY (TURMAS) REFERENCES TURMA(CodTurma));

----------------------------------------- Inserts -----------------------------------------

INSERT INTO INSTRUTOR (RGInstrutor, NomeInstrutor, DataNascimentoInstrutor, TitulacaoInstrutor, TelefoneInstrutor) VALUES ('048.112.345-99', 'CLAUDIO SILVA', '1988-05-30', 'POS GRADUADO', '77 9992-0941')
INSERT INTO INSTRUTOR (RGInstrutor, NomeInstrutor, DataNascimentoInstrutor, TitulacaoInstrutor, TelefoneInstrutor) VALUES ('179.665.999-22', 'RAFAEL NETO', '1980-12-21', 'MESTRADO', '55 8755-7024')
SELECT * FROM INSTRUTOR
  
INSERT INTO TURMA (HorarioAula, DuracaoAula, DataInicial, DataFinal, CursoTurma, INSTRUTOR) VALUES ('18:50:00', '03:20:00', '2022-01-01', '2022-06-01', 'BANCO DE DADOS II', 1)
INSERT INTO TURMA (HorarioAula, DuracaoAula, DataInicial, DataFinal, CursoTurma, INSTRUTOR) VALUES ('07:30:00', '04:30:00', '2022-06-01', '2022-11-01', 'MATEMATICA', 2)
SELECT * FROM TURMA

INSERT INTO ALUNO (DataMatricula, NomeAluno, EnderecoAluno, TelefoneAluno, DataNascimentoAluno, AlturaAluno, PesoAluno, TURMAS, FaltasAluno) VALUES (GETDATE(), 'PEDRO', 'RUA TAL', '77 9199-8823', '2002-09-27', '170.5', '81.2', 1, 0)
INSERT INTO ALUNO (DataMatricula, NomeAluno, EnderecoAluno, TelefoneAluno, DataNascimentoAluno, AlturaAluno, PesoAluno, TURMAS, FaltasAluno) VALUES (GETDATE(), 'ALAN', 'RUA 5 DE JULHO', '71 6384-1234', '2001-02-09', '160.1', '75.9', 1, 0)
INSERT INTO ALUNO (DataMatricula, NomeAluno, EnderecoAluno, TelefoneAluno, DataNascimentoAluno, AlturaAluno, PesoAluno, TURMAS, FaltasAluno) VALUES (GETDATE(), 'IRAN', 'RUA MAGALHAES', '11 9666-9385', '2000-01-20', '194.5', '102.7', 2, 0)
SELECT * FROM ALUNO

----------------------------------------- Indices -----------------------------------------

CREATE NONCLUSTERED INDEX IDX_InstrutorTitulacao
      ON INSTRUTOR (TitulacaoInstrutor);

CREATE CLUSTERED INDEX IDX_AlunoNome
      ON ALUNO (NomeAluno);

CREATE NONCLUSTERED INDEX IDX_AlunoTurma
      ON ALUNO (TURMAS);

CREATE NONCLUSTERED INDEX IDX_TurmaInstrutor
      ON TURMA (INSTRUTOR);

----------------------------------------- Views -----------------------------------------

CREATE VIEW VW_ALUNOSTURMA AS SELECT * FROM ALUNO WHERE TURMAS = 1;
SELECT * FROM VW_ALUNOSBD

CREATE VIEW VW_MATRICULARECENTE AS SELECT * FROM ALUNO WHERE DataMatricula > '2022-06-01 00:00:00';
SELECT * FROM VW_MATRICULARECENTE

CREATE VIEW VW_AULAS2SEMESTRE AS SELECT * FROM TURMA WHERE DataInicial >= '2022-06-01 ';
SELECT * FROM VW_AULAS2SEMESTRE

CREATE VIEW VW_INSTRUTORMESTRADO AS SELECT * FROM INSTRUTOR WHERE TitulacaoInstrutor LIKE 'MESTRADO';
SELECT * FROM VW_INSTRUTORMESTRADO

CREATE VIEW VW_ALUNONOMEASC AS SELECT TOP 100 PERCENT * FROM ALUNO ORDER BY NomeAluno;
SELECT * FROM VW_ALUNONOMEASC

----------------------------------------- Procedures -----------------------------------------

CREATE PROCEDURE SP_MATRICULARALUNO @ALUNONOME VARCHAR(50), @ALUNOENDERECO VARCHAR(100), @ALUNOTELEFONE VARCHAR(20), @ALUNODATANASCIMENTO DATE, @ALUNOALTURA FLOAT, @ALUNOPESO FLOAT, @TURMA INT AS INSERT INTO ALUNO (DataMatricula, NomeAluno, EnderecoAluno, TelefoneAluno, DataNascimentoAluno, AlturaAluno, PesoAluno, TURMAS, FaltasAluno) VALUES (GETDATE(), @ALUNONOME, @ALUNOENDERECO, @ALUNOTELEFONE, @ALUNODATANASCIMENTO, @ALUNOALTURA, @ALUNOPESO, @TURMA, 0);
EXEC SP_MATRICULARALUNO 'ENZO', 'RUA CASTRO ALVES', '99 0401-8878', '1999-10-14', '169.2', '68.2', 2

CREATE PROCEDURE SP_ALUNOSNOME @AlunoNomeSP VARCHAR(50) AS SELECT * FROM ALUNO WHERE NomeAluno LIKE '%' + @AlunoNomeSP + '%';
EXEC SP_ALUNOSNOME 'EDR'

CREATE PROCEDURE SP_FALTAALUNO @AlunoFaltaSP INT AS UPDATE ALUNO SET FaltasAluno += 1 WHERE CodMatricula = @AlunoFaltaSP
EXEC SP_FALTAALUNO 1

----------------------------------------------------------------------------------------------