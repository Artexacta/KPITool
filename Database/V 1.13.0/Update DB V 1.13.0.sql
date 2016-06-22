/* 
	Updates de the KPIDB database to version 1.13.0 
*/

Use [Master]
GO 

IF  NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'KPIDB')
	RAISERROR('KPIDB database Doesn´t exists. Create the database first',16,127)
GO

PRINT 'Updating KPIDB database to version 1.13.0'

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

IF NOT (@smiMajor = 1 AND @smiMinor = 12) 
BEGIN
	RAISERROR('KPIDB database is not in version 1.12 This program only applies to version 1.12',16,127)
	RETURN;
END

PRINT 'KPIDB Database version OK'
GO

--===================================================================================================

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tbl_KPIMeasurementCategories_tbl_KPIMeasurements]') AND parent_object_id = OBJECT_ID(N'[dbo].[tbl_KPIMeasurementCategories]'))
ALTER TABLE [dbo].[tbl_KPIMeasurementCategories] DROP CONSTRAINT [FK_tbl_KPIMeasurementCategories_tbl_KPIMeasurements]
GO

ALTER TABLE [dbo].[tbl_KPIMeasurementCategories]  WITH CHECK ADD  CONSTRAINT [FK_tbl_KPIMeasurementCategories_tbl_KPIMeasurements] FOREIGN KEY([measurementID])
REFERENCES [dbo].[tbl_KPIMeasurements] ([measurmentID])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[tbl_KPIMeasurementCategories] CHECK CONSTRAINT [FK_tbl_KPIMeasurementCategories_tbl_KPIMeasurements]
GO

