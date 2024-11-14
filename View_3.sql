 -- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
-- odpoved na otazku 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

CREATE OR REPLACE VIEW v_kamil_hnatek_project_SQL_avg_annual_increase AS
SELECT 
    start_data.category_code,
    start_data.category_name,
    start_data.year AS start_year,
    end_data.year AS end_year,
    start_data.price AS start_price,
    end_data.price AS end_price,
    ROUND(
        ((end_data.price / start_data.price) - 1) * 100, 2
    ) AS avg_annual_increase_percent  -- Průměrný meziroční nárůst v procentech
FROM 
    t_kamil_hnatek_project_SQL_primary_final AS start_data
JOIN 
    t_kamil_hnatek_project_SQL_primary_final AS end_data
ON 
    start_data.category_code = end_data.category_code
    AND start_data.year = end_data.year - 1  -- Připojení po sobě jdoucích let
WHERE 
    start_data.price IS NOT NULL
    AND end_data.price IS NOT NULL
    AND start_data.category_code IS NOT NULL
ORDER BY 
    avg_annual_increase_percent ASC;


