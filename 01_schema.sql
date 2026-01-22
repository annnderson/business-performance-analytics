CREATE DATABASE IF NOT EXISTS business_analytics;

USE business_analytics;

CREATE TABLE IF NOT EXISTS dim_tempo (
    id_tempo INT PRIMARY KEY,
    data DATE NOT NULL,
    ano INT,
    mes INT,
    nome_mes VARCHAR(20),
    trimestre INT,
    dia INT,
    dia_semana VARCHAR(15)
);

CREATE TABLE IF NOT EXISTS dim_cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome_cliente VARCHAR(100),
    idade INT,
    genero VARCHAR(20),
    cidade VARCHAR(100),
    estado VARCHAR(50),
    segmento VARCHAR(50),
    data_cadastro DATE
);

CREATE TABLE IF NOT EXISTS dim_produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome_produto VARCHAR(100),
    categoria VARCHAR(50),
    

    subcategoria VARCHAR(50),
    preco_unitario DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS dim_canal (
    id_canal INT AUTO_INCREMENT PRIMARY KEY,
    nome_canal VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS dim_regiao (
    id_regiao INT AUTO_INCREMENT PRIMARY KEY,
    regiao VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS fato_vendas (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    id_tempo INT,
    id_cliente INT,
    id_produto INT,
    id_canal INT,
    id_regiao INT,
    quantidade INT,
    receita DECIMAL(12,2),
    custo DECIMAL(12,2),
    FOREIGN KEY (id_tempo) REFERENCES dim_tempo(id_tempo),
    FOREIGN KEY (id_cliente) REFERENCES dim_cliente(id_cliente),
    FOREIGN KEY (id_produto) REFERENCES dim_produto(id_produto),
    FOREIGN KEY (id_canal) REFERENCES dim_canal(id_canal),
    FOREIGN KEY (id_regiao) REFERENCES dim_regiao(id_regiao)
);

CREATE TABLE IF NOT EXISTS fato_custos (
    id_custo INT AUTO_INCREMENT PRIMARY KEY,
    id_tempo INT,
    id_regiao INT,
    tipo_custo VARCHAR(50),
    valor DECIMAL(12,2),
    FOREIGN KEY (id_tempo) REFERENCES dim_tempo(id_tempo),
    FOREIGN KEY (id_regiao) REFERENCES dim_regiao(id_regiao)
);

-- Tabela auxiliar para gerar sequências numéricas
-- Será usada para criar a dimensão tempo
CREATE TABLE IF NOT EXISTS numeros (
    n INT PRIMARY KEY
);