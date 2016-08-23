/* 
	Updates de the KPIDB database to version 1.21.0
*/

Use [Master]
GO 

IF  NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'KPIDB')
	RAISERROR('KPIDB database Doesn´t exists. Create the database first',16,127)
GO

PRINT 'Updating KPIDB database to version 1.21.0'

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

IF NOT (@smiMajor = 1 AND @smiMinor = 20) 
BEGIN
	RAISERROR('KPIDB database is not in version 1.20 This program only applies to version 1.20',16,127)
	RETURN;
END

PRINT 'KPIDB Database version OK'
GO

--=================================================================================================

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiProgress]    Script Date: 08/23/2016 16:28:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpiProgress]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpiProgress]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiStats]    Script Date: 08/23/2016 16:28:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpiStats]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpiStats]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByActivity]    Script Date: 08/23/2016 16:28:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKPIsByActivity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKPIsByActivity]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByOrganization]    Script Date: 08/23/2016 16:28:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKPIsByOrganization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKPIsByOrganization]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByProject]    Script Date: 08/23/2016 16:28:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKPIsByProject]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKPIsByProject]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByPerson]    Script Date: 08/23/2016 16:28:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKPIsByPerson]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKPIsByPerson]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsBySearch]    Script Date: 08/23/2016 16:28:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKPIsBySearch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKPIsBySearch]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementsForChart]    Script Date: 08/23/2016 16:28:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpiMeasurementsForChart]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpiMeasurementsForChart]
GO


