INSERT INTO t_kamil_hnatek_project_SQL_primary_final 
    (industry_branch_name, year, quarter, payroll_value)
SELECT 
    b.name AS industry_branch_name,          -- Název odvětví
    cp.payroll_year as year,                         -- Rok
    NULL AS quarter,                         -- Čtvrtletí jako NULL, protože průměrujeme
    AVG(cp.value) AS payroll_value           -- Průměrná mzda pro dané odvětví a rok
FROM 
    czechia_payroll AS cp                    -- Alias cp pro tabulku czechia_payroll
JOIN 
    czechia_payroll_industry_branch AS b ON cp.industry_branch_code = b.code
WHERE 
    cp.value_type_code = 5958                -- Použijeme pouze řádky, kde value_type_code = 5958 (průměrná mzda)
GROUP BY 
    b.name, cp.payroll_year;                 -- Skupinová funkce podle názvu odvětví a roku