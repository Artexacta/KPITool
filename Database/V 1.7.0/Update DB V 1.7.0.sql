/* 
	Updates de the KPIDB database to version 1.7.0 
*/

Use [Master]
GO 

IF  NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'KPIDB')
	RAISERROR('KPIDB database Doesn´t exists. Create the database first',16,127)
GO

PRINT 'Updating KPIDB database to version 1.7.0'

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

IF NOT (@smiMajor = 1 AND @smiMinor = 6) 
BEGIN
	RAISERROR('KPIDB database is not in version 1.6 This program only applies to version 1.6',16,127)
	RETURN;
END

PRINT 'KPIDB Database version OK'
GO

-----------------------------------------


/****** Object:  Table [dbo].[tbl_KPIDashboard]    Script Date: 05/17/2016 12:25:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_KPIDashboard](
	[kpiDashboardId] [int] IDENTITY(1,1) NOT NULL,
	[dashboardId] [int] NULL,
	[kpiId] [int] NOT NULL,
	[ownerUserId] [int] NOT NULL,
 CONSTRAINT [PK_tbl_KPI_KPIDashboard] PRIMARY KEY CLUSTERED 
(
	[kpiDashboardId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
	

/****** Object:  Table [dbo].[tbl_UserDashboard]    Script Date: 05/17/2016 12:25:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_UserDashboard](
	[dashboardId] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](250) NOT NULL,
	[ownerUserId] [int] NOT NULL,
 CONSTRAINT [PK_tbl_KPI_UserDashboard] PRIMARY KEY CLUSTERED 
(
	[dashboardId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tbl_KPIDashboard]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPI_KPIDashboard_tbl_KPI_KPIDashboard] FOREIGN KEY([dashboardId])
REFERENCES [dbo].[tbl_UserDashboard] ([dashboardId])
GO

ALTER TABLE [dbo].[tbl_KPIDashboard] CHECK CONSTRAINT [FK_tbl_KPI_KPIDashboard_tbl_KPI_KPIDashboard]
GO

ALTER TABLE [dbo].[tbl_KPIDashboard]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPI_KPIDashboard_tbl_SEG_User] FOREIGN KEY([ownerUserId])
REFERENCES [dbo].[tbl_SEG_User] ([userId])
GO

ALTER TABLE [dbo].[tbl_KPIDashboard] CHECK CONSTRAINT [FK_tbl_KPI_KPIDashboard_tbl_SEG_User]
GO

ALTER TABLE [dbo].[tbl_KPIDashboard]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPIDashboard_tbl_KPI] FOREIGN KEY([kpiId])
REFERENCES [dbo].[tbl_KPI] ([kpiID])
GO

ALTER TABLE [dbo].[tbl_KPIDashboard] CHECK CONSTRAINT [FK_tbl_KPIDashboard_tbl_KPI]
GO

ALTER TABLE [dbo].[tbl_UserDashboard]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPI_UserDashboard_tbl_SEG_User] FOREIGN KEY([ownerUserId])
REFERENCES [dbo].[tbl_SEG_User] ([userId])
GO

ALTER TABLE [dbo].[tbl_UserDashboard] CHECK CONSTRAINT [FK_tbl_KPI_UserDashboard_tbl_SEG_User]
GO



/****** Object:  StoredProcedure [dbo].[usp_KPI_DeleteKpiDashboard]    Script Date: 05/17/2016 12:23:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_DeleteKpiDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_DeleteKpiDashboard]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetUserDashboardByKpiId]    Script Date: 05/17/2016 12:23:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetUserDashboardByKpiId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetUserDashboardByKpiId]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_DeleteUserDashboard]    Script Date: 05/17/2016 12:23:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_DeleteUserDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_DeleteUserDashboard]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpisFromDashboard]    Script Date: 05/17/2016 12:23:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpisFromDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpisFromDashboard]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_InsertKpiToDashboard]    Script Date: 05/17/2016 12:23:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_InsertKpiToDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_InsertKpiToDashboard]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetUserDashboardWhenKpiIdIsNotIn]    Script Date: 05/17/2016 12:23:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetUserDashboardWhenKpiIdIsNotIn]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetUserDashboardWhenKpiIdIsNotIn]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetUserDashboards]    Script Date: 05/17/2016 12:23:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetUserDashboards]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetUserDashboards]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_InsertUserDashboard]    Script Date: 05/17/2016 12:23:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_InsertUserDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_InsertUserDashboard]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_UpdateUserDashboard]    Script Date: 05/17/2016 12:23:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_UpdateUserDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_UpdateUserDashboard]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementsForChart]    Script Date: 05/17/2016 12:23:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpiMeasurementsForChart]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpiMeasurementsForChart]
GO


/****** Object:  StoredProcedure [dbo].[usp_KPI_DeleteKpiDashboard]    Script Date: 05/17/2016 12:23:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jose Carlos Gutiérrez
-- Create date: 2016/05/13
-- Description:	Insert a KPI to Dashboard
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_DeleteKpiDashboard]
	@intKpiId		INT,
	@intUserId		INT,
	@intDashboardId	INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @intDashboardId = 0
	BEGIN
		DELETE FROM [dbo].[tbl_KPIDashboard]
		WHERE [dashboardId] IS NULL AND [kpiId] = @intKpiId
			AND [ownerUserId] = @intUserId
	END
	ELSE
	BEGIN
		DELETE FROM [dbo].[tbl_KPIDashboard]
		WHERE [dashboardId] = @intDashboardId AND [kpiId] = @intKpiId
			AND [ownerUserId] = @intUserId
	END
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetUserDashboardByKpiId]    Script Date: 05/17/2016 12:23:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jose Carlos Gutiérrez
-- Create date: 2016/05/13
-- Description:	Get dashboards that KPI is into it
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetUserDashboardByKpiId]
	@intKPI		INT,
	@intUserId	INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT 0 AS [dashboardId]
      ,'Main Dashboard' AS [name]
      ,@intUserId [ownerUserId]
	FROM [dbo].[tbl_KpiDashboard] 
			WHERE [dashboardId] IS NULL AND [ownerUserId] = @intUserId
				AND [kpiId] = @intKPI
	UNION
	SELECT [dashboardId]
      ,[name]
      ,[ownerUserId]
	FROM [dbo].[tbl_UserDashboard]
	WHERE [dashboardId] IN (
			SELECT [dashboardId] 
			FROM [dbo].[tbl_KpiDashboard] 
			WHERE [kpiId] = @intKPI AND [ownerUserId] = @intUserId
			)


    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_DeleteUserDashboard]    Script Date: 05/17/2016 12:23:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jose Carlos Gutierrez
-- Create date: 2016/05/13
-- Description:	Deletes a dashboard for user
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_DeleteUserDashboard]
	@intDashboardId	INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0
		-- Procedure called when there is an active transaction.
		-- Create a savepoint to be able to roll back only the work done
		-- in the procedure if there is an error.
		SAVE TRANSACTION DeleteUserDashboard;
	ELSE
		-- Procedure must start its own transaction.
		BEGIN TRANSACTION;

	BEGIN TRY	
	

	DELETE FROM [dbo].[tbl_KpiDashboard]
	WHERE [dashboardId] = @intDashboardId

	DELETE FROM [dbo].[tbl_UserDashboard]
	WHERE [dashboardId] = @intDashboardId

    	-- Llegamos aquí si no hay errores;  debemos hacer un commit de la transacción
		-- que comenzamos, pero no debemos hacer un comit si hubo una transacción
		-- comenzada anteriormente.
		IF @TranCounter = 0
			-- @TranCounter = 0 significa que no se comenzó ninguna transacción antes de 
			-- esta transacción y por lo tando debemos hacer un comit de nuestra 
			-- stranacción.
			COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH

		-- Hubo un error. Debemos detemrinar que tipo de rollback debemos hacer.

		IF @TranCounter = 0
			-- Tenemos sólo la transacción que comenzamos en este SP.  Rollback
			-- toda la transacción.
			ROLLBACK TRANSACTION;
		ELSE
			-- Se comenzó una transacción antes de que llamen a este SP. Debemos hacer
			-- un rollback solo de las modificaciones que hicimos en este SP

			-- Vemos XACT_STATE y los posibles resultados son 0, 1, or -1.
			-- Si es 1, la transacción es válida y se puede hacer un comit. Pero como 
			-- estamos en el CATCH no hacemos comit.
			-- Si es -1 la transacción no es válida y se debe hacer un rollback
			-- Si es - Significa que no hay un transacción y que un rollback causaría un error
			-- Ver http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() <> -1
				-- Si la transacción es todavía válida, hacemos un rollback hasta el punto
				-- de restauración definido anteriormente.  
				-- Sólo podemos hacer un rollback si XACT_STATE() = -1
				-- OJO: Este es el mismo nombre utilizado anterioremente!!  
				ROLLBACK TRANSACTION DeleteUserDashboard;

				-- Si la transaccion no es válida no se puede hacer un commit ni un rollback, 
				-- por lo que un rollback al punto de restauración no es permitido por que 
				-- el rollback al punto de restauración escribiría en el log de la base de 
				-- datos.  Símplemente debemos retornar al que nos llamó y este será 
				-- responsable de hacer rollback a la transacción. 

		-- Luego de hacer el rollback correspondiente, debemos propagar la información de error
		-- al SP que nos llamó. 
		--
		-- Ver http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		-- The database can return values from 0 to 256 but raise error
		-- will only allow us to use values from 1 to 127
		IF(@ErrorState < 1 OR @ErrorState > 127)
			SELECT @ErrorState = 1
			
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH
	
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpisFromDashboard]    Script Date: 05/17/2016 12:23:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jose Carlos Gutiérrez
-- Create date: 2016/05/13
-- Description:	Insert a KPI to Dashboard
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKpisFromDashboard]
	@intDashboardId	INT,
	@intUserId		INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @intDashboardId = 0 
	BEGIN
		SELECT [kpiDashboardId]
			  ,[dashboardId]
			  ,d.[kpiId]
			  ,[ownerUserId]
			  ,k.[name]
		FROM [dbo].[tbl_KPIDashboard] d
			JOIN [dbo].[tbl_KPI] k ON k.[kpiID] = d.[kpiId]
		WHERE [dashboardId] IS NULL
			AND [ownerUserId] = @intUserId
	END 
	ELSE
	BEGIN
		SELECT [kpiDashboardId]
			  ,[dashboardId]
			  ,d.[kpiId]
			  ,[ownerUserId]
			  ,k.[name]
		FROM [dbo].[tbl_KPIDashboard] d
			JOIN [dbo].[tbl_KPI] k ON k.[kpiID] = d.[kpiId]
		WHERE [dashboardId] = @intDashboardId 
			AND [ownerUserId] = @intUserId
	END
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_InsertKpiToDashboard]    Script Date: 05/17/2016 12:23:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jose Carlos Gutiérrez
-- Create date: 2016/05/13
-- Description:	Insert a KPI to Dashboard
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_InsertKpiToDashboard]
	@intDashboardId	INT,
	@intKpiId		INT,
	@intOwnerUserId	INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @intDashboardId = 0
		SET @intDashboardId = NULL

	INSERT INTO [dbo].[tbl_KPIDashboard]
			   ([dashboardId]
			   ,[kpiId]
			   ,[ownerUserId])
		 VALUES
			   (@intDashboardId
			   ,@intKpiId
			   ,@intOwnerUserId)

    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetUserDashboardWhenKpiIdIsNotIn]    Script Date: 05/17/2016 12:23:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jose Carlos Gutiérrez
-- Create date: 2016/05/13
-- Description:	Get dashboards that KPI is not in it
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetUserDashboardWhenKpiIdIsNotIn]
	@intKPI		INT,
	@intUserId	INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--SELECT 0 AS [dashboardId]
 --     ,'Main Dashboard' AS [name]
 --     ,@intUserId [ownerUserId]
	--FROM [dbo].[tbl_KpiDashboard] 
	--WHERE 0 NOT IN (
	--	SELECT 0 AS [dashboardId]
	--	FROM [dbo].[tbl_KpiDashboard] 
	--	WHERE [dashboardId] IS NULL AND [ownerUserId] = @intUserId
	--	)
	--UNION
	SELECT [dashboardId]
      ,[name]
      ,[ownerUserId]
	FROM [dbo].[tbl_UserDashboard]
	WHERE [dashboardId] NOT IN (		
		SELECT ud.[dashboardId]
		FROM [dbo].[tbl_UserDashboard] ud 
			JOIN [dbo].[tbl_KpiDashboard] kd ON kd.[dashboardId] = ud.[dashboardId]
		WHERE kd.[kpiId] = @intKPI AND kd.[ownerUserId] = @intUserId
	)

    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetUserDashboards]    Script Date: 05/17/2016 12:23:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jose Carlos Gutierrez
-- Create date: 2016/05/13
-- Description:	Deletes a dashboard for user
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetUserDashboards]
	@intOwnerUserId	INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [dashboardId]
		  ,[name]
		  ,[ownerUserId]
	FROM [dbo].[tbl_UserDashboard]
	WHERE [ownerUserId] = @intOwnerUserId

    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_InsertUserDashboard]    Script Date: 05/17/2016 12:23:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jose Carlos Gutierrez
-- Create date: 2016/05/13
-- Description:	Inserts a dashboard for user
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_InsertUserDashboard]
	@varName		NVARCHAR(250),
	@intOwnerUser	INT,
	@intDashboardId	INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO [dbo].[tbl_UserDashboard]
		   ([name]
		   ,[ownerUserId])
	VALUES
		   (@varName
		   ,@intOwnerUser)
	       
	SET @intDashboardId = SCOPE_IDENTITY()

    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_UpdateUserDashboard]    Script Date: 05/17/2016 12:23:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jose Carlos Gutierrez
-- Create date: 2016/05/13
-- Description:	Updates a dashboard for user
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_UpdateUserDashboard]
	@varName		NVARCHAR(250),
	@intDashboardId	INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE [dbo].[tbl_UserDashboard]
		   SET [name] = @varName
	WHERE [dashboardId] = @intDashboardId

    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementsForChart]    Script Date: 05/17/2016 12:23:59 ******/
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
	@intKpiId	INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @datStartDate DATE 
	DECLARE @varStrategyId CHAR(3)


	DECLARE @tabDates TABLE([date] DATE PRIMARY KEY)


	SELECT @varStrategyId = [strategyID]
	FROM [dbo].[tbl_KPI] 
	WHERE [kpiID] = @intKpiId

	SELECT @datStartDate = MIN([date])
	FROM [dbo].[tbl_KPIMeasurements]
	WHERE [kpiID] = @intKpiId

	DECLARE @today DATE = GETDATE()
	DECLARE @currentDate DATE = @datStartDate



	WHILE @currentDate <= @today
	BEGIN
		INSERT INTO @tabDates ([date])
		VALUES (@currentDate)
		
		SET @currentDate = DATEADD(DAY, 1, @currentDate)
	END


	DECLARE @tabResult TABLE ([date] DATE,[measurement] DECIMAL(21,3))
	print @varStrategyId
	IF @varStrategyId = 'AVG'
	BEGIN
		INSERT INTO @tabResult
		SELECT [date], AVG([measurement])
		FROM [dbo].[tbl_KPIMeasurements]
		WHERE [kpiID] = @intKpiId
		GROUP BY [date]
		ORDER BY [date] ASC
	END

	IF @varStrategyId = 'SUM'
	BEGIN
		INSERT INTO @tabResult
		SELECT [date], SUM([measurement])
		FROM [dbo].[tbl_KPIMeasurements]
		WHERE [kpiID] = @intKpiId
		GROUP BY [date]
		ORDER BY [date] ASC
	END

	IF @varStrategyId = 'NA'
	BEGIN
		INSERT INTO @tabResult
		SELECT [date], [measurement]
		FROM [dbo].[tbl_KPIMeasurements]
		WHERE [kpiID] = @intKpiId
		ORDER BY [date] ASC
	END


	SELECT d.[date]
		,ISNULL(r.[measurement],0) [measurement]
	FROM @tabDates d
		LEFT OUTER JOIN @tabResult r  ON d.[date] = r.[date] 
	WHERE d.[date] BETWEEN @datStartDate AND @today
END

GO




--=============================================================================================================================

/*
 * We are done, mark the database as a 1.7.0 database.
 */

DELETE FROM [dbo].[tbl_DatabaseInfo] 
INSERT INTO [dbo].[tbl_DatabaseInfo] 
	([majorversion], [minorversion], [releaseversion])
	VALUES (1,7,0)
GO