/****** Object:  UserDefinedFunction [dbo].[svf_GetKpiTrend]    Script Date: 08/23/2016 16:30:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[svf_GetKpiTrend]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[svf_GetKpiTrend]
GO

/****** Object:  UserDefinedFunction [dbo].[svf_GetKpiProgess]    Script Date: 08/23/2016 16:30:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[svf_GetKpiProgess]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[svf_GetKpiProgess]
GO


/****** Object:  UserDefinedFunction [dbo].[svf_GetKpiTrend]    Script Date: 08/23/2016 16:30:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 23/05/2016
-- Description:	Get KPI Trend
-- =============================================
CREATE FUNCTION [dbo].[svf_GetKpiTrend]
(
	@intKpiId INT,
	@varCategoryId	VARCHAR(20),
	@varCategoryItemId	VARCHAR(20)
)
RETURNS DECIMAL(9,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @dcTrend DECIMAL(25,3)
	
	DECLARE @intParameterActual AS INT
	SELECT @intParameterActual = [value] FROM [dbo].[tbl_PAR_Parameter] WHERE [parameterID] = 2
	IF(@intParameterActual IS NULL)
		SET @intParameterActual = 3	

	DECLARE @varDirectionId AS CHAR(3)
	DECLARE @varStrategyId AS CHAR(3)
	DECLARE @varReportingUnitId AS CHAR(5)
	DECLARE @dcMeasurement AS DECIMAL(25,3)
	
	SELECT @varDirectionId = [directionID],
		   @varStrategyId = [strategyID],
		   @varReportingUnitId = [reportingUnitID]
	FROM [dbo].[tbl_KPI] 
	WHERE [kpiID] = @intKpiId
	
	DECLARE @dtToday AS DATE = GETDATE()
	DECLARE @dtYesterday AS DATE = DATEADD(DAY, -1, @dtToday)
	DECLARE @intActualData AS INT
	DECLARE @intPreviousData AS INT
	DECLARE @intActualYear AS INT = YEAR(GETDATE())
	DECLARE @intPreviousYear AS INT = @intActualYear -1
	
	DECLARE @dcMeasurementActual AS DECIMAL(25,3)
	DECLARE @dcMeasurementPrevious AS DECIMAL(25,3)
	
	IF(@varStrategyId = 'SUM')
		BEGIN
			IF(@varReportingUnitId = 'DAY')
				BEGIN
					-- calculate for today
					SELECT @dcMeasurementActual = SUM(CONVERT(DECIMAL(25,3),[measurement]))
					FROM [dbo].[tbl_KPIMeasurements] 
					WHERE [date] = @dtToday 
					AND [kpiID] = @intKpiId 
					AND CASE WHEN ISNULL(@varCategoryId,'') = '' THEN 1 
					ELSE (CASE WHEN [measurmentID] IN (SELECT [measurementID] FROM [dbo].[tbl_KPIMeasurementCategories] 
										   WHERE [kpiID] = @intKpiId 
										   AND [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId) THEN 1 ELSE 0 END) 
					END = 1
						
					
					-- calculate for yesterday
					SELECT @dcMeasurementPrevious = SUM(CONVERT(DECIMAL(25,3),[measurement]))
					FROM [dbo].[tbl_KPIMeasurements] 
					WHERE [date] = @dtYesterday 
					AND [kpiID] = @intKpiId 
					AND CASE WHEN ISNULL(@varCategoryId,'') = '' THEN 1 
					ELSE (CASE WHEN [measurmentID] IN (SELECT [measurementID] FROM [dbo].[tbl_KPIMeasurementCategories] 
										   WHERE [kpiID] = @intKpiId 
										   AND [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId) THEN 1 ELSE 0 END) 
					END = 1
						
				END
			
			IF(@varReportingUnitId = 'MONTH')
				BEGIN
					SET @intActualData = MONTH(GETDATE())
					SET @intPreviousData = MONTH(DATEADD(MONTH, -1, GETDATE()))
					SET @intPreviousYear = YEAR(DATEADD(MONTH, -1, GETDATE()))
					
					-- calculate for actual month
					SELECT @dcMeasurementActual = SUM(CONVERT(DECIMAL(25,3),[measurement]))
					FROM [dbo].[tbl_KPIMeasurements]  
					WHERE MONTH([date]) = @intActualData 
					AND YEAR([date]) = @intActualYear 
					AND [kpiID] = @intKpiId 
					AND CASE WHEN ISNULL(@varCategoryId,'') = '' THEN 1 
					ELSE (CASE WHEN [measurmentID] IN (SELECT [measurementID] FROM [dbo].[tbl_KPIMeasurementCategories] 
										   WHERE [kpiID] = @intKpiId 
										   AND [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId) THEN 1 ELSE 0 END) 
					END = 1
						
					
					-- calculate for previous month
					SELECT @dcMeasurementPrevious = SUM(CONVERT(DECIMAL(25,3),[measurement]))
					FROM [dbo].[tbl_KPIMeasurements]  
					WHERE MONTH([date]) = @intPreviousData 
					AND YEAR([date]) = @intPreviousYear 
					AND [kpiID] = @intKpiId 
					AND CASE WHEN ISNULL(@varCategoryId,'') = '' THEN 1 
					ELSE (CASE WHEN [measurmentID] IN (SELECT [measurementID] FROM [dbo].[tbl_KPIMeasurementCategories] 
										   WHERE [kpiID] = @intKpiId 
										   AND [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId) THEN 1 ELSE 0 END) 
					END = 1
						
				END
			
			IF(@varReportingUnitId = 'QUART')
				BEGIN
					SET @intActualData = DATEPART(QUARTER, GETDATE())
					SET @intPreviousData = CASE WHEN @intActualData = 4 THEN 1 ELSE @intActualData - 1 END
					SET @intPreviousYear = CASE WHEN @intActualData = 4 THEN @intActualYear - 1 ELSE @intActualYear END
					
					-- calculate for actual quart
					SELECT @dcMeasurementActual = SUM(CONVERT(DECIMAL(25,3),[measurement]))
					FROM [dbo].[tbl_KPIMeasurements]  
					WHERE DATEPART(QUARTER, [date]) = @intActualData 
					AND YEAR([date]) = @intActualYear 
					AND [kpiID] = @intKpiId 
					AND CASE WHEN ISNULL(@varCategoryId,'') = '' THEN 1 
					ELSE (CASE WHEN [measurmentID] IN (SELECT [measurementID] FROM [dbo].[tbl_KPIMeasurementCategories] 
										   WHERE [kpiID] = @intKpiId 
										   AND [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId) THEN 1 ELSE 0 END) 
					END = 1
					
					-- calculate for previous quart
					SELECT @dcMeasurementPrevious = SUM(CONVERT(DECIMAL(25,3),[measurement]))
					FROM [dbo].[tbl_KPIMeasurements]  
					WHERE DATEPART(QUARTER, [date]) = @intPreviousData 
					AND YEAR([date]) = @intPreviousYear 
					AND [kpiID] = @intKpiId 
					AND CASE WHEN ISNULL(@varCategoryId,'') = '' THEN 1 
					ELSE (CASE WHEN [measurmentID] IN (SELECT [measurementID] FROM [dbo].[tbl_KPIMeasurementCategories] 
										   WHERE [kpiID] = @intKpiId 
										   AND [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId) THEN 1 ELSE 0 END) 
					END = 1
				END
			
			IF(@varReportingUnitId = 'WEEK')
				BEGIN
					SET @intActualData = DATEPART(WEEK, GETDATE())
					SET @intPreviousData = DATEPART(WEEK,DATEADD(DAY,-7,GETDATE()))
					SET @intPreviousYear = YEAR(DATEADD(DAY,-7,GETDATE()))
					
					-- calculate for actual week
					SELECT @dcMeasurementActual = SUM(CONVERT(DECIMAL(25,3),[measurement]))
					FROM [dbo].[tbl_KPIMeasurements]  
					WHERE DATEPART(WEEK, [date]) = @intActualData 
					AND YEAR([date]) = @intActualYear 
					AND [kpiID] = @intKpiId 
					AND CASE WHEN ISNULL(@varCategoryId,'') = '' THEN 1 
					ELSE (CASE WHEN [measurmentID] IN (SELECT [measurementID] FROM [dbo].[tbl_KPIMeasurementCategories] 
										   WHERE [kpiID] = @intKpiId 
										   AND [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId) THEN 1 ELSE 0 END) 
					END = 1
					
					-- calculate for previous week
					SELECT @dcMeasurementPrevious = SUM(CONVERT(DECIMAL(25,3),[measurement]))
					FROM [dbo].[tbl_KPIMeasurements]  
					WHERE DATEPART(WEEK, [date]) = @intPreviousData 
					AND YEAR([date]) = @intPreviousYear 
					AND [kpiID] = @intKpiId 
					AND CASE WHEN ISNULL(@varCategoryId,'') = '' THEN 1 
					ELSE (CASE WHEN [measurmentID] IN (SELECT [measurementID] FROM [dbo].[tbl_KPIMeasurementCategories] 
										   WHERE [kpiID] = @intKpiId 
										   AND [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId) THEN 1 ELSE 0 END) 
					END = 1
				END
			
			IF(@varReportingUnitId = 'YEAR')
				BEGIN
					-- calculate for actual year
					SELECT @dcMeasurementActual = SUM(CONVERT(DECIMAL(25,3),[measurement]))
					FROM [dbo].[tbl_KPIMeasurements]  
					WHERE YEAR([date]) = @intActualYear 
					AND [kpiID] = @intKpiId 
					AND CASE WHEN ISNULL(@varCategoryId,'') = '' THEN 1 
					ELSE (CASE WHEN [measurmentID] IN (SELECT [measurementID] FROM [dbo].[tbl_KPIMeasurementCategories] 
										   WHERE [kpiID] = @intKpiId 
										   AND [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId) THEN 1 ELSE 0 END) 
					END = 1
					
					-- calculate for previous year
					SELECT @dcMeasurementPrevious = SUM(CONVERT(DECIMAL(25,3),[measurement]))
					FROM [dbo].[tbl_KPIMeasurements]  
					WHERE YEAR([date]) = @intPreviousYear 
					AND [kpiID] = @intKpiId 
					AND CASE WHEN ISNULL(@varCategoryId,'') = '' THEN 1 
					ELSE (CASE WHEN [measurmentID] IN (SELECT [measurementID] FROM [dbo].[tbl_KPIMeasurementCategories] 
										   WHERE [kpiID] = @intKpiId 
										   AND [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId) THEN 1 ELSE 0 END) 
					END = 1
				END
			
			IF(ISNULL(@dcMeasurementPrevious,0) = 0)
				SET @dcTrend = 0
			ELSE
				SET @dcTrend = ((ISNULL(@dcMeasurementPrevious,0) - ISNULL(@dcMeasurementActual,0)) * 100)/ISNULL(@dcMeasurementPrevious,0)
			
			IF(@varDirectionId = 'MIN')
				SET @dcTrend = @dcTrend * -1
			
		END
	
	ELSE IF(@varStrategyId = 'AVG')
		BEGIN
			DECLARE @tbl_Measurements AS TABLE([date] DATE, [measurement] DECIMAL(25,3))
			INSERT INTO @tbl_Measurements 
				SELECT [date],
					   SUM([measurement]) [measurement]
				FROM [dbo].[tbl_KPIMeasurements] 
				WHERE [kpiID] = @intKpiId 
				AND CASE WHEN ISNULL(@varCategoryId,'') = '' THEN 1 
				ELSE (CASE WHEN [measurmentID] IN (SELECT [measurementID] FROM [dbo].[tbl_KPIMeasurementCategories] 
									   WHERE [kpiID] = @intKpiId 
									   AND [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId) THEN 1 ELSE 0 END) 
				END = 1
				GROUP BY [date]
			
			DECLARE @tbl_MeasurementActual AS TABLE([measurement] DECIMAL(21,3)) 
			DECLARE @tbl_MeasurementPrevious AS TABLE([measurement] DECIMAL(21,3)) 
			
			IF(@varReportingUnitId = 'DAY')
				BEGIN
					SET @dtToday  = GETDATE()
					SET @dtYesterday = DATEADD(DAY, -1, @dtToday)
					
					-- calculate for today
					INSERT INTO @tbl_MeasurementActual
						SELECT TOP (@intParameterActual) [measurement]
						FROM @tbl_Measurements 
						WHERE [date] = @dtToday 
						ORDER BY [date] DESC
					
					-- calculate for yesterday
					INSERT INTO @tbl_MeasurementPrevious
						SELECT TOP(@intParameterActual) [measurement]
						FROM @tbl_Measurements 
						WHERE [date] = @dtYesterday
						ORDER BY [date] DESC
				END
				
			IF(@varReportingUnitId = 'MONTH')
				BEGIN
					SET @intActualData = MONTH(GETDATE())
					SET @intPreviousData = MONTH(DATEADD(MONTH, -1, GETDATE()))
					SET @intPreviousYear = YEAR(DATEADD(MONTH, -1, GETDATE()))
					
					-- calculate for actual month
					INSERT INTO @tbl_MeasurementActual
						SELECT TOP (@intParameterActual) [measurement]
						FROM @tbl_Measurements 
						WHERE MONTH([date]) = @intActualData 
						AND YEAR([date]) = @intActualYear 
						ORDER BY [date] DESC
					
					-- calculate for previous month
					INSERT INTO @tbl_MeasurementPrevious
						SELECT TOP (@intParameterActual) [measurement]
						FROM @tbl_Measurements 
						WHERE MONTH([date]) = @intPreviousData 
						AND YEAR([date]) = @intPreviousYear 
						ORDER BY [date] DESC
				END
			
			IF(@varReportingUnitId = 'QUART')
				BEGIN
					SET @intActualData = DATEPART(QUARTER, GETDATE())
					SET @intPreviousData = CASE WHEN @intActualData = 4 THEN 1 ELSE @intActualData - 1 END
					SET @intPreviousYear = CASE WHEN @intActualData = 4 THEN @intActualYear - 1 ELSE @intActualYear END
					
					-- calculate for actual quart
					INSERT INTO @tbl_MeasurementActual
						SELECT TOP (@intParameterActual) [measurement]
						FROM @tbl_Measurements 
						WHERE DATEPART(QUARTER, [date]) = @intActualData 
						AND YEAR([date]) = @intActualYear 
						ORDER BY [date] DESC
						
					-- calculate for previous quart
					INSERT INTO @tbl_MeasurementPrevious
						SELECT TOP (@intParameterActual) [measurement]
						FROM @tbl_Measurements 
						WHERE DATEPART(QUARTER, [date]) = @intPreviousData 
						AND YEAR([date]) = @intPreviousYear 
						ORDER BY [date] DESC
				END
			
			IF(@varReportingUnitId = 'WEEK')
				BEGIN
					SET @intActualData = DATEPART(WEEK, GETDATE())
					SET @intPreviousData = DATEPART(WEEK,DATEADD(DAY,-7,GETDATE()))
					SET @intPreviousYear = YEAR(DATEADD(DAY,-7,GETDATE()))
					
					-- calculate for actual week
					INSERT INTO @tbl_MeasurementActual
						SELECT TOP (@intParameterActual) [measurement]
						FROM @tbl_Measurements 
						WHERE DATEPART(WEEK, [date]) = @intActualData 
						AND YEAR([date]) = @intActualYear 
						ORDER BY [date] DESC
					
					-- calculate for previous week
					INSERT INTO @tbl_MeasurementPrevious
						SELECT TOP (@intParameterActual) [measurement]
						FROM @tbl_Measurements 
						WHERE DATEPART(WEEK, [date]) = @intPreviousData 
						AND YEAR([date]) = @intPreviousYear 
						ORDER BY [date] DESC
				END
			
			IF(@varReportingUnitId = 'YEAR')
				BEGIN
					SET @intActualYear = YEAR(GETDATE())
					SET @intPreviousYear = @intActualYear -1
					
					-- calculate for actual year
					INSERT INTO @tbl_MeasurementActual
						SELECT TOP (@intParameterActual) [measurement]
						FROM @tbl_Measurements 
						WHERE YEAR([date]) = @intActualYear 
						ORDER BY [date] DESC
					
					-- calculate for previous year
					INSERT INTO @tbl_MeasurementPrevious
						SELECT TOP (@intParameterActual) [measurement]
						FROM @tbl_Measurements 
						WHERE YEAR([date]) = @intPreviousYear 
						ORDER BY [date] DESC
				END
			
			-- calculate for actual data
			SELECT @dcMeasurementActual = AVG(CONVERT(DECIMAL(25,3),[measurement]))
			FROM @tbl_MeasurementActual
			
			-- calculate for previous data
			SELECT @dcMeasurementPrevious = AVG(CONVERT(DECIMAL(25,3),[measurement]))
			FROM @tbl_MeasurementPrevious
			
			IF(ISNULL(@dcMeasurementPrevious,0) = 0)
				SET @dcTrend = 0
			ELSE
				SET @dcTrend = ((ISNULL(@dcMeasurementPrevious,0) - ISNULL(@dcMeasurementActual,0)) * 100)/ISNULL(@dcMeasurementPrevious,0)
			
			IF(@varDirectionId = 'MIN')
				SET @dcTrend = @dcTrend * -1
		END
	
	ELSE
		SET @dcTrend = 0

	-- Return the result of the function
	RETURN CONVERT(DECIMAL(9,2), @dcTrend)

END


GO

/****** Object:  UserDefinedFunction [dbo].[svf_GetKpiProgess]    Script Date: 08/23/2016 16:30:23 ******/
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
	DECLARE @dcMeasurement AS DECIMAL(25,3)	
	
	SELECT @varDirectionId = [directionID],
		   @varStrategyId = [strategyID],
		   @dtStartDate = [startDate]
	FROM [dbo].[tbl_KPI] 
	WHERE [kpiID] = @intKpiId
	
	-- verify if exists a target
	IF ISNULL(@varCategoryId,'') = ''
		BEGIN
			IF(@varStrategyId = 'SUM')
				SELECT @dcTarget = SUM([target]) 
				FROM [dbo].[tbl_KPITarget] 
				WHERE [kpiID] = @intKpiId
				GROUP BY [kpiID]
			ELSE IF @varStrategyId = 'AVG'
				SELECT @dcTarget = AVG([target]) 
				FROM [dbo].[tbl_KPITarget] 
				WHERE [kpiID] = @intKpiId
				GROUP BY [kpiID]
		END
	ELSE
	BEGIN
		IF(@varStrategyId = 'SUM')
			SELECT @dcTarget = SUM([target]) 
			FROM [dbo].[tbl_KPITarget]
			WHERE [kpiID] = @intKpiId
			AND [targetID] IN (SELECT [targetID] FROM [dbo].[tbl_KPITargetCategories] 
								   WHERE [kpiID] = @intKpiId 
								   AND [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId)
			GROUP BY [kpiID]
		ELSE IF @varStrategyId = 'AVG'
			SELECT @dcTarget = AVG([target]) 
			FROM [dbo].[tbl_KPITarget]
			WHERE [kpiID] = @intKpiId
			AND [targetID] IN (SELECT [targetID] FROM [dbo].[tbl_KPITargetCategories] 
							   WHERE  [kpiID] = @intKpiId 
							   AND [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId)
			GROUP BY [kpiID]
	END
	
	
	IF(ISNULL(@dcTarget,0) > 0)
		BEGIN
			-- SUM Measurements registered since startDate
			IF(@varStrategyId = 'SUM')
				BEGIN
					IF ISNULL(@varCategoryId,'') = ''
						SELECT @dcMeasurement = SUM(CONVERT(DECIMAL(25,3),[measurement])) 
						FROM [dbo].[tbl_KPIMeasurements] 
						WHERE [kpiID] = @intKpiId 
						AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
								 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
							END = 1
						GROUP BY [kpiID]
					ELSE
						SELECT @dcMeasurement = SUM(CONVERT(DECIMAL(25,3),[measurement])) 
						FROM [dbo].[tbl_KPIMeasurements] 
						WHERE [kpiID] = @intKpiId 
						AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
								 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
							END = 1
						AND [measurmentID] IN (SELECT [measurementID] FROM [dbo].[tbl_KPIMeasurementCategories] 
											   WHERE [kpiID] = @intKpiId 
											   AND [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId)
						GROUP BY [kpiID]
					
					-- calculate progress
					IF(@dcMeasurement > @dcTarget)
						SET @dcProgress = 100
					ELSE
						SET @dcProgress = (CASE WHEN ISNULL(@dcMeasurement,0) = 0 THEN 0 ELSE ((CONVERT(DECIMAL(25,3),@dcMeasurement) * 100)/@dcTarget) END)
				END
				
			ELSE IF(@varStrategyId = 'AVG')
				BEGIN
					DECLARE @tbl_Measurements AS TABLE([date] DATE, [measurement] DECIMAL(25,3))
					IF ISNULL(@varCategoryId,'') = ''
						INSERT INTO @tbl_Measurements 
							SELECT [date],
								   SUM([measurement]) [measurement]
							FROM [dbo].[tbl_KPIMeasurements] 
							WHERE [kpiID] = @intKpiId 
							AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
									 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
								END = 1
							GROUP BY [date]
					ELSE
						INSERT INTO @tbl_Measurements 
							SELECT [date],
								   SUM([measurement]) [measurement]
							FROM [dbo].[tbl_KPIMeasurements] 
							WHERE [kpiID] = @intKpiId 
							AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
									 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
								END = 1
							AND [measurmentID] IN (SELECT [measurementID] FROM [dbo].[tbl_KPIMeasurementCategories] 
												   WHERE [kpiID] = @intKpiId 
												   AND [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId)
							GROUP BY [date]
					
					-- COUNT Measurements registered since startDate
					DECLARE @intCountMeasurement AS INT
					SELECT @intCountMeasurement = COUNT(*) 
					FROM @tbl_Measurements
					
					IF(ISNULL(@intCountMeasurement,0) < (@intParameterBase + @intParameterActual))
						BEGIN
							-- AVG Measurements registered since startDate
							SELECT @dcMeasurement = AVG(CONVERT(DECIMAL(25,3),[kpim].[measurement])) 
							FROM @tbl_Measurements [kpim]
						
							-- calculate progress
							IF(ISNULL(@dcMeasurement,0) = 0)
								SET @dcProgress = 0
							ELSE
								SET @dcProgress = ((CONVERT(DECIMAL(25,3),@dcMeasurement) * 100)/@dcTarget)
						END
					ELSE
						BEGIN
							DECLARE @dcMeasurementActual AS DECIMAL(25,3)
							DECLARE @dcMeasurementBase AS DECIMAL(25,3)
							DECLARE @tbl_MeasurementActual AS TABLE([date] DATE, [measurement] DECIMAL(21,3))
							DECLARE @tbl_MeasurementBase AS TABLE([date] DATE, [measurement] DECIMAL(21,3))
							
							-- AVG Measurements registered since startDate for Actual
							INSERT INTO @tbl_MeasurementActual
								SELECT TOP (@intParameterActual) [date]
									  ,[measurement]
								FROM @tbl_Measurements 
								ORDER BY [date] DESC
							
							-- AVG Measurements registered since startDate for base
							INSERT INTO @tbl_MeasurementBase
								SELECT TOP (@intParameterBase) [date]
									  ,[measurement]
								FROM @tbl_Measurements 
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



/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiProgress]    Script Date: 08/23/2016 16:28:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:  Jose Carlos Gutierrez
-- Create date: 2016/05/19
-- Description: Get KPI Progress
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKpiProgress]
	@intKpiId   INT,
	@varCategoryId  VARCHAR(20),
	@varCategoryItemId VARCHAR(20),
	@intFirstDayOfWeek	INT,
	@bitHasTarget  BIT OUTPUT,
	@decCurrentValue DECIMAL(21,3) OUTPUT,
	@decProgress  DECIMAL(5,2) OUTPUT
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

	IF  @varCategoryId = '' OR @varCategoryId IS NULL
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
		
	DECLARE @tabResult TABLE(
		[id] INT IDENTITY(1,1),
		[period] VARCHAR(50),
		[measurement] DECIMAL(21,3)
	) 
	
	SELECT @decProgress = [dbo].[svf_GetKpiProgess](@intKpiId, @varCategoryId, @varCategoryItemId)
	
	INSERT INTO @tabResult ([period], [measurement])
	EXEC [dbo].[usp_KPI_GetKpiMeasurementsForChart] 
		@intKpiId, 
		@varCategoryId, 
		@varCategoryItemId, 
		@intFirstDayOfWeek,
		0,
		0,
		'',
		''
		
	SELECT TOP 1 @decCurrentValue = [measurement]
		FROM @tabResult
		ORDER BY [id] DESC
 
    
END



GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiStats]    Script Date: 08/23/2016 16:28:25 ******/
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
	@intFirstDayOfWeek	INT,
	@decCurrentValue DECIMAL(21,3) OUTPUT,
	@decLowestValue  DECIMAL(21,3) OUTPUT,
	@decMaxValue	 DECIMAL(21,3) OUTPUT,
	@decAvgValue	 DECIMAL(21,3) OUTPUT,
	@decProgress	 DECIMAL(5,2) OUTPUT,
	@decTrend	     DECIMAL(9,2) OUTPUT
	
AS
BEGIN
	
	SET NOCOUNT ON;
	
	DECLARE @tabResult TABLE(
		[id] INT IDENTITY(1,1),
		[period] VARCHAR(50),
		[measurement] DECIMAL(21,3)
	) 
	
	SELECT @decTrend = [dbo].[svf_GetKpiTrend](@intKpiId, @varCategoryId, @varCategoryItemId)
	
	INSERT INTO @tabResult ([period], [measurement])
	EXEC [dbo].[usp_KPI_GetKpiMeasurementsForChart] 
		@intKpiId, 
		@varCategoryId, 
		@varCategoryItemId, 
		@intFirstDayOfWeek,
		0,
		0,
		'',
		''	
	
	EXEC [dbo].[usp_KPI_GetKpiProgress] 
		@intKpiId, 
		@varCategoryId, 
		@varCategoryItemId, 
		@intFirstDayOfWeek,
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

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByActivity]    Script Date: 08/23/2016 16:28:25 ******/
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
	 @varUserName AS VARCHAR(50),
	 @intFirstDayOfWeek	INT
