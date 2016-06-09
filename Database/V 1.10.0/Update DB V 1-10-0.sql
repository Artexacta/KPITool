/* 
	Updates de the KPIDB database to version 1.10.0 
*/

Use [Master]
GO 

IF  NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'KPIDB')
	RAISERROR('KPIDB database Doesn´t exists. Create the database first',16,127)
GO

PRINT 'Updating KPIDB database to version 1.10.0'

Use [KPIDB]
GO
PRINT 'Verifying database version'

/*
 * Verify that we are using the right database version
 */

IF  NOT ((EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetVersionMajor]') AND type in (N'P', N'PC'))) 
	AND 
	(EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetVersionMinor]') AND type in (N'P', N'PC'))))
		RAISERROR('KPIDB database has not been initialized.  Cant find version stored procedures',16,127)


declare @smiMajor smallint 
declare @smiMinor smallint

exec [dbo].[usp_GetVersionMajor] @smiMajor output
exec [dbo].[usp_GetVersionMinor] @smiMinor output

IF NOT (@smiMajor = 1 AND @smiMinor = 9) 
BEGIN
	RAISERROR('KPIDB database is not in version 1.9 This program only applies to version 1.9',16,127)
	RETURN;
END

PRINT 'KPIDB Database version OK'
GO

USE [KPIDB]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_DeleteAllKPITarget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_DeleteAllKPITarget]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Gabriela Sanchez 
-- Create date: May 23, 2016
-- Description:	Delete all targets from KPI
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_DeleteAllKPITarget]
	@kpiID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE FROM [dbo].[tbl_KPITargetCategories]
	WHERE [targetID] IN (SELECT [targetID] FROM [dbo].[tbl_KPITarget]
	                     WHERE [kpiID] = @kpiID)
	
	DELETE FROM [dbo].[tbl_KPITarget]
	WHERE [kpiID] = @kpiID
	
END
GO

--===========================================================================================

