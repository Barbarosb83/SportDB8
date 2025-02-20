USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchOdd_NEW]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Betradar].[ProcMatchOdd_NEW]
@MatchId bigint,
@BetradarOddTypeId bigint,
@OutCome nvarchar(50),
@OutComeId int,
@OddValue float,
@SpecialBetValue nvarchar(50),
@BettradarOddId bigint,
@SportId int,
@Category int,
@TournamentId int,
@BetRadarPlayerId nvarchar(50),
@BetradarTeamId nvarchar(50)

AS


SET NOCOUNT ON;

declare @OddsTypeId int
declare @oddId bigint
declare @MatchoddId int 
declare @BetradarMatchId bigint=@MatchId


if exists (Select Parameter.OddsType.OddsTypeId from Parameter.OddsType where BetradarOddsTypeId=@BetradarOddTypeId and IsActive=1)
	begin


if exists(select  Match.Match.MatchId from Match.Match with (nolock) where Match.Match.BetradarMatchId=@BetradarMatchId)
if(@OutCome<>'')
begin



 if (@SportId=1 and @BetradarOddTypeId=383)
	begin
		set @BetradarOddTypeId=56
	end
else if (@SportId=1 and @BetradarOddTypeId=386)
	begin
		set @BetradarOddTypeId=10
	end
else if (@SportId=10 and @BetradarOddTypeId=60)
	begin
		set @BetradarOddTypeId=56	
	end


