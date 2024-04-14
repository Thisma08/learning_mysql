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


-- 2.3. HAVING
--------------

-- Permet un controle supplémentaire sur l'aggrégation des records dans une opération GROUP BY

SELECT first_name, last_name, COUNT(film_id)
FROM actor INNER JOIN film_actor USING (actor_id)
GROUP BY actor_id, first_name, last_name 
HAVING COUNT(film_id) > 40
ORDER BY COUNT(film_id) DESC;

/* =>
+------------+-----------+----------------+
| first_name | last_name | COUNT(film_id) |
+------------+-----------+----------------+
| GINA       | DEGENERES |             42 |
| WALTER     | TORN      |             41 |
+------------+-----------+----------------+ */

-- Doit contenir une expression (COUNT, SUM, MIN, MAX)/colonne présente dans la clause SELECT

-- Si l'on veut écrire une clause HAVING utilisant une colonne ou expression non présente dans la clause SELECT => where

-- HAVING faite pour comment former chaque groupe, pas pour choisir des records dans l'output

SELECT title, COUNT(rental_id) AS num_rented 
FROM film INNER JOIN inventory USING (film_id)
INNER JOIN rental USING (inventory_id)
GROUP BY title
HAVING num_rented > 30
ORDER BY num_rented DESC LIMIT 5;

/* =>
+--------------------+------------+
| title              | num_rented |
+--------------------+------------+
| BUCKET BROTHERHOOD |         34 |
| ROCKETEER MOTHER   |         33 |
| FORWARD TEMPLE     |         32 |
| GRIT CLOCKWORK     |         32 |
| JUGGLER HARDLY     |         32 |
+--------------------+------------+ */

-- Ne pas faire cela (Très lent si bcp de données) :

SELECT first_name, last_name, COUNT(film_id) AS film_cnt 
FROM actor INNER JOIN film_actor USING (actor_id)
GROUP BY actor_id, first_name, last_name
HAVING first_name = 'EMILY' AND last_name = 'DEE';

-- Mais faire :

SELECT first_name, last_name, COUNT(film_id) AS film_cnt 
FROM actor INNER JOIN film_actor USING (actor_id)
WHERE first_name = 'EMILY' AND last_name = 'DEE'
GROUP BY actor_id, first_name, last_name;

-- 2.4. Fonct°s d'aggrégation
-----------------------------

-- 2.4.1. COUNT()

-- Retourne le nbre de records ou le nombre de valeurs dans une colonne. 

-- COUNT(*) => Nmbre de records, sans tenir compte du fait que la valeur est NULL ou non.

-- COUNT(<nom_colonne>) => Nmbre de records, en ne comptant pas les valeurs NULL.

SELECT COUNT(*) FROM customer;

/* =>
+----------+
| count(*) |
+----------+
|      599 |
+----------+ */

SELECT COUNT(email) FROM customer;

/* =>
+--------------+
| count(email) |
+--------------+
|          598 |
+--------------+ */

-- => Un des client a une adresse email NULL.

-- Peut être utilisée avec DISTINCT pour compter le nombre de valeurs distinctes (COUNT(DISTINCT <column>))

-- 2.4.2. AVG()

-- Retourne la moyenne des valeurs dans le colonne spécifiée.

SELECT AVG(cost) 
FROM house_prices 
GROUP BY city;

-- 2.4.3. MAX()

-- Retourne la valeur maximale des records dans un groupe.

SELECT MAX(cost) 
FROM house_prices
GROUP BY city;

-- 2.4.4. MIN()

-- Retourne la valeur minimale des records dans un groupe.

SELECT MIN(cost) 
FROM house_prices
GROUP BY city;

-- 2.4.5. STD(), STDDEV(), STDDEV_POP() (Synonymes)

-- Retourne la déviation standard des records dans un groupe. 
-- (Répartit° des résultats aux tests, lorsque les lignes sont regroupées par cours universitaire.)


-- SUM()

-- Retourne la somme des valeurs des records dans un groupe.

SELECT SUM(cost) 
FROM house_prices
GROUP BY city;

-- 3. JOINTURES AVANCEES
--======================

-- 3.1. INNER JOIN
------------------

-- Fait correspondre des lignes entre deux tables, basé sur le critère précisé dans la clause USING.

SELECT first_name, last_name, film_id 
FROM actor INNER JOIN film_actor USING (actor_id)
LIMIT 20;

