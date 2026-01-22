USE business_analytics;

-- KPI: Receita, Custo, Margem e Margem %
SELECT
    SUM(receita) AS receita_total,
    SUM(custo) AS custo_vendas,
    SUM(receita - custo) AS margem_bruta,
    ROUND(
        (SUM(receita - custo) / SUM(receita)) * 100,
        2
    ) AS margem_percentual
FROM fato_vendas;

-- KPI: Ticket médio por venda
SELECT
    ROUND(SUM(receita) / COUNT(DISTINCT id_venda), 2) AS ticket_medio
FROM fato_vendas;

-- KPI: Receita por canal de venda
SELECT
    ca.nome_canal,
    SUM(fv.receita) AS receita
FROM fato_vendas fv
JOIN dim_canal ca ON fv.id_canal = ca.id_canal
GROUP BY ca.nome_canal
ORDER BY receita DESC;


-- KPI: Performance de produtos
SELECT
    p.nome_produto,
    SUM(fv.receita) AS receita,
    SUM(fv.receita - fv.custo) AS margem,
    ROUND(
        (SUM(fv.receita - fv.custo) / SUM(fv.receita)) * 100,
        2
    ) AS margem_percentual
FROM fato_vendas fv
JOIN dim_produto p ON fv.id_produto = p.id_produto
GROUP BY p.nome_produto
ORDER BY receita DESC;

-- KPI: Receita por ano e mês
SELECT
    t.ano,
    t.mes,
    SUM(fv.receita) AS receita
FROM fato_vendas fv
JOIN dim_tempo t ON fv.id_tempo = t.id_tempo
GROUP BY t.ano, t.mes
ORDER BY t.ano, t.mes;

-- KPI: Crescimento MoM da receita
WITH receita_mensal AS (
    SELECT
        t.ano,
        t.mes,
        SUM(fv.receita) AS receita
    FROM fato_vendas fv
    JOIN dim_tempo t ON fv.id_tempo = t.id_tempo
    GROUP BY t.ano, t.mes
)
SELECT
    ano,
    mes,
    receita,
    receita - LAG(receita) OVER (ORDER BY ano, mes) AS variacao_absoluta,
    ROUND(
        (receita - LAG(receita) OVER (ORDER BY ano, mes)) /
        LAG(receita) OVER (ORDER BY ano, mes) * 100,
        2
    ) AS variacao_percentual
FROM receita_mensal
ORDER BY ano, mes;

-- Quantidade de registros por mês
SELECT
    t.ano,
    t.mes,
    COUNT(*) AS qtd_registros
FROM fato_vendas fv
JOIN dim_tempo t ON fv.id_tempo = t.id_tempo
GROUP BY t.ano, t.mes
ORDER BY t.ano, t.mes;

-- KPI: Top clientes por margem
SELECT
    c.nome_cliente,
    SUM(fv.receita - fv.custo) AS margem
FROM fato_vendas fv
JOIN dim_cliente c ON fv.id_cliente = c.id_cliente
GROUP BY c.nome_cliente
ORDER BY margem DESC
LIMIT 10;

-- KPI: Resultado financeiro por região
WITH custos_por_regiao AS (
    SELECT
        id_regiao,
        SUM(valor) AS custo_total
    FROM fato_custos
    GROUP BY id_regiao
)

SELECT
    r.regiao,
    SUM(fv.receita) AS receita,
    c.custo_total AS custo,
    SUM(fv.receita) - c.custo_total AS resultado
FROM fato_vendas fv
JOIN dim_regiao r
    ON fv.id_regiao = r.id_regiao
LEFT JOIN custos_por_regiao c
    ON fv.id_regiao = c.id_regiao
GROUP BY r.regiao, c.custo_total
ORDER BY resultado DESC;








