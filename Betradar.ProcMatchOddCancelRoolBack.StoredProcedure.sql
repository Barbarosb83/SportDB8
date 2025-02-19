USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchOddCancelRoolBack]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventOddCancel]    Script Date: 10/9/2020 7:37:38 AM ******/
CREATE PROCEDURE [Betradar].[ProcMatchOddCancelRoolBack]
@BetradarMatchId bigint,
@BetradarOddTypeId bigint,
@BetradarOddSubTypeId bigint,
@SpecialBetValue nvarchar(50),
@BettradarOddId bigint,
@IsActive bit,
@Combination bigint,
@ForTheRest nchar(30),
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
declare @OddTypeId int

declare @StartDate datetime
declare @EndDate datetime

--set @StartDate=cast(@ForTheRest as datetime)
--set @EndDate =@BetradarTimeStamp

declare @MatchId int
select @MatchId=Match.Match.MatchId from Match.Match with (nolock) where Match.Match.[BetradarMatchId]=@BetradarMatchId


if(@BetradarOddTypeId in (48,49,202,232,553,206,233,332,234,453))
	set @SpecialBetValue=''


if(@BetradarOddTypeId=383)
	set @BetradarOddTypeId=56

if(@BetradarOddTypeId=60)
	set @BetradarOddTypeId=56

		if(@SpecialBetValue is null)
		set @SpecialBetValue=''

--insert dbo.betslip values (@EventId,'[ProcMatchOddCancelRoolback]',GETDATE())	
--if (@MatchId is not null)
--	begin
		
--		declare @eventoddid bigint  
--		declare @IsOddValueLock bit
		
				
--				set nocount on
--					declare cur111 cursor local for(
--					SELECT  Match.Odd.OddId,Match.Odd.OddsTypeId  from  Match.Odd with (nolock) WHERE  Match.Odd.BetradarOddTypeId=@BetradarOddTypeId and SpecialBetValue=@SpecialBetValue and Match.Odd.MatchId=@MatchId

--						)

--					open cur111
--					fetch next from cur111 into @eventoddid,@OddTypeId
--					while @@fetch_status=0
--						begin
--							begin

--											update Customer.SlipOdd 
--											set SlipOdd.StateId=OddCancel.StateId,SlipOdd.OddValue=OddCancel.[OddValue]
--											FROM [Customer].[SlipOddCancel]   AS OddCancel with (nolock)
--											INNER JOIN Customer.SlipOdd AS SlipOdd    with (nolock)  
--											on SlipOdd.SlipOddId=OddCancel.SlipOddCancelId and OddCancel.[OddId]=@eventoddid

								
--								delete from Customer.SlipOddCancel where SlipOddCancelId in (select Customer.SlipOdd.SlipOddId from Customer.SlipOdd with (nolock)  where OddId=@eventoddid and MatchId=@MatchId and BetTypeId=0)

							
--								exec [RiskManagement].ProcSlipOddsEvaluateCancelRoolback   @MatchId,@OddTypeId,0
							
--							end
--							fetch next from cur111 into @eventoddid,@OddTypeId
			
--						end
--					close cur111
--					deallocate cur111	
		
--				end
				
 




				select 0
END


GO
