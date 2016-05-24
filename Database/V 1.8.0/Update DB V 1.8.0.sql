/* 
	Updates de the KPIDB database to version 1.8.0 
*/

Use [Master]
GO 

IF  NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'KPIDB')
	RAISERROR('KPIDB database Doesn´t exists. Create the database first',16,127)
GO

PRINT 'Updating KPIDB database to version 1.8.0'

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

IF NOT (@smiMajor = 1 AND @smiMinor = 7) 
BEGIN
	RAISERROR('KPIDB database is not in version 1.7 This program only applies to version 1.7',16,127)
	RETURN;
END

PRINT 'KPIDB Database version OK'
GO

-----------------------------------------

USE [KPIDB]
GO

/****** Object:  Table [dbo].[tbl_KpiReportingPeriod]    Script Date: 05/24/2016 15:46:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tbl_KpiReportingPeriod](
	[reportingUnitId] [char](5) NOT NULL,
	[periodsToReport] [int] NOT NULL,
	[days] [int] NOT NULL,
 CONSTRAINT [PK_tbl_KpiReportingPeriod] PRIMARY KEY CLUSTERED 
(
	[reportingUnitId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiProgress]    Script Date: 05/24/2016 15:49:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpiProgress]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpiProgress]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementsForChart]    Script Date: 05/24/2016 15:49:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpiMeasurementsForChart]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpiMeasurementsForChart]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementsByKpiOwner]    Script Date: 05/24/2016 15:49:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpiMeasurementsByKpiOwner]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpiMeasurementsByKpiOwner]
GO


/****** Object:  UserDefinedFunction [dbo].[svf_GetKpiProgess]    Script Date: 05/24/2016 15:49:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[svf_GetKpiProgess]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[svf_GetKpiProgess]
GO

/****** Object:  UserDefinedFunction [dbo].[svf_GetReportingName]    Script Date: 05/24/2016 15:49:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[svf_GetReportingName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[svf_GetReportingName]
GO




/****** Object:  UserDefinedFunction [dbo].[svf_GetKpiProgess]    Script Date: 05/24/2016 15:49:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jose Carlos Gutierrez
-- Create date: 2016/05/19
-- Description:	Get KPI Progress
-- =============================================
CREATE FUNCTION [dbo].[svf_GetKpiProgess]
(
	@intKpiId	INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result DECIMAL(5,2)

	DECLARE @decTarget DECIMAL(21,3)

	SELECT @decTarget = ISNULL(SUM([target]),0)
	FROM [dbo].[tbl_KPITarget]
	WHERE [kpiID] = @intKpiId
	
	DECLARE @varStrategyId CHAR(3)

	SELECT @varStrategyId = [strategyID]	
	FROM [dbo].[tbl_KPI] 
	WHERE [kpiID] = @intKpiId
	
	DECLARE @measurement DECIMAL(21,3)
	
	IF @varStrategyId = 'AVG'
	BEGIN
		SELECT @measurement = ISNULL(AVG([measurement]),0)
		FROM [dbo].[tbl_KPIMeasurements]
		WHERE [kpiID] = @intKpiId
	END

	IF @varStrategyId = 'SUM'
	BEGIN
		SELECT @measurement = ISNULL(SUM([measurement]),0)
		FROM [dbo].[tbl_KPIMeasurements]
		WHERE [kpiID] = @intKpiId
	END 
	
	IF @measurement > @decTarget
		SET @result = 100
	ELSE
	BEGIN
		IF @decTarget = 0
			SET @result = 0
		ELSE
			SET @result = (@measurement * 100.0) / @decTarget
	END
	-- Return the result of the function
	RETURN @result

END

GO

/****** Object:  UserDefinedFunction [dbo].[svf_GetReportingName]    Script Date: 05/24/2016 15:50:00 ******/
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





