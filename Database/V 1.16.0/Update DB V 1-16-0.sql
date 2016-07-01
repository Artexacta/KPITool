/* 
	Updates de the KPIDB database to version 1.16.0 
*/

Use [Master]
GO 

IF  NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'KPIDB')
	RAISERROR('KPIDB database Doesn´t exists. Create the database first',16,127)
GO

PRINT 'Updating KPIDB database to version 1.16.0'

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

IF NOT (@smiMajor = 1 AND @smiMinor = 15) 
BEGIN
	RAISERROR('KPIDB database is not in version 1.15 This program only applies to version 1.15',16,127)
	RETURN;
END

PRINT 'KPIDB Database version OK'
GO

--===================================================================================================


/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementsForChart]    Script Date: 07/01/2016 10:10:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpiMeasurementsForChart]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpiMeasurementsForChart]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiStats]    Script Date: 07/01/2016 10:10:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpiStats]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpiStats]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurements]    Script Date: 07/01/2016 10:10:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpiMeasurements]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpiMeasurements]
GO

/****** Object:  StoredProcedure [dbo].[usp_CLA_GetReportingUnitById]    Script Date: 07/01/2016 10:10:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CLA_GetReportingUnitById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CLA_GetReportingUnitById]
GO


/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementsForChart]    Script Date: 07/01/2016 10:10:21 ******/
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
 
	IF @intCategoryId IS NULL
	BEGIN
 
		SELECT @decTarget = SUM([target])
		FROM [dbo].[tbl_KPITarget]
		WHERE [kpiID] = @intKpiId
 
	END
	ELSE
	BEGIN
 
		SELECT @decTarget = [target]
		FROM [dbo].[tbl_KPITarget] t
			JOIN [dbo].[tbl_KPITargetCategories] tc ON t.[target] = tc.[targetID]
		WHERE t.[kpiID] = @intKpiId
			AND tc.[categoryID] = @intCategoryId 
			AND tc.[categoryItemID] = @intCategoryItemId   
 
	END

	SELECT @varStrategyId = [strategyID],
		@datStartDate = [startDate],
		@intTargetPeriod = ISNULL([targetPeriod],0),
		@varReportingUnit = [reportingUnitID]  
	FROM [dbo].[tbl_KPI] 
	WHERE [kpiID] = @intKpiId
 
	IF @decTarget IS NULL OR @decTarget = 0
		SET @decTarget = -1
	ELSE
	BEGIN
		
		IF @varStrategyId = 'SUM'
			SET @decTarget = @decTarget / @intTargetPeriod
		
		
	END


	DECLARE @today DATE = GETDATE()
	DECLARE @currentDate DATE = @today

	DECLARE @intReportingPeriod INT
	DECLARE @intDaysToSubstract INT
 
	SELECT @intReportingPeriod = [periodsToReport],
		   @intDaysToSubstract = [days]
	FROM [dbo].[tbl_KpiReportingPeriod]
	WHERE [reportingUnitId] = @varReportingUnit
 
	DECLARE @currentPeriod INT = @intReportingPeriod

	WHILE @currentPeriod > 0
	BEGIN

		DECLARE @from DATE = DATEADD(DAY, -@intDaysToSubstract, @currentDate)
		
		IF @datStartDate IS NOT NULL AND @varStartingTargetPeriod IS NULL
		BEGIN
		
			IF @datStartDate >= @from AND @datStartDate <= @currentDate
				SELECT @varStartingTargetPeriod = [dbo].[svf_GetReportingName](@varReportingUnit, @currentDate)
		
		END
  
		IF @varStrategyId = 'AVG'
		BEGIN
  
			IF @intCategoryId IS NULL
			BEGIN
				INSERT INTO @tabResult
				SELECT [dbo].[svf_GetReportingName](@varReportingUnit, @currentDate), [measurement], @currentPeriod
				FROM (
					SELECT ISNULL(AVG([measurement]),0) [measurement]
					FROM [dbo].[tbl_KPIMeasurements]
					WHERE [kpiID] = @intKpiId
						AND [date] BETWEEN @from AND @currentDate
						--AND 1 = CASE WHEN @datStartDate IS NULL THEN 1 ELSE
						--		CASE WHEN [date] >= @datStartDate THEN 1 ELSE 0 END
						--		END
				) tbl
			END
			ELSE
			BEGIN
   
				INSERT INTO @tabResult
				SELECT [dbo].[svf_GetReportingName](@varReportingUnit, @currentDate), [measurement], @currentPeriod
				FROM (
					SELECT ISNULL(AVG([measurement]),0) [measurement]
					FROM [dbo].[tbl_KPIMeasurements]
					WHERE [kpiID] = @intKpiId
						AND [date] BETWEEN @from AND @currentDate
						--AND 1 = CASE WHEN @datStartDate IS NULL THEN 1 ELSE
						--		CASE WHEN [date] >= @datStartDate THEN 1 ELSE 0 END
						--		END
						AND [measurmentID] IN (SELECT [measurmentID] 
												FROM [dbo].[tbl_KPIMeasurementCategories]
												WHERE [categoryID] = @intCategoryId 
												AND [categoryItemID] = @intCategoryItemId
											)
				) tbl
   
			END
		END

		IF @varStrategyId = 'SUM'
		BEGIN

			IF @intCategoryId IS NULL
			BEGIN
				INSERT INTO @tabResult
				SELECT [dbo].[svf_GetReportingName](@varReportingUnit, @currentDate),[measurement], @currentPeriod
				FROM (
					SELECT ISNULL(SUM([measurement]),0) [measurement]
					FROM [dbo].[tbl_KPIMeasurements]
					WHERE [kpiID] = @intKpiId
					AND [date] BETWEEN @from AND @currentDate
					--AND 1 = CASE WHEN @datStartDate IS NULL THEN 1 ELSE
					--		CASE WHEN [date] >= @datStartDate THEN 1 ELSE 0 END
					--END
				) tbl
			
			END		
			ELSE
			BEGIN
		
				INSERT INTO @tabResult
				SELECT [dbo].[svf_GetReportingName](@varReportingUnit, @currentDate),[measurement], @currentPeriod
				FROM (
					SELECT ISNULL(SUM([measurement]),0) [measurement]
					FROM [dbo].[tbl_KPIMeasurements]
					WHERE [kpiID] = @intKpiId
						AND [date] BETWEEN @from AND @currentDate
						--AND 1 = CASE WHEN @datStartDate IS NULL THEN 1 ELSE
						--CASE WHEN [date] >= @datStartDate THEN 1 ELSE 0 END
						--END
						AND [measurmentID] IN (SELECT [measurmentID] 
											FROM [dbo].[tbl_KPIMeasurementCategories]
											WHERE [categoryID] = @intCategoryId 
											AND [categoryItemID] = @intCategoryItemId
										)
				) tbl

			END
		END

  
		SET @currentDate = DATEADD(DAY, -1, @from)
		SET @currentPeriod = @currentPeriod - 1
	END

	SELECT [period],
		[measurement]
	FROM @tabResult
	ORDER BY [order] ASC


