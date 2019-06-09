--- USE db ---
USE s_matskiv_module_3;
GO

/*1.	�������� �� 10 ������� ��� �������������, ������� ���� � ����� ������ ������ �� ������� ������������� 4*/
UPDATE suppliers
SET rating=rating+10
WHERE rating < ALL (SELECT rating FROM suppliers WHERE supplierid = 4);
GO
SELECT * FROM suppliers;
GO
 
/*2.	���������� �������, � ��� �������� ������ ������ ������, �� ��� ����������� � ������, ��� ��� ��� ������������� ����� ����-������ �������������� � �������*/
SELECT DISTINCT products.productid 
INTO d_products
FROM products JOIN supplies
ON products.productid = supplies.productid
JOIN suppliers
ON suppliers.supplierid = supplies.supplierid
WHERE products.city = 'London' OR suppliers.city = 'London';
GO
SELECT * FROM d_products;
GO

/*3.	�������� �� ������, ��� ���� ���� �������� �������*/
DELETE FROM products
WHERE productid NOT IN(SELECT DISTINCT productid FROM supplies);
GO

/*4.	�������� ������� � �������� ������������� � ������ ������ �������, �����, �� ����� � ������������� ��������� ����� ������ �����*/
;WITH details_pairs_every_supplier AS(
SELECT d1,d2
FROM (SELECT d1.detailid d1, d2.detailid d2 
	  FROM details d1
	  JOIN details d2
	  ON d1.detailid <> d2.detailid) AS details_pairs
WHERE (
SELECT COUNT(*) FROM suppliers supp
WHERE EXISTS(SELECT * FROM supplies WHERE supplies.supplierid=supp.supplierid AND detailid=details_pairs.d1) AND 
EXISTS(SELECT * FROM supplies WHERE supplies.supplierid=supp.supplierid AND detailid=details_pairs.d2)) = (SELECT COUNT(*) FROM suppliers)
)
SELECT suppliers.supplierid,d1,d2
INTO supplier_and_pairs
FROM suppliers
JOIN details_pairs_every_supplier
ON 1=1;
GO
SELECT * FROM supplier_and_pairs;
GO

/*5.	�������� ����� �������� �� 10 ������� ��� ��� �������� ��� �������������, �� ����������� ���-������ ������� ������*/
UPDATE supplies
SET quantity=quantity*1.1
WHERE supplierid IN(SELECT DISTINCT suppr.supplierid
				    FROM suppliers suppr JOIN supplies supps
					ON suppr.supplierid=supps.supplierid
					JOIN details ON details.detailid=supps.detailid
					WHERE details.color='Red');
GO
SELECT * FROM supplies;
 
/*6.	�������� �������  � ����������� ����� ����� -- ���� �� ���������� ������� � ���������� ��������*/
SELECT DISTINCT color,city
INTO detail_col_cily
FROM details;
GO
SELECT * FROM detail_col_cily;
GO

/*7.	������� � ������������ ������� ������ ������ �������, �� ������������� ����-���� �������������� � ������� �� ��� ����-����� ������ � �������*/
SELECT DISTINCT details.detailid
INTO detail_London
FROM details JOIN supplies
ON supplies.detailid=details.detailid
JOIN suppliers ON suppliers.supplierid=supplies.supplierid
JOIN products ON products.productid=supplies.productid
WHERE suppliers.city='London' OR products.city='London';
GO
SELECT * FROM detail_London;
GO

/*8.	�������� � ������� ������������� ������������� � ����� 10, �������� ����, � ���� ���-���� � �������� ���������*/ 
SET IDENTITY_INSERT suppliers  ON
GO
INSERT INTO suppliers(supplierid,name,rating,city) VALUES(10,'White',NULL,'New York');
SET IDENTITY_INSERT suppliers  OFF
GO
SELECT * FROM suppliers;
GO

/*9.	�������� �� ������ � ���� � �� ������� ��������*/
;WITH products_Roma AS(
SELECT productid
FROM products
WHERE city ='Roma')
DELETE FROM supplies
WHERE productid IN(SELECT productid FROM products_Roma);
GO
DELETE FROM products
WHERE city='Roma';
GO
SELECT * FROM products;
GO
SELECT * FROM supplies;
GO

/*10.	�������� ������� � ������������� ������� ��� ��� � ���� � �� ������ �� ���� ������������, ���� ������ �� ����*/
;WITH all_cities AS(
SELECT DISTINCT city
FROM suppliers
UNION 
SELECT DISTINCT city
FROM details
UNION 
SELECT DISTINCT city
FROM products
)
SELECT DISTINCT city
INTO active_cities
FROM all_cities
ORDER BY city;
GO
SELECT * FROM active_cities;
GO

/*11.	������ ���� �������� ������� � ����� ����� 15 ����� �� ������.*/
UPDATE details
SET color='Yellow'
WHERE color='Red' AND weight<15;
GO
SELECT * FROM details;
GO

/*12.	�������� ������� � �������� ������ � ������� ���, �� ���� ��������������. ��������� ����� � ����� ����� ����� ���� ������� ���� ��*/
SELECT productid,city
INTO produtcs_cities
FROM products
WHERE city LIKE '_[o]%';
GO
SELECT * FROM produtcs_cities;
GO

/*13.	�������� �� 10 ������� ��� �������������, �ᒺ� �������� ���� ���� ����������*/
;WITH suppliers_avg_qantity AS(
SELECT supplierid, AVG(quantity) avg_qu
FROM supplies
GROUP BY supplierid
)
UPDATE suppliers
SET rating=rating+10
WHERE supplierid IN(SELECT suppliers.supplierid
					FROM suppliers_avg_qantity
					WHERE avg_qu > (SELECT AVG(quantity) FROM supplies));
GO
SELECT * FROM suppliers;
GO

/*14.	�������� ������� � �������������� �������� ������ � ��������� �������������, �� ���������� ����� ��� ������ 1.*/
SELECT DISTINCT suppliers.supplierid,name
INTO suppliers_for_1product
FROM suppliers JOIN supplies
ON suppliers.supplierid=supplies.supplierid
WHERE detailid = 1
ORDER BY supplierid;
GO
SELECT * FROM suppliers_for_1product;
GO

/*15.	�������� � ������� ���� ����� ������������� ����� ��������*/
INSERT INTO suppliers VALUES
('Mike',NULL,'London'),
('Jenny',NULL,'Boston');
GO
SELECT * FROM suppliers;
GO

--- Merge --- 
/*1.	�������� ��������� ������� tmp_Details (��������� ����) �� ��������� �� ������*/
-- done in the first file --

/*2.	��������  ������� merge, ��� ������ ��� � ������� Details �������� �� ������� ����� ������� tmp_Details.*/

MERGE details AS [target]
USING tmp_details AS [source]
ON [target].detailid=[source].detailid

WHEN MATCHED THEN 
		UPDATE SET [target].name=[source].name,[target].color=[source].color,[target].weight=[source].weight,[target].city=[source].city
WHEN NOT MATCHED THEN
		INSERT(name,color,weight,city) VALUES([source].name,[source].color,[source].weight,[source].city)
WHEN NOT MATCHED BY SOURCE THEN 
		DELETE;
GO
SELECT * FROM details;
GO

