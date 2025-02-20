USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Lsports].[ProcMatchOdd]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Lsports].[ProcMatchOdd]
@LSFixtureId bigint,
@LSOddTypeId bigint,
@LSOddId bigint,
@OutCome nvarchar(50),
@OddValue float,
@SpecialBetValue nvarchar(50),
@Settlement int
--@OutComeId int,
--@OddValue float,
--@BettradarOddId bigint,
--@Category int,
--@TournamentId int,
--@BetRadarPlayerId nvarchar(50),
--@BetradarTeamId nvarchar(50)

AS


SET NOCOUNT ON;

declare @OddsTypeId int
declare @oddId int
declare @MatchoddId int
declare @PlayerId int=0
declare @TeamId int=0

declare @MatchId bigint=0
declare @SportId bigint=0
declare @CategoryId bigint=0
declare @TournamentId bigint=0

declare @BetRadarPlayerId nvarchar(50)=null
declare @BetradarTeamId nvarchar(50)=null
declare @OutComeId int=0


select @MatchId=Match.MatchId, @SportId=Parameter.Category.SportId,@CategoryId=Parameter.Category.CategoryId,@TournamentId=Match.Match.TournamentId from 
	Match.Match inner join Parameter.Tournament on Match.Match.TournamentId=Parameter.Tournament.TournamentId
	inner join Parameter.Category on Parameter.Category.CategoryId=Parameter.Tournament.CategoryId
	where Match.Match.BetradarMatchId=@LSFixtureId

	
		SELECT  top 1   @oddId= Parameter.Odds.OddsId,@OddsTypeId=Parameter.OddsType.OddsTypeId
		FROM         Parameter.Odds with (nolock) INNER JOIN
							  Parameter.OddsType with (nolock) ON Parameter.Odds.OddTypeId = Parameter.OddsType.OddsTypeId
		where Parameter.OddsType.LSId=@LSOddTypeId and  Parameter.OddsType.SportId=@SportId and Parameter.Odds.Outcomes=@OutCome --and Parameter.OddsType.IsActive=1

			if(@oddId is null)
			begin
				SELECT  top 1   @oddId= Parameter.Odds.OddsId
				FROM         Parameter.Odds with (nolock) INNER JOIN
									  Parameter.OddsType with (nolock) ON Parameter.Odds.OddTypeId = Parameter.OddsType.OddsTypeId
				where Parameter.OddsType.LSId=@LSOddTypeId and  Parameter.OddsType.SportId=30 and Parameter.Odds.Outcomes=@OutCome --and Parameter.OddsType.IsActive=1
			end

			if(@oddId is null)
			begin
				SELECT  top 1   @oddId= Parameter.Odds.OddsId
				FROM         Parameter.Odds with (nolock) INNER JOIN
									  Parameter.OddsType with (nolock) ON Parameter.Odds.OddTypeId = Parameter.OddsType.OddsTypeId
				where Parameter.OddsType.LSId=@LSOddTypeId and  Parameter.OddsType.SportId=@SportId --and Parameter.OddsType.IsActive=1 --and Parameter.Odds.Outcomes=@OutCome
			end


			if(@OddsTypeId is null)
			begin
				SELECT  top 1  @OddsTypeId=Parameter.OddsType.OddsTypeId
				FROM        Parameter.OddsType with (nolock)
				where Parameter.OddsType.LSId=@LSOddTypeId and  Parameter.OddsType.SportId=@SportId -- and Parameter.OddsType.IsActive=1
				


			if(@OddsTypeId is null)
				SELECT  top 1  @OddsTypeId=Parameter.OddsType.OddsTypeId
				FROM        Parameter.OddsType with (nolock)
				where Parameter.OddsType.LSId=@LSOddTypeId and  Parameter.OddsType.SportId=30 --and IsActive=1
			end
			
		if(@OutCome<>'-1' and @OddValue>1)
			begin
			if(@SpecialBetValue is null)
			begin
				If EXISTS (select Match.Odd.OddId from Match.Odd with (nolock)  where Match.Odd.ParameterOddId=@oddId and Match.Odd.MatchId=@MatchId and Match.Odd.OutCome=@OutCome and IsOddValueLock=1)
				begin
					update Match.Odd set Match.Odd.Suggestion=@OddValue
					where Match.Odd.ParameterOddId=@oddId and Match.Odd.MatchId=@MatchId and Match.Odd.OutCome=@OutCome
				end
			else
				begin
		
					update Match.Odd set Match.Odd.Suggestion=@OddValue,
					Match.Odd.OddValue=@OddValue
					where Match.Odd.ParameterOddId=@oddId and Match.Odd.MatchId=@MatchId and Match.Odd.OutCome=@OutCome
				end
			end
			else
			begin

				If EXISTS (select Match.Odd.OddId from Match.Odd  where Match.Odd.ParameterOddId=@oddId and Match.Odd.MatchId=@MatchId and Match.Odd.OutCome=@OutCome and Match.Odd.SpecialBetValue=@SpecialBetValue and IsOddValueLock=1)
				begin
					update Match.Odd set Match.Odd.Suggestion=@OddValue,[BetRadarPlayerId]=@BetRadarPlayerId,[BetradarTeamId]=@BetradarTeamId
					where Match.Odd.ParameterOddId=@oddId and Match.Odd.MatchId=@MatchId and Match.Odd.SpecialBetValue=@SpecialBetValue and Match.Odd.OutCome=@OutCome
				end
				else
					begin
			
						update Match.Odd set Match.Odd.Suggestion=@OddValue,[BetRadarPlayerId]=@BetRadarPlayerId,[BetradarTeamId]=@BetradarTeamId,
						Match.Odd.OddValue=@OddValue
						where Match.Odd.ParameterOddId=@oddId and Match.Odd.MatchId=@MatchId and Match.Odd.SpecialBetValue=@SpecialBetValue and Match.Odd.OutCome=@OutCome
					end

			end
			if(@@ROWCOUNT=0)
			begin
				if (@OddsTypeId=1497 and @SpecialBetValue='0')  --Basketball handicap 0 ı almyoruz.
						set @OddsTypeId=null

				if (@OddsTypeId is not null )
					begin
			
						insert into Match.Odd (Match.Odd.OddsTypeId,Match.Odd.OutCome,Match.Odd.SpecialBetValue,Match.Odd.Suggestion,Match.Odd.OddValue,Match.Odd.MatchId,Match.Odd.BettradarOddId,Match.Odd.ParameterOddId,Match.Odd.BetradarOddTypeId,Match.Odd.ParameterSportId,Match.Odd.OutComeId,BetRadarPlayerId,BetradarTeamId,StateId)
						values (@OddsTypeId,@OutCome,@SpecialBetValue,@OddValue,@OddValue,@MatchId,@LSOddId,@oddId,@LSOddTypeId,@SportId,@OutComeId,@BetRadarPlayerId,@BetradarTeamId,2)
		
						set @MatchoddId=SCOPE_IDENTITY()
			
						execute Betradar.ProcOddSettingInsert  @OddsTypeId,@MatchoddId,@MatchId,@SportId,@CategoryId,@TournamentId
					end
			end
		end
		--else
		--	begin
		--		update Match.OddTypeSetting set StateId=1 where MatchId=@MatchId and OddTypeId=@OddsTypeId
		--		update Match.OddSetting set StateId=1 where Match.OddSetting.OddId in (select OddId from Match.Odd where MatchId=@MatchId and OddsTypeId=@OddsTypeId)
		--		update Match.Odd set OddValue=1 where MatchId=@MatchId and OddsTypeId=@OddsTypeId

		--	end




GO
