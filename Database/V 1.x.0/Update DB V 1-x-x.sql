USE [KPIDB]
GO

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
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @tblData AS TABLE
	(targetID INT,
	 detalle VARCHAR(1000),
	 [target] DECIMAL(21,9))

	DECLARE @targetID INT
	DECLARE @detalle VARCHAR(1000)
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
		
		SELECT @detalle = STUFF((SELECT '; ' + [i].[name]
							  FROM [dbo].[tbl_KPITargetCategories] [c]
							  INNER JOIN [dbo].[tbl_CategoryItem] [i] ON [c].[categoryItemID] = [i].[categoryItemID]
							  WHERE [targetID] = @targetID
							  FOR XML PATH('')), 1, 1, '') 

		INSERT @tblData VALUES (@targetID, @detalle, @valor)

		FETCH NEXT FROM target_cursor
		INTO @targetID, @valor
	END

	CLOSE target_cursor;
	DEALLOCATE target_cursor;

	SELECT targetID, detalle, [target]
	FROM @tblData
	
END
GO

--===========================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_AddDeleteCategoryTargetByKpi]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_KPI_AddDeleteCategoryTargetByKpi]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: 30/05/2016
-- Description:	Add or Delete a category for a KPI Target
-- =============================================
CREATE PROCEDURE usp_KPI_AddDeleteCategoryTargetByKpi
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
				SELECT @count, [productoId] + ';' + [b].[categoryItemID], [a].[categoriesId] + ';' + [b].[categoryID]
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
			FROM dbo.tvf_SplitStringInVarCharTable(@productoId,';')
			
			INSERT #tbl_CategoryItems
			SELECT splitvalue
			FROM dbo.tvf_SplitStringInVarCharTable(@categoriesId,';')
			
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

--===========================================================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- =============================================
-- Author:		Ivan Krsul
-- Create date: May 5 2016
-- Description:	List all KPIs in the system by Search
-- =============================================
ALTER PROCEDURE [dbo].[usp_KPI_GetKPIsBySearch]
	@varUserName VARCHAR(50),
	@varWhereClause VARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	CREATE TABLE #tblKPI
		(kpiId INT)

	INSERT INTO #tblKPI
	EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUsername
	
	DECLARE @varSQL VARCHAR(MAX)

	SET @varSQL = 'SELECT [k].[kpiID]
				  ,[name]
				  ,[organizationID]
				  ,[areaID]
				  ,[projectID]
				  ,[activityID]
				  ,[personID]
				  ,[unitID]
				  ,[directionID]
				  ,[strategyID]
				  ,[startDate]
				  ,[reportingUnitID]
				  ,[targetPeriod]
				  ,[allowsCategories]
				  ,[currency]
				  ,[currencyUnitID]
				  ,[kpiTypeID]
			  FROM [dbo].[tbl_KPI] [k]
			  INNER JOIN #tblKPI [tk] ON [k].[KPIId] = [tk].[KPIId]
			  WHERE ' + @varWhereClause
			  
	 EXEC (@varSQL)
	 
	 DROP TABLE #tblKPI
	 
END
GO

--===========================================================================================
--===========================================================================================
--===========================================================================================
--===========================================================================================
--===========================================================================================