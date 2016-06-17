USE [KPIDB]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PEOPLE_GetPersonByArea]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PEOPLE_GetPersonByArea]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Marcela Martinez
-- Create date: 30/04/2016
-- Description:	Get persona by Area
-- =============================================
CREATE PROCEDURE [dbo].[usp_PEOPLE_GetPersonByArea]
	@intAreaId AS INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [personID]
		  ,[id]
		  ,[name]
		  ,[organizationID]
		  ,[areaID]
	FROM [dbo].[tbl_People] 
	WHERE [areaID] = @intAreaId
    
END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PEOPLE_UpdatePerson]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PEOPLE_UpdatePerson]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: June 7, 2016
-- Description:	Update a new person
-- =============================================
CREATE PROCEDURE [dbo].[usp_PEOPLE_UpdatePerson]
	@personID int,
	@id nvarchar(50),
	@personName nvarchar(250),
	@organizationID int,
	@areaID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF(@areaID = 0)
		SELECT @areaID = null

	UPDATE [dbo].[tbl_People]
	   SET [id] = @id
		  ,[name] = @personName
		  ,[organizationID] = @organizationID
		  ,[areaID] = @areaID
	 WHERE [personId] = @personID

END
GO




IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PEOPLE_DeletePerson]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PEOPLE_DeletePerson]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: June 7, 2016
-- Description:	Delete a person
-- =============================================
CREATE PROCEDURE [dbo].[usp_PEOPLE_DeletePerson]
	@personID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE FROM [dbo].[tbl_People]
      WHERE [personID] = @personID


END

GO

