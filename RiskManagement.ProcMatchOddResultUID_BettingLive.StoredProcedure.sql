USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcMatchOddResultUID_BettingLive]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcMatchOddResultUID_BettingLive]
@OddId int,
@OddValue float,
@StateId int,
@Limit money,
@LimitPerTicket money,
@StakeLimit money,
@Availabity nvarchar(20),
@MinCombiBranch int,
@MinCombiInternet int,
@MinCombiMachine int,
@IsOddValueLock bit,
@LangId int,
@username nvarchar(max),
@ActivityCode int,
@NewValues nvarchar(max),
@BetType int


AS

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @AvailabityId int=0
declare @oddSettingId int


BEGIN
SET NOCOUNT ON;

select @AvailabityId=Parameter.MatchAvailability.AvailabilityId from Parameter.MatchAvailability with (nolock)
where Parameter.MatchAvailability.Availability=@Availabity



select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId

declare @FixtureId int



if(@ActivityCode=1)
	begin

	if(@BetType=0)
		begin

				--exec [Log].ProcConcatOldValues  'Odd','[Archive]','OddId',@oddId,@OldValues output
	
				--exec [Log].[ProcTransactionLogUID] 4,@ActivityCode,@Username,@oddId,'Archive.OddId'
				--,@NewValues,@OldValues
				if exists(select Archive.Odd.OddId from Archive.Odd with (nolock) where Archive.Odd.OddId=@OddId)
					update Archive.Odd set StateId=@StateId	where OddId=@OddId
				else if exists(select Match.Odd.OddId from Match.Odd with (nolock) where Match.Odd.OddId=@OddId)
					update Match.Odd set StateId=@StateId	where OddId=@OddId

		end
	else 
	if (@BetType=1)
		begin
			if exists (select [BettingLive].Live.EventOddResult.OddId from [BettingLive].Live.EventOddResult with (nolock) where OddId=@OddId)
				update [BettingLive].Live.EventOddResult set StateId=@StateId where OddId=@OddId
			else if exists (select [BettingLive].Archive.[Live.EventOddResult].OddId from [BettingLive].Archive.[Live.EventOddResult] with (nolock) where OddId=@OddId)
				update [BettingLive].Archive.[Live.EventOddResult] set StateId=@StateId where OddId=@OddId
			else
				begin
					if exists (select Live.EventOdd.OddId from Live.EventOdd with (nolock) where OddId=@OddId)
						begin
							 
							INSERT INTO [BettingLive].[Live].[EventOddResult]
								   ([BetradarOddId]
								   ,[OddsTypeId]
								   ,[OutCome]
								   ,[SpecialBetValue]
								   ,[OddResult]
								   ,[VoidFactor]
								   ,[IsCanceled]
								   ,[IsEvaluated]
								   ,[OddFactor]
								   ,[EvaluatedDate]
								   ,[BetradarOddsTypeId]
								   ,[BetradarOddsSubTypeId]
								   ,[StateId]
								   ,[BetradarMatchId]
								   ,[OddId])
							 select BettradarOddId,OddsTypeId,OutCome,SpecialBetValue,ISNULL(OddResult,1),VoidFactor,IsCanceled,1,OddFactor,GETDATE(),BetradarOddsTypeId,BetradarOddsSubTypeId,@StateId,BetradarMatchId,
							 OddId from Live.EventOdd  with (nolock) where OddId=@OddId
						end
					else if exists (select Archive.[Live.EventOdd].OddId from Archive.[Live.EventOdd] with (nolock) where OddId=@OddId)
						begin
							 
							INSERT INTO [BettingLive].Archive.[Live.EventOddResult]
								   ([OddresultId],[BetradarOddId]
								   ,[OddsTypeId]
								   ,[OutCome]
								   ,[SpecialBetValue]
								   ,[OddResult]
								   ,[VoidFactor]
								   ,[IsCanceled]
								   ,[IsEvaluated]
								   ,[OddFactor]
								   ,[EvaluatedDate]
								   ,[BetradarOddsTypeId]
								   ,[BetradarOddsSubTypeId]
								   ,[StateId]
								   ,[BetradarMatchId]
								   ,[OddId])
							 select (select MAX([BettingLive].Archive.[Live.EventOddResult].OddresultId)+1 from [BettingLive].Archive.[Live.EventOddResult]), BettradarOddId,OddsTypeId,OutCome,SpecialBetValue,ISNULL(OddResult,1),VoidFactor,IsCanceled,1,OddFactor,GETDATE(),BetradarOddsTypeId,BetradarOddsSubTypeId,@StateId,BetradarMatchId,
							 OddId from Archive.[Live.EventOdd]  with (nolock) where OddId=@OddId
						end

				end


		end

			exec [RiskManagement].[ProcManuelOddsEvaluate] @OddId,@StateId,@username,@OddValue,@BetType

			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId

	end



	select @resultcode as resultcode,@resultmessage as resultmessage




END


GO
