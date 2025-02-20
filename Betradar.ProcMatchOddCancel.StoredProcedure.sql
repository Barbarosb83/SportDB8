USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchOddCancel]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventOddCancel]    Script Date: 10/9/2020 7:37:38 AM ******/
CREATE PROCEDURE [Betradar].[ProcMatchOddCancel]
@BetradarMatchId bigint,
@BetradarOddTypeId bigint,
@BetradarOddSubTypeId bigint,
@SpecialBetValue nvarchar(50),
@BettradarOddId bigint,
@IsActive bit,
@Combination bigint,
@ForTheRest nchar(50),
@Comment nchar(30),
@MostBalanced bit,
@Changed bit,
@IsCanceled bit,
@BetradarTimeStamp datetime
AS

BEGIN

declare @oddId int
declare @PlayerId int=0
declare @TeamId int=0
declare @EventId bigint



--if(@BetradarOddTypeId in (48,49,202,232,553,206,233,332,234,453))
--	set @SpecialBetValue=''

----insert dbo.betslip values (@BetradarMatchId,'[ProcMatchOddCancel]-'+@ForTheRest+'-'+cast(@BetradarTimeStamp as nvarchar(30)),GETDATE())	
--declare @StartDate datetime
--declare @EndDate datetime
--if(@ForTheRest is not null or @ForTheRest='')
--	set @StartDate=cast(@ForTheRest as datetime)
--else
--	set @StartDate=DATEADD(Day,-20,GETDATE())

--if(@BetradarTimeStamp is not null)
--	set @EndDate =@BetradarTimeStamp
--else
--	set @EndDate=DATEADD(Day,1,GETDATE())

--declare @MatchId int
--select @MatchId=Match.Match.MatchId from Match.Match with (nolock) where Match.Match.[BetradarMatchId]=@BetradarMatchId

--declare @IsArchive int=0
--if(@MatchId is null)
--	begin
--	select @MatchId=Archive.Match.MatchId from Archive.Match with (nolock) where Archive.Match.[BetradarMatchId]=@BetradarMatchId
--	set @IsArchive=1
--	end

--if(@BetradarOddTypeId=383)
--	set @BetradarOddTypeId=56

--if(@BetradarOddTypeId=381)
--	set @BetradarOddTypeId=10

--	if(@BetradarOddTypeId=60)
--	set @BetradarOddTypeId=56

--	if(@SpecialBetValue is null)
--		set @SpecialBetValue=''

----insert dbo.betslip values (@MatchId,'[ProcMatchOddCancel]-'+ISNULL(cast(@BetradarOddTypeId as nvarchar(50)),'')+'-'+ISNULL(cast(@SpecialBetValue as nvarchar(50)),''),GETDATE())	
--if (@MatchId is not null)
--	begin
		
--		declare @eventoddid bigint  
--		declare @IsOddValueLock bit
		
				
----insert dbo.betslip values (@MatchId,'[ProcMatchOddCancel-----]-'+ISNULL(cast(@BetradarOddTypeId as nvarchar(50)),'')+'-'+ISNULL(cast(@SpecialBetValue as nvarchar(50)),''),GETDATE())
--			if(@IsActive=0)
--			begin
--				set nocount on
--					declare cur111 cursor local for(
--					SELECT  Match.Odd.OddId  from  Match.Odd with (nolock) 
--					WHERE  Match.Odd.BetradarOddTypeId=@BetradarOddTypeId and SpecialBetValue=@SpecialBetValue and Match.Odd.MatchId=@MatchId

--						)

--					open cur111
--					fetch next from cur111 into @eventoddid
--					while @@fetch_status=0
--						begin
--							begin
--								INSERT INTO [Customer].[SlipOddCancel]
--										   ([SlipOddCancelId]
--										   ,[SlipId]
--										   ,[OddId]
--										   ,[OddValue]
--										   ,[Amount]
--										   ,[StateId]
--										   ,[BetTypeId]
--										   ,[OutCome]
--										   ,[MatchId]
--										   ,[OddsTypeId]
--										   ,[SpecialBetValue]
--										   ,[ParameterOddId]
--										   ,[EventName]
--										   ,[EventDate]
--										   ,[CurrencyId]
--										   ,[Score]
--										   ,[ScoreTimeStatu]
--										   ,[SportId]
--										   ,[Banko]
--										   ,[BetradarMatchId],OddProbValue)
--										select * from Customer.SlipOdd with (nolock)  where OddId=@eventoddid and MatchId=@MatchId and BetTypeId=0
--										and SlipId in (Select SlipId from Customer.Slip with (nolock) where CreateDate>=@StartDate and CreateDate<=@EndDate)