AS
BEGIN
	
	SET NOCOUNT ON;
	
	SET DATEFIRST @intFirstDayOfWeek
	
    CREATE TABLE #tbl_KPI
		(kpiId INT,
		 sourceObjectType VARCHAR(100))

	INSERT INTO #tbl_KPI (kpiId, sourceObjectType)
	EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUsername
	
    SELECT DISTINCT [k].[kpiID]
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
		  ,[dbo].[svf_GetKpiTrend]([k].[kpiID], '', '') [trend]
	FROM [dbo].[tbl_KPI] [k] 
	INNER JOIN #tbl_KPI [kpi] ON [k].[kpiID] = [kpi].[kpiId] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID] 
	LEFT OUTER JOIN [dbo].[tbl_Activity] [ac] ON [k].[activityID] = [ac].[activityID] 
	LEFT OUTER JOIN [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID] 
	WHERE [k].[activityID] = @intActivityId
	AND [o].[deleted] = 0
	and case when k.projectID Is not null then
				 case when p.deleted = 0 then 1 else 0 end
				 else 1
			end = 1
	and case when k.personID Is not null then
			 case when pe.deleted = 0 then 1 else 0 end
			 else 1
		end = 1
	and case when k.activityID Is not null then
			 case when ac.deleted = 0 then 1 else 0 end
			 else 1
		end = 1
	
	DROP TABLE #tbl_KPI
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByOrganization]    Script Date: 08/23/2016 16:28:25 ******/
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
	 @varUserName AS VARCHAR(50),
	 @intFirstDayOfWeek	INT
