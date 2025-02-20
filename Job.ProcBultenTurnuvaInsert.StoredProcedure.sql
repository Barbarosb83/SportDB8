USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Job].[ProcBultenTurnuvaInsert]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [Job].[ProcBultenTurnuvaInsert] 

AS

BEGIN
 
 
 INSERT INTO [Retail].[ProgrammeConfig]
           ([SportId]
           ,[CategoryId]
           ,[TournamentId]
           ,[ReportCount]
           ,[IsHighlights])
select Parameter.Sport.SportId,Parameter.Category.CategoryId,Parameter.Tournament.TournamentId,1,0 
from Parameter.Tournament INNER JOIN Parameter.Category On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN Parameter.Sport On Parameter.Sport.SportId=Parameter.Category.SportId
where TournamentId not in (SELECT         TournamentId 
FROM            Retail.ProgrammeConfig)

end
GO
