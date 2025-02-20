USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Virtual].[GamePlatform.ProcSports]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Virtual].[GamePlatform.ProcSports]
	@LangId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    
     SELECT     distinct  Language.[Parameter.Sport].SportName, 
				Parameter.Sport.SportName AS OrginalName, 
                Parameter.Sport.Icon AS SportIcon,
                Parameter.Sport.IconColor AS SportIconColor,
                Parameter.Sport.SportId

FROM            Virtual.Event INNER JOIN
                         Virtual.EventDetail ON Virtual.Event.EventId = Virtual.EventDetail.EventId INNER JOIN
                         Parameter.Tournament ON Virtual.Event.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                         Parameter.Category ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                         Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId AND Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
                         Language.[Parameter.Tournament] ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND 
                         Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId  AND Language.[Parameter.Tournament].LanguageId=@LangId  INNER JOIN
                         Language.[Parameter.Sport] ON Parameter.Sport.SportId = Language.[Parameter.Sport].SportId AND Parameter.Sport.SportId = Language.[Parameter.Sport].SportId AND 
                         Parameter.Sport.SportId = Language.[Parameter.Sport].SportId AND Parameter.Sport.SportId = Language.[Parameter.Sport].SportId  AND Language.[Parameter.Sport].LanguageId=@LangId   INNER JOIN
                         Language.[Parameter.Category] ON Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId AND Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId AND 
                         Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId  AND Language.[Parameter.Category].LanguageId=@LangId  INNER JOIN
                         Virtual.[EventSetting] on Virtual.[EventSetting].MatchId=Virtual.Event.EventId INNER JOIN Virtual.[EventTopOdd] ON Virtual.[EventTopOdd].EventId=Virtual.[Event].EventId
Where 
Virtual.[EventSetting].StateId=2 and --Match State Open
Virtual.[EventDetail].IsActive=1 and --Match Active
Virtual.[EventDetail].TimeStatu not in (5,27,84) 
    
END


GO
