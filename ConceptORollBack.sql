CREATE TABLE dbo.TranTest (id INT NOT NULL, some_value INT NOT NULL);
INSERT dbo.TranTest (id, some_value) VALUES (1, 11111);

BEGIN TRANSACTION
    -- check initial values...
    SELECT * FROM dbo.TranTest tt;

    -- update values and include the OUTPUT clause to view the contents of the "Inserted" & "Deleted" tables.
    UPDATE tt SET 
        tt.some_value = tt.some_value * 22
            OUTPUT 
                Deleted.id, 
                Deleted.some_value, 
                Inserted.id, 
                Inserted.some_value, 
                GETDATE() AS tran_date 
    FROM
        dbo.TranTest tt;

    -- check the values after the UPDATE and before the ROLLBACK
    SELECT * FROM dbo.TranTest tt;

ROLLBACK TRANSACTION

    -- check the values after the ROLLBACK
    SELECT * FROM dbo.TranTest tt;  