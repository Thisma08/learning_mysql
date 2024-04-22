-- But de HAVING : Avoir + de contrôle sur l'aggrégat° de lignes ds une clause GROUP BY.

-- Sans HAVING :
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
5 rows in set (0.00 sec) */

-- Avec HAVING :
SELECT c.nom, c.prenom, COUNT(a.id) AS nbre_achats 
FROM client c 
INNER JOIN achat a ON (a.client_id = c.id)
GROUP BY nom, prenom
HAVING COUNT(a.id) > 1;
/* 
+---------+--------+-------------+
| nom     | prenom | nbre_achats |
+---------+--------+-------------+
| Musette | Alice  |           2 |
| Musette | Marc   |           3 | <- Clients ayant effectué + de 1 achat
+---------+--------+-------------+
2 rows in set (0.00 sec) */

--Possibilité d'utiliser l'alias :
SELECT c.nom, c.prenom, COUNT(a.id) AS nbre_achats 
FROM client c 
INNER JOIN achat a ON (a.client_id = c.id)
GROUP BY nom, prenom
HAVING nbre_achats > 1;

-- Remarques :
-- 1. DOIT contenir une expression/colonne listée ds la clause SELECT.
-- 2. Expression ds une clause HAVING = typiquement une fonct° d'aggrégat° (COUNT, SUM, AVG, ...)
-- 3. Ne pas utiliser HAVING pour filtrer les réponses à afficher.