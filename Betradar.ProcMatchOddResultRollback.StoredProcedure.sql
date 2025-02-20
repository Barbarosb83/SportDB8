USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchOddResultRollback]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Betradar].[ProcMatchOddResultRollback]
@BetradarMatchId bigint,
@BetradarOddTypeId bigint,
@BetradarOddSubTypeId bigint,
@OutCome nvarchar(50),
@OutComeId int,
@BetRadarPlayerId bigint,
@BetradarTeamId bigint,
@OddValue float,
@SpecialBetValue nvarchar(50),
@BettradarOddId bigint,
@IsActive bit,
@Combination bigint,
@ForTheRest nchar(30),
@Comment nchar(30),
@MostBalanced bit,
@Changed bit,
@OddResult bit,
@VoidFactor float,
@BetradarTimeStamp datetime

AS

BEGIN
declare @OddsTypeId int
declare @oddId int
declare @PlayerId int=0
declare @TeamId int=0
declare @EventId bigint
 
-- --if(@BetradarOddTypeId=383)
--	--set @BetradarOddTypeId=56

--	if exists (Select Parameter.OddsType.OddsTypeId from Parameter.OddsType with (nolock) where BetradarOddsTypeId=@BetradarOddTypeId and IsActive=1)
--	begin

--if(@BetradarOddTypeId in (48,49,202,232,553,206,233,332,234,453))
--	set @SpecialBetValue=''


-- --insert dbo.betslip values (@BetradarMatchId,'[ProcMatchOddResultCancel]-'+cast(@BetradarOddTypeId as nvarchar(30))+'-'+ ISNULL(@OutCome,'') +'-'+ISNULL(@SpecialBetValue,''),GETDATE())	
		
--		declare @eventoddid bigint 
--		declare @IsOddValueLock bit
		
		
--			select @EventId=Match.Match.MatchId from Match.Match with (nolock) where Match.Match.[BetradarMatchId]=@BetradarMatchId
		
--		if(@SpecialBetValue is not null)
--			begin
--				select top 1 @eventoddid=Match.Odd.OddId,@OddsTypeId=OddsTypeId,@IsOddValueLock=Match.Odd.IsOddValueLock 
--				from Match.Odd with (nolock) 
--			where Match.Odd.BetradarOddTypeId=@BetradarOddTypeId and Match.Odd.MatchId=@EventId   and Match.Odd.SpecialBetValue=@SpecialBetValue
		
--		if(@eventoddid is not null)
--			begin
--				if exists (select Match.OddsResult.OddsResultId from Match.OddsResult with (nolock) where Match.OddsResult.OddsTypeId=@OddsTypeId and Match.OddsResult.MatchId=@EventId )--and Match.OddsResult.Outcome=@OutCome and Match.OddsResult.SpecialBetValue=@SpecialBetValue)
--						delete from Match.OddsResult  where Match.OddsResult.OddsTypeId=@OddsTypeId and Match.OddsResult.MatchId=@EventId --and Match.OddsResult.Outcome=@OutCome and Match.OddsResult.SpecialBetValue=@SpecialBetValue
				
--			end
			
--			END
--			ELSE if(@OutCome is not null)
--			begin
--							select top 1 @eventoddid=Match.Odd.OddId,@OddsTypeId=OddsTypeId,@IsOddValueLock=Match.Odd.IsOddValueLock 
--				from Match.Odd with (nolock) 
--			where Match.Odd.BetradarOddTypeId=@BetradarOddTypeId and Match.Odd.MatchId=@EventId and Match.Odd.OutCome=@OutCome  
--			if(@eventoddid is not null)
--			begin
--				if exists (select Match.OddsResult.OddsResultId from Match.OddsResult with (nolock) where Match.OddsResult.OddsTypeId=@OddsTypeId and Match.OddsResult.MatchId=@EventId )--and Match.OddsResult.Outcome=@OutCome)
--						delete from Match.OddsResult  where Match.OddsResult.OddsTypeId=@OddsTypeId and Match.OddsResult.MatchId=@EventId and Match.OddsResult.Outcome=@OutCome
				
--			end

	
		
--			ENd

--			ELSE 
--			begin
--							select top 1 @eventoddid=Match.Odd.OddId,@OddsTypeId=OddsTypeId,@IsOddValueLock=Match.Odd.IsOddValueLock 
--				from Match.Odd with (nolock) 
--			where Match.Odd.BetradarOddTypeId=@BetradarOddTypeId and Match.Odd.MatchId=@EventId --and Match.Odd.OutCome=@OutCome  
--			if(@eventoddid is not null)
--			begin
--				if exists (select Match.OddsResult.OddsResultId from Match.OddsResult with (nolock) where Match.OddsResult.OddsTypeId=@OddsTypeId and Match.OddsResult.MatchId=@EventId )--and Match.OddsResult.Outcome=@OutCome)
--						delete from Match.OddsResult  where Match.OddsResult.OddsTypeId=@OddsTypeId and Match.OddsResult.MatchId=@EventId --and Match.OddsResult.Outcome=@OutCome
				
--			end

	
		
--			ENd
		

--		 --insert dbo.betslip values (@BetradarMatchId,'[ProcMatchOddResultCancel]-'+cast(@eventoddid as nvarchar(30))+'-'+ cast(@OddsTypeId as nvarchar(30)) ,GETDATE())	
		
		
		
--		if(@eventoddid is not null)
--				begin
				 
--						 update Customer.SlipOdd set Customer.SlipOdd.StateId=1 where Customer.SlipOdd.OddId in (select  Match.Odd.OddId from Match.Odd with (nolock) 
--			where Match.Odd.BetradarOddTypeId=@BetradarOddTypeId and Match.Odd.MatchId=@EventId) and Customer.SlipOdd.MatchId=@EventId 
--						 and Customer.SlipOdd.BetTypeId=0
						 
--					--	 exec RiskManagement.ProcSlipOddsEvaluateRollBackNew @EventId,@OddsTypeId,0
						
					 
				

--				end

--	end

select 0
	
	
	

END



GO