AS
BEGIN
	
	SET NOCOUNT ON;
	
	SET DATEFIRST @intFirstDayOfWeek
	
	CREATE TABLE #tbl_KPI
		(kpiId INT,
		 sourceObjectType VARCHAR(100))

	INSERT INTO #tbl_KPI (kpiId, sourceObjectType)
	EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUsername
	
    SELECT DISTINCT [k].[kpiID]
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
		  ,[dbo].[svf_GetKpiProgess]([k].[kpiID], '', '') [progress]
		  ,[dbo].[svf_GetKpiTrend]([k].[kpiID], '', '') [trend]
	FROM [dbo].[tbl_KPI] [k] 
	INNER JOIN #tbl_KPI [kpi] ON [k].[kpiID] = [kpi].[kpiId] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID] 
	LEFT OUTER JOIN [dbo].[tbl_Activity] [ac] ON [k].[activityID] = [ac].[activityID] 
	LEFT OUTER JOIN [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID] 
	WHERE [k].[organizationID] = @intOrganizationId
	  AND [o].[deleted] = 0
	  AND CASE WHEN [k].[projectID] IS NOT NULL THEN
				CASE WHEN [p].[deleted] = 0 THEN 1 ELSE 0 END
			   ELSE 1
		  END = 1
	  AND CASE WHEN [k].[activityID] IS NOT NULL THEN
				CASE WHEN [ac].[deleted] = 0 THEN 1 ELSE 0 END
			   ELSE 1
		  END = 1
      AND CASE WHEN [k].[personID] IS NOT NULL THEN
				CASE WHEN [pe].[deleted] = 0 THEN 1 ELSE 0 END
			   ELSE 1
		  END = 1
    
    DROP TABLE #tbl_KPI
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByProject]    Script Date: 08/23/2016 16:28:25 ******/
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
	@varUserName AS VARCHAR(50),
	@intFirstDayOfWeek	INT
