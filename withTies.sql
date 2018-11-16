

;WITH MyTable (ID)
AS
(
	SELECT 1 UNION ALL
	SELECT 2 UNION ALL
	SELECT 3 UNION ALL
	SELECT 4 UNION ALL
	SELECT 5 UNION ALL
	SELECT 5
)
SELECT TOP 5 WITH TIES *
FROM MyTable 
ORDER BY ID;

;WITH MyTable (ID)
AS
(
	SELECT 1 UNION ALL
	SELECT 2 UNION ALL
	SELECT 3 UNION ALL
	SELECT 4 UNION ALL
	SELECT 5 UNION ALL
	SELECT 5
)
SELECT TOP 5 WITH TIES *
FROM MyTable 
ORDER BY ID DESC;
-----------------------------
;WITH temp (dt, id,cnt) AS 
(
 SELECT '2018-09-01',   100 ,  50  UNION ALL 
 SELECT '2018-09-01',   101 ,  60  UNION ALL
 SELECT '2018-09-01',   102 ,  55  UNION ALL
 SELECT '2018-09-02',   103 ,  40  UNION ALL
 SELECT '2018-09-02',   104 ,  30  UNION ALL
 SELECT '2018-09-02',   105 ,  20  UNION ALL
 SELECT '2018-09-02',   106 ,  10  UNION ALL
 SELECT '2018-09-03',   107 ,  30  UNION ALL
 SELECT '2018-09-03',   108 ,  70
 /*
 Date         Id    Count
2018-09-01   102   55   
2018-09-02   106   10
2018-09-03   108   70
 */
 )

 SELECT 
top (1) WITH ties t.* 
from temp t
order by row_number() over (partition by dt order by id desc);
-------------------------------------
;WITH temp (dt, id,cnt) AS 
(
 SELECT '2018-09-01',   100 ,  50  UNION ALL 
 SELECT '2018-09-01',   101 ,  60  UNION ALL
 SELECT '2018-09-01',   102 ,  55  UNION ALL
 SELECT '2018-09-02',   103 ,  40  UNION ALL
 SELECT '2018-09-02',   104 ,  30  UNION ALL
 SELECT '2018-09-02',   105 ,  20  UNION ALL
 SELECT '2018-09-02',   106 ,  10  UNION ALL
 SELECT '2018-09-03',   107 ,  30  UNION ALL
 SELECT '2018-09-03',   108 ,  70
 /*
 Date         Id    Count
2018-09-01   102   55   
2018-09-02   106   10
2018-09-03   108   70
 */
 )

 SELECT 
 *,
 --top (1) WITH ties t.* 
 row_number() over (partition by dt order by id desc)
from temp t
order by row_number() over (partition by dt order by id desc);

;WITH temp (dt, id,cnt) AS 
(
 SELECT '2018-09-01',   100 ,  50  UNION ALL 
 SELECT '2018-09-01',   101 ,  60  UNION ALL
 SELECT '2018-09-01',   102 ,  55  UNION ALL
 SELECT '2018-09-02',   103 ,  40  UNION ALL
 SELECT '2018-09-02',   104 ,  30  UNION ALL
 SELECT '2018-09-02',   105 ,  20  UNION ALL
 SELECT '2018-09-02',   106 ,  10  UNION ALL
 SELECT '2018-09-03',   107 ,  30  UNION ALL
 SELECT '2018-09-03',   108 ,  70
 /*
 Date         Id    Count
2018-09-01   102   55   
2018-09-02   106   10
2018-09-03   108   70
 */
 )

 SELECT 
 top (1) WITH ties t.* 
from temp t
order by row_number() over (partition by dt order by id desc);
----------------------------------
----Create temporary table
--CREATE TABLE #MyTable1 (Purchase_Date DATETIME, Amount INT)
----Insert few rows to hold
--INSERT INTO #MyTable1
;WITH MyTable1(Purchase_Date,Amount)
as(
SELECT '11/11/2011', 100 UNION ALL
SELECT '11/12/2011', 110 UNION ALL
SELECT '11/13/2011', 120 UNION ALL
SELECT '11/14/2011', 130 UNION ALL
SELECT '11/11/2011', 150)
--Get ALL records which has minimum purchase date (i.e. 11/11/2011)
SELECT * FROM MyTable1
WHERE Purchase_Date IN (SELECT MIN(Purchase_Date) FROM MyTable1)

;WITH MyTable1(Purchase_Date,Amount)
as(
SELECT '11/11/2011', 100 UNION ALL
SELECT '11/12/2011', 110 UNION ALL
SELECT '11/13/2011', 120 UNION ALL
SELECT '11/14/2011', 130 UNION ALL
SELECT '11/11/2011', 150)
SELECT TOP(3) WITH TIES * FROM MyTable1
ORDER BY Purchase_Date


