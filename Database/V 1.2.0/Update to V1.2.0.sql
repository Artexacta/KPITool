USE KPIDB
GO

--=============================================================================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 21 2016
-- Description:	List organizations
-- =============================================
CREATE PROCEDURE usp_ORG_GetAllOrganizations 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT [organizationID], [name]
	FROM [dbo].[tbl_Organization]

END
GO

--=============================================================================================================================

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Cerate a new person
-- =============================================
CREATE PROCEDURE [dbo].[usp_PEOPLE_InsertPerson]
	@userName varchar(50),
	@organizationID int,
	@areaID int,
	@personName nvarchar(250),
	@id nvarchar(50),
	@personID int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
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
		-- ===============================================
		---  MAKE SURE THAT THIS NAME IS COPIED BELOW 
		---  AND IS UNIQUE IN THE SYSTEM!!!!!!
		-- ===============================================
		SAVE TRANSACTION InsertPersonPS;     
	ELSE
		-- This SP starts its own transaction and there was no previous transaction
		BEGIN TRANSACTION;

	BEGIN TRY
		
		IF(@areaID = 0)
			SELECT @areaID = null

		INSERT INTO [dbo].[tbl_People]
           ([id]
           ,[name]
           ,[organizationID]
           ,[areaID])
		VALUES
           (@id
           ,@personName
           ,@organizationID
           ,@areaID)

		SELECT @personID = SCOPE_IDENTITY()

		-- Ensure that the owner can manage this object
		INSERT INTO [dbo].[tbl_SEG_ObjectPermissions]
           ([objectTypeID]
           ,[objectID]
           ,[username]
           ,[objectActionID])
		VALUES
           ('PERSON'
           ,@personID
           ,@userName
           ,'OWN')

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
				-- ===============================================
				---  MAKE SURE THAT THIS NAME IS EXACTLY AS ABOVE 
				-- ===============================================
				ROLLBACK TRANSACTION InsertPersonPS;

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

--=============================================================================================================================

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Get the full lists of people
-- =============================================
CREATE PROCEDURE [dbo].[usp_PEOPLE_GetAllPeople]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [personID]
      ,[id]
      ,[name]
      ,[organizationID]
      ,[areaID]
	FROM [dbo].[tbl_People]

END
GO

--=============================================================================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 22 2014
-- Description:	List all projects in the system
-- =============================================
CREATE PROCEDURE usp_PROJ_GetAllProjects
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [projectID]
		,[name]
		,[organizationID]
		,[areaID]
	FROM [dbo].[tbl_Project]

END
GO


--=============================================================================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 22 2016
-- Description:	List all activities in the system
-- =============================================
CREATE PROCEDURE usp_ACT_GetAllActivities
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [activityID]
		  ,[name]
		  ,[organizationID]
		  ,[areaID]
		  ,[projectID]
	  FROM [dbo].[tbl_Activity]
END
GO


--=============================================================================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Cerate a new activity
-- =============================================
CREATE PROCEDURE [dbo].[usp_ACT_InsertActivity]
	@userName varchar(50),
	@organizationID int,
	@areaID int,
	@projectID int,
	@activityName nvarchar(250),
	@activityID int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
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
		-- ===============================================
		---  MAKE SURE THAT THIS NAME IS COPIED BELOW 
		---  AND IS UNIQUE IN THE SYSTEM!!!!!!
		-- ===============================================
		SAVE TRANSACTION InsertActivityPS;     
	ELSE
		-- This SP starts its own transaction and there was no previous transaction
		BEGIN TRANSACTION;

	BEGIN TRY
		
		IF(@areaID = 0)
			SELECT @areaID = null
		IF(@projectID = 0)
			SELECT @projectID = null

		INSERT INTO [dbo].[tbl_Activity]
			([name]
			,[organizationID]
			,[areaID]
			,[projectID])
		VALUES
           (@activityName
           ,@organizationID
           ,@areaID
           ,@projectID)

		SELECT @activityID = SCOPE_IDENTITY()

		-- Ensure that the owner can manage this object
		INSERT INTO [dbo].[tbl_SEG_ObjectPermissions]
           ([objectTypeID]
           ,[objectID]
           ,[username]
           ,[objectActionID])
		VALUES
           ('ACTIVITY'
           ,@activityID
           ,@userName
           ,'OWN')

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
				-- ===============================================
				---  MAKE SURE THAT THIS NAME IS EXACTLY AS ABOVE 
				-- ===============================================
				ROLLBACK TRANSACTION InsertActivityPS;

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

