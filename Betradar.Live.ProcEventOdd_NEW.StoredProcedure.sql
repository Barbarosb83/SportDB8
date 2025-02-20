USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventOdd_NEW]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [Betradar].[Live.ProcEventOdd_NEW]
@BetradarMatchId bigint,
@BetradarOddTypeId bigint,
@BetradarOddSubTypeId bigint,
@OutCome nvarchar(100),
@OutComeId int,
@BetRadarPlayerId bigint,
@BetradarTeamId bigint,
@OddValue float,
@SpecialBetValue nvarchar(100),
@BettradarOddId bigint,
@IsActive bit,
@Combination bigint,
@ForTheRest nchar(30),
@Comment nchar(30),
@MostBalanced bit,
@Changed bit,
@BetradarTimeStamp datetime

AS

BEGIN 


-----------TİMESATAMP liveeventoddıd yi getirmiyor.

declare @OddsTypeId int
declare @oddId int
declare @PlayerId int=0
declare @TeamId int=0
declare @EventId bigint
declare @parameterOddId int
declare @LiveEventId bigint
declare @IsChange int 
declare @BetradarOddSubTypeId2 bigint=@BetradarOddSubTypeId

		declare @OddFactor float
		declare @eventoddid bigint 
		declare @IsOddValueLock bit
		declare @OldOddValue float
		declare @ChangeValue int=0
		declare @newoldvalue float
		set @newoldvalue=@OddValue
		
		--if (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=28)
		--	insert dbo.betslip values (@BetradarMatchId,cast(@BetradarOddTypeId as nvarchar(10))+'-'+cast(@BetradarOddSubTypeId as nvarchar(10))+'-'+ISNULL(cast(@OutComeId as nvarchar(50)),'')+'-'+ISNULL(@OutCome,'')+'-'+ISNULL(@SpecialBetValue,'')+'-'+CAST(@IsActive as nvarchar(50)),GETDATE())

	 	if (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=32) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=28) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=25) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=18)  or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=144) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=145) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=1537) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=140) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=24) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=1032) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=423) 
					set @SpecialBetValue=null
					--if(@BetradarMatchId= 23707659)
					--insert dbo.betslip values (@BetradarMatchId,cast(@BetradarOddTypeId as nvarchar(10))+'-'+cast(@BetradarOddSubTypeId as nvarchar(10))+'-'+@OutCome+'-'+@SpecialBetValue+'-'+CAST(@IsActive as nvarchar(50)),GETDATE())

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
								select  @eventoddid=Live.EventOdd.OddId ,@OddsTypeId=Live.EventOdd.OddsTypeId
								from Live.EventOdd with (nolock) 
									where  Live.EventOdd.BettradarOddId=@BettradarOddId
								and Live.EventOdd.BetradarMatchId=@BetradarMatchId 
								and Live.EventOdd.OutCome=@OutCome and Live.EventOdd.SpecialBetValue=@SpecialBetValue
							
							
							END
						ELSE
							begin
								select  @eventoddid=Live.EventOdd.OddId ,@OddsTypeId=Live.EventOdd.OddsTypeId
								 from Live.EventOdd  with (nolock)
								where   Live.EventOdd.BettradarOddId=@BettradarOddId
								and Live.EventOdd.BetradarMatchId=@BetradarMatchId  
								and Live.EventOdd.OutCome=@OutCome 
							END
		
				if (@BetradarOddSubTypeId is null)
			set @BetradarOddSubTypeId2=-1
			 
			
	If (@eventoddid is not null)
	begin
	 

						UPDATE [Live].[EventOdd]  
						   SET 
							  [Live].[EventOdd].[OddValue] =@OddValue
							  ,[Live].[EventOdd].[Suggestion] = @OddValue
							  ,[Live].[EventOdd].[IsActive] = @IsActive
							  ,[Live].[EventOdd].BetradarTimeStamp=@BetradarTimeStamp
							  ,[Live].[EventOdd].UpdatedDate=GETDATE()
							   where Live.EventOdd.OddId=@eventoddid
							   and [Live].[EventOdd].BetradarTimeStamp<@BetradarTimeStamp

				 exec [Betradar].[Live.ProcEventTopOdd] @BetradarMatchId, @OutCome,@SpecialBetValue,@OddValue,@eventoddid,@IsActive,@IsChange,@OddsTypeId
			
		
	end
	else
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
					
									INSERT INTO [Live].[EventOdd]
								   ([OddsTypeId],[OutCome]
								   ,[SpecialBetValue]
								   ,[OddValue]
								   ,[MatchId]
								   ,[BettradarOddId]
								   ,[Suggestion]
								   ,[ParameterOddId]
								   ,[IsOddValueLock]
								   ,[IsChanged]
								   ,[IsActive]
								   ,BetradarTimeStamp
								   ,BetradarMatchId,BetradarOddsTypeId,BetradarOddsSubTypeId,StateId)
							 VALUES
								   (@OddsTypeId,@OutCome
								   ,@SpecialBetValue
								   ,@OddValue
								   ,@LiveEventId
								   ,@BettradarOddId
								   ,@OddValue
								   ,@parameterOddId
								   ,0
								   ,0
								   ,@IsActive
								   ,@BetradarTimeStamp
								   ,@BetradarMatchId
								   ,@BetradarOddTypeId
								   ,@BetradarOddSubTypeId2,2)
									
								set @eventoddid=SCOPE_IDENTITY()
								execute [Betradar].[Live.ProcOddSettingInsert] @OddsTypeId,@eventoddid,@LiveEventId,@BetradarMatchId
								exec [Betradar].[Live.ProcEventTopOdd] @BetradarMatchId, @OutCome, @SpecialBetValue,@OddValue,@eventoddid,@IsActive,@IsChange,@OddsTypeId
						end
			end

END
GO
