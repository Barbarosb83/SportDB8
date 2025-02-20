USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchOdd]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [Betradar].[ProcMatchOdd]
@MatchId bigint,
@BetradarOddTypeId bigint,
@OutCome nvarchar(100),
@OutComeId int,
@OddValue float,
@SpecialBetValue nvarchar(100),
@BettradarOddId bigint,
@SportId int,
@Category int,
@TournamentId int,
@BetRadarPlayerId nvarchar(100),
@BetradarTeamId nvarchar(100)

AS


SET NOCOUNT ON;
	
declare @OddsTypeId int
declare @oddId bigint
declare @MatchoddId bigint 
declare @BetradarMatchId bigint=@MatchId
 declare @control int=0
 
 if (@SportId in (1,10) and @BetradarOddTypeId=383)
	begin
		set @BetradarOddTypeId=56
	end
 if (@SportId in (5,19) and @BetradarOddTypeId=20)
	begin
		set @BetradarOddTypeId=382
	end
	
 else if (@SportId=1 and @BetradarOddTypeId=52)
	begin
			set @Control=1
	end
--else if (@SportId=1 and @BetradarOddTypeId=386)
--	begin
--		set @BetradarOddTypeId=10
--	end
else if (@SportId=1 and @BetradarOddTypeId=381)
	begin
		set @BetradarOddTypeId=10
	end
else if (@SportId=10 and @BetradarOddTypeId=60)
	begin
		set @BetradarOddTypeId=56	
	end
	 
 --insert dbo.betslip values (@BetradarMatchId,cast(@BetradarOddTypeId as nvarchar(20))+' '+ @OutCome+' SportID: '+cast(@SportId as  nvarchar(50)),GETDATE())
--	select * from     dbo.betslip where Id in (53542545,53755249,53542519,53542247) order by createdate desc	
--   select DISTINCT ID from  truncate table   dbo.betslip 
--if exists (Select Parameter.OddsType.OddsTypeId from Parameter.OddsType with (nolock) where BetradarOddsTypeId=@BetradarOddTypeId and IsActive=1) and @control=0
--	begin


 --if exists(select  Match.Match.MatchId from Match.Match with (nolock) where Match.Match.BetradarMatchId=@BetradarMatchId)
 if exists (Select Parameter.OddsType.OddsTypeId from Parameter.OddsType with (nolock) where BetradarOddsTypeId=@BetradarOddTypeId and IsActive=1 ) and @Control=0
if(@OutCome<>'')
begin


declare @OddFactor float
declare @NewOddValue float=@OddValue
	
	select @OddFactor=1.05
	
							--	if @BetradarMatchId>0
							set @NewOddValue = ROUND(@OddValue*@OddFactor, 2)
								set @NewOddValue=CASE
								WHEN cast(@NewOddValue as decimal(10,2)) % 1 < 0.25 THEN cast(FLOOR(@NewOddValue * 20) / 20 as decimal(10,2))
								WHEN cast(@NewOddValue as decimal(10,2)) % 1 >= 0.25 AND cast(@NewOddValue as decimal(10,2)) % 1 < 0.75 THEN cast(ROUND(@NewOddValue * 20, 0) / 20 as decimal(10,2))
								ELSE cast(CEILING(@NewOddValue * 20) / 20 as decimal(10,2)) end