END




GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiStats]    Script Date: 07/01/2016 10:10:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		José Carlos Gutiérrez
-- Create date: 2016/Jun/16
-- Description:	Gets stats of a KPI
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKpiStats]
	@intKpiId			INT,
	@varCategoryId		VARCHAR(20),
	@varCategoryItemId	VARCHAR(20),
	@decCurrentValue DECIMAL(21,3) OUTPUT,
	@decLowestValue  DECIMAL(21,3) OUTPUT,
	@decMaxValue	 DECIMAL(21,3) OUTPUT,
	@decAvgValue	 DECIMAL(21,3) OUTPUT,
	@decProgress	 DECIMAL(5,2) OUTPUT,
	@decTrend	     DECIMAL(9,2) OUTPUT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @tabResult TABLE(
		[period] VARCHAR(50),
		[measurement] DECIMAL(21,3)
	) 
	
	SELECT @decTrend = [dbo].[svf_GetKpiTrend](@intKpiId)
	
	INSERT INTO @tabResult
	EXEC [dbo].[usp_KPI_GetKpiMeasurementsForChart] 
		@intKpiId, 
		@varCategoryId, 
		@varCategoryItemId, 
		0,
		0,
		''
	
	
	EXEC [dbo].[usp_KPI_GetKpiProgress] 
		@intKpiId, 
		@varCategoryId, 
		@varCategoryItemId, 
		0, 
		@decCurrentValue OUTPUT, 
		@decProgress OUTPUT
		
	--DECLARE @varStrategyId CHAR(3)
	DECLARE @varReportingUnitId CHAR(5)	

	SELECT --@varStrategyId = [strategyID],
		@varReportingUnitId = [reportingUnitId]
	FROM [dbo].[tbl_KPI] 
	WHERE [kpiID] = @intKpiId
		
	DECLARE @days INT 
	SELECT @days = p.[days]
	FROM [dbo].[tbl_KpiReportingPeriod] p
	WHERE p.[reportingUnitId] = @varReportingUnitId
	
	DECLARE @dateFrom DATE = DATEADD(DAY, -@days, GETDATE())
		
	
	--IF 	@varCategoryId = '' OR @varCategoryId IS NULL
	--BEGIN
	
		--SELECT @decMaxValue = MAX([measurement]),
		--	@decLowestValue = MIN([measurement]),
		--	@decAvgValue = AVG([measurement])
		--FROM [dbo].[tbl_KPIMeasurements]
		--WHERE [kpiID] = @intKpiId
		--	AND [date] BETWEEN @dateFrom AND GETDATE()		
	
		SELECT @decMaxValue = MAX([measurement]),
			@decLowestValue = MIN([measurement]),
			@decAvgValue = AVG([measurement])
		FROM @tabResult
	
	--END
	--ELSE
	--BEGIN
	
		--SELECT @decMaxValue = MAX([measurement]),
		--	@decLowestValue = MIN([measurement]),
		--	@decAvgValue = AVG([measurement])
		--FROM [dbo].[tbl_KPIMeasurements]
		--WHERE [kpiID] = @intKpiId
		--	AND [date] BETWEEN @dateFrom AND GETDATE()
		--	AND [measurmentID] IN (SELECT [measurmentID] FROM [dbo].[tbl_KPIMeasurementCategories] WHERE [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId)
	
	--END


END


GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurements]    Script Date: 07/01/2016 10:10:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Jose Carlos Gutierrez
-- Create date: 04/05/2016
-- Description:	Gets all measurements of KPI
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKpiMeasurements]
	@intKpiId			INT,
	@varCategoryId		VARCHAR(20),
	@varCategoryItemId	VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @varCategoryId = '' OR @varCategoryId IS NULL
	BEGIN

		SELECT [measurmentID]
		  ,[kpiID]
		  ,[date]
		  ,[measurement]
		FROM [dbo].[tbl_KPIMeasurements]
		WHERE [kpiID] = @intKpiId 
		ORDER BY [date] ASC
	END	
	ELSE
	BEGIN
	
		SELECT [measurmentID]
		  ,[kpiID]
		  ,[date]
		  ,[measurement]
		FROM [dbo].[tbl_KPIMeasurements]
		WHERE [kpiID] = @intKpiId 
			AND [measurmentID] IN ( SELECT [measurmentID] 
									FROM [dbo].[tbl_KPIMeasurementCategories]
									WHERE [categoryID] = @varCategoryId 
										AND [categoryItemID] = @varCategoryItemId)
		ORDER BY [date] ASC
	
	END

END



GO

/****** Object:  StoredProcedure [dbo].[usp_CLA_GetReportingUnitById]    Script Date: 07/01/2016 10:10:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:  Marcela Martinez
-- Create date: 26/05/2016
-- Description: Get Reporting unit by id
-- =============================================
CREATE PROCEDURE [dbo].[usp_CLA_GetReportingUnitById]
 @varReportingUnitId AS CHAR(5),
 @varLanguage CHAR(2)
AS
BEGIN
 
 SET NOCOUNT ON;

    SELECT [reportingUnitID]
    ,[name]
 FROM [dbo].[tbl_ReportingUnitLabels] 
 WHERE [language] = @varLanguage 
 AND [reportingUnitID] = @varReportingUnitId
    
END

GO




--=================================================================================================

/*
 * We are done, mark the database as a 1.16.0 database.
 */
DELETE FROM [dbo].[tbl_DatabaseInfo] 
INSERT INTO [dbo].[tbl_DatabaseInfo] 
	([majorversion], [minorversion], [releaseversion])
	VALUES (1,16,0)
GO