AS
BEGIN
	
	SET NOCOUNT ON;
	
	SET DATEFIRST @intFirstDayOfWeek
	
	CREATE TABLE #tbl_KPI
		(kpiId INT,
		 sourceObjectType VARCHAR(100))

	INSERT INTO #tbl_KPI (kpiId, sourceObjectType)
	EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUsername
	
    SELECT DISTINCT [k].[kpiID]
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
		  ,[dbo].[svf_GetKpiProgess]([k].[kpiID], '', '') [progress]
		  ,[dbo].[svf_GetKpiTrend]([k].[kpiID], '', '') [trend]
	FROM [dbo].[tbl_KPI] [k] 
	INNER JOIN #tbl_KPI [kpi] ON [k].[kpiID] = [kpi].[kpiId] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID] 
	LEFT OUTER JOIN [dbo].[tbl_Activity] [ac] ON [k].[activityID] = [ac].[activityID] 
	LEFT OUTER JOIN [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID]
	WHERE [k].[projectID] = @intProjectId
	AND [o].[deleted] = 0
	AND CASE WHEN [k].[projectID] IS NOT NULL THEN 
	         CASE WHEN [p].[deleted] = 0 THEN 1 ELSE 0 END
	         ELSE 1
	    END = 1
	AND CASE WHEN [k].[activityID] IS NOT NULL THEN 
	         CASE WHEN [ac].[deleted] = 0 THEN 1 ELSE 0 END
	         ELSE 1
	    END = 1
	AND CASE WHEN [k].[personID] IS NOT NULL THEN 
	         CASE WHEN [pe].[deleted] = 0 THEN 1 ELSE 0 END
	         ELSE 1
	    END = 1
    
    DROP TABLE #tbl_KPI
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByPerson]    Script Date: 08/23/2016 16:28:25 ******/
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
	 @varUserName AS VARCHAR(50),
	 @intFirstDayOfWeek	INT