if(@BetradarOddTypeId in (48,49,202,232,553,206,233,332,234,453))
	set @SpecialBetValue=''


			
		if(@OutCome<>'-1' and @OddValue>1 )
			begin
			if(@SpecialBetValue is null)
			begin
					
					update Match.Odd set Match.Odd.Suggestion=@OddValue,
					Match.Odd.OddValue=@OddValue,Match.Odd.StateId=2
					where Match.Odd.BetradarOddTypeId=@BetradarOddTypeId 
					and Match.Odd.BetradarMatchId=@BetradarMatchId and Match.Odd.OutCome=@OutCome
				
			end
			else
			begin

						update Match.Odd set Match.Odd.Suggestion=@OddValue ,
						Match.Odd.OddValue=@OddValue,Match.Odd.StateId=2
						where Match.Odd.BetradarOddTypeId=@BetradarOddTypeId and Match.Odd.BetradarMatchId=@BetradarMatchId
						and Match.Odd.SpecialBetValue=@SpecialBetValue and Match.Odd.OutCome=@OutCome
	
			end
			if(@@ROWCOUNT=0 )
			begin
				select @SportId=SportId from Parameter.Sport with (nolock) where BetRadarSportId=@SportId

				select  @MatchId=Match.Match.MatchId from Match.Match with (nolock)
					where Match.Match.BetradarMatchId=@BetradarMatchId --and Match.Odd.OutCome=@OutCome

					if exists(sElect Match.Setting.MatchId from Match.Setting where MatchId=@MatchId and StateId=1)
						update Match.Setting set StateId=2 where MatchId=@MatchId


				SELECT  top 1   @oddId= Parameter.Odds.OddsId,@OddsTypeId=Parameter.OddsType.OddsTypeId
				FROM         Parameter.Odds with (nolock) INNER JOIN
									  Parameter.OddsType with (nolock) ON Parameter.Odds.OddTypeId = Parameter.OddsType.OddsTypeId
				where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and  Parameter.OddsType.SportId=@SportId and Parameter.Odds.Outcomes=@OutCome --and Parameter.OddsType.IsActive=1

			if(@oddId is null)
			begin
			SELECT  top 1   @oddId= Parameter.Odds.OddsId,@OddsTypeId=Parameter.OddsType.OddsTypeId
			FROM         Parameter.Odds with (nolock) INNER JOIN
								  Parameter.OddsType with (nolock) ON Parameter.Odds.OddTypeId = Parameter.OddsType.OddsTypeId
			where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and  Parameter.OddsType.SportId=30 and Parameter.Odds.Outcomes=@OutCome --and Parameter.OddsType.IsActive=1
			end

			if(@oddId is null)
			begin
			SELECT  top 1   @oddId= Parameter.Odds.OddsId,@OddsTypeId=Parameter.OddsType.OddsTypeId
			FROM         Parameter.Odds with (nolock) INNER JOIN
								  Parameter.OddsType with (nolock) ON Parameter.Odds.OddTypeId = Parameter.OddsType.OddsTypeId
			where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and  Parameter.OddsType.SportId=@SportId --and Parameter.OddsType.IsActive=1 --and Parameter.Odds.Outcomes=@OutCome
			end


			

				if ((@OddsTypeId=1497 and @SpecialBetValue='0') or (@OddsTypeId=1519 and @OutCome=''))  --Basketball handicap 0 ı almyoruz.
						set @OddsTypeId=null

				if (@OddsTypeId is not null )
					begin
						--if(@OddsTypeId not in (1836,1748,1749,1750,1751) and @SportId<>2)
						insert into Match.Odd (Match.Odd.OddsTypeId,Match.Odd.OutCome,Match.Odd.SpecialBetValue,Match.Odd.Suggestion,Match.Odd.OddValue,Match.Odd.MatchId,Match.Odd.BettradarOddId,Match.Odd.ParameterOddId,Match.Odd.BetradarOddTypeId,Match.Odd.ParameterSportId,Match.Odd.OutComeId,BetRadarPlayerId,BetradarTeamId,StateId,BetradarMatchId)
						values (@OddsTypeId,@OutCome,@SpecialBetValue,@OddValue,@OddValue,@MatchId,@BettradarOddId,@oddId,@BetradarOddTypeId,@SportId,@OutComeId,@BetRadarPlayerId,@BetradarTeamId,2,@BetradarMatchId)
						
						set @MatchoddId=SCOPE_IDENTITY()
			
						execute Betradar.ProcOddSettingInsert  @OddsTypeId,@MatchoddId,@MatchId,@SportId,@Category,@TournamentId
					end
			end
		end
		else
			begin
								select  @MatchId=Match.Match.MatchId from Match.Match with (nolock)
									where Match.Match.BetradarMatchId=@BetradarMatchId --and Match.Odd.OutCome=@OutCome

									if exists(sElect Match.Setting.MatchId from Match.Setting where MatchId=@MatchId and StateId=1)
										update Match.Setting set StateId=2 where MatchId=@MatchId


								SELECT  top 1   @oddId= Parameter.Odds.OddsId,@OddsTypeId=Parameter.OddsType.OddsTypeId
								FROM         Parameter.Odds with (nolock) INNER JOIN
													  Parameter.OddsType with (nolock) ON Parameter.Odds.OddTypeId = Parameter.OddsType.OddsTypeId
								where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and  Parameter.OddsType.SportId=@SportId and Parameter.Odds.Outcomes=@OutCome --and Parameter.OddsType.IsActive=1

							if(@oddId is null)
							begin
							SELECT  top 1   @oddId= Parameter.Odds.OddsId,@OddsTypeId=Parameter.OddsType.OddsTypeId
							FROM         Parameter.Odds with (nolock) INNER JOIN
												  Parameter.OddsType with (nolock) ON Parameter.Odds.OddTypeId = Parameter.OddsType.OddsTypeId
							where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and  Parameter.OddsType.SportId=30 and Parameter.Odds.Outcomes=@OutCome --and Parameter.OddsType.IsActive=1
							end

							if(@oddId is null)
							begin
							SELECT  top 1   @oddId= Parameter.Odds.OddsId,@OddsTypeId=Parameter.OddsType.OddsTypeId
							FROM         Parameter.Odds with (nolock) INNER JOIN
												  Parameter.OddsType with (nolock) ON Parameter.Odds.OddTypeId = Parameter.OddsType.OddsTypeId
							where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and  Parameter.OddsType.SportId=@SportId --and Parameter.OddsType.IsActive=1 --and Parameter.Odds.Outcomes=@OutCome
							end


				if (@OddsTypeId is not null)
				begin
				update Match.OddTypeSetting set StateId=1 where MatchId=@MatchId and OddTypeId=@OddsTypeId
				--update Match.OddSetting set StateId=1 where Match.OddSetting.OddId in (select OddId from Match.Odd where MatchId=@MatchId and OddsTypeId=@OddsTypeId)
				update Match.Odd set OddValue=1 where BetradarMatchId=@BetradarMatchId and BetradarOddTypeId=@BetradarOddTypeId
				end
			end
		end
end


GO
