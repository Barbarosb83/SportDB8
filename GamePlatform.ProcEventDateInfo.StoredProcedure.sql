USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcEventDateInfo]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcEventDateInfo] 
@MatchId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;



select 
Match.FixtureDateInfo.ConfirmedMatchStart
,Match.FixtureDateInfo.Comment
,Parameter.DateInfoType.TypeName
from Match.FixtureDateInfo with (nolock) INNER JOIN
Match.Fixture with (nolock) ON Match.Fixture.FixtureId=Match.FixtureDateInfo.FixtureId INNER JOIN
Parameter.DateInfoType with (nolock) ON Parameter.DateInfoType.DateInfoTypeId=Match.FixtureDateInfo.DateInfoTypeId
where Match.Fixture.MatchId=@MatchId


END


GO
