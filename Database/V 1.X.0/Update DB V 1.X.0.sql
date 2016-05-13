/* 
	Updates de the KPIDB database to version 1.5.0 
*/

Use [Master]
GO 

IF  NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'KPIDB')
	RAISERROR('KPIDB database Doesn´t exists. Create the database first',16,127)
GO

PRINT 'Updating KPIDB database to version 1.5.0'

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

IF NOT (@smiMajor = 1 AND @smiMinor = 4) 
BEGIN
	RAISERROR('KPIDB database is not in version 1.4 This program only applies to version 1.3',16,127)
	RETURN;
END

PRINT 'KPIDB Database version OK'
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

	DELETE FROM [dbo].[tbl_SEG_ObjectPublic]
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
-- =============================================================
-- Author:		Get KPI List Visible for User
-- Create date: May 12 2016
-- Description:	Get List of KPIs that user has view rights to
-- =============================================================
ALTER PROCEDURE [dbo].[usp_KPI_GetKPIListForUser]
	-- Add the parameters for the stored procedure here
	@userName varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--- Get list of KPIS where user has acccess.  In the sourceObjectType
	-- column we will record where we got this from, and the objectID will
	-- tell us the ID of the object where this KPI came from.
	DECLARE @kpiList as TABLE(kpiID int, sourceObjectType varchar(100), objectID int)

	-- For the following description ORG = ORGANIZATION, ACT = ACTIVITY, PPL = PEOPLE, PROF = PROJECT. 
	--If we need to determine the list of KPIs that a specific user can see 
	--we need to follow the following steps:
	--
	--1. Search for all ORGs where the user has OWN permissions and add to the list 
	--   of KPIs all of those KPIs associated to those ORGs.
	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of KPIs all of these that are directly associated 
	--   to the organization and ARE NOT associated to a PROJ, ACT or PPL.  
	--3. Search for all ORGs where the user has MAN_PROJECT permissions or ORG has public 
	--   MAN_PROJECT, then search for all PROJs associated to these ORGs and then add to 
	--   the KPI list all of the KPIs that are associated to these PROJs.
	--4. For the list of projects obtained above, search for all the ACT that are associated
	--   to these PROJ and then add to the KPI list all of the KPIs that are associated to 
	--   these ACT.
	--5. Search for all ORGs where the user has MAN_ACTITIVIES permissions or ORG has public 
	--   MAN_ACTITIVIES and search for ACT that are associated to these ORGs and ARE NOT 
	--   associated to any PROJ, then add to the KPI list all of the KPIs that are 
	--   associated to these ACT.
	--6. Search for all ORGs where the user has MAN_PEOPLE permissions or where the ORG has 
	--   public MAN_PEOPLE, then search for all of the PPL that are associated to those 
	--   ORGs and finally add to the KPI list all of the KPIs that are associated to those 
	--   PPL.
	--7. Search for all ACT where the user has OWN or MAN_KPI permissions or the ACT is public 
	--   MAN_KPI and add to the KPI list all of the KPIs that are associated to the ACT.
	--8. Search for all PROJ where the user has OWN or MAN_KPI permissions, or where the ORG 
	--   is public MAN_KPI and add to the KPI list all of the PKIs that are associated to those
	--   PROJ.
	--9. Search for all PROJ where the user has MAN_ACTIVITIES permissions or where the PROJ is 
	--   public MAN_ACTIVITIES, then search for all of the ACT that are associated to these 
	--   PROJs and finally add to the KPI list the KPIs that are associated to these ACT.
	--10. Search for all PPL where the user user has MAN_KPI permissions or where the PPL is 
	--    public MAN_KPI and add to the KPI list all of the KIPs that are associated to these PPL.
	--11.	Add to the KPI list all of the KPIs that are public VIEW
	--12.	Add to the KPI list all of the KPIs where the user has OWN or VIEW or ENTER_DATA
	--      permissions.
	--
	--At the end of this, we should have a list of all of the KPIs that the user can see.

	-- So lets start with step 1.
 
	--1. Search for all ORGs where the user has OWN permissions and add to the list 
	--   of KPIs all of those KPIs associated to those ORGs.

	insert into @kpiList
	select [kpiID], 'ORG OWN (1)', [organizationID] 
	from [dbo].[tbl_KPI]
	where [organizationID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'ORGANIZATION' and objectActionID = 'OWN'
			and username = @userName
	)

	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of KPIs all of these that are directly associated 
	--   to the organization and ARE NOT associated to a PROJ, ACT or PPL.  

	insert into @kpiList
	select [kpiID], 'ORG MAN_KPI (2)', [organizationID] 
	from [dbo].[tbl_KPI]
	where [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI'
	) and [projectID] is null and [activityID] is null and [personID] is null

	--3. Search for all ORGs where the user has MAN_PROJECT permissions or ORG has public 
	--   MAN_PROJECT, then search for all PROJs associated to these ORGs and then add to 
	--   the KPI list all of the KPIs that are associated to these PROJs.

	insert into @kpiList
	select [kpiID], 'ORG MAN_PROJECT (3)', [organizationID] 
	from [dbo].[tbl_KPI]
	where [projectID] in (
		select [projectID]
		from [dbo].[tbl_Project] 
		where [organizationID] in (
			SELECT [objectID] 
			FROM [dbo].[tbl_SEG_ObjectPermissions]
			WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PROJECT' AND username = @userName
			UNION
			SELECT [objectID]
			FROM [dbo].[tbl_SEG_ObjectPublic]
			WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PROJECT'
		) 
	)

	--4. For the list of projects obtained above, search for all the ACT that are associated
	--   to these PROJ and then add to the KPI list all of the KPIs that are associated to 
	--   these ACT.

	insert into @kpiList
	select [kpiID], 'ORG MAN_PROJECT_ACT (4)', [organizationID] 
	from [dbo].[tbl_KPI]
	where [activityID] in (
		select [activityID] 
		from [dbo].[tbl_Activity]
		where [projectID] in (
			select [projectID]
			from [dbo].[tbl_Project] 
			where [organizationID] in (
				SELECT [objectID] 
				FROM [dbo].[tbl_SEG_ObjectPermissions]
				WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PROJECT' AND username = @userName
				UNION
				SELECT [objectID]
				FROM [dbo].[tbl_SEG_ObjectPublic]
				WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PROJECT'
			) 
		)
	)

	--5. Search for all ORGs where the user has MAN_ACTITIVIES permissions or ORG has public 
	--   MAN_ACTITIVIES and search for ACT that are associated to these ORGs and ARE NOT 
	--   associated to any PROJ, then add to the KPI list all of the KPIs that are 
	--   associated to these ACT.
	
	insert into @kpiList
	select [kpiID], 'ORG MAN_ACTIVITY (5)', [organizationID] 
	from [dbo].[tbl_KPI]
	where [activityID] in (
		select [activityID] 
		from [dbo].[tbl_Activity]
		where [organizationID] in (
			SELECT [objectID] 
			FROM [dbo].[tbl_SEG_ObjectPermissions]
			WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_ACTIVITY' AND username = @userName
			UNION
			SELECT [objectID]
			FROM [dbo].[tbl_SEG_ObjectPublic]
			WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_ACTIVITY'
		)  and [projectID] is null
	)

	--6. Search for all ORGs where the user has MAN_PEOPLE permissions or where the ORG has 
	--   public MAN_PEOPLE, then search for all of the PPL that are associated to those 
	--   ORGs and finally add to the KPI list all of the KPIs that are associated to those 
	--   PPL.

	insert into @kpiList
	select [kpiID], 'ORG MAN_PEOPLE (6)', [organizationID] 
	from [dbo].[tbl_KPI]
	where [personID] in (
		select [personID]
		from [dbo].[tbl_People] 
		where [organizationID] in (
			SELECT [objectID] 
			FROM [dbo].[tbl_SEG_ObjectPermissions]
			WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PEOPLE' AND username = @userName
			UNION
			SELECT [objectID]
			FROM [dbo].[tbl_SEG_ObjectPublic]
			WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PEOPLE'
		) 
	)

	--7. Search for all ACT where the user has OWN or MAN_KPI permissions or the ACT is public 
	--   MAN_KPI and add to the KPI list all of the KPIs that are associated to the ACT.

	insert into @kpiList
	select [kpiID], 'ACT OWN (7)', [activityID]
	from [dbo].[tbl_KPI]
	where[activityID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'ACTIVITY' and objectActionID = 'OWN' and username = @userName
	)

	insert into @kpiList
	select [kpiID], 'ACT-MAN_KPI (7)', [activityID] 
	FROM [dbo].[tbl_KPI]
	where[activityID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ACTIVITY' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ACTIVITY' and objectActionID = 'MAN_KPI'
	)

	--8. Search for all PROJ where the user has OWN or MAN_KPI permissions, or where the ORG 
	--   is public MAN_KPI and add to the KPI list all of the PKIs that are associated to those
	--   PROJ.

	insert into @kpiList
	select [kpiID], 'PROJ OWN (8)', [projectID] 
	from [dbo].[tbl_KPI]
	where [projectID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'PROJECT' and objectActionID = 'OWN' and username = @userName
	)

	insert into @kpiList
	select [kpiID], 'PROJ-MAN_KPI (8)', [projectID] 
	FROM [dbo].[tbl_KPI]
	where [projectID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_KPI'
	)

	--9. Search for all PROJ where the user has MAN_ACTIVITIES permissions or where the PROJ is 
	--   public MAN_ACTIVITIES, then search for all of the ACT that are associated to these 
	--   PROJs and finally add to the KPI list the KPIs that are associated to these ACT.

	insert into @kpiList
	select [kpiID], 'PROJ-MAN_ACTIVITY (9)', [projectID] 
	FROM [dbo].[tbl_KPI]
	where [activityID] in (
		select [activityID]
		from [dbo].[tbl_Activity]
		where [projectID] in (
			SELECT [objectID] 
			FROM [dbo].[tbl_SEG_ObjectPermissions]
			WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_ACTIVITY' AND username = @userName
			UNION
			SELECT [objectID]
			FROM [dbo].[tbl_SEG_ObjectPublic]
			WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_ACTIVITY'
		)
	)

	--10. Search for all PPL where the user has OWN or MAN_KPI permissions or where the PPL is 
	--    public MAN_KPI and add to the KPI list all of the KIPs that are associated to these PPL.

	insert into @kpiList
	select [kpiID], 'PPL OWN (10)', [personID]
	from [dbo].[tbl_KPI]
	where [personID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'PERSON' and objectActionID = 'OWN' and username = @userName
	)

	insert into @kpiList
	select [kpiID], 'PPL-MAN_KPI (10)', [personID] 
	FROM [dbo].[tbl_KPI]
	where [personID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PERSON' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'PERSON' and objectActionID = 'MAN_KPI'
	)

	--11. Add to the KPI list all of the KPIs that are public VIEW_KPI

	insert into @kpiList
	select [kpiID], 'KPI-PUB VIEW (11)', [kpiID] 
	FROM [dbo].[tbl_KPI]
	where [kpiID] in (
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI'
	)

	--12.	Add to the KPI list all of the KPIs where the user has OWN or VIEW_KPI or ENTER_DATA
	--      permissions.
	insert into @kpiList
	select [kpiID], 'KPI-VIEW-OWN-ENTER (12)', [kpiID] 
	FROM [dbo].[tbl_KPI]
	where [kpiID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'OWN' AND username = @userName
		union
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'ENTER_DATA' AND username = @userName
		union
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI' AND username = @userName
	)

	select distinct kpiID from @kpiList 


END
GO

--=============================================================================================================================

/*
 * We are done, mark the database as a 1.5.0 database.
 */

DELETE FROM [dbo].[tbl_DatabaseInfo] 
INSERT INTO [dbo].[tbl_DatabaseInfo] 
	([majorversion], [minorversion], [releaseversion])
	VALUES (1,5,0)
GO