USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventOddProb_NEW]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Live.ProcEventOddProb_NEW]
@BetradarMatchId bigint,
@BetradarOddTypeId bigint,
@BetradarOddSubTypeId bigint,
@OutCome nvarchar(100),
@OutComeId int,
@ProbValue float,
@SpecialBetValue nvarchar(100),
@BettradarOddId bigint,
@MarketStatus int,
@CashOutStatus int,
@BetradarTimeStamp datetime,
@OutcomeActive bit

AS

BEGIN 

declare @OddsTypeId int 
declare @parameterOddId int
declare @LiveEventId bigint 
declare @BetradarOddSubTypeId2 bigint=@BetradarOddSubTypeId

  
 
		
	 		if (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=32) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=28) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=18)  or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=144) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=145) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=1537) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=140) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=24) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=1032) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=423) 
					set @SpecialBetValue=null
					
	if(@OutCome<>'' and @OutCome is not null)
		begin
		if @BetradarOddTypeId=7 and @BetradarOddSubTypeId=21
				begin
				if @OutCome='1'
					set @OutCome='u'
				else if @OutCome='2'
					set @OutCome='o'
				end

		if @BetradarOddTypeId=7 and @BetradarOddSubTypeId=7 -- Total UzATMALAR
				begin
				if @OutCome='1'
					set @OutCome='u'
				else if @OutCome='2'
					set @OutCome='o'
				end
						
		
			if(@SpecialBetValue is not null)
							begin

								UPDATE [Live].[EventOddProb]  
								SET 
								  [Live].[EventOddProb].[ProbilityValue] =@ProbValue
								  ,[Live].[EventOddProb].[CashoutStatus] = @CashOutStatus
								  ,[Live].[EventOddProb].[MarketStatus] = @MarketStatus
								  ,[Live].[EventOddProb].BetradarTimeStamp=@BetradarTimeStamp
								  ,OutcomeActive=@OutcomeActive
								   where   Live.[EventOddProb].BetradarMatchId=@BetradarMatchId 
									and Live.[EventOddProb].OutCome=@OutCome and Live.[EventOddProb].SpecialBetValue=@SpecialBetValue 
									and Live.[EventOddProb].BetradarOddsTypeId=@BetradarOddTypeId
									and Live.[EventOddProb].BetradarOddsSubTypeId=@BetradarOddSubTypeId
 
							END
						ELSE
							begin
							UPDATE [Live].[EventOddProb]  
						   SET 
							  [Live].[EventOddProb].[ProbilityValue] =@ProbValue
							  ,[Live].[EventOddProb].[CashoutStatus] = @CashOutStatus
							  ,[Live].[EventOddProb].[MarketStatus] = @MarketStatus
							  ,[Live].[EventOddProb].BetradarTimeStamp=@BetradarTimeStamp
							  ,OutcomeActive=@OutcomeActive
							   where  Live.[EventOddProb].BetradarMatchId=@BetradarMatchId 
								and Live.[EventOddProb].OutCome=@OutCome 
								and Live.[EventOddProb].BetradarOddsTypeId=@BetradarOddTypeId
								and Live.[EventOddProb].BetradarOddsSubTypeId=@BetradarOddSubTypeId
								 
							END
								if (@BetradarOddSubTypeId is null)
									set @BetradarOddSubTypeId2=-1
			 
	 
		if(@@ROWCOUNT=0)
			begin
			
				if exists (Select [Live].[Event].EventId from [Live].[Event] with (nolock) where [Live].[Event].[BetradarMatchId]=@BetradarMatchId)
					begin
					select @LiveEventId=[Live].[Event].EventId from [Live].[Event] with (nolock)
					where [Live].[Event].[BetradarMatchId]=@BetradarMatchId
				 
					    if (@BetradarOddSubTypeId is not null)
					 begin
							select @parameterOddId=Live.[Parameter.Odds].OddsId 
							,@OddsTypeId=Live.[Parameter.OddType].OddTypeId
							from live.[Parameter.Odds] with (nolock) 
							INNER JOIN Live.[Parameter.OddType] On Live.[Parameter.OddType].OddTypeId=Live.[Parameter.Odds].OddTypeId
							where [Live].[Parameter.OddType].[BetradarOddsTypeId]=@BetradarOddTypeId
				 					and [Live].[Parameter.OddType].[BetradarOddsSubTypeId]=@BetradarOddSubTypeId and live.[Parameter.Odds].Outcomes=@OutCome
					 	end
					else
						begin
							select @parameterOddId=Live.[Parameter.Odds].OddsId 
							,@OddsTypeId=Live.[Parameter.OddType].OddTypeId
							from live.[Parameter.Odds] with (nolock) 
							INNER JOIN Live.[Parameter.OddType] On Live.[Parameter.OddType].OddTypeId=Live.[Parameter.Odds].OddTypeId
							where [Live].[Parameter.OddType].[BetradarOddsTypeId]=@BetradarOddTypeId
									and live.[Parameter.Odds].Outcomes=@OutCome
						end

					if(@parameterOddId is null)
						begin
						 if (@BetradarOddSubTypeId is not null)
							 begin
									select @parameterOddId=Live.[Parameter.Odds].OddsId 
									,@OddsTypeId=Live.[Parameter.OddType].OddTypeId
									from live.[Parameter.Odds] with (nolock) 
									INNER JOIN Live.[Parameter.OddType] On Live.[Parameter.OddType].OddTypeId=Live.[Parameter.Odds].OddTypeId
									where [Live].[Parameter.OddType].[BetradarOddsTypeId]=@BetradarOddTypeId
				 							and [Live].[Parameter.OddType].[BetradarOddsSubTypeId]=@BetradarOddSubTypeId 
											--and live.[Parameter.Odds].Outcomes=@OutCome
					 		 end
					else
						begin
							select @parameterOddId=Live.[Parameter.Odds].OddsId 
							,@OddsTypeId=Live.[Parameter.OddType].OddTypeId
							from live.[Parameter.Odds] with (nolock) 
							INNER JOIN Live.[Parameter.OddType] On Live.[Parameter.OddType].OddTypeId=Live.[Parameter.Odds].OddTypeId
							where [Live].[Parameter.OddType].[BetradarOddsTypeId]=@BetradarOddTypeId
						end
							end
							 	
					if(@parameterOddId is not null)
						begin
								INSERT INTO [Live].[EventOddProb]
								   ([OddsTypeId]
								   ,[OutCome]
								   ,[SpecialBetValue]
								   ,[ProbilityValue]
								   ,[MatchId]
								   ,[BettradarOddId]
								   ,[ParameterOddId]
								   ,[MarketStatus]
								   ,[CashoutStatus]
								   ,[BetradarTimeStamp]
								   ,[UpdatedDate]
								   ,[BetradarMatchId]
								   ,[BetradarOddsTypeId]
								   ,[BetradarOddsSubTypeId],OutcomeActive)
							 VALUES
														   (@OddsTypeId,@OutCome
														   ,@SpecialBetValue
														   ,@ProbValue
														   ,@LiveEventId
														   ,@BettradarOddId
														   ,@parameterOddId
														   ,@MarketStatus
														   ,@CashOutStatus
														   ,@BetradarTimeStamp
														   ,GETDATE()
														   ,@BetradarMatchId
														   ,@BetradarOddTypeId
														   ,@BetradarOddSubTypeId2,@OutcomeActive)
							end
						end			
						 
			end
		end
	else
		begin
			if(@SpecialBetValue is not null)
				begin
				UPDATE [Live].[EventOddProb]  
						   SET 
							  [Live].[EventOddProb].[ProbilityValue] =@ProbValue
							  ,[Live].[EventOddProb].[CashoutStatus] = @CashOutStatus
							  ,[Live].[EventOddProb].[MarketStatus] = @MarketStatus
							  ,[Live].[EventOddProb].BetradarTimeStamp=@BetradarTimeStamp
							  ,OutcomeActive=@OutcomeActive
							   where Live.[EventOddProb].BetradarMatchId=@BetradarMatchId 
							 and  Live.[EventOddProb].SpecialBetValue=@SpecialBetValue 
								and Live.[EventOddProb].BetradarOddsTypeId=@BetradarOddTypeId
								and Live.[EventOddProb].BetradarOddsSubTypeId=@BetradarOddSubTypeId
				end
			else
				begin
					UPDATE [Live].[EventOddProb]  
						   SET 
							  [Live].[EventOddProb].[ProbilityValue] =@ProbValue
							  ,[Live].[EventOddProb].[CashoutStatus] = @CashOutStatus
							,[Live].[EventOddProb].[MarketStatus] = @MarketStatus
							  ,[Live].[EventOddProb].BetradarTimeStamp=@BetradarTimeStamp
							  ,OutcomeActive=@OutcomeActive
							   where Live.[EventOddProb].BetradarMatchId=@BetradarMatchId   
								and Live.[EventOddProb].BetradarOddsTypeId=@BetradarOddTypeId
								and Live.[EventOddProb].BetradarOddsSubTypeId=@BetradarOddSubTypeId

				end
		end
			
			


END
GO
