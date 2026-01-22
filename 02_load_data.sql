USE business_analytics;

--------------------------------------------------
-- TABELA AUXILIAR DE NÚMEROS (0–1999)
--------------------------------------------------
INSERT INTO numeros (n)
SELECT 
    a.N + b.N * 10 + c.N * 100 + d.N * 1000
FROM
(SELECT 0 N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a,
(SELECT 0 N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b,
(SELECT 0 N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c,
(SELECT 0 N UNION ALL SELECT 1) d;

--------------------------------------------------
-- DIMENSÃO TEMPO (2022–2025)
--------------------------------------------------
INSERT INTO dim_tempo (
    id_tempo,
    data,
    ano,
    mes,
    nome_mes,
    trimestre,
    dia,
    dia_semana
)
SELECT
    DATE_FORMAT(DATE_ADD('2022-01-01', INTERVAL n DAY), '%Y%m%d'),
    DATE_ADD('2022-01-01', INTERVAL n DAY),
    YEAR(DATE_ADD('2022-01-01', INTERVAL n DAY)),
    MONTH(DATE_ADD('2022-01-01', INTERVAL n DAY)),
    MONTHNAME(DATE_ADD('2022-01-01', INTERVAL n DAY)),
    QUARTER(DATE_ADD('2022-01-01', INTERVAL n DAY)),
    DAY(DATE_ADD('2022-01-01', INTERVAL n DAY)),
    DAYNAME(DATE_ADD('2022-01-01', INTERVAL n DAY))
FROM numeros
WHERE DATE_ADD('2022-01-01', INTERVAL n DAY) <= '2025-12-31';

--------------------------------------------------
-- DIMENSÕES DE NEGÓCIO
--------------------------------------------------
INSERT INTO dim_canal (nome_canal) VALUES
('Loja Física'),
('E-commerce'),
('Marketplace'),
('Televendas');

INSERT INTO dim_regiao (regiao) VALUES
('Sudeste'),
('Sul'),
('Nordeste'),
('Centro-Oeste'),
('Norte');

INSERT INTO dim_produto (nome_produto, categoria, subcategoria, preco_unitario) VALUES
('Notebook Pro', 'Eletrônicos', 'Computadores', 5500.00),
('Smartphone X', 'Eletrônicos', 'Celulares', 3200.00),
('Fone Bluetooth', 'Acessórios', 'Áudio', 350.00),
('Cadeira Ergonômica', 'Móveis', 'Escritório', 1200.00),
('Mesa Office', 'Móveis', 'Escritório', 980.00);

INSERT INTO dim_cliente (
    nome_cliente,
    idade,
    genero,
    cidade,
    estado,
    segmento,
    data_cadastro
)
SELECT
    CONCAT('Cliente ', n),
    FLOOR(18 + RAND() * 55),
    IF(RAND() > 0.5, 'Masculino', 'Feminino'),
    CASE 
        WHEN RAND() < 0.3 THEN 'São Paulo'
        WHEN RAND() < 0.5 THEN 'Rio de Janeiro'
        WHEN RAND() < 0.7 THEN 'Belo Horizonte'
        WHEN RAND() < 0.85 THEN 'Curitiba'
        ELSE 'Recife'
    END,
    CASE 
        WHEN RAND() < 0.3 THEN 'SP'
        WHEN RAND() < 0.5 THEN 'RJ'
        WHEN RAND() < 0.7 THEN 'MG'
        WHEN RAND() < 0.85 THEN 'PR'
        ELSE 'PE'
    END,
    CASE 
        WHEN RAND() < 0.2 THEN 'Premium'
        WHEN RAND() < 0.6 THEN 'Standard'
        ELSE 'Básico'
    END,
    DATE_ADD('2022-01-01', INTERVAL FLOOR(RAND() * 900) DAY)
FROM numeros
WHERE n BETWEEN 1 AND 500;

UPDATE dim_cliente dc
JOIN (
    SELECT id_cliente
    FROM dim_cliente
) x ON dc.id_cliente = x.id_cliente
SET dc.nome_cliente = CONCAT(
    ELT(FLOOR(1 + RAND()*6),
        'Ana','Carlos','Mariana','João','Fernanda','Paulo'
    ),
    ' ',
    ELT(FLOOR(1 + RAND()*8),
        'Silva','Santos','Oliveira','Pereira',
        'Costa','Rodrigues','Lima','Almeida'
    )
);
--------------------------------------------------
-- FATO VENDAS (2 ANOS | 8.000 REGISTROS)
--------------------------------------------------
INSERT INTO fato_vendas (
    id_tempo,
    id_cliente,
    id_produto,
    id_canal,
    id_regiao,
    quantidade,
    receita,
    custo
)
SELECT
    t.id_tempo,
    ((n.n % c.total_clientes) + 1) AS id_cliente,
    ((n.n % p.total_produtos) + 1) AS id_produto,
    ((n.n % ca.total_canais) + 1) AS id_canal,
    ((n.n % r.total_regioes) + 1) AS id_regiao,
    q.qtd AS quantidade,
    pr.preco_unitario * q.qtd AS receita,
    pr.preco_unitario * q.qtd * 0.4 AS custo
FROM numeros n
JOIN (
    SELECT id_tempo
    FROM dim_tempo
    WHERE data BETWEEN '2023-01-01' AND '2024-12-31'
) t ON t.id_tempo = (
    SELECT id_tempo
    FROM dim_tempo
    WHERE data BETWEEN '2023-01-01' AND '2024-12-31'
    ORDER BY id_tempo
    LIMIT 1 OFFSET (n.n % 730)
)
JOIN (SELECT COUNT(*) AS total_clientes FROM dim_cliente) c
JOIN (SELECT COUNT(*) AS total_produtos FROM dim_produto) p
JOIN (SELECT COUNT(*) AS total_canais FROM dim_canal) ca
JOIN (SELECT COUNT(*) AS total_regioes FROM dim_regiao) r
JOIN (
    SELECT n.n, FLOOR(1 + RAND(n.n) * 4) AS qtd
    FROM numeros n
) q ON q.n = n.n
JOIN dim_produto pr
    ON pr.id_produto = ((n.n % p.total_produtos) + 1)
WHERE n.n < 8000;



--------------------------------------------------
-- FATO CUSTOS OPERACIONAIS (MENSAL POR REGIÃO)
--------------------------------------------------
INSERT INTO fato_custos (
    id_tempo,
    id_regiao,
    tipo_custo,
    valor
)
SELECT
    MIN(t.id_tempo),
    r.id_regiao,
    'Operacional',
    ROUND(15000 + RAND() * 20000, 2)
FROM dim_tempo t
JOIN dim_regiao r
WHERE t.data BETWEEN '2023-01-01' AND '2024-12-31'
GROUP BY YEAR(t.data), MONTH(t.data), r.id_regiao;


--------------------------------------------------
-- VALIDAÇÕES RÁPIDAS
--------------------------------------------------

SELECT COUNT(*) FROM dim_tempo;
SELECT COUNT(*) FROM dim_cliente;
SELECT COUNT(*) FROM dim_produto;
SELECT COUNT(*) FROM dim_canal;
SELECT COUNT(*) FROM dim_regiao;
SELECT COUNT(*) FROM fato_vendas;
SELECT COUNT(*) FROM fato_custos;

WITH custos_por_regiao AS (
    SELECT
        id_regiao,
        SUM(valor) AS custo_operacional
    FROM fato_custos
    GROUP BY id_regiao
)
SELECT
    r.regiao,
    SUM(fv.receita) AS receita,
    SUM(fv.custo) + c.custo_operacional AS custo_total,
    SUM(fv.receita) - (SUM(fv.custo) + c.custo_operacional) AS resultado
FROM fato_vendas fv
JOIN dim_regiao r ON fv.id_regiao = r.id_regiao
LEFT JOIN custos_por_regiao c ON fv.id_regiao = c.id_regiao
GROUP BY r.regiao, c.custo_operacional
ORDER BY resultado DESC;

