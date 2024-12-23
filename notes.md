# Notes

## Ch. 1 Create Views of the Data

Tell SQL Server which db to use:

```SQL
USE DatabaseName;
GO
```

Interact with SQL Server from the command prompt: 

```shell
C:\> sqlcmd
1>
```

The `AS` keyword can be used to alias an entire table:

```SQL
...
JOIN Application.People AS Contacts
...
```

Creating a view:

```SQL
CREATE VIEW SchemaName.ViewName
AS
-- Query goes here
```

You can put aliased, literal values into a query on-the-fly:

```SQL
SELECT
    CustomerID,
    'Customer' AS ContactType
FROM Customers;    
```

`UNION` combines the results of multiple `SELECT` statements:

```SQL
SELECT * FROM Customers
UNION
SELECT * FROM Employees;
```

To use `UNION`, the columns of both queries need to match in terms of data type, number of columns, and sequence.

See all the Views in a database: 

```SQL
SELECT * FROM sys.objects
WHERE type_desc = 'VIEW';
```

See all the schemas in a database: 

```SQL
SELECT * FROM sys.schemas;
```

`sp_helptext` is a built-in stored procedure that lets you display all of the contents of a multi-line database object

```SQL
EXEC sp_helptext 'SomeSchema.SomeView';
```

The above query will print out the contents of the View (the actual SQL), line by line. This allows you to not have all of the content of the query crammed into a single cell in the output. 

`sp_rename` is a built-in stored procedure that allows you to rename tables, indexes, columns, etc.

Example of using `sp_rename` to rename a column:

```SQL
EXEC sp_rename 'SomeSchema.SomeTable.SomeColumn', 'NewColumnName', 'COLUMN';
```

* When you rename database objects you will often get a warning like `Caution: Changing any part of an object name could break scripts and stored procedures.` 
* Renaming objects can also break Views that reference the old name. 
* When you get an error like `Could not use view or function 'WideWorldImporters.Sales.OutstandingBalance' because of binding errors.` that happens because there's been a rename that has broken the view or function.

_Schema binding_ - you can lock down object changes until the dependant objects are either altered or dropped first. In other words, schema binding is a forcing function that forces users to notice when there's a dependency. Ex: A View with `SCHEMABINDING` turned on will force you to drop or alter the View before editing the Table upon which the View depends. 

How to apply schema binding to a brand new View:

```SQL
CREATE VIEW MySchema.MyView
WITH SCHEMABINDING
AS
-- Complex query goes here
```

How to apply schema binding to an existing View:

```SQL
ALTER VIEW MySchema.MyView
WITH SCHEMABINDING
AS
-- Complex query goes here
```

If you try to change an object that is schema-bound, you'll get an error like...

```
Object 'Sales.CustomerTransactions.PreTaxTotal' cannot be renamed because the object participates in enforced dependencies.
```

Use this query to find which objects are using schema binding:

```SQL
SELECT 
    dm_sql_referencing_entities.referencing_schema_name,
    dm_sql_referencing_entities.referencing_entity_name,
    sql_modules.object_id,
    sql_modules.definition,
    sql_modules.is_schema_bound
FROM sys.dm_sql_referencing_entities ('SomeSchema.SomeObject', 'OBJECT')
JOIN sys.sql_modules
ON dm_sql_referencing_entities.referencing_id = sql_modules.object_id;
```

Drop a View:

```SQL
DROP VIEW SomeSchema.SomeView;
```

_Normalized_ - information is split across multiple tables with keys that connect the tables together

_Deterministic_ - something is deterministic if it always has the same outputs given the same set of inputs

_Non-deterministic_ - different outputs occur, even when inputs are held constant. (ex: random function)

**Indexed Views**

* a.k.a. _"Materialized View"_
* You'd index a View for the same reason you'd index a table - the performance of complex queries could become expensive if not indexed.
* Must be deterministic to be an indexed View.
* Limitations
    * Can't use aggregate functions
    * Can't use outer joins
    * Can't use columns with float/real type
    * and more 

Add an index to a View:

```SQL
CREATE UNIQUE CLUSTERED INDEX IX_SomeView
ON SomeSchema.SomeView 
(SomeID, SomeColumn, SomeColumn);
```

## Ch. 2 Create User-Defined Functions

`GETDATE()` returns a fully qualified timestamp of now

```SQL
SELECT GETDATE() AS 'Now';
-- 2024-12-23 18:27:00.850
```

`RAND()` generates a random number between 0 and 1

```SQL
SELECT RAND() AS 'Random Number';
-- 0.585513872220982
```

`FORMAT` allows you to apply string formatting to datetimes

```SQL
SELECT 
    FORMAT(GETDATE(), 'd');
-- 12/23/2024
```

[MS Docs: What are the SQL database functions?](https://learn.microsoft.com/en-us/sql/t-sql/functions/functions?view=sql-server-ver16)

* Deterministic
    * `AVG`
    * `MIN`
    * `MAX`
* Non-deterministic
    * `GETDATE`
    * `RAND`
    * `FORMAT` (culturally dependent)

> You can't index a View if it contains non-deterministic functions.

---
End of document
