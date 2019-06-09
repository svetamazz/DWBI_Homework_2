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
detailid INT FOREIGN KEY REFERENCES details(detailid),
productid INT FOREIGN KEY REFERENCES products(productid),
quantity INT
);
GO