--=============================================================================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Cerate a new KPI
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_InsertKPI]
	@userName varchar(50),
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
	@curency char(3),
	@currencyUnit char(3),
	@kpiTypeID varchar(10),
	@kpiID int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
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
		-- ===============================================
		---  MAKE SURE THAT THIS NAME IS COPIED BELOW 
		---  AND IS UNIQUE IN THE SYSTEM!!!!!!
		-- ===============================================
		SAVE TRANSACTION InsertKPIPS;     
	ELSE
		-- This SP starts its own transaction and there was no previous transaction
		BEGIN TRANSACTION;

	BEGIN TRY
		
		IF(@areaID = 0)
			SELECT @areaID = null
		IF(@projecTID = 0)
			SELECT @projectID = null
		IF(@activityID = null)
			SELECT @activityID = null
		IF(@personID = null)
			SELECT @personID = null

		INSERT INTO [dbo].[tbl_KPI]
			([name]
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
			,[kpiTypeID])
		VALUES
			(@kpiName
			,@organizationID
			,@areaID
			,@projectID
			,@activityID
			,@personID
			,@unit
			,@direction
			,@strategy
			,@startDate
			,@reportingUnit
			,@targetPeriod
			,@allowsCategories
			,@curency
			,@currencyUnit
			,@kpiTypeID)

		SELECT @kpiID = SCOPE_IDENTITY()

		-- Ensure that the owner can manage this object
		INSERT INTO [dbo].[tbl_SEG_ObjectPermissions]
           ([objectTypeID]
           ,[objectID]
           ,[username]
           ,[objectActionID])
		VALUES
           ('KPI'
           ,@kpiID
           ,@userName
           ,'OWN')

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
				-- ===============================================
				---  MAKE SURE THAT THIS NAME IS EXACTLY AS ABOVE 
				-- ===============================================
				ROLLBACK TRANSACTION InsertKPIPS;

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

--=============================================================================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- =============================================
-- Author:		Ivan Krsul
-- Create date: April 22 2014
-- Description:	List all KPIs in the system
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetAllKPIs]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
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
END
GO

--=============================================================================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 22 2016
-- Description:	Resets the database, deleting all user data
-- =============================================
CREATE PROCEDURE usp_DELETE_DeleteAllUserData
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE FROM [dbo].[tbl_SEG_ObjectPermissions]
	DELETE FROM [dbo].[tbl_KPIMeasurementCategories]
	DELETE FROM [dbo].[tbl_KPIMeasurements]
	DELETE FROM [dbo].[tbl_KPITargetCategories]
	DELETE FROM [dbo].[tbl_KPITarget]
	DELETE FROM [dbo].[tbl_KPI]
	DELETE FROM [dbo].[tbl_CategoryItem]
	DELETE FROM [dbo].[tbl_Category]
	DELETE FROM [dbo].[tbl_People]
	DELETE FROM [dbo].[tbl_Activity]
	DELETE FROM [dbo].[tbl_Project]
	DELETE FROM [dbo].[tbl_Area]
	DELETE FROM [dbo].[tbl_Organization]

END
GO

--=============================================================================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 22 2016
-- Description:	Inserts a Category
-- =============================================
CREATE PROCEDURE usp_CATEGORY_InsertNewCategory
	@categoryName nvarchar(250),
	@categoryID varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO [dbo].[tbl_Category]
           ([categoryID]
           ,[name])
     VALUES
           (@categoryID
		   , @categoryName)
