DROP DATABASE learning_mysql;
CREATE DATABASE IF NOT EXISTS learning_mysql;

USE learning_mysql;

CREATE TABLE IF NOT EXISTS client (
	id MEDIUMINT NOT NULL AUTO_INCREMENT,
	nom VARCHAR(40),
	prenom VARCHAR(40),
	PRIMARY KEY (id) 
);
ALTER TABLE application AUTO_INCREMENT = 1;

INSERT INTO client (nom, prenom) VALUES
("Mahaux", "Mathis"),
("Mahaux", "Mathis"),
("Mahaux", "Sam"),
("Musette", "Alice"),
("Musette", "Marc"),
("Fassin", "Claire");