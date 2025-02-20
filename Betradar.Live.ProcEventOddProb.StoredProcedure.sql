USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventOddProb]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Live.ProcEventOddProb]
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


	insert dbo.betslip values (@BetradarMatchId,cast(@BettradarOddId as nvarchar(50))+'-'+cast(ISNULL(@BetradarOddTypeId,0) as nvarchar(10))+'-'+cast(ISNULL(@BetradarTimeStamp,'') as nvarchar(20))+'-'+cast(ISNULL(@BetradarOddSubTypeId,0) as nvarchar(10))+'-'+@OutCome+'-'+ISNULL(@SpecialBetValue,'')+'-OUTID:'+CAST(ISNULL(@OutComeId,0)as nvarchar(50)),GETDATE())


declare @BetradarOddSubTypeId2 bigint=@BetradarOddSubTypeId

	if (@BetradarOddSubTypeId is null)
		 set @BetradarOddSubTypeId2=-1
 
 
	if exists(Select Live.[Parameter.OddType].OddTypeId from Live.[Parameter.OddType] with (nolock) where BetradarOddsTypeId=@BetradarOddTypeId and BetradarOddsSubTypeId=@BetradarOddSubTypeId2 and IsActive=1)	
		begin

declare @OddsTypeId int
declare @oddId int
declare @PlayerId int=0
declare @TeamId int=0
declare @EventId bigint
declare @parameterOddId int
declare @LiveEventId bigint
declare @IsChange int 

		
		declare @OddFactor float
		declare @eventoddid bigint 
		declare @IsOddValueLock bit
		declare @OldOddValue float
		declare @ChangeValue int=0
		declare @newoldvalue float
		set @newoldvalue=@ProbValue
		
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
							  --,@OddsTypeId=Live.EventOdd.OddsTypeId
							  ,[Live].[EventOddProb].[MarketStatus] = @MarketStatus
							  ,[Live].[EventOddProb].BetradarTimeStamp=@BetradarTimeStamp
							  ,OutcomeActive=@OutcomeActive
							  ,@eventoddid=Live.[EventOddProb].OddId 
							   where   Live.[EventOddProb].BetradarMatchId=@BetradarMatchId 
								and Live.[EventOddProb].OutCome=@OutCome and Live.[EventOddProb].SpecialBetValue=@SpecialBetValue 
								and Live.[EventOddProb].BetradarOddsTypeId=@BetradarOddTypeId
								and Live.[EventOddProb].BetradarOddsSubTypeId=@BetradarOddSubTypeId

								--select  @eventoddid=Live.[EventOddProb].OddId 
								--from Live.[EventOddProb] with (nolock) 
								--	where   Live.[EventOddProb].BetradarMatchId=@BetradarMatchId 
								--and Live.[EventOddProb].OutCome=@OutCome and Live.[EventOddProb].SpecialBetValue=@SpecialBetValue 
								--and Live.[EventOddProb].BetradarOddsTypeId=@BetradarOddTypeId
								--and Live.[EventOddProb].BetradarOddsSubTypeId=@BetradarOddSubTypeId
							
							
							END
						ELSE
							begin
							UPDATE [Live].[EventOddProb]  
						   SET 
							  [Live].[EventOddProb].[ProbilityValue] =@ProbValue
							  ,[Live].[EventOddProb].[CashoutStatus] = @CashOutStatus
							  --,@OddsTypeId=Live.EventOdd.OddsTypeId
							  ,[Live].[EventOddProb].[MarketStatus] = @MarketStatus
							  ,[Live].[EventOddProb].BetradarTimeStamp=@BetradarTimeStamp
							  ,OutcomeActive=@OutcomeActive
							  ,@eventoddid=Live.[EventOddProb].OddId 
							   where  Live.[EventOddProb].BetradarMatchId=@BetradarMatchId 
								and Live.[EventOddProb].OutCome=@OutCome --and Live.[EventOddProb].SpecialBetValue=@SpecialBetValue 
								and Live.[EventOddProb].BetradarOddsTypeId=@BetradarOddTypeId
								and Live.[EventOddProb].BetradarOddsSubTypeId=@BetradarOddSubTypeId

								--select  @eventoddid=Live.[EventOddProb].OddId
								-- from Live.[EventOddProb]  with (nolock)
								--	where   Live.[EventOddProb].BetradarMatchId=@BetradarMatchId 
								--and Live.[EventOddProb].OutCome=@OutCome --and Live.[EventOddProb].SpecialBetValue=@SpecialBetValue 
								--and Live.[EventOddProb].BetradarOddsTypeId=@BetradarOddTypeId
								--and Live.[EventOddProb].BetradarOddsSubTypeId=@BetradarOddSubTypeId
							END
							
			 
	 
	if(@eventoddid is null)
			begin
			
				
					select @LiveEventId=[Live].[Event].EventId from [Live].[Event] with (nolock)
					where [Live].[Event].[BetradarMatchId]=@BetradarMatchId
					
						   if (@BetradarOddSubTypeId is not null)
						begin
							select  @OddsTypeId=OddTypeId from [Live].[Parameter.OddType] with (nolock)
										where [Live].[Parameter.OddType].[BetradarOddsTypeId]=@BetradarOddTypeId
										and [Live].[Parameter.OddType].[BetradarOddsSubTypeId]=@BetradarOddSubTypeId
						end
					else
						begin
							select @OddsTypeId=OddTypeId from [Live].[Parameter.OddType]  with (nolock)
										where [Live].[Parameter.OddType].[BetradarOddsTypeId]=@BetradarOddTypeId
						end

					select @parameterOddId=Live.[Parameter.Odds].OddsId from live.[Parameter.Odds] with (nolock) where Live.[Parameter.Odds].OddTypeId=@OddsTypeId and live.[Parameter.Odds].Outcomes=@OutCome

					if(@parameterOddId is null)
						select top 1 @parameterOddId=Live.[Parameter.Odds].OddsId from live.[Parameter.Odds] with (nolock) where Live.[Parameter.Odds].OddTypeId=@OddsTypeId 
					
							if(@LiveEventId is not null and @OddsTypeId is not null)
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
									
								set @eventoddid=SCOPE_IDENTITY()
				
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
							  --,@OddsTypeId=Live.EventOdd.OddsTypeId
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
							  --,@OddsTypeId=Live.EventOdd.OddsTypeId
							  ,[Live].[EventOddProb].[MarketStatus] = @MarketStatus
							  ,[Live].[EventOddProb].BetradarTimeStamp=@BetradarTimeStamp
							  ,OutcomeActive=@OutcomeActive
							   where Live.[EventOddProb].BetradarMatchId=@BetradarMatchId   
								and Live.[EventOddProb].BetradarOddsTypeId=@BetradarOddTypeId
								and Live.[EventOddProb].BetradarOddsSubTypeId=@BetradarOddSubTypeId

				end
		end
			
			
end

END
GO