END
GO

--=============================================================================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 22 2016
-- Description:	Inserts a Category Item
-- =============================================
CREATE PROCEDURE usp_CATEGORY_InsertNewCategoryItem
	@categoryID varchar(20),
	@categoryItemID varchar(20),
	@categoryItemName nvarchar(250)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO [dbo].[tbl_CategoryItem]
           ([categoryItemID]
           ,[categoryID]
           ,[name])
     VALUES
           (@categoryItemID
           ,@categoryID
           ,@categoryItemName)

END
GO

--=============================================================================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 22 2016
-- Description:	Gets all category items
-- =============================================
CREATE PROCEDURE usp_CATEGORY_GetCategoryItems
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT ci.[categoryItemID]
		  ,ci.[categoryID]
		  ,c.[name] as categoryName
		  ,ci.[name] as categoriItemName
	  FROM [dbo].[tbl_CategoryItem] as ci
	  join [dbo].[tbl_Category] as c on ci.categoryID = c.categoryID

END
GO

--=============================================================================================================================

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SEG_InsertUserRecord]
	@varFullname AS VARCHAR(500),
	@varCellphone AS VARCHAR(50),
	@varAddress AS VARCHAR(250),
	@varPhone AS VARCHAR(50),
	@varPhoneArea AS INT,
	@varPhoneCode AS INT,
	@varUsername AS VARCHAR(50),
	@varEmail AS VARCHAR(100),
	@intUserId as int output
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @varFinalFullname AS VARCHAR(500)
	DECLARE @varFinalCellphone AS VARCHAR(50)
	DECLARE @varFinalAddress AS VARCHAR(250)
	DECLARE @varFinalPhoneNumber AS VARCHAR(50)
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
		SELECT @varFinalPhoneNumber = NULL 
	ELSE
		SELECT @varFinalPhoneNumber = @varPhone
		
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
		SAVE TRANSACTION InsertUserPS;
	ELSE
		-- Este SP comienza su propia transacción y no hay otra antes
		BEGIN TRANSACTION;
	BEGIN TRY
 	
	 INSERT INTO [dbo].[tbl_SEG_User]
           ([fullname]
           ,[cellphone]
           ,[address]
           ,[phonenumber]
           ,[phonearea]
           ,[phonecode]
           ,[username]
           ,[email])
     VALUES
           (@varFinalFullname
           ,@varFinalCellphone
           ,@varFinalAddress
           ,@varFinalPhoneNumber
           ,@varPhoneArea
           ,@varPhoneCode
           ,@varFinalUsername
           ,@varFinalEmail)

	SELECT @intUserId = SCOPE_IDENTITY()
	
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
				ROLLBACK TRANSACTION InsertUserPS;

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

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[tvf_SplitStringInIntTable]
(
	@varString VARCHAR(MAX),
    @varDelimiter VARCHAR(5)
)
RETURNS @tblSplittedValues TABLE
(
  splitvalue VARCHAR(8000)
)
AS
BEGIN
 DECLARE @intSplitLength INT

 WHILE LEN(@varString) > 0
  BEGIN
    SELECT @intSplitLength = 
     (CASE CHARINDEX(@varDelimiter,@varString) 
     WHEN 0 THEN
      LEN(@varString) 
     ELSE CHARINDEX(@varDelimiter,@varString) -1  
     END)

    INSERT INTO @tblSplittedValues
    SELECT CONVERT(int, SUBSTRING(@varString,1,@intSplitLength))

    SELECT @varString = 
     (CASE (LEN(@varString) - @intSplitLength) 
      WHEN 0 THEN ''
      ELSE 
       RIGHT(@varString, LEN(@varString) - @intSplitLength - 1) 
     END)
  END
 RETURN
END 
GO

