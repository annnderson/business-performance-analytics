
-- View – KPI Financeiro
CREATE OR REPLACE VIEW vw_kpi_financeiro AS
SELECT
    SUM(receita) AS receita_total,
    SUM(custo) AS custo_vendas,
    SUM(receita - custo) AS margem_bruta,
    ROUND(
        (SUM(receita - custo) / SUM(receita)) * 100,
        2
    ) AS margem_percentual
FROM fato_vendas;

SELECT * FROM vw_kpi_financeiro;

-- View – Ticket Médio
CREATE OR REPLACE VIEW vw_ticket_medio AS
SELECT
    ROUND(SUM(receita) / COUNT(DISTINCT id_venda), 2) AS ticket_medio
FROM fato_vendas;

SELECT * FROM vw_ticket_medio;

-- View – Receita por Canal
CREATE OR REPLACE VIEW vw_receita_canal AS
SELECT
    ca.nome_canal,
    SUM(fv.receita) AS receita
FROM fato_vendas fv
JOIN dim_canal ca ON fv.id_canal = ca.id_canal
GROUP BY ca.nome_canal;

SELECT * FROM vw_receita_canal;

-- View – Performance de Produtos
CREATE OR REPLACE VIEW vw_performance_produto AS
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
GROUP BY p.nome_produto;

SELECT * FROM vw_performance_produto;

-- View – Receita Mensal
CREATE OR REPLACE VIEW vw_receita_mensal AS
SELECT
    t.ano,
    t.mes,
    SUM(fv.receita) AS receita
FROM fato_vendas fv
JOIN dim_tempo t ON fv.id_tempo = t.id_tempo
GROUP BY t.ano, t.mes;

SELECT * FROM vw_receita_mensal;

-- View – Crescimento MoM da Receita
CREATE OR REPLACE VIEW vw_crescimento_mensal_receita AS
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
FROM receita_mensal;

SELECT * FROM vw_crescimento_mensal_receita;

-- View – Resultado Financeiro por Região
CREATE OR REPLACE VIEW vw_resultado_por_regiao AS
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
    COALESCE(c.custo_total, 0) AS custo,
    SUM(fv.receita) - COALESCE(c.custo_total, 0) AS resultado
FROM fato_vendas fv
JOIN dim_regiao r ON fv.id_regiao = r.id_regiao
LEFT JOIN custos_por_regiao c ON fv.id_regiao = c.id_regiao
GROUP BY r.regiao, c.custo_total;

SELECT * FROM vw_resultado_por_regiao;

-- View – Top Clientes por Margem
CREATE OR REPLACE VIEW vw_top_clientes_margem AS
SELECT
    c.nome_cliente,
    SUM(fv.receita) AS receita,
    SUM(fv.receita - fv.custo) AS margem
FROM fato_vendas fv
JOIN dim_cliente c ON fv.id_cliente = c.id_cliente
GROUP BY c.nome_cliente
ORDER BY margem DESC;

SELECT * FROM vw_top_clientes_margem;

-- View – Margem por Canal
CREATE OR REPLACE VIEW vw_margem_por_canal AS
SELECT
    ca.nome_canal,
    SUM(fv.receita) AS receita,
    SUM(fv.receita - fv.custo) AS margem,
    ROUND(
        (SUM(fv.receita - fv.custo) / SUM(fv.receita)) * 100,
        2
    ) AS margem_percentual
FROM fato_vendas fv
JOIN dim_canal ca ON fv.id_canal = ca.id_canal
GROUP BY ca.nome_canal;

SELECT * FROM vw_margem_por_canal;

-- View – Volume de Vendas (quantidade)
CREATE OR REPLACE VIEW vw_volume_vendas AS
SELECT
    t.ano,
    t.mes,
    SUM(fv.quantidade) AS quantidade_vendida
FROM fato_vendas fv
JOIN dim_tempo t ON fv.id_tempo = t.id_tempo
GROUP BY t.ano, t.mes;

SELECT * FROM vw_volume_vendas;




