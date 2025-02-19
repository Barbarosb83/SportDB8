USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcNews2]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcNews2]
@LangId int,
@ViewScreen int
AS


BEGIN
SET NOCOUNT ON;
--@ViewType
--BranchView 1
--TerminalView 2
--TvView 3
--WebView 4 
select * from RiskManagement.News where IsActive=1 and RiskManagement.News.IsTvView=1 and StartDate<GETDATE() and EndDate>GETDATE() and LangId=@LangId
  

END
GO
