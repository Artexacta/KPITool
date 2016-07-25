USE [KPIDB]
GO

UPDATE [dbo].[tbl_UnitsAllowedForCurrency] SET [orden] = 1, [hasMeasure] = 0 WHERE currencyID = 'EUR' AND currencyUnitID = 'EUR'
UPDATE [dbo].[tbl_UnitsAllowedForCurrency] SET [orden] = 2, [hasMeasure] = 1 WHERE currencyID = 'EUR' AND currencyUnitID = 'THO'
UPDATE [dbo].[tbl_UnitsAllowedForCurrency] SET [orden] = 3, [hasMeasure] = 1 WHERE currencyID = 'EUR' AND currencyUnitID = 'BIL'

UPDATE [dbo].[tbl_UnitsAllowedForCurrency] SET [orden] = 1, [hasMeasure] = 0 WHERE currencyID = 'USD' AND currencyUnitID = 'DOL'
UPDATE [dbo].[tbl_UnitsAllowedForCurrency] SET [orden] = 2, [hasMeasure] = 1 WHERE currencyID = 'USD' AND currencyUnitID = 'THO'
UPDATE [dbo].[tbl_UnitsAllowedForCurrency] SET [orden] = 3, [hasMeasure] = 1 WHERE currencyID = 'USD' AND currencyUnitID = 'BIL'

UPDATE [dbo].[tbl_UnitsAllowedForCurrency] SET [orden] = 1, [hasMeasure] = 0 WHERE currencyID = 'PKR' AND currencyUnitID = 'CRO'
UPDATE [dbo].[tbl_UnitsAllowedForCurrency] SET [orden] = 2, [hasMeasure] = 1 WHERE currencyID = 'PKR' AND currencyUnitID = 'LAK'
UPDATE [dbo].[tbl_UnitsAllowedForCurrency] SET [orden] = 3, [hasMeasure] = 1 WHERE currencyID = 'PKR' AND currencyUnitID = 'RS '
UPDATE [dbo].[tbl_UnitsAllowedForCurrency] SET [orden] = 4, [hasMeasure] = 1 WHERE currencyID = 'PKR' AND currencyUnitID = 'THO'
UPDATE [dbo].[tbl_UnitsAllowedForCurrency] SET [orden] = 5, [hasMeasure] = 1 WHERE currencyID = 'PKR' AND currencyUnitID = 'BIL'
GO