--							----update Customer.SlipOdd set OddValue=1,StateId=2 where OddId=@eventoddid and MatchId=@MatchId and BetTypeId=0 and SlipId in (Select SlipId from Customer.Slip with (nolock) where CreateDate>=@StartDate and CreateDate<=@EndDate)
--							----	exec RiskManagement.ProcSlipOddsEvaluateRollBack  @eventoddid,0

--							--exec [RiskManagement].[ProcManuelOddsEvaluate]   @eventoddid,4,'administrator','1',0

							
--							end
--							fetch next from cur111 into @eventoddid
			
--						end
--					close cur111
--					deallocate cur111	
--			end
--			else
--				begin
--						set nocount on
--					declare cur111 cursor local for(
--					SELECT  Archive.Odd.OddId  from  Archive.Odd with (nolock) 
--					WHERE  Archive.Odd.BetradarOddTypeId=@BetradarOddTypeId and SpecialBetValue=@SpecialBetValue and Archive.Odd.MatchId=@MatchId

--						)

--					open cur111
--					fetch next from cur111 into @eventoddid
--					while @@fetch_status=0
--						begin
--							begin
--								INSERT INTO [Customer].[SlipOddCancel]
--										   ([SlipOddCancelId]
--										   ,[SlipId]
--										   ,[OddId]
--										   ,[OddValue]
--										   ,[Amount]
--										   ,[StateId]
--										   ,[BetTypeId]
--										   ,[OutCome]
--										   ,[MatchId]
--										   ,[OddsTypeId]
--										   ,[SpecialBetValue]
--										   ,[ParameterOddId]
--										   ,[EventName]
--										   ,[EventDate]
--										   ,[CurrencyId]
--										   ,[Score]
--										   ,[ScoreTimeStatu]
--										   ,[SportId]
--										   ,[Banko]
--										   ,[BetradarMatchId],OddProbValue)
--										select * from Customer.SlipOdd with (nolock)  where OddId=@eventoddid and MatchId=@MatchId and BetTypeId=0
--										and SlipId in (Select SlipId from Customer.Slip with (nolock) where CreateDate>=@StartDate and CreateDate<=@EndDate)

--							--update Customer.SlipOdd set OddValue=1,StateId=2 where OddId=@eventoddid and MatchId=@MatchId and BetTypeId=0 and SlipId in (Select SlipId from Customer.Slip with (nolock) where CreateDate>=@StartDate and CreateDate<=@EndDate)
--							--	exec RiskManagement.ProcSlipOddsEvaluateRollBack  @eventoddid,0
--							exec [RiskManagement].[ProcManuelOddsEvaluate]   @eventoddid,4,'administrator','1',0
							
--							end
--							fetch next from cur111 into @eventoddid
			
--						end
--					close cur111
--					deallocate cur111	
--				end
		
--		end
				
--				if not exists (Select [Match].[OddsResult].OddsResultId from [Match].[OddsResult]   with (nolock)  where MatchId=@MatchId and OddsTypeId=@BetradarOddTypeId and SpecialBetValue=@SpecialBetValue and IsEvoluate=1)
--				begin
--						INSERT INTO [Match].[OddsResult]
--				   ([MatchId]
--				   ,[OddsTypeId]
--				   ,[Outcome]
--				   ,[SpecialBetValue]
--				   ,[VoidFactor]
--				   ,[Status]
--				   ,[Reason]
--				   ,[BetradarOddTypeId]
--				   ,[IsEvoluate])
--				   values (@MatchId,@BetradarOddTypeId,'',@SpecialBetValue,'',0,@Comment,@BetradarOddTypeId,1)
--				   end



				select 0
END


GO
