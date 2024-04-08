-- 1. ALIASES
--===========

-- Aliases = Surnoms. Manière raccourcie d'exprimer une colonne, table ou nom de fonct°
-- Buts :
-- * Queries + courtes
-- * Queries exprimées + clairement
-- * Utilisater un table de 2 manières et + dans 1 seule requête
-- * Accès aux données + facile
-- * Usage des "nestes queries"

-- 1.1. Aliases de colonnes
---------------------------

-- Utiles pour ameliorer l'expression des queries en réduisant le nbre de caractères à taper.
-- Travail avec des lagages de programmation (Python, PHP) facilité

SELECT first_name AS 'First Name', last_name AS 'Last Name' 
FROM actor LIMIT 5; 

/* =>
+------------+--------------+ 
| First Name | Last Name    | 
+------------+--------------+ 
| PENELOPE   | GUINESS      | 
| NICK       | WAHLBERG     | 
| ED         | CHASE        | 
| JENNIFER   | DAVIS        | 
| JOHNNY     | LOLLOBRIGIDA | 
+------------+--------------+ */

-- Noms de colonnes habituels (first_name, last_name) remplacés par "First Name" et "Last Name"
-- Avantage : Noms des colonnes peuvent avoir + de sens pour les humains.

SELECT CONCAT(first_name, ' ', last_name, ' played in ', title) AS movie 
FROM actor JOIN film_actor USING (actor_id) 
JOIN film USING (film_id) 
ORDER BY movie LIMIT 20;

/* =>
+--------------------------------------------+ 
| movie                                      | 
+--------------------------------------------+ 
| ADAM GRANT played in ANNIE IDENTITY        | 
| ADAM GRANT played in BALLROOM MOCKINGBIRD  | 
| ...                                        | 
| ADAM GRANT played in TWISTED PIRATES       | 
| ADAM GRANT played in WANDA CHAMBER         | 
| ADAM HOPPER played in BLINDNESS GUN        | 
| ADAM HOPPER played in BLOOD ARGONAUTS      | 
+--------------------------------------------+ */

-- La colonne a comme titre "movie" et nom la fonction "CONCAT()" entière.
-- Fonction "CONCAT()" référée en tant que "movie". On peut maintenant faire référence à celle-ci facilement (P.e. dans la clause "ORDER BY").

-- On ne peut utiliser les aliases dans les clauses :
-- * WHERE
-- * USING
-- * ON

SELECT first_name AS name FROM actor WHERE name = 'ZERO CAGE';

-- => ERROR 1054 (42S22): Unknown column 'name' in 'where clause'

-- Raison : MySQL ne sait pas tjrs les valeurs des colonnes avant l'éxecut° de la clause WHERE.

-- On peut utiliser les aliases de colonnes avec les clauses :
-- * ORDER BY
-- * GROUP BY
-- * HAVING

-- Mot clé AS optionnel.

SELECT actor_id id FROM actor WHERE first_name = 'ZERO'; 

/* =>
+----+ 
| id | 
+----+ 
| 11 | 
+----+ */ 

-- Utilisation du mot clé AS tt de même recommandé (Aide à distinguer clairement les colonnes avec alias).

-- 255 caractères max.
-- Suivent les mêmes règles de nommage que les noms de tables et de colonnes.
-- Insensibles à la casse