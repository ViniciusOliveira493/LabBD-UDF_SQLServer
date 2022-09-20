CREATE DATABASE bd_funcionarios
GO
USE bd_funcionarios
CREATE TABLE tbFuncionario(
	codigo				INT				NOT NULL
	, nome				VARCHAR(100)	NOT NULL
	, salario			DECIMAL(7,2)	NOT NULL
	PRIMARY KEY (codigo)
);

CREATE TABLE tbDependente(
	codigoFuncionario	INT				NOT NULL
	, nomeDependente	VARCHAR(100)	NOT NULL
	, salarioDependente DECIMAL(7,2)	NOT NULL
	PRIMARY KEY (codigoFuncionario,nomeDependente)
	CONSTRAINT fk_dependenteFuncionario FOREIGN KEY (codigoFuncionario) REFERENCES tbFuncionario(codigo)
);

--========================================== INSERTS ==============================================================
INSERT INTO	tbFuncionario(codigo,nome,salario)
	VALUES
		(1,'Diego Pietro da Luz',1500)
		, (2,'Olivia Luana Gomes',1600)
		, (3,'Kaique César Bernardes',1400)
		, (4,'Diogo Elias Marcelo Monteiro',1600)
INSERT INTO tbDependente(codigoFuncionario,nomeDependente,salarioDependente)
	VALUES 
		(1,'João Mário da Luz',300) 
		,(1,'Agatha Andreia Luz',300) 
		,(2,'Filipe Otávio Manoel Gomes',300) 
		,(3,'Murilo Enrico Bernardes',300) 
		,(3,'Rosângela Tereza Bernardes',300)
		,(3,'Lucas Benedito Pedro Henrique Bernardes',300)

--========================================================================================================
--1) Function que Retorne uma tabela: (Nome_Funcionário, Nome_Dependente, Salário_Funcionário, Salário_Dependente)
CREATE FUNCTION fn_salarioFuncionarioDependente()
RETURNS @tabela TABLE(
	nomeFuncionario				VARCHAR(100)
	, nomeDependente			VARCHAR(100)
	, salarioFuncionario		DECIMAL(7,2)
	, salarioDependente			DECIMAL(7,2)
)
AS
BEGIN
	INSERT INTO @tabela(nomeFuncionario,nomeDependente,salarioFuncionario,salarioDependente)
		SELECT 
			f.nome 
			, d.nomeDependente 
			, f.salario
			, d.salarioDependente
		FROM tbFuncionario AS f, tbDependente AS d
		WHERE f.codigo = d.codigoFuncionario
		RETURN
END

SELECT * FROM fn_salarioFuncionarioDependente()

--=========================================================================================================
--2) Scalar Function que Retorne a soma dos Salários dos dependentes, mais a do funcionário
CREATE FUNCTION fn_obterSalarioDependentes(@codigoFuncionario INT)
RETURNS DECIMAL(7,2)
AS 
BEGIN
	DECLARE @salarioDp DECIMAL(7,2)
	SELECT @salarioDp = SUM(salarioDependente)
	FROM tbDependente
	WHERE codigoFuncionario = @codigoFuncionario
	RETURN @salarioDp
END

SELECT dbo.fn_obterSalarioDependentes(2)

--==========================
CREATE FUNCTION fn_obterSalario(@codigoFuncionario INT)
RETURNS DECIMAL(7,2)
AS 
BEGIN
	DECLARE @salario DECIMAL(7,2)
	SELECT @salario = salario
	FROM tbFuncionario
	WHERE codigo = @codigoFuncionario
	RETURN @salario
END

SELECT dbo.fn_obterSalario(2)
--==========================
CREATE FUNCTION fn_somarSalarios(@codigoFuncionario INT)
RETURNS DECIMAL(7,2)
AS
BEGIN
	DECLARE @salario DECIMAL(7,2)
			, @salarioDp DECIMAL(7,2)
	SELECT @salario = dbo.fn_obterSalario(@codigoFuncionario)
	SELECT @salarioDp = dbo.fn_obterSalarioDependentes(@codigoFuncionario)
	IF(@salarioDp IS NOT NULL)
	BEGIN
		RETURN @salario +  @salarioDp
	END
	RETURN @salario
END