/* =>
+------------+-----------+---------+
| first_name | last_name | film_id |
+------------+-----------+---------+
| PENELOPE   | GUINESS   |       1 |
| PENELOPE   | GUINESS   |      23 |
| ...                              |
| PENELOPE   | GUINESS   |     980 |
| NICK       | WAHLBERG  |       3 |
+------------+-----------+---------+ */

-- Les lignes n'ayant aucune correspondance ne seront pas incluses dans l'output.

-- Si les noms des identifiants ne sont pas les mêmes dans les deux tables => ON

SELECT first_name, last_name, film_id 
FROM actor INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id
LIMIT 20;

/* =>
+------------+-----------+---------+
| first_name | last_name | film_id |
+------------+-----------+---------+
| PENELOPE   | GUINESS   |       1 |
| PENELOPE   | GUINESS   |      23 |
| ...                              |
| PENELOPE   | GUINESS   |     980 |
| NICK       | WAHLBERG  |       3 |
+------------+-----------+---------+ */

-- INNER JOIN = JOIN = STRAIGHT JOIN

-- 3.2. UNION
-------------

-- Combine les outputs de plusieurs clauses SELECT.

-- Utile lorsque l'on veut faire une seule liste depuis plusieurs sources.

SELECT first_name FROM actor
UNION
SELECT first_name FROM customer
UNION
SELECT title FROM film;

/* =>
+-----------------------------+
| first_name                  |
+-----------------------------+
| PENELOPE                    |
| NICK                        |
| ED                          |
| ...                         |
| ZHIVAGO CORE                |
| ZOOLANDER FICTION           |
| ZORRO ARK                   |
+-----------------------------+ */

-- Créer une liste des 5 films les plus loué et des 5 films les moins loués

(SELECT title, COUNT(rental_id) AS num_rented
FROM film JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
GROUP BY title ORDER BY num_rented DESC LIMIT 5)
UNION
(SELECT title, COUNT(rental_id) AS num_rented
FROM film JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
GROUP BY title ORDER BY num_rented ASC LIMIT 5);

/* =>
+--------------------+------------+
| title              | num_rented |
+--------------------+------------+
| BUCKET BROTHERHOOD |         34 |
| ROCKETEER MOTHER   |         33 |
| FORWARD TEMPLE     |         32 |
| GRIT CLOCKWORK     |         32 |
| JUGGLER HARDLY     |         32 |
| TRAIN BUNCH        |          4 |
| HARDLY ROBBERS     |          4 |
| MIXED DOORS        |          4 |
| BUNCH MINDS        |          5 |
| BRAVEHEART HUMAN   |          5 |
+--------------------+------------+ */

-- UNION possède une oppération DISTINCT implicite.

-- (Deux acteurs ont comme prénom "KENNETH")

SELECT first_name 
FROM actor 
WHERE actor_id = 88
UNION
SELECT first_name 
FROM actor 
WHERE actor_id = 169;

/* =>
+------------+
| first_name |
+------------+
| KENNETH    |
+------------+*/

-- Si l'on veut voir les doublons => UNION ALL

SELECT first_name 
FROM actor 
WHERE actor_id = 88
UNION ALL
SELECT first_name 
FROM actor 
WHERE actor_id = 169;

/* =>
+------------+
| first_name |
+------------+
| KENNETH    |
| KENNETH    |
+------------+ */

-- Si query utilisant LIMIT ou ORDER BY fait partie d'une clause UNION => Parenthèses

-- UNION concatène simplement les résultats des subqueries sans tenir compte de l'ordre => ORDER BY pas vraiment utile dans ce cas.
-- Le seul cas ou cela a du sens d'utiliser ORDER BY dans une subquery faisant partie d'une opérat° UNION est quand l'on veut selectionner un ss-ensemble  des résultats.

-- MySQL ignore les ORDER BY dans uns subquery si elles sont utilisées sans LIMIT.

-- 3.3. LEFT JOIN
-----------------

-- Chaque ligne de la table de gauche est traitée et incluse dans l'output,
-- Avec les données correspondant venant de la seconde table si elles existent, sinon NULL.

SELECT title, rental_date
FROM film 
LEFT JOIN inventory USING (film_id)
LEFT JOIN rental USING (inventory_id);

/* =>
+-----------------------------+---------------------+
| title                       | rental_date         |
+-----------------------------+---------------------+
| ACADEMY DINOSAUR            | 2005-07-08 19:03:15 |
| ACADEMY DINOSAUR            | 2005-08-02 20:13:10 |
| ACADEMY DINOSAUR            | 2005-08-21 21:27:43 |
| ...                                               |
| WAKE JAWS                   | NULL                |
| WALLS ARTIST                | NULL                |
| ...                                               |
| ZORRO ARK                   | 2005-07-31 07:32:21 |
| ZORRO ARK                   | 2005-08-19 03:49:28 |
+-----------------------------+---------------------+ */

