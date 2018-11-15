



SET QUOTED_IDENTIFIER ON;
GO
SET ANSI_NULLS ON;
GO

create FUNCTION dbo.tfn_SplitForSort
/* ===================================================================
11/11/2018 JL, Created: Comments    
=================================================================== */
--===== Define I/O parameters
(
    @string VARCHAR(8000)
)
RETURNS TABLE WITH SCHEMABINDING AS
RETURN 
    WITH 
        cte_n1 (n) AS (SELECT 1 FROM (VALUES (1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) n (n)), 
        cte_n2 (n) AS (SELECT 1 FROM cte_n1 a CROSS JOIN cte_n1 b),
        cte_Tally (n) AS (
            SELECT TOP (LEN(@string))
                ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
            FROM
                cte_n2 a CROSS JOIN cte_n2 b
            ),
        cte_split_string AS (
            SELECT 
                col_num = ROW_NUMBER() OVER (ORDER BY t.n) + CASE WHEN LEFT(@string, 1) LIKE '[0-9]' THEN 0 ELSE 1 END,
                string_part = SUBSTRING(@string, t.n, LEAD(t.n, 1, 8000) OVER (ORDER BY t.n) - t.n)
            FROM
                cte_Tally t
                CROSS APPLY ( VALUES (SUBSTRING(@string, t.n, 2)) ) s (str2)
            WHERE 
                t.n = 1
                OR SUBSTRING(@string, t.n - 1, 2) LIKE '[0-9][^0-9]'
                OR SUBSTRING(@string, t.n - 1, 2) LIKE '[^0-9][0-9]'
            )

    SELECT 
        so_01 = ISNULL(MAX(CASE WHEN ss.col_num = 1 THEN CONVERT(FLOAT, ss.string_part) END), 99999999),
        so_02 = MAX(CASE WHEN ss.col_num = 2 THEN ss.string_part END),
        so_03 = MAX(CASE WHEN ss.col_num = 3 THEN CONVERT(FLOAT, ss.string_part) END),
        so_04 = MAX(CASE WHEN ss.col_num = 4 THEN ss.string_part END),
        so_05 = MAX(CASE WHEN ss.col_num = 5 THEN CONVERT(FLOAT, ss.string_part) END),
        so_06 = MAX(CASE WHEN ss.col_num = 6 THEN ss.string_part END),
        so_07 = MAX(CASE WHEN ss.col_num = 7 THEN CONVERT(FLOAT, ss.string_part) END),
        so_08 = MAX(CASE WHEN ss.col_num = 8 THEN ss.string_part END),
        so_09 = MAX(CASE WHEN ss.col_num = 9 THEN CONVERT(FLOAT, ss.string_part) END),
        so_10 = MAX(CASE WHEN ss.col_num = 10 THEN ss.string_part END)
    FROM
        cte_split_string ss;
---------------------------------------------------------

create proc dbo.prc_SplitForSort
as
SELECT 
    ts.*
FROM
    dbo.tvseason ts
    CROSS APPLY dbo.tfn_SplitForSort (ts.title) sfs
ORDER BY
    sfs.so_01,
    sfs.so_02,
    sfs.so_03,
    sfs.so_04,
    sfs.so_05,
    sfs.so_06,
    sfs.so_07,
    sfs.so_08,
    sfs.so_09,
    sfs.so_10;
-----------------------------------------------------------------------
--*********************************************************************
--*********************************************************************
-----------------------------------------------------------------------*-
create table tvseason
(
    title varchar(100)
);

insert into tvseason (title)
values ('100 Season 03'), ('100 Season 1'),
       ('100 Season 10'), ('100 Season 2'),
       ('100 Season 4'), ('Show Season 1 (2008)'),
       ('Show Season 2 (2008)'), ('Show Season 10 (2008)'),
       ('Another Season 01'), ('Another Season 02'),
       ('Another 1st Anniversary Season 01'),
       ('Another 2nd Anniversary Season 01'),
       ('Another 10th Anniversary Season 01'),
       ('Some Show Another No Season Number'),
       ('Some Show No Season Number'),
       ('Show 2 Season 1'),
       ('Some Show With Season Number 1'),
       ('Some Show With Season Number 2'),
       ('Some Show With Season Number 10');
-----------------------------------------------------
USE [TestDB]
GO
/****** Object:  StoredProcedure [dbo].[TblExec]    Script Date: 11/14/2018 10:54:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[TblExec]
as
Select A.* 
 From tvseason A 
 Cross Apply (values ( replace(
                       replace(
                       replace(Title,'th',' th')
                       ,'st',' st')
                       ,'nd',' nd')
                      )
             ) B(S)
 Cross Apply [dbo].[tvf-Str-Parse-Row](S,' ') C
 Order By IsNull(format(try_convert(money,Pos1),'0000000.0000'),Pos1)
         ,IsNull(format(try_convert(money,Pos2),'0000000.0000'),Pos2)
         ,IsNull(format(try_convert(money,Pos3),'0000000.0000'),Pos3)
         ,IsNull(format(try_convert(money,Pos4),'0000000.0000'),Pos4)
         ,IsNull(format(try_convert(money,Pos5),'0000000.0000'),Pos5)
         ,IsNull(format(try_convert(money,Pos6),'0000000.0000'),Pos6)
         ,IsNull(format(try_convert(money,Pos7),'0000000.0000'),Pos7)
         ,IsNull(format(try_convert(money,Pos8),'0000000.0000'),Pos8)
         ,IsNull(format(try_convert(money,Pos9),'0000000.0000'),Pos9)
-----------------------------------------------------------------
USE [TestDB]
GO
/****** Object:  UserDefinedFunction [dbo].[tvf-Str-Parse-Row]    Script Date: 11/14/2018 10:54:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[tvf-Str-Parse-Row] (@String varchar(max),@Delimiter varchar(10))
Returns Table 
As
Return (
    Select Pos1 = xDim.value('/x[1]','varchar(max)')
          ,Pos2 = xDim.value('/x[2]','varchar(max)')
          ,Pos3 = xDim.value('/x[3]','varchar(max)')
          ,Pos4 = xDim.value('/x[4]','varchar(max)')
          ,Pos5 = xDim.value('/x[5]','varchar(max)')
          ,Pos6 = xDim.value('/x[6]','varchar(max)')
          ,Pos7 = xDim.value('/x[7]','varchar(max)')
          ,Pos8 = xDim.value('/x[8]','varchar(max)')
          ,Pos9 = xDim.value('/x[9]','varchar(max)')
    From  (Select Cast('<x>' + replace((Select replace(@String,@Delimiter,'§§Split§§') as [*] For XML Path('')),'§§Split§§','</x><x>')+'</x>' as xml) as xDim) as A 
)

/*
Here is the output:

title
100 Season 1
100 Season 2
100 Season 03
100 Season 4
100 Season 10
**Case 7 here**
Another 10th Anniversary Season 01
Another 1st Anniversary Season 01
Another 2nd Anniversary Season 01
Another Season 01
Another Season 02
Show (2008) Season 1
Show (2008) Season 2
Show 2 The 75th Anniversary Season 1
Show Season 1 (2008)
Show Season 2 (2008)
Show Season 10 (2008)
Some Show Another No Season Number
Some Show No Season Number
Some Show With Season Number 1
Some Show With Season Number 2
Some Show With Season Number 10
*/