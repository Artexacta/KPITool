/* 
	Updates de the KPIDB database to version 1.19.0 
*/

Use [Master]
GO 

IF  NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'KPIDB')
	RAISERROR('KPIDB database Doesn´t exists. Create the database first',16,127)
GO

PRINT 'Updating KPIDB database to version 1.19.0'

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

IF NOT (@smiMajor = 1 AND @smiMinor = 18) 
BEGIN
	RAISERROR('KPIDB database is not in version 1.18 This program only applies to version 1.18',16,127)
	RETURN;
END

PRINT 'KPIDB Database version OK'
GO

--===================================================================================================


/****** Object:  Table [dbo].[tbl_UserTour]    Script Date: 08/01/2016 06:14:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tbl_UserTour](
	[userId] [int] NOT NULL,
	[tourId] [varchar](50) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[tbl_UserTour]  WITH CHECK ADD  CONSTRAINT [FK_tbl_UserTour_tbl_SEG_User] FOREIGN KEY([userId])
REFERENCES [dbo].[tbl_SEG_User] ([userId])
GO

ALTER TABLE [dbo].[tbl_UserTour] CHECK CONSTRAINT [FK_tbl_UserTour_tbl_SEG_User]
GO



/****** Object:  StoredProcedure [dbo].[usp_TOUR_SetUserTourStatus]    Script Date: 08/01/2016 06:14:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_TOUR_SetUserTourStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_TOUR_SetUserTourStatus]
GO

/****** Object:  StoredProcedure [dbo].[usp_TOUR_CheckUserTour]    Script Date: 08/01/2016 06:14:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_TOUR_CheckUserTour]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_TOUR_CheckUserTour]
GO


/****** Object:  StoredProcedure [dbo].[usp_TOUR_SetUserTourStatus]    Script Date: 08/01/2016 06:14:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jose Carlos Gutierrez
-- Create date: 2016-07-29
-- Description:	Update UserTour status
-- =============================================
CREATE PROCEDURE [dbo].[usp_TOUR_SetUserTourStatus]
	@intUserId	INT,
	@varTourId	VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @intCounter INT = 0
    
    SELECT @intCounter = COUNT(*)
    FROM [dbo].[tbl_UserTour]
    WHERE [userId] = @intUserId
		AND [tourId] = @varTourId
		
	IF @intCounter = 0
	BEGIN
	
		INSERT INTO [dbo].[tbl_UserTour]
			([userId],[tourId])
			VALUES
			(@intUserId, @varTourId)
	
	END
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_TOUR_CheckUserTour]    Script Date: 08/01/2016 06:14:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jose Carlos Gutierrez
-- Create date: 2016-07-29
-- Description:	Check if user end a specific tour
-- =============================================
CREATE PROCEDURE [dbo].[usp_TOUR_CheckUserTour]
	@intUserId	INT,
	@varTourId	VARCHAR(50),
	@bitChecked BIT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SET @bitChecked = 0

    DECLARE @intCounter INT = 0
    
    SELECT @intCounter = COUNT(*)
    FROM tbl_UserTour
    WHERE [userId] = @intUserId
		AND [tourId] = @varTourId
		
	IF @intCounter > 0
		SET @bitChecked = 1
    
END

GO


/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiStats]    Script Date: 08/01/2016 10:42:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpiStats]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpiStats]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiStats]    Script Date: 08/01/2016 10:42:58 ******/
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
		@intFirstDayOfWeek,
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






--=================================================================================================

/*
 * We are done, mark the database as a 1.19.0 database.
 */
DELETE FROM [dbo].[tbl_DatabaseInfo] 
INSERT INTO [dbo].[tbl_DatabaseInfo] 
	([majorversion], [minorversion], [releaseversion])
	VALUES (1,19,0)
GO