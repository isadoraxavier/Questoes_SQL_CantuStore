-- Criando a tabela 
CREATE TABLE colaboradores ( 
id INTEGER NOT NULL UNIQUE
, nome VARCHAR NOT NULL 
, salario INTEGER NOT NULL 
, lider_id INTEGER 
)


-- Inserindo os valores na tabela
INSERT INTO colaboradores (id, nome, salario, lider_id)
VALUES
    (40, 'Helen', 1500, 50),
    (50, 'Bruno', 3000, 10),
    (10, 'Leonardo', 4500, 20),
    (20, 'Marcos', 10000, NULL),
    (70, 'Mateus', 1500, 10),
    (60, 'Cinthia', 2000, 70),
    (30, 'Wilian', 1501, 50);

WITH RECURSIVE Hierarquia AS (
    -- Seleciona os chefes diretos e inicializa a hierarquia
    SELECT
        id AS funcionario_id,
        lider_id AS chefe_id,
        salario AS salario_funcionario,
        salario AS salario_chefe,
        1 AS nivel
    FROM colaboradores
    WHERE lider_id IS NOT NULL

    UNION ALL

    -- Encontra os chefes indiretos
    SELECT
        h.funcionario_id,
        c.lider_id AS chefe_id,
        h.salario_funcionario,
        c.salario AS salario_chefe,
        h.nivel + 1 AS nivel
    FROM Hierarquia h
    JOIN colaboradores c
        ON h.chefe_id = c.id
    WHERE c.lider_id IS NOT NULL
),

-- Filtra chefes indiretos que ganham pelo menos o dobro do salário do funcionário
ChefesValidos AS (
    SELECT
        h.funcionario_id,
        h.chefe_id,
        h.salario_funcionario,
        h.salario_chefe,
        h.nivel
    FROM Hierarquia h
    WHERE h.salario_chefe >= 2 * h.salario_funcionario
),

-- Seleciona o chefe indireto de classificação mais baixa
ChefeMaisBaixo AS (
    SELECT
        f.id AS funcionario_id,
        COALESCE(MAX(c.chefe_id), NULL) AS chefe_id
    FROM colaboradores f
    LEFT JOIN ChefesValidos c
        ON f.id = c.funcionario_id
    GROUP BY f.id
)

-- Consulta final
SELECT
    funcionario_id,
    chefe_id
FROM ChefeMaisBaixo
ORDER BY funcionario_id;

