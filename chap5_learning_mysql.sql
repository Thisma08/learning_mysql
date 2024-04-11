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

-- 1.2. Aliases de tables
-------------------------

-- Utiles pour les mêmes raisons que les aliases de colonnes, mais sont parfois la seule manière d'exprimer une query.

SELECT ac.actor_id, ac.first_name, ac.last_name, fla.title 
FROM actor AS ac INNER JOIN film_actor AS fla USING (actor_id) 
INNER JOIN film AS fla USING (film_id) 
WHERE fla.title = 'AFFAIR PREJUDICE'; 

/* =>
+----------+------------+-----------+------------------+ 
| actor_id | first_name | last_name | title            | 
+----------+------------+-----------+------------------+ 
|       41 | JODIE      | DEGENERES | AFFAIR PREJUDICE | 
|       81 | SCARLETT   | DAMON     | AFFAIR PREJUDICE | 
|       88 | KENNETH    | PESCI     | AFFAIR PREJUDICE | 
|      147 | FAY        | WINSLET   | AFFAIR PREJUDICE | 
|      162 | OPRAH      | KILMER    | AFFAIR PREJUDICE | 
+----------+------------+-----------+------------------+  */

-- Si un alias a été utilisé pour une table, impossible de référer à cette table sans utiliser le nouvel alias.

SELECT ac.actor_id, ac.first_name, ac.last_name, fl.title 
FROM actor AS ac INNER JOIN film_actor AS fla USING (actor_id) 
INNER JOIN film AS fl USING (film_id) 
WHERE film.title = 'AFFAIR PREJUDICE'; 

-- => ERROR 1054 (42S22): Unknown column 'film.title' in 'where clause' 

-- Mot clé AS également optionnel, mais tjrs recommandé.

-- Les aliases de tables permettent d'écrire des queries pas faciles à exprimer autrement. p.e., pour savoir si deux films ont le même nom :

SELECT m1.film_id, m2.title 
FROM film AS m1, film AS m2 
WHERE m1.title = m2.title 
AND m1.film_id <> m2.film_id;

