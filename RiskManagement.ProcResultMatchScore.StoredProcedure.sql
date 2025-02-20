USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcResultMatchScore]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 03.03.2015
-- Description:
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcResultMatchScore] 
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(200),
@orderby nvarchar(100),
@MatchId int,
@LangId int,
@Islive bit
AS
BEGIN
SET NOCOUNT ON;


if(@Islive=0)
begin
select 0 as totalrow,Match.ScoreInfo.ScoreInfoId,Match.ScoreInfo.MatchId, Match.ScoreInfo.MatchTimeTypeId, Parameter.MatchTimeType.MatchTimeType, Match.ScoreInfo.Score, Match.ScoreInfo.DecidedByFA,Match.ScoreInfo.Comment
FROM         Match.ScoreInfo INNER JOIN
                      Parameter.MatchTimeType ON Match.ScoreInfo.MatchTimeTypeId = Parameter.MatchTimeType.MatchTimeTypeId
                      WHERE     Match.ScoreInfo.MatchId= @MatchId
UNION ALL
select 0 as totalrow,[Archive].ScoreInfo.ScoreInfoId,[Archive].ScoreInfo.MatchId, [Archive].ScoreInfo.MatchTimeTypeId, Parameter.MatchTimeType.MatchTimeType, [Archive].ScoreInfo.Score, [Archive].ScoreInfo.DecidedByFA,[Archive].ScoreInfo.Comment
FROM         [Archive].ScoreInfo INNER JOIN
                      Parameter.MatchTimeType ON [Archive].ScoreInfo.MatchTimeTypeId = Parameter.MatchTimeType.MatchTimeTypeId
                      WHERE     [Archive].ScoreInfo.MatchId= @MatchId
end
else
begin
if exists (select Archive.[Live.EventDetail].EventDetailId from Archive.[Live.EventDetail] where Archive.[Live.EventDetail].EventId=@MatchId and Score is not null)
begin
	select 0 as totalrow,Archive.[Live.EventDetail].EventDetailId,Archive.[Live.EventDetail].EventId,0 as MatchTimeTypeId,'Full Time' as MatchTimeType,Archive.[Live.EventDetail].Score,@Islive as DecidedByFA,''  as Comment
	from Archive.[Live.EventDetail] 
	where Archive.[Live.EventDetail].EventId=@MatchId
end
else
begin
		select 0 as totalrow,Match.ScoreInfo.ScoreInfoId,Match.ScoreInfo.MatchId, Match.ScoreInfo.MatchTimeTypeId, Parameter.MatchTimeType.MatchTimeType, Match.ScoreInfo.Score, Match.ScoreInfo.DecidedByFA,Match.ScoreInfo.Comment
FROM         Match.ScoreInfo INNER JOIN
                      Parameter.MatchTimeType ON Match.ScoreInfo.MatchTimeTypeId = Parameter.MatchTimeType.MatchTimeTypeId
                      WHERE     Match.ScoreInfo.MatchId= (select top 1 MatchId from Archive.Match where BetradarMatchId in ((select BetradarMatchId from Archive.[Live.Event] where EventId=@MatchId)))
					  UNION ALL
	select 0 as totalrow,[Archive].ScoreInfo.ScoreInfoId,[Archive].ScoreInfo.MatchId, [Archive].ScoreInfo.MatchTimeTypeId, Parameter.MatchTimeType.MatchTimeType, [Archive].ScoreInfo.Score, [Archive].ScoreInfo.DecidedByFA,[Archive].ScoreInfo.Comment
FROM         [Archive].ScoreInfo INNER JOIN
                      Parameter.MatchTimeType ON [Archive].ScoreInfo.MatchTimeTypeId = Parameter.MatchTimeType.MatchTimeTypeId
                      WHERE     [Archive].ScoreInfo.MatchId= (select top 1 MatchId from Archive.Match where BetradarMatchId in ((select BetradarMatchId from Archive.[Live.Event] where EventId=@MatchId)))
end

end

END


GO
