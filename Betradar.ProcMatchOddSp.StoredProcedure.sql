USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchOddSp]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[ProcMatchOddSp] 
@sqlcommand nvarchar(max)
AS

BEGIN
SET NOCOUNT ON;


BEGIN TRAN
--exec sp_MSforeachtable 'ALTER TABLE [Match].[Odd] NOCHECK CONSTRAINT ALL'
execute (@sqlcommand)
--exec sp_MSforeachtable 'ALTER TABLE [Match].[Odd] CHECK CONSTRAINT ALL' 

COMMIT TRAN
END


GO
