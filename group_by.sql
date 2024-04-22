-- But de GROUP BY : Grouper les données en output dans le but d'une aggrégat°.
-- Permet d'utiliser les foncti°s d'aggrégat° sur les données quand le contenu de la clause SELECT contient des colonnes autres que celles dans la fonct° d'aggrégat°.

-- EX1:
-- Sans GROUP BY :
SELECT nom 
FROM client;
/* 
+---------+
| nom     |
+---------+
| Mahaux  |
| Mahaux  |
| Mahaux  |
| Musette |
| Musette |
| Fassin  |
+---------+
6 rows in set (0.00 sec) */

-- Avec GROUP BY:
SELECT nom 
FROM client 
GROUP BY nom;
/* 
+---------+
| nom     |
+---------+
| Mahaux  |
| Musette |
| Fassin  |
+---------+
3 rows in set (0.00 sec) */

-- EX2:
-- Sans GROUP BY
SELECT c.nom, c.prenom, a.id AS achat_id 
FROM client c 
INNER JOIN achat a ON (a.client_id = c.id);
/* 
+---------+--------+----------+
| nom     | prenom | achat_id |
+---------+--------+----------+
| Mahaux  | Mathis |        1 |
| Mahaux  | Sam    |        2 |
| Musette | Alice  |        3 |
| Musette | Alice  |        4 |
| Musette | Marc   |        5 |
| Musette | Marc   |        6 |
| Musette | Marc   |        7 |
| Fassin  | Claire |        8 |
+---------+--------+----------+
8 rows in set (0.00 sec) */

-- Avec GROUP BY
SELECT c.nom, c.prenom, COUNT(a.id) AS nbre_achats 
FROM client c 
INNER JOIN achat a ON (a.client_id = c.id)
GROUP BY nom, prenom;
/* 
+---------+--------+-------------+
| nom     | prenom | nbre_achats |
+---------+--------+-------------+
| Mahaux  | Mathis |           1 |
| Mahaux  | Sam    |           1 |
| Musette | Alice  |           2 |
| Musette | Marc   |           3 |
| Fassin  | Claire |           1 |
+---------+--------+-------------+
4 rows in set (0.00 sec) */

-- Remarques :
-- 1. Similaire à ORDER BY (Prennent une liste de colonnes comme argument), mais les 2 clauses sont évaluées à des moments <> et sont similaires en à quoi elles ressemblent, mais
-- pas en comment elles opèrent.
-- 2. Si l'on liste chaque colonne selectionnée dans le GROUP BY = DISTINCT. <> avec DISTINCT : Moment d'évaluat° et d'execut°.
-- 3. Chaque colonne dans la clause SELECT n'étant pas ds une fonct° d'aggrégat° devrait être listée dans la clause GROUP BY.
-- 4. Si l'on groupe basé sur des colonnes ne formant pas un identifiant unique => Risque de grouper des lignes sans rapport => Données érronées.