-- COUNT
--------

-- But de COUNT : Retourner le nbre de lignes (COUNT(*)) OU le nbre de valeurs dans une colonne (COUNT(<nom_colonne>)).

SELECT COUNT(*) FROM client;
/* 
+----------+
| COUNT(*) |
+----------+
|        5 |
+----------+
1 row in set (0.00 sec) */

-- Remarques :
-- 1. COUNT(*) PRESQUE tjrs = à COUNT(<nom_colonne>). Différence = NULL.
-- COUNT(*) => Nbre de lignes retournées, ss tenir compte du fait que la colonne est NULL.
-- COUNT(<nom_colonne>) => Seulement les valeurs non-NULL.

SELECT * FROM client;
/* 
+----+---------+--------+
| id | nom     | prenom |
+----+---------+--------+
|  1 | Mahaux  | Mathis |
|  2 | Mahaux  | Sam    |
|  3 | Mahaux  | NULL   | <- Valeur NULL
|  4 | Musette | Alice  |
|  5 | Musette | Marc   |
|  6 | Fassin  | Claire |
+----+---------+--------+
6 rows in set (0.00 sec) */

SELECT COUNT(*) FROM client;
/* 
+----------+
| COUNT(*) |
+----------+
|        6 | <- Car 6 lignes dans le tableau
+----------+
1 row in set (0.00 sec) */

SELECT COUNT(prenom) FROM client;
/* 
+---------------+
| COUNT(prenom) |
+---------------+
|             5 | <- 6 lignes - 1 valeur NULL = 5
+---------------+
1 row in set (0.00 sec) */

-- 2. COUNT peut être éxecutée avec une clause DISTINCT interne : COUNT(DISTINCT <nom_colonne>)
-- => Nbre de valeurs distinctes au lieu de ttes les valeurs.

SELECT nom FROM client;
/* 
+---------+
| nom     |
+---------+
| Mahaux  |
| Mahaux  |
| Musette |
| Musette |
| Fassin  |
+---------+
5 rows in set (0.00 sec) */

SELECT COUNT(DISTINCT nom) FROM client;
/* 
+---------------------+
| COUNT(DISTINCT nom) |
+---------------------+
|                   3 | <- Car 3 valeurs <> ds la colonne nom : Mahaux, Musette et Fassin
+---------------------+
1 row in set (0.00 sec) */

-- Colonne "montant" de la table "achat" (Pour illustrer les exemples suivants) :
SELECT montant from achat;
/* 
+---------+
| montant |
+---------+
|   88.88 |
|   66.66 |
|   99.99 |
|   77.77 |
|   33.33 |
|   44.44 |
|   55.55 |
|   22.22 |
+---------+
8 rows in set (0.00 sec) */

-- AVG
------

-- But de AVG : Retourner la moyenne des valeurs dans la colonne spécifiée pour ttes les lignes ds un groupe.

SELECT AVG(montant) FROM achat;
/* 
+--------------+
| AVG(montant) |
+--------------+
|    61.104999 |
+--------------+
1 row in set (0.00 sec) */

-- MAX
------

-- BUT de MAX : Retourner la valeur maximale des lignes d'un groupe.

SELECT MAX(montant) FROM achat;
/* 
+--------------+
| MAX(montant) |
+--------------+
|        99.99 |
+--------------+
1 row in set (0.00 sec) */

-- MIN
------
-- BUT de MIN : Retourner la valeur minimale des lignes d'un groupe.

SELECT MIN(montant) FROM achat;
/* 
+--------------+
| MIN(montant) |
+--------------+
|        22.22 |
+--------------+
1 row in set (0.00 sec) */


-- STD, STDDEV, STDDEV_POP
--------------------------

-- But de STD : Retourner l'écart-type (Mesure statistique qui indique à quel point les valeurs d'un ensemble de données sont dispersées autour de la moyenne) 
-- des lignes d'un groupe.

SELECT STD(montant) FROM achat;
/* 
+--------------------+
| STD(montant)       |
+--------------------+
| 25.456207042746918 | <- Elevé => Données fort dispersées par rapport à la moyenne.
+--------------------+
1 row in set (0.00 sec) */

-- Remarques :
-- 1. STD, STDDEV et STDDEV_POP = synonymes.
-- STD = Extension MySQL
-- STDDEV : Ajouté pour + de compatibilité avec Oracle
-- STDDEV_POP = Fonct° SQL standard.

-- SUM
------

-- But de SUM : Retourner la somme des valeurs des lignes d'un groupe.

SELECT SUM(montant) FROM achat;
/* 
+--------------+
| SUM(montant) |
+--------------+
|       488.84 |
+--------------+
1 row in set (0.00 sec) */