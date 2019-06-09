--- db creation ---
CREATE DATABASE s_matskiv_module_3;
GO

--- USE db ---
USE s_matskiv_module_3;
GO

--- suppliers ---
CREATE TABLE suppliers(
supplierid INT PRIMARY KEY IDENTITY,
name VARCHAR(20),
rating INT,
city VARCHAR(20)
);
GO

--- details ---
CREATE TABLE details(
detailid INT PRIMARY KEY IDENTITY,
name VARCHAR(20),
color VARCHAR(20),
weight INT,
city VARCHAR(20)
);
GO

--- products ---
CREATE TABLE products(
productid INT PRIMARY KEY IDENTITY,
name VARCHAR(20),
city VARCHAR(20)
);
GO

--- supplies --
CREATE TABLE supplies(
supplierid INT FOREIGN KEY REFERENCES suppliers(supplierid),
detailid INT FOREIGN KEY REFERENCES details(detailid) ON DELETE CASCADE,
productid INT FOREIGN KEY REFERENCES products(productid),
quantity INT
);
GO

--- Merge --- /*1.	Створити додаткову таблицю tmp_Details та наповнити її даними*/
CREATE TABLE tmp_details(
detailid INT PRIMARY KEY,
name VARCHAR(20),
color VARCHAR(20),
weight INT,
city VARCHAR(20)
);
GO

--- filling data ---
INSERT INTO suppliers(name,rating,city) VALUES
('Smith',20,'London'),
('Jonth',10,'Paris'),
('Blacke',30,'Paris'),
('Clarck',20,'London'),
('Adams',30,'Athens');
GO

INSERT INTO details(name,color,weight,city) VALUES
('Screw','Red',12,'London'),
('Bolt','Green',17,'Paris'),
('Male-screw','Blue',17,'Roma'),
('Male-screw','Red',14,'London'),
('Whell','Blue',12,'Paris'),
('Bloom','Red',19,'London');
GO

INSERT INTO products(name,city) VALUES
('HDD','Paris'),
('Perforator','Roma'),
('Reader','Athens'),
('Printer','Athens'),
('FDD','London'),
('Terminal','Oslo'),
('Ribbon','London');
GO

INSERT INTO supplies(supplierid,detailid,productid,quantity) VALUES
(1,1,1,200),
(1,1,4,700),
(2,3,1,400),
(2,3,2,200),
(2,3,3,200),
(2,3,4,500),
(2,3,5,600),
(2,3,6,400),
(2,3,7,800),
(2,5,2,100),
(3,3,1,200),
(3,4,2,500),
(4,6,3,300),
(4,6,7,300),
(5,2,2,200),
(5,2,4,100),
(5,5,5,500),
(5,5,7,100),
(5,6,2,200),
(5,1,4,100),
(5,3,4,200),
(5,4,4,800),
(5,5,4,400),
(5,6,4,500);
GO

INSERT INTO tmp_details(detailid,name,color,weight,city) VALUES
(1, 'Screw',         'Blue',     13, 'Osaka'),
(2, 'Bolt',           'Pink', 12, 'Tokio'),
(18, 'Whell-24', 'Red',   14, 'Lviv'),
(19, 'Whell-28', 'Pink',     15, 'London');
GO