--=============================================================================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[tvf_SplitStringInDecimalTable]
(
	@varString VARCHAR(MAX),
    @varDelimiter VARCHAR(5)
)
RETURNS @tblSplittedValues TABLE
(
  splitvalue VARCHAR(8000)
)
AS
BEGIN
 DECLARE @intSplitLength INT

 WHILE LEN(@varString) > 0
  BEGIN
    SELECT @intSplitLength = 
     (CASE CHARINDEX(@varDelimiter,@varString) 
     WHEN 0 THEN
      LEN(@varString) 
     ELSE CHARINDEX(@varDelimiter,@varString) -1  
     END)

    INSERT INTO @tblSplittedValues
    SELECT CONVERT(decimal(21,3), SUBSTRING(@varString,1,@intSplitLength))

    SELECT @varString = 
     (CASE (LEN(@varString) - @intSplitLength) 
      WHEN 0 THEN ''
      ELSE 
       RIGHT(@varString, LEN(@varString) - @intSplitLength - 1) 
     END)
  END
 RETURN
END 
GO

--=============================================================================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[tvf_SplitStringInVarCharTable]
(
	@varString VARCHAR(MAX),
    @varDelimiter VARCHAR(5)
)
RETURNS @tblSplittedValues TABLE
(
  splitvalue VARCHAR(8000)
)
AS
BEGIN
 DECLARE @intSplitLength INT

 WHILE LEN(@varString) > 0
  BEGIN
    SELECT @intSplitLength = 
     (CASE CHARINDEX(@varDelimiter,@varString) 
     WHEN 0 THEN
      LEN(@varString) 
     ELSE CHARINDEX(@varDelimiter,@varString) -1  
     END)

    INSERT INTO @tblSplittedValues
    SELECT CONVERT(varchar, SUBSTRING(@varString,1,@intSplitLength))

    SELECT @varString = 
     (CASE (LEN(@varString) - @intSplitLength) 
      WHEN 0 THEN ''
      ELSE 
       RIGHT(@varString, LEN(@varString) - @intSplitLength - 1) 
     END)
  END
 RETURN
END 
GO

--=============================================================================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Create a new KPI
-- =============================================
ALTER PROCEDURE [dbo].[usp_KPI_InsertKPI]
	@userName varchar(50),
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
	@kpiTypeID varchar(10),
	@kpiID int output
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

	if(@kpiTypeID <> 'GENDEC' and @kpiTypeID <> 'GENINT' 
		and @kpiTypeID <> 'GENMON' and @kpiTypeID <> 'GENPER') 
	begin
		-- The KPI is a not generic, so we must fetch from the KPI type table
		-- the values for direction, strategy and unit
			
		select @direction = [directionID],
			@strategy = [strategyID],
			@unit = [unitID]
		from [dbo].[tbl_KPITypes]
		where [kpiTypeID] = @kpiTypeID
	end

	IF(@areaID = 0)
		SELECT @areaID = null
	IF(@projecTID = 0)
		SELECT @projectID = null
	IF(@activityID = null)
		SELECT @activityID = null
	IF(@personID = null)
		SELECT @personID = null

	INSERT INTO [dbo].[tbl_KPI]
		([name]
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
		,[kpiTypeID])
	VALUES
		(@kpiName
		,@organizationID
		,@areaID
		,@projectID
		,@activityID
		,@personID
		,@unit
		,@direction
		,@strategy
		,@startDate
		,@reportingUnit
		,@targetPeriod
		,@allowsCategories
		,@currency
		,@currencyUnit
		,@kpiTypeID)

	SELECT @kpiID = SCOPE_IDENTITY()

	-- Ensure that the owner can manage this object
	INSERT INTO [dbo].[tbl_SEG_ObjectPermissions]
		([objectTypeID]
		,[objectID]
		,[username]
		,[objectActionID])
	VALUES
		('KPI'
		,@kpiID
		,@userName
		,'OWN')
END
GO

--=============================================================================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Adda  Category for a KPI
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_AddKPICategory]
	@kpiID int,
	@categoryID varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO [dbo].[tbl_KPICategories]
           ([kpiID]
           ,[categoryID])
     VALUES
           (@kpiID
           ,@categoryID)

