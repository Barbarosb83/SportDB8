USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Outrights.ProcMatchOdd]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [Betradar].[Outrights.ProcMatchOdd]
@MatchId bigint,
@BetradarOddTypeId bigint,
@OutCome nvarchar(50),
--@OutComeId int,
--@BetRadarPlayerId bigint,
--@BetradarTeamId bigint,
@OddValue float,
@SpecialBetValue nvarchar(50),
@BettradarOddId bigint,
@SportId int,
@Category int,
@TournamentBetradarId int,
@BetradarCompetitorId bigint

AS

SET NOCOUNT ON;
	declare @SwCode int
declare @OddsTypeId bigint=@BetradarOddTypeId
declare @oddId bigint=@BettradarOddId
declare @MatchoddId int
declare @PlayerId int=0
declare @TeamId int=0
declare @TournamentId int=0
declare @CompetitorId bigint=@BetradarCompetitorId
declare @BetradarMatchId bigint
set @SpecialBetValue= REPLACE(@SpecialBetValue, 'pre:markettext:', '')
declare @Special2 bigint=0
	 --if @MatchId=118566
 --insert dbo.betslip values (@MatchId,'Outrights:'+cast(@BetradarOddTypeId as nvarchar(50))+'-BetradOdd:'+cast(@BettradarOddId as nvarchar(50))+'-Oddvalue:'+ISNULL(cast(@OddValue as nvarchar(50)),'')+'-Outcome'+ISNULL(@OutCome,'')+'-Speciel'+ISNULL(@SpecialBetValue,'')+'-'+ISNULL(CAST(@BetradarCompetitorId as nvarchar(50)),''),GETDATE())
 declare @eventBetrradarId bigint

 select @eventBetrradarId=EventBetradarId from Outrights.Event where EventId=@MatchId
 
  set @Special2 = CASE WHEN TRY_CAST(@SpecialBetValue AS bigint) IS NULL THEN 0 ELSE cast(@SpecialBetValue as bigint) end

 
if (ISNULL(@SpecialBetValue,'')<>'')		
if(@MatchId>0 and @Special2=@eventBetrradarId)
begin
select @TournamentId=Parameter.TournamentOutrights.TournamentId from Parameter.TournamentOutrights  with (nolock) where
	Parameter.TournamentOutrights.BetradarTournamentId=@TournamentBetradarId

	

	--select  @MatchId=Outrights.Event.EventId from Outrights.Event with (nolock)
	--				where Outrights.Event.EventBetradarId=@MatchId

select top 1 @CompetitorId=CompetitorId from Parameter.Competitor with (nolock) 
where CompetitorId in (Select Outrights.Competitor.CompetitorId from Outrights.Competitor with (nolock) where EventId=@MatchId ) and CompetitorName=@OutCome

--if((@BetradarOddTypeId=10) )
--	begin
--		set @BetradarOddTypeId=381
--	end
--else if (@SportId=1 and @BetradarOddTypeId=383)
--	begin
--		set @BetradarOddTypeId=56
--	end
--else if (@SportId=1 and @BetradarOddTypeId=60)
--	begin
--		set @BetradarOddTypeId=56
--	end
--else if (@SportId=1 and @BetradarOddTypeId=385)
--	begin
--		set @BetradarOddTypeId=2
--	end
--else if (@SportId=1 and @BetradarOddTypeId=384)
--	begin
--		set @BetradarOddTypeId=1
--	end
 --if (@SportId=1 and @BetradarOddTypeId=383)
	--begin
	--	set @BetradarOddTypeId=56
	--end



--SELECT  top 1   @oddId= Parameter.Odds.OddsId,@OddsTypeId=Parameter.OddsType.OddsTypeId
--FROM         Parameter.Odds  with (nolock) INNER JOIN
--                      Parameter.OddsType  with (nolock) ON Parameter.Odds.OddTypeId = Parameter.OddsType.OddsTypeId
--where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and  Parameter.OddsType.SportId=@SportId and Parameter.Odds.Outcomes=@OutCome and Parameter.OddsType.IsActive=1


--		if(@oddId is null)
--			begin
--			SELECT  top 1   @oddId= Parameter.Odds.OddsId
--			FROM         Parameter.Odds with (nolock) INNER JOIN
--								  Parameter.OddsType with (nolock) ON Parameter.Odds.OddTypeId = Parameter.OddsType.OddsTypeId
--			where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and  Parameter.OddsType.SportId=30 and Parameter.Odds.Outcomes=@OutCome --and Parameter.OddsType.IsActive=1
--			end

--			if(@oddId is null)
--			begin
--			SELECT  top 1   @oddId= Parameter.Odds.OddsId
--			FROM         Parameter.Odds with (nolock) INNER JOIN
--								  Parameter.OddsType with (nolock) ON Parameter.Odds.OddTypeId = Parameter.OddsType.OddsTypeId
--			where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and  Parameter.OddsType.SportId=@SportId --and Parameter.OddsType.IsActive=1 --and Parameter.Odds.Outcomes=@OutCome
--			end


