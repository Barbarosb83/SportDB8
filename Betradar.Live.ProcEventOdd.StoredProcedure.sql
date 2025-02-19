USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventOdd]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE[Betradar].[Live.ProcEventOdd]
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
declare @IsChange int 


		declare @OddFactor float
		declare @eventoddid bigint 
		declare @IsOddValueLock bit
		declare @OldOddValue float
		declare @ChangeValue int=0
		declare @newoldvalue float
		set @newoldvalue=@OddValue
		
	 
	 	if (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=32) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=28) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=25) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=18)  or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=144) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=145) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=1537) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=140) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=24) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=1032) or (@BetradarOddTypeId=8 and @BetradarOddSubTypeId=423) 
					set @SpecialBetValue=null
					 
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
			
								select  @eventoddid=Live.EventOdd.OddId 
								from Live.EventOdd with (nolock) 
									where  Live.EventOdd.BettradarOddId=@BettradarOddId
								and Live.EventOdd.BetradarMatchId=@BetradarMatchId 
								and Live.EventOdd.OutCome=@OutCome and Live.EventOdd.SpecialBetValue=ISNULL(@SpecialBetValue,'')
				
			
	If (@eventoddid is not null)
	begin
	 
						if (@BetradarMatchId<0)
						begin
						UPDATE [Live].[EventOdd]  
						   SET 
							  [Live].[EventOdd].[OddValue] =@OddValue
							--  ,[Live].[EventOdd].[Suggestion] = @OddValue
							  ,@OddsTypeId=Live.EventOdd.OddsTypeId
							  ,[Live].[EventOdd].[IsActive] = case when @OddValue<=1.01 then 0 else  @IsActive end
							  ,[Live].[EventOdd].BetradarTimeStamp=@BetradarTimeStamp
							  ,[Live].[EventOdd].UpdatedDate=GETDATE()
							    ,BetradarPlayerId=@BetradarTeamId
								 ,OddFactor=@ForTheRest
								 ,GenuisId=@BetRadarPlayerId
								  
							   where Live.EventOdd.OddId=@eventoddid
							and [Live].[EventOdd].BetradarTimeStamp<@BetradarTimeStamp
						end
						else
							begin
								UPDATE [Live].[EventOdd]  
						   SET 
							  [Live].[EventOdd].[OddValue] =@OddValue
							 -- ,[Live].[EventOdd].[Suggestion] = @OddValue
							  ,@OddsTypeId=Live.EventOdd.OddsTypeId
							  ,[Live].[EventOdd].[IsActive] = case when @OddValue<=1.01 then 0 else  @IsActive end
							  ,[Live].[EventOdd].BetradarTimeStamp=@BetradarTimeStamp
							  ,[Live].[EventOdd].UpdatedDate=GETDATE()
							    ,BetradarPlayerId=@BetradarTeamId
								 ,OddFactor=@ForTheRest
								 
							   where Live.EventOdd.OddId=@eventoddid
and [Live].[EventOdd].BetradarTimeStamp<@BetradarTimeStamp

							end

	end
	else
			begin
					if (@BetradarOddSubTypeId is null)
						set @BetradarOddSubTypeId2=-1
					
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
					
							if(@BetradarMatchId is not null and @OddsTypeId is not null)
							begin		
									if (@BetradarMatchId>0)
									begin
											INSERT INTO [Live].[EventOdd]
										   (OddId, [OddsTypeId],[OutCome]
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
										   ,BetradarMatchId,BetradarOddsTypeId,BetradarOddsSubTypeId,StateId,BetradarPlayerId,OddFactor  )
									 VALUES
										   (@BettradarOddId,@OddsTypeId,@OutCome
										   ,ISNULL(@SpecialBetValue,'')
										   ,@OddValue
										   ,@BetradarMatchId
										   ,@BettradarOddId
										   ,@OddValue
										   ,@parameterOddId
										   ,0
										   ,0
										   ,   case when @OddValue<=1.01 then 0 else  @IsActive end
										   ,@BetradarTimeStamp
										   ,@BetradarMatchId
										   ,@BetradarOddTypeId
										   ,@BetradarOddSubTypeId2,2,@BetradarTeamId,@ForTheRest)
									end
									else
										begin
											INSERT INTO [Live].[EventOdd]
											   (OddId, [OddsTypeId],[OutCome]
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
											   ,BetradarMatchId,BetradarOddsTypeId,BetradarOddsSubTypeId,StateId,BetradarPlayerId,OddFactor,GenuisId)
										 VALUES
											   (@BettradarOddId,@OddsTypeId,@OutCome
											   ,ISNULL(@SpecialBetValue,'')
											   ,@OddValue
											   ,@BetradarMatchId
											   ,@BettradarOddId
											   ,@OddValue
											   ,@parameterOddId
											   ,0
											   ,0
											   ,@IsActive
											   ,@BetradarTimeStamp
											   ,@BetradarMatchId
											   ,@BetradarOddTypeId
											   ,@BetradarOddSubTypeId2,2,@BetradarTeamId,@ForTheRest,@BetRadarPlayerId)
										end
								set @eventoddid=@BettradarOddId

								execute [Betradar].[Live.ProcOddSettingInsert] @OddsTypeId,@eventoddid,@BetradarMatchId,@BetradarMatchId

						end
			end

--			exec [Tip_CashoutDB].[Betradar].[Live.ProcEventOdd]
--@BetradarMatchId  ,
--@BetradarOddTypeId ,
--@BetradarOddSubTypeId ,
--@OutCome ,
--@OutComeId ,
--@BetRadarPlayerId ,
--@BetradarTeamId ,
--@OddValue ,
--@SpecialBetValue ,
--@BettradarOddId ,
--@IsActive ,
--@Combination ,
----@ForTheRest ,
----@Comment,
----@MostBalanced ,
----@Changed ,
--@BetradarTimeStamp  
			end

		
END
GO