AS
BEGIN
	
	SET NOCOUNT ON;
	
	SET DATEFIRST @intFirstDayOfWeek
	
	CREATE TABLE #tbl_KPI
		(kpiId INT,
		 sourceObjectType VARCHAR(100))

	INSERT INTO #tbl_KPI (kpiId, sourceObjectType)
	EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUsername
	
    SELECT DISTINCT [k].[kpiID]
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
		  ,[dbo].[svf_GetKpiProgess]([k].[kpiID], '', '') [progress]
		  ,[dbo].[svf_GetKpiTrend]([k].[kpiID], '', '') [trend]
	FROM [dbo].[tbl_KPI] [k] 
	INNER JOIN #tbl_KPI [kpi] ON [k].[kpiID] = [kpi].[kpiId] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID]
	LEFT OUTER JOIN [dbo].[tbl_Activity] [ac] ON [k].[activityID] = [ac].[activityID] 
	LEFT OUTER JOIN [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID]
	WHERE [k].[personID] = @intPersonId   
	AND [o].[deleted] = 0
	and case when k.projectID Is not null then
				 case when p.deleted = 0 then 1 else 0 end
				 else 1
			end = 1
	and case when k.personID Is not null then
			 case when pe.deleted = 0 then 1 else 0 end
			 else 1
		end = 1
	and case when k.activityID Is not null then
			 case when ac.deleted = 0 then 1 else 0 end
			 else 1
		end = 1
	
    DROP TABLE #tbl_KPI
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsBySearch]    Script Date: 08/23/2016 16:28:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---- =============================================
-- Author:		Ivan Krsul
-- Create date: May 5 2016
-- Description:	List all KPIs in the system by Search
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKPIsBySearch]
	@varUserName VARCHAR(50),
	@varWhereClause VARCHAR(MAX),
	@intFirstDayOfWeek	INT
