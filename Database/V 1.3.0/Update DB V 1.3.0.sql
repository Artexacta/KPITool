/* 
	Updates de the KPIDB database to version 1.1.0 
*/

Use [Master]
GO 

IF  NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'KPIDB')
	RAISERROR('KPIDB database Doesn´t exists. Create the database first',16,127)
GO

PRINT 'Updating KPIDB database to version 1.3.0'

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

IF NOT (@smiMajor = 1 AND @smiMinor = 2) 
BEGIN
	RAISERROR('KPIDB database is not in version 1.2 This program only applies to version 1.2',16,127)
	RETURN;
END

PRINT 'KPIDB Database version OK'
GO

USE [KPIDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_ORG_GetAllOrganizations]    Script Date: 04/27/2016 10:41:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez
-- Create date: April 27 2016
-- Description:	Get organization by ID
-- =============================================
CREATE PROCEDURE [dbo].[usp_ORG_GetOrganizationById]
	 @intOrganizationId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT [organizationID], [name]
	FROM [dbo].[tbl_Organization]
	WHERE [organizationID] = @intOrganizationId

END
GO

--========================================================================
/****** Object:  StoredProcedure [dbo].[usp_ORG_GetAllOrganizations]    Script Date: 04/27/2016 12:09:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez
-- Create date: April 27 2016
-- Description:	List organizations by user
-- =============================================
CREATE PROCEDURE [dbo].[usp_ORG_GetOrganizationsByUser] 
	@varUsername VARCHAR(50),
	@varWhereClause VARCHAR(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @varSQL AS VARCHAR(MAX)

	SET @varSQL = '	SELECT DISTINCT [o].[organizationID], [o].[name]
					FROM [dbo].[tbl_Organization] [o]
					INNER JOIN [dbo].[tbl_SEG_ObjectPermissions] [p] ON [o].[organizationID] = [p].[objectID]
					WHERE [p].[objectTypeID] = ''ORGANIZATION''
					AND   [p].[username] = ''' + @varUsername + '''
					AND ' + @varWhereClause + '
					ORDER BY [o].[name]'
	
	EXEC (@varSQL)

END
GO

--==============================================================================

/****** Object:  StoredProcedure [dbo].[usp_ORG_DeleteOrganization]    Script Date: 04/27/2016 12:46:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Delete an organization, an all of the related objects
--				
-- =============================================
ALTER PROCEDURE [dbo].[usp_ORG_DeleteOrganization]
	@organizationID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

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
		SAVE TRANSACTION DeleteOrganization;     
	ELSE
		-- This SP starts its own transaction and there was no previous transaction
		BEGIN TRANSACTION;

	BEGIN TRY
		
		-- We basically have to delete everything related to that organization.
		
		-- Start with KPIs. 
		-- Get the IDs of all the KPIs we will delete
		DECLARE @KPITable as TABLE (kpiID int)
		INSERT INTO @KPITable
		SELECT [kpiID] from [dbo].[tbl_KPI]
		where [organizationID] = @organizationID

		-- Delete all measurements for the KPIs selected

		-- Delete all permissions for the KPIs selected
		DELETE FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and [objectID] in (select kpiID from @KPITable)

		-- Delete the KPIs selected
		-- Now lets delete all people for the organization
		-- Get the IDs of all the people we will delete
		-- Delete all the permissios for these persons
		-- Delete the people

		-- Now lets delete all activities for the organization
		-- Get the IDs of all the activities we will delete
		-- Delete all the permissios for these activities
		-- Delete the activities

		-- Now lets delete all projects for the organization
		-- Get the IDs of all the projects we will delete
		-- Delete all the projects for these activities
		-- Delete the projects

		-- Now lets delete all areas for the organization

		-- Now lets delete the permissions for the organization

		-- And finally lets delete the organization

		-- =============================================================
		DELETE FROM [dbo].[tbl_Area]
		WHERE [organizationID] = @organizationID
		
		DELETE FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION'
		AND   [objectID] = @organizationID
		
		DELETE FROM dbo.tbl_Organization
		WHERE organizationID = @organizationID
		-- =============================================================

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
				ROLLBACK TRANSACTION DeleteOrganization;

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

--==============================================================================

/****** Object:  StoredProcedure [dbo].[usp_ORG_GetAllOrganizations]    Script Date: 04/27/2016 12:09:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez
-- Create date: April 27 2016
-- Description:	List organizations by name
-- =============================================
CREATE PROCEDURE [dbo].[usp_ORG_GetOrganizationsByName] 
	@varUsername VARCHAR(50),
	@varName VARCHAR(250)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT DISTINCT [o].[organizationID], [o].[name]
	FROM [dbo].[tbl_Organization] [o]
	INNER JOIN [dbo].[tbl_SEG_ObjectPermissions] [p] ON [o].[organizationID] = [p].[objectID]
	WHERE [p].[objectTypeID] = 'ORGANIZATION'
	AND   [p].[username] = @varUsername 
	AND   [o].[name] = @varName

END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez
-- Create date: April 29 2016
-- Description:	Get areas by organization
-- =============================================
CREATE PROCEDURE [dbo].[usp_ORG_GetAreasByOrganization]
	 @intOrganizationId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT [areaID]
		  ,[organizationID]
		  ,[name]
	  FROM [dbo].[tbl_Area]
	 WHERE [organizationID] = @intOrganizationId


END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez
-- Create date: April 29 2016
-- Description:	Get area by organization y name
-- =============================================
CREATE PROCEDURE [dbo].[usp_ORG_GetAreaByNameAndOrganization]
	 @intOrganizationId INT,
	 @varName VARCHAR(250)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT [areaID]
		  ,[organizationID]
		  ,[name]
	  FROM [dbo].[tbl_Area]
	 WHERE [organizationID] = @intOrganizationId
	 AND   [name] = @varName


END
GO

--===================================================================================
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: April 29, 2016
-- Description:	Update the area for an organization
-- =============================================
CREATE PROCEDURE [dbo].[usp_ORG_UpdateArea]
	@areaID int,
	@areaName nvarchar(250)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE [dbo].[tbl_Area]
	SET [name] = @areaName
	WHERE [areaID] = @areaID


END
GO

--===================================================================================
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: April 29, 2016
-- Description:	Delete the area for an organization
-- =============================================
CREATE PROCEDURE [dbo].[usp_ORG_DeleteArea]
	@areaID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE FROM [dbo].[tbl_Area]
	WHERE [areaID] = @areaID

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: April 29 2016
-- Description:	List all projects by organization
-- =============================================
CREATE PROCEDURE [dbo].[usp_PROJ_GetProjectsByOrganization]
	@intOrganizationId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [projectID]
		,[name]
		,[organizationID]
		,[areaID]
	FROM [dbo].[tbl_Project]
	WHERE [organizationID] = @intOrganizationId

END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: April 29 2016
-- Description:	List all projects by organization
-- =============================================
CREATE PROCEDURE [dbo].[usp_PROJ_GetProjectsBySearch]
	@varUsername VARCHAR(50),
	@varWhereClause VARCHAR(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @varSQL AS VARCHAR(MAX)

	SET @varSQL = 'SELECT [projectID]
						,[name]
						,[organizationID]
						,[areaID]
					FROM [dbo].[tbl_Project] [p]
					INNER JOIN [dbo].[tbl_SEG_ObjectPermissions] [o] ON [p].[projectID] = [o].[objectID]
					WHERE [o].[objectTypeID] = ''PROJECT''
					AND   [o].[username] = ''' + @varUsername + '''
					AND  ' + @varWhereClause + '
					ORDER BY [p].[name]'
	
	EXEC (@varSQL)

END
GO

--=============================================================================================================================

/*
 * We are done, mark the database as a 1.3.0 database.
 */

DELETE FROM [dbo].[tbl_DatabaseInfo] 
INSERT INTO [dbo].[tbl_DatabaseInfo] 
	([majorversion], [minorversion], [releaseversion])
	VALUES (1,3,0)
GO
