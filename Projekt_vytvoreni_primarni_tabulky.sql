CREATE or replace TABLE t_Kamil_Hnatek_project_SQL_primary_final (
    id INT AUTO_INCREMENT PRIMARY KEY,           -- Primární klíč s automatickým číslováním
    industry_branch_name VARCHAR(255),           -- Název odvětví
    year INT,                            			-- Rok pro mzdy
    quarter INT,                                 -- Čtvrtletí
    payroll_value DECIMAL(10, 2),                -- Hodnota mezd
    category_code INT,                           -- Kód kategorie z tabulky czechia_price
    category_name VARCHAR(255),                  -- Název kategorie z tabulky czechia_price_category
    price DECIMAL(10, 2),                  		 -- Hodnota ceny
    price_value DECIMAL(5, 2),                   -- Hodnota ceny
    price_unit VARCHAR(50),                      -- Jednotka ceny
    date_from DATE,                              -- Datum od (bez časové složky)
    date_to DATE,                                -- Datum do (bez časové složky)
    region_code VARCHAR(10)                      -- Kód regionu (např. CZ011)
);