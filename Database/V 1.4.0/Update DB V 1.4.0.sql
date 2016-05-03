/* 
	Updates de the KPIDB database to version 1.4.0 
*/

Use [Master]
GO 

IF  NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'KPIDB')
	RAISERROR('KPIDB database Doesn´t exists. Create the database first',16,127)
GO

PRINT 'Updating KPIDB database to version 1.4.0'

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

IF NOT (@smiMajor = 1 AND @smiMinor = 3) 
BEGIN
	RAISERROR('KPIDB database is not in version 1.3 This program only applies to version 1.3',16,127)
	RETURN;
END

PRINT 'KPIDB Database version OK'
GO

-----------------------------------------

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchAreas]    Script Date: 04/29/2016 18:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AUTOCOMPLETE_SearchAreas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchAreas]
GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchOrganizations]    Script Date: 04/29/2016 18:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AUTOCOMPLETE_SearchOrganizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchOrganizations]
GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchProjects]    Script Date: 04/29/2016 18:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AUTOCOMPLETE_SearchProjects]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchProjects]
GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchUsers]    Script Date: 04/29/2016 18:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AUTOCOMPLETE_SearchUsers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchUsers]
GO

/****** Object:  StoredProcedure [dbo].[usp_ORG_GetAreaById]    Script Date: 04/29/2016 18:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ORG_GetAreaById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ORG_GetAreaById]
GO

/****** Object:  StoredProcedure [dbo].[usp_PROJ_GetProjectById]    Script Date: 04/29/2016 18:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PROJ_GetProjectById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PROJ_GetProjectById]
GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_UpdateUserRecord]    Script Date: 04/29/2016 18:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SEG_UpdateUserRecord]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SEG_UpdateUserRecord]
GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchAreas]    Script Date: 04/29/2016 18:23:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Marcela Martinez
-- Create date: 25/04/2016
-- Description:	Get areas for autocomplete
-- ===============================================
CREATE PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchAreas]
	@intOrganizationId AS INT,
	@varFilter AS VARCHAR(250)
AS
BEGIN
	
	SET NOCOUNT ON;

    IF(@varFilter IS NULL)
		SELECT @varFilter = ''
	
	SELECT TOP 10 [areaID]
		  ,[organizationID]
		  ,[name]
	FROM [dbo].[tbl_Area] 
	WHERE [name] LIKE CASE @varFilter WHEN '' THEN [name] ELSE '%' + @varFilter + '%' END 
	AND [organizationID] = @intOrganizationId 
	ORDER BY [name]
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchOrganizations]    Script Date: 04/29/2016 18:23:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ===============================================
-- Author:		Marcela Martinez
-- Create date: 25/04/2016
-- Description:	Get organizations for autocomplete
-- ===============================================
CREATE PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchOrganizations]
	@varUserName AS VARCHAR(50),
	@varFilter AS VARCHAR(250)
AS
BEGIN
	
	SET NOCOUNT ON;

    IF(@varFilter IS NULL)
		SELECT @varFilter = ''
	
	SELECT [or].[organizationID]
		  ,[or].[name]
	FROM [dbo].[tbl_Organization] [or] 
	INNER JOIN [dbo].[tbl_SEG_ObjectPermissions] [op] ON [or].[organizationID] = [op].[objectID] 
	WHERE [op].[objectTypeID] = 'ORGANIZATION' 
	AND [op].[username] = @varUserName
	AND [or].[name] LIKE CASE @varFilter WHEN '' THEN [or].[name] ELSE '%' + @varFilter + '%' END 
	ORDER BY [or].[name]
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchProjects]    Script Date: 04/29/2016 18:23:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Marcela Martinez
-- Create date: 29/04/2016
-- Description:	Get projects for autocomplete
-- =============================================
CREATE PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchProjects]
	@varUserName AS VARCHAR(50),
	@intOrganizationId AS INT,
	@intAreaId AS INT,
	@varFilter AS VARCHAR(250)
AS
BEGIN
	
	SET NOCOUNT ON;

    IF(@varFilter IS NULL)
		SELECT @varFilter = ''
	
	SELECT [p].[projectID]
		  ,[p].[name]
		  ,[p].[organizationID]
		  ,[p].[areaID]
	FROM [dbo].[tbl_Project] [p] 
	INNER JOIN [dbo].[tbl_SEG_ObjectPermissions] [op] ON [p].[projectID] = [op].[objectID] 
	WHERE [op].[objectTypeID] = 'PROJECT' 
	AND [op].[username] = @varUserName
	AND [p].[name] LIKE CASE @varFilter WHEN '' THEN [p].[name] ELSE '%' + @varFilter + '%' END 
	AND [p].[organizationID] = @intOrganizationId 
	AND ISNULL([p].[areaID],0) = CASE WHEN ISNULL(@intAreaId,0) = 0 THEN ISNULL([p].[areaID],0) ELSE ISNULL(@intAreaId,0) END 
	ORDER BY [p].[name]
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchUsers]    Script Date: 04/29/2016 18:23:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Jose Miguel Alvarez
-- Create date: 30/01/2012
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchUsers]
	@pageSize AS INT,                      
	@firstItem AS INT,
	@varFilter AS VARCHAR(250),
	@totalNumberOfRows INT OUTPUT
AS
BEGIN
	
	SET NOCOUNT ON;

    -- NOTA:  ES importante mencionar que esta función no es escalable 
	-- indefinidamente.  Si el número total de filas es razonablemente chico 
	-- (por ejemplo, 100,000 registros) el desempeño es aceptable. Cuando el número
	-- de filas es muy grande (por ejemplo, tres milones) el query puede tardar mucho
	-- por que SQL Server tiene que contar las filas.  En este caso, deberíamos 
	-- reducir el número de filas utilizando un parámetro de búsqueda en el 
	-- WHERE que se encuentra comentada en SELECT interno.

	-- Lo que queremos es hacer hacer algo así como:
	--
	--    SELECT [ProductID], NúmeroDeFila
	--    FROM [SalesLT].[Product]
	--    WHERE NúmeroDeFila between (@firstItem + 1) and (@firstItem + @pageSize) 
	--
	-- Para esto usamos la función ROW_NUMBER() 
	-- Ver http://msdn.microsoft.com/en-us/library/ms186734.aspx
	--
 
	if(@varFilter IS null)
		SELECT @varFilter = ''
		
	-- Contamos el número total de filas para el SELECT y lo devolvemos 
	-- al que nos llama
	
	SELECT @totalNumberOfRows = count([usr].[userId]) 
		FROM [dbo].[tbl_SEG_User] [usr]
		WHERE 
			[usr].[fullname] LIKE CASE @varFilter WHEN '' 
				THEN [usr].[fullname] ELSE '%' + @varFilter + '%' END
	
	-- Y jalamos sólamente las filas indicadas
	
	SELECT [userId]
		  ,[fullname]
		  ,[cellphone]
		  ,[address]
		  ,[phonenumber]
		  ,[phonearea]
		  ,[phonecode]
		  ,[username]
		  ,[email]
    FROM 
    (
		SELECT 	[userId]
			  ,[fullname]
			  ,[cellphone]
			  ,[address]
			  ,[phonenumber]
			  ,[phonearea]
			  ,[phonecode]
			  ,[username]
			  ,[email]
			, ROW_NUMBER() OVER (ORDER BY [usr].[fullname]) as RowNumber
		FROM [dbo].[tbl_SEG_User] [usr]
		WHERE 
			[usr].[fullname] LIKE CASE @varFilter WHEN ''
				THEN [usr].[fullname] ELSE '%' + @varFilter + '%' END
	) AS data 
    WHERE RowNumber between (@firstItem + 1) and (@firstItem + @pageSize)
	
END


GO

/****** Object:  StoredProcedure [dbo].[usp_ORG_GetAreaById]    Script Date: 04/29/2016 18:23:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Marcela Martinez
-- Create date: 29/04/2016
-- Description:	Get area by Id
-- =============================================
CREATE PROCEDURE [dbo].[usp_ORG_GetAreaById]
	@intAreaId AS INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [areaID]
		  ,[organizationID]
		  ,[name]
	FROM [dbo].[tbl_Area]
	WHERE [areaID] = @intAreaId
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_PROJ_GetProjectById]    Script Date: 04/29/2016 18:23:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Marcela Martinez
-- Create date: 29/04/2016
-- Description:	Get Project by id
-- =============================================
CREATE PROCEDURE [dbo].[usp_PROJ_GetProjectById]
	@intProjectId AS INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [projectID]
		,[name]
		,[organizationID]
		,[areaID]
	FROM [dbo].[tbl_Project]
	WHERE [projectID] = @intProjectId
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_UpdateUserRecord]    Script Date: 04/29/2016 18:23:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--=======================================================================================================
CREATE PROCEDURE [dbo].[usp_SEG_UpdateUserRecord]
	@varFullname AS VARCHAR(500),
	@varCellphone AS VARCHAR(50),
	@varAddress AS VARCHAR(250),
	@varPhone AS VARCHAR(50),
	@varPhoneArea AS INT,
	@varPhoneCode AS INT,
	@varUsername AS VARCHAR(50),
	@intUserId as int,
	@varEmail AS VARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @varFinalFullname AS VARCHAR(500)
	DECLARE @varFinalCellphone AS VARCHAR(50)
	DECLARE @varFinalAddress AS VARCHAR(250)
	DECLARE @varFinalPhone AS VARCHAR(50)
	DECLARE @varFinalUsername AS VARCHAR(50)
	DECLARE @varFinalEmail AS VARCHAR(100)

	IF(@varFullname = '')
		SELECT @varFinalFullname = NULL 
	ELSE
		SELECT @varFinalFullname = @varFullname

	IF(@varCellphone = '')
		SELECT @varFinalCellphone = NULL 
	ELSE
		SELECT @varFinalCellphone = @varCellphone

	IF(@varAddress = '')
		SELECT @varFinalAddress = NULL 
	ELSE
		SELECT @varFinalAddress = @varAddress

	IF(@varPhone = '')
		SELECT @varFinalPhone = NULL 
	ELSE
		SELECT @varFinalPhone = @varPhone

	IF(@varUsername = '')
		SELECT @varFinalUsername = NULL 
	ELSE
		SELECT @varFinalUsername = @varUsername

	IF (@varEmail = '')
		SELECT @varFinalEmail = NULL
	ELSE
		SELECT @varFinalEmail = @varEmail
		
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
		SAVE TRANSACTION UpdateUserPS;
	ELSE
		-- Este SP comienza su propia transacción y no hay otra antes
		BEGIN TRANSACTION;
	BEGIN TRY
	
		UPDATE [dbo].[tbl_SEG_User]
	    SET [fullname] = @varFinalFullname
		  ,[cellphone] = @varFinalCellphone
		  ,[address] = @varFinalAddress
		  ,[phonenumber] = @varFinalPhone
		  ,[phonearea] = @varPhoneArea
		  ,[phonecode] = @varPhoneCode
		  ,[username] = @varFinalUsername
		  ,[email] = @varFinalEmail
		WHERE 
			[userid] = @intUserId
	
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
				ROLLBACK TRANSACTION UpdateUserPS;

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


--=============================================================================================================================

/*
 * We are done, mark the database as a 1.4.0 database.
 */

DELETE FROM [dbo].[tbl_DatabaseInfo] 
INSERT INTO [dbo].[tbl_DatabaseInfo] 
	([majorversion], [minorversion], [releaseversion])
	VALUES (1,4,0)
GO