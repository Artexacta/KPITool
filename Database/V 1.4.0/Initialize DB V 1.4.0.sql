Use [KPIDB]
GO

IF NOT EXISTS(SELECT 1 FROM [dbo].[tbl_SEG_Permission] WHERE [permissionID] = 1)
INSERT [dbo].[tbl_SEG_Permission] ([permissionID], [mnemonic], [description]) VALUES (1, N'MANAGE_SECURITY', N'Administración de Seguridad')
GO

IF NOT EXISTS(SELECT 1 FROM [dbo].[tbl_SEG_Permission] WHERE [permissionID] = 2)
INSERT INTO [dbo].[tbl_SEG_Permission] ([permissionID] ,[mnemonic] ,[description]) VALUES (2 ,'RESET_USER_ACCOUNT' ,'Permiso para resetear la información del usuario')
GO

IF NOT EXISTS(SELECT 1 FROM [dbo].[tbl_SEG_Permission] WHERE [permissionID] = 3)
INSERT INTO [dbo].[tbl_SEG_Permission]([permissionID] ,[mnemonic] ,[description]) VALUES (3 ,'MANAGE_CATEGORIES' ,'Permiso para Administrar Categorías')
GO

IF NOT EXISTS(SELECT 1 FROM [dbo].[tbl_SEG_AccessUser] WHERE [permissionID] = 1 AND [userID] = 1)
INSERT [dbo].[tbl_SEG_AccessUser] ([permissionID], [userID]) VALUES (1, 1)
GO