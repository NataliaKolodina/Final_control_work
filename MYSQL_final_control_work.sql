-- Создаем бд
DROP SCHEMA IF EXISTS human_friends;
CREATE SCHEMA human_friends;
USE human_friends;

-- Создаем таблицы
DROP TABLE IF EXISTS dogs;
CREATE TABLE dogs (
	id INT PRIMARY KEY AUTO_INCREMENT,
    animal_name VARCHAR(20),
    command TEXT,
    date_of_birth DATE
);   

DROP TABLE IF EXISTS cats;
CREATE TABLE cats (
	id INT PRIMARY KEY AUTO_INCREMENT,
    animal_name VARCHAR(20),
    command TEXT,
    date_of_birth DATE
);  

DROP TABLE IF EXISTS hamsters;
CREATE TABLE hamsters (
	id INT PRIMARY KEY AUTO_INCREMENT,
    animal_name VARCHAR(20),
    command TEXT,
    date_of_birth DATE
); 

DROP TABLE IF EXISTS horses;
CREATE TABLE horses (
	id INT PRIMARY KEY AUTO_INCREMENT,
    animal_name VARCHAR(20),
    command TEXT,
    date_of_birth DATE
); 

DROP TABLE IF EXISTS camels;
CREATE TABLE camels (
	id INT PRIMARY KEY AUTO_INCREMENT,
    animal_name VARCHAR(20),
    command TEXT,
    date_of_birth DATE
); 

DROP TABLE IF EXISTS donkeys;
CREATE TABLE donkeys (
	id INT PRIMARY KEY AUTO_INCREMENT,
    animal_name VARCHAR(20),
    command TEXT,
    date_of_birth DATE
); 

-- Заполняем таблицы
INSERT INTO dogs(animal_name, command, date_of_birth)
VALUE
	('Tuzik', 'golos', '2023-09-10'),
    ('Reks', 'sidet', '2023-08-10'),
    ('Baron', 'golos, lapu', '2021-07-15'),
    ('Bonya', 'legat, sidet', '2022-05-09'),
    ('Kukuruza', 'golos, lapu', '2024-09-10');
    
INSERT INTO cats(animal_name, command, date_of_birth)
VALUE
	('Feliks', 'legat', '2021-03-10'),
    ('Filya', 'myau', '2023-05-19'),
    ('Murzik', 'legat, lapu', '2021-11-15'),
    ('Matroskin', 'legat, sidet', '2021-11-11'),
    ('Stepasha', 'myau', '2019-12-15');
    
INSERT INTO hamsters(animal_name, command, date_of_birth)
VALUE
	('Pipi', 'gevat', '2022-06-11'),
    ('Pups', 'golos, zamri', '2018-04-12'),
    ('Gigant', 'umri', '2024-03-11'),
    ('Gigi', 'zamri, umri', '2023-11-08'),
    ('Mini', 'golos, gevat', '2023-05-12');
    
INSERT INTO horses(animal_name, command, date_of_birth)
VALUE
	('Belaya', 'lapu', '2017-11-23'),
    ('Chernaya', 'truscoy', '2021-02-16'),
    ('Voronaya', 'truscoy, lapu', '2022-06-14'),
    ('Yabloko', 'golos', '2019-05-09'),
    ('Lilu', 'lapu', '2024-02-09');
    
INSERT INTO camels(animal_name, command, date_of_birth)
VALUE
	('Perviy', 'golos', '2017-11-23'),
    ('Vtoroy', 'lapu', '2021-02-16'),
    ('Tretiy', 'legat, lapu', '2022-06-14'),
    ('Chetvertiy', 'truscoy', '2019-05-09'),
    ('Pyatiy', 'lapu', '2024-02-09');

INSERT INTO donkeys(animal_name, command, date_of_birth)
VALUE
	('Ia', 'truscoy', '2020-11-23'),
    ('Popo', 'sidet', '2023-02-16'),
    ('Fro', 'golos', '2019-06-14'),
    ('Tim', 'legat', '2019-05-09'),
    ('Lol', 'lapu', '2022-02-09');

