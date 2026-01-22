# 📊 Business Analytics Dashboard | SQL + Power BI

## 📌 Visão Geral
Projeto de Business Analytics desenvolvido utilizando MySQL e Power BI, com foco na geração de insights financeiros, comerciais e operacionais a partir de um modelo dimensional (Star Schema).

O projeto cobre todo o ciclo analítico, desde a modelagem do banco de dados, carga e exploração dos dados, criação de KPIs em SQL, otimização de performance, até a construção de um dashboard interativo no Power BI, orientado à tomada de decisão.

🔗 **Link do Dashboard (Power BI):**  
https://app.powerbi.com/view?r=eyJrIjoiMmFkZmRiMDQtZGVmOC00MjBjLTliMGYtYTlmMDA1N2NhODEyIiwidCI6ImQ2MmVkZjk4LTJkNmYtNDBhOS05YTJhLWEwNmE4MmFlOTdlYyJ9

<img width="1532" height="847" alt="Captura de tela 2026-01-22 181811" src="https://github.com/user-attachments/assets/4f87cde6-30b2-4036-b266-f98b58c06be9" />


---

## 🧱 Modelagem de Dados
- **Modelo:** Estrela (Star Schema)
- **Tabela Fato:**
  - `fato_vendas`
- **Tabelas Dimensão:**
  - `dim_cliente`
  - `dim_produto`
  - `dim_canal`
  - `dim_regiao`
  - `dim_tempo`
 
  <img width="724" height="595" alt="CRIAÇÃO DA TABELAS SQL" src="https://github.com/user-attachments/assets/01ca1ada-3bc1-4733-897e-1aff269e0d6b" />


Toda a modelagem foi criada manualmente em SQL, seguindo boas práticas de BI e Data Warehousing.

---

## ⚙️ Engenharia e Exploração de Dados
- Criação completa do schema em SQL
- Geração de dados simulados para análise
- Exploração e validação dos dados
- Ajustes na dimensão tempo para consistência analítica
- Garantia de integridade entre tabelas fato e dimensões

---

## 🚀 Otimização de Performance
- Criação de índices em colunas estratégicas da tabela fato:
  - `id_tempo`
  - `id_cliente`
  - `id_produto`
  - `id_regiao`
- Otimização de consultas analíticas para consumo no Power BI

  <img width="650" height="308" alt="OTIMIZAÇÃO" src="https://github.com/user-attachments/assets/7743dd1f-38a6-4b42-b519-790e331c931c" />


---

## 📐 Views Analíticas (Camada Semântica)
Foram criadas views em SQL para padronizar e consolidar indicadores, utilizando:
- CTEs
- Window Functions
- Agregações analíticas

Principais views desenvolvidas:
- KPI financeiro (receita, custo, margem)
- Receita mensal
- Crescimento Month-over-Month (MoM)
- Resultado financeiro por região
- Performance de produtos
- Receita e margem por canal

<img width="702" height="756" alt="VIEWS" src="https://github.com/user-attachments/assets/5fa71733-4eca-4c05-8364-287f524db831" />


Essas views funcionam como uma camada semântica de apoio à análise.

---

## 📈 KPIs e Análises
KPIs desenvolvidos no projeto:
- Receita total
- Custo e margem
- Margem percentual
- Ticket médio
- Receita por canal
- Performance de produtos
- Crescimento mensal (MoM)
- Resultado financeiro por região
- Segmentação de clientes (Básico, Standard e Premium)


---

## 📊 Power BI – Dashboard Interativo
- Conexão direta com banco MySQL
- Modelagem de dados no Power BI
- Criação de medidas em DAX para análises dinâmicas
- Relacionamento entre fato e dimensões
- Dashboard com:
  - Filtros inteligentes
  - Segmentações interativas
  - Visuais integrados
  - Análises temporais e comparativas


---

## 🛠️ Tecnologias Utilizadas
- MySQL
- SQL (Views, CTEs, Window Functions, Indexes)
- Power BI
- DAX
- Power Query
- Modelagem Dimensional

---

## 🎯 Objetivo do Projeto
Demonstrar domínio prático em:
- SQL analítico
- Modelagem de dados para BI
- Criação e consolidação de KPIs
- Otimização de performance
- Visualização de dados orientada a negócio
- Construção de dashboards interativos

---

### 💡 Observação
Todo o schema, dados, views, índices, KPIs e dashboard foram desenvolvidos do zero, simulando um ambiente real de Business Intelligence.
