DROP DATABASE learning_mysql;
CREATE DATABASE IF NOT EXISTS learning_mysql;

USE learning_mysql;

CREATE TABLE IF NOT EXISTS client (
	id MEDIUMINT NOT NULL AUTO_INCREMENT,
	nom VARCHAR(40),
	prenom VARCHAR(40),
	PRIMARY KEY (id) 
);
ALTER TABLE client AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS achat (
	id MEDIUMINT NOT NULL AUTO_INCREMENT,
	montant FLOAT(6,2),
	client_id MEDIUMINT,
	PRIMARY KEY (id)
);
ALTER TABLE client AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS employe (
	id MEDIUMINT NOT NULL AUTO_INCREMENT,
	nom VARCHAR(40),
	prenom VARCHAR(40),
	salaire FLOAT(6,2),
	PRIMARY KEY (id) 
);
ALTER TABLE employe AUTO_INCREMENT = 1;

INSERT INTO client (nom, prenom) VALUES
("Mahaux", "Mathis"),
("Mahaux", "Sam"),
("Musette", "Alice"),
("Musette", "Marc"),
("Fassin", "Claire");

INSERT INTO achat (montant, client_id) VALUES
(88.88, 1),
(66.66, 2),
(99.99, 3),
(77.77, 3),
(33.33, 4),
(44.44, 4),
(55.55, 4),
(22.22, 5);

INSERT INTO employe (nom, prenom, salaire) VALUES
("NomEmploye1", "PrenomEmploye1", 1111.11),
("NomEmploye2", "PrenomEmploye2", 2222.22),
("NomEmploye3", "PrenomEmploye3", 3333.33);