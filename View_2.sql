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
JOIN 
    (
        SELECT 
            MIN(year) AS first_year,
            MAX(year) AS last_year
        FROM 
            t_kamil_hnatek_project_SQL_primary_final
        WHERE 
            year IN (SELECT DISTINCT YEAR(date_from) FROM czechia_price WHERE region_code IS NULL)
    ) AS year_range ON t.year = year_range.first_year OR t.year = year_range.last_year
WHERE 
    p.region_code IS NULL
GROUP BY 
    t.year
HAVING 
    average_payroll_value IS NOT NULL
ORDER BY 
    t.year;