-- Ordre des tables dans un LEFT JOIN important.

-- 3.4. RIGHT JOIN
-----------------

-- Chaque ligne de la table de droite est traitée et incluse dans l'output,
-- Avec les données correspondant venant de la seconde table si elles existent, sinon NULL.

SELECT title, rental_date
FROM rental RIGHT JOIN inventory USING (inventory_id)
RIGHT JOIN film USING (film_id)
ORDER BY rental_date DESC;

/* =>
...
| SUICIDES SILENCE            | NULL                |
| TADPOLE PARK                | NULL                |
| TREASURE COMMAND            | NULL                |
| VILLAIN DESPERATE           | NULL                |
| VOLUME HOUSE                | NULL                |
| WAKE JAWS                   | NULL                |
| WALLS ARTIST                | NULL                |
+-----------------------------+---------------------+ */

-- Pas beacoup utilisée, à éviter si possible.

-- 3.5. NATURAL JOIN
--------------------

-- Cherche les colonnes avec un nom identique, puis les ajoute dans un INNER JOIN.

SELECT first_name, last_name, film_id
FROM actor_info NATURAL JOIN film_actor
LIMIT 20;

/* =>
+------------+-----------+---------+
| first_name | last_name | film_id |
+------------+-----------+---------+
| PENELOPE   | GUINESS   |       1 |
| PENELOPE   | GUINESS   |      23 |
| ...                              |
| PENELOPE   | GUINESS   |     980 |
| NICK       | WAHLBERG  |       3 |
+------------+-----------+---------+ */

-- 3.6. Expressions constantes dans les jointures
-------------------------------------------------

-- Lorsque l'on utilise ON, il est possible d'ajouter des expressions constantes.

--Soit la query :
SELECT first_name, last_name, title
FROM actor 
JOIN film_actor USING (actor_id)
JOIN film USING (film_id)
WHERE actor_id = 11;

/* =>
+------------+-----------+--------------------+
| first_name | last_name | title              |
+------------+-----------+--------------------+
| ZERO       | CAGE      | CANYON STOCK       |
| ZERO       | CAGE      | DANCES NONE        |
| ...                                         |
| ZERO       | CAGE      | WEST LION          |
| ZERO       | CAGE      | WORKER TARZAN      |
+------------+-----------+--------------------+ */

-- Il est possible de déplacer la clause actor_id dans le join :

SELECT first_name, last_name, title
FROM actor 
JOIN film_actor ON actor.actor_id = film_actor.actor_id AND actor.actor_id = 11
JOIN film USING (film_id);

/* =>
+------------+-----------+--------------------+
| first_name | last_name | title              |
+------------+-----------+--------------------+
| ZERO       | CAGE      | CANYON STOCK       |
| ZERO       | CAGE      | DANCES NONE        |
| ...                                         |
| ZERO       | CAGE      | WEST LION          |
| ZERO       | CAGE      | WORKER TARZAN      |
+------------+-----------+--------------------+ */

-- Pourquoi ? Les conditions constantes dans les jointures sont évaluées et résolues différemment quand dans les clauses WHERE.

SELECT email, name AS category_name, COUNT(rental_id) AS cnt
FROM category cat LEFT JOIN film_category USING (category_id)
LEFT JOIN inventory USING (film_id)
LEFT JOIN rental USING (inventory_id)
LEFT JOIN customer cs USING (customer_id)
WHERE cs.email = 'WESLEY.BULL@sakilacustomer.org'
GROUP BY email, category_name
ORDER BY cnt DESC;

/* =>
+--------------------------------+---------------+-----+
| email                          | category_name | cnt |
+--------------------------------+---------------+-----+
| WESLEY.BULL@sakilacustomer.org | Games         |   9 |
| WESLEY.BULL@sakilacustomer.org | Foreign       |   6 |
| ...                                                  |
| WESLEY.BULL@sakilacustomer.org | Comedy        |   1 |
| WESLEY.BULL@sakilacustomer.org | Sports        |   1 |
+--------------------------------+---------------+-----+ */

-- Si l'on déplace la clause cs.email dans la clause LEFT JOIN customer cs

