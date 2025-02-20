USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchOddResult]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Betradar].[ProcMatchOddResult]
@MatchId bigint,
@BetradarOddTypeId bigint,
@OutCome nvarchar(50),
@OutComeId int,
@BetRadarPlayerId bigint,
@BetradarTeamId bigint,
@SpecialBetValue nvarchar(50),
@VoidFactor float,
@Status bit,
@Reason nvarchar(50),
@SportId int

AS

BEGIN
declare @OddsTypeId int
--if @MatchId=28077446
--	insert dbo.betslip values (@MatchId,cast(@BetradarOddTypeId as nvarchar(10))+'-Outcome'+ISNULL(@OutCome,'')+'-'+ISNULL(@SpecialBetValue,'')+' Sport:'+cast(@SportId as nvarchar(10)),GETDATE())

--if exists (Select Parameter.OddsType.OddsTypeId from Parameter.OddsType with (nolock) where BetradarOddsTypeId=@BetradarOddTypeId and IsActive=1)
--	begin
--	select @SportId=SportId from Parameter.Sport where BetRadarSportId=@SportId


-- if (@SportId=1 and @BetradarOddTypeId=383)
--	begin
--		set @BetradarOddTypeId=56
--	end
----else if (@SportId=1 and @BetradarOddTypeId=386)
----	begin
----		set @BetradarOddTypeId=10
----	end
--else if (@SportId=1 and @BetradarOddTypeId=381)
--	begin
--		set @BetradarOddTypeId=10
--	end
--else if (@SportId=10 and @BetradarOddTypeId=60)
--	begin
--		set @BetradarOddTypeId=56	
--	end

--if(@BetradarOddTypeId in (48,49,202,232,553,206,233,332,234,453,232))
--	set @SpecialBetValue=''

----select  @MatchId=Match.Match.MatchId from Match.Match
--			--		where Match.Match.BetradarMatchId=@MatchId --and Match.Odd.OutCome=@OutCome

				
					 
--					if exists (select Archive.Match.MatchId from Archive.Match with (nolock) where BetradarMatchId=@MatchId)
--						select @MatchId=Archive.Match.MatchId from Archive.Match where BetradarMatchId=@MatchId
--					else 
--						select @MatchId=Match.Match.MatchId from Match.Match with (nolock) where BetradarMatchId=@MatchId



--SELECT  top 1 @OddsTypeId= Parameter.OddsType.OddsTypeId
--FROM     Parameter.OddsType with (nolock)
--where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and  Parameter.OddsType.SportId=@SportId


--if(@OddsTypeId is null)
--SELECT  top 1 @OddsTypeId= Parameter.OddsType.OddsTypeId
--FROM     Parameter.OddsType with (nolock)
--where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and  Parameter.OddsType.SportId=30

--if(@OddsTypeId is not null )
--begin
 
--		if(@SpecialBetValue is not null)
--			begin
--				if not exists (select Match.OddsResult.OddsResultId from Match.OddsResult with (nolock) where MatchId=@MatchId and OddsTypeId=@OddsTypeId and Outcome=@OutCome and SpecialBetValue=@SpecialBetValue)
--					begin
--					--insert dbo.Tempbooking values(@MatchId,@OddsTypeId)
--						insert Match.OddsResult(MatchId,OddsTypeId,Outcome,SpecialBetValue,VoidFactor,OutcomeId,PlayerId,CompetitorId,[Status],Reason,BetradarOddTypeId)
--						values (@MatchId,@OddsTypeId,@OutCome,@SpecialBetValue,@VoidFactor,@OutComeId,@PlayerId,@TeamId,@Status,@Reason,@BetradarOddTypeId)
--					end
--				else
--					begin
--					if not exists (select Match.OddsResult.OddsResultId from Match.OddsResult with (nolock) where MatchId=@MatchId and OddsTypeId=@OddsTypeId and Outcome=@OutCome and SpecialBetValue=@SpecialBetValue and IsEvoluate=1)
--						begin
--						delete from Match.OddsResult where MatchId=@MatchId and OddsTypeId=@OddsTypeId and Outcome=@OutCome and SpecialBetValue=@SpecialBetValue
--						insert Match.OddsResult(MatchId,OddsTypeId,Outcome,SpecialBetValue,VoidFactor,OutcomeId,PlayerId,CompetitorId,[Status],Reason,BetradarOddTypeId)
--						values (@MatchId,@OddsTypeId,@OutCome,@SpecialBetValue,@VoidFactor,@OutComeId,@PlayerId,@TeamId,@Status,@Reason,@BetradarOddTypeId)
--						end
--					end
--			end
--			else
--				begin
--					if not exists (select  Match.OddsResult.OddsResultId from Match.OddsResult with (nolock) where MatchId=@MatchId and OddsTypeId=@OddsTypeId and Outcome=@OutCome )
--						begin
--						--insert dbo.Tempbooking values(@MatchId,@OddsTypeId)
--							insert Match.OddsResult(MatchId,OddsTypeId,Outcome,SpecialBetValue,VoidFactor,OutcomeId,PlayerId,CompetitorId,[Status],Reason,BetradarOddTypeId)
--							values (@MatchId,@OddsTypeId,@OutCome,@SpecialBetValue,@VoidFactor,@OutComeId,@PlayerId,@TeamId,@Status,@Reason,@BetradarOddTypeId)
--						end
--					else
--						begin
--						if not exists (select  Match.OddsResult.OddsResultId from Match.OddsResult with (nolock) where MatchId=@MatchId and OddsTypeId=@OddsTypeId and Outcome=@OutCome and IsEvoluate=1)
--							begin
--								delete from Match.OddsResult where MatchId=@MatchId and OddsTypeId=@OddsTypeId and Outcome=@OutCome and SpecialBetValue=@SpecialBetValue
--								insert Match.OddsResult(MatchId,OddsTypeId,Outcome,SpecialBetValue,VoidFactor,OutcomeId,PlayerId,CompetitorId,[Status],Reason,BetradarOddTypeId)
--								values (@MatchId,@OddsTypeId,@OutCome,@SpecialBetValue,@VoidFactor,@OutComeId,@PlayerId,@TeamId,@Status,@Reason,@BetradarOddTypeId)
--							end
--						end
--				end
--end
	
--	end

END


GO
