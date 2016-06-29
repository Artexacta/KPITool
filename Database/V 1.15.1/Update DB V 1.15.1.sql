USE [KPIDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiCategories]    Script Date: 06/24/2016 16:42:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpiCategories]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpiCategories]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementsForChart]    Script Date: 06/24/2016 16:42:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpiMeasurementsForChart]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpiMeasurementsForChart]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiProgress]    Script Date: 06/24/2016 16:42:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpiProgress]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpiProgress]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsBySearch]    Script Date: 06/24/2016 16:42:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKPIsBySearch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKPIsBySearch]
GO

/****** Object:  StoredProcedure [dbo].[usp_PEOPLE_GetPeopleBySearch]    Script Date: 06/24/2016 16:42:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PEOPLE_GetPeopleBySearch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PEOPLE_GetPeopleBySearch]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiCategories]    Script Date: 06/24/2016 16:42:07 ******/
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
 FROM [dbo].[tbl_Category] c
  JOIN [dbo].[tbl_KPICategories] kc ON kc.[categoryID] = c.[categoryID]
  JOIN [dbo].[tbl_CategoryItem] ci ON ci.[categoryID] = ci.[categoryID]
 WHERE kc.[kpiID] = @intKpiId
END


GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementsForChart]    Script Date: 06/24/2016 16:42:07 ******/
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
 @intKpiId   INT,
 @intCategoryId  VARCHAR(20),
 @intCategoryItemId VARCHAR(20),
 @varStrategyId  CHAR(3) OUTPUT,
 @decTarget   DECIMAL(21,3) OUTPUT
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
  
   IF @intCategoryId IS NULL
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
   ELSE
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
       AND 1 = CASE WHEN @datStartDate IS NULL THEN 1 ELSE
          CASE WHEN [date] >= @datStartDate THEN 1 ELSE 0 END
         END
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

  --IF @varStrategyId = 'NA'
  --BEGIN
  -- INSERT INTO @tabResult
  -- SELECT [date], [measurement]
  -- FROM [dbo].[tbl_KPIMeasurements]
  -- WHERE [kpiID] = @intKpiId
  --  AND [date] BETWEEN @from AND @currentDate
  -- ORDER BY [date] ASC
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

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiProgress]    Script Date: 06/24/2016 16:42:07 ******/
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
  
 
 
 
 DECLARE @days INT 
 SELECT @days = p.[days]
 FROM [dbo].[tbl_KpiReportingPeriod] p
 WHERE p.[reportingUnitId] = @varReportingUnitId
 
 DECLARE @dateFrom DATE = DATEADD(DAY, -@days, GETDATE())
 
 IF @varStrategyId = 'AVG'
 BEGIN
  IF @varCategoryId = '' OR @varCategoryId IS NULL
  BEGIN
  
   SELECT TOP 1 @decCurrentValue = ISNULL([value],0)
   FROM (
    SELECT ISNULL(AVG([measurement]),0) [value]
    FROM [dbo].[tbl_KPIMeasurements]
    WHERE [kpiID] = @intKpiId
     AND [date] BETWEEN @dateFrom AND GETDATE()
   ) tbl
  END
  ELSE
  BEGIN
  
   SELECT TOP 1 @decCurrentValue = ISNULL([value],0)
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
  
   SELECT TOP 1 @decCurrentValue = ISNULL([value],0)
   FROM (
    SELECT ISNULL(SUM([measurement]),0) [value]
    FROM [dbo].[tbl_KPIMeasurements]
    WHERE [kpiID] = @intKpiId
     AND [date] BETWEEN @dateFrom AND GETDATE()
   ) tbl
  END
  ELSE
  BEGIN
  
   SELECT TOP 1 @decCurrentValue = ISNULL([value],0)
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

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsBySearch]    Script Date: 06/24/2016 16:42:07 ******/
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
	@varWhereClause VARCHAR(MAX)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	CREATE TABLE #tblKPI
		(kpiId INT)

	INSERT INTO #tblKPI
	EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUsername
	
	DECLARE @varSQL VARCHAR(MAX)

	SET @varSQL = 'SELECT [k].[kpiID]
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
				  ,[dbo].[svf_GetKpiProgess]([k].[kpiID],'''','''') [progress]
				  ,[dbo].[svf_GetKpiTrend]([k].[kpiID]) [trend]
			  FROM [dbo].[tbl_KPI] [k]
			  INNER JOIN #tblKPI [tk] ON [k].[KPIId] = [tk].[KPIId]
			  WHERE ' + @varWhereClause
			  
	 EXEC (@varSQL)
	 
	 DROP TABLE #tblKPI
	 
END

GO

/****** Object:  StoredProcedure [dbo].[usp_PEOPLE_GetPeopleBySearch]    Script Date: 06/24/2016 16:42:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: June 2, 2016
-- Description:	Get the lists of people for search
-- =============================================
CREATE PROCEDURE [dbo].[usp_PEOPLE_GetPeopleBySearch]
	@varUsername VARCHAR(25),
	@varWhereClause VARCHAR(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #tblPeople
		(personId INT)

	INSERT INTO #tblPeople
	EXEC [usp_PEOPLE_GetPersonListForUser] @varUsername

	DECLARE @varSQL AS VARCHAR(MAX)

	SET @varSQL = 'SELECT [p].[personID]
				  ,[p].[id]
				  ,[p].[name]
				  ,[p].[organizationID]
				  ,[p].[areaID]
			FROM [dbo].[tbl_People] [p]
			INNER JOIN #tblPeople [t] ON [p].[personID] = [t].[personId]
			INNER JOIN [dbo].[tbl_Organization] [g] ON [p].[organizationID] = [g].[organizationID] AND [p].[deleted] = 0
			LEFT JOIN [dbo].[tbl_Area] [r] ON [p].[areaID] = [r].[areaID]
	        WHERE [g].[deleted] = 0 and ' + @varWhereClause + '
	        ORDER BY [p].[name]'
	  
	 EXEC (@varSQL)
	 
	 DROP TABLE #tblPeople
	 
END

GO


--=================================================================================================

/*
 * We are done, mark the database as a 1.15.1 database.
 */
DELETE FROM [dbo].[tbl_DatabaseInfo] 
INSERT INTO [dbo].[tbl_DatabaseInfo] 
	([majorversion], [minorversion], [releaseversion])
	VALUES (1,15,1)
GO