SELECT email, name AS category_name, COUNT(rental_id) AS cnt
FROM category cat LEFT JOIN film_category USING (category_id)
LEFT JOIN inventory USING (film_id)
LEFT JOIN rental USING (inventory_id)
LEFT JOIN customer cs ON rental.customer_id = cs.customer_id
AND cs.email = 'WESLEY.BULL@sakilacustomer.org'
GROUP BY email, category_name
ORDER BY cnt DESC;

/* =>
+--------------------------------+-------------+------+
| email                          | name        | cnt  |
+--------------------------------+-------------+------+
| NULL                           | Sports      | 1178 |
| NULL                           | Animation   | 1164 |
| ...                                                 |
| NULL                           | Travel      |  834 |
| NULL                           | Music       |  829 |
| WESLEY.BULL@sakilacustomer.org | Games       |    9 |
| WESLEY.BULL@sakilacustomer.org | Foreign     |    6 |
| ...                                                 |
| WESLEY.BULL@sakilacustomer.org | Comedy      |    1 |
| NULL                           | Thriller    |    0 |
+--------------------------------+-------------+------+ */

-- Non seulement nous avons les nombres de locations de Weasley, mais également ceux de tous les autres clients, regroupés en catégories.

-- Le contenu de la clause WHERE sont appliqués après que les joins soient résolus et éxecutés.

-- MySQL, au lieu de renvoyer les records où cs.email = 'WESLEY.BULL@sakilacustomer.org', 
-- va commencer l'éxécut° comme si des INNER JOIN avaient été utilisés.

-- Lorsque l'on a la condition "cs.email" dans la clause LEFT JOIN, on dit à MySQL que l'on veut
-- ajouter les colonnes de la table customer aux résultats (tables category, inventory et rental),
-- mais seulement lorsque la valeur 'WESLEY.BULL@sakilacustomer.org' est présente dans la colonne email.

-- LEFT JOIN => NULL dans chaque colonne de la table customer dans les records n'ayant pas de correspondance.

-- 4. NESTED Queries
--==================

-- 4.1. Bases
-------------

SELECT first_name, last_name 
FROM actor 
JOIN film_actor USING (actor_id)
WHERE film_id = (SELECT film_id 
FROM film
WHERE title = 'ZHIVAGO CORE');

/* =>
+------------+-----------+
| first_name | last_name |
+------------+-----------+
| UMA        | WOOD      |
| NICK       | STALLONE  |
| GARY       | PENN      |
| SALMA      | NOLTE     |
| KENNETH    | HOFFMAN   |
| WILLIAM    | HACKMAN   |
+------------+-----------+ */

-- Même chose que la query permettant de trouver tous les noms des acteurs ayant joué ds un film particulier:
/* SELECT first_name, last_name 
FROM actor JOIN film_actor USING (actor_id)
JOIN film USING (film_id)
WHERE title = 'ZHIVAGO CORE'; */

-- inner query entre ().

-- Nested query = Une query ds une autre.

-- Nested queries non preferable en terme de performance (Plus lentes), mais cela est parfois le seul choix si l'on veut écrire 1 seule query.
-- et elles peuvent satisfaire des besoins d'informations qui ne sont pas résolvables facilement.

-- Exemple:

SELECT MAX(rental_date) 
FROM rental
JOIN customer USING (customer_id)
WHERE email = 'WESLEY.BULL@sakilacustomer.org';

/* =>
+---------------------+
| MAX(rental_date)    |
+---------------------+
| 2005-08-23 15:46:33 |
+---------------------+ */

-- On peut utiliser l'output en tant qu'input d'une autre query:
SELECT title 
FROM film
JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
JOIN customer USING (customer_id)
WHERE email = 'WESLEY.BULL@sakilacustomer.org'
AND rental_date = '2005-08-23 15:46:33';

/* =>
+-------------+
| title       |
+-------------+
| KARATE MOON |
+-------------+ */

-- Grace aux nested queries, on peut faire ces deux étapes d'un coup:

SELECT title 
FROM film 
JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
WHERE rental_date = (SELECT MAX(rental_date) FROM rental
JOIN customer USING (customer_id)
WHERE email = 'WESLEY.BULL@sakilacustomer.org');

/* =>
+-------------+
| title       |
+-------------+
| KARATE MOON |
+-------------+ */

-- 4.2. Les clauses ANY, SOME, ALL, IN, NOT IN
----------------------------------------------

-- 4.2.1. ANY et IN