-- Удаляем из таблицы верблюдов
TRUNCATE camels;

-- Объединить таблицу лошади и ослы в одну таблицу
INSERT INTO horses (animal_name, command, date_of_birth)
SELECT animal_name, command, date_of_birth
FROM donkeys;
ALTER TABLE horses RENAME horses_and_donkeys;
DROP TABLE donkeys;

/* Создаем новую таблицу “молодые животные”, в которую попадут все
животные старше 1 года, но младше 3 лет и в отдельном столбце с точностью
до месяца считаем возраст животных в новой таблице
*/
DROP TABLE IF EXISTS young_animals;
CREATE TABLE young_animals (
	id INT PRIMARY KEY AUTO_INCREMENT,
     animal_name VARCHAR(20),
    command TEXT,
    date_of_birth DATE,
    age TEXT
);

-- Функция, которая ищет возраст
DELIMITER $$
CREATE FUNCTION age_animal (date_b DATE)
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE res TEXT DEFAULT '';
	SET res = CONCAT(
            TIMESTAMPDIFF(YEAR, date_b, CURDATE()),
            ' years ',
            TIMESTAMPDIFF(MONTH, date_b, CURDATE()) % 12,
            ' month'
        );
	RETURN res;
END $$
DELIMITER ;

-- Заполняем таблицу
INSERT INTO young_animals (animal_name, command, date_of_birth, age)
SELECT animal_name, command, date_of_birth, age_animal(date_of_birth)
FROM dogs
WHERE TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 1 AND 3
UNION ALL
SELECT animal_name, command, date_of_birth, age_animal(date_of_birth)
FROM cats
WHERE TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 1 AND 3
UNION ALL
SELECT animal_name, command, date_of_birth, age_animal(date_of_birth)
FROM hamsters
WHERE TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 1 AND 3
UNION ALL
SELECT animal_name, command, date_of_birth, age_animal(date_of_birth)
FROM horses_and_donkeys
WHERE TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 1 AND 3;

-- Объединить все таблицы в одну, при этом сохраняя поля, указывающие на прошлую принадлежность к старым таблицам.

-- Удаляем животных, которые попали в таблицу "молодые животные", чтобы избежать дублирования 
DELETE FROM cats
WHERE TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE())  BETWEEN 1 AND 3;

DELETE FROM dogs 
WHERE TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 1 AND 3;

DELETE FROM hamsters 
WHERE TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 1 AND 3;

DELETE FROM horses_and_donkeys 
WHERE TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 1 AND 3;

-- Создаем общую таблицу и добавляем столбец тип животного
DROP TABLE IF EXISTS animals;
CREATE TABLE animals (
	id INT PRIMARY KEY AUTO_INCREMENT,
	animal_name CHAR(30),
    command TEXT,
    date_of_birth DATE,
    age TEXT,
    animal_type ENUM('cat','dog','hamster', 'horse_and_donkey', 'young_animal') NOT NULL
);

-- Заполняем новую таблицу данными из всех предыдущих таблиц
INSERT INTO animals (animal_name, command, date_of_birth, age, animal_type)
SELECT animal_name, command, date_of_birth, age_animal(date_of_birth), 'cat'
FROM cats;

INSERT INTO animals (animal_name, command, date_of_birth, age, animal_type)
SELECT animal_name, command, date_of_birth, age_animal(date_of_birth), 'dog'
FROM dogs;

INSERT INTO animals (animal_name, command, date_of_birth, age, animal_type)
SELECT animal_name, command, date_of_birth, age_animal(date_of_birth), 'hamster'
FROM hamsters;

INSERT INTO animals (animal_name, command, date_of_birth, age, animal_type)
SELECT animal_name, command, date_of_birth, age_animal(date_of_birth), 'horse_and_donkey'
FROM horses_and_donkeys;

INSERT INTO animals (animal_name, command, date_of_birth, age, animal_type)
SELECT animal_name, command, date_of_birth, age_animal(date_of_birth), 'young_animal'
FROM young_animals;


    