USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcNews]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcNews]
@LangId int
AS


BEGIN
SET NOCOUNT ON;

select * from RiskManagement.News where IsActive=1 and StartDate<GETDATE() and EndDate>GETDATE() and LangId=@LangId
  

END
GO