SELECT emp_no, first_name, last_name, hire_date
FROM employees JOIN titles USING (emp_no)
WHERE title = 'Assistant Engineer'
AND hire_date < ANY (SELECT hire_date FROM
employees JOIN titles USING (emp_no)
WHERE title = 'Manager');

/* =>
+--------+----------------+------------------+------------+
| emp_no | first_name     | last_name        | hire_date  |
+--------+----------------+------------------+------------+
|  10009 | Sumant         | Peac             | 1985-02-18 |
|  10066 | Kwee           | Schusler         | 1986-02-26 |
| ...                                                     |
| ...                                                     |
| 499958 | Srinidhi       | Theuretzbacher   | 1989-12-17 |
| 499974 | Shuichi        | Piazza           | 1989-09-16 |
+--------+----------------+------------------+------------+ */


-- ANY => BOOLEAN

-- ANY = SOME

-- ANY retourne les valeurs satisfiant au moins un condit° (OR)

-- Si = ANY => IN

-- 4.2.2. ALL

SELECT emp_no, first_name, last_name, hire_date
FROM employees JOIN titles USING (emp_no)
WHERE title = 'Assistant Engineer'
AND hire_date < ALL (SELECT hire_date FROM
employees JOIN titles USING (emp_no)
WHERE title = 'Manager');

/* => Empty set (0.18 sec)
 */
 
-- Raison : Dans les données, le 1er manager a été embauché le 1er janvier 1985,
-- et le 1er ingénieur assistant a été embauché le 1er février 1985.

-- ALL retourne seulement les valeurs où TOUTES les condit°s sont remplies (AND)

-- 4.2.3. Row subqueries

-- Marche avec +ieurs colonnes et +ieurs lignes.

SELECT emp_no, YEAR(from_date) AS fd
FROM titles WHERE title = 'Manager' AND
(emp_no, YEAR(from_date)) IN
(SELECT emp_no, YEAR(from_date)
FROM titles WHERE title <> 'Manager');

/* =>
+--------+------+
| emp_no | fd   |
+--------+------+
| 110765 | 1989 |
| 111784 | 1988 |
+--------+------+ */

-- Syntaxe : Liste de colonnes entre () après WHERE, inner query retourne 2 colonnes

-- 4.3. EXISTS et NOT EXISTS
----------------------------

-- 4.3.1. Bases

SELECT COUNT(*) 
FROM film
WHERE EXISTS (SELECT * FROM rental);

/* =>
+----------+
| COUNT(*) |
+----------+
|     1000 |
+----------+ */

-- Retourne au moins 1 ligne, quoi qu'il arrive.

-- Si la inner query est vraie, la outer query retourne une ligne.

-- Ds l'exemple, le nbre de lignes dans la table film est compté car la inner query est vraie pour chacune d'elles.

-- Si la inner query est fausse :

SELECT title FROM film
WHERE EXISTS (SELECT * 
FROM film
WHERE title = 'IS THIS A MOVIE?');
	
/* => Empty set (0.00 sec)
 */

-- NOT EXISTS fait l'inverse :

SELECT * FROM actor 
WHERE NOT EXISTS
(SELECT * 
FROM film 
WHERE title = 'ZHIVAGO CORE');

/* Empty set (0.00 sec)
 */
 
-- 4.3.2. Subqueries corrélées

-- Véritable usage de EXISTS et NOT EXISTS

SELECT first_name, last_name FROM staff
WHERE EXISTS (SELECT * FROM customer
WHERE customer.first_name = staff.first_name
AND customer.last_name = staff.last_name);

/* Empty set (0.01 sec)
 */
 
-- Pas d'output car personne dans le staff n'est aussi un client.
 
-- Ajout d'un client avec les mêmes détails qu'un membre du staff:

INSERT INTO customer(store_id, first_name, last_name,
email, address_id, create_date)
VALUES (1, 'Mike', 'Hillyer',
'Mike.Hillyer@sakilastaff.com', 3, NOW());

/* => Query OK, 1 row affected (0.02 sec)
 */

SELECT first_name, last_name FROM staff
WHERE EXISTS (SELECT * FROM customer
WHERE customer.first_name = staff.first_name
AND customer.last_name = staff.last_name);

/* =>
+------------+-----------+
| first_name | last_name |
+------------+-----------+
| Mike       | Hillyer   |
+------------+-----------+ */

-- Query "SELECT * FROM customer WHERE customer.first_name = staff.first_name;"
-- Impossible a éxecuter seule.

-- Cela est légal quand éxecuté dans une subquery car les tables listées dans l'outer query peuvent être accédées dans l'inner query.

