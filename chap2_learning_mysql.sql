-- 1. PROCESSUS DE DESIGN D'UNE DB
--===================================

/* Trois étapes majeures dans la concept° de bases de données :

Analyse des besoins
-------------------
Déterminat° des besoins et des données à stocker, ainsi que des relat°s entre ces données.
Étude approfondie des exigences de l'applicat° et des discussions avec les intervenants.

Concept° conceptuelle
-----------------------
Formalisat° des besoins en une descript° formelle de la concept° de la base de données.
Utilisat° de la modélisat° pour produire la concept° conceptuelle.

Concept° logique
------------------
Mappage de la concept° de la base de données sur un système de gest° de base de données et des tables existantes. */


-- 2. MODELE ER
--=============

-- 2.1. Représenter les entités
-------------------------------

/* Le modèle ER utilise un diag. où les ensembles d'entités = rect. nommés. 
Les caractéristiques des entités stockées comme des attributs (simples ou composés). Certains attributs peuvent avoir +ieurs valeurs, comme les numéros de tel.
Pour différencier les entités, on utilise des clés prim. (simples ou composées), choisies en fonct° de leur unicité et de leur compacité. 
Les attributs = ovales étiquetés dans le diag., et ceux qui composent la clé prim. soulignés. Parties d'attributs composites connectées à l'ovale de l'attribut composite, et attributs multivalués = par des ovales à double ligne. */

/* Valeurs d'attributs choisies dans un domaine de valeurs légales. Par ex., nom = chaîne de max 100 caractères, un numéro de tel. = chaîne de max 40 caractères. 
Attributs peuvent être vides, sauf  clé primaire. 
Il faut réfléchir avant de classer un attribut comme multivalué. Par ex., pour des numéros de tel., il serait utile de les étiqueter séparément. */

-- 2.2. Représenter les relat°s
---------------------------------

/* Entités peuvent participer à des relat°s avec autres entités. Par ex., un client peut acheter un produit, un étudiant peut suivre un cours, un employé peut avoir une adresse, etc.
Comme les entités, les relat°s peuvent avoir des attributs : une vente peut être une relat° entre un client (identifié par l'adresse email unique) et un produit (identifié par l'ID unique) existant à une date et heure particulières (le timestamp).
Notre base de données peut enregistrer chaque vente, par ex., Marcos Albe a acheté à 15h13 le mercredi 22 mars un "Raspberry Pi 4", un "SSD 500 Go M.2 NVMe" et deux ensembles de "Haut-parleurs 5.1 canaux 2000 watts".
Différents nombres d'entités peuvent apparaître de chaque côté d'une relat°, comme dans une relat° de plusieurs à plusieurs (M:N). On peut aussi avoir une relat° de un à plusieurs (1:N), ou un à un (1:1), comme le numéro de série sur un moteur de voiture. 
Dans un diag. ER, une relat° est représentée par un diamant nommé, avec la cardinalité souvent indiquée à côté. */

-- 2.3. Participat° partielle et totale
-----------------------------------------

/* Les relat°s entre entités peuvent être optionelles ou obligatoires. Par ex., une personne peut être considérée comme un client seulement si elle a acheté un produit. 
Ou bien, un client peut être une personne dont nous avons des informat°s et que nous espérons voir acheter quelque chose, même si elle n'a jamais acheté. 
Dans le premier cas, le client participe totalement à la relat° achat (tous les clients ont acheté un produit, et nous ne pouvons pas avoir de client qui n'a pas acheté de produit), 
tandis que dans le second cas, il participe partiellement (un client peut acheter un produit). 
Ces contraintes de participat° sont indiquées dans un diag. ER avec une double ligne entre la boîte d'entité et le diamant de relat°. */

-- 2.4. Entité ou attribut?
---------------------------

/* Parfois, on se demande si un élément devrait être un attribut ou une entité en soi. Quand on hésite :
- L'objet intéresse-t-il directement la base de données ? Si oui, il doit être une entité, sinon, il peut être un attribut. 
- L'objet a-t-il ses propres composants ? Si oui, une entité séparée pourrait être la meilleure solution.
- L'objet peut-il avoir plusieurs instances ? Si oui, il devrait être une entité séparée.
- L'objet est-il souvent inexistant ou inconnu ? Si oui, il serait mieux représenté comme une entité séparée plutôt qu'un attribut souvent vide. */

-- 2.5. Entité ou relation?
---------------------------

/* Pour décider si un objet devrait être une entité ou une relation, mapper les noms aux entités et les verbes aux relations. 
Essayer de garder le design simple et éviter d'introduire des entités triviales si possible. */

-- 2.6. Entités intermédiaire
-----------------------------

/* Pour simplifier une relation de plusieurs-à-plusieurs, on peut introduire une entité intermédiaire reliant les entités originales à travers des relations de plusieurs-à-un et de un-à-plusieurs. 
Par exemple, dans une relation entre "passager" et "vol", on peut introduire l'entité intermédiaire "réservation". 
Chaque réservation implique un passager et un vol, établissant des relations de un-à-plusieurs entre chaque passager et ses réservations, ainsi qu'entre chaque vol et ses réservations. 
La participation totale de l'entité "réservation" dans ces relations assure qu'elle est toujours liée à un passager et à un vol spécifiques. */

-- 2.7. Entités fortes et faibles
---------------------------------

/* Contexte est crucial dans interactions quotidiennes; avec contexte, nécessité d'info réduite. 
Par ex., famille appelée par prénom ou surnom. Pour clarifier, ajoutons infos complémentaires comme nom de famille. 
En design de base de données, pouvons omettre certaines infos clés pour entités dépendantes. 
Par ex., stocker noms des enfants de clients sans toutes les infos. Entité enfant est faible, relation avec client est appelée relation d'identification. 
Entités faibles et relations d'identification représentées avec double ligne dans diag. ER. Entité faible identifiée uniquement dans contexte de son entité parente. 
Clé complète pour entité faible = combinaison de sa propre clé avec celle de son entité parente. Pour identifier enfant dans ex., besoin prénom de l'enfant et email du parent. */


-- 3. Normalisation de la DB
--==========================

/* La normalisation de base de données est essentielle pour concevoir une structure de données relationnelle. Elle vise à réduire la redondance des données et à améliorer leur intégrité. 
Il existe six formes normales, mais la plupart des architectes de bases de données se concentrent sur les trois premières. Chaque niveau de normalisation doit être atteint avant de passer au suivant. 

La 1ere forme vise à éliminer les groupes répétés, à séparer les données connexes et à identifier chaque ensemble de données avec une clé primaire. 

La 2eme forme ajoute la création de tables distinctes pour les ensembles de valeurs applicables à plusieurs enregistrements, reliées par des clés étrangères. 

La 3eme forme ajoute l'élimination des champs indépendants de la clé. En pratique, les problèmes de performance peuvent nécessiter la dénormalisation des données pour les traiter. */


-- 4. UTILISER LE MODELE ER
--=========================