-- => Empty set (0.00 sec) (Signification : Il n'y a pas deux films dans la db avec le même nom.)

-- Un film venant d'une table avec alias ne correspond à lui-même dans l'autre table avec alias.

-- Aliases de tables également utiles dans les nested queries utilisant les clauses EXISTS et ON.

-- 2. AGGREGATION DES DONNEES
--===========================

-- But des fonct°s d'aggrégat° : Découvrir les propriétés d'un groupe de record(Nbre de records ds une table, nbre de records partageant une propriété, moyenne, max, min).

-- 2.1. DISTINCT
--------------------------

-- Pas vraiment une fonct° d'aggrégation, mais un filtre post-traitement
-- Permet de supprimer les doublons

SELECT DISTINCT first_name
FROM actor JOIN film_actor USING (actor_id);

/* =>
+-------------+
| first_name  |
+-------------+
| PENELOPE    |
| NICK        |
| ...         |
| GREGORY     |
| JOHN        |
| BELA        |
| THORA       |
+-------------+ */

-- Si clause DISTINCT retirée:

SELECT first_name
FROM actor JOIN film_actor USING (actor_id)
LIMIT 5;

/* =>
+------------+
| first_name |
+------------+
| PENELOPE   |
| PENELOPE   |
| PENELOPE   |
| PENELOPE   |
| PENELOPE   |
+------------+ */

-- La clause DISTINCT s'applique sur l'output et supprimme les records ayant des valeurs identiques dans les colonnes selectionnées pour l'output dans la query.

SELECT DISTINCT first_name, last_name
FROM actor JOIN film_actor USING (actor_id);

/* =>
+-------------+--------------+
| first_name  | last_name    |
+-------------+--------------+
| PENELOPE    | GUINESS      |
| NICK        | WAHLBERG     |
| ...                        |
| JULIA       | FAWCETT      |
| THORA       | TEMPLE       |
+-------------+--------------+ */

-- /!\ Utiliser cette clause avec prudence si le dataset est grand

-- 2.2. GROUP BY
----------------

-- Groupe l'output dans le but de l'aggrégation.
-- Permet d'utiliser les fonctions d'aggrégation sur les données quand le contenu de la clause SELECT contient des colonnes autres que celles contenues dans une fonct° d'aggrégat°.

SELECT first_name FROM actor
WHERE first_name IN ('GENE', 'MERYL');

/* =>
+------------+
| first_name |
+------------+
| GENE       |
| GENE       |
| MERYL      |
| GENE       |
| MERYL      |
+------------+ */

SELECT first_name FROM actor
WHERE first_name IN ('GENE', 'MERYL')
GROUP BY first_name;

/* =>
+------------+
| first_name |
+------------+
| GENE       |
| MERYL      |
+------------+ */

-- Similaire à DISTINCT. Différence : Evalués et éxecutés à des stades différents de l'éxecution de la query. 
-- Toute colonne appartenant au contenu de la clause SELECT qui ne fait pas partie d'une fonct° d'aggrégati° devrait être listée dans GROUP BY. Cette règle peut être enfreinte si chaque groupe résultant ne contient qu'une seule colonne.

SELECT first_name, last_name, COUNT(film_id) AS num_films 
FROM actor INNER JOIN film_actor USING (actor_id)
GROUP BY first_name, last_name
ORDER BY num_films DESC LIMIT 10;

/* =>
+------------+-------------+-----------+
| first_name | last_name   | num_films |
+------------+-------------+-----------+
| SUSAN      | DAVIS       |        54 |
| GINA       | DEGENERES   |        42 |
| WALTER     | TORN        |        41 |
| MARY       | KEITEL      |        40 |
| MATTHEW    | CARREY      |        39 |
| SANDRA     | KILMER      |        37 |
| SCARLETT   | DAMON       |        36 |
| VAL        | BOLGER      |        35 |
| ANGELA     | WITHERSPOON |        35 |
| UMA        | WOOD        |        35 |
+------------+-------------+-----------+ */

-- COUNT ignore les valeurs NULL.

SELECT title, name AS category_name, COUNT(*) AS cnt
FROM film INNER JOIN film_actor USING (film_id)
INNER JOIN film_category USING (film_id)
INNER JOIN category USING (category_id)
GROUP BY film_id, category_id
ORDER BY cnt DESC LIMIT 5;

/* =>
+------------------+---------------+-----+
| title            | category_name | cnt |
+------------------+---------------+-----+
| LAMBS CINCINATTI | Games         |  15 |
| CRAZY HOME       | Comedy        |  13 |
| CHITTY LOCK      | Drama         |  13 |
| RANDOM GO        | Sci-Fi        |  13 |
| DRACULA CRYSTAL  | Classics      |  13 |
+------------------+---------------+-----+ */

SELECT email, name AS category_name, COUNT(category_id) AS cnt
FROM customer cs INNER JOIN rental USING (customer_id)
INNER JOIN inventory USING (inventory_id)
INNER JOIN film_category USING (film_id)
INNER JOIN category cat USING (category_id)
GROUP BY 1, 2
ORDER BY 3 DESC LIMIT 5;

/* =>
+----------------------------------+---------------+-----+
| email                            | category_name | cnt |
+----------------------------------+---------------+-----+
| WESLEY.BULL@sakilacustomer.org   | Games         |   9 |
| ALMA.AUSTIN@sakilacustomer.org   | Animation     |   8 |
| KARL.SEAL@sakilacustomer.org     | Animation     |   8 |
| LYDIA.BURKE@sakilacustomer.org   | Documentary   |   8 |
| NATHAN.RUNYON@sakilacustomer.org | Animation     |   7 |
+----------------------------------+---------------+-----+ */

-- 1, 2, 3 : Numéro de position des colonnes apparaissant dans la clause SELECT

-- Trouver les acteurs possédant le même nom et prénom

SELECT a1.actor_id, a1.first_name, a1.last_name
FROM actor AS a1, actor AS a2
WHERE a1.first_name = a2.first_name
AND a1.last_name = a2.last_name
AND a1.actor_id <> a2.actor_id;

/* =>
+----------+------------+-----------+
| actor_id | first_name | last_name |
+----------+------------+-----------+
|      101 | SUSAN      | DAVIS     |
|      110 | SUSAN      | DAVIS     |
+----------+------------+-----------+ */













