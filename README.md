Kamil Hnátek
Discord: irenicus87
email: kamil.hnatek@gmail.com
-------------------------------------------------------------------
Projekt je zpracován tak, že skript "Projekt_vytvoreni_primarni_tabulky.sql" vytvoří prázdnou tabulku, kde se uloží informace k
cenám potravin v letech a průměrných platech v daných odvětvích. 

Do této tabulky se vkládají data díky skriptům Vlozeni_do_primaru_potraviny.sql a Vlozeni_do_primaru.sql.
Dostupná data cen potravin jsou v letech 2006 až 2018. Data k mzdám jsou od roku 2000 do 2020, porovnání a analýza je tak proveda na společných letech.

Skript "Druha_tabulka_HDP.sql" vytváří tabulku s informacemi k HDP a Gini všech evropských zemí z dostupných dat.

Postup:
1. spusť skript v Projekt_vytvoreni_primarni_tabulky.sql
2. spusť skript v Druha_tabulka HDP.sql
3. spusť skript Vlozeni_do_primaru.sql - toto ti vloží data ohledně mezd v ČR
4. spusť skript Vlozeni_do_primaru_potraviny.sql - toto ti vloží data ohledně cen potravin v letech 2006 - 2018
5. otevři si skript View_projekt.sql, kde jsou vypsány jednotlivá VIEW zobrazující data z vytvořených tabulek výše, tyto VIEW ti pomohou zodpovědět stanovené otázky

Veškeré potřebné informace a odpovědi na dané otázky tak lze zodpovědět díky skriptu "View_projekt.sql",
kde je podrobně popsáno, které VIEW generuje které informace zodpovídajícíc stanovené otázky.

Analýza těchto dat je i proveda v přiloženém excelu "SQL_projekt_analýza.xls" pomocí grafů a tabulek.
