--*************************************************************************--
-- Title: Assignment05
-- Author: IMartinez
-- Desc: This file demonstrates how to process data in a database
-- Change Log: When,Who,What
-- 2020-05-05,IMartinez,Created File
--**************************************************************************--
-- Step 1: Create the assignment database
Use Master;
go

If Exists(Select Name from SysDatabases Where Name = 'Assignment05DB_IMartinez')
 Begin 
  Alter Database [Assignment05DB_IMartinez] set Single_user With Rollback Immediate;
  Drop Database Assignment05DB_IMartinez;
 End
go

Create Database Assignment05DB_IMartinez;
go

Use Assignment05DB_IMartinez;
go

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Alter Table Categories 
 Add Constraint pkCategories 
  Primary Key (CategoryId);
go

Alter Table Categories 
 Add Constraint ukCategories 
  Unique (CategoryName);
go

Alter Table Products 
 Add Constraint pkProducts 
  Primary Key (ProductId);
go

Alter Table Products 
 Add Constraint ukProducts 
  Unique (ProductName);
go

Alter Table Products 
 Add Constraint fkProductsToCategories 
  Foreign Key (CategoryId) References Categories(CategoryId);
go

Alter Table Products 
 Add Constraint ckProductUnitPriceZeroOrHigher 
  Check (UnitPrice >= 0);
go

Alter Table Inventories 
 Add Constraint pkInventories 
  Primary Key (InventoryId);
go

Alter Table Inventories
 Add Constraint dfInventoryDate
  Default GetDate() For InventoryDate;
go

Alter Table Inventories
 Add Constraint fkInventoriesToProducts
  Foreign Key (ProductId) References Products(ProductId);
go

Alter Table Inventories 
 Add Constraint ckInventoryCountZeroOrHigher 
  Check ([Count] >= 0);
go



-- Show the Current data in the Categories, Products, and Inventories Tables
-- Step 2: Add some starter data to the database

/* Add the following data to this database using inserts:
Category	Product	Price	Date		Count
Beverages	Chai	18.00	2017-01-01	61
Beverages	Chang	19.00	2017-01-01	17

Beverages	Chai	18.00	2017-02-01	13
Beverages	Chang	19.00	2017-02-01	12

Beverages	Chai	18.00	2017-03-02	18
Beverages	Chang	19.00	2017-03-02	12
*/

insert into Categories (CategoryName) values ('Beverages');
insert into Products (ProductName, UnitPrice) values ('Chai', '18.00');
insert into Products (ProductName, UnitPrice) values ('Chang', '19.00');
insert into Inventories (InventoryDate, ProductID, [Count]) values ('2017-01-01', 1, 61);
insert into Inventories (InventoryDate, ProductID, [Count]) values ('2017-01-01', 2, 17);
insert into Inventories (InventoryDate, ProductID, [Count]) values ('2017-02-01', 1, 13);
insert into Inventories (InventoryDate, ProductID, [Count]) values ('2017-02-01', 2, 12);
insert into Inventories (InventoryDate, ProductID, [Count]) values ('2017-03-02', 1, 18);
insert into Inventories (InventoryDate, ProductID, [Count]) values ('2017-03-02', 2, 12);



