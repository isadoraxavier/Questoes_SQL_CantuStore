-- Criando a tabela comissoes

CREATE TABLE comissoes ( 
comprador VARCHAR NOT NULL 
,vendedor VARCHAR NOT NULL 
,dataPgto DATE NOT NULL 
,valor FLOAT NOT NULL
)

--Inserindo dados de exemplo 
INSERT INTO comissoes (comprador, vendedor, dataPgto, valor)
VALUES
    ('Leonardo', 'Bruno', '2000-01-01', 200.00),
    ('Leonardo', 'Matheus', '2003-09-27', 1024.00),
    ('Leonardo', 'Lucas', '2006-06-26', 512.00),
    ('Marcos', 'Lucas', '2020-12-17', 100.00),
    ('Marcos', 'Lucas', '2002-03-22', 10.00),
    ('Cinthia', 'Lucas', '2021-03-20', 500.00),
    ('Mateus', 'Bruno', '2007-06-02', 400.00),
    ('Mateus', 'Bruno', '2006-06-26', 400.00),
    ('Mateus', 'Bruno', '2015-06-26', 200.00);

-- criando CTEs para analisar as comissoes 
WITH ComissoesOrdenadas AS (
    SELECT 
        vendedor,
        valor,
        ROW_NUMBER() OVER (PARTITION BY vendedor ORDER BY valor DESC) AS rn
    FROM comissoes
),

Combinacoes AS (
    SELECT 
        c1.vendedor AS vendedor,
        COALESCE(c1.valor, 0) +
        COALESCE(c2.valor, 0) +
        COALESCE(c3.valor, 0) AS total
    FROM ComissoesOrdenadas c1
    LEFT JOIN ComissoesOrdenadas c2
        ON c1.vendedor = c2.vendedor AND c2.rn > c1.rn
    LEFT JOIN ComissoesOrdenadas c3
        ON c1.vendedor = c3.vendedor AND c3.rn > c2.rn
    WHERE c1.rn <= 3
        AND (c2.rn IS NULL OR c2.rn <= 3)
        AND (c3.rn IS NULL OR c3.rn <= 3)
),

TotalVendedores AS (
    SELECT 
        vendedor
    FROM Combinacoes
    GROUP BY vendedor
    HAVING MAX(total) >= 1024
)

SELECT DISTINCT
    vendedor
FROM TotalVendedores
ORDER BY vendedor;
