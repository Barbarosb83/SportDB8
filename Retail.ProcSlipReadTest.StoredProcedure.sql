USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcSlipReadTest]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcSlipReadTest] 
@data nvarchar(max)
AS

BEGIN
SET NOCOUNT ON;

INSERT INTO [dbo].[betslip]
           ([data]
           ,[CreateDate])
     VALUES
           (@data,GETDATE())

		   select 1 as results
END





GO
