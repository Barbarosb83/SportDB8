USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCompetitorList]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcCompetitorList] 
 
AS

BEGIN
SET NOCOUNT ON;


 select CompetitorId, CompetitorName,BetradarSuperId
FROM         Parameter.Competitor
WHERE     (CompetitorId <> 0)
END


GO