--if(@OddsTypeId is null)
--begin


--SELECT  top 1  @OddsTypeId=Parameter.OddsType.OddsTypeId
--FROM        Parameter.OddsType  with (nolock)
--where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and  Parameter.OddsType.SportId=@SportId and Parameter.OddsType.IsActive=1

--if(@OddsTypeId is null)
--	SELECT  top 1  @OddsTypeId=Parameter.OddsType.OddsTypeId
--	FROM        Parameter.OddsType  with (nolock)
--	where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and IsActive=1
--end


--if(@oddId is null)
--begin
--SELECT  top 1   @oddId= Parameter.Odds.OddsId
--FROM         Parameter.Odds  with (nolock) INNER JOIN
--                      Parameter.OddsType  with (nolock) ON Parameter.Odds.OddTypeId = Parameter.OddsType.OddsTypeId
--where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and  Parameter.OddsType.SportId=30 and Parameter.Odds.Outcomes=@OutCome and Parameter.OddsType.IsActive=1
--end

--if(@oddId is null)
--begin
--SELECT  top 1   @oddId= Parameter.Odds.OddsId
--FROM         Parameter.Odds  with (nolock) INNER JOIN
--                      Parameter.OddsType  with (nolock) ON Parameter.Odds.OddTypeId = Parameter.OddsType.OddsTypeId
--where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and Parameter.OddsType.IsActive=1 --and Parameter.Odds.Outcomes=@OutCome
--end

if(@OutCome<>'off' and @OutCome<>'')
begin
	If exists (select Outrights.Odd.OddId from Outrights.Odd with (nolock)   where    Outrights.Odd.MatchId=@MatchId and Outrights.Odd.BettradarOddId=@BettradarOddId)
		begin
	 if  exists (select  Outrights.Odd.OddId  from Outrights.Odd  with (nolock)  where  Outrights.Odd.MatchId=@MatchId  and Outrights.Odd.BettradarOddId=@BettradarOddId and  SWCode is null) 
		begin
		if (Select COUNT(Outrights.Odd.OddId) from Outrights.Odd  with (nolock)  where  OddsTypeId=@OddsTypeId and Outrights.Odd.MatchId=@MatchId )<=36
			begin
				 Select top 1  @SwCode= [SCCode] from Parameter.SwCode with (nolock) where
				  Parameter.SwCode.[SCCode] not in (Select SwCode from Outrights.Odd  with (nolock) where OddsTypeId=@OddsTypeId and Outrights.Odd.MatchId=@MatchId)
				 
					update Outrights.Odd set Outrights.Odd.Suggestion=@OddValue, Outrights.Odd.OddValue=@OddValue,SWCode=@SwCode --,OutCome=@OutCome
					where   Outrights.Odd.MatchId=@MatchId and Outrights.Odd.BettradarOddId=@BettradarOddId
			end
		else
			begin
				
				update Outrights.Odd set Outrights.Odd.Suggestion=@OddValue, Outrights.Odd.OddValue=@OddValue --,OutCome=@OutCome 
				where    Outrights.Odd.MatchId=@MatchId and Outrights.Odd.BettradarOddId=@BettradarOddId
			end
		end
	 else
		begin
			update Outrights.Odd set Outrights.Odd.Suggestion=@OddValue, Outrights.Odd.OddValue=@OddValue --,OutCome=@OutCome
			where   Outrights.Odd.MatchId=@MatchId and Outrights.Odd.BettradarOddId=@BettradarOddId
		end
	end
	else
		begin

	if (@OddsTypeId is not null)
		begin
			 Select top 1  @SwCode= [SCCode] from Parameter.SwCode with (nolock) where Parameter.SwCode.[SCCode] not in (Select ISNULL(SwCode,0) from Outrights.Odd  with (nolock) where  
			 OddsTypeId=@OddsTypeId and Outrights.Odd.MatchId=@MatchId )

			 insert into Outrights.Odd ( Outrights.Odd.OddsTypeId,Outrights.Odd.OutCome,Outrights.Odd.SpecialBetValue,Outrights.Odd.Suggestion,Outrights.Odd.OddValue
			 ,Outrights.Odd.MatchId,Outrights.Odd.BettradarOddId,Outrights.Odd.ParameterOddId,Outrights.Odd.BetradarOddTypeId,Outrights.Odd.ParameterSportId,Outrights.Odd.CompetitorId,SWCode,IsOddValueLock)
			 values ( @OddsTypeId,@OutCome,@SpecialBetValue,@OddValue,@OddValue,@MatchId,@BettradarOddId,@oddId,@BetradarOddTypeId,@SportId,@CompetitorId,@SwCode,0)
		
			set @MatchoddId=SCOPE_IDENTITY()
			
			execute Betradar.[Outrights.ProcOddSettingInsert]  @OddsTypeId,@MatchoddId,@MatchId,@SportId,@Category,@TournamentId
		end
end
end
else
	begin
		update Outrights.Event set IsActive=0 where Outrights.Event.EventId=@MatchId
	end

	end
GO
