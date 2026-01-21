CREATE TABLE credit_card_transactions (
    customer_id INT,
    card_id INT,
    province TEXT,
    card_type TEXT,
    transaction_date DATE,
    transaction_amount NUMERIC,
    merchant_category TEXT,
    interest_rate NUMERIC,
    annual_fee NUMERIC,
    operational_cost NUMERIC
);

SELECT * FROM credit_card_transactions;

SELECT COUNT(*) FROM credit_card_transactions;

SELECT * FROM credit_card_transactions LIMIT 10;

CREATE SCHEMA IF NOT EXISTS credit;



CREATE VIEW credit.v_base_transactions AS
SELECT
    customer_id,
    card_id,
    province,
    card_type,
    transaction_date,
    DATE_TRUNC('month', transaction_date) AS transaction_month,
    transaction_amount,
    transaction_amount * interest_rate AS interest_revenue,
    annual_fee,
    operational_cost
FROM credit_card_transactions;

SELECT * FROM credit.v_base_transactions;

CREATE VIEW credit.v_kpis AS
SELECT
    COUNT(DISTINCT customer_id) AS active_cardholders,
    COUNT(DISTINCT card_id) AS cards_issued,
    SUM(interest_revenue + annual_fee) AS total_revenue,
    SUM(interest_revenue + annual_fee - operational_cost) AS net_profit
FROM credit.v_base_transactions;

SELECT * FROM credit.v_kpis;

CREATE VIEW credit.v_monthly_performance AS
SELECT
    transaction_month,
    SUM(interest_revenue + annual_fee) AS revenue,
    SUM(interest_revenue + annual_fee - operational_cost) AS profit
FROM credit.v_base_transactions
GROUP BY transaction_month
ORDER BY transaction_month;

SELECT * FROM credit.v_monthly_performance;

CREATE VIEW credit.v_province_performance AS
SELECT
    province,
    SUM(interest_revenue + annual_fee) AS revenue,
    SUM(interest_revenue + annual_fee - operational_cost) AS profit
FROM credit.v_base_transactions
GROUP BY province;

SELECT * FROM credit.v_province_performance;

CREATE VIEW credit.v_card_type_performance AS
SELECT
    card_type,
    SUM(interest_revenue + annual_fee) AS revenue,
    SUM(interest_revenue + annual_fee - operational_cost) AS profit
FROM credit.v_base_transactions
GROUP BY card_type;

SELECT * FROM credit.v_card_type_performance;






