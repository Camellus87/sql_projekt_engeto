Kamil Hnátek
Discord: irenicus87
email: kamil.hnatek@gmail.com
-------------------------------------------------------------------
Projekt je zpracován tak, že skript "Projekt_vytvoreni_primarni_tabulky.sql" a vytvoří tabulku s informacemi k
cenám potravin v letech a průměrných platech v daných odvětvích. 

Do této tabulky se vkládají data díky skriptům Vlozeni do primaru potraviny.sql a Vlozeni_do_primaru.sql.
Dostupná data cen potravin jsou v letech 2006 až 2018. Data k mzdám jsou od roku 2000 do 2020, porovnání a analýza je tak proveda na společných letech.

Skript "Druha tabulka HDP.sql" vytváří tabulku s informacemi k HDP a Gini všech evropských zemí z dostupných dat.

Postup:
1. spusť skript v Projekt_vytvoreni_primarni_tabulky.sql
2. spusť skript v Druha tabulka HDP.sql
3. spusť skript Vlozeni_do_primaru.sql - toto ti vloží data ohledně mezd v ČR
4. spusť skript Vlozeni do primaru potraviny.sql - toto ti vloží data ohledně cen potravin v letech 2006 - 2018
5. otevři si skript View - projekt.sql, kde jsou vypsány jednotlivá VIEW zobrazující data z vytvořených tabulek výše, tyto VIEW ti pomohou zodpovědět stanovené otázky

Veškeré potřebné informace a odpovědi na dané otázky tak lze zodpovědět díky skriptu "View - projekt.sql",
kde je podrobně popsáno, které VIEW generuje které informace zodpovídajícíc stanovené otázky.

Analýza těchto dat je i proveda v přiloženém excelu "SQL projekt analýza.xls" pomocí grafů a tabulek.