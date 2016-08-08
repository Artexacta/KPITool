USE [KPIDB]
GO

/****** Object:  UserDefinedFunction [dbo].[svf_GetKpiProgess]    Script Date: 08/08/2016 17:41:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[svf_GetKpiProgess]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[svf_GetKpiProgess]
GO

/****** Object:  UserDefinedFunction [dbo].[svf_GetKpiProgess]    Script Date: 08/08/2016 17:41:50 ******/
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
					-- COUNT Measurements registered since startDate
					DECLARE @intCountMeasurement AS INT
					
					IF ISNULL(@varCategoryId,'') = ''
						SELECT @intCountMeasurement = COUNT(*) 
						FROM [dbo].[tbl_KPIMeasurements] 
						WHERE [kpiID] = @intKpiId 
						AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
								 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
							END = 1
					ELSE
						SELECT @intCountMeasurement = COUNT(*) 
						FROM [dbo].[tbl_KPIMeasurements] 
						WHERE [kpiID] = @intKpiId 
						AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
								 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
							END = 1
						AND [measurmentID] IN (SELECT [measurementID] FROM [dbo].[tbl_KPIMeasurementCategories] 
										       WHERE [kpiID] = @intKpiId 
										       AND [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId)
					
					IF(ISNULL(@intCountMeasurement,0) < (@intParameterBase + @intParameterActual))
						BEGIN
							-- AVG Measurements registered since startDate
							IF ISNULL(@varCategoryId,'') = ''
								SELECT @dcMeasurement = AVG(CONVERT(DECIMAL(25,3),[kpim].[measurement])) 
								FROM (SELECT TOP (@intParameterActual) * 
									  FROM [dbo].[tbl_KPIMeasurements] 
									  WHERE [kpiID] = @intKpiId 
									  AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
											   CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
										  END = 1 
									  ORDER BY [measurmentID] DESC) [kpim] 
								GROUP BY [kpim].[kpiID]
							ELSE
								SELECT @dcMeasurement = AVG(CONVERT(DECIMAL(25,3),[kpim].[measurement])) 
								FROM (SELECT TOP (@intParameterActual) * 
									  FROM [dbo].[tbl_KPIMeasurements] 
									  WHERE [kpiID] = @intKpiId 
									  AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
											   CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
										  END = 1 
									  AND [measurmentID] IN (SELECT [measurementID] FROM [dbo].[tbl_KPIMeasurementCategories] 
														     WHERE [kpiID] = @intKpiId 
														     AND [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId)
									  ORDER BY [measurmentID] DESC) [kpim] 
								GROUP BY [kpim].[kpiID]
						
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
							
							IF ISNULL(@varCategoryId,'') = ''
								BEGIN
									-- AVG Measurements registered since startDate for Actual
									INSERT INTO @tbl_MeasurementActual
										SELECT TOP (@intParameterActual) [date]
											  ,[measurement]
										FROM [dbo].[tbl_KPIMeasurements] 
										WHERE [kpiID] = @intKpiId 
										AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
												 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
											END = 1
										ORDER BY [measurmentID] DESC
									
									-- AVG Measurements registered since startDate for base
									INSERT INTO @tbl_MeasurementBase
										SELECT TOP (@intParameterBase) [date]
											  ,[measurement]
										FROM [dbo].[tbl_KPIMeasurements] 
										WHERE [kpiID] = @intKpiId 
										AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
												 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
											END = 1
										ORDER BY [measurmentID] ASC
								END
							ELSE
								BEGIN
									-- AVG Measurements registered since startDate for Actual
									INSERT INTO @tbl_MeasurementActual
										SELECT TOP (@intParameterActual) [date]
											  ,[measurement]
										FROM [dbo].[tbl_KPIMeasurements] 
										WHERE [kpiID] = @intKpiId 
										AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
												 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
											END = 1 
										AND [measurmentID] IN (SELECT [measurementID] FROM [dbo].[tbl_KPIMeasurementCategories] 
															   WHERE [kpiID] = @intKpiId 
														       AND [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId)
										ORDER BY [measurmentID] DESC
									
									-- AVG Measurements registered since startDate for base
									INSERT INTO @tbl_MeasurementBase
										SELECT TOP (@intParameterBase) [date]
											  ,[measurement]
										FROM [dbo].[tbl_KPIMeasurements] 
										WHERE [kpiID] = @intKpiId 
										AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
												 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
											END = 1 
										AND [measurmentID] IN (SELECT [measurementID] FROM [dbo].[tbl_KPIMeasurementCategories] 
														       WHERE [kpiID] = @intKpiId 
														       AND [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId)
										ORDER BY [measurmentID] ASC
								END
							
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


/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementCategoriesByKpiId]    Script Date: 08/08/2016 17:41:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpiMeasurementCategoriesByKpiId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpiMeasurementCategoriesByKpiId]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_UpdateKPI]    Script Date: 08/08/2016 17:41:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_UpdateKPI]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_UpdateKPI]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementCategoriesByKpiId]    Script Date: 08/08/2016 17:41:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =================================================
-- Author:		Marcela Martinez
-- Create date: 30/05/2016
-- Description:	Get MeasurementCategories by kpiId
-- =================================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKpiMeasurementCategoriesByKpiId]
	@intKpiId INT,
	@varCategoryId VARCHAR(20),
	@varCategoryItemId VARCHAR(20)
