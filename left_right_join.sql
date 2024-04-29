-- But de LEFT JOIN : Joindre deux tables. Si aucune donnée de la seconde table ne correspond à une donnée de la première table => NULL
-- Permet d'avoir à coup sûr ttes les données de la table de gauche.

-- Ex 1 :
SELECT c.nom, a.montant
FROM client c
LEFT JOIN achat a ON (c.id = a.client_id);
/* 
+---------+---------+
| nom     | montant |
+---------+---------+
| Mahaux  |   88.88 |
| Mahaux  |   66.66 |
| Musette |   77.77 |
| Musette |   99.99 |
| Musette |   55.55 |
| Musette |   44.44 |
| Musette |   33.33 |
| Fassin  |   22.22 |
| Test    |    NULL | <- Valeur NULL, car le client avec le nom "Test" n'a effectué aucun achat.
+---------+---------+
9 rows in set (0.00 sec) */

-- Remarques :
-- 1. Si plusieurs LEFT JOINs : Faire attention à l'ordre des tables.
-- 2. RIGHT JOIN = exactement la même chose, sauf que c'est la table de droite dont on veut obtenir ttes les informations
SELECT c.nom, a.montant
FROM client c
RIGHT JOIN achat a ON (c.id = a.client_id);
/* 
+---------+---------+
| nom     | montant |
+---------+---------+
| Mahaux  |   88.88 |
| Mahaux  |   66.66 |
| Musette |   99.99 |
| Musette |   77.77 |
| Musette |   33.33 |
| Musette |   44.44 |
| Musette |   55.55 |
| Fassin  |   22.22 |
+---------+---------+
8 rows in set (0.00 sec) */
-- Le client "Test" n'est pas repris dans la table.