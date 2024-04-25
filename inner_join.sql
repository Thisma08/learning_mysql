-- But de INNER JOIN : Faire correspondre les lignes entre deux tables selon le critère spécifié dans la clause ON ou USING

SELECT c.nom, c.prenom, a.montant
FROM client c
INNER JOIN achat a 
ON (c.id = a.client_id);
/* 
+---------+--------+---------+
| nom     | prenom | montant |
+---------+--------+---------+
| Mahaux  | Mathis |   88.88 |
| Mahaux  | Sam    |   66.66 |
| Musette | Alice  |   99.99 |
| Musette | Alice  |   77.77 |
| Musette | Marc   |   33.33 |
| Musette | Marc   |   44.44 |
| Musette | Marc   |   55.55 |
| Fassin  | Claire |   22.22 |
+---------+--------+---------+
8 rows in set (0.00 sec) */

-- Remarques :
-- 1. Autres moyens d'arriver au même résultat sans utiliser INNER JOIN :

SELECT nom, prenom, montant
FROM client, achat
WHERE client.id = achat.client_id;

-- Si absence de INNER JOIN dans ce type de query => Produit cartésien (<nbre_lignes_table_1>x<nbre_lignes_table_2>, pas de sens)
-- Cela arrive également si INNER JOIN executé sans utiliser USING ou ON.

-- 2. Si les noms des colonnes avec les identifiants ne sont pas les mêmes => Utiliser USING
-- (INNER JOIN table USING(<nom_colonne_identifiants>))

