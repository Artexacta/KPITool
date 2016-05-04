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

/****** Object:  StoredProcedure [dbo].[usp_ACT_GetActivityById]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ACT_GetActivityById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ACT_GetActivityById]
GO

/****** Object:  StoredProcedure [dbo].[usp_ACT_GetActivityByOrganization]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ACT_GetActivityByOrganization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ACT_GetActivityByOrganization]
GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchActivitiess]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AUTOCOMPLETE_SearchActivitiess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchActivitiess]
GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchAreas]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AUTOCOMPLETE_SearchAreas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchAreas]
GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchOrganizations]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AUTOCOMPLETE_SearchOrganizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchOrganizations]
GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchPeople]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AUTOCOMPLETE_SearchPeople]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchPeople]
GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchProjects]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AUTOCOMPLETE_SearchProjects]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchProjects]
GO

/****** Object:  StoredProcedure [dbo].[usp_CATEGORY_DeleteCategory]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CATEGORY_DeleteCategory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CATEGORY_DeleteCategory]
GO

/****** Object:  StoredProcedure [dbo].[usp_CATEGORY_DeleteCategoryItem]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CATEGORY_DeleteCategoryItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CATEGORY_DeleteCategoryItem]
GO

/****** Object:  StoredProcedure [dbo].[usp_CATEGORY_GetAllCategories]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CATEGORY_GetAllCategories]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CATEGORY_GetAllCategories]
GO

/****** Object:  StoredProcedure [dbo].[usp_CATEGORY_GetCategoryById]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CATEGORY_GetCategoryById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CATEGORY_GetCategoryById]
GO

/****** Object:  StoredProcedure [dbo].[usp_CATEGORY_GetCategoryItemById]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CATEGORY_GetCategoryItemById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CATEGORY_GetCategoryItemById]
GO

/****** Object:  StoredProcedure [dbo].[usp_CATEGORY_GetCategoryItemsByCategoryId]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CATEGORY_GetCategoryItemsByCategoryId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CATEGORY_GetCategoryItemsByCategoryId]
GO

/****** Object:  StoredProcedure [dbo].[usp_CATEGORY_UpdateCategory]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CATEGORY_UpdateCategory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CATEGORY_UpdateCategory]
GO

/****** Object:  StoredProcedure [dbo].[usp_CATEGORY_UpdateCategoryItem]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CATEGORY_UpdateCategoryItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CATEGORY_UpdateCategoryItem]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIById]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKPIById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKPIById]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByOrganization]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKPIsByOrganization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKPIsByOrganization]
GO

/****** Object:  StoredProcedure [dbo].[usp_ORG_GetAreasByOrganization]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ORG_GetAreasByOrganization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ORG_GetAreasByOrganization]
GO

/****** Object:  StoredProcedure [dbo].[usp_PEOPLE_GetPersonById]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PEOPLE_GetPersonById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PEOPLE_GetPersonById]
GO

/****** Object:  StoredProcedure [dbo].[usp_PROJ_GetProjectsByOrganization]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PROJ_GetProjectsByOrganization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PROJ_GetProjectsByOrganization]
GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_InsertOperationForRole]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SEG_InsertOperationForRole]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SEG_InsertOperationForRole]
GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_InsertOperationForUser]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SEG_InsertOperationForUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SEG_InsertOperationForUser]
GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_IsPermissionAllowedForRole]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SEG_IsPermissionAllowedForRole]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SEG_IsPermissionAllowedForRole]
GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_IsPermissionAllowedForUser]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SEG_IsPermissionAllowedForUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SEG_IsPermissionAllowedForUser]
GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_IsUserAllowedToPerformPermission]    Script Date: 05/04/2016 10:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SEG_IsUserAllowedToPerformPermission]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SEG_IsUserAllowedToPerformPermission]
GO

USE [KPIDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_ACT_GetActivityById]    Script Date: 05/04/2016 10:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 30/04/2016
-- Description:	Get persona by id
-- =============================================
CREATE PROCEDURE [dbo].[usp_ACT_GetActivityById]
	@intActivityId AS INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [activityID]
		  ,[name]
		  ,[organizationID]
		  ,[areaID]
		  ,[projectID]
	FROM [dbo].[tbl_Activity] 
	WHERE [activityID] = @intActivityId
    
END


GO

/****** Object:  StoredProcedure [dbo].[usp_ACT_GetActivityByOrganization]    Script Date: 05/04/2016 10:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 02/05/2016
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ACT_GetActivityByOrganization]
	@intOrganizationId INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [a].[activityID]
		  ,[a].[name]
		  ,[a].[organizationID]
		  ,[a].[areaID]
		  ,[a].[projectID]
		  ,[kpi].[numberKPIs]
	FROM [dbo].[tbl_Activity] [a] 
	LEFT OUTER JOIN (SELECT COUNT([kpiID]) [numberKPIs]
						   ,[organizationID]
						   ,[activityID]
					 FROM [dbo].[tbl_KPI] 
					 GROUP BY [organizationID], [activityID]) [kpi] 
	ON [a].[organizationID] = [kpi].[organizationID] AND [a].[activityID] = [kpi].[activityID] 
	WHERE [a].[organizationID] = @intOrganizationId
    
END


GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchActivitiess]    Script Date: 05/04/2016 10:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 30/04/2016
-- Description:	Get activities for autocomplete
-- =============================================
CREATE PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchActivitiess]
	@varUserName AS VARCHAR(50),
	@intOrganizationId AS INT,
	@intAreaId AS INT,
	@intProjectId AS INT,
	@varFilter AS VARCHAR(250)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [a].[activityID]
		  ,[a].[name]
		  ,[a].[organizationID]
		  ,[a].[areaID]
		  ,[a].[projectID]
	FROM [dbo].[tbl_Activity] [a] 
	INNER JOIN [dbo].[tbl_SEG_ObjectPermissions] [op] ON [a].[activityID] = [op].[objectID] 
	WHERE [op].[objectTypeID] = 'ACTIVITY' 
	AND [op].[username] = @varUserName
	AND [a].[name] LIKE CASE @varFilter WHEN '' THEN [a].[name] ELSE '%' + @varFilter + '%' END 
	AND [a].[organizationID] = @intOrganizationId 
	AND ISNULL([a].[areaID],0) = CASE WHEN ISNULL(@intAreaId,0) = 0 THEN ISNULL([a].[areaID],0) ELSE ISNULL(@intAreaId,0) END 
	AND ISNULL([a].[projectID],0) = CASE WHEN ISNULL(@intProjectId,0) = 0 THEN ISNULL([a].[projectID],0) ELSE ISNULL(@intProjectId,0) END 
	ORDER BY [a].[name]
    
END


GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchAreas]    Script Date: 05/04/2016 10:30:50 ******/
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

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchOrganizations]    Script Date: 05/04/2016 10:30:50 ******/
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

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchPeople]    Script Date: 05/04/2016 10:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 30/04/2016
-- Description:	Get people for autocomplete
-- =============================================
CREATE PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchPeople]
	@varUserName AS VARCHAR(50),
	@intOrganizationId AS INT,
	@intAreaId AS INT,
	@varFilter AS VARCHAR(250)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [p].[personID]
		  ,[p].[id]
		  ,[p].[name]
		  ,[p].[organizationID]
		  ,[p].[areaID]
	FROM [dbo].[tbl_People] [p] 
	INNER JOIN [dbo].[tbl_SEG_ObjectPermissions] [op] ON [p].[personID] = [op].[objectID] 
	WHERE [op].[objectTypeID] = 'PERSON' 
	AND [op].[username] = @varUserName
	AND [p].[name] LIKE CASE @varFilter WHEN '' THEN [p].[name] ELSE '%' + @varFilter + '%' END 
	AND [p].[organizationID] = @intOrganizationId 
	AND ISNULL([p].[areaID],0) = CASE WHEN ISNULL(@intAreaId,0) = 0 THEN ISNULL([p].[areaID],0) ELSE ISNULL(@intAreaId,0) END 
	ORDER BY [p].[name]
    
