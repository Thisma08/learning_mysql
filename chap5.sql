-- 1. Aggrégation de données
--==========================

-- 1.1. DISTINCT
----------------

-- Sans DISTINCT :
SELECT prenom FROM client;
/* 
+--------+
| prenom |
+--------+
| Mathis |
| Mathis | <- Duplicate
| Sam    |
| Alice  |
| Marc   |
| Claire |
+--------+
6 rows in set (0.00 sec) */

-- Avec DISTINCT :
SELECT DISTINCT prenom FROM client;
/* 
+--------+
| prenom |
+--------+
| Mathis |
| Sam    |
| Alice  |
| Marc   |
| Claire |
+--------+
5 rows in set (0.00 sec) */

-- But de DISTINCT : Supprimer les duplicates