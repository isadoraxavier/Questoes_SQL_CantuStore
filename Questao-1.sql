-- Criando Tabelas e inserindo os dados 
CREATE TABLE times( 
	time_id INTEGER NOT NULL UNIQUE
	,time_nome  VARCHAR NOT NULL 
)

-- INSERT INTO times (time_id, time_nome) VALUES
(10, 'Financeiro'),
(20, 'Marketing'),
(30, 'Logística'),
(40, 'TI'),
(50, 'Dados');

-- SELECT * FROM times

CREATE TABLE jogos ( 
jogo_id INTEGER NOT NULL UNIQUE
, mandante_time INTEGER NOT NULL 
, visitante_time INTEGER NOT NULL 
, mandante_gols INTEGER NOT NULL 
, visitante_gols INTEGER NOT NULL 
)

-- INSERT INTO jogos (jogo_id,mandante_time,visitante_time, mandante_gols, visitante_gols) VALUES
(1, 30, 20, 1, 0),
(2, 10, 20, 1, 2),
(3, 20, 50, 2, 2),
(4, 10, 30, 1, 0),
(5, 30, 50, 0, 1);

-- Criar uma subconsulta para calcular os pontos ganhos por cada time em todas as partidas
WITH Pontos AS (
    SELECT 
        mandante_time AS time_id, 
        CASE 
            WHEN mandante_gols > visitante_gols THEN 3
            WHEN mandante_gols = visitante_gols THEN 1
            ELSE 0
        END AS pontos
    FROM jogos
    UNION ALL
    SELECT 
        visitante_time AS time_id, 
        CASE 
            WHEN visitante_gols > mandante_gols THEN 3
            WHEN mandante_gols = visitante_gols THEN 1
            ELSE 0
        END AS pontos
    FROM jogos
),

-- Soma os pontos por time
TotalPontos AS (
    SELECT 
        time_id, 
        SUM(pontos) AS num_pontos
    FROM Pontos
    GROUP BY time_id
)

-- Junta com a tabela de times para obter o nome dos times e ordena pelos pontos e ID do time
SELECT 
    t.time_id, 
    t.time_nome, 
    COALESCE(tp.num_pontos, 0) AS num_pontos
FROM times t
LEFT JOIN TotalPontos tp ON t.time_id = tp.time_id
ORDER BY num_pontos DESC, t.time_id;