-- 4.4. Nested queries dans FROM
--------------------------------

SELECT emp_no, monthly_salary FROM
(SELECT emp_no, salary/12 AS monthly_salary FROM salaries) AS ms
LIMIT 5;

/* =>
+--------+----------------+
| emp_no | monthly_salary |
+--------+----------------+
|  10001 |      5009.7500 |
|  10001 |      5175.1667 |
|  10001 |      5506.1667 |
|  10001 |      5549.6667 |
|  10001 |      5580.0833 |
+--------+----------------+ */


-- Subquery => table dérivée

-- Alias sur la table dérivée obligatoire. Sinon :
-- "ERROR 1248 (42000): Every derived table must have its own alias"

-- 4.4. Nested queries dans les JOINs
-------------------------------------

-- Pour lister le nobre de films de chaque catégorie qu'un client particulier a loué:

SELECT cat.name AS category_name, cnt
FROM category AS cat
LEFT JOIN (SELECT cat.name, COUNT(cat.category_id) AS cnt
   FROM category AS cat
   LEFT JOIN film_category USING (category_id)
   LEFT JOIN inventory USING (film_id)
   LEFT JOIN rental USING (inventory_id)
   JOIN customer cs ON rental.customer_id = cs.customer_id
   WHERE cs.email = 'WESLEY.BULL@sakilacustomer.org'
   GROUP BY cat.name) AS customer_cat USING (name)
ORDER BY cnt DESC;

/* =>
+-------------+------+
| name        | cnt  |
+-------------+------+
| Games       |    9 |
| Foreign     |    6 |
| ...                |
| Children    |    1 |
| Sports      |    1 |
| Sci-Fi      | NULL |
| Action      | NULL |
| Thriller    | NULL |
+-------------+------+ */

-- Puissant, mais pas très optimisé.

-- 5. USER VARIABLES
--==================

-- Servent à sauver une valeur pour un usage ultérieur.

SELECT @film:=title FROM film WHERE film_id = 1;

/* =>
+------------------+
| @film:=title     |
+------------------+
| ACADEMY DINOSAUR |
+------------------+ */

SELECT @film;

/* =>
+------------------+
| @film            |
+------------------+
| ACADEMY DINOSAUR |
+------------------+ */

-- Mais il y a un avertissement :
/* *************************** 1. row ***************************
  Level: Warning
   Code: 1287
Message: Setting user variables within expressions is deprecated
and will be removed in a future release. Consider alternatives:
'SET variable=expression, ...', or
'SELECT expression(s) INTO variables(s)'. */

-- 2 alternatives :

SET @film := (SELECT title FROM film WHERE film_id = 1);

/* Query OK, 0 rows affected (0.00 sec)
 */
SELECT @film;

/*=>
+------------------+
| @film            |
+------------------+
| ACADEMY DINOSAUR |
+------------------+ */

-- Ou bien :

SELECT title INTO @film FROM film WHERE film_id = 1;

/* => Query OK, 1 row affected (0.00 sec)
 */
SELECT @film;
 
/*=>
+------------------+
| @film            |
+------------------+
| ACADEMY DINOSAUR |
+------------------+ */

-- Pour définir explicitement une variable :

SET @counter := 0;

-- := optionel. on peut écrire =. Assignements séparés par des ,

SET @counter = 0, @age := 23;

-- Syntaxe alternative : SELECT INTO.

SELECT 0 INTO @counter;

SELECT 0, 23 INTO @counter, @age;

-- Exemple d'utilisat° :

SELECT MAX(rental_date) INTO @recent FROM rental
JOIN customer USING (customer_id)
WHERE email = 'WESLEY.BULL@sakilacustomer.org';

SELECT title 
FROM film
JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
JOIN customer USING (customer_id)
WHERE email = 'WESLEY.BULL@sakilacustomer.org'
AND rental_date = @recent;

/* =>
+-------------+
| title       |
+-------------+
| KARATE MOON |
+-------------+ */

-- Uniques à une seule connection

-- Nom = chaines alphanumériques pouvant inclure . _ et $

-- Noms case sensitive

-- Variable non initialisée = NULL

-- Variables détruites qd connection fermée

-- Eviter d'assigner une valeur à une variable et de l'utiliser dans un SELECT.
-- Raisons : Nvelle valeur peut ne pas être disponible immédiatement ds la même query,
-- et le type d'une variable est défini quand il est assigné dans une query => 
-- Essayer de l'utiliser + tard sous un type différent ds la même commande SQL
-- => Résultats inattendus