END
GO

--=============================================================================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Add a Target for a KPI that does not have Categories
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_AddKPITargetNoCategories]
	@kpiID int,
	@target decimal(21,3),
	@targetID int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO [dbo].[tbl_KPITarget]
           ([kpiID]
           ,[target])
     VALUES
           (@kpiID
           ,@target)

	SELECT @targetID = SCOPE_IDENTITY()

END
GO

--=============================================================================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Add a Target for a KPI for a specific item in a category
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_AddKPITargetInCategoryItem]
	@kpiID int,
	@target decimal(21,3),
	@categoryItemID varchar(20),
	@categoryID varchar(20),
	@targetID int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO [dbo].[tbl_KPITarget]
           ([kpiID]
           ,[target])
     VALUES
           (@kpiID
           ,@target)

	SELECT @targetID = SCOPE_IDENTITY()

	INSERT INTO [dbo].[tbl_KPITargetCategories]
           ([targetID]
           ,[categoryItemID]
           ,[categoryID])
     VALUES
           (@targetID
           ,@categoryItemID
           ,@categoryID)
END
GO

--=============================================================================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 26 2015
-- Description:	Get a list of all KPY Types in the system
-- =============================================
CREATE PROCEDURE usp_KPITYPE_GetAllKPITypes 
	@language CHAR(3)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select t.[kpiTypeID], t.[directionID], dl.[name] directionName, 
		t.[strategyID], sl.name strategyName, t.unitID, ul.name unitName
		from [dbo].[tbl_KPITypes] t
		join [dbo].[tbl_KPITypesLabels] tl on t.kpiTypeID = tl.kpiTypeID
		join [dbo].[tbl_DirectionLabels] dl on t.directionID = dl.directionID
		join [dbo].[tbl_StrategyLabels] sl on t.[strategyID] = sl.strategyID
		join [dbo].[tbl_UnitLabels] ul on t.[unitID] = ul.[unitID]
		where tl.language = @language and dl.language = @language 
			and sl.language = @language and ul.language = @language
END
GO

--=============================================================================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 26 2016>
-- Description:	Ge a list of curencies we can use
-- =============================================
CREATE PROCEDURE usp_CURRENCY_GetAllCurrencies
	@language char(3)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select c.[currencyID], cl.[name]
		from [dbo].[tbl_Currency] as c
		join [dbo].[tbl_CurrencyLabels] as cl on cl.[currencyID] = c.[currencyID]
		where cl.language = @language
END
GO

--=============================================================================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 26 2016>
-- Description:	Get a list of currency units that can be used for all currencies
-- =============================================
CREATE PROCEDURE usp_CURRENCY_GetCurrencyUnitsAcceptableForAllCurrencies
	@language char(3)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select u.[currencyID], u.[currencyUnitID], ul.name
		from [dbo].[tbl_UnitsAllowedForCurrency] as u
		join [dbo].[tbl_CurrencyUnitsLabels] as ul on u.[currencyUnitID] = ul.[currencyUnitID]
		where ul.language = @language
END
GO

