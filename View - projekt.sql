-- tady si spočítám průměrnou mzdu ze všech odvětví v daném roce
-- Zodpovezeni otazky 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
   
CREATE OR REPLACE VIEW v_kamil_hnatek_project_SQL_total_and_average_payroll AS
SELECT 
    year,
    SUM(payroll_value) AS total_payroll_value,                      -- Celková hodnota mezd pro daný rok
    ROUND(SUM(payroll_value) / COUNT(payroll_value), 2) AS average_payroll_value  -- Průměrná hodnota mzdy za všechny industry_branch
FROM 
    t_kamil_hnatek_project_SQL_primary_final
WHERE 
    payroll_value IS NOT NULL
GROUP BY 
    year
ORDER BY 
    year;
   
-- Nové VIEW pro výpočet chleba a mléka, funguje
-- odpověď na otazku 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
   
CREATE OR REPLACE VIEW v_kamil_hnatek_project_SQL_avg_payroll_milk_bread AS
SELECT 
    t.year,
    ROUND(SUM(t.payroll_value) / COUNT(t.payroll_value), 2) AS average_payroll_value,  -- Průměrná mzda za všechny industry_branch
    ROUND(AVG(CASE WHEN p.category_code = 114201 THEN t.payroll_value / p.value ELSE NULL END), 1) AS milk_quantity,  -- Kolik mléka si mohu koupit
    ROUND(AVG(CASE WHEN p.category_code = 111301 THEN t.payroll_value / p.value ELSE NULL END), 1) AS bread_quantity  -- Kolik chleba si mohu koupit
FROM 
    t_kamil_hnatek_project_SQL_primary_final t
JOIN 
    czechia_price p ON t.year = YEAR(p.date_from)
WHERE 
    p.region_code IS NULL
GROUP BY 
    t.year
HAVING 
    average_payroll_value IS NOT NULL
ORDER BY 
    t.year;


-- VIEW pro meziroční nárůst od roku 2006 do 2018, nefunguje prokud mám dostupné jiné roky, funguje:
CREATE OR REPLACE VIEW v_kamil_hnatek_project_SQL_price_increase_by_category AS
SELECT 
    category_code,
    category_name,
    price_unit,
    ROUND(((price_2018 - price_2006) / price_2006) * 100, 2) AS nárůst_cen -- Procentuální nárůst cen mezi rokem 2006 a 2018
FROM 
    (SELECT 
        category_code,
        category_name,
        price_unit,
        MAX(CASE WHEN year = 2006 THEN price END) AS price_2006, -- Cena v roce 2006
        MAX(CASE WHEN year = 2018 THEN price END) AS price_2018  -- Cena v roce 2018
    FROM 
        t_kamil_hnatek_project_SQL_primary_final
    WHERE 
        year IN (2006, 2018) -- Pouze roky 2006 a 2018
    GROUP BY 
        category_code, category_name, price_unit
    ) AS price_comparison
ORDER BY 
    nárůst_cen ASC;
   
-- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
-- odpoved na otazku 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
CREATE OR REPLACE VIEW v_kamil_hnatek_project_SQL_avg_annual_increase AS
SELECT 
    start_data.category_code,
    start_data.category_name,
    start_data.start_year,
    end_data.end_year,
    start_data.start_price,
    end_data.end_price,
    ROUND(
        ((end_data.end_price / start_data.start_price) - 1) * 100, 2
    ) AS avg_annual_increase_percent  -- Průměrný meziroční nárůst v procentech
FROM 
    -- Poddotaz pro první dostupný rok s hodnotou price
    (SELECT 
        category_code,
        category_name,
        year AS start_year,
        price AS start_price
     FROM 
        t_kamil_hnatek_project_SQL_primary_final AS t_start
     WHERE 
        price IS NOT NULL
        AND category_code IS NOT NULL
        AND year = (SELECT MIN(year) FROM t_kamil_hnatek_project_SQL_primary_final WHERE category_code = t_start.category_code)
    ) AS start_data

JOIN 
    -- Poddotaz pro poslední dostupný rok s hodnotou price
    (SELECT 
        category_code,
        category_name,
        year AS end_year,
        price AS end_price
     FROM 
        t_kamil_hnatek_project_SQL_primary_final AS t_end
     WHERE 
        price IS NOT NULL
        AND category_code IS NOT NULL
        AND year = (SELECT MAX(year) FROM t_kamil_hnatek_project_SQL_primary_final WHERE category_code = t_end.category_code)
    ) AS end_data
ON start_data.category_code = end_data.category_code 
   AND start_data.category_name = end_data.category_name
   AND start_data.start_year <> end_data.end_year  -- Ověření, že start a end roky nejsou stejné

ORDER BY 
    avg_annual_increase_percent ASC;

-- sloučené VIEW
-- odpověd na 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
   
