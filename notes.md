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

In order to run `CREATE VIEW` queries, your user needs the following permissions:

1. Creating views 
2. Altering the schema

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

The above query will print out the SQL contents of the View (the SQL), line by line. This allows you to not have all of the content of the query crammed into a single cell in the output. 

[`sp_rename`](https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-rename-transact-sql?view=sql-server-ver16) is a built-in stored procedure that allows you to rename tables, indexes, columns, etc.

Example of using `sp_rename` to rename a column:

```SQL
EXEC sp_rename 'SomeSchema.SomeTable.SomeColumn', 'NewColumnName', 'COLUMN';
```

* When you rename database objects you will often get a warning like `Caution: Changing any part of an object name could break scripts and stored procedures.` 
* It can also break Views that reference the old name. 
* When you get an error like "Could not use view or function `WideWorldImporters.Sales.OutstandingBalance' because of binding errors.` that happen because there's been a rename that has broken the view or function.

_Schema binding_ - you can lock down object changes until the dependant objects are either altered or dropped first. In other words, a forcing function that forces users to notice when there's a dependency. Ex: A View with `SCHEMABINDING` turned on will force you to drop or alter the View before editing the Table upon which the View depends. 

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

Use this query to find which objects are dependent:

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

---
End of document
