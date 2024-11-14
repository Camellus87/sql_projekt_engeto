-- sloučené VIEW
-- odpověd na 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

CREATE OR REPLACE VIEW v_kamil_hnatek_project_SQL_payroll_annual_increase AS
SELECT 
    current_year.year AS start_year,  -- Aktuální rok
    ROUND(
        ((SUM(current_year.payroll_value) / NULLIF(SUM(previous_year.payroll_value), 0)) - 1) * 100, 2
    ) AS annual_payroll_increase_percent,  -- Meziroční nárůst mezd v procentech
    ROUND(SUM(current_year.payroll_value) / COUNT(current_year.payroll_value), 2) AS average_payroll_value,  -- Průměrná mzda za aktuální rok
    ROUND(
        ((SUM(price_current.price) / NULLIF(SUM(price_previous.price), 0)) - 1) * 100, 2
    ) AS annual_price_increase_percent,  -- Meziroční nárůst cen všech kategorií
    ROUND(
        SUM(price_current.price) / COUNT(price_current.price), 2
    ) AS average_food_price  -- Průměrná cena potravin v daném roce
FROM 
    t_kamil_hnatek_project_SQL_primary_final AS current_year
JOIN 
    t_kamil_hnatek_project_SQL_primary_final AS previous_year
ON 
    current_year.year = previous_year.year + 1  -- Spojíme rok s předchozím rokem
LEFT JOIN
    t_kamil_hnatek_project_SQL_primary_final AS price_current
ON 
    price_current.year = current_year.year
LEFT JOIN
    t_kamil_hnatek_project_SQL_primary_final AS price_previous
ON 
    price_previous.year = previous_year.year
WHERE 
    current_year.payroll_value IS NOT NULL 
    AND previous_year.payroll_value IS NOT NULL
    AND current_year.year BETWEEN 2006 AND 2018  -- Omezíme roky na období 2006 až 2018
    AND price_current.price IS NOT NULL
    AND price_previous.price IS NOT NULL
GROUP BY 
    current_year.year  -- Skupiny podle aktuálního roku
ORDER BY 
    start_year;

