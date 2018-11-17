
--https://docs.microsoft.com/en-us/sql/t-sql/queries/from-using-pivot-and-unpivot?view=sql-server-2017
-- MSSQL get top 4 values from 12 columns

;WITH cte AS (
SELECT *,ROW_NUMBER() OVER (PARTITION BY Name  ORDER BY Percentage DESC) AS rn
FROM 
(SELECT Name,percentage1,percentage2,percentage3,percentage4
            ,percentage5,percentage6,percentage7,percentage8
            ,percentage9,percentage10,percentage11,percentage12
FROM r ) p
UNPIVOT 
 (percentage  FOR subject IN (,percentage1,percentage2,percentage3,percentage4
                              ,percentage5,percentage6,percentage7,percentage8
                             ,percentage9,percentage10,percentage11,percentage12)
  ) up )
 SELECT * FROM cte
 WHERE rn IN (1,2,3,4)
 
 --------------------
DECLARE @FooTable TABLE 
( Name VARCHAR(10), IdNumber INT,
   Subject1 VARCHAR(100), Percentage1 INT,
   Subject2 VARCHAR(10),  Percentage2 INT,
   Subject3 VARCHAR(10),  Percentage3 INT,
   Subject4 VARCHAR(10),  Percentage4 INT
)

INSERT INTO @FooTable
(
    Name, IdNumber,
    Subject1, Percentage1,
    Subject2, Percentage2,
    Subject3, Percentage3,
    Subject4, Percentage4
)


 VALUES
(   'Name 1', -- Name - varchar(10)
    1,
    'Subject 1', -- Subject1 - varchar(10)
    10,  -- Percentage1 - int
    'Subject 2', -- Subject2 - varchar(10)
    20,  -- Percentage2 - int
    'Subject 3', -- Subject3 - varchar(10)
    30,  -- Percentage3 - int
    'Subject 4', -- Subject4 - varchar(10)
    40   -- Percentage4 - int
    )
, ('Name 2', -- Name - varchar(10)
    2,
    'Subject 1', -- Subject1 - varchar(10)
    20,  -- Percentage1 - int
    'Subject 2', -- Subject2 - varchar(10)
    30,  -- Percentage2 - int
    'Subject 3', -- Subject3 - varchar(10)
    40,  -- Percentage3 - int
    'Subject 4', -- Subject4 - varchar(10)
    50   -- Percentage4 - int)
    )
, ('Name 3', -- Name - varchar(10)
    3,
    'Subject 1', -- Subject1 - varchar(10)
    30,  -- Percentage1 - int
    'Subject 2', -- Subject2 - varchar(10)
    40,  -- Percentage2 - int
    'Subject 3', -- Subject3 - varchar(10)
    50,  -- Percentage3 - int
    'Subject 4', -- Subject4 - varchar(10)
    60   -- Percentage4 - int)
    )

SELECT * FROM @FooTable

-----------------
;WITH cte
AS (SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Name ORDER BY percentage DESC) AS rn
    FROM
    (
        SELECT Name,               
               Percentage1,
               Percentage2,
               Percentage3,
               Percentage4
        FROM @FooTable
    ) p
        UNPIVOT
        (
            percentage
            FOR subject IN (Percentage1, Percentage2, Percentage3, Percentage4)
        ) up)
SELECT *
FROM (
SELECT cte.percentage, cte.subject
FROM cte
WHERE rn IN ( 1, 2, 3, 4 )
)source
PIVOT
(
    MAX(percentage)
    FOR subject IN ([Percentage1],[Percentage2],[Percentage3],[Percentage4])
)q
 
