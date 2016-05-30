USE [KPIDB]
GO

INSERT INTO [dbo].[tbl_KpiReportingPeriod] ([reportingUnitId],[periodsToReport], [days]) VALUES ('DAY',	30, 1)
INSERT INTO [dbo].[tbl_KpiReportingPeriod] ([reportingUnitId],[periodsToReport], [days]) VALUES ('MONTH', 12, 30)
INSERT INTO [dbo].[tbl_KpiReportingPeriod] ([reportingUnitId],[periodsToReport], [days]) VALUES ('QUART', 4, 90)
INSERT INTO [dbo].[tbl_KpiReportingPeriod] ([reportingUnitId],[periodsToReport], [days]) VALUES ('WEEK', 52, 7)
INSERT INTO [dbo].[tbl_KpiReportingPeriod] ([reportingUnitId],[periodsToReport], [days]) VALUES ('YEAR', 10, 365)