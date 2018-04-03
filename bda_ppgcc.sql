/*
DROP TYPE aluno_type;
DROP TYPE professor_type;
DROP TYPE pessoa_type;
DROP TYPE endereco_type;
DROP TYPE estado_civil_type;
DROP TYPE disciplina_type;
DROP TYPE turma_type;


DROP TABLE disciplina_professor;
DROP TABLE professor_turma;
DROP TABLE professor;
DROP TABLE aluno;
DROP TABLE turma;
DROP TABLE disciplina;
DROP TABLE pessoa;
*/

/**
* DEFININDO TIPOS
*/

-- TIPO ENDEREÇO
CREATE TYPE endereco_type  AS (
	logradouro VARCHAR(100),
	complemento VARCHAR(20),
	bairro VARCHAR(20),
	cidade VARCHAR(20),
	cep VARCHAR(10),
	abreviacao_estado VARCHAR(2)
);

--TIPO (ENUM) ESTADO CIVIL
CREATE TYPE estado_civil_type AS ENUM('SOLTEIRO', 'CASADO', 'SEPARADO', 'DIVORCIADO', 'VIÚVO');

-- TIPO PESSOA
CREATE TYPE pessoa_type as (
	id INT,
	nome VARCHAR(60),
	data_nascimento DATE,
	estado_civil estado_civil_type,
	endereco endereco_type
);

--TIPO PROFESSOR
CREATE TYPE professor_type as (
	--pessoa pessoa_type,
	pessoa_id INT,
	matricula VARCHAR(10) 
);

--TIPO ALUNO
CREATE TYPE aluno_type as (
	--pessoa pessoa_type,
	pessoa_id INT,
	ra VARCHAR(10),
	turma_id INT
);

-- TIPO TURMA
CREATE TYPE turma_type as (
	id INT,
	nome varchar(60),
	descricao varchar(255)
);

-- TIPO DISCIPLINA
CREATE TYPE disciplina_type as (
	id INT,
	nome varchar(50),
	descricao varchar(255)
);

-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

/**
* CRIANDO TABELAS
*/
CREATE TABLE turma of turma_type(
	CONSTRAINT pk_turma PRIMARY KEY(id),
	CONSTRAINT unq_turma_turma UNIQUE(nome)
);
ALTER TABLE turma ALTER COLUMN nome SET NOT NULL;


CREATE TABLE pessoa of pessoa_type (
	CONSTRAINT pk_pessoa PRIMARY KEY(id),
	CONSTRAINT unq_nome_pessoa UNIQUE(nome)
);
ALTER TABLE pessoa ALTER COLUMN nome SET NOT NULL;


CREATE TABLE professor of professor_type (
	CONSTRAINT pk_professor PRIMARY KEY(pessoa_id),
	CONSTRAINT unq_matricula_professor UNIQUE(matricula)
);
ALTER TABLE professor ALTER COLUMN matricula SET NOT NULL;


CREATE TABLE aluno of aluno_type (
	CONSTRAINT unq_ra_aluno UNIQUE(ra),
	CONSTRAINT pk_aluno PRIMARY KEY(pessoa_id),
	CONSTRAINT fk_turma_aluno FOREIGN KEY(turma_id) REFERENCES turma(id)
);
ALTER TABLE aluno ALTER COLUMN turma_id SET NOT NULL;
ALTER TABLE aluno ALTER COLUMN ra SET NOT NULL;


CREATE TABLE disciplina of disciplina_type(
	CONSTRAINT pk_disciplina PRIMARY KEY(id),
	CONSTRAINT unq_nome_disciplina UNIQUE(nome)
);
ALTER TABLE disciplina ALTER COLUMN nome SET NOT NULL;


CREATE TABLE professor_turma(
	professor_id INT NOT NULL,
	turma_id INT NOT NULL,
	horario TIME NOT NULL,
	CONSTRAINT pk_professor_turma PRIMARY KEY(professor_id, turma_id, horario),
	CONSTRAINT fk_professor_professor_turma FOREIGN KEY(professor_id) REFERENCES professor(pessoa_id),
	CONSTRAINT fk_turma_professor_turma FOREIGN KEY(turma_id) REFERENCES turma(id)
);


CREATE TABLE disciplina_professor (
	professor_id INT NOT NULL,
	disciplina_id INT NOT NULL,
	CONSTRAINT pk_disciplina_professor PRIMARY KEY(professor_id, disciplina_id),
	CONSTRAINT fk_professor_disciplina_professor FOREIGN KEY(professor_id) REFERENCES professor(pessoa_id),
	CONSTRAINT fk_disciplina_disciplina_professor FOREIGN KEY(disciplina_id) REFERENCES disciplina(id)
);

-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

/**
* INSERINDO DADOS
*/

-- CADASTRANDO DISCIPLINAS
INSERT INTO disciplina VALUES (1, 'Banco de Dados Avançados', 'Descrição da disciplina...');
INSERT INTO disciplina VALUES (2, 'Teoria dos Grafos', 'Descrição da disciplina...');
INSERT INTO disciplina VALUES (3, 'Programação e Análise de Algorítmos', 'Descrição da disciplina...');
INSERT INTO disciplina VALUES (4, 'Engenharia de Software', 'Descrição da disciplina...');
INSERT INTO disciplina VALUES (5, 'Metodologia Científica', 'Descrição da disciplina...');


