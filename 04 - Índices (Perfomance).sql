USE business_analytics;

CREATE INDEX idx_fato_vendas_tempo ON fato_vendas(id_tempo);
CREATE INDEX idx_fato_vendas_cliente ON fato_vendas(id_cliente);
CREATE INDEX idx_fato_vendas_produto ON fato_vendas(id_produto);
CREATE INDEX idx_fato_vendas_regiao ON fato_vendas(id_regiao);
