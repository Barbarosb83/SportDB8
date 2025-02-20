USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Stadium].[ProcSport]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

 
CREATE PROCEDURE [Stadium].[ProcSport] 
@LangId int,
@StadiumId bigint
AS

BEGIN
SET NOCOUNT ON;


if exists (Select SportId from Stadium.Sports where StadiumId=@StadiumId and SportId=-1)
	begin
		SELECT     Sport_1.SportId, Language.[Parameter.Sport].SportName, COUNT(Sport_1.MatchId) as SportEventCount, 
		Parameter.Sport.SportName AS OrginalName
		FROM         Parameter.Sport with (nolock) INNER JOIN
					Language.[Parameter.Sport] with (nolock) ON
					 Parameter.Sport.SportId = Language.[Parameter.Sport].SportId 
					 and Language.[Parameter.Sport].LanguageId=@LangId INNER JOIN
					Cache.Fixture AS Sport_1 with (nolock) ON Parameter.Sport.SportId = Sport_1.SportId
		Where  Sport_1.MatchDate>GETDATE()  and Sport_1.MatchDate<(Select Stadium.Stadium.EndDate from Stadium.Stadium where StadiumId=@StadiumId)
		 and Parameter.Sport.SportId in (Select SportId from Parameter.Sport)   and (SELECT     COUNT(DISTINCT OddTypeId)
                                        FROM          Match.OddTypeSetting with (nolock)
                                                      WHERE      (MatchId = Sport_1.MatchId) AND (StateId = 2))>0
		GROUP BY  Sport_1.SportId, Language.[Parameter.Sport].SportName,Parameter.Sport.SportName
		order by Sport_1.SportId
	end
else
	begin
		SELECT     Sport_1.SportId, Language.[Parameter.Sport].SportName, COUNT(Sport_1.MatchId) as SportEventCount, 
		Parameter.Sport.SportName AS OrginalName
		FROM         Parameter.Sport with (nolock) INNER JOIN
					Language.[Parameter.Sport] with (nolock) ON
					 Parameter.Sport.SportId = Language.[Parameter.Sport].SportId 
					 and Language.[Parameter.Sport].LanguageId=@LangId INNER JOIN
					Cache.Fixture AS Sport_1 with (nolock) ON Parameter.Sport.SportId = Sport_1.SportId
		Where  Sport_1.MatchDate>GETDATE() and Sport_1.MatchDate<(Select Stadium.Stadium.EndDate from Stadium.Stadium where StadiumId=@StadiumId)  and (SELECT     COUNT(DISTINCT OddTypeId)
                                        FROM          Match.OddTypeSetting with (nolock)
                                                      WHERE      (MatchId = Sport_1.MatchId) AND (StateId = 2))>0
		 and Parameter.Sport.SportId in (Select SportId from Stadium.Sports where StadiumId=@StadiumId)
		GROUP BY  Sport_1.SportId, Language.[Parameter.Sport].SportName,Parameter.Sport.SportName
		order by Sport_1.SportId
	end


END


GO
