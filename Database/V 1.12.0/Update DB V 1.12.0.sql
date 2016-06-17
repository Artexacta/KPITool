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

--===================================================================================================


/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiProgress]    Script Date: 06/16/2016 15:17:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpiProgress]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpiProgress]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByProject]    Script Date: 06/16/2016 15:17:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKPIsByProject]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKPIsByProject]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByPerson]    Script Date: 06/16/2016 15:17:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKPIsByPerson]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKPIsByPerson]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByOrganization]    Script Date: 06/16/2016 15:17:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKPIsByOrganization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKPIsByOrganization]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByActivity]    Script Date: 06/16/2016 15:17:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKPIsByActivity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKPIsByActivity]
GO


/****** Object:  UserDefinedFunction [dbo].[svf_GetKpiProgess]    Script Date: 06/16/2016 15:19:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[svf_GetKpiProgess]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[svf_GetKpiProgess]
GO


/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiProgress]    Script Date: 06/16/2016 15:17:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jose Carlos Gutierrez
-- Create date: 2016/05/19
-- Description:	Get KPI Progress
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKpiProgress]
	@intKpiId			INT,
	@varCategoryId		VARCHAR(20),
	@varCategoryItemId	VARCHAR(20),
	@bitHasTarget		BIT OUTPUT,
	@decCurrentValue	DECIMAL(21,3) OUTPUT,
	@decProgress		DECIMAL(5,2) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @decTarget DECIMAL(21,3)
	
	DECLARE @varStrategyId CHAR(3)
	DECLARE @varReportingUnitId CHAR(5)	

	SELECT @varStrategyId = [strategyID],
		@varReportingUnitId = [reportingUnitId]
	FROM [dbo].[tbl_KPI] 
	WHERE [kpiID] = @intKpiId

	IF 	@varCategoryId = '' OR @varCategoryId IS NULL
	BEGIN
	
		IF(@varStrategyId = 'SUM')
		BEGIN
	
			-- verify if exists a target
			SELECT @decTarget = SUM([target]) 
			FROM [dbo].[tbl_KPITarget] 
			WHERE [kpiID] = @intKpiId
			GROUP BY [kpiID]
		END
		ELSE IF @varStrategyId = 'AVG'
		BEGIN
			SELECT @decTarget = AVG([target]) 
			FROM [dbo].[tbl_KPITarget] 
			WHERE [kpiID] = @intKpiId
			GROUP BY [kpiID]
		END
		
	END
	ELSE
	BEGIN
	
		IF(@varStrategyId = 'SUM')
		BEGIN
			SELECT @decTarget = SUM([target]) 
			FROM [dbo].[tbl_KPITarget]
			WHERE [kpiID] = @intKpiId
				AND [kpiID] IN (SELECT [kpiID] FROM [dbo].[tbl_KPITargetCategories] WHERE [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId)
			GROUP BY [kpiID]
		END
		ELSE IF @varStrategyId = 'AVG'
		BEGIN
			SELECT @decTarget = AVG([target]) 
			FROM [dbo].[tbl_KPITarget]
			WHERE [kpiID] = @intKpiId
				AND [kpiID] IN (SELECT [kpiID] FROM [dbo].[tbl_KPITargetCategories] WHERE [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId)
			GROUP BY [kpiID]
		END
	END
	
	IF @decTarget IS NULL
		SET @bitHasTarget = 0
	ELSE
		SET @bitHasTarget = 1
		
	
	
	
	DECLARE @days INT 
	SELECT @days = p.[days]
	FROM [dbo].[tbl_KpiReportingPeriod] p
	WHERE p.[reportingUnitId] = @varReportingUnitId
	
	DECLARE @dateFrom DATE = DATEADD(DAY, -@days, GETDATE())
	
	IF @varStrategyId = 'AVG'
	BEGIN
		IF @varCategoryId = '' OR @varCategoryId IS NULL
		BEGIN
		
			SELECT TOP 1 @decCurrentValue = [value]
			FROM (
				SELECT ISNULL(AVG([measurement]),0) [value]
				FROM [dbo].[tbl_KPIMeasurements]
				WHERE [kpiID] = @intKpiId
					AND [date] BETWEEN @dateFrom AND GETDATE()
			) tbl
		END
		ELSE
		BEGIN
		
			SELECT TOP 1 @decCurrentValue = [value]
			FROM (
				SELECT ISNULL(AVG([measurement]),0) [value]
				FROM [dbo].[tbl_KPIMeasurements]
				WHERE [kpiID] = @intKpiId
					AND [date] BETWEEN @dateFrom AND GETDATE()
					AND [measurmentID] IN (SELECT [measurmentID] FROM [dbo].[tbl_KPIMeasurementCategories] WHERE [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId)
			) tbl
		
		END
		
		
	END

	IF @varStrategyId = 'SUM'
	BEGIN
		IF @varCategoryId = '' OR @varCategoryId IS NULL
		BEGIN
		
			SELECT TOP 1 @decCurrentValue = [value]
			FROM (
				SELECT ISNULL(SUM([measurement]),0) [value]
				FROM [dbo].[tbl_KPIMeasurements]
				WHERE [kpiID] = @intKpiId
					AND [date] BETWEEN @dateFrom AND GETDATE()
			) tbl
		END
		ELSE
		BEGIN
		
			SELECT TOP 1 @decCurrentValue = [value]
			FROM (
				SELECT ISNULL(SUM([measurement]),0) [value]
				FROM [dbo].[tbl_KPIMeasurements]
				WHERE [kpiID] = @intKpiId
					AND [date] BETWEEN @dateFrom AND GETDATE()
					AND [measurmentID] IN (SELECT [measurmentID] FROM [dbo].[tbl_KPIMeasurementCategories] WHERE [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId)
			) tbl
		
		END
	END 

    SELECT @decProgress = [dbo].[svf_GetKpiProgess](@intKpiId, @varCategoryId, @varCategoryItemId)
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByProject]    Script Date: 06/16/2016 15:17:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Marcela Martinez
-- Create date: 19/05/2016
-- Description:	Get KPIs by project
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKPIsByProject]
	@intProjectId INT,
	@varUserName AS VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;

    CREATE TABLE #tbl_KPI([kpiId] INT)
	INSERT INTO #tbl_KPI 
		EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUserName
	
    SELECT [k].[kpiID]
		  ,[k].[name]
		  ,[k].[organizationID]
		  ,[k].[areaID]
		  ,[k].[projectID]
		  ,[k].[activityID]
		  ,[k].[personID]
		  ,[k].[unitID]
		  ,[k].[directionID]
		  ,[k].[strategyID]
		  ,[k].[startDate]
		  ,[k].[reportingUnitID]
		  ,[k].[targetPeriod]
		  ,[k].[allowsCategories]
		  ,[k].[currency]
		  ,[k].[currencyUnitID]
		  ,[k].[kpiTypeID]
		  ,[o].[name] [organizationName]
		  ,[a].[name] [areaName]
		  ,[p].[name] [projectName]
		  ,[ac].[name] [activityName]
		  ,[pe].name [personName]
		  ,[dbo].[svf_GetKpiProgess]([k].[kpiID],'','') [progress]
		  ,[dbo].[svf_GetKpiTrend]([k].[kpiID]) [trend]
	FROM [dbo].[tbl_KPI] [k] 
	INNER JOIN #tbl_KPI [kpi] ON [k].[kpiID] = [kpi].[kpiId] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID] 
	LEFT OUTER JOIN [dbo].[tbl_Activity] [ac] ON [k].[activityID] = [ac].[activityID] 
	LEFT OUTER JOIN [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID] 
	WHERE [k].[projectID] = @intProjectId
    
    DROP TABLE #tbl_KPI
    
END




GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByPerson]    Script Date: 06/16/2016 15:17:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Marcela Martinez
-- Create date: 19/05/2016
-- Description:	Get KPIs by person
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKPIsByPerson]
	 @intPersonId INT,
	 @varUserName AS VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;

    CREATE TABLE #tbl_KPI([kpiId] INT)
	INSERT INTO #tbl_KPI
		EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUserName
	
    SELECT [k].[kpiID]
		  ,[k].[name]
		  ,[k].[organizationID]
		  ,[k].[areaID]
		  ,[k].[projectID]
		  ,[k].[activityID]
		  ,[k].[personID]
		  ,[k].[unitID]
		  ,[k].[directionID]
		  ,[k].[strategyID]
		  ,[k].[startDate]
		  ,[k].[reportingUnitID]
		  ,[k].[targetPeriod]
		  ,[k].[allowsCategories]
		  ,[k].[currency]
		  ,[k].[currencyUnitID]
		  ,[k].[kpiTypeID]
		  ,[o].[name] [organizationName]
		  ,[a].[name] [areaName]
		  ,[p].[name] [projectName]
		  ,[ac].[name] [activityName]
		  ,[pe].name [personName]
		  ,[dbo].[svf_GetKpiProgess]([k].[kpiID],'','') [progress]
		  ,[dbo].[svf_GetKpiTrend]([k].[kpiID]) [trend]
	FROM [dbo].[tbl_KPI] [k] 
	INNER JOIN #tbl_KPI [kpi] ON [k].[kpiID] = [kpi].[kpiId] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID] 
	LEFT OUTER JOIN [dbo].[tbl_Activity] [ac] ON [k].[activityID] = [ac].[activityID] 
	LEFT OUTER JOIN [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID] 
	WHERE [k].[personID] = @intPersonId
    
    DROP TABLE #tbl_KPI
    
END




GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByOrganization]    Script Date: 06/16/2016 15:17:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Marcela Martinez
-- Create date: 02/04/2016
-- Description:	Get KPIs by organization
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKPIsByOrganization]
	 @intOrganizationId INT,
	 @varUserName AS VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	CREATE TABLE #tbl_KPI([kpiId] INT)
	INSERT INTO #tbl_KPI 
		EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUserName
	
    SELECT [k].[kpiID]
		  ,[k].[name]
		  ,[k].[organizationID]
		  ,[k].[areaID]
		  ,[k].[projectID]
		  ,[k].[activityID]
		  ,[k].[personID]
		  ,[k].[unitID]
		  ,[k].[directionID]
		  ,[k].[strategyID]
		  ,[k].[startDate]
		  ,[k].[reportingUnitID]
		  ,[k].[targetPeriod]
		  ,[k].[allowsCategories]
		  ,[k].[currency]
		  ,[k].[currencyUnitID]
		  ,[k].[kpiTypeID]
		  ,[o].[name] [organizationName]
		  ,[a].[name] [areaName]
		  ,[p].[name] [projectName]
		  ,[ac].[name] [activityName]
		  ,[pe].name [personName]
		  ,[dbo].[svf_GetKpiProgess]([k].[kpiID],'','') [progress]
		  ,[dbo].[svf_GetKpiTrend]([k].[kpiID]) [trend]
	FROM [dbo].[tbl_KPI] [k] 
	INNER JOIN #tbl_KPI [kpi] ON [k].[kpiID] = [kpi].[kpiId] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID] 
	LEFT OUTER JOIN [dbo].[tbl_Activity] [ac] ON [k].[activityID] = [ac].[activityID] 
	LEFT OUTER JOIN [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID] 
	WHERE [k].[organizationID] = @intOrganizationId
    
    DROP TABLE #tbl_KPI
    
END





GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByActivity]    Script Date: 06/16/2016 15:17:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Marcela Martinez
-- Create date: 19/05/2016
-- Description:	Get KPIs by activity
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKPIsByActivity]
	 @intActivityId INT,
	 @varUserName AS VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;

    CREATE TABLE #tbl_KPI([kpiId] INT)
	INSERT INTO #tbl_KPI 
		EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUserName
	
    SELECT [k].[kpiID]
		  ,[k].[name]
		  ,[k].[organizationID]
		  ,[k].[areaID]
		  ,[k].[projectID]
		  ,[k].[activityID]
		  ,[k].[personID]
		  ,[k].[unitID]
		  ,[k].[directionID]
		  ,[k].[strategyID]
		  ,[k].[startDate]
		  ,[k].[reportingUnitID]
		  ,[k].[targetPeriod]
		  ,[k].[allowsCategories]
		  ,[k].[currency]
		  ,[k].[currencyUnitID]
		  ,[k].[kpiTypeID]
		  ,[o].[name] [organizationName]
		  ,[a].[name] [areaName]
		  ,[p].[name] [projectName]
		  ,[ac].[name] [activityName]
		  ,[pe].name [personName]
		  ,[dbo].[svf_GetKpiProgess]([k].[kpiID],'','') [progress]
		  ,[dbo].[svf_GetKpiTrend]([k].[kpiID]) [trend]
	FROM [dbo].[tbl_KPI] [k] 
	INNER JOIN #tbl_KPI [kpi] ON [k].[kpiID] = [kpi].[kpiId] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID] 
	LEFT OUTER JOIN [dbo].[tbl_Activity] [ac] ON [k].[activityID] = [ac].[activityID] 
	LEFT OUTER JOIN [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID] 
	WHERE [k].[activityID] = @intActivityId
	
	DROP TABLE #tbl_KPI
    
END




GO



/****** Object:  UserDefinedFunction [dbo].[svf_GetKpiProgess]    Script Date: 06/16/2016 15:19:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:  Jose Carlos Gutierrez
-- Create date: 2016/05/19
-- Description: Get KPI Progress
-- =============================================
CREATE FUNCTION [dbo].[svf_GetKpiProgess]
(
	@intKpiId INT,
	@varCategoryId	VARCHAR(20),
	@varCategoryItemId	VARCHAR(20)
)
RETURNS DECIMAL(9,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @dcProgress DECIMAL(25,3)
	
	DECLARE @intParameterBase AS INT
	DECLARE @intParameterActual AS INT
	SELECT @intParameterBase = [value] FROM [dbo].[tbl_PAR_Parameter] WHERE [parameterID] = 1
	SELECT @intParameterActual = [value] FROM [dbo].[tbl_PAR_Parameter] WHERE [parameterID] = 2
	IF(@intParameterBase IS NULL)
		SET @intParameterBase = 0
	IF(@intParameterActual IS NULL)
		SET @intParameterActual = 0	
		
	DECLARE @dcTarget AS DECIMAL(25,3)
	
	DECLARE @varDirectionId AS CHAR(3)
	DECLARE @varStrategyId AS CHAR(3)
	DECLARE @dtStartDate AS DATE
	
	SELECT @varDirectionId = [directionID],
		   @varStrategyId = [strategyID],
		   @dtStartDate = [startDate]
	FROM [dbo].[tbl_KPI] 
	WHERE [kpiID] = @intKpiId
		
	IF 	@varCategoryId = '' OR @varCategoryId IS NULL
	BEGIN
	
		IF(@varStrategyId = 'SUM')
		BEGIN
	
			-- verify if exists a target
			SELECT @dcTarget = SUM([target]) 
			FROM [dbo].[tbl_KPITarget] 
			WHERE [kpiID] = @intKpiId
			GROUP BY [kpiID]
		END
		ELSE IF @varStrategyId = 'AVG'
		BEGIN
			SELECT @dcTarget = AVG([target]) 
			FROM [dbo].[tbl_KPITarget] 
			WHERE [kpiID] = @intKpiId
			GROUP BY [kpiID]
		END
		
	END
	ELSE
	BEGIN
	
		IF(@varStrategyId = 'SUM')
		BEGIN
			SELECT @dcTarget = SUM([target]) 
			FROM [dbo].[tbl_KPITarget]
			WHERE [kpiID] = @intKpiId
				AND [kpiID] IN (SELECT [kpiID] FROM [dbo].[tbl_KPITargetCategories] WHERE [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId)
			GROUP BY [kpiID]
		END
		ELSE IF @varStrategyId = 'AVG'
		BEGIN
			SELECT @dcTarget = AVG([target]) 
			FROM [dbo].[tbl_KPITarget]
			WHERE [kpiID] = @intKpiId
				AND [kpiID] IN (SELECT [kpiID] FROM [dbo].[tbl_KPITargetCategories] WHERE [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId)
			GROUP BY [kpiID]
		END
	END
	
	
	IF(ISNULL(@dcTarget,0) > 0)
		BEGIN
			
			DECLARE @dcMeasurement AS DECIMAL(25,3)			
			
			
			IF(@varStrategyId = 'SUM')
				BEGIN
				
					IF 	@varCategoryId = '' OR @varCategoryId IS NULL
					BEGIN
					
						SELECT @dcMeasurement = SUM(CONVERT(DECIMAL(25,3),[measurement])) 
						FROM [dbo].[tbl_KPIMeasurements] 
						WHERE [kpiID] = @intKpiId 
						AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
								 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
							END = 1
						GROUP BY [kpiID]
					
					END
					ELSE
					BEGIN						
				
						-- SUM Measurements registered since startDate
						SELECT @dcMeasurement = SUM(CONVERT(DECIMAL(25,3),[measurement])) 
						FROM [dbo].[tbl_KPIMeasurements] 
						WHERE [kpiID] = @intKpiId 
						AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
								 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
							END = 1
						AND [measurmentID] IN (SELECT [measurmentID] FROM [dbo].[tbl_KPIMeasurementCategories] WHERE [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId)
						GROUP BY [kpiID]
					
					END
					
					-- calculate progress
					IF(@dcMeasurement > @dcTarget)
						SET @dcProgress = 100
					ELSE
						SET @dcProgress = (CASE WHEN ISNULL(@dcMeasurement,0) = 0 THEN 0 ELSE ((CONVERT(DECIMAL(25,3),@dcMeasurement) * 100)/@dcTarget) END)
				END
				
			ELSE IF(@varStrategyId = 'AVG')
				BEGIN
					-- COUNT Measurements registered since startDate
					DECLARE @intCountMeasurement AS INT
					
					IF 	@varCategoryId = '' OR @varCategoryId IS NULL
					BEGIN
						SELECT @intCountMeasurement = COUNT(*) 
						FROM [dbo].[tbl_KPIMeasurements] 
						WHERE [kpiID] = @intKpiId 
						AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
								 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
							END = 1
							
					END
					ELSE
					BEGIN
						SELECT @intCountMeasurement = COUNT(*) 
						FROM [dbo].[tbl_KPIMeasurements] 
						WHERE [kpiID] = @intKpiId 
						AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
								 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
							END = 1
						AND [measurmentID] IN (SELECT [measurmentID] FROM [dbo].[tbl_KPIMeasurementCategories] WHERE [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId)
					END
				
					
					IF(ISNULL(@intCountMeasurement,0) <= @intParameterActual)
						BEGIN
							-- AVG Measurements registered since startDate
							IF 	@varCategoryId = '' OR @varCategoryId IS NULL
							BEGIN
							
								SELECT @dcMeasurement = AVG(CONVERT(DECIMAL(25,3),[measurement])) 
								FROM [dbo].[tbl_KPIMeasurements] 
								WHERE [kpiID] = @intKpiId 
								AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
										 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
									END = 1
								GROUP BY [kpiID]
								
							END
							ELSE
							BEGIN
							
								SELECT @dcMeasurement = AVG(CONVERT(DECIMAL(25,3),[measurement])) 
								FROM [dbo].[tbl_KPIMeasurements] 
								WHERE [kpiID] = @intKpiId 
								AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
										 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
									END = 1
								AND [measurmentID] IN (SELECT [measurmentID] FROM [dbo].[tbl_KPIMeasurementCategories] WHERE [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId)
								GROUP BY [kpiID]
								
							END
						
							-- calculate progress
							IF(ISNULL(@dcMeasurement,0) = 0)
								SET @dcProgress = 0
							ELSE
								SET @dcProgress = ((CONVERT(DECIMAL(25,3),@dcMeasurement) * 100)/@dcTarget)
						END
					ELSE
						BEGIN
							IF(ISNULL(@intCountMeasurement,0) <= (@intParameterBase + @intParameterActual))
								SET @intParameterBase = ISNULL(@intCountMeasurement,0) - @intParameterActual
						
							DECLARE @dcMeasurementActual AS DECIMAL(25,3)
							DECLARE @dcMeasurementBase AS DECIMAL(25,3)
							DECLARE @tbl_MeasurementActual AS TABLE([date] DATE, [measurement] DECIMAL(21,3))
							DECLARE @tbl_MeasurementBase AS TABLE([date] DATE, [measurement] DECIMAL(21,3))
							
							-- AVG Measurements registered since startDate for Actual
							INSERT INTO @tbl_MeasurementActual
								SELECT TOP (@intParameterActual) [date]
									  ,[measurement]
								FROM [dbo].[tbl_KPIMeasurements] 
								WHERE [kpiID] = @intKpiId 
								AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
										 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
									END = 1
								ORDER BY [date] DESC
							
							-- AVG Measurements registered since startDate for base
							INSERT INTO @tbl_MeasurementBase
								SELECT TOP (@intParameterBase) [date]
									  ,[measurement]
								FROM [dbo].[tbl_KPIMeasurements] 
								WHERE [kpiID] = @intKpiId 
								AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
										 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
									END = 1
								ORDER BY [date] ASC
							
							-- calculate progress
							SET @dcMeasurementActual = ABS((SELECT AVG(CONVERT(DECIMAL(25,3),[measurement])) FROM @tbl_MeasurementActual) - @dcTarget)
							SET @dcMeasurementBase = ABS((SELECT AVG(CONVERT(DECIMAL(25,3),[measurement])) FROM @tbl_MeasurementBase) - @dcTarget)
							SET @dcProgress = ABS(100 - ((CONVERT(DECIMAL(25,3),@dcMeasurementActual) * 100)/CONVERT(DECIMAL(25,3),@dcMeasurementBase)))
						END
				END
			ELSE
				BEGIN
					SET @dcProgress = 0
				END
		END
	ELSE 
		SET @dcProgress = 0
		
	IF(@dcProgress > 100)
		SET @dcProgress = 100
	
	
	-- Return the result of the function
	RETURN CONVERT(DECIMAL(9,2), @dcProgress)
END


GO



--=================================================================================================

/*
 * We are done, mark the database as a 1.12.0 database.
 */
DELETE FROM [dbo].[tbl_DatabaseInfo] 
INSERT INTO [dbo].[tbl_DatabaseInfo] 
	([majorversion], [minorversion], [releaseversion])
	VALUES (1,12,0)
GO