CREATE OR REPLACE VIEW v_kamil_hnatek_project_SQL_total_increase AS
SELECT 
    current_year.year AS start_year,
    next_year.year AS end_year,
    'mzdy' AS typ,
    ROUND(
        ((SUM(next_year.payroll_value) / SUM(current_year.payroll_value)) - 1) * 100, 2
    ) AS annual_increase_percent,  -- Meziroční nárůst mezd v procentech
    NULL AS higher_price_increase  -- Pouze pro zachování sloupce, hodnota bude NULL pro "mzdy"
FROM 
    t_kamil_hnatek_project_SQL_primary_final AS current_year
JOIN 
    t_kamil_hnatek_project_SQL_primary_final AS next_year
ON 
    current_year.year = next_year.year - 1
WHERE 
    current_year.payroll_value IS NOT NULL 
    AND next_year.payroll_value IS NOT NULL 
GROUP BY 
    current_year.year, next_year.year

UNION ALL

SELECT 
    current_year.year AS start_year,
    next_year.year AS end_year,
    'ceny' AS typ,
    ROUND(
        ((SUM(next_year.price) / SUM(current_year.price)) - 1) * 100, 2
    ) AS annual_increase_percent,  -- Meziroční nárůst cen v procentech
    CASE 
        WHEN ROUND(
            ((SUM(next_year.price) / SUM(current_year.price)) - 1) * 100, 2
        ) > (
            SELECT 
                ROUND(
                    ((SUM(payroll_next.payroll_value) / SUM(payroll_current.payroll_value)) - 1) * 100, 2
                ) + 10
            FROM 
                t_kamil_hnatek_project_SQL_primary_final AS payroll_current
            JOIN 
                t_kamil_hnatek_project_SQL_primary_final AS payroll_next
            ON 
                payroll_current.year = payroll_next.year - 1
            WHERE 
                payroll_current.year = current_year.year 
                AND payroll_current.payroll_value IS NOT NULL 
                AND payroll_next.payroll_value IS NOT NULL
        ) THEN 1
        ELSE 0
    END AS higher_price_increase
FROM 
    t_kamil_hnatek_project_SQL_primary_final AS current_year
JOIN 
    t_kamil_hnatek_project_SQL_primary_final AS next_year
ON 
    current_year.year = next_year.year - 1
WHERE 
    current_year.price IS NOT NULL 
    AND next_year.price IS NOT NULL 
GROUP BY 
    current_year.year, next_year.year

ORDER BY 
    start_year, typ;


-- VIEW odpověď na otázku 5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
CREATE OR REPLACE VIEW v_kamil_hnatek_project_SQL_Czech_Republic_GDP_increase AS
SELECT 
    gdp_current.year AS start_year,
    gdp_next.year AS end_year,
    gdp_current.GDP AS start_GDP,
    gdp_next.GDP AS end_GDP,
    ROUND(
        ((gdp_next.GDP / gdp_current.GDP) - 1) * 100, 2
    ) AS annual_GDP_increase_percent,  -- Meziroční nárůst GDP v procentech
    ROUND(
        ((SUM(payroll_next.payroll_value) / SUM(payroll_current.payroll_value)) - 1) * 100, 2
    ) AS annual_payroll_increase_percent,  -- Meziroční nárůst mezd v procentech
    ROUND(
        ((SUM(price_next.price) / SUM(price_current.price)) - 1) * 100, 2
    ) AS annual_price_increase_percent  -- Meziroční nárůst cen v procentech
FROM 
    v_kamil_hnatek_project_sql_Czech_Republic_GDP_Gini AS gdp_current
JOIN 
    v_kamil_hnatek_project_sql_Czech_Republic_GDP_Gini AS gdp_next 
    ON gdp_current.year = gdp_next.year - 1
JOIN 
    t_kamil_hnatek_project_SQL_primary_final AS payroll_current
    ON payroll_current.year = gdp_current.year
JOIN 
    t_kamil_hnatek_project_SQL_primary_final AS payroll_next
    ON payroll_next.year = gdp_next.year
JOIN 
    t_kamil_hnatek_project_SQL_primary_final AS price_current
    ON price_current.year = gdp_current.year
JOIN 
    t_kamil_hnatek_project_SQL_primary_final AS price_next
    ON price_next.year = gdp_next.year
WHERE 
    gdp_current.country = 'Czech Republic'
    AND gdp_current.GDP IS NOT NULL 
    AND gdp_next.GDP IS NOT NULL
    AND payroll_current.payroll_value IS NOT NULL 
    AND payroll_next.payroll_value IS NOT NULL
    AND price_current.price IS NOT NULL 
    AND price_next.price IS NOT NULL
GROUP BY 
    gdp_current.year, gdp_next.year
ORDER BY 
    start_year;




