USE [KPIDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetNumberFromTime]    Script Date: 07/28/2016 12:29:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetNumberFromTime]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetNumberFromTime]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementsForChart]    Script Date: 07/28/2016 12:29:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpiMeasurementsForChart]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpiMeasurementsForChart]
GO

/****** Object:  UserDefinedFunction [dbo].[tvf_GetDatesForKpiReportingForDays]    Script Date: 07/28/2016 12:33:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tvf_GetDatesForKpiReportingForDays]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[tvf_GetDatesForKpiReportingForDays]
GO

/****** Object:  UserDefinedFunction [dbo].[tvf_GetDatesForKpiReportingForMonths]    Script Date: 07/28/2016 12:33:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tvf_GetDatesForKpiReportingForMonths]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[tvf_GetDatesForKpiReportingForMonths]
GO

/****** Object:  UserDefinedFunction [dbo].[tvf_GetDatesForKpiReportingForQuarter]    Script Date: 07/28/2016 12:33:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tvf_GetDatesForKpiReportingForQuarter]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[tvf_GetDatesForKpiReportingForQuarter]
GO

/****** Object:  UserDefinedFunction [dbo].[tvf_GetDatesForKpiReportingForWeeks]    Script Date: 07/28/2016 12:33:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tvf_GetDatesForKpiReportingForWeeks]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[tvf_GetDatesForKpiReportingForWeeks]
GO

/****** Object:  UserDefinedFunction [dbo].[tvf_GetDatesForKpiReportingForYears]    Script Date: 07/28/2016 12:33:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tvf_GetDatesForKpiReportingForYears]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[tvf_GetDatesForKpiReportingForYears]
GO


/****** Object:  UserDefinedFunction [dbo].[tvf_GetDatesForKpiReportingForDays]    Script Date: 07/28/2016 12:33:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jose Carlos Gutierrez
-- Create date: 2016-07-22
-- Description:	Gets a table with dates for KPI Chart
-- =============================================
CREATE FUNCTION [dbo].[tvf_GetDatesForKpiReportingForDays]
(
	@intAmountOfPeriods INT
)
RETURNS 
@tblDates TABLE 
(
	[from] DATE,
	[to] DATE
)
AS
BEGIN

	DECLARE @date DATE = GETDATE()

	WHILE @intAmountOfPeriods > 0
	BEGIN
		
		INSERT INTO @tblDates VALUES (@date, @date)		
		
		SET @date = DATEADD(day, -1, @date)
		SET @intAmountOfPeriods = @intAmountOfPeriods - 1

	END
	
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[tvf_GetDatesForKpiReportingForMonths]    Script Date: 07/28/2016 12:33:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jose Carlos Gutierrez
-- Create date: 2016-07-22
-- Description:	Gets a table with dates for KPI Chart
-- =============================================
CREATE FUNCTION [dbo].[tvf_GetDatesForKpiReportingForMonths]
(
	@intAmountOfPeriods INT
)
RETURNS 
@tblDates TABLE 
(
	[from] DATE,
	[to] DATE
)
AS
BEGIN
	DECLARE @today DATE = GETDATE()

	DECLARE @from DATE = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@today)-1),@today),101)
	DECLARE @to DATE = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@today))),DATEADD(mm,1,@today)),101)

	WHILE @intAmountOfPeriods > 0
	BEGIN
		
		INSERT INTO @tblDates VALUES (@from, @to)		
		
		SET @to = DATEADD(day, -1, @from)
		SET @from = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@to)-1),@to),101)
		SET @intAmountOfPeriods = @intAmountOfPeriods - 1

	END
	
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[tvf_GetDatesForKpiReportingForQuarter]    Script Date: 07/28/2016 12:33:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jose Carlos Gutierrez
-- Create date: 2016-07-22
-- Description:	Gets a table with dates for KPI Chart
-- =============================================
CREATE FUNCTION [dbo].[tvf_GetDatesForKpiReportingForQuarter]
(
	@intAmountOfPeriods INT
)
RETURNS 
@tblDates TABLE 
(
	[from] DATE,
	[to] DATE
)
AS
BEGIN
	DECLARE @today DATE = GETDATE()

	DECLARE @from DATE = DATEADD(q, DATEDIFF(q, 0, @today), 0) 
	DECLARE @to DATE = DATEADD(d, -1, DATEADD(q, DATEDIFF(q, 0, @today) + 1, 0))

	WHILE @intAmountOfPeriods > 0
	BEGIN
		
		INSERT INTO @tblDates VALUES (@from, @to)		
		
		SET @to = DATEADD(day, -1, @from)
		SET @from = DATEADD(q, DATEDIFF(q, 0, @to), 0) 
		SET @intAmountOfPeriods = @intAmountOfPeriods - 1

	END
	
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[tvf_GetDatesForKpiReportingForWeeks]    Script Date: 07/28/2016 12:33:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jose Carlos Gutierrez
-- Create date: 2016-07-22
-- Description:	Gets a table with dates for KPI Chart
-- =============================================
CREATE FUNCTION [dbo].[tvf_GetDatesForKpiReportingForWeeks]
(
	@intAmountOfPeriods INT
)
RETURNS 
@tblDates TABLE 
(
	[from] DATE,
	[to] DATE
)
AS
BEGIN
	DECLARE @today DATE = GETDATE()

	DECLARE @from DATE = DATEADD(dd, -(DATEPART(dw, @today)-1), @today)
	DECLARE @to DATE = DATEADD(dd, 7-(DATEPART(dw, @today)), @today)

	WHILE @intAmountOfPeriods > 0
	BEGIN
		
		INSERT INTO @tblDates VALUES (@from, @to)		
		
		SET @to = DATEADD(day, -1, @from)
		SET @from = DATEADD(dd, -(DATEPART(dw, @to)-1), @to)
		SET @intAmountOfPeriods = @intAmountOfPeriods - 1

	END
	
	RETURN
END

GO

/****** Object:  UserDefinedFunction [dbo].[tvf_GetDatesForKpiReportingForYears]    Script Date: 07/28/2016 12:33:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jose Carlos Gutierrez
-- Create date: 2016-07-22
-- Description:	Gets a table with dates for KPI Chart
-- =============================================
CREATE FUNCTION [dbo].[tvf_GetDatesForKpiReportingForYears]
(
	@intAmountOfPeriods INT
)
RETURNS 
@tblDates TABLE 
(
	[from] DATE,
	[to] DATE
)
AS
BEGIN
	DECLARE @today DATE = GETDATE()

	DECLARE @from DATE = DATEADD(yy, DATEDIFF(yy,0,@today), 0)
	DECLARE @to DATE = DATEADD(yy, DATEDIFF(yy,0,getdate()) + 1, -1)

	WHILE @intAmountOfPeriods > 0
	BEGIN
		
		INSERT INTO @tblDates VALUES (@from, @to)		
		
		SET @to = DATEADD(day, -1, @from)
		SET @from = DATEADD(yy, DATEDIFF(yy,0,@to), 0)
		SET @intAmountOfPeriods = @intAmountOfPeriods - 1

	END
	
	RETURN
END

GO



USE [KPIDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetNumberFromTime]    Script Date: 07/28/2016 12:29:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: 24/05/2016
-- Description:	Convert time data to float to save en DB
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetNumberFromTime]
	@year INT,
	@month INT,
	@day INT,
	@hour INT,
	@minute INT,
	@valor DECIMAL(21,3) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @fechaBase AS DATETIME
	DECLARE @fechaCalculada AS DATETIME
	
	SET @fechaBase = '1900-01-01'
	SET @fechaCalculada = DATEADD(MINUTE,@minute,DATEADD(HH,@hour,DATEADD(DD,@day,DATEADD(MM,@month,DATEADD(YY,@year, @fechaBase)))))
	SET @valor = CAST(@fechaCalculada AS DECIMAL(21,3))

END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementsForChart]    Script Date: 07/28/2016 12:29:53 ******/
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
	
 
	DECLARE @currentPeriod INT = @intReportingPeriod
	DECLARE @from DATE
	DECLARE @to DATE
	
	DECLARE cDates CURSOR FOR
	SELECT [from], [to] FROM @tblDates
	
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
		
			IF @datStartDate >= @from AND @datStartDate <= @to
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
					FROM [dbo].[tbl_KPIMeasurements]
					WHERE [kpiID] = @intKpiId
						AND [date] BETWEEN @from AND @to
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
					FROM [dbo].[tbl_KPIMeasurements]
					WHERE [kpiID] = @intKpiId
						AND [date] BETWEEN @from AND @to
						AND 1 = CASE WHEN @datStartDate IS NULL THEN 1 ELSE
								CASE WHEN [date] >= @datStartDate THEN 1 ELSE 0 END
								END
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
				SELECT [dbo].[svf_GetReportingName](@varReportingUnit, @from),[measurement], @currentPeriod
				FROM (
					SELECT ISNULL(SUM([measurement]),0) [measurement]
					FROM [dbo].[tbl_KPIMeasurements]
					WHERE [kpiID] = @intKpiId
					AND [date] BETWEEN @from AND @to
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
					FROM [dbo].[tbl_KPIMeasurements]
					WHERE [kpiID] = @intKpiId
						AND [date] BETWEEN @from AND @to
						AND 1 = CASE WHEN @datStartDate IS NULL THEN 1 ELSE
						CASE WHEN [date] >= @datStartDate THEN 1 ELSE 0 END
						END
						AND [measurmentID] IN (SELECT [measurmentID] 
											FROM [dbo].[tbl_KPIMeasurementCategories]
											WHERE [categoryID] = @intCategoryId 
											AND [categoryItemID] = @intCategoryItemId
										)
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
	ORDER BY [order] ASC


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


