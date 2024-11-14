-- tady si spočítám průměrnou mzdu ze všech odvětví v daném roce
-- Zodpovezeni otazky 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
   
CREATE OR REPLACE VIEW v_kamil_hnatek_project_SQL_industry_yearly_average_payroll AS
SELECT 
    industry_branch_name,
    year,
    ROUND(AVG(payroll_value), 2) AS average_payroll_value  -- Průměrná hodnota mzdy pro konkrétní odvětví a rok
FROM 
    t_kamil_hnatek_project_SQL_primary_final
WHERE 
    payroll_value IS NOT NULL
    AND year IN 2000 AND 2020
GROUP BY 
    industry_branch_name, year
ORDER BY 
    industry_branch_name, year;
   
-- a nebo si vypíšeme pouze prvni a posledni rok a zjistime, zdali v nějakem odvětví poklesly mzdy?
   
CREATE OR REPLACE VIEW v_kamil_hnatek_project_SQL_industry_yearly_average_payroll_2 AS
SELECT 
    industry_branch_name,
    year,
    ROUND(AVG(payroll_value), 2) AS average_payroll_value  -- Průměrná hodnota mzdy pro konkrétní odvětví a rok
FROM 
    t_kamil_hnatek_project_SQL_primary_final
WHERE 
    payroll_value IS NOT NULL
    AND year IN (2000, 2020)  -- Výběr pouze let 2000 a 2020
GROUP BY 
    industry_branch_name, year
ORDER BY 
    industry_branch_name, year;



