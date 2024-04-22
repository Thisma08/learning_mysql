-- But de DISTINCT : Supprimer les duplicates

-- Sans DISTINCT :
SELECT prenom FROM client;
/* 
+--------+
| prenom |
+--------+
| Mathis | <- Doublon (Ajouté à titre d'exemple)
| Mathis | <- Doublon (Ajouté à titre d'exemple)
| Sam    |
| Alice  |
| Marc   |
| Claire |
+--------+
6 rows in set (0.00 sec) */

SELECT nom, prenom FROM client;
/* 
+---------+--------+
| nom     | prenom |
+---------+--------+
| Mahaux  | Mathis | <- Doublon (Ajouté à titre d'exemple) 
| Mahaux  | Mathis | <- Doublon (Ajouté à titre d'exemple)
| Mahaux  | Sam    |
| Musette | Alice  |
| Musette | Marc   |
| Fassin  | Claire |
+---------+--------+
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

SELECT DISTINCT nom, prenom FROM client;
 /* 
+---------+--------+
| nom     | prenom |
+---------+--------+
| Mahaux  | Mathis |
| Mahaux  | Sam    |
| Musette | Alice  |
| Musette | Marc   |
| Fassin  | Claire |
+---------+--------+
5 rows in set (0.00 sec) */

-- Fonctionnement :
-- DISTINCT n'est pas vraiment une fonct° d'aggrégat°, mais un filtre post-traitement.
-- DISTINCT s'applique à l'output de la query et retire les lignes qui ont des valeurs = dans les colonnes sélectionnées pour l'output de la query.

-- Remarques :
-- 1. Utiliser DISTINCT avec prudence dans les grands jeux de données, car MySQL doit trier l'output avant de supprimer les doublons.
-- => Si DISTINCT utilisé avec de très grandes tables => LENTEUR !