AS
BEGIN
	
	SET NOCOUNT ON;

    CREATE TABLE #tbl_Measurement([measurmentID] INT, [date] DATE, [measurement] DECIMAL(21,3), [detalle] VARCHAR(MAX), [categories] VARCHAR(MAX))
    
    DECLARE @intMeasurementId AS INT
    DECLARE @dtDate AS DATE
	DECLARE @dcMeasurement AS DECIMAL(21,3)
    DECLARE @varDetalle AS VARCHAR(MAX)
    DECLARE @varCategories AS VARCHAR(MAX)
    
	IF ISNULL(@varCategoryId,'') = ''
		DECLARE MEASUREMENT_CURSOR CURSOR FOR
			SELECT [measurmentID]
			FROM [dbo].[tbl_KPIMeasurements] 
			WHERE [kpiID] = @intKpiID 
			ORDER BY [date] DESC 
	ELSE
		DECLARE MEASUREMENT_CURSOR CURSOR FOR
			SELECT [measurmentID]
			FROM [dbo].[tbl_KPIMeasurements] 
			WHERE [kpiID] = @intKpiID 
			AND [measurmentID] IN (SELECT [measurementID] FROM [dbo].[tbl_KPIMeasurementCategories] 
								   WHERE [kpiID] = @intKpiId 
								   AND [categoryID] = @varCategoryId AND [categoryItemID] = @varCategoryItemId)
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
				AND [c].[categoryID] = CASE WHEN ISNULL(@varCategoryId,'') = '' THEN [c].[categoryID] ELSE @varCategoryId END 
				AND [c].[categoryItemID] = CASE WHEN ISNULL(@varCategoryItemId,'') = '' THEN [c].[categoryItemID] ELSE @varCategoryItemId END 
			WHERE [m].[measurmentID] = @intMeasurementId 
			ORDER BY [i].[categoryID]
			
			INSERT INTO #tbl_Measurement VALUES(@intMeasurementId, @dtDate, @dcMeasurement, @varDetalle, @varCategories)
			
			SET @varDetalle = ''
			SET @varCategories = ''
			SET @dtDate = NULL
			SET @dcMeasurement = NULL
			
			FETCH NEXT FROM MEASUREMENT_CURSOR INTO @intMeasurementId
		END
	
	CLOSE MEASUREMENT_CURSOR;
	DEALLOCATE MEASUREMENT_CURSOR;
    
    SELECT [measurmentID]
		  ,@intKpiID [kpiID]
		  ,[date]
		  ,[measurement]
		  ,[detalle]
		  ,[categories]
	FROM #tbl_Measurement 
	ORDER BY [date] DESC, [measurmentID] DESC
	
	DROP TABLE #tbl_Measurement
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_UpdateKPI]    Script Date: 08/08/2016 17:41:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: May 23, 2016
-- Description:	Update a new KPI
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_UpdateKPI]
	@kpiId int,
	@organizationID int,
	@areaID int,
	@projectID int,
	@activityID int,
	@personID int,
	@kpiName nvarchar(250),
	@unit varchar(10),
	@direction char(3),
	@strategy char(3),
	@startDate date,
	@reportingUnit char(15),
	@targetPeriod int,
	@allowsCategories bit,
	@currency char(3),
	@currencyUnit char(3),
	@kpiTypeID varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- ===============================================================================================
	-- ===============================================================================================
	-- This is very important! This stored procedure does not implement a transaction, even though
	-- it does multiple things.  We do this because it is assumed that the ASP.NET program that is 
	-- calling this procedure is handling the transaction, since this procedure must be called in 
	-- conjunction with others that crete the categories and targets.  
	-- Hence, YOU MUST create an ASP.NET tranaction to call this function!
	-- ===============================================================================================
	-- ===============================================================================================

	if(@kpiTypeID is null or @kpiTypeID = '')
			RAISERROR ('KPITypeID is null or empty', -- Message text.
			16, -- Severity.
			1 -- State.
			); 

	IF(@areaID = 0)
		SELECT @areaID = null
	IF(@projecTID = 0)
		SELECT @projectID = null
	IF(@activityID = 0)
		SELECT @activityID = null
	IF(@personID = 0)
		SELECT @personID = null
	IF (@targetPeriod = 0)
		SELECT @targetPeriod = NULL
	IF (@currency = '')
		SELECT @currency = NULL
	IF (@currencyUnit='')
		SELECT @currencyUnit = NULL

	UPDATE [dbo].[tbl_KPI]
	SET [name] = @kpiName
		  ,[organizationID] = @organizationID
		  ,[areaID] = @areaID
		  ,[projectID] = @projectID
		  ,[activityID] = @activityID
		  ,[personID] = @personID
		  ,[unitID] = @unit
		  ,[directionID] = @direction
		  ,[strategyID] = @strategy
		  ,[startDate] = @startDate
		  ,[reportingUnitID] = @reportingUnit
		  ,[targetPeriod] = @targetPeriod
		  ,[allowsCategories] = @allowsCategories
		  ,[currency] = @currency
		  ,[currencyUnitID] = @currencyUnit
		  ,[kpiTypeID] = @kpiTypeID
	WHERE [kpiID] = @kpiId

END

GO


--=================================================================================================

/*
 * We are done, mark the database as a 1.20.1 database.
 */
DELETE FROM [dbo].[tbl_DatabaseInfo] 
INSERT INTO [dbo].[tbl_DatabaseInfo] 
	([majorversion], [minorversion], [releaseversion])
	VALUES (1,20,1)
GO