/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiProgress]    Script Date: 05/24/2016 15:49:27 ******/
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
	@bitHasTarget		BIT OUTPUT,
	@decCurrentValue	DECIMAL(21,3) OUTPUT,
	@decProgress		DECIMAL(5,2) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @decTarget DECIMAL(21,3)

	SELECT @decTarget = SUM([target])
	FROM [dbo].[tbl_KPITarget]
	WHERE [kpiID] = @intKpiId
	
	IF @decTarget IS NULL
		SET @bitHasTarget = 0
	ELSE
		SET @bitHasTarget = 1
		
	DECLARE @varStrategyId CHAR(3)
	DECLARE @varReportingUnitId CHAR(5)	

	SELECT @varStrategyId = [strategyID],
		@varReportingUnitId = [reportingUnitId]
	FROM [dbo].[tbl_KPI] 
	WHERE [kpiID] = @intKpiId
	
	
	DECLARE @days INT 
	SELECT @days = p.[days]
	FROM [dbo].[tbl_KpiReportingPeriod] p
	WHERE p.[reportingUnitId] = @varReportingUnitId
	
	DECLARE @dateFrom DATE = DATEADD(DAY, -@days, GETDATE())
	
	IF @varStrategyId = 'AVG'
	BEGIN
		SELECT TOP 1 @decCurrentValue = [value]
		FROM (
			SELECT ISNULL(AVG([measurement]),0) [value]
			FROM [dbo].[tbl_KPIMeasurements]
			WHERE [kpiID] = @intKpiId
				AND [date] BETWEEN @dateFrom AND GETDATE()
		) tbl
	END

	IF @varStrategyId = 'SUM'
	BEGIN
		SELECT TOP 1 @decCurrentValue = [value]
		FROM (
			SELECT ISNULL(SUM([measurement]),0) [value]
			FROM [dbo].[tbl_KPIMeasurements]
			WHERE [kpiID] = @intKpiId
				AND [date] BETWEEN @dateFrom AND GETDATE()
		) tbl
	END 

    SELECT @decProgress = [dbo].[svf_GetKpiProgess](@intKpiId)
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementsForChart]    Script Date: 05/24/2016 15:49:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jose Carlos Gutierrez
-- Create date: 2016/05/12
-- Description:	Gets measurement of KPI
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKpiMeasurementsForChart]
	@intKpiId		INT,
	@varStrategyId	CHAR(3) OUTPUT,
	@decTarget		DECIMAL(21,3) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

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

	SELECT @decTarget = SUM([target])
	FROM [dbo].[tbl_KPITarget]
	WHERE [kpiID] = @intKpiId

	SELECT @varStrategyId = [strategyID],
		@datStartDate = [startDate],
		@intTargetPeriod = ISNULL([targetPeriod],0),
		@varReportingUnit = [reportingUnitID]		
	FROM [dbo].[tbl_KPI] 
	WHERE [kpiID] = @intKpiId
	
	SET @decTarget = @decTarget / @intTargetPeriod


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
		
		IF @varStrategyId = 'AVG'
		BEGIN
			INSERT INTO @tabResult
				SELECT [dbo].[svf_GetReportingName](@varReportingUnit, @currentDate), [measurement], @currentPeriod
				FROM (
					SELECT ISNULL(AVG([measurement]),0) [measurement]
					FROM [dbo].[tbl_KPIMeasurements]
					WHERE [kpiID] = @intKpiId
						AND [date] BETWEEN @from AND @currentDate
						AND 1 = CASE WHEN @datStartDate IS NULL THEN 1 ELSE
									CASE WHEN [date] >= @datStartDate THEN 1 ELSE 0 END
								END
				) tbl
		END

		IF @varStrategyId = 'SUM'
		BEGIN
			INSERT INTO @tabResult
				SELECT [dbo].[svf_GetReportingName](@varReportingUnit, @currentDate),[measurement], @currentPeriod
				FROM (
					SELECT ISNULL(SUM([measurement]),0) [measurement]
					FROM [dbo].[tbl_KPIMeasurements]
					WHERE [kpiID] = @intKpiId
						AND [date] BETWEEN @from AND @currentDate
						AND 1 = CASE WHEN @datStartDate IS NULL THEN 1 ELSE
									CASE WHEN [date] >= @datStartDate THEN 1 ELSE 0 END
								END
				) tbl
		END

		--IF @varStrategyId = 'NA'
		--BEGIN
		--	INSERT INTO @tabResult
		--	SELECT [date], [measurement]
		--	FROM [dbo].[tbl_KPIMeasurements]
		--	WHERE [kpiID] = @intKpiId
		--		AND [date] BETWEEN @from AND @currentDate
		--	ORDER BY [date] ASC
		--END
		
		SET @currentDate = DATEADD(DAY, -1, @from)
		SET @currentPeriod = @currentPeriod - 1
	END

	SELECT [period],
		[measurement]
	FROM @tabResult
	ORDER BY [order] ASC


	--DECLARE @tabResult TABLE ([date] DATE,[measurement] DECIMAL(21,3))
	--print @varStrategyId
	--IF @varStrategyId = 'AVG'
	--BEGIN
	--	INSERT INTO @tabResult
	--	SELECT [date], AVG([measurement])
	--	FROM [dbo].[tbl_KPIMeasurements]
	--	WHERE [kpiID] = @intKpiId
	--	GROUP BY [date]
	--	ORDER BY [date] ASC
	--END

	--IF @varStrategyId = 'SUM'
	--BEGIN
	--	INSERT INTO @tabResult
	--	SELECT [date], SUM([measurement])
	--	FROM [dbo].[tbl_KPIMeasurements]
	--	WHERE [kpiID] = @intKpiId
	--	GROUP BY [date]
	--	ORDER BY [date] ASC
	--END

	--IF @varStrategyId = 'NA'
	--BEGIN
	--	INSERT INTO @tabResult
	--	SELECT [date], [measurement]
	--	FROM [dbo].[tbl_KPIMeasurements]
	--	WHERE [kpiID] = @intKpiId
	--	ORDER BY [date] ASC
	--END


	--SELECT d.[date]
	--	,ISNULL(r.[measurement],0) [measurement]
	--FROM @tabDates d
	--	LEFT OUTER JOIN @tabResult r  ON d.[date] = r.[date] 
	--WHERE d.[date] BETWEEN @datStartDate AND @today
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementsByKpiOwner]    Script Date: 05/24/2016 15:49:27 ******/
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
	
	DECLARE @tbl_AuthorizedKPI AS TABLE([kpiId] INT)
 
	 INSERT INTO @tbl_AuthorizedKPI
		EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUserName
	
	DECLARE @tblKpiIds AS TABLE ([kpiId] INT)
	
	IF @varOwnerType = 'KPI'
	BEGIN
		INSERT INTO @tblKpiIds ([kpiId]) VALUES (@intOwnerId)
	END
	
	IF @varOwnerType = 'ACTIVITY'
	BEGIN
	
		INSERT INTO @tblKpiIds
		SELECT [kpiID]
		FROM [dbo].[tbl_KPI]
		WHERE [activityID] = @intOwnerId
			AND [kpiID] IN (SELECT [kpiId] FROM @tbl_AuthorizedKPI)

	END
	
	IF @varOwnerType = 'ORGANIZATION'
	BEGIN
	
		INSERT INTO @tblKpiIds
		SELECT [kpiID]
		FROM [dbo].[tbl_KPI]
		WHERE [organizationID] = @intOwnerId
			AND [kpiID] IN (SELECT [kpiId] FROM @tbl_AuthorizedKPI)

	END
	
	IF @varOwnerType = 'AREA'
	BEGIN
	
		INSERT INTO @tblKpiIds
		SELECT [kpiID]
		FROM [dbo].[tbl_KPI]
		WHERE [areaID] = @intOwnerId
			AND [kpiID] IN (SELECT [kpiId] FROM @tbl_AuthorizedKPI)

	END
	
	IF @varOwnerType = 'PROJECT'
	BEGIN
	
		INSERT INTO @tblKpiIds
		SELECT [kpiID]
		FROM [dbo].[tbl_KPI]
		WHERE [projectID] = @intOwnerId
			AND [kpiID] IN (SELECT [kpiId] FROM @tbl_AuthorizedKPI)

	END
	
	IF @varOwnerType = 'PERSON'
	BEGIN
	
		INSERT INTO @tblKpiIds
		SELECT [kpiID]
		FROM [dbo].[tbl_KPI]
		WHERE [personID] = @intOwnerId
			AND [kpiID] IN (SELECT [kpiId] FROM @tbl_AuthorizedKPI)

	END
	
	SELECT @decMax = MAX([measurement]), @decMin = MIN([measurement])
	FROM [dbo].[tbl_KPIMeasurements]
	WHERE [kpiID] IN (SELECT [kpiID] FROM @tblKpiIds)

    SELECT [measurmentID]
      ,[kpiID]
      ,[date]
      ,[measurement]
	FROM [dbo].[tbl_KPIMeasurements]
	WHERE [kpiID] IN (SELECT [kpiID] FROM @tblKpiIds)
	ORDER BY [measurement] ASC


END

GO

--=============================================================================================================================

/*
 * We are done, mark the database as a 1.8.0 database.
 */

DELETE FROM [dbo].[tbl_DatabaseInfo] 
INSERT INTO [dbo].[tbl_DatabaseInfo] 
	([majorversion], [minorversion], [releaseversion])
	VALUES (1,8,0)
GO
