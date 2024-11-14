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