END


GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchProjects]    Script Date: 05/04/2016 10:30:50 ******/
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

/****** Object:  StoredProcedure [dbo].[usp_CATEGORY_DeleteCategory]    Script Date: 05/04/2016 10:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 30/04/2016
-- Description:	Delete category
-- =============================================
CREATE PROCEDURE [dbo].[usp_CATEGORY_DeleteCategory]
	@varCategoryId varchar(20)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	-- We detect if the SP was called from an active transation and 
	-- we save it to use it later.  In the SP, @TranCounter = 0
	-- means that there are no active transations and that this SP
	-- started one. @TranCounter > 0 means that a transation was started
	-- before we started this SP
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0
		-- We called this SP when an active transaction already exists.
		-- We create a savepoint to be able to only roll back this 
		-- transaction if there is some error.
		SAVE TRANSACTION DeleteCategoryPS;     
	ELSE
		-- This SP starts its own transaction and there was no previous transaction
		BEGIN TRANSACTION;

	BEGIN TRY
		
		DELETE FROM [dbo].[tbl_KPITargetCategories] 
		WHERE [categoryID] = @varCategoryId 
		
		DELETE FROM [dbo].[tbl_KPIMeasurementCategories] 
		WHERE [categoryID] = @varCategoryId
		
		DELETE FROM [dbo].[tbl_KPICategories] 
		WHERE [categoryID] = @varCategoryId
		
		DELETE FROM [dbo].[tbl_CategoryItem] 
		WHERE [categoryID] = @varCategoryId
		
		DELETE FROM [dbo].[tbl_Category] 
		WHERE [categoryID] = @varCategoryId 
	    
	    -- We arrived here without errors; we should commit the transation we started
		-- but we should not commit if there was a previous transaction started
		IF @TranCounter = 0
			-- @TranCounter = 0 means that no other transaction was started before this transaction 
			-- and that we shouold hence commit this transaction
			COMMIT TRANSACTION;
		
	END TRY
	BEGIN CATCH

		-- There was an error.  We need to determine what type of rollback we must perform

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		IF @TranCounter = 0
			-- We have only the transaction that we started in this SP.  Rollback
			-- all the tranaction.
			ROLLBACK TRANSACTION;
		ELSE
			-- A transaction was started before this SP was called.  We must
			-- rollback only the changes we made in this SP.

			-- We see XACT_STATE and the possible results are 0, 1, or -1.
			-- If it is 1, the transaction is valid and we can do a commit. But since we are in the 
			-- CATCH we don't do the commit. We need to rollback to the savepoint
			-- If it is -1 the transaction is not valid and we must do a full rollback... we can't
			-- do a rollback to a savepoint
			-- XACT_STATE = 0 means that there is no transaciton and a rollback would cause an error
			-- See http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() = 1
				-- If the transaction is still valid then we rollback to the restore point defined before
				ROLLBACK TRANSACTION DeleteCategoryPS;

				-- If the transaction is not valid we cannot do a commit or a rollback to a savepoint
				-- because a rollback is not allowed. Hence, we must simply return to the caller and 
				-- they will be respnsible to rollback the transaction

				-- If there is no tranaction then there is nothing left to do

		-- After doing the correpsonding rollback, we must propagate the error information to the SP that called us 
		-- See http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

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

/****** Object:  StoredProcedure [dbo].[usp_CATEGORY_DeleteCategoryItem]    Script Date: 05/04/2016 10:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 30/04/2016
-- Description:	Delete category item
-- =============================================
CREATE PROCEDURE [dbo].[usp_CATEGORY_DeleteCategoryItem]
	@varCategoryItemId VARCHAR(20),
	@varCategoryId AS VARCHAR(20)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	-- We detect if the SP was called from an active transation and 
	-- we save it to use it later.  In the SP, @TranCounter = 0
	-- means that there are no active transations and that this SP
	-- started one. @TranCounter > 0 means that a transation was started
	-- before we started this SP
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0
		-- We called this SP when an active transaction already exists.
		-- We create a savepoint to be able to only roll back this 
		-- transaction if there is some error.
		SAVE TRANSACTION DeleteCategoryItemPS;     
	ELSE
		-- This SP starts its own transaction and there was no previous transaction
		BEGIN TRANSACTION;

	BEGIN TRY
		
		DELETE FROM [dbo].[tbl_KPITargetCategories] 
		WHERE [categoryItemID] = @varCategoryItemId 
		
		DELETE FROM [dbo].[tbl_KPIMeasurementCategories] 
		WHERE [categoryItemID] = @varCategoryItemId
		
		DELETE FROM [dbo].[tbl_CategoryItem] 
		WHERE [categoryItemID] = @varCategoryItemId 
		AND [categoryID] = @varCategoryId
	    
	    
	    -- We arrived here without errors; we should commit the transation we started
		-- but we should not commit if there was a previous transaction started
		IF @TranCounter = 0
			-- @TranCounter = 0 means that no other transaction was started before this transaction 
			-- and that we shouold hence commit this transaction
			COMMIT TRANSACTION;
		
	END TRY
	BEGIN CATCH

		-- There was an error.  We need to determine what type of rollback we must perform

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		IF @TranCounter = 0
			-- We have only the transaction that we started in this SP.  Rollback
			-- all the tranaction.
			ROLLBACK TRANSACTION;
		ELSE
			-- A transaction was started before this SP was called.  We must
			-- rollback only the changes we made in this SP.

			-- We see XACT_STATE and the possible results are 0, 1, or -1.
			-- If it is 1, the transaction is valid and we can do a commit. But since we are in the 
			-- CATCH we don't do the commit. We need to rollback to the savepoint
			-- If it is -1 the transaction is not valid and we must do a full rollback... we can't
			-- do a rollback to a savepoint
			-- XACT_STATE = 0 means that there is no transaciton and a rollback would cause an error
			-- See http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() = 1
				-- If the transaction is still valid then we rollback to the restore point defined before
				ROLLBACK TRANSACTION DeleteCategoryItemPS;

				-- If the transaction is not valid we cannot do a commit or a rollback to a savepoint
				-- because a rollback is not allowed. Hence, we must simply return to the caller and 
				-- they will be respnsible to rollback the transaction

				-- If there is no tranaction then there is nothing left to do

		-- After doing the correpsonding rollback, we must propagate the error information to the SP that called us 
		-- See http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

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

/****** Object:  StoredProcedure [dbo].[usp_CATEGORY_GetAllCategories]    Script Date: 05/04/2016 10:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 29/04/2016
-- Description:	Get all categories
-- =============================================
CREATE PROCEDURE [dbo].[usp_CATEGORY_GetAllCategories] 
	
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [categoryID]
		  ,[name]
	FROM [dbo].[tbl_Category] 
	ORDER BY [name]
    
END


GO

/****** Object:  StoredProcedure [dbo].[usp_CATEGORY_GetCategoryById]    Script Date: 05/04/2016 10:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 29/04/2016
-- Description:	Get category by id
-- =============================================
CREATE PROCEDURE [dbo].[usp_CATEGORY_GetCategoryById] 
	@intCategoryId AS VARCHAR(20)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [categoryID]
		  ,[name]
	FROM [dbo].[tbl_Category] 
	WHERE [categoryID] = @intCategoryId
    
END


GO

/****** Object:  StoredProcedure [dbo].[usp_CATEGORY_GetCategoryItemById]    Script Date: 05/04/2016 10:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 30/04/2016
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_CATEGORY_GetCategoryItemById]
	@varCategoryItemId AS VARCHAR(20),
	@varCategoryId AS VARCHAR(20)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [categoryItemID]
		  ,[categoryID]
		  ,[name]
	FROM [dbo].[tbl_CategoryItem] 
	WHERE [categoryItemID] = @varCategoryItemId 
	AND [categoryID] = @varCategoryId
    
END


GO

/****** Object:  StoredProcedure [dbo].[usp_CATEGORY_GetCategoryItemsByCategoryId]    Script Date: 05/04/2016 10:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 30/04/2016
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_CATEGORY_GetCategoryItemsByCategoryId]
	@varCategoryId AS VARCHAR(20)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [categoryItemID]
		  ,[categoryID]
		  ,[name]
	FROM [dbo].[tbl_CategoryItem] 
	WHERE [categoryID] = @varCategoryId 
	ORDER BY [name]
    
END


GO

/****** Object:  StoredProcedure [dbo].[usp_CATEGORY_UpdateCategory]    Script Date: 05/04/2016 10:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 30/04/2016
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_CATEGORY_UpdateCategory]
	@varCategoryName NVARCHAR(250),
	@varCategoryId varchar(20)
AS
BEGIN
	
	SET NOCOUNT ON;

    UPDATE [dbo].[tbl_Category]
    SET [name] = @varCategoryName 
    WHERE [categoryID] = @varCategoryId 
    
END


GO

/****** Object:  StoredProcedure [dbo].[usp_CATEGORY_UpdateCategoryItem]    Script Date: 05/04/2016 10:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 30/04/2016
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_CATEGORY_UpdateCategoryItem]
	@varCategoryItemId AS VARCHAR(20),
	@varCategoryId AS VARCHAR(20),
	@varName AS NVARCHAR(250)
AS
BEGIN
	
	SET NOCOUNT ON;

    UPDATE [dbo].[tbl_CategoryItem]
	SET [name] = @varName 
	WHERE [categoryItemID] = @varCategoryItemId 
    AND [categoryID] = @varCategoryId
    
END


GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIById]    Script Date: 05/04/2016 10:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Marcela Martinez
-- Create date: 03/05/2016
-- Description:	Get KPI by id
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKPIById]
	 @intKPIId INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [kpiID]
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
	FROM [dbo].[tbl_KPI] 
	WHERE [kpiID] = @intKPIId
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByOrganization]    Script Date: 05/04/2016 10:30:50 ******/
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
	 @intOrganizationId INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [kpiID]
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
	FROM [dbo].[tbl_KPI] 
	WHERE [organizationID] = @intOrganizationId
	
    