-- CADASRANDO TURMAS
INSERT INTO turma VALUES (1, 'PPgCC 2017.1', 'Descrição da turma');
INSERT INTO turma VALUES (2, 'PPgCC 2018.1', 'Descrição da turma');


-- CADASTRANDO PESSOAS
INSERT INTO pessoa VALUES (1, 'Francisco Gomes', '1964-03-25', 'SOLTEIRO', ROW('rua São João, 170', '', 'Girilandia', 'Morada Nova', '62.940-000', 'CE'));
INSERT INTO pessoa VALUES (2, 'Maria das Graças', '1970-02-07', 'CASADO', ROW('av. cel. Tibúrcio, 56', '', 'Girilandia', 'Morada Nova', '62.940-000', 'CE'));
INSERT INTO pessoa VALUES (3, 'José das Chagas', '1990-10-25', 'CASADO', ROW('Av. Cipriano Maia, 420', '', 'São Francisco', 'Morada Nova', '62.940-000', 'CE'));
INSERT INTO pessoa VALUES (4, 'Pedro Douglas', '1989-06-11', 'VIÚVO', ROW('Av. Maria Clara, 500', '', 'Centro', 'Morada Nova', '62.940-000', 'CE'));
INSERT INTO pessoa VALUES (5, 'Vitória Nunes', '1988-08-31', 'SOLTEIRO', ROW('rua Casa Grande, 330', '', 'Parque de Exposições', 'Morada Nova', '62.940-000', 'CE'));
INSERT INTO pessoa VALUES (6, 'Santiago Vidal', '1987-11-09', 'DIVORCIADO', ROW('rua João XXIII, 1250', '', '02 de Agosto', 'Morada Nova', '62.940-000', 'CE'));


-- CADASTRANDO PROFESSOR
INSERT INTO professor VALUES(1, '2016000001');
INSERT INTO professor VALUES(2, '2016000002');


-- CADASTRANDO ALUNOS
INSERT INTO aluno VALUES(3, '2017000001', 1);
INSERT INTO aluno VALUES(4, '2017000002', 1);
INSERT INTO aluno VALUES(5, '2018000001', 2);
INSERT INTO aluno VALUES(6, '2018000002', 2);


-- CADASTRANDO 'professor_turma'
INSERT INTO professor_turma VALUES (1, 1, '08:00');
INSERT INTO professor_turma VALUES (1, 2, '13:00');
INSERT INTO professor_turma VALUES (2, 1, '08:00');
INSERT INTO professor_turma VALUES (2, 2, '13:00');


-- CADASTRANDO 'disciplina_professor'
INSERT INTO disciplina_professor VALUES (1, 1);
INSERT INTO disciplina_professor VALUES (1, 2);
INSERT INTO disciplina_professor VALUES (1, 3);
INSERT INTO disciplina_professor VALUES (2, 4);
INSERT INTO disciplina_professor VALUES (2, 5);

/**
* ATUALIZANDO DADOS
*/


--ATUALIZANDO NOME DE QUEM MORA NA RUA SÃO JOÃO
UPDATE pessoa SET nome = 'Nome Alterado da Silva' WHERE (endereco).logradouro = 'rua São João, 170';

--DESFAZENDO OPERAÇÃO ANTERIOR
UPDATE pessoa SET nome = 'Francisco Gomes' WHERE id = 1;
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------


/**
* DELETANDO DADOS
*/

--ECLUINDO OS MORADORES DO BAIRRO 'Girilandia'
DELETE  from pessoa WHERE (endereco).bairro = 'Girilandia'

-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------


/**
* CONSULTANDO 
*/
 
select * from disciplina;
select * from turma;
select * from pessoa;
select * from aluno;
select * from professor;
select * from professor_turma;
select * from disciplina_professor;

-- listando logradouro e bairro
select (endereco).logradouro, (endereco).bairro from pessoa;

-- CASO A TABELA PROFESSOR FOSSE COMPOSTA PELO TIPO 'pessoa_type', A FILTRAGEM POR NOME, EM PROFESSORES, SERIA PARECIDO COM ISSO:
SELECT (pessoa).nome from professor where (pessoa).nome like '%Francisco%';

--OU SE FOSSE NECESSÁRIO FILTRAR POR ALGUM ATRIBUTO DO TIPO 'endereco_type', QUE COMPÕE 'pessoa_type', EM PROFESSOR
/**	Buscando o nome dos professores que moram no bairro centro*/
SELECT (pessoa).nome from professor where ((pessoa).endereco).bairro = 'Centro';

-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------


/**
* UTILITÁRIOS
*/

-- LISTANDO TABELAS
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';

-- DETALHES DAS COLUNAS
SELECT * FROM information_schema.columns WHERE table_name =' <<< COL_NAME >>> ';
