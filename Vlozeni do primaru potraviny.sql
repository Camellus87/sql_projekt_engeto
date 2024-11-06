INSERT INTO t_kamil_hnatek_project_SQL_primary_final 
    (industry_branch_name, quarter, payroll_value, category_code, category_name, price, price_value, price_unit, year, region_code)
SELECT 
    NULL AS industry_branch_name,           -- industry_branch_name bude NULL
    NULL AS quarter,                        -- quarter bude NULL
    NULL AS payroll_value,                  -- payroll_value bude NULL
    p.category_code AS category_code,       -- Kód kategorie z tabulky czechia_price
    pc.name AS category_name,               -- Název kategorie z tabulky czechia_price_category
    AVG(p.value) AS price,                  -- Průměrná hodnota ceny z tabulky czechia_price (ukládá se do nového sloupce price)
    pc.price_value AS price_value,          -- Hodnota ceny z tabulky czechia_price_category
    pc.price_unit AS price_unit,            -- Jednotka ceny z tabulky czechia_price_category
    YEAR(p.date_from) AS year,              -- Extrahujeme rok z date_from
    p.region_code                          -- Kód regionu z tabulky czechia_price
FROM 
    czechia_price AS p
JOIN 
    czechia_price_category AS pc ON p.category_code = pc.code  -- Spojení přes category_code a code
WHERE 
    p.region_code IS NULL               -- Pouze řádky, kde region_code je NULL
GROUP BY 
    p.category_code, YEAR(p.date_from), pc.name, pc.price_value, pc.price_unit, p.region_code;  -- Seskupení podle category_code a roku


