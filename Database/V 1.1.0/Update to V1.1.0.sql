USE KPIDB
GO

--=============================================================================================================================

BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbl_Activity SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tbl_Activity', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tbl_Activity', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tbl_Activity', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbl_KPI
	DROP CONSTRAINT FK_tbl_KPI_tbl_Area
GO
ALTER TABLE dbo.tbl_Currency SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tbl_Currency', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tbl_Currency', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tbl_Currency', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbl_Area SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tbl_Area', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tbl_Area', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tbl_Area', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbl_KPI ADD CONSTRAINT
	FK_tbl_KPI_tbl_Area FOREIGN KEY
	(
	areaID
	) REFERENCES dbo.tbl_Area
	(
	areaID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbl_KPI ADD CONSTRAINT
	FK_tbl_KPI_tbl_Activity FOREIGN KEY
	(
	activityID
	) REFERENCES dbo.tbl_Activity
	(
	activityID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbl_KPI SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tbl_KPI', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tbl_KPI', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tbl_KPI', 'Object', 'CONTROL') as Contr_Per 
GO

--=============================================================================================================================

BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbl_KPITypes SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tbl_KPITypes', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tbl_KPITypes', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tbl_KPITypes', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbl_KPI
	DROP CONSTRAINT FK_tbl_KPI_tbl_Activity
GO
ALTER TABLE dbo.tbl_Activity SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tbl_Activity', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tbl_Activity', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tbl_Activity', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbl_KPI
	DROP CONSTRAINT FK_tbl_KPI_tbl_Currency
GO
ALTER TABLE dbo.tbl_Currency SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tbl_Currency', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tbl_Currency', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tbl_Currency', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbl_KPI
	DROP CONSTRAINT FK_tbl_KPI_tbl_Project
GO
ALTER TABLE dbo.tbl_Project SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tbl_Project', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tbl_Project', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tbl_Project', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbl_KPI
	DROP CONSTRAINT FK_tbl_KPI_tbl_Area
GO
ALTER TABLE dbo.tbl_Area SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tbl_Area', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tbl_Area', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tbl_Area', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbl_KPI
	DROP CONSTRAINT FK_tbl_KPI_tbl_Organization
GO
ALTER TABLE dbo.tbl_Organization SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tbl_Organization', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tbl_Organization', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tbl_Organization', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbl_KPI
	DROP CONSTRAINT FK_tbl_KPI_tbl_ReportingUnit
GO
ALTER TABLE dbo.tbl_ReportingUnit SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tbl_ReportingUnit', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tbl_ReportingUnit', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tbl_ReportingUnit', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbl_KPI
	DROP CONSTRAINT FK_tbl_KPI_tbl_Strategy
GO
ALTER TABLE dbo.tbl_Strategy SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tbl_Strategy', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tbl_Strategy', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tbl_Strategy', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbl_KPI
	DROP CONSTRAINT FK_tbl_KPI_tbl_Direction
GO
ALTER TABLE dbo.tbl_Direction SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tbl_Direction', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tbl_Direction', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tbl_Direction', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbl_KPI
	DROP CONSTRAINT FK_tbl_KPI_tbl_Unit
GO
ALTER TABLE dbo.tbl_Unit SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tbl_Unit', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tbl_Unit', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tbl_Unit', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbl_KPI
	DROP CONSTRAINT FK_tbl_KPI_tbl_People
GO
ALTER TABLE dbo.tbl_People SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tbl_People', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tbl_People', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tbl_People', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbl_KPI
	DROP CONSTRAINT FK_tbl_KPI_tbl_CurrencyUnits
GO
ALTER TABLE dbo.tbl_CurrencyUnits SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tbl_CurrencyUnits', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tbl_CurrencyUnits', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tbl_CurrencyUnits', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tbl_KPI
	(
	kpiID int NOT NULL IDENTITY (1, 1),
	name nvarchar(250) NOT NULL,
	organizationID int NULL,
	areaID int NULL,
	projectID int NULL,
	activityID int NULL,
	personID int NULL,
	unitID varchar(10) NOT NULL,
	directionID char(3) NOT NULL,
	strategyID char(3) NOT NULL,
	startDate date NULL,
	reportingUnitID char(5) NOT NULL,
	targetPeriod int NULL,
	allowsCategories bit NOT NULL,
	currency char(3) NULL,
	currencyUnitID char(3) NULL,
	kpiTypeID varchar(10) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tbl_KPI SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tbl_KPI ON
GO
IF EXISTS(SELECT * FROM dbo.tbl_KPI)
	 EXEC('INSERT INTO dbo.Tmp_tbl_KPI (kpiID, name, organizationID, areaID, projectID, activityID, personID, unitID, directionID, strategyID, startDate, reportingUnitID, targetPeriod, allowsCategories, currency, currencyUnitID)
		SELECT kpiID, name, organizationID, areaID, projectID, activityID, personID, unitID, directionID, strategyID, startDate, reportingUnitID, targetPeriod, allowsCategories, currency, currencyUnitID FROM dbo.tbl_KPI WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tbl_KPI OFF
GO
ALTER TABLE dbo.tbl_KPITarget
	DROP CONSTRAINT FK_tbl_KPITargets_tbl_KPI
GO
ALTER TABLE dbo.tbl_KPIMeasurements
	DROP CONSTRAINT FK_tbl_KPIMeasurements_tbl_KPI
GO
DROP TABLE dbo.tbl_KPI
GO
EXECUTE sp_rename N'dbo.Tmp_tbl_KPI', N'tbl_KPI', 'OBJECT' 
GO
ALTER TABLE dbo.tbl_KPI ADD CONSTRAINT
	PK_tbl_KPI PRIMARY KEY CLUSTERED 
	(
	kpiID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tbl_KPI ADD CONSTRAINT
	FK_tbl_KPI_tbl_CurrencyUnits FOREIGN KEY
	(
	currencyUnitID
	) REFERENCES dbo.tbl_CurrencyUnits
	(
	currencyUnitID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbl_KPI ADD CONSTRAINT
	FK_tbl_KPI_tbl_People FOREIGN KEY
	(
	personID
	) REFERENCES dbo.tbl_People
	(
	personID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbl_KPI ADD CONSTRAINT
	FK_tbl_KPI_tbl_Unit FOREIGN KEY
	(
	unitID
	) REFERENCES dbo.tbl_Unit
	(
	unitID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbl_KPI ADD CONSTRAINT
	FK_tbl_KPI_tbl_Direction FOREIGN KEY
	(
	directionID
	) REFERENCES dbo.tbl_Direction
	(
	directionID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbl_KPI ADD CONSTRAINT
	FK_tbl_KPI_tbl_Strategy FOREIGN KEY
	(
	strategyID
	) REFERENCES dbo.tbl_Strategy
	(
	strategyID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbl_KPI ADD CONSTRAINT
	FK_tbl_KPI_tbl_ReportingUnit FOREIGN KEY
	(
	reportingUnitID
	) REFERENCES dbo.tbl_ReportingUnit
	(
	reportingUnitID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbl_KPI ADD CONSTRAINT
	FK_tbl_KPI_tbl_Organization FOREIGN KEY
	(
	organizationID
	) REFERENCES dbo.tbl_Organization
	(
	organizationID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbl_KPI ADD CONSTRAINT
	FK_tbl_KPI_tbl_Area FOREIGN KEY
	(
	areaID
	) REFERENCES dbo.tbl_Area
	(
	areaID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbl_KPI ADD CONSTRAINT
	FK_tbl_KPI_tbl_Project FOREIGN KEY
	(
	projectID
	) REFERENCES dbo.tbl_Project
	(
	projectID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbl_KPI ADD CONSTRAINT
	FK_tbl_KPI_tbl_Currency FOREIGN KEY
	(
	currency
	) REFERENCES dbo.tbl_Currency
	(
	currencyID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbl_KPI ADD CONSTRAINT
	FK_tbl_KPI_tbl_Activity FOREIGN KEY
	(
	activityID
	) REFERENCES dbo.tbl_Activity
	(
	activityID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbl_KPI ADD CONSTRAINT
	FK_tbl_KPI_tbl_KPITypes FOREIGN KEY
	(
	kpiTypeID
	) REFERENCES dbo.tbl_KPITypes
	(
	kpiTypeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tbl_KPI', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tbl_KPI', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tbl_KPI', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbl_KPIMeasurements ADD CONSTRAINT
	FK_tbl_KPIMeasurements_tbl_KPI FOREIGN KEY
	(
	kpiID
	) REFERENCES dbo.tbl_KPI
	(
	kpiID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbl_KPIMeasurements SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tbl_KPIMeasurements', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tbl_KPIMeasurements', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tbl_KPIMeasurements', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbl_KPITarget ADD CONSTRAINT
	FK_tbl_KPITargets_tbl_KPI FOREIGN KEY
	(
	kpiID
	) REFERENCES dbo.tbl_KPI
	(
	kpiID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbl_KPITarget SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tbl_KPITarget', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tbl_KPITarget', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tbl_KPITarget', 'Object', 'CONTROL') as Contr_Per 
GO

--=============================================================================================================================

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbl_DirectionLabels
	DROP CONSTRAINT FK_tbl_DirectionLabels_tbl_Language
GO
ALTER TABLE dbo.tbl_Language SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tbl_Language', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tbl_Language', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tbl_Language', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbl_DirectionLabels
	DROP CONSTRAINT FK_tbl_DirectionLabels_tbl_Direction
GO
ALTER TABLE dbo.tbl_Direction SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tbl_Direction', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tbl_Direction', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tbl_Direction', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tbl_DirectionLabels
	(
	directionID char(3) NOT NULL,
	language char(2) NOT NULL,
	name nvarchar(250) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tbl_DirectionLabels SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.tbl_DirectionLabels)
	 EXEC('INSERT INTO dbo.Tmp_tbl_DirectionLabels (directionID, language, name)
		SELECT directionID, language, CONVERT(nvarchar(250), name) FROM dbo.tbl_DirectionLabels WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.tbl_DirectionLabels
GO
EXECUTE sp_rename N'dbo.Tmp_tbl_DirectionLabels', N'tbl_DirectionLabels', 'OBJECT' 
GO
ALTER TABLE dbo.tbl_DirectionLabels ADD CONSTRAINT
	PK_tbl_DirectionLabels PRIMARY KEY CLUSTERED 
	(
	directionID,
	language
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tbl_DirectionLabels ADD CONSTRAINT
	FK_tbl_DirectionLabels_tbl_Direction FOREIGN KEY
	(
	directionID
	) REFERENCES dbo.tbl_Direction
	(
	directionID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbl_DirectionLabels ADD CONSTRAINT
	FK_tbl_DirectionLabels_tbl_Language FOREIGN KEY
	(
	language
	) REFERENCES dbo.tbl_Language
	(
	languageID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tbl_DirectionLabels', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tbl_DirectionLabels', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tbl_DirectionLabels', 'Object', 'CONTROL') as Contr_Per 
GO

--=============================================================================================================================

INSERT INTO [dbo].[tbl_Unit]([unitID]) VALUES ('NA')
INSERT INTO [dbo].[tbl_UnitLabels]([unitID],[language],[name])
     VALUES ('NA', 'EN', 'Does not apply')
INSERT INTO [dbo].[tbl_UnitLabels]([unitID],[language],[name])
     VALUES ('NA', 'ES', 'No aplica')

INSERT INTO [dbo].[tbl_Direction] ([directionID]) VALUES ('NA')
INSERT INTO [dbo].[tbl_DirectionLabels] ([directionID],[language],[name])
     VALUES ('NA', 'EN', 'Does not apply')
INSERT INTO [dbo].[tbl_DirectionLabels] ([directionID],[language],[name])
     VALUES ('NA', 'ES', 'No aplica')

INSERT INTO [dbo].[tbl_Strategy] ([strategyID])
     VALUES ('NA')
INSERT INTO [dbo].[tbl_StrategyLabels] ([strategyID],[language],[name])
     VALUES ('NA', 'EN', 'Does not apply')
INSERT INTO [dbo].[tbl_StrategyLabels] ([strategyID],[language],[name])
     VALUES ('NA', 'ES', 'No aplica')

INSERT INTO [dbo].[tbl_KPITypes]([kpiTypeID],[directionID],[strategyID],[unitID])
     VALUES ('GENINT', 'NA', 'NA', 'NA') 
INSERT INTO [dbo].[tbl_KPITypesLabels]([kpiTypeID],[language],[typeName],[description])
     VALUES ('GENINT', 'EN', 'Generic integer', 'NA')
INSERT INTO [dbo].[tbl_KPITypesLabels]([kpiTypeID],[language],[typeName],[description])
     VALUES ('GENINT', 'ES', 'Entero genérico', 'NA')

INSERT INTO [dbo].[tbl_KPITypes]([kpiTypeID],[directionID],[strategyID],[unitID])
     VALUES ('GENDEC', 'NA', 'NA', 'NA') 
INSERT INTO [dbo].[tbl_KPITypesLabels]([kpiTypeID],[language],[typeName],[description])
     VALUES ('GENDEC', 'EN', 'Generic decimal', 'NA')
INSERT INTO [dbo].[tbl_KPITypesLabels]([kpiTypeID],[language],[typeName],[description])
     VALUES ('GENDEC', 'ES', 'Decimal genérico', 'NA')

INSERT INTO [dbo].[tbl_KPITypes]([kpiTypeID],[directionID],[strategyID],[unitID])
     VALUES ('GENPER', 'NA', 'NA', 'NA') 
INSERT INTO [dbo].[tbl_KPITypesLabels]([kpiTypeID],[language],[typeName],[description])
     VALUES ('GENPER', 'EN', 'Generic percentage', 'NA')
INSERT INTO [dbo].[tbl_KPITypesLabels]([kpiTypeID],[language],[typeName],[description])
     VALUES ('GENPER', 'ES', 'Porcentaje genérico', 'NA')

INSERT INTO [dbo].[tbl_KPITypes]([kpiTypeID],[directionID],[strategyID],[unitID])
     VALUES ('GENMON', 'NA', 'NA', 'NA') 
INSERT INTO [dbo].[tbl_KPITypesLabels]([kpiTypeID],[language],[typeName],[description])
     VALUES ('GENMON', 'EN', 'Generic money', 'NA')
INSERT INTO [dbo].[tbl_KPITypesLabels]([kpiTypeID],[language],[typeName],[description])
     VALUES ('GENMON', 'ES', 'Dinero genérico', 'NA')
GO

--=============================================================================================================================

INSERT INTO [dbo].[tbl_StrategyLabels] ([strategyID],[language],[name])
     VALUES ('AVG', 'ES', 'Promedio')
INSERT INTO [dbo].[tbl_StrategyLabels] ([strategyID],[language],[name])
     VALUES ('SUM', 'ES', 'Suma')

--=============================================================================================================================

INSERT INTO [dbo].[tbl_DatabaseInfo]
           ([majorversion]
           ,[minorversion]
           ,[releaseversion])
     VALUES
           (1
           ,0
           ,1)
GO