AS
BEGIN
	
	SET NOCOUNT ON;
	
	SET DATEFIRST @intFirstDayOfWeek
	
	CREATE TABLE #tblKPI
		(kpiId INT,
		 sourceObjectType VARCHAR(100),
		 isOwner INT DEFAULT(1))

	INSERT INTO #tblKPI (kpiId, sourceObjectType)
	EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUsername
	
	UPDATE #tblKPI
	SET isOwner = 0
	WHERE sourceObjectType IN ('KPI-PUB VIEW (11)','KPI-VIEW (12)')
	
	DECLARE @varSQL VARCHAR(MAX)

	SET @varSQL = 'SELECT [k].[kpiID]
				  ,[k].[name]
				  ,[k].[organizationID]
				  ,[o].[name] organizationName
				  ,[k].[areaID]
				  ,[a].[name] areaName
				  ,[k].[projectID]
				  ,[p].[name] projectName
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
				  ,[dbo].[svf_GetKpiProgess]([k].[kpiID], '''', '''') [progress]
				  ,[dbo].[svf_GetKpiTrend]([k].[kpiID], '''', '''') [trend]
				  ,CASE WHEN ISNULL([tk].[isOwner],0) > 0 THEN 1 ELSE 0 END isOwner
			  FROM [dbo].[tbl_KPI] [k]
			  INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID]
			  LEFT JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID]
			  LEFT JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID]
			  INNER JOIN (
						  SELECT kpiId, SUM(isOwner) as isOwner
						  FROM #tblKPI
						  GROUP BY kpiId) [tk] ON [k].[KPIId] = [tk].[KPIId]
			  WHERE ' + @varWhereClause
			  
	 EXEC (@varSQL)
	 
	 DROP TABLE #tblKPI
	 
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementsForChart]    Script Date: 08/23/2016 16:28:25 ******/
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
	@varStartingTargetPeriod VARCHAR(50) OUTPUT,
	@varEndTargetPeriod		 VARCHAR(50) OUTPUT
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
	DECLARE @datEndDateForTarget DATE 
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

	
 
	IF @decTarget IS NULL OR @decTarget = 0 OR ISNULL(@intTargetPeriod,0) = 0
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
	
	IF @datStartDate IS NOT NULL
	BEGIN
	
		IF @varReportingUnit = 'DAY'
		BEGIN
			SET @datEndDateForTarget = DATEADD(DAY, @intTargetPeriod,@datStartDate)
		END
		
		IF @varReportingUnit = 'MONTH'
		BEGIN 		
			
			--Getting first day of moth for start date
			SET @datEndDateForTarget = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@datStartDate)-1),@datStartDate),101)
			--Adding months according to periods
			SET @datEndDateForTarget = DATEADD(MONTH, @intTargetPeriod,@datEndDateForTarget)
		
		END
		
		IF @varReportingUnit = 'WEEK'
		BEGIN 
		
			SET @datEndDateForTarget = DATEADD(dd, -(DATEPART(dw, @datStartDate)-1), @datStartDate)
			SET @datEndDateForTarget = DATEADD(WEEK, @intTargetPeriod, @datEndDateForTarget)
		
		END
		
		IF @varReportingUnit = 'QUART'
		BEGIN 
		
			SET @datEndDateForTarget = DATEADD(q, DATEDIFF(q, 0, @datStartDate), 0) 
			SET @datEndDateForTarget = DATEADD(q, @intTargetPeriod, @datEndDateForTarget)
		
		END
		
		IF @varReportingUnit = 'YEAR'
		BEGIN 
		
			SET @datEndDateForTarget = DATEADD(yy, DATEDIFF(yy,0,@datStartDate), 0)
			SET @datEndDateForTarget = DATEADD(yy, @intTargetPeriod, @datEndDateForTarget)
		
		END
		
		SELECT @varEndTargetPeriod = [dbo].[svf_GetReportingName](@varReportingUnit, @datEndDateForTarget)
				
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
		
			IF (@datStartDate >= @from AND @datStartDate <= @to)
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
						AND 1 = CASE WHEN @datStartDate IS NULL OR @varReportingUnit = 'DAY' THEN 1 ELSE
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
						AND 1 = CASE WHEN @datStartDate IS NULL OR @varReportingUnit = 'DAY' THEN 1 ELSE
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
					AND 1 = CASE WHEN @datStartDate IS NULL OR @varReportingUnit = 'DAY' THEN 1 ELSE
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
						AND 1 = CASE WHEN @datStartDate IS NULL OR @varReportingUnit = 'DAY' THEN 1 ELSE
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




--=================================================================================================

/*
 * We are done, mark the database as a 1.20.0 database.
 */
DELETE FROM [dbo].[tbl_DatabaseInfo] 
INSERT INTO [dbo].[tbl_DatabaseInfo] 
	([majorversion], [minorversion], [releaseversion])
	VALUES (1,20,0)
GO