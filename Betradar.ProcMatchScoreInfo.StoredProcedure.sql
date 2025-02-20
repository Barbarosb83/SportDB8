USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchScoreInfo]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[ProcMatchScoreInfo]
@MatchId bigint,
@MatchTimeType nvarchar(20),
@Score nvarchar(15),
@DecidedByFA bit

AS

BEGIN
declare @sportId int
declare @matchtimetypeId int
----if exists (select Parameter.MatchTimeType.MatchTimeTypeId from Parameter.MatchTimeType with (nolock) where Parameter.MatchTimeType.MatchTimeType=@MatchTimeType)
--	select @matchtimetypeId=Parameter.MatchTimeType.MatchTimeTypeId from Parameter.MatchTimeType with (nolock) where Parameter.MatchTimeType.MatchTimeType=@MatchTimeType
----else
----	begin
----		insert Parameter.MatchTimeType(MatchTimeType) values(@MatchTimeType)
----		set @matchtimetypeId=SCOPE_IDENTITY()
----	end



--	--IF EXISTS (select Customer.SlipOdd.SlipOddId from Customer.SlipOdd where Customer.SlipOdd.MatchId=@MatchId)
--	--	begin
--	--	SELECT   @sportId= Parameter.Category.SportId
--	--	FROM  Parameter.Category INNER JOIN
-- --                     Parameter.Tournament ON Parameter.Category.CategoryId = Parameter.Tournament.CategoryId INNER JOIN
-- --                     Match.Match ON Parameter.Tournament.TournamentId = Match.Match.TournamentId AND Parameter.Tournament.TournamentId = Match.Match.TournamentId
-- --                     where MatchId=@MatchId
		
--	--	if(@sportId=1)
--	--		begin
--	--			if(@matchtimetypeId= 1)
--	--				begin
--	--					update Customer.SlipOdd set Score=REPLACE(@Score,' ',''),ScoreTimeStatu=@matchtimetypeId where MatchId=@MatchId		
--	--				end
--	--			else if (@matchtimetypeId=2)
--	--					update Customer.SlipOdd set Score=REPLACE(@Score,' ',''),ScoreTimeStatu=@matchtimetypeId where MatchId=@MatchId		
--	--		end
--	--	else if (@sportId=2)
--	--		begin
--	--			if(@matchtimetypeId= 1)
--	--				begin
--	--					update Customer.SlipOdd set Score=REPLACE(@Score,' ',''),ScoreTimeStatu=@matchtimetypeId where MatchId=@MatchId		
--	--				end
--	--			else if (@matchtimetypeId=2)
--	--					update Customer.SlipOdd set Score=REPLACE(@Score,' ',''),ScoreTimeStatu=@matchtimetypeId where MatchId=@MatchId		
			
			
--	--		end
		
--	--	end



--if not exists (select Match.ScoreInfo.MatchId from Match.ScoreInfo with (nolock) where MatchId=@MatchId and MatchTimeTypeId=@matchtimetypeId)
--begin
--	insert Match.ScoreInfo (MatchId,MatchTimeTypeId,Score,DecidedByFA) 
--	values (@MatchId,@matchtimetypeId,@Score,@DecidedByFA)
	

	
--end
--ELSE
--	UPDATE Match.ScoreInfo set
--	MatchTimeTypeId=@matchtimetypeId,
--	Score=@Score
--	where MatchId=@MatchId and MatchTimeTypeId=@matchtimetypeId
	
	
--		--if(@matchtimetypeId=17)
--		--begin
--		--exec [RiskManagement].[ProcOddsEvaluateCancel] @MatchId
--		--update Match.Setting set StateId=1 where MatchId=@MatchId
--		--end
--		--else if(@matchtimetypeId=16)
--		--exec [RiskManagement].[ProcOddsEvaluateCancel] @MatchId

	
END


GO