/****** Object:  Table [dbo].[tbl_SavedSearch]    Script Date: 06/22/2016 10:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_SavedSearch]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_SavedSearch](
	[searchId] [varchar](50) NOT NULL,
	[userId] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[searchExpression] [varchar](1000) NULL,
	[dateCreated] [datetime] NULL,
 CONSTRAINT [PK_tbl_SavedSearch_1] PRIMARY KEY CLUSTERED 
(
	[searchId] ASC,
	[userId] ASC,
	[name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

/****** Object:  StoredProcedure [dbo].[usp_SEARCH_DeleteSavedSearch]    Script Date: 06/22/2016 10:07:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SEARCH_DeleteSavedSearch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SEARCH_DeleteSavedSearch]
GO

/****** Object:  StoredProcedure [dbo].[usp_SEARCH_GetSavedSearch]    Script Date: 06/22/2016 10:07:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SEARCH_GetSavedSearch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SEARCH_GetSavedSearch]
GO

/****** Object:  StoredProcedure [dbo].[usp_SEARCH_GetSavedSearchBySearchName]    Script Date: 06/22/2016 10:07:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SEARCH_GetSavedSearchBySearchName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SEARCH_GetSavedSearchBySearchName]
GO

/****** Object:  StoredProcedure [dbo].[usp_SEARCH_InsertSavedSearch]    Script Date: 06/22/2016 10:07:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SEARCH_InsertSavedSearch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SEARCH_InsertSavedSearch]
GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_AddDefaultAdministratorAccess]    Script Date: 06/22/2016 10:07:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SEG_AddDefaultAdministratorAccess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SEG_AddDefaultAdministratorAccess]
GO

/****** Object:  StoredProcedure [dbo].[usp_SEARCH_DeleteSavedSearch]    Script Date: 06/22/2016 10:07:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		Vladimir Calderon
-- Create date: 21-02-2011
-- Description:	Deletes a saved search
-- =============================================
CREATE PROCEDURE [dbo].[usp_SEARCH_DeleteSavedSearch]
	-- Add the parameters for the stored procedure here
	@searchId varchar(50), 
	@userId int,
	@name varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DELETE FROM [tbl_SavedSearch] 
    WHERE 
		[searchId] = @searchId
	AND	[userId] = @userId
	AND [name] = @name
END





GO

/****** Object:  StoredProcedure [dbo].[usp_SEARCH_GetSavedSearch]    Script Date: 06/22/2016 10:07:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		Vladimir Calderon
-- Create date: 21-02-2011
-- Description:	Gets all the saved searches for a specific user and search control
-- =============================================
CREATE PROCEDURE [dbo].[usp_SEARCH_GetSavedSearch]
	-- Add the parameters for the stored procedure here
	@searchId varchar(50), 
	@userId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT [searchId]
      ,[userId]
      ,[name]
      ,[searchExpression]
      ,[dateCreated]
    FROM [tbl_SavedSearch] 
    WHERE 
		[searchId] = @searchId
	AND	[userId] = @userId
	ORDER BY [dateCreated] desc
END





GO

/****** Object:  StoredProcedure [dbo].[usp_SEARCH_GetSavedSearchBySearchName]    Script Date: 06/22/2016 10:07:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		Vladimir Calderon
-- Create date: 21-02-2011
-- Description:	Gets one saved search for a search control and a user
-- =============================================
CREATE PROCEDURE [dbo].[usp_SEARCH_GetSavedSearchBySearchName]
	-- Add the parameters for the stored procedure here
	@searchId varchar(50), 
	@userId int,
	@name varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT [searchId]
      ,[userId]
      ,[name]
      ,[searchExpression]
      ,[dateCreated]
    FROM [tbl_SavedSearch] 
    WHERE 
		[searchId] = @searchId
	AND	[userId] = @userId
	AND [name] = @name
END





GO

/****** Object:  StoredProcedure [dbo].[usp_SEARCH_InsertSavedSearch]    Script Date: 06/22/2016 10:07:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		Vladimir Calderon
-- Create date: 21-02-2011
-- Description:	Inserts a saved search
-- =============================================
CREATE PROCEDURE [dbo].[usp_SEARCH_InsertSavedSearch]
	-- Add the parameters for the stored procedure here
	@searchId varchar(50), 
	@userId int,
	@name varchar(50),
	@searchExpression varchar(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	-- Detectamos si el SP fue llamado desde una transacción activa y 
	-- la guardamos para usarla más tarde.  En el SP, @TranCounter = 0
	-- significa que no existen transacciones activas y que este SP
	-- comenzó una.  @TranCounter > 0 significa que se inició una transacción
	-- antes de la que empezaremos en este SP
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;

	IF @TranCounter > 0
		-- Se llamó a este SP cuando ya existe una transacción activa.
		-- Creamos un punto de restauración para poder hacer sólo rollback
		-- de esta transacción si hay algún error.
		-- OJO:  Este nombre tiene que cambiarse!!!  Debe ser único para la 
		-- cadena de transacciones.  También debe cambiarse al final del SP!!!
		SAVE TRANSACTION InsertCompanyProcedureSave;
	ELSE
		-- Este SP comienza su propia transacción y no hay otra antes
		BEGIN TRANSACTION;


	BEGIN TRY
	
		DECLARE @currentNumberSavedSearches int
		DECLARE @maxNumberSavedSearches int
		SET @maxNumberSavedSearches = 10
		
		-- Count the number of saved searches already saved for this user and control
		SELECT @currentNumberSavedSearches = COUNT([name]) 
		FROM [tbl_SavedSearch]
		WHERE
			[searchId] = @searchId
		AND [userId] = @userId
		GROUP BY [searchId],[userId]
		
		-- if more than max allowed, delete the oldest
		IF (@currentNumberSavedSearches >= @maxNumberSavedSearches) 
		BEGIN
			DECLARE @nameToDelete varchar(50)
			
			DELETE FROM [tbl_SavedSearch] 
			WHERE 
				[searchId] = @searchId
			AND [userId] = @userId
			AND [name] = (
				SELECT TOP 1 ss.[name]
				FROM [tbl_SavedSearch] ss
				WHERE
					ss.[searchId] = @searchId
				AND ss.[userId] = @userId
				ORDER BY ss.[dateCreated] ASC)
		END	
		
		INSERT INTO [tbl_SavedSearch]
			   ([searchId]
			   ,[userId]
			   ,[name]
			   ,[searchExpression]
			   ,[dateCreated])
		 VALUES
			   (@searchId
			   ,@userId
			   ,@name
			   ,@searchExpression
			   ,getDate())
			   
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
				ROLLBACK TRANSACTION NOMBRE_PUNTO_DE_RESTAURACION;

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

/****** Object:  StoredProcedure [dbo].[usp_SEG_AddDefaultAdministratorAccess]    Script Date: 06/22/2016 10:07:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- ==============================================================================================================
/* 
* Add default access to administrator.
* The administrator for the application should ALWAYS be able to define access 
* control.  Otherwise the application locks up.  Hence, we add access to
* operation 1 for the given group, if it does not exist.
* Variables: @roleName
*/
CREATE PROCEDURE [dbo].[usp_SEG_AddDefaultAdministratorAccess] 
	-- Add the parameters for the stored procedure here
	@roleName as varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @intCount AS INT 
	SELECT @intCount = count(*) 
	FROM [dbo].[tbl_SEG_AccessRole] 
	WHERE [role] = @roleName 
	AND [permissionID] = (SELECT [permissionID] 
						  FROM [tbl_SEG_Permission]
						  WHERE [mnemonic] = 'MANAGE_SECURITY')
				 
	IF(@intCount = 0)  
		BEGIN
			INSERT INTO [dbo].[tbl_SEG_AccessRole] ([permissionID], [role])
			VALUES (1, @roleName)
		END
	
END






GO

--=================================================================================================

/*
 * We are done, mark the database as a 1.13.0 database.
 */
DELETE FROM [dbo].[tbl_DatabaseInfo] 
INSERT INTO [dbo].[tbl_DatabaseInfo] 
	([majorversion], [minorversion], [releaseversion])
	VALUES (1,13,0)
GO

