/* 
	Updates de the KPIDB database to version 1.12.0 
*/

Use [Master]
GO 

IF  NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'KPIDB')
	RAISERROR('KPIDB database Doesn´t exists. Create the database first',16,127)
GO

PRINT 'Updating KPIDB database to version 1.12.0'

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

IF NOT (@smiMajor = 1 AND @smiMinor = 11) 
BEGIN
	RAISERROR('KPIDB database is not in version 1.11 This program only applies to version 1.11',16,127)
	RETURN;
END

PRINT 'KPIDB Database version OK'
GO


USE [KPIDB]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PEOPLE_GetPersonByArea]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PEOPLE_GetPersonByArea]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Marcela Martinez
-- Create date: 30/04/2016
-- Description:	Get persona by Area
-- =============================================
CREATE PROCEDURE [dbo].[usp_PEOPLE_GetPersonByArea]
	@intAreaId AS INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [personID]
		  ,[id]
		  ,[name]
		  ,[organizationID]
		  ,[areaID]
	FROM [dbo].[tbl_People] 
	WHERE [areaID] = @intAreaId
    
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKPIsByPerson]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKPIsByPerson]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sánchez V.
-- Create date: 03/06/2016
-- Description:	Get KPIs by person
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKPIsByPerson]
	 @intPersonId INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [kpiID]
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
	FROM [dbo].[tbl_KPI] 
	WHERE [personID] = @intPersonId
	
    
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PEOPLE_UpdatePerson]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PEOPLE_UpdatePerson]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: June 7, 2016
-- Description:	Update a new person
-- =============================================
CREATE PROCEDURE [dbo].[usp_PEOPLE_UpdatePerson]
	@personID int,
	@id nvarchar(50),
	@personName nvarchar(250),
	@organizationID int,
	@areaID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF(@areaID = 0)
		SELECT @areaID = null

	UPDATE [dbo].[tbl_People]
	   SET [id] = @id
		  ,[name] = @personName
		  ,[organizationID] = @organizationID
		  ,[areaID] = @areaID
	 WHERE [personId] = @personID

END
GO




IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PEOPLE_DeletePerson]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PEOPLE_DeletePerson]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: June 7, 2016
-- Description:	Delete a person
-- =============================================
CREATE PROCEDURE [dbo].[usp_PEOPLE_DeletePerson]
	@personID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE FROM [dbo].[tbl_People]
      WHERE [personID] = @personID


END

GO


/*
 * We are done, mark the database as a 1.12.0 database.
 */

DELETE FROM [dbo].[tbl_DatabaseInfo] 
INSERT INTO [dbo].[tbl_DatabaseInfo] 
	([majorversion], [minorversion], [releaseversion])
	VALUES (1,12,0)
GO
