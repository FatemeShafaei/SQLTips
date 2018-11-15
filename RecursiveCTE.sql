-- https://stackoverflow.com/questions/14274942/sql-server-cte-and-recursion-example

I haven't tested your code, just tried to help you understand how it operates in comment;

WITH
  cteReports (EmpID, FirstName, LastName, MgrID, EmpLevel)
  AS
  (
-->>>>>>>>>>Block 1>>>>>>>>>>>>>>>>>
-- In a rCTE, this block is called an [Anchor]
-- The query finds all root nodes as described by WHERE ManagerID IS NULL
    SELECT EmployeeID, FirstName, LastName, ManagerID, 1
    FROM Employees
    WHERE ManagerID IS NULL
-->>>>>>>>>>Block 1>>>>>>>>>>>>>>>>>
    UNION ALL
-->>>>>>>>>>Block 2>>>>>>>>>>>>>>>>>    
-- This is the recursive expression of the rCTE
-- On the first "execution" it will query data in [Employees],
-- relative to the [Anchor] above.
-- This will produce a resultset, we will call it R{1} and it is JOINed to [Employees]
-- as defined by the hierarchy
-- Subsequent "executions" of this block will reference R{n-1}
    SELECT e.EmployeeID, e.FirstName, e.LastName, e.ManagerID,
      r.EmpLevel + 1
    FROM Employees e
      INNER JOIN cteReports r
        ON e.ManagerID = r.EmpID
-->>>>>>>>>>Block 2>>>>>>>>>>>>>>>>>
  )
SELECT
  FirstName + ' ' + LastName AS FullName,
  EmpLevel,
  (SELECT FirstName + ' ' + LastName FROM Employees
    WHERE EmployeeID = cteReports.MgrID) AS Manager
FROM cteReports
ORDER BY EmpLevel, MgrID
The simplest example of a recursive CTE I can think of to illustrate its operation is;

;WITH Numbers AS
(
    SELECT n = 1
    UNION ALL
    SELECT n + 1
    FROM Numbers
    WHERE n+1 <= 10
)
SELECT n
FROM Numbers
Q 1) how value of N is getting incremented. if value is assign to N every time then N value can be incremented but only first time N value was initialize.

A1: In this case, N is not a variable. N is an alias. It is the equivalent of SELECT 1 AS N. It is a syntax of personal preference. There are 2 main methods of aliasing columns in a CTE in T-SQL. I've included the analog of a simple CTE in Excel to try and illustrate in a more familiar way what is happening.

--  Outside
;WITH CTE (MyColName) AS
(
    SELECT 1
)
-- Inside
;WITH CTE AS
(
    SELECT 1 AS MyColName
    -- Or
    SELECT MyColName = 1  
    -- Etc...
)
Excel_CTE

Q 2) now here about CTE and recursion of employee relation the moment i add two manager and add few more employee under second manager then problem start. i want to display first manager detail and in the next rows only those employee details will come those who are subordinate of that manager

A2:

Does this code answer your question?

--------------------------------------------
-- Synthesise table with non-recursive CTE
--------------------------------------------
;WITH Employee (ID, Name, MgrID) AS 
(
    SELECT 1,      'Keith',      NULL   UNION ALL
    SELECT 2,      'Josh',       1      UNION ALL
    SELECT 3,      'Robin',      1      UNION ALL
    SELECT 4,      'Raja',       2      UNION ALL
    SELECT 5,      'Tridip',     NULL   UNION ALL
    SELECT 6,      'Arijit',     5      UNION ALL
    SELECT 7,      'Amit',       5      UNION ALL
    SELECT 8,      'Dev',        6   
)
--------------------------------------------
-- Recursive CTE - Chained to the above CTE
--------------------------------------------
,Hierarchy AS
(
    --  Anchor
    SELECT   ID
            ,Name
            ,MgrID
            ,nLevel = 1
            ,Family = ROW_NUMBER() OVER (ORDER BY Name)
    FROM Employee
    WHERE MgrID IS NULL

    UNION ALL
    --  Recursive query
    SELECT   E.ID
            ,E.Name
            ,E.MgrID
            ,H.nLevel+1
            ,Family
    FROM Employee   E
    JOIN Hierarchy  H ON E.MgrID = H.ID
)
SELECT *
FROM Hierarchy
ORDER BY Family, nLevel
Another one sql with tree structure
SELECT ID,space(nLevel+
                    (CASE WHEN nLevel > 1 THEN nLevel ELSE 0 END)
                )+Name
FROM Hierarchy
ORDER BY Family, nLevel