/****** Object:  StoredProcedure [dbo].[usp_KPI_AddDeleteCategoryTargetByKpi]    Script Date: 05/31/2016 14:07:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_AddDeleteCategoryTargetByKpi]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_AddDeleteCategoryTargetByKpi]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_AddDeleteCategoryTargetByKpi]    Script Date: 05/31/2016 14:07:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: 30/05/2016
-- Description:	Add or Delete a category for a KPI Target
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_AddDeleteCategoryTargetByKpi]
	@kpiID INT,
	@newCategoryID VARCHAR(20),
	@operation INT --1: Insert 2: Delete
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @tblCategories AS TABLE
	(categoryId VARCHAR(20))

	DECLARE @tblProducto AS TABLE
	(number INT,
	 productoId VARCHAR(1000),
	 categoriesId VARCHAR(1000))
	
	DECLARE @categoryId VARCHAR(20)
	DECLARE @count INT = 1
	
	--Create the table with all the categories of KPI
	INSERT @tblCategories
	SELECT DISTINCT [categoryID]
	  FROM [dbo].[tbl_KPITargetCategories] [c]
	  INNER JOIN [dbo].[tbl_KPITarget] [t] ON [c].[targetID] = [t].[targetID]
	 WHERE [t].[kpiID] = @kpiID

	IF (@operation = 1)
		INSERT @tblCategories VALUES (@newCategoryID)
	IF (@operation = 2)
		DELETE @tblCategories WHERE categoryId = @newCategoryID

	DECLARE @productoId VARCHAR(1000)
	DECLARE @categoriesId VARCHAR(1000)
	DECLARE @targetID INT
	
	CREATE TABLE #tbl_Items 
	(itemId INT IDENTITY,
	 itemText VARCHAR(20))
	 
	CREATE TABLE #tbl_CategoryItems 
	(categoryId INT IDENTITY,
	 categoryText VARCHAR(20))

	-- We detect if the SP was called from an active transation and 
	-- we save it to use it later.  In the SP, @TranCounter = 0
	-- means that there are no active transations and that this SP
	-- started one. @TranCounter > 0 means that a transation was started
	-- before we started this SP
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0
		-- We called this SP when an active transaction already exists.
		-- We create a savepoint to be able to only roll back this 
		-- transaction if there is some error.
		-- ===============================================
		---  MAKE SURE THAT THIS NAME IS COPIED BELOW 
		---  AND IS UNIQUE IN THE SYSTEM!!!!!!
		-- ===============================================
		SAVE TRANSACTION AddDeleteCategoryTarget;     
	ELSE
		-- This SP starts its own transaction and there was no previous transaction
		BEGIN TRANSACTION;

	BEGIN TRY
		
		--Create in @tblProducto all categoryItems combinations
		DECLARE category_cursor CURSOR FOR 
			SELECT DISTINCT c.categoryId 
			FROM @tblCategories c
			INNER JOIN [dbo].[tbl_CategoryItem] [i]
			ON [c].[categoryId] = [i].[categoryID]
		OPEN category_cursor

		FETCH NEXT FROM category_cursor
		INTO @categoryId

		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF EXISTS(SELECT 1 FROM @tblProducto)
				INSERT @tblProducto
				SELECT @count, [productoId] + ',' + [b].[categoryItemID], [a].[categoriesId] + ',' + [b].[categoryID]
				  FROM @tblProducto [a], [dbo].[tbl_CategoryItem] [b]
				 WHERE [b].[categoryID] = @categoryId
			ELSE
				INSERT @tblProducto
				SELECT @count, [b].[categoryItemID], [b].[categoryID]
				  FROM [dbo].[tbl_CategoryItem] [b]
				 WHERE [b].[categoryID] = @categoryId
						
			DELETE FROM @tblProducto WHERE number = @count - 1
			
			SET @count = @count + 1
			
			FETCH NEXT FROM category_cursor
			INTO @categoryId
		END

		CLOSE category_cursor;
		DEALLOCATE category_cursor;

		--With the combinatios of items, insert into database
		--First clean all the target in the database
		DELETE FROM dbo.tbl_KPITargetCategories
		WHERE targetID IN (SELECT targetID FROM dbo.tbl_KPITarget WHERE kpiID = @kpiID)
		
		DELETE FROM dbo.tbl_KPITarget WHERE kpiID = @kpiID
		
		--Second insert all in database as a new target without value (0)
		DECLARE producto_cursor CURSOR FOR 
			SELECT productoId, categoriesId
			FROM @tblProducto
		OPEN producto_cursor

		FETCH NEXT FROM producto_cursor
		INTO @productoId, @categoriesId

		WHILE @@FETCH_STATUS = 0
		BEGIN
			--INICIALIZAR LAS TABLAS TEMPORALES
			DELETE FROM #tbl_Items
			DELETE FROM #tbl_CategoryItems
			
			DBCC CHECKIDENT (#tbl_Items, RESEED, 0)
			DBCC CHECKIDENT (#tbl_CategoryItems, RESEED, 0)
			
			INSERT #tbl_Items
			SELECT splitvalue
			FROM dbo.tvf_SplitStringInVarCharTable(@productoId,',')
			
			INSERT #tbl_CategoryItems
			SELECT splitvalue
			FROM dbo.tvf_SplitStringInVarCharTable(@categoriesId,',')
			
			INSERT INTO [dbo].[tbl_KPITarget] ([kpiID],[target]) VALUES (@kpiID, 0)

			SET @targetID = @@IDENTITY
			
			INSERT INTO [dbo].[tbl_KPITargetCategories]
			   ([targetID],[categoryItemID],[categoryID])
			SELECT @targetID, itemText, categoryText
			FROM #tbl_Items a, #tbl_CategoryItems b
			WHERE a.itemId = b.categoryId

			FETCH NEXT FROM producto_cursor
			INTO @productoId, @categoriesId
		END

		CLOSE producto_cursor;
		DEALLOCATE producto_cursor;
		
		DROP TABLE #tbl_Items 
		DROP TABLE #tbl_CategoryItems 

		-- We arrived here without errors; we should commit the transation we started
		-- but we should not commit if there was a previous transaction started
		IF @TranCounter = 0
			-- @TranCounter = 0 means that no other transaction was started before this transaction 
			-- and that we shouold hence commit this transaction
			COMMIT TRANSACTION;
		
	END TRY
	BEGIN CATCH

		-- There was an error.  We need to determine what type of rollback we must perform

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		IF @TranCounter = 0
			-- We have only the transaction that we started in this SP.  Rollback
			-- all the tranaction.
			ROLLBACK TRANSACTION;
		ELSE
			-- A transaction was started before this SP was called.  We must
			-- rollback only the changes we made in this SP.

			-- We see XACT_STATE and the possible results are 0, 1, or -1.
			-- If it is 1, the transaction is valid and we can do a commit. But since we are in the 
			-- CATCH we don't do the commit. We need to rollback to the savepoint
			-- If it is -1 the transaction is not valid and we must do a full rollback... we can't
			-- do a rollback to a savepoint
			-- XACT_STATE = 0 means that there is no transaciton and a rollback would cause an error
			-- See http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() = 1
				-- If the transaction is still valid then we rollback to the restore point defined before
				-- ===============================================
				---  MAKE SURE THAT THIS NAME IS EXACTLY AS ABOVE 
				-- ===============================================
				ROLLBACK TRANSACTION AddDeleteCategoryTarget;

				-- If the transaction is not valid we cannot do a commit or a rollback to a savepoint
				-- because a rollback is not allowed. Hence, we must simply return to the caller and 
				-- they will be respnsible to rollback the transaction

				-- If there is no tranaction then there is nothing left to do

		-- After doing the correpsonding rollback, we must propagate the error information to the SP that called us 
		-- See http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

		-- The database can return values from 0 to 256 but raise error
		-- will only allow us to use values from 1 to 127
		IF(@ErrorState < 1 OR @ErrorState > 127)
			SELECT @ErrorState = 1
			
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH
	
END

GO


/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPITargetCategoriesByKpiId]    Script Date: 05/31/2016 14:07:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKPITargetCategoriesByKpiId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKPITargetCategoriesByKpiId]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: 30/05/2016
-- Description:	Obtener las categorias con target de un KPI
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKPITargetCategoriesByKpiId]
	@kpiID INT
AS
BEGIN
	
	SET NOCOUNT ON;

    DECLARE @tblData AS TABLE
	(targetID INT,
	 detalle VARCHAR(1000),
	 categories VARCHAR(1000),
	 [target] DECIMAL(21,9))

	DECLARE @targetID INT
	DECLARE @detalle VARCHAR(1000)
	DECLARE @categories VARCHAR(1000)
	DECLARE @valor DECIMAL(21,9)

	DECLARE target_cursor CURSOR FOR 
		SELECT DISTINCT [t].[targetID], [t].[target]
		FROM [dbo].[tbl_KPITarget] [t]
		INNER JOIN [dbo].[tbl_KPITargetCategories] [c] ON [t].[targetID] = [c].[targetID]
		WHERE [kpiID] = @kpiID
	OPEN target_cursor

	FETCH NEXT FROM target_cursor
	INTO @targetID, @valor

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		SELECT @detalle = COALESCE(COALESCE(CASE WHEN @detalle = '' THEN '' ELSE @detalle + ', ' END, '') + [i].[categoryItemID], @detalle),
		       @categories = COALESCE(COALESCE(CASE WHEN @categories = '' THEN '' ELSE @categories + ', ' END, '') + [i].[categoryID], @categories)
		FROM [dbo].[tbl_KPITargetCategories] [c]
		INNER JOIN [dbo].[tbl_CategoryItem] [i] ON [c].[categoryItemID] = [i].[categoryItemID] 
		AND [c].[categoryID] = [i].[categoryID] 
		WHERE [targetID] = @targetID 
		ORDER BY [i].[categoryItemID]

		INSERT @tblData VALUES (@targetID, @detalle, @categories, @valor)
		
		SET @detalle = ''
		
		FETCH NEXT FROM target_cursor
		INTO @targetID, @valor
	END

	CLOSE target_cursor;
	DEALLOCATE target_cursor;

	SELECT [targetID]
		  ,@kpiID [kpiID]
		  ,[target]
		  ,[detalle]
		  ,[categories]
	FROM @tblData
	
END
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CATEGORY_GetCategoryByKpi]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_CATEGORY_GetCategoryByKpi] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: 31/05/2016
-- Description:	Get category KPI
-- =============================================
CREATE PROCEDURE [dbo].[usp_CATEGORY_GetCategoryByKpi] 
	@kpiId AS INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT DISTINCT [c].[categoryID],[c].[name]
	  FROM [dbo].[tbl_KPITargetCategories] [t]
	 INNER JOIN [dbo].[tbl_Category] [c] ON [t].[categoryID] = [c].[categoryID]
	  WHERE [targetID] IN (SELECT [targetID] FROM [dbo].[tbl_KPITarget] WHERE [kpiID] = @kpiId)

END
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKPITargetTimeByTargetId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKPITargetTimeByTargetId]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: 24/05/2016
-- Description:	Get KPI Target Time By TargetId
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKPITargetTimeByTargetId]
	@targetID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @valor AS DECIMAL(21,9)

	SELECT @valor = [target]
	FROM [dbo].[tbl_KPITarget]
	WHERE [targetID] = @targetID
	
	DECLARE @year INT
	DECLARE @month INT
	DECLARE @day INT
	DECLARE @hour INT
	DECLARE @minute INT

	DECLARE @fechaBase AS DATETIME
	DECLARE @fechaObtenida DATETIME
	
	SET @fechaBase = '1900-01-01'	
	SET @fechaObtenida = CAST(@valor AS DATETIME)
	--REDONDEO AL SEGUNDO
	SET @fechaObtenida = dateadd(second, round(datepart(second,@fechaObtenida)*2,-1) / 2-datepart(second,@fechaObtenida), @fechaObtenida)

	SET @year = DATEDIFF(YY,@fechaBase,@fechaObtenida)
	SET @fechaObtenida = DATEADD(YY,-@year,@fechaObtenida)

	SET @month = DATEDIFF(MM,@fechaBase,@fechaObtenida) 
	SET @fechaObtenida = DATEADD(MM,-@month,@fechaObtenida)

	SET @day = DATEDIFF(DD,@fechaBase,@fechaObtenida) 
	SET @fechaObtenida = DATEADD(DD,-@day,@fechaObtenida)

	SET @hour = DATEDIFF(HH,@fechaBase,@fechaObtenida) 
	SET @fechaObtenida = DATEADD(HH,-@hour,@fechaObtenida)

	SET @minute = DATEDIFF(MINUTE,@fechaBase,@fechaObtenida) 

	SELECT 0 as kpiID,
	       @targetID as targetID,
	       @year as [year],
	       @month as [month],
	       @day as [day],
	       @hour as [hour],
	       @minute as [minute]

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetCombinationCategoryItems]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetCombinationCategoryItems]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: 30/05/2016
-- Description:	Get combination of items by categoy list
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetCombinationCategoryItems]
	@categoryList VARCHAR(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @tblCategories AS TABLE
	(categoryId VARCHAR(20))

	INSERT @tblCategories
	SELECT * FROM [dbo].[tvf_SplitStringInTable] (@categoryList, ',')

	DECLARE @tblProducto AS TABLE
	(number INT,
	 productoId VARCHAR(1000),
	 categoriesId VARCHAR(1000))
	
	DECLARE @categoryId VARCHAR(20)
	DECLARE @productoId VARCHAR(1000)
	DECLARE @count INT = 1
	
			
	--Create in @tblProducto all categoryItems combinations
	DECLARE category_cursor CURSOR FOR 
		SELECT DISTINCT c.categoryId 
		FROM @tblCategories c
		INNER JOIN [dbo].[tbl_CategoryItem] [i]
		ON [c].[categoryId] = [i].[categoryID]
	OPEN category_cursor

	FETCH NEXT FROM category_cursor
	INTO @categoryId

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF EXISTS(SELECT 1 FROM @tblProducto)
			INSERT @tblProducto
			SELECT @count, [productoId] + ',' + [b].[categoryItemID], [a].[categoriesId] + ',' + [b].[categoryID]
			  FROM @tblProducto [a], [dbo].[tbl_CategoryItem] [b]
			 WHERE [b].[categoryID] = @categoryId
		ELSE
			INSERT @tblProducto
			SELECT @count, [b].[categoryItemID], [b].[categoryID]
			  FROM [dbo].[tbl_CategoryItem] [b]
			 WHERE [b].[categoryID] = @categoryId
					
		DELETE FROM @tblProducto WHERE number = @count - 1
		
		SET @count = @count + 1
		
		FETCH NEXT FROM category_cursor
		INTO @categoryId
	END

	CLOSE category_cursor;
	DEALLOCATE category_cursor;

	SELECT productoId, categoriesId
	FROM @tblProducto
	
	
END
GO

--===============================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_UpdateKPITargetCategory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_UpdateKPITargetCategory]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: 01/06/2016
-- Description:	Update KPI Target Category
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_UpdateKPITargetCategory]
	@kpiId INT,
	@targetID INT,
	@items VARCHAR(1000),
	@categories VARCHAR(1000),
	@target DECIMAL(21,9)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (@categories IS NULL)
		SET @categories = ''

    CREATE TABLE #tbl_Items 
	(itemId INT IDENTITY,
	 itemText VARCHAR(20))
	 
	CREATE TABLE #tbl_CategoryItems 
	(categoryId INT IDENTITY,
	 categoryText VARCHAR(20))
	 
	IF (@targetID > 0)
	BEGIN 
		UPDATE [dbo].[tbl_KPITarget]
		SET [target] = @target
		WHERE [targetID] = @targetID
		AND   [kpiID] = @kpiId
	END
	ELSE
	BEGIN
		DECLARE @newTargetID INT
		
		INSERT INTO [dbo].[tbl_KPITarget]
			   ([kpiID]
			   ,[target])
		 VALUES
			   (@kpiId
			   ,@target)
	           
		SET @newTargetID = @@IDENTITY

		INSERT #tbl_Items
		SELECT splitvalue
		FROM dbo.tvf_SplitStringInVarCharTable(@items,',')
		
		INSERT #tbl_CategoryItems
		SELECT splitvalue
		FROM dbo.tvf_SplitStringInVarCharTable(@categories,',')
		
		INSERT INTO [dbo].[tbl_KPITargetCategories]
		   ([targetID],[categoryItemID],[categoryID])
		SELECT @newTargetID, itemText, categoryText
		FROM #tbl_Items a, #tbl_CategoryItems b
		WHERE a.itemId = b.categoryId

	END	

	DROP TABLE #tbl_Items
	DROP TABLE #tbl_CategoryItems

END
GO

--=============================================================================

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIListForUser]    Script Date: 06/02/2016 10:20:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ORG_GetOrganizationListForUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ORG_GetOrganizationListForUser]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIListForUser]    Script Date: 06/02/2016 10:20:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================================
-- Author:		Gabriela Sanchez V.
-- Create date: Jun 2 2016
-- Description:	Get List of Organizations that user has view rights to
-- =============================================================
CREATE PROCEDURE [dbo].[usp_ORG_GetOrganizationListForUser]
	-- Add the parameters for the stored procedure here
	@userName varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--- Get list of KPIS where user has acccess.  In the sourceObjectType
	-- column we will record where we got this from, and the objectID will
	-- tell us the ID of the object where this KPI came from.
	DECLARE @orgList as TABLE(organizationID int, sourceObjectType varchar(100), objectID int)

	-- For the following description ORG = ORGANIZATION, ACT = ACTIVITY, PPL = PEOPLE, PROF = PROJECT. 
	--If we need to determine the list of KPIs that a specific user can see 
	--we need to follow the following steps:
	--
	--1. Search for all ORGs where the user has OWN permissions and add to the list 
	--   of organizations to those ORGs.
	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of ORGs all of these that are directly associated 
	--   to the organization
	--3. Search for all ORGs where the user has MAN_PROJECT permissions or ORG has public 
	--   MAN_PROJECT, then search for all PROJs then add to the ORG list all of the ORGs 
	--   that are associated to these PROJs.
	--4. Search for all ORGs where the user has MAN_ACTITIVIES permissions or ORG has public 
	--   MAN_ACTITIVIES and search for ACT that are associated to these ORGs and ARE NOT 
	--   associated to any PROJ, then add to the ORG list all of the ORGs that are 
	--   associated to these ACT.
	--5. Search for all ORGs where the user has MAN_PEOPLE permissions or where the ORG has 
	--   public MAN_PEOPLE, then search for all of the PPL that are associated to those 
	--   ORGs and finally add to the ORG list all of the ORGs that are associated to those 
	--   PPL.
	--6. Search for all ACT where the user has OWN or MAN_KPI permissions or the ACT is public 
	--   MAN_KPI and add to the ORG list all of the ORGs that are associated to the ACT.
	--7. Search for all PROJ where the user has OWN or MAN_KPI permissions, or where the PROJ 
	--   is public MAN_KPI and add to the ORG list all of the ORGs that are associated to those
	--   PROJ.
	--8. Search for all PROJ where the user has MAN_ACTIVITIES permissions or where the PROJ is 
	--   public MAN_ACTIVITIES, then search for all of the ACT that are associated to these 
	--   PROJs and finally add to the ORG list the ORGs that are associated to these ACT.
	--9. Search for all PPL where the user has OWN or MAN_KPI permissions or where the PPL is 
	--    public MAN_KPI and add to the ORG list all of the ORGs that are associated to these PPL.
	--10. Add to the ORG list all of the KPIs that are public VIEW_KPI
	--11.	Add to the ORG list all of the ORGs where the user has OWN or VIEW_KPI or ENTER_DATA
	--      permissions.
	--
	--At the end of this, we should have a list of all of the ORGs that the user can see.

	-- So lets start with step 1.
 
	--1. Search for all ORGs where the user has OWN permissions and add to the list 
	--   of organizations to those ORGs.

	insert into @orgList
	select [organizationID], 'ORG OWN (1)', [organizationID] 
	from [dbo].[tbl_Organization]
	where [organizationID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'ORGANIZATION' and objectActionID = 'OWN'
			and username = @userName
	)

	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of ORGs all of these that are directly associated 
	--   to the organization

	insert into @orgList
	select [organizationID], 'ORG MAN_ORG (2)', [organizationID] 
	from [dbo].[tbl_Organization]
	where [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI'
	) 

	--3. Search for all ORGs where the user has MAN_PROJECT permissions or ORG has public 
	--   MAN_PROJECT, then search for all PROJs then add to the ORG list all of the ORGs 
	--   that are associated to these PROJs.

	insert into @orgList
	select [organizationID], 'ORG MAN_PROJECT (3)', [organizationID] 
	from [dbo].[tbl_Project]
	where [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PROJECT' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PROJECT'
	) 

	--4. Search for all ORGs where the user has MAN_ACTITIVIES permissions or ORG has public 
	--   MAN_ACTITIVIES and search for ACT that are associated to these ORGs and ARE NOT 
	--   associated to any PROJ, then add to the ORG list all of the ORGs that are 
	--   associated to these ACT.
	
	insert into @orgList
	select [organizationID], 'ORG MAN_ACTIVITY (4)', [organizationID] 
	from [dbo].[tbl_Activity]
	where [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_ACTIVITY' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_ACTIVITY'
	)  and [projectID] is null

	--5. Search for all ORGs where the user has MAN_PEOPLE permissions or where the ORG has 
	--   public MAN_PEOPLE, then search for all of the PPL that are associated to those 
	--   ORGs and finally add to the ORG list all of the ORGs that are associated to those 
	--   PPL.

	insert into @orgList
	select [organizationID], 'ORG MAN_PEOPLE (5)', [organizationID] 
	from [dbo].[tbl_People] 
	where [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PEOPLE' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PEOPLE'
	) 

	--6. Search for all ACT where the user has OWN or MAN_KPI permissions or the ACT is public 
	--   MAN_KPI and add to the ORG list all of the ORGs that are associated to the ACT.

	insert into @orgList
	select [organizationID], 'ACT OWN (6)', [activityID]
	from [dbo].[tbl_Activity]
	where[activityID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'ACTIVITY' and objectActionID = 'OWN' and username = @userName
	) 

	insert into @orgList
	select [organizationID], 'ACT-MAN_KPI (6)', [activityID] 
	FROM [dbo].[tbl_Activity]
	where[activityID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ACTIVITY' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ACTIVITY' and objectActionID = 'MAN_KPI'
	)

	--7. Search for all PROJ where the user has OWN or MAN_KPI permissions, or where the PROJ 
	--   is public MAN_KPI and add to the ORG list all of the ORGs that are associated to those
	--   PROJ.

	insert into @orgList
	select [organizationID], 'PROJ OWN (7)', [projectID] 
	from [dbo].[tbl_Project]
	where [projectID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'PROJECT' and objectActionID = 'OWN' and username = @userName
	)

	insert into @orgList
	select [organizationID], 'PROJ-MAN_KPI (7)', [projectID] 
	FROM [dbo].[tbl_Project]
	where [projectID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_KPI'
	)

	--8. Search for all PROJ where the user has MAN_ACTIVITIES permissions or where the PROJ is 
	--   public MAN_ACTIVITIES, then search for all of the ACT that are associated to these 
	--   PROJs and finally add to the ORG list the ORGs that are associated to these ACT.

	insert into @orgList
	select [organizationID], 'PROJ-MAN_ACTIVITY (8)', [projectID] 
	from [dbo].[tbl_Activity]
	where [projectID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_ACTIVITY' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_ACTIVITY'
	)

	--9. Search for all PPL where the user has OWN or MAN_KPI permissions or where the PPL is 
	--    public MAN_KPI and add to the ORG list all of the ORGs that are associated to these PPL.

	insert into @orgList
	select [organizationID], 'PPL OWN (9)', [personID]
	from [dbo].[tbl_People]
	where [personID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'PERSON' and objectActionID = 'OWN' and username = @userName
	)

	insert into @orgList
	select [organizationID], 'PPL-MAN_KPI (9)', [personID] 
	FROM [dbo].[tbl_People]
	where [personID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PERSON' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'PERSON' and objectActionID = 'MAN_KPI'
	)

	--10. Add to the ORG list all of the KPIs that are public VIEW_KPI

	insert into @orgList
	select [organizationID], 'KPI-PUB VIEW (10)', [kpiID] 
	FROM [dbo].[tbl_KPI]
	where [kpiID] in (
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI'
	)

	--11.	Add to the ORG list all of the ORGs where the user has OWN or VIEW_KPI or ENTER_DATA
	--      permissions.
	insert into @orgList
	select [organizationID], 'KPI-VIEW-OWN-ENTER (11)', [kpiID] 
	FROM [dbo].[tbl_KPI]
	where [kpiID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'OWN' AND username = @userName
		union
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'ENTER_DATA' AND username = @userName
		union
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI' AND username = @userName
	)

	select distinct organizationID from @orgList 


END
GO

--===================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PROJ_GetProjectListForUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PROJ_GetProjectListForUser]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================================
-- Author:		Gabriela Sanchez V.
-- Create date: Jun 2 2016
-- Description:	Get List of Projects that user has view rights to
-- =============================================================
CREATE PROCEDURE [dbo].[usp_PROJ_GetProjectListForUser]
	-- Add the parameters for the stored procedure here
	@userName varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--- Get list of KPIS where user has acccess.  In the sourceObjectType
	-- column we will record where we got this from, and the objectID will
	-- tell us the ID of the object where this KPI came from.
	DECLARE @projList as TABLE(projectID int, sourceObjectType varchar(100), objectID int)

	-- For the following description ORG = ORGANIZATION, ACT = ACTIVITY, PPL = PEOPLE, PROF = PROJECT. 
	--If we need to determine the list of KPIs that a specific user can see 
	--we need to follow the following steps:
	--
	--1. Search for all ORGs where the user has OWN permissions and add to the list 
	--   of PROJ the PROJs of this ORG.
	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of PROJs all of these that are directly associated 
	--   to the organization
	--3. Search for all ORGs where the user has MAN_PROJECT permissions or ORG has public 
	--   MAN_PROJECT, then search for all PROJs then add to the PROJ list all of the PROJs 
	--   that are associated to these ORGs.
	--4. Search for all ORGs where the user has MAN_ACTITIVIES permissions or ORG has public 
	--   MAN_ACTITIVIES and search for PROJ that are associated to these ORGs then add to the 
	--   PROJ list all of the PROJs.
	--5. Search for all ACT where the user has OWN or MAN_KPI permissions or the ACT is public 
	--   MAN_KPI and add to the PROJ list all of the PROJs that are associated to the ACT.
	--6. Search for all PROJ where the user has OWN or MAN_KPI permissions, or where the PROJ 
	--   is public MAN_KPI and add to the PROJ list all of the PROJ.
	--7. Search for all PROJ where the user has MAN_ACTIVITIES permissions or where the PROJ is 
	--   public MAN_ACTIVITIES, then search for all of the PROJs and finally add to the PROJ list.
	--8. Add to the PROJ list all of the PROJs that are public VIEW_KPI
	--9. Add to the PROJ list all of the PROJs where the user has OWN or VIEW_KPI or ENTER_DATA
	--   permissions.
	--
	--At the end of this, we should have a list of all of the ORGs that the user can see.

	-- So lets start with step 1.
 
	--1. Search for all ORGs where the user has OWN permissions and add to the list 
	--   of PROJ the PROJs of this ORG.

	insert into @projList
	select [projectID], 'ORG OWN (1)', [organizationID] 
	from [dbo].[tbl_Project]
	where [organizationID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'ORGANIZATION' and objectActionID = 'OWN'
			and username = @userName
	)

	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of PROJs all of these that are directly associated 
	--   to the organization

	insert into @projList
	select [projectID], 'ORG MAN_ORG (2)', [organizationID] 
	from [dbo].[tbl_Project]
	where [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI'
	) 

	--3. Search for all ORGs where the user has MAN_PROJECT permissions or ORG has public 
	--   MAN_PROJECT, then search for all PROJs then add to the PROJ list all of the PROJs 
	--   that are associated to these ORGs.

	insert into @projList
	select [projectID], 'ORG MAN_PROJECT (3)', [organizationID] 
	from [dbo].[tbl_Project]
	where [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PROJECT' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PROJECT'
	) 

	--4. Search for all ORGs where the user has MAN_ACTITIVIES permissions or ORG has public 
	--   MAN_ACTITIVIES and search for PROJ that are associated to these ORGs then add to the 
	--   PROJ list all of the PROJs.
	
	insert into @projList
	select [projectID], 'ORG MAN_ACTIVITY (4)', [organizationID] 
	from [dbo].[tbl_Project]
	where [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_ACTIVITY' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_ACTIVITY'
	)  

	--5. Search for all ACT where the user has OWN or MAN_KPI permissions or the ACT is public 
	--   MAN_KPI and add to the PROJ list all of the PROJs that are associated to the ACT.

	insert into @projList
	select [projectID], 'ACT OWN (5)', [activityID]
	from [dbo].[tbl_Activity]
	where[activityID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'ACTIVITY' and objectActionID = 'OWN' and username = @userName
	) 

	insert into @projList
	select [projectID], 'ACT-MAN_KPI (5)', [activityID] 
	FROM [dbo].[tbl_Activity]
	where[activityID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ACTIVITY' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ACTIVITY' and objectActionID = 'MAN_KPI'
	)

	--6. Search for all PROJ where the user has OWN or MAN_KPI permissions, or where the PROJ 
	--   is public MAN_KPI and add to the PROJ list all of the PROJ.

	insert into @projList
	select [projectID], 'PROJ OWN (6)', [projectID] 
	from [dbo].[tbl_Project]
	where [projectID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'PROJECT' and objectActionID = 'OWN' and username = @userName
	)

	insert into @projList
	select [projectID], 'PROJ-MAN_KPI (6)', [projectID] 
	FROM [dbo].[tbl_Project]
	where [projectID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_KPI'
	)

	--7. Search for all PROJ where the user has MAN_ACTIVITIES permissions or where the PROJ is 
	--   public MAN_ACTIVITIES, then search for all of the PROJs and finally add to the PROJ list.

	insert into @projList
	select [projectID], 'PROJ-MAN_ACTIVITY (7)', [projectID] 
	from [dbo].[tbl_Project]
	where [projectID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_ACTIVITY' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_ACTIVITY'
	)


	--8. Add to the PROJ list all of the PROJs that are public VIEW_KPI

	insert into @projList
	select [projectID], 'KPI-PUB VIEW (8)', [kpiID] 
	FROM [dbo].[tbl_KPI]
	where [kpiID] in (
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI'
	)

	--9.	Add to the PROJ list all of the PROJs where the user has OWN or VIEW_KPI or ENTER_DATA
	--      permissions.
	insert into @projList
	select [projectID], 'KPI-VIEW-OWN-ENTER (9)', [kpiID] 
	FROM [dbo].[tbl_KPI]
	where [kpiID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'OWN' AND username = @userName
		union
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'ENTER_DATA' AND username = @userName
		union
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI' AND username = @userName
	)

	select distinct [projectID] from @projList 


END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ACT_GetActivityListForUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ACT_GetActivityListForUser]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================================
-- Author:		Gabriela Sanchez V.
-- Create date: Jun 2 2016
-- Description:	Get List of Activities that user has view rights to
-- =============================================================
CREATE PROCEDURE [dbo].[usp_ACT_GetActivityListForUser]
	-- Add the parameters for the stored procedure here
	@userName varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--- Get list of KPIS where user has acccess.  In the sourceObjectType
	-- column we will record where we got this from, and the objectID will
	-- tell us the ID of the object where this KPI came from.
	DECLARE @actList as TABLE(activityID int, sourceObjectType varchar(100), objectID int)

	-- For the following description ORG = ORGANIZATION, ACT = ACTIVITY, PPL = PEOPLE, PROF = PROJECT. 
	--If we need to determine the list of KPIs that a specific user can see 
	--we need to follow the following steps:
	--
	--1. Search for all ORGs where the user has OWN permissions and add to the list 
	--   of ACT to those ORGs.
	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of ACTs all of these that are directly associated 
	--   to the organization
	--3. Search for all ORGs where the user has MAN_PROJECT permissions or ORG has public 
	--   MAN_PROJECT, then search for all ACTs then add to the ACT list all of the ACTs 
	--   that are associated to these ORGs.
	--4. Search for all ORGs where the user has MAN_ACTITIVIES permissions or ORG has public 
	--   MAN_ACTITIVIES and search for ACT that are associated to these ORGs and ARE NOT 
	--   associated to any PROJ, then add to the ACT list all of the ACTs that are 
	--   associated.
	--5. Search for all ACT where the user has OWN or MAN_KPI permissions or the ACT is public 
	--   MAN_KPI and add to the ACT list all of the ACTs.
	--6. Search for all PROJ where the user has OWN or MAN_KPI permissions, or where the PROJ 
	--   is public MAN_KPI and add to the ACT list all of the ACTs that are associated to those
	--   PROJ.
	--7. Search for all PROJ where the user has MAN_ACTIVITIES permissions or where the PROJ is 
	--   public MAN_ACTIVITIES, then search for all of the ACT and finally add to the ACT list 
	--   the ACTs.
	--8. Add to the ACT list all of the ACTs that are public VIEW_KPI
	--9. Add to the ACT list all of the ACTs where the user has OWN or VIEW_KPI or ENTER_DATA
	--   permissions.
	--
	--At the end of this, we should have a list of all of the ORGs that the user can see.

	-- So lets start with step 1.
 
	--1. Search for all ORGs where the user has OWN permissions and add to the list 
	--   of ACT to those ORGs.

	insert into @actList
	select [activityID], 'ORG OWN (1)', [organizationID] 
	from [dbo].[tbl_Activity]
	where [organizationID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'ORGANIZATION' and objectActionID = 'OWN'
			and username = @userName
	)

	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of ACTs all of these that are directly associated 
	--   to the organization

	insert into @actList
	select [activityID], 'ORG MAN_KPI (2)', [organizationID] 
	from [dbo].[tbl_Activity]
	where [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI'
	) 

	--3. Search for all ORGs where the user has MAN_PROJECT permissions or ORG has public 
	--   MAN_PROJECT, then search for all ACTs then add to the ACT list all of the ACTs 
	--   that are associated to these ORGs.

	insert into @actList
	select [activityID], 'ORG MAN_PROJECT (3)', [organizationID] 
	from [dbo].[tbl_Activity]
	where [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PROJECT' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PROJECT'
	) 

	--4. Search for all ORGs where the user has MAN_ACTITIVIES permissions or ORG has public 
	--   MAN_ACTITIVIES and search for ACT that are associated to these ORGs and ARE NOT 
	--   associated to any PROJ, then add to the ACT list all of the ACTs that are 
	--   associated.
	
	insert into @actList
	select [activityID], 'ORG MAN_ACTIVITY (4)', [organizationID] 
	from [dbo].[tbl_Activity]
	where [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_ACTIVITY' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_ACTIVITY'
	)  and [projectID] is null

	--5. Search for all ACT where the user has OWN or MAN_KPI permissions or the ACT is public 
	--   MAN_KPI and add to the ACT list all of the ACTs.

	insert into @actList
	select [activityID], 'ACT OWN (5)', [activityID]
	from [dbo].[tbl_Activity]
	where[activityID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'ACTIVITY' and objectActionID = 'OWN' and username = @userName
	) 

	insert into @actList
	select [activityID], 'ACT-MAN_KPI (5)', [activityID] 
	FROM [dbo].[tbl_Activity]
	where[activityID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ACTIVITY' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ACTIVITY' and objectActionID = 'MAN_KPI'
	)

	--6. Search for all PROJ where the user has OWN or MAN_KPI permissions, or where the PROJ 
	--   is public MAN_KPI and add to the ACT list all of the ACTs that are associated to those
	--   PROJ.

	insert into @actList
	select [activityID], 'PROJ OWN (6)', [projectID] 
	from [dbo].[tbl_Activity]
	where [projectID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'PROJECT' and objectActionID = 'OWN' and username = @userName
	)

	insert into @actList
	select [activityID], 'PROJ-MAN_KPI (6)', [projectID] 
	FROM [dbo].[tbl_Activity]
	where [projectID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_KPI'
	)

	--7. Search for all PROJ where the user has MAN_ACTIVITIES permissions or where the PROJ is 
	--   public MAN_ACTIVITIES, then search for all of the ACT and finally add to the ACT list 
	--   the ACTs.

	insert into @actList
	select [activityID], 'PROJ-MAN_ACTIVITY (7)', [projectID] 
	from [dbo].[tbl_Activity]
	where [projectID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_ACTIVITY' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_ACTIVITY'
	)

	--8. Add to the ACT list all of the ACTs that are public VIEW_KPI

	insert into @actList
	select [activityID], 'KPI-PUB VIEW (8)', [kpiID] 
	FROM [dbo].[tbl_KPI]
	where [kpiID] in (
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI'
	)

	--9.	Add to the ACT list all of the ACTs where the user has OWN or VIEW_KPI or ENTER_DATA
	--      permissions.
	insert into @actList
	select [activityID], 'KPI-VIEW-OWN-ENTER (11)', [kpiID] 
	FROM [dbo].[tbl_KPI]
	where [kpiID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'OWN' AND username = @userName
		union
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'ENTER_DATA' AND username = @userName
		union
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI' AND username = @userName
	)

	select distinct [activityID] from @actList 


END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[usp_PEOPLE_GetPersonListForUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [usp_PEOPLE_GetPersonListForUser]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================================
-- Author:		Gabriela Sanchez V.
-- Create date: Jun 2 2016
-- Description:	Get List of People that user has view rights to
-- =============================================================
CREATE PROCEDURE [usp_PEOPLE_GetPersonListForUser]
	-- Add the parameters for the stored procedure here
	@userName varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--- Get list of KPIS where user has acccess.  In the sourceObjectType
	-- column we will record where we got this from, and the objectID will
	-- tell us the ID of the object where this KPI came from.
	DECLARE @pplList as TABLE(personID int, sourceObjectType varchar(100), objectID int)

	-- For the following description ORG = ORGANIZATION, ACT = ACTIVITY, PPL = PEOPLE, PROF = PROJECT. 
	--If we need to determine the list of KPIs that a specific user can see 
	--we need to follow the following steps:
	--
	--1. Search for all ORGs where the user has OWN permissions and add to the list 
	--   of PPL all the people related to the ORG.
	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of PPLs all of the people that are directly associated 
	--   to the ORG
	--3. Search for all ORGs where the user has MAN_PEOPLE permissions or where the ORG has 
	--   public MAN_PEOPLE, then search for all of the PPL that are associated to those 
	--   ORGs and finally add to the PLL list all of the people.
	--4. Search for all PPL where the user has OWN or MAN_KPI permissions or where the PPL is 
	--    public MAN_KPI and add to the PPL list all the people that are associated.
	--5. Add to the ORG list all of the KPIs that are public VIEW_KPI
	--6.	Add to the ORG list all of the ORGs where the user has OWN or VIEW_KPI or ENTER_DATA
	--      permissions.
	--
	--At the end of this, we should have a list of all of the ORGs that the user can see.

	-- So lets start with step 1.
 
	--1. Search for all ORGs where the user has OWN permissions and add to the list 
	--   of PPL all the people related to the ORG.

	insert into @pplList
	select [personID], 'ORG OWN (1)', [organizationID] 
	from [dbo].[tbl_People]
	where [organizationID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'ORGANIZATION' and objectActionID = 'OWN'
			and username = @userName
	)

	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of PPLs all of the people that are directly associated 
	--   to the ORG

	insert into @pplList
	select [personID], 'ORG MAN_ORG (2)', [organizationID] 
	from [dbo].[tbl_KPI]
	where [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI'
	) 

	--3. Search for all ORGs where the user has MAN_PEOPLE permissions or where the ORG has 
	--   public MAN_PEOPLE, then search for all of the PPL that are associated to those 
	--   ORGs and finally add to the PLL list all of the people.

	insert into @pplList
	select [personID], 'ORG MAN_PEOPLE (3)', [organizationID] 
	from [dbo].[tbl_People] 
	where [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PEOPLE' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PEOPLE'
	)  

	--4. Search for all PPL where the user has OWN or MAN_KPI permissions or where the PPL is 
	--    public MAN_KPI and add to the PPL list all the people that are associated.

	insert into @pplList
	select [personID], 'PPL OWN (4)', [personID]
	from [dbo].[tbl_People]
	where [personID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'PERSON' and objectActionID = 'OWN' and username = @userName
	)

	insert into @pplList
	select [personID], 'PPL-MAN_KPI (4)', [personID] 
	FROM [dbo].[tbl_People]
	where [personID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PERSON' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'PERSON' and objectActionID = 'MAN_KPI'
	)

	--5. Add to the ORG list all of the KPIs that are public VIEW_KPI

	insert into @pplList
	select [personID], 'KPI-PUB VIEW (5)', [kpiID] 
	FROM [dbo].[tbl_KPI]
	where [kpiID] in (
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI'
	)

	--6.	Add to the ORG list all of the ORGs where the user has OWN or VIEW_KPI or ENTER_DATA
	--      permissions.
	insert into @pplList
	select [personID], 'KPI-VIEW-OWN-ENTER (6)', [kpiID] 
	FROM [dbo].[tbl_KPI]
	where [kpiID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'OWN' AND username = @userName
		union
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'ENTER_DATA' AND username = @userName
		union
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI' AND username = @userName
	)

	select distinct personID from @pplList 


END
GO

/****** Object:  StoredProcedure [dbo].[usp_ORG_GetOrganizationsByUser]    Script Date: 06/02/2016 12:08:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez
-- Create date: April 27 2016
-- Description:	List organizations by user
-- =============================================
ALTER PROCEDURE [dbo].[usp_ORG_GetOrganizationsByUser] 
	@varUsername VARCHAR(50),
	@varWhereClause VARCHAR(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #tblOrganization
		(organizationId INT)

	INSERT INTO #tblOrganization
	EXEC [dbo].[usp_ORG_GetOrganizationListForUser] @varUsername

	DECLARE @varSQL AS VARCHAR(MAX)

	SET @varSQL = '	SELECT DISTINCT [o].[organizationID], [o].[name]
					FROM [dbo].[tbl_Organization] [o]
					INNER JOIN #tblOrganization [t] ON [o].[organizationID] = [t].[organizationId]
					WHERE ' + @varWhereClause + '
					ORDER BY [o].[name]'
	
	EXEC (@varSQL)
	
	DROP TABLE #tblOrganization

END
GO

--========================================================================
/****** Object:  StoredProcedure [dbo].[usp_PROJ_GetProjectsBySearch]    Script Date: 06/02/2016 12:11:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: April 29 2016
-- Description:	List all projects by organization
-- =============================================
ALTER PROCEDURE [dbo].[usp_PROJ_GetProjectsBySearch]
	@varUsername VARCHAR(50),
	@varWhereClause VARCHAR(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #tblProject
		(projectId INT)

	INSERT INTO #tblProject
	EXEC [dbo].[usp_PROJ_GetProjectListForUser] @varUsername

	DECLARE @varSQL AS VARCHAR(MAX)

	SET @varSQL = 'SELECT DISTINCT [p].[projectID]
						,[p].[name]
						,[p].[organizationID]
						,[p].[areaID]
					FROM [dbo].[tbl_Project] [p]
					INNER JOIN #tblProject [t] ON [p].[projectID] = [t].[projectId]
					WHERE ' + @varWhereClause + '
					ORDER BY [p].[name]'
	
	EXEC (@varSQL)

	DROP TABLE #tblProject

END
GO

--===========================================================================
/****** Object:  StoredProcedure [dbo].[usp_ACT_GetActivitiesBySearch]    Script Date: 06/02/2016 12:15:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: May 4 2016
-- Description:	List all activities by search
-- =============================================
ALTER PROCEDURE [dbo].[usp_ACT_GetActivitiesBySearch]
	@varUsername VARCHAR(25),
	@varWhereClause VARCHAR(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #tblActivity
		(activityId INT)

	INSERT INTO #tblActivity
	EXEC [dbo].[usp_ACT_GetActivityListForUser] @varUsername

	DECLARE @varSQL AS VARCHAR(MAX)

	SET @varSQL = 'SELECT [a].[activityID]
		  ,[a].[name]
		  ,[a].[organizationID]
		  ,[a].[areaID]
		  ,[a].[projectID]
	  FROM [dbo].[tbl_Activity] [a]
	  INNER JOIN #tblActivity [t] ON [a].[activityID] = [t].[activityId]
	  INNER JOIN [dbo].[tbl_Organization] [g] ON [a].[organizationID] = [g].[organizationID]
	  LEFT JOIN [dbo].[tbl_Area] [r] ON [a].[areaID] = [r].[areaID]
	  LEFT JOIN [dbo].[tbl_Project] [p] ON [p].[projectID] = [a].[projectID]
	  WHERE ' + @varWhereClause + '
	  ORDER BY [a].[name]'
	  
	 EXEC (@varSQL)
	 
	 DROP TABLE #tblActivity
	 
END
GO

--==============================================================================

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PEOPLE_GetPeopleBySearch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PEOPLE_GetPeopleBySearch]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: June 2, 2016
-- Description:	Get the lists of people for search
-- =============================================
CREATE PROCEDURE [dbo].[usp_PEOPLE_GetPeopleBySearch]
	@varUsername VARCHAR(25),
	@varWhereClause VARCHAR(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #tblPeople
		(personId INT)

	INSERT INTO #tblPeople
	EXEC [usp_PEOPLE_GetPersonListForUser] @varUsername

	DECLARE @varSQL AS VARCHAR(MAX)

	SET @varSQL = 'SELECT [p].[personID]
				  ,[p].[id]
				  ,[p].[name]
				  ,[p].[organizationID]
				  ,[p].[areaID]
			FROM [dbo].[tbl_People] [p]
			INNER JOIN #tblPeople [t] ON [p].[personID] = [t].[personId]
			INNER JOIN [dbo].[tbl_Organization] [g] ON [p].[organizationID] = [g].[organizationID]
			LEFT JOIN [dbo].[tbl_Area] [r] ON [p].[areaID] = [r].[areaID]
	        WHERE ' + @varWhereClause + '
	        ORDER BY [p].[name]'
	  
	 EXEC (@varSQL)
	 
	 DROP TABLE #tblPeople
	 
END

GO


/*
 * We are done, mark the database as a 1.10.0 database.
 */

DELETE FROM [dbo].[tbl_DatabaseInfo] 
INSERT INTO [dbo].[tbl_DatabaseInfo] 
	([majorversion], [minorversion], [releaseversion])
	VALUES (1,10,0)
GO
