USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcNewsOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcNewsOne]
@NewsId bigint

AS



BEGIN
SET NOCOUNT ON;


select * from RiskManagement.News where RiskManagement.News.NewsId=@NewsId




END



GO