--=============================================================================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Create a new KPI
-- =============================================
ALTER PROCEDURE [dbo].[usp_KPI_InsertKPI]
	@userName varchar(50),
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
	@kpiTypeID varchar(10),
	@kpiID int output
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

	if(@kpiTypeID <> 'GENDEC' and @kpiTypeID <> 'GENINT' 
		and @kpiTypeID <> 'GENMON' and @kpiTypeID <> 'GENPER') 
	begin
		-- The KPI is a not generic, so we must fetch from the KPI type table
		-- the values for direction, strategy and unit
			
		select @direction = [directionID],
			@strategy = [strategyID],
			@unit = [unitID]
		from [dbo].[tbl_KPITypes]
		where [kpiTypeID] = @kpiTypeID
	end

	IF(@areaID = 0)
		SELECT @areaID = null
	IF(@projecTID = 0)
		SELECT @projectID = null
	IF(@activityID = 0)
		SELECT @activityID = null
	IF(@personID = 0)
		SELECT @personID = null

	INSERT INTO [dbo].[tbl_KPI]
		([name]
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
		,[kpiTypeID])
	VALUES
		(@kpiName
		,@organizationID
		,@areaID
		,@projectID
		,@activityID
		,@personID
		,@unit
		,@direction
		,@strategy
		,@startDate
		,@reportingUnit
		,@targetPeriod
		,@allowsCategories
		,@currency
		,@currencyUnit
		,@kpiTypeID)

	SELECT @kpiID = SCOPE_IDENTITY()

	-- Ensure that the owner can manage this object
	INSERT INTO [dbo].[tbl_SEG_ObjectPermissions]
		([objectTypeID]
		,[objectID]
		,[username]
		,[objectActionID])
	VALUES
		('KPI'
		,@kpiID
		,@userName
		,'OWN')
END
GO

--=============================================================================================================================

INSERT INTO [dbo].[tbl_KPITypes]
           ([kpiTypeID]
           ,[directionID]
           ,[strategyID]
           ,[unitID])
     VALUES
           ('GENTIME'
           ,'NA'
           ,'NA'
           ,'NA')
GO

--=============================================================================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 22 2016
-- Description:	Resets the database, deleting all user data
-- =============================================
ALTER PROCEDURE [dbo].[usp_DELETE_DeleteAllUserData]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE FROM [dbo].[tbl_SEG_ObjectPermissions]
	DELETE FROM [dbo].[tbl_KPIMeasurementCategories]
	DELETE FROM [dbo].[tbl_KPIMeasurements]
	DELETE FROM [dbo].[tbl_KPITargetCategories]
	DELETE FROM [dbo].[tbl_KPITarget]
	DELETE FROM [dbo].[tbl_KPICategories]
	DELETE FROM [dbo].[tbl_KPI]
	DELETE FROM [dbo].[tbl_People]
	DELETE FROM [dbo].[tbl_Activity]
	DELETE FROM [dbo].[tbl_Project]
	DELETE FROM [dbo].[tbl_Area]
	DELETE FROM [dbo].[tbl_Organization]
	DELETE FROM [dbo].[tbl_CategoryItem]
	DELETE FROM [dbo].[tbl_Category]

END
GO

--=============================================================================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 26 2016
-- Description:	Insert Measurement for a KPI
-- =============================================
CREATE PROCEDURE usp_KPI_InsertMeasurement
	@kpiID int,
	@date date,
	@measurement decimal(21,3),
	@categoryID varchar(20),
	@categoryItemID varchar(20),
	@measurementID int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- ===============================================================================================
	-- ===============================================================================================
	-- This is very important! This stored procedure does not implement a transaction, even though
	-- it does multiple things.  We do this because it is assumed that the ASP.NET program that is 
	-- calling this procedure is handling the transaction, since this procedure is likely to be called
	-- many times during the insert process of KPI data.
	-- ===============================================================================================
	-- ===============================================================================================

	INSERT INTO [dbo].[tbl_KPIMeasurements]
           ([kpiID]
           ,[date]
           ,[measurement])
     VALUES
           (@kpiID
           ,@date
           ,@measurement)
	
	SELECT @measurementID = SCOPE_IDENTITY()

	if(@categoryID is not null and @categoryID <> '' 
		and @categoryItemID is not null and @categoryItemID <> '') 
	begin
		INSERT INTO [dbo].[tbl_KPIMeasurementCategories]
           ([measurementID]
           ,[categoryItemID]
           ,[categoryID])
		VALUES
           (@measurementID
           ,@categoryItemID
           ,@categoryID)
	end
END
GO

--=============================================================================================================================

UPDATE [dbo].[tbl_DatabaseInfo]
   SET [majorversion] = 1
      ,[minorversion] = 2
      ,[releaseversion] = 0
GO
GO
