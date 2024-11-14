-- Vytvoření tabulky
CREATE OR REPLACE TABLE t_Kamil_Hnatek_project_SQL_primary_final (
    id INT AUTO_INCREMENT PRIMARY KEY,           -- Primární klíč s automatickým číslováním
    industry_branch_name VARCHAR(255),           -- Název odvětví
    year INT,                                    -- Rok
    payroll_value DECIMAL(10, 2),                -- Hodnota mezd
    category_code INT,                           -- Kód kategorie z tabulky czechia_price
    category_name VARCHAR(255),                  -- Název kategorie z tabulky czechia_price_category
    price DECIMAL(10, 2),                        -- Průměrná cena
    price_value DECIMAL(5, 2),                   -- Hodnota ceny
    price_unit VARCHAR(50)                       -- Jednotka ceny
);

-- Vložení dat o cenách potravin do tabulky
INSERT INTO t_kamil_hnatek_project_SQL_primary_final 
    (industry_branch_name, payroll_value, category_code, category_name, price, price_value, price_unit, year)
SELECT 
    NULL AS industry_branch_name,               -- industry_branch_name bude NULL
    NULL AS payroll_value,                      -- payroll_value bude NULL
    p.category_code AS category_code,           -- Kód kategorie z tabulky czechia_price
    pc.name AS category_name,                   -- Název kategorie z tabulky czechia_price_category
    AVG(p.value) AS price,                      -- Průměrná hodnota ceny z tabulky czechia_price (ukládá se do sloupce price)
    pc.price_value AS price_value,              -- Hodnota ceny z tabulky czechia_price_category
    pc.price_unit AS price_unit,                -- Jednotka ceny z tabulky czechia_price_category
    YEAR(p.date_from) AS year                   -- Rok z date_from
FROM 
    czechia_price AS p
JOIN 
    czechia_price_category AS pc ON p.category_code = pc.code  -- Spojení přes category_code a code
WHERE 
    p.region_code IS NULL                       -- Pouze řádky, kde region_code je NULL
GROUP BY 
    p.category_code, YEAR(p.date_from), pc.name, pc.price_value, pc.price_unit;  -- Seskupení podle category_code a roku

-- Vložení dat o mzdách do tabulky
INSERT INTO t_kamil_hnatek_project_SQL_primary_final 
    (industry_branch_name, year, payroll_value)
SELECT 
    b.name AS industry_branch_name,             -- Název odvětví
    cp.payroll_year AS year,                    -- Rok
    AVG(cp.value) AS payroll_value              -- Průměrná mzda pro dané odvětví a rok
FROM 
    czechia_payroll AS cp                       -- Alias cp pro tabulku czechia_payroll
JOIN 
    czechia_payroll_industry_branch AS b ON cp.industry_branch_code = b.code
WHERE 
    cp.value_type_code = 5958                   -- Pouze řádky s value_type_code = 5958 (průměrná mzda)
GROUP BY 
    b.name, cp.payroll_year;                    -- Skupinová funkce podle názvu odvětví a roku