END


GO

/****** Object:  StoredProcedure [dbo].[usp_ORG_GetAreasByOrganization]    Script Date: 05/04/2016 10:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Gabriela Sanchez
-- Create date: April 29 2016
-- Description:	Get areas by organization
-- =============================================
CREATE PROCEDURE [dbo].[usp_ORG_GetAreasByOrganization]
	 @intOrganizationId INT
AS
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT [a].[areaID]
		  ,[a].[organizationID]
		  ,[a].[name]
		  ,[kpi].[numberKPIs]
	FROM [dbo].[tbl_Area] [a] 
	LEFT OUTER JOIN (SELECT COUNT([kpiID]) [numberKPIs]
						   ,[organizationID]
						   ,[areaID]
					 FROM [dbo].[tbl_KPI] 
					 GROUP BY [organizationID], [areaID]) [kpi] 
	ON [a].[organizationID] = [kpi].[organizationID] AND [a].[areaID] = [kpi].[areaID] 
	WHERE [a].[organizationID] = @intOrganizationId


END


GO

/****** Object:  StoredProcedure [dbo].[usp_PEOPLE_GetPersonById]    Script Date: 05/04/2016 10:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 30/04/2016
-- Description:	Get persona by id
-- =============================================
CREATE PROCEDURE [dbo].[usp_PEOPLE_GetPersonById]
	@intPersonId AS INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [personID]
		  ,[id]
		  ,[name]
		  ,[organizationID]
		  ,[areaID]
	FROM [dbo].[tbl_People] 
	WHERE [personID] = @intPersonId
    
END


GO

/****** Object:  StoredProcedure [dbo].[usp_PROJ_GetProjectsByOrganization]    Script Date: 05/04/2016 10:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: April 29 2016
-- Description:	List all projects by organization
-- =============================================
CREATE PROCEDURE [dbo].[usp_PROJ_GetProjectsByOrganization]
	@intOrganizationId INT
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT [p].[projectID]
		  ,[p].[name]
		  ,[p].[organizationID]
		  ,[p].[areaID]
		  ,[kpi].[numberKPIs]
	FROM [dbo].[tbl_Project] [p] 
	LEFT OUTER JOIN (SELECT COUNT([kpiID]) [numberKPIs]
						   ,[organizationID]
						   ,[projectID]
					 FROM [dbo].[tbl_KPI] 
					 GROUP BY [organizationID], [projectID]) [kpi] 
	ON [p].[organizationID] = [kpi].[organizationID] AND [p].[projectID] = [kpi].[projectID] 
	WHERE [p].[organizationID] = @intOrganizationId

END


GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_InsertOperationForRole]    Script Date: 05/04/2016 10:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[usp_SEG_InsertOperationForRole]
	@intPermissionID int,
	@varRole varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF NOT EXISTS(
					SELECT * 
						FROM [dbo].[tbl_SEG_AccessRole] 
						WHERE [permissionid] = @intPermissionID AND [role] = @varRole
				  ) 
	BEGIN
		INSERT INTO [dbo].[tbl_SEG_AccessRole]([permissionid], [role])
			VALUES (@intPermissionID, @varRole)
	END
END





GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_InsertOperationForUser]    Script Date: 05/04/2016 10:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[usp_SEG_InsertOperationForUser]
	@intPermissionID int,
	@intUserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF NOT EXISTS(
					SELECT * 
						FROM [dbo].[tbl_SEG_AccessUser] 
						WHERE [permissionID] = @intPermissionID AND [userID] = @intUserID
				  ) 
	BEGIN
		INSERT INTO [dbo].[tbl_SEG_AccessUser]([permissionID], [userID])
			VALUES (@intPermissionID, @intUserID)
	END
END





GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_IsPermissionAllowedForRole]    Script Date: 05/04/2016 10:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_SEG_IsPermissionAllowedForRole]
	@intPermissionID int,
	@varRole varchar(100)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT COUNT([permissionid]) AS [OC] 
	FROM [dbo].[tbl_SEG_AccessRole] [ar]
	WHERE [ar].[permissionid] = @intPermissionID 
	AND [ar].[role] = @varRole
	
END




GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_IsPermissionAllowedForUser]    Script Date: 05/04/2016 10:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_SEG_IsPermissionAllowedForUser]
	@intPermissionID int,
	@intUserId int
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT COUNT([permissionId]) AS [OC] 
	FROM [dbo].[tbl_SEG_AccessUser] [au]
	WHERE [au].[permissionid] = @intPermissionID 
	AND [au].[userid] = @intUserId
	
END




GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_IsUserAllowedToPerformPermission]    Script Date: 05/04/2016 10:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- ==============================================================================================================
/* 
* Get 1 if the user is allowed to perform permission and 0 otherwise
* Variables: @varMnemonic,  @intUserID
* Created by: Javier Viscarra Vargas
* Date: 10/Nov/2008
*/
CREATE PROCEDURE [dbo].[usp_SEG_IsUserAllowedToPerformPermission] 
	@varMnemonic varchar(100),
	@intUser int
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT COUNT(*) [count]
	FROM [dbo].[tbl_SEG_Permission] [os], [dbo].[tbl_SEG_AccessUser] [au]
	WHERE [os].[permissionID] = [au].[permissionID]
	AND [os].[mnemonic] = @varMnemonic
	AND [au].[userID] = @intUser
		
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