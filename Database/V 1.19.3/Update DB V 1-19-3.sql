/* 
	Updates de the KPIDB database to version 1.19.3
*/

Use [Master]
GO 

IF  NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'KPIDB')
	RAISERROR('KPIDB database Doesn´t exists. Create the database first',16,127)
GO

PRINT 'Updating KPIDB database to version 1.19.3'

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

IF NOT (@smiMajor = 1 AND @smiMinor = 19) 
BEGIN
	RAISERROR('KPIDB database is not in version 1.19 This program only applies to version 1.19',16,127)
	RETURN;
END

PRINT 'KPIDB Database version OK'
GO

USE [KPIDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementsForChart]    Script Date: 08/05/2016 16:20:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpiMeasurementsForChart]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpiMeasurementsForChart]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiCategories]    Script Date: 08/05/2016 16:20:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpiCategories]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpiCategories]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementsByKpiOwner]    Script Date: 08/05/2016 16:20:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpiMeasurementsByKpiOwner]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpiMeasurementsByKpiOwner]
GO


/****** Object:  UserDefinedFunction [dbo].[svf_GetReportingName]    Script Date: 08/05/2016 16:21:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[svf_GetReportingName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[svf_GetReportingName]
GO


/****** Object:  UserDefinedFunction [dbo].[svf_GetReportingName]    Script Date: 08/05/2016 16:21:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Jose Carlos Gutierrez
-- Create date: 2016/05/18
-- Description:	Get reporting period name from date
-- =============================================
CREATE FUNCTION [dbo].[svf_GetReportingName] 
(
	@reportingUnitId CHAR(5),
	@date	DATE
)
RETURNS VARCHAR(25)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @varResult VARCHAR(25)

	DECLARE @DAY INT 
	DECLARE @MONTH INT
	DECLARE @YEAR INT
	
	SELECT @DAY = DATEPART(DAY,@DATE)
	SELECT @MONTH = DATEPART(MONTH,@DATE)
	SELECT @YEAR = DATEPART(YEAR,@DATE)

	IF @reportingUnitId = 'YEAR'
		SET @varResult = CAST(@YEAR AS VARCHAR)
		
	IF @reportingUnitId = 'MONTH'
		SET @varResult = CAST(@MONTH AS VARCHAR) + '-' + CAST(@YEAR AS VARCHAR)
		
	IF @reportingUnitId = 'DAY' OR @reportingUnitId = 'WEEK' 
		SET @varResult = CAST(@YEAR AS VARCHAR) + '-' + CAST(@MONTH AS VARCHAR) + '-' + CAST(@DAY AS VARCHAR)
		
	--IF @reportingUnitId = 'WEEK'
	--	SET @varResult = CAST(@YEAR AS VARCHAR) + '-' + CAST(@MONTH AS VARCHAR) + '-' + CAST(@DAY AS VARCHAR)
		
	IF @reportingUnitId = 'QUART'
		SET @varResult = 'Q' + CAST(DATEPART(QUARTER, @date) AS VARCHAR) + '-' + CAST(@YEAR AS VARCHAR)


	-- Return the result of the function
	RETURN @varResult

END


GO



/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementsForChart]    Script Date: 08/05/2016 16:20:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:  Jose Carlos Gutierrez
-- Create date: 2016/05/12
-- Description: Gets measurement of KPI
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKpiMeasurementsForChart]
	@intKpiId				 INT,
	@intCategoryId			 VARCHAR(20),
	@intCategoryItemId		 VARCHAR(20),
	@intFirstDayOfWeek		 INT,
	@varStrategyId			 CHAR(3) OUTPUT,
	@decTarget				 DECIMAL(21,3) OUTPUT,
	@varStartingTargetPeriod VARCHAR(50) OUTPUT
AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;
 
IF @intCategoryId = ''
	BEGIN
		SET @intCategoryId = NULL
		SET @intCategoryItemId = NULL
	END
	
	SET DATEFIRST @intFirstDayOfWeek
	
	SET @varStartingTargetPeriod = NULL

	DECLARE @datStartDate DATE 
	--DECLARE @varStrategyId CHAR(3)
	DECLARE @varReportingUnit CHAR(5)
	DECLARE @intTargetPeriod INT
	--DECLARE @decTarget DECIMAL(21,3)

	 DECLARE @tabResult TABLE(
		[period] VARCHAR(50),
		[measurement] DECIMAL(21,3),
		[order] INT
	 )
	 
	DECLARE @tblTargets AS TABLE
			(targetID INT,
			 [kpiId] INT,
			 [target] DECIMAL(21,9),
			 detalle VARCHAR(1000),
			 categories VARCHAR(1000)
	)
			 
	SELECT @varStrategyId = [strategyID],
		@datStartDate = [startDate],
		@intTargetPeriod = ISNULL([targetPeriod],0),
		@varReportingUnit = [reportingUnitID]  
	FROM [dbo].[tbl_KPI] 
	WHERE [kpiID] = @intKpiId
 
	IF @intCategoryId IS NULL
	BEGIN
	
		DECLARE @intAmountOfCategories INT
		
		SELECT @intAmountOfCategories = COUNT(*)
		FROM [dbo].[tbl_KPICategories]
		WHERE [kpiID] = @intKpiId
		
		IF @intAmountOfCategories = 0 OR @varStrategyId = 'SUM'
		BEGIN
			SELECT @decTarget = SUM([target])
			FROM [dbo].[tbl_KPITarget]
			WHERE [kpiID] = @intKpiId
		END
		ELSE
		BEGIN
		
			INSERT INTO @tblTargets
			EXEC [dbo].[usp_KPI_GetKPITargetCategoriesByKpiId] @intKpiId			
			
			SELECT @decTarget = AVG([target])
			FROM @tblTargets
			WHERE [target] <> 0			
			
		END
	END
	ELSE
	BEGIN
	
		INSERT INTO @tblTargets
		EXEC [dbo].[usp_KPI_GetKPITargetCategoriesByKpiId] @intKpiId
 
		SELECT @decTarget = [target]
		FROM @tblTargets t
		WHERE t.[detalle] = @intCategoryItemId   
 
	END

	
 
	IF @decTarget IS NULL OR @decTarget = 0
		SET @decTarget = -1
	ELSE
	BEGIN
		
		IF @varStrategyId = 'SUM'
			SET @decTarget = @decTarget / @intTargetPeriod
		
	END
	
	DECLARE  @tbl_Measurement table(
		[measurmentID] INT,
		[kpiId] INT,
		[date] DATE, 
		[measurement] DECIMAL(21,3), 
		[detalle] VARCHAR(MAX), 
		[categories] VARCHAR(MAX)
	)
	
	IF @intCategoryId IS NULL
	BEGIN
		INSERT INTO @tbl_Measurement 
		EXEC [dbo].[usp_KPI_GetKpiMeasurementCategoriesByKpiId] @intKpiId
	END
	ELSE
	BEGIN
	
		INSERT INTO @tbl_Measurement  
		SELECT m.[measurmentID],
			@intKpiId,
			[date],
			[measurement],
			null,
			null
		FROM [dbo].[tbl_KPIMeasurements] m
		WHERE [kpiID] = @intKpiId
	
	END

	DECLARE @today DATE = GETDATE()
	DECLARE @currentDate DATE = @today

	DECLARE @intReportingPeriod INT
	DECLARE @intDaysToSubstract INT
 
	SELECT @intReportingPeriod = [periodsToReport],
		   @intDaysToSubstract = [days]
	FROM [dbo].[tbl_KpiReportingPeriod]
	WHERE [reportingUnitId] = @varReportingUnit
	
	DECLARE @tblDates TABLE 
	(
		[from] DATE,
		[to] DATE
	)
	
	IF @varReportingUnit = 'DAY'
	BEGIN 
	
		INSERT INTO @tblDates
		SELECT [from], [to] FROM [dbo].[tvf_GetDatesForKpiReportingForDays](@intReportingPeriod)
	
	END
	
	IF @varReportingUnit = 'MONTH'
	BEGIN 
	
		INSERT INTO @tblDates
		SELECT [from], [to] FROM [dbo].[tvf_GetDatesForKpiReportingForMonths](@intReportingPeriod)
	
	END
	
	IF @varReportingUnit = 'WEEK'
	BEGIN 
	
		INSERT INTO @tblDates
		SELECT [from], [to] FROM [dbo].[tvf_GetDatesForKpiReportingForWeeks](@intReportingPeriod)
	
	END
	
	IF @varReportingUnit = 'QUART'
	BEGIN 
	
		INSERT INTO @tblDates
		SELECT [from], [to] FROM [dbo].[tvf_GetDatesForKpiReportingForQuarter](@intReportingPeriod)
	
	END
	
	IF @varReportingUnit = 'YEAR'
	BEGIN 
	
		INSERT INTO @tblDates
		SELECT [from], [to] FROM [dbo].[tvf_GetDatesForKpiReportingForYears](@intReportingPeriod)
	
	END
	
	DECLARE @order INT = 1
	DECLARE @currentPeriod INT = @intReportingPeriod
	DECLARE @from DATE
	DECLARE @to DATE
	
	DECLARE cDates CURSOR FOR
	SELECT [from], [to] FROM @tblDates
	ORDER BY [from]
	
	OPEN cDates
	FETCH cDates INTO @from, @to

	WHILE (@@FETCH_STATUS = 0)
	BEGIN

		
		
		--IF @varReportingUnit = 'YEAR'
		--BEGIN
		--	SET @from = null
			
		--END
		
		--IF @varReportingUnit = 'MONTH'
		--BEGIN
		--	SET @from = null
		--END 
		
		--IF @varReportingUnit = 'QUART'
		--BEGIN
		--	SET @from = null
		--END 
		
		--IF @varReportingUnit = 'WEEK'
		--BEGIN
		--	SET @from = null
		--END 
		
		--IF @varReportingUnit = 'DAY'
		--BEGIN
		--	SET @from = null
		--END 
		
		
		-- = DATEADD(DAY, -@intDaysToSubstract, @currentDate)
		
		IF @datStartDate IS NOT NULL AND @varStartingTargetPeriod IS NULL
		BEGIN
		
			IF (@datStartDate >= @from AND @datStartDate <= @to) OR @datStartDate < @from
				SELECT @varStartingTargetPeriod = [dbo].[svf_GetReportingName](@varReportingUnit, @from)
		
		END
  
		IF @varStrategyId = 'AVG'
		BEGIN
  
			IF @intCategoryId IS NULL
			BEGIN
				INSERT INTO @tabResult
				SELECT [dbo].[svf_GetReportingName](@varReportingUnit, @from), [measurement], @currentPeriod
				FROM (
					SELECT ISNULL(AVG([measurement]),0) [measurement]
					FROM @tbl_Measurement
					WHERE [date] BETWEEN @from AND @to
						AND 1 = CASE WHEN @datStartDate IS NULL THEN 1 ELSE
								CASE WHEN [date] >= @datStartDate THEN 1 ELSE 0 END
								END
				) tbl
			END
			ELSE
			BEGIN
   
				INSERT INTO @tabResult
				SELECT [dbo].[svf_GetReportingName](@varReportingUnit, @from), [measurement], @currentPeriod
				FROM (
					SELECT ISNULL(AVG([measurement]),0) [measurement]
					FROM @tbl_Measurement
					WHERE [date] BETWEEN @from AND @to
						AND 1 = CASE WHEN @datStartDate IS NULL THEN 1 ELSE
								CASE WHEN [date] >= @datStartDate THEN 1 ELSE 0 END
								END
						--AND [measurmentID] IN (SELECT [measurmentID] 
						--						FROM [dbo].[tbl_KPIMeasurementCategories]
						--						WHERE [categoryID] = @intCategoryId 
						--						AND [categoryItemID] = @intCategoryItemId
						--					)
				) tbl
   
			END
		END

		IF @varStrategyId = 'SUM'
		BEGIN

			IF @intCategoryId IS NULL
			BEGIN
				INSERT INTO @tabResult
				SELECT [dbo].[svf_GetReportingName](@varReportingUnit, @from),[measurement], @currentPeriod
				FROM (
					SELECT ISNULL(SUM([measurement]),0) [measurement]
					FROM @tbl_Measurement
					WHERE [date] BETWEEN @from AND @to
					AND 1 = CASE WHEN @datStartDate IS NULL THEN 1 ELSE
							CASE WHEN [date] >= @datStartDate THEN 1 ELSE 0 END
					END
				) tbl
			
			END		
			ELSE
			BEGIN
		
				INSERT INTO @tabResult
				SELECT [dbo].[svf_GetReportingName](@varReportingUnit, @to),[measurement], @currentPeriod
				FROM (
					SELECT ISNULL(SUM([measurement]),0) [measurement]
					FROM @tbl_Measurement
					WHERE [date] BETWEEN @from AND @to
						AND 1 = CASE WHEN @datStartDate IS NULL THEN 1 ELSE
						CASE WHEN [date] >= @datStartDate THEN 1 ELSE 0 END
						END
						--AND [measurmentID] IN (SELECT [measurmentID] 
						--					FROM [dbo].[tbl_KPIMeasurementCategories]
						--					WHERE [categoryID] = @intCategoryId 
						--					AND [categoryItemID] = @intCategoryItemId
						--				)
				) tbl

			END
		END

  
		SET @currentPeriod = @currentPeriod - 1
		
		FETCH cDates INTO @from, @to
		
	END
	
	CLOSE cDates
	DEALLOCATE cDates

	SELECT [period],
		[measurement]
	FROM @tabResult
	ORDER BY [order] DESC

 --DECLARE @tabResult TABLE ([date] DATE,[measurement] DECIMAL(21,3))
 --print @varStrategyId
 --IF @varStrategyId = 'AVG'
 --BEGIN
 -- INSERT INTO @tabResult
 -- SELECT [date], AVG([measurement])
 -- FROM [dbo].[tbl_KPIMeasurements]
 -- WHERE [kpiID] = @intKpiId
 -- GROUP BY [date]
 -- ORDER BY [date] ASC
 --END

 --IF @varStrategyId = 'SUM'
 --BEGIN
 -- INSERT INTO @tabResult
 -- SELECT [date], SUM([measurement])
 -- FROM [dbo].[tbl_KPIMeasurements]
 -- WHERE [kpiID] = @intKpiId
 -- GROUP BY [date]
 -- ORDER BY [date] ASC
 --END

 --IF @varStrategyId = 'NA'
 --BEGIN
 -- INSERT INTO @tabResult
 -- SELECT [date], [measurement]
 -- FROM [dbo].[tbl_KPIMeasurements]
 -- WHERE [kpiID] = @intKpiId
 -- ORDER BY [date] ASC
 --END


 --SELECT d.[date]
 -- ,ISNULL(r.[measurement],0) [measurement]
 --FROM @tabDates d
 -- LEFT OUTER JOIN @tabResult r  ON d.[date] = r.[date] 
 --WHERE d.[date] BETWEEN @datStartDate AND @today
END





GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiCategories]    Script Date: 08/05/2016 16:20:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:  Jose Carlos Gutierrez
-- Create date: 2016/05/27
-- Description: Get Categories used in KPI
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKpiCategories]
 @intKpiId INT
AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;


 --SELECT kc.[categoryID]
 -- ,c.[name] [categoryName]
 --FROM (
 -- SELECT DISTINCT [categoryID],
 --     [categoryItemID]
 -- FROM [dbo].[tbl_KPIMeasurementCategories] kmc 
 -- WHERE [kmc].[categoryID] IN (SELECT [categoryId] FROM [dbo].[tbl_KPICategories] WHERE [kpiID] = @intKpiId)
 -- ) kc
 -- JOIN [dbo].[tbl_Category] c ON c.[categoryID] = kc.[categoryID]
  
 
 SELECT kc.[categoryID] 
  ,c.[name] [categoryName]
  ,ci.[categoryItemID]
  ,ci.[name] [categoryItemName]
 FROM [dbo].[tbl_KPICategories] kc
  JOIN [dbo].[tbl_Category] c ON c.[categoryID] = kc.[categoryID]
  JOIN [dbo].[tbl_CategoryItem] ci ON ci.[categoryID] = c.[categoryID]
 WHERE kc.[kpiID] = @intKpiId
END



GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementsByKpiOwner]    Script Date: 08/05/2016 16:20:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Jose Carlos Gutierrez
-- Create date: 04/05/2016
-- Description:	Gets all measurements of KPI
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKpiMeasurementsByKpiOwner]
	@intOwnerId	INT,
	@varOwnerType VARCHAR(25),
	@varUserName	VARCHAR(50),
	@decMin	DECIMAL(21,3) OUTPUT,
	@decMax	DECIMAL(21,3) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @tbl_AuthorizedKPI AS TABLE([kpiId] INT,sourceObjectType VARCHAR(100))
 
	 INSERT INTO @tbl_AuthorizedKPI (kpiId, sourceObjectType)
		EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUserName
	DECLARE @tblKpiIds AS TABLE ([kpiId] INT)
	
	IF @varOwnerType = 'KPI'
	BEGIN
		INSERT INTO @tblKpiIds ([kpiId]) VALUES (@intOwnerId)
	END
	
	IF @varOwnerType = 'ACTIVITY'
	BEGIN
	
		INSERT INTO @tblKpiIds
		SELECT k.[kpiID]
		FROM [dbo].[tbl_KPI] k
			JOIN [dbo].[tbl_KPITarget] kt ON kt.[kpiID] = k.[kpiID]
		WHERE k.[activityID] = @intOwnerId
			AND k.[kpiID] IN (SELECT [kpiId] FROM @tbl_AuthorizedKPI)

	END
	
	IF @varOwnerType = 'ORGANIZATION'
	BEGIN
	
		INSERT INTO @tblKpiIds
		SELECT k.[kpiID]
		FROM [dbo].[tbl_KPI] k
			JOIN [dbo].[tbl_KPITarget] kt ON kt.[kpiID] = k.[kpiID]
		WHERE [organizationID] = @intOwnerId
			AND k.[kpiID] IN (SELECT [kpiId] FROM @tbl_AuthorizedKPI)

	END
	
	IF @varOwnerType = 'AREA'
	BEGIN
	
		INSERT INTO @tblKpiIds
		SELECT k.[kpiID]
		FROM [dbo].[tbl_KPI] k
			JOIN [dbo].[tbl_KPITarget] kt ON kt.[kpiID] = k.[kpiID]
		WHERE k.[areaID] = @intOwnerId
			AND k.[kpiID] IN (SELECT [kpiId] FROM @tbl_AuthorizedKPI)

	END
	
	IF @varOwnerType = 'PROJECT'
	BEGIN
	
		INSERT INTO @tblKpiIds
		SELECT k.[kpiID]
		FROM [dbo].[tbl_KPI] k
			JOIN [dbo].[tbl_KPITarget] kt ON kt.[kpiID] = k.[kpiID]
		WHERE k.[projectID] = @intOwnerId
			AND k.[kpiID] IN (SELECT [kpiId] FROM @tbl_AuthorizedKPI)

	END
	
	IF @varOwnerType = 'PERSON'
	BEGIN
	
		INSERT INTO @tblKpiIds
		SELECT k.[kpiID]
		FROM [dbo].[tbl_KPI] k
			JOIN [dbo].[tbl_KPITarget] kt ON kt.[kpiID] = k.[kpiID]
		WHERE k.[personID] = @intOwnerId
			AND k.[kpiID] IN (SELECT [kpiId] FROM @tbl_AuthorizedKPI)

	END
	
	--SELECT @decMax = MAX([measurement]), @decMin = MIN([measurement])
	--FROM [dbo].[tbl_KPIMeasurements]
	--WHERE [kpiID] IN (SELECT [kpiID] FROM @tblKpiIds)
	
	SET @decMax = 100
	SET @decMin = 0

    SELECT ROW_NUMBER() 
        OVER (ORDER BY [kpiID]) AS [measurmentID]
      ,[kpiID]
      ,GETDATE() [date]
      ,[dbo].[svf_GetKpiProgess]([kpiID],'','') [measurement]
	FROM @tblKpiIds
	--WHERE [kpiID] IN (SELECT distinct [kpiID]  FROM @tblKpiIds)
	ORDER BY [measurement] ASC


END


GO



--=================================================================================================

/*
 * We are done, mark the database as a 1.19.3 database.
 */
DELETE FROM [dbo].[tbl_DatabaseInfo] 
INSERT INTO [dbo].[tbl_DatabaseInfo] 
	([majorversion], [minorversion], [releaseversion])
	VALUES (1,19,3)
GO