USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCompetitorOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCompetitorOne]
@CompetitorId bigint,
@username nvarchar(max)

AS



BEGIN
SET NOCOUNT ON;


SELECT    CompetitorId, CompetitorName
FROM         Parameter.Competitor
WHERE     (CompetitorId =@CompetitorId)




END


GO
