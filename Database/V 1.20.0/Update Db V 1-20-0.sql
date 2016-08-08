/* 
	Updates de the KPIDB database to version 1.20.0
*/

Use [Master]
GO 

IF  NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'KPIDB')
	RAISERROR('KPIDB database Doesn´t exists. Create the database first',16,127)
GO

PRINT 'Updating KPIDB database to version 1.20.0'

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

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementsForChart]    Script Date: 08/08/2016 16:47:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpiMeasurementsForChart]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpiMeasurementsForChart]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPITargetCategoriesByKpiId]    Script Date: 08/08/2016 16:47:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKPITargetCategoriesByKpiId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKPITargetCategoriesByKpiId]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurements]    Script Date: 08/08/2016 16:47:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpiMeasurements]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpiMeasurements]
GO


/****** Object:  UserDefinedFunction [dbo].[tvf_GetKpiTargetForCategories]    Script Date: 08/08/2016 16:48:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tvf_GetKpiTargetForCategories]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[tvf_GetKpiTargetForCategories]
GO

/****** Object:  UserDefinedFunction [dbo].[tvf_GetKpiMeasurements]    Script Date: 08/08/2016 16:48:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tvf_GetKpiMeasurements]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[tvf_GetKpiMeasurements]
GO


/****** Object:  UserDefinedFunction [dbo].[tvf_GetKpiTargetForCategories]    Script Date: 08/08/2016 16:48:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jose Carlos Gutierrez
-- Create date: 2016/08/05
-- Description:	Gets measurements for KPI
-- =============================================
CREATE FUNCTION [dbo].[tvf_GetKpiTargetForCategories]
(	
	@intKpiId			INT
)
RETURNS  
@tblTargets TABLE(
	[targetID] INT,
	[kpiId] INT,
	[detalle] VARCHAR(1000),
	[categories] VARCHAR(1000),
	[target] DECIMAL(21,9)
)
AS
BEGIN

	DECLARE @targetID INT
	DECLARE @detalle VARCHAR(1000)
	DECLARE @categories VARCHAR(1000)
	DECLARE @valor DECIMAL(21,9)

	DECLARE target_cursor CURSOR FOR 
		SELECT DISTINCT [t].[targetID], [t].[target]
		FROM [dbo].[tbl_KPITarget] [t]
		INNER JOIN [dbo].[tbl_KPITargetCategories] [c] ON [t].[targetID] = [c].[targetID]
		WHERE [kpiID] = @intKpiId
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

		INSERT @tblTargets VALUES (@targetID, @intKpiId, @detalle, @categories, @valor)
		
		SET @detalle = ''
		
		FETCH NEXT FROM target_cursor
		INTO @targetID, @valor
	END

	CLOSE target_cursor;
	DEALLOCATE target_cursor;

	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[tvf_GetKpiMeasurements]    Script Date: 08/08/2016 16:48:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jose Carlos Gutierrez
-- Create date: 2016/08/05
-- Description:	Gets measurements for KPI
-- =============================================
CREATE FUNCTION [dbo].[tvf_GetKpiMeasurements]
(	
	@intKpiId			INT,
	@varCategoryItems	VARCHAR(50)
)
RETURNS  
@tblMeasurements TABLE(
	[measurmentID] INT,
	[kpiId] INT,
	[date] DATE, 
	[measurement] DECIMAL(21,3), 
	[detalle] VARCHAR(MAX), 
	[categories] VARCHAR(MAX)
)
AS
BEGIN

	IF @varCategoryItems IS NULL
	BEGIN
	
		INSERT INTO @tblMeasurements  
		SELECT m.[measurmentID],
			@intKpiId,
			[date],
			[measurement],
			null,
			null
		FROM [dbo].[tbl_KPIMeasurements] m
		WHERE [kpiID] = @intKpiId
		
	END
	ELSE
	BEGIN
	
		DECLARE @intMeasurementId AS INT
		DECLARE @dtDate AS DATE
		DECLARE @dcMeasurement AS DECIMAL(21,3)
		DECLARE @varDetalle AS VARCHAR(MAX)
		DECLARE @varCategories AS VARCHAR(MAX)
	    
		DECLARE MEASUREMENT_CURSOR CURSOR FOR
			SELECT [measurmentID]
			FROM [dbo].[tbl_KPIMeasurements] 
			WHERE [kpiID] = @intKpiID
			ORDER BY [date] DESC
		
		OPEN MEASUREMENT_CURSOR
		
		FETCH NEXT FROM MEASUREMENT_CURSOR INTO @intMeasurementId
		
		WHILE @@FETCH_STATUS = 0
			BEGIN
				SELECT @varDetalle = COALESCE(COALESCE(CASE WHEN @varDetalle = '' THEN '' ELSE @varDetalle + ', ' END, '') + [i].[categoryItemID], @varDetalle),
					   @varCategories = COALESCE(COALESCE(CASE WHEN @varCategories = '' THEN '' ELSE @varCategories + ', ' END, '') + [i].[categoryID], @varCategories),
					   @dtDate = [m].[date],
					   @dcMeasurement = [m].[measurement]
				FROM [dbo].[tbl_KPIMeasurements] [m]  
				LEFT OUTER JOIN [dbo].[tbl_KPIMeasurementCategories] [c] ON [m].[measurmentID] = [c].[measurementID] 
				LEFT OUTER JOIN [dbo].[tbl_CategoryItem] [i] ON [c].[categoryItemID] = [i].[categoryItemID] 
					AND [c].[categoryID] = [i].[categoryID]
				WHERE [m].[measurmentID] = @intMeasurementId 
				ORDER BY [i].[categoryID]
				
				INSERT INTO @tblMeasurements VALUES(@intMeasurementId, @intKpiId, @dtDate, @dcMeasurement, @varDetalle, @varCategories)
				
				SET @varDetalle = ''
				SET @varCategories = ''
				SET @dtDate = NULL
				SET @dcMeasurement = NULL
				
				FETCH NEXT FROM MEASUREMENT_CURSOR INTO @intMeasurementId
			END
		
		CLOSE MEASUREMENT_CURSOR;
		DEALLOCATE MEASUREMENT_CURSOR;
	    
	END		

	RETURN
END

GO


/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementsForChart]    Script Date: 08/08/2016 16:47:40 ******/
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
			SELECT [targetID],
				[kpiId],
				[target],
				[detalle],
				[categories]
			FROM [dbo].[tvf_GetKpiTargetForCategories](@intKpiId)
			
			SELECT @decTarget = AVG([target])
			FROM @tblTargets
			WHERE [target] <> 0			
			
		END
	END
	ELSE
	BEGIN
	
		INSERT INTO @tblTargets
		SELECT [targetID],
			[kpiId],
			[target],
			[detalle],
			[categories]
		FROM [dbo].[tvf_GetKpiTargetForCategories](@intKpiId)
 
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
	
	--IF @intCategoryId IS NULL
	--BEGIN
	
		INSERT INTO @tbl_Measurement  
		SELECT [measurmentID],
			[kpiId],
			[date],
			[measurement],
			[detalle],
			[categories]
		FROM [dbo].[tvf_GetKpiMeasurements](@intKpiId, @intCategoryId)
		
	--END
	--ELSE
	--BEGIN
	
		--INSERT INTO @tbl_Measurement 
		--EXEC [dbo].[usp_KPI_GetKpiMeasurementCategoriesByKpiId] @intKpiId
	
	--END

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
						AND [detalle] = @intCategoryItemId
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
						AND [detalle] = @intCategoryItemId
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

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPITargetCategoriesByKpiId]    Script Date: 08/08/2016 16:47:40 ******/
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

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurements]    Script Date: 08/08/2016 16:47:40 ******/
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
	
		DECLARE @tbl_Measurements TABLE (
			[measurmentID] INT, 
			[kpiId] INT,
			[date] DATE, 
			[measurement] DECIMAL(21,3), 
			[detalle] VARCHAR(MAX), 
			[categories] VARCHAR(MAX)
		)
		
		INSERT INTO @tbl_Measurements
		EXEC [dbo].[usp_KPI_GetKpiMeasurementCategoriesByKpiId] @intKpiId
		
		SELECT [measurmentID]
		  ,[kpiID]
		  ,[date]
		  ,[measurement]
		FROM @tbl_Measurements
		WHERE [detalle] = @varCategoryItemId
		ORDER BY [date] ASC
	
	END

END




GO




--=================================================================================================

/*
 * We are done, mark the database as a 1.20.0 database.
 */
DELETE FROM [dbo].[tbl_DatabaseInfo] 
INSERT INTO [dbo].[tbl_DatabaseInfo] 
	([majorversion], [minorversion], [releaseversion])
	VALUES (1,20,0)
GO