if(@BetradarOddTypeId in (48,49,202,232,553,206,233,332,234,453,382,732,733,730,235,337,201,222))
	set @SpecialBetValue=''


			
		if(@OutCome<>'-1' and @OddValue>1 )
			begin
				--if  exists (Select OddId from Match.Odd where Match.Odd.OddId=@BettradarOddId and  Match.Odd.BetradarOddTypeId=@BetradarOddTypeId
				--		and Match.Odd.OutCome=@OutCome and  Match.Odd.SpecialBetValue =ISNULL(@SpecialBetValue,''))
					if exists (Select OddId from Match.Odd with (nolock) where Match.Odd.OddId=@BettradarOddId)
						begin
						if exists(sElect Match.Setting.MatchId from Match.Setting with (nolock) where MatchId=@MatchId and StateId=1 and Username is null)
											update Match.Setting set StateId=2 where MatchId=@MatchId
 

								--update Match.Odd set Match.Odd.Suggestion=@NewOddValue ,
								--Match.Odd.OddValue=@NewOddValue,Match.Odd.StateId=2, BetRadarPlayerId= @BetRadarPlayerId
								----where Match.Odd.BetradarMatchId=@BetradarMatchId 
								----and Match.Odd.BettradarOddId=@BettradarOddId
								--where Match.Odd.BetradarMatchId=@BetradarMatchId and  Match.Odd.BetradarOddTypeId=@BetradarOddTypeId
								--and Match.Odd.OutCome=@OutCome and  Match.Odd.SpecialBetValue =ISNULL(@SpecialBetValue,'')

									update Match.Odd set Match.Odd.Suggestion=@NewOddValue ,
								Match.Odd.OddValue=@NewOddValue,Match.Odd.StateId=2, BetRadarPlayerId= @BetRadarPlayerId
								 where Match.Odd.OddId=@BettradarOddId
	 
						end
					else
						begin
							select @SportId=SportId from Parameter.Sport with (nolock) where BetRadarSportId=@SportId

							--select  @MatchId=Match.Match.MatchId from Match.Match with (nolock)
							--	where Match.Match.BetradarMatchId=@BetradarMatchId --and Match.Odd.OutCome=@OutCome

								if exists(sElect Match.Setting.MatchId from Match.Setting with (nolock) where MatchId=@MatchId and StateId=1)
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
									insert into Match.Odd (Match.Odd.OddId,Match.Odd.OddsTypeId,Match.Odd.OutCome,Match.Odd.SpecialBetValue,Match.Odd.Suggestion,Match.Odd.OddValue,Match.Odd.MatchId,Match.Odd.BettradarOddId,Match.Odd.ParameterOddId,Match.Odd.BetradarOddTypeId,Match.Odd.ParameterSportId,Match.Odd.OutComeId,BetRadarPlayerId,BetradarTeamId,StateId,BetradarMatchId)
									values (@BettradarOddId,@OddsTypeId,@OutCome,ISNULL(@SpecialBetValue,''),@NewOddValue,@NewOddValue,@MatchId,@BettradarOddId,@oddId,@BetradarOddTypeId,@SportId,@OutComeId,@BetRadarPlayerId,@BetradarTeamId,2,@BetradarMatchId)
						
									set @MatchoddId=@BettradarOddId
			
									execute Betradar.ProcOddSettingInsert  @OddsTypeId,@MatchoddId,@MatchId,@SportId,@Category,@TournamentId
								end
						end
		end
		else
			begin
								--select  @MatchId=Match.Match.MatchId from Match.Match with (nolock)
								--	where Match.Match.BetradarMatchId=@BetradarMatchId --and Match.Odd.OutCome=@OutCome

									if exists(sElect Match.Setting.MatchId from Match.Setting where MatchId=@MatchId and StateId=1 and Username is null)
											update Match.Setting set StateId=2 where MatchId=@MatchId


							--	SELECT  top 1   @oddId= Parameter.Odds.OddsId,@OddsTypeId=Parameter.OddsType.OddsTypeId
							--	FROM         Parameter.Odds with (nolock) INNER JOIN
							--						  Parameter.OddsType with (nolock) ON Parameter.Odds.OddTypeId = Parameter.OddsType.OddsTypeId
							--	where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and  Parameter.OddsType.SportId=@SportId and Parameter.Odds.Outcomes=@OutCome --and Parameter.OddsType.IsActive=1

							--if(@oddId is null)
							--begin
							--SELECT  top 1   @oddId= Parameter.Odds.OddsId,@OddsTypeId=Parameter.OddsType.OddsTypeId
							--FROM         Parameter.Odds with (nolock) INNER JOIN
							--					  Parameter.OddsType with (nolock) ON Parameter.Odds.OddTypeId = Parameter.OddsType.OddsTypeId
							--where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and  Parameter.OddsType.SportId=30 and Parameter.Odds.Outcomes=@OutCome --and Parameter.OddsType.IsActive=1
							--end

							--if(@oddId is null)
							--begin
							--SELECT  top 1   @oddId= Parameter.Odds.OddsId,@OddsTypeId=Parameter.OddsType.OddsTypeId
							--FROM         Parameter.Odds with (nolock) INNER JOIN
							--					  Parameter.OddsType with (nolock) ON Parameter.Odds.OddTypeId = Parameter.OddsType.OddsTypeId
							--where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and  Parameter.OddsType.SportId=@SportId --and Parameter.OddsType.IsActive=1 --and Parameter.Odds.Outcomes=@OutCome
							--end


				if (@OddsTypeId is not null)
				begin
				--update Match.OddTypeSetting set StateId=1 where MatchId=@MatchId and OddTypeId=@OddsTypeId
				--update Match.OddSetting set StateId=1 where Match.OddSetting.OddId in (select OddId from Match.Odd where MatchId=@MatchId and OddsTypeId=@OddsTypeId)
				update Match.Odd set OddValue=1,StateId=1 where BetradarMatchId=@BetradarMatchId and BetradarOddTypeId=@BetradarOddTypeId
				end
			end
		end
--end


GO
