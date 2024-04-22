-- 1. Aggrégation de données
--==========================

-- 1.1. DISTINCT
----------------

-- But de DISTINCT : Supprimer les duplicates

-- Sans DISTINCT :
SELECT prenom FROM client;
/* 
+--------+
| prenom |
+--------+
| Mathis | <- Doublon
| Mathis | <- Doublon
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
| Mahaux  | Mathis | <- Doublon
| Mahaux  | Mathis | <- Doublon
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
-- Utiliser DISTINCT avec prudence dans les grands jeux de données, car MySQL doit trier l'output avant de supprimer les doublons
-- => Si DISTINCT utilisé avec de très grandes tables => LENTEUR !