-- Step 3: Create transactional stored procedures for each table using the proviced template:
-- INSERTS --
Create Procedure pInsCategories
(@CategoryName nvarchar(100))
/* Author: IMartinez
** Desc: Processes Inserts for Categories table
** Change Log: When,Who,What
** 2020-05-05,IMartinez,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
	Insert Into Categories (CategoryName) Values(@CategoryName);
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go

Create Procedure pInsProducts
(@ProductName nvarchar(100), @CategoryID int, @UnitPrice Money)
/* Author: IMartinez
** Desc: Processes Inserts for Products table
** Change Log: When,Who,What
** 2020-05-05,IMartinez,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
	Insert Into Products(ProductName, CategoryID, UnitPrice)
	Values (@ProductName, @CategoryID, @UnitPrice);
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go

Create Procedure pInsInventories
(@InventoryDate date, @ProductID int, @Count int)
/* Author: IMartinez
** Desc: Processes Inserts for Inventories table
** Change Log: When,Who,What
** 2020-05-05,IMartinez,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
	Insert Into Inventories(InventoryDate, ProductID, [Count])
	Values (@InventoryDate, @ProductID, @Count);
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go


-- UPDATES --
Create Procedure pUpdCategories
(@CategoryID int, @CategoryName nvarchar(100))
/* Author: IMartinez
** Desc: Processes updates for Categories table
** Change Log: When,Who,What
** 2020-05-05,IMartinez,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
	Update Categories Set CategoryName = @CategoryName Where CategoryID = @CategoryID
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go

Create Procedure pUpdProducts
(@ProductID int, @ProductName nvarchar(100), @CategoryID int, @UnitPrice Money)
/* Author: IMartinez
** Desc: Processes updates for Products table
** Change Log: When,Who,What
** 2020-05-05,IMartinez,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
	Update Products 
	 Set ProductName = @ProductName
	    ,CategoryID = @CategoryID
		,UnitPrice = @UnitPrice
	 Where ProductID = @ProductID;
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go

Create Procedure pUpdInventories
(@InventoryID int, @InventoryDate date, @ProductID int, @Count int)
/* Author: IMartinez
** Desc: Processes updates for Inventories table
** Change Log: When,Who,What
** 2020-05-05,IMartinez,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
	Update Inventories 
	 Set InventoryDate = @InventoryDate
		,ProductID = @ProductID
		,[Count] = @Count
	 Where InventoryID = @InventoryID;
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go


-- DELETES --
Create Procedure pDelCategories
(@CategoryID int)
/* Author: IMartinez
** Desc: Processes Deletes for Categories table
** Change Log: When,Who,What
** 2020-05-05,IMartinez,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
	Delete From Categories Where CategoryID = @CategoryID
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go

Create Procedure pDelProducts
(@ProductID int)
/* Author: IMartinez
** Desc: Processes Deletes for Products table
** Change Log: When,Who,What
** 2020-05-05,IMartinez,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
	Delete From Products 
	Where ProductID = @ProductID
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go

Create Procedure pDelInventories
(@InventoryID int)
/* Author: IMartinez
** Desc: Processes Deletes for Inventories table
** Change Log: When,Who,What
** 2020-05-05,IMartinez,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
	Delete From Inventories 
	Where InventoryID = @InventoryID
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go



-- Step 4: Create code to test each transactional stored procedure. 
-- INSERTS --
Declare @Status int;
Exec @Status = pInsCategories @CategoryName = 'Cat1';
Print @Status; -- Adds Cat1 to CategoryName
Select * From Categories;

Declare @Status int;
Exec @Status = pInsProducts @ProductName = 'ProdA', @CategoryID = '2', @UnitPrice = 9.99;
Print @Status; -- Adds ProdA to as a product
Select * From Products;

Declare @Status int;
Exec @Status = pInsInventories @InventoryDate = '2017-04-01', @ProductID = '5', @Count = '15';
Print @Status; -- Adds InventoryID 7
Select * From Inventories;


-- UPDATES --
Declare @Status int;
Exec @Status = pUpdCategories @CategoryID = 2, @CategoryName = 'Cat1a';
Print @Status; -- Updates Cat1 to Cat1a in CategoryName.
Select * From Categories;

Declare @Status int;
Exec @Status = pUpdProducts @ProductID = 5, @ProductName = 'ProdAB', @CategoryID = '1', @UnitPrice = 19.99;
Print @Status; -- Updates ProdA to ProdAB in ProductName.
Select * From Products;

Declare @Status int;
Exec @Status = pUpdInventories @InventoryID = 7, @InventoryDate = '2017-04-01', @ProductID = '5', @Count = '10';
Print @Status; -- Updates InventoryID 7 row from 15 to 10 in Count.
Select * From Inventories;


-- DELETES --
Declare @Status int;
Exec @Status = pDelCategories @CategoryID = 3;
Print @Status; -- Deletes CategoryID 2 row.
Select * from Categories;

Declare @Status int;
Exec @Status = pDelProducts @ProductID = '5';
Print @Status; -- Deletes ProductID 5 row.
Select * from Products;

Declare @Status int;
Exec @Status = pDelInventories @InventoryID = 7;
Print @Status; -- Deletes ProductID 5 row.
Select * from Inventories;
go
