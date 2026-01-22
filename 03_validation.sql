USE business_analytics;

-- Conferência das cargas
SELECT COUNT(*) AS total_vendas FROM fato_vendas;
SELECT COUNT(*) AS total_custos FROM fato_custos;

-- Amostra dos dados
SELECT * FROM fato_vendas LIMIT 10;
SELECT * FROM fato_custos LIMIT 10;

-- Quantidade total de registros
SELECT COUNT(*) AS total_registros
FROM fato_vendas;

-- Verifica se há chaves órfãs (não deveria retornar linhas)
SELECT *
FROM fato_vendas fv
LEFT JOIN dim_cliente dc ON fv.id_cliente = dc.id_cliente
WHERE dc.id_cliente IS NULL;

-- Confere se receita e custo seguem as regras definidas
SELECT
    fv.id_venda,
    fv.quantidade,
    fv.receita,
    fv.custo,
    (p.preco_unitario * fv.quantidade) AS receita_esperada,
    (p.preco_unitario * 0.6 * fv.quantidade) AS custo_esperado
FROM fato_vendas fv
JOIN dim_produto p ON fv.id_produto = p.id_produto
WHERE fv.receita <> (p.preco_unitario * fv.quantidade)
   OR fv.custo   <> (p.preco_unitario * 0.6 * fv.quantidade);
   
-- Não devem existir valores inválidos
SELECT *
FROM fato_vendas
WHERE quantidade <= 0
   OR receita < 0
   OR custo < 0
   OR id_tempo IS NULL;
   
-- Distribuição por ano (confere cobertura temporal)
SELECT
    t.ano,
    COUNT(*) AS total_vendas
FROM fato_vendas fv
JOIN dim_tempo t ON fv.id_tempo = t.id_tempo
GROUP BY t.ano
ORDER BY t.ano;   