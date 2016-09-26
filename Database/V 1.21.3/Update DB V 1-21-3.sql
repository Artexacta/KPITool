USE [KPIDB]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_UserTour_tbl_SEG_User]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_UserTour]'))
ALTER TABLE [dbo].[tbl_UserTour] DROP CONSTRAINT [FK_tbl_UserTour_tbl_SEG_User]
GO

ALTER TABLE [dbo].[tbl_UserTour]  WITH CHECK ADD  CONSTRAINT [FK_tbl_UserTour_tbl_SEG_User] FOREIGN KEY([userId])
REFERENCES [dbo].[tbl_SEG_User] ([userId])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[tbl_UserTour] CHECK CONSTRAINT [FK_tbl_UserTour_tbl_SEG_User]
GO

/****** Object:  UserDefinedFunction [dbo].[svf_GetReportingName]    Script Date: 09/26/2016 11:16:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[svf_GetReportingName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[svf_GetReportingName]
GO

/****** Object:  UserDefinedFunction [dbo].[svf_GetKpiProgess]    Script Date: 09/26/2016 11:16:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[svf_GetKpiProgess]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[svf_GetKpiProgess]
GO

/****** Object:  UserDefinedFunction [dbo].[svf_GetKpiTrend]    Script Date: 09/26/2016 11:16:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[svf_GetKpiTrend]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[svf_GetKpiTrend]
GO

/****** Object:  UserDefinedFunction [dbo].[svf_GetReportingName]    Script Date: 09/26/2016 11:16:50 ******/
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
		
	IF @reportingUnitId = 'DAY'
		SET @varResult = CAST(@YEAR AS VARCHAR) + '-' + CAST(@MONTH AS VARCHAR) + '-' + CAST(@DAY AS VARCHAR)
		
	IF @reportingUnitId = 'WEEK'
		SET @varResult = CAST(DATEPART(WEEK,@date) AS VARCHAR) + '-' + CAST(@YEAR AS VARCHAR)
		
	IF @reportingUnitId = 'QUART'
		SET @varResult = 'Q' + CAST(DATEPART(QUARTER, @date) AS VARCHAR) + '-' + CAST(@YEAR AS VARCHAR)


	-- Return the result of the function
	RETURN @varResult

END



GO

/****** Object:  UserDefinedFunction [dbo].[svf_GetKpiProgess]    Script Date: 09/26/2016 11:16:50 ******/
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
	DECLARE @varReportingUnitId AS CHAR(5)
	DECLARE @dcMeasurement AS DECIMAL(25,3)	
	
	SELECT @varDirectionId = [directionID],
		   @varStrategyId = [strategyID],
		   @varReportingUnitId = [reportingUnitID],
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
					
					DECLARE @dcPromedioBase AS DECIMAL(25,3)
					DECLARE @dcMeasurementActual AS DECIMAL(25,3)
					
					-- Promedio Base de los X valores mas altos
					DECLARE @tbl_Measurements AS TABLE([date] DATE, [measurement] DECIMAL(25,3))
					IF ISNULL(@varCategoryId,'') = ''
						INSERT INTO @tbl_Measurements 
							SELECT [date],
								   [measurement]
							FROM [dbo].[tbl_KPIMeasurements] 
							WHERE [kpiID] = @intKpiId 
							AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
									 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
								END = 1
					ELSE
						INSERT INTO @tbl_Measurements 
							SELECT [date],
								   [measurement]
							FROM [dbo].[tbl_KPIMeasurements] 
							WHERE [kpiID] = @intKpiId 
							AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
									 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
								END = 1
							AND [measurmentID] IN (SELECT [measurementID] FROM [dbo].[tbl_KPIMeasurementCategories] 
												   WHERE [kpiID] = @intKpiId 
												   AND [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId)
					
					IF((SELECT COUNT(*) FROM @tbl_Measurements) <= @intParameterBase)
						BEGIN
							
							SELECT @dcMeasurementActual = AVG([measurement])
							FROM @tbl_Measurements
							
							SET @dcProgress = ((CONVERT(DECIMAL(25,3),@dcMeasurementActual) * 100)/@dcTarget)
							
						END
					ELSE
						BEGIN
							SELECT @dcPromedioBase = AVG([m].[measurement]) 
							FROM (SELECT TOP (@intParameterBase) 
										[measurement]
								  FROM [dbo].[tbl_KPIMeasurements] 
								  WHERE [kpiID] = @intKpiId 
								  ORDER BY [measurement] DESC) [m] 
							
							-- Measurements por reportingUnit
							DECLARE @dtFechaUltima AS DATE
							
							SELECT TOP 1 @dtFechaUltima = [date] 
							FROM @tbl_Measurements 
							ORDER BY [date] DESC
							
							IF(@varReportingUnitId = 'DAY')
								SELECT @dcMeasurementActual = AVG([measurement]) 
								FROM @tbl_Measurements 
								WHERE [date] = @dtFechaUltima
								
							IF(@varReportingUnitId = 'MONTH')
								SELECT @dcMeasurementActual = AVG([measurement]) 
								FROM @tbl_Measurements 
								WHERE MONTH([date]) = MONTH(@dtFechaUltima) 
							
							IF(@varReportingUnitId = 'QUART')
								SELECT @dcMeasurementActual = AVG([measurement]) 
								FROM @tbl_Measurements 
								WHERE DATEPART(QUARTER, [date]) = DATEPART(QUARTER, @dtFechaUltima) 
							
							IF(@varReportingUnitId = 'WEEK')
								SELECT @dcMeasurementActual = AVG([measurement]) 
								FROM @tbl_Measurements 
								WHERE DATEPART(WEEK, [date]) = DATEPART(WEEK, @dtFechaUltima) 
							
							IF(@varReportingUnitId = 'YEAR')
								SELECT @dcMeasurementActual = AVG([measurement]) 
								FROM @tbl_Measurements 
								WHERE YEAR([date]) = YEAR(@dtFechaUltima) 
							
							IF(@varDirectionId = 'MIN')
								SET @dcProgress = ABS(100 - (((@dcMeasurementActual - @dcTarget) *100) / (@dcPromedioBase - @dcTarget)))
							ELSE
								SET @dcProgress = ABS(100 - (((@dcPromedioBase - @dcTarget)  *100) / (@dcMeasurementActual - @dcTarget)))
								
						END
					
				END
			ELSE
				BEGIN
					SET @dcProgress = 0
				END
		END
	ELSE 
		SET @dcProgress = 0
	
	IF(@dcProgress < 0)
		SET @dcProgress = 0
	
	IF(@dcProgress > 100)
		SET @dcProgress = 100
	
	
	-- Return the result of the function
	RETURN CONVERT(DECIMAL(9,2), ISNULL(@dcProgress,0))
END





GO

/****** Object:  UserDefinedFunction [dbo].[svf_GetKpiTrend]    Script Date: 09/26/2016 11:16:50 ******/
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
					   [measurement]
				FROM [dbo].[tbl_KPIMeasurements] 
				WHERE [kpiID] = @intKpiId 
				AND CASE WHEN ISNULL(@varCategoryId,'') = '' THEN 1 
				ELSE (CASE WHEN [measurmentID] IN (SELECT [measurementID] FROM [dbo].[tbl_KPIMeasurementCategories] 
									   WHERE [kpiID] = @intKpiId 
									   AND [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId) THEN 1 ELSE 0 END) 
				END = 1
			
			DECLARE @tbl_MeasurementActual AS TABLE([measurement] DECIMAL(21,3)) 
			DECLARE @tbl_MeasurementPrevious AS TABLE([measurement] DECIMAL(21,3)) 
			
			IF(@varReportingUnitId = 'DAY')
				BEGIN
					SET @dtToday  = GETDATE()
					SET @dtYesterday = DATEADD(DAY, -1, @dtToday)
					
					-- calculate for today
					INSERT INTO @tbl_MeasurementActual
						SELECT [measurement]
						FROM @tbl_Measurements 
						WHERE [date] = @dtToday 
						ORDER BY [date] DESC
					
					-- calculate for yesterday
					INSERT INTO @tbl_MeasurementPrevious
						SELECT [measurement]
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
						SELECT [measurement]
						FROM @tbl_Measurements 
						WHERE MONTH([date]) = @intActualData 
						AND YEAR([date]) = @intActualYear 
						ORDER BY [date] DESC
					
					-- calculate for previous month
					INSERT INTO @tbl_MeasurementPrevious
						SELECT [measurement]
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
						SELECT [measurement]
						FROM @tbl_Measurements 
						WHERE DATEPART(QUARTER, [date]) = @intActualData 
						AND YEAR([date]) = @intActualYear 
						ORDER BY [date] DESC
						
					-- calculate for previous quart
					INSERT INTO @tbl_MeasurementPrevious
						SELECT [measurement]
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
						SELECT [measurement]
						FROM @tbl_Measurements 
						WHERE DATEPART(WEEK, [date]) = @intActualData 
						AND YEAR([date]) = @intActualYear 
						ORDER BY [date] DESC
					
					-- calculate for previous week
					INSERT INTO @tbl_MeasurementPrevious
						SELECT [measurement]
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
						SELECT [measurement]
						FROM @tbl_Measurements 
						WHERE YEAR([date]) = @intActualYear 
						ORDER BY [date] DESC
					
					-- calculate for previous year
					INSERT INTO @tbl_MeasurementPrevious
						SELECT [measurement]
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
	RETURN CONVERT(DECIMAL(9,2), ISNULL(@dcTrend,0))

END



GO


--=================================================================================================

/*
 * We are done, mark the database as a 1.21.3 database.
 */
DELETE FROM [dbo].[tbl_DatabaseInfo] 
INSERT INTO [dbo].[tbl_DatabaseInfo] 
	([majorversion], [minorversion], [releaseversion])
	VALUES (1,21,3)
GO