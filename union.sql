-- But de UNION : Combiner l'output de deux clauses SELECT ou plus. N'est pas vraiment un opérateur JOIN.
-- Utile dans les cas où l'on veut produire une seule liste à partir de plus d'une source,
-- ou si l'on veut créer des listes à partir d'une source difficile à éxprimer avec une seule query.

-- Ex 1 :
SELECT nom from client
UNION
SELECT nom from employe
UNION
SELECT prenom from client
UNION
SELECT prenom from employe;
/* 
+----------------+
| nom            |
+----------------+
| Mahaux         |
| Musette        |
| Fassin         |
| NomEmploye1    |
| NomEmploye2    |
| NomEmploye3    |
| Mathis         |
| Sam            |
| Alice          |
| Marc           |
| Claire         |
| PrenomEmploye1 |
| PrenomEmploye2 |
| PrenomEmploye3 |
+----------------+
14 rows in set (0.00 sec) */

-- Ex 2 :
-- Top 3 des achats aux montants les + élevés
-- et top 3 des achats aux montants les - élevés
(SELECT id, montant AS montant
FROM achat
GROUP BY id ORDER BY montant DESC LIMIT 3)
UNION
(SELECT id, montant AS montant
FROM achat
GROUP BY id ORDER BY montant ASC LIMIT 3);
/* 
+----+---------+
| id | montant |
+----+---------+
|  3 |   99.99 |
|  1 |   88.88 |
|  4 |   77.77 |
|  8 |   22.22 |
|  5 |   33.33 |
|  6 |   44.44 |
+----+---------+
6 rows in set (0.00 sec) */

-- Remarques :
-- 1. L'output est étiqueté avec les noms des colonnes/expressions venant de la 1ère query => utiliser les alias.
-- 2. Les queries doivent retourner le même nbre de colonnes, sinon => Erreur
-- 3. Ttes les colonnes correspondantes doivent avoir le même type. (Si 1ère colonne ds la 1ère query = INT => 1ère colonne ds la 2ème query = INT)
-- 4. Résultats uniques, comme si DISTINCT avait été utilisé.
-- Ex :
-- Soit la table client suivante :
/* 
+----+---------+--------+
| id | nom     | prenom |
+----+---------+--------+
|  1 | Mahaux  | Mathis | <- Doublon sur le nom et le prénom
|  2 | Mahaux  | Mathis | <- Doublon sur le nom et le prénom
|  3 | Mahaux  | Sam    |
|  4 | Musette | Alice  |
|  5 | Musette | Marc   |
|  6 | Fassin  | Claire |
+----+---------+--------+
6 rows in set (0.00 sec) */

SELECT nom, prenom 
FROM client 
WHERE id = 1
UNION
SELECT nom, prenom 
FROM client 
WHERE id = 2;
/* 
+--------+--------+
| nom    | prenom |
+--------+--------+
| Mahaux | Mathis |
+--------+--------+
1 row in set (0.00 sec) */

-- Si l'on veut tt de même afficher les doublons => UNION ALL :

SELECT nom, prenom 
FROM client 
WHERE id = 1
UNION ALL
SELECT nom, prenom 
FROM client 
WHERE id = 2;
/* 
+--------+--------+
| nom    | prenom |
+--------+--------+
| Mahaux | Mathis |
| Mahaux | Mathis |
+--------+--------+
2 rows in set (0.00 sec) */

-- 5. Si LIMIT ou ORDER BY doit faire partie d'une query faisant partie d'une clause UNION => L'enfermer entre ()
-- UNION ne fait pas attention à l'ordre => ORDER BY pas très utile. ORDER BY seulement utile si l'on veut selectionner un ss-ensemble ds les résultats (Top 3, ...)
-- MySQL ignore ORDER BY s'il est utilisé sans LIMIT (But d'efficacité)
-- Output d'une UNION n'est pas garanti d'être ordonné => Conseillé d'ajouter un ORDER BY à la fin de la query entière.