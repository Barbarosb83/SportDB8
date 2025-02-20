USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Stadium].[ProcStadiumCreateJob]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [Stadium].[ProcStadiumCreateJob] 
 
AS

BEGIN
SET NOCOUNT ON;

----Rule Parameters -------
declare @RuleId bigint
declare @BranchId bigint
declare @OpenHours int
declare @EntranceFee money
declare @CurrencyId int
declare @MaxPlayer int
declare @MinPlayer int
declare @MinOddvalue float
declare @MaxOddValue float
declare @ServiceFee float
declare @CardChangeCount int
declare @CardView bit
declare @IsRepeat bit
declare @CreateDate datetime
declare @RuleStartDate datetime
declare @RuleEndDate datetime
declare @RuleIsActive bit
------------------------------------------------------------------

 

declare @StadiumId bigint


set nocount on
					declare cur111 cursor local for(
					SELECT [StadiumRuleId]
      ,[BranchId]
      ,[OpenHours]
      ,[EntranceFee]
      ,[CurrencyId]
      ,[MaxPlayer]
      ,[MinPlayer]
      ,[MinOddValue]
      ,[MaxOddValue]
      ,[ServiceFee]
      ,[CardChangeCount]
      ,[CardView]
      ,[IsRepeat]
      ,[CreateDate]
      ,[RuleStartDate]
      ,[RuleEndDate]
      ,[RuleIsActive]
  FROM [Stadium].[Rule] with (nolock) where RuleStartDate<=GETDATE() and RuleEndDate>GETDATE() and RuleIsActive=1
					
						)

					open cur111
					fetch next from cur111 into @RuleId,@BranchId,@OpenHours,@EntranceFee,@CurrencyId,@MaxPlayer,@MinPlayer,@MinOddvalue,@MaxOddValue,@ServiceFee,@CardChangeCount,@CardView,@IsRepeat,@CreateDate,@RuleStartDate,@RuleEndDate,@RuleIsActive
					while @@fetch_status=0
						begin
							begin
								if not exists (Select Stadium.Stadium.StadiumId from Stadium.Stadium with (nolock) where Stadium.CreateRuleId=@RuleId and Stadium.Stadium.BranchId=@BranchId and Stadium.Stadium.IsActive=1 and Stadium.Stadium.EndDate>GETDATE())
									begin
										INSERT INTO [Stadium].[Stadium]
											   ([BranchId]
											   ,[EntranceFee]
											   ,[CurrencyId]
											   ,[MaxPlayer]
											   ,[MinPlayer]
											   ,[MinOddValue]
											   ,[MaxOddValue]
											   ,[ServiceFee]
											   ,[CardChangeCount]
											   ,[CardView]
											   ,[CreateDate]
											   ,[IsActive]
											   ,[Comment]
											   ,[StartDate]
											   ,[EndDate]
											   ,[CreateRuleId],ActivePlayerCount)
										 values (
												@BranchId
												,@EntranceFee
												,@CurrencyId
												,@MaxPlayer
												,@MinPlayer
												,@MinOddvalue
												,@MaxOddValue
												,@ServiceFee
												,@CardChangeCount
												,@CardView
												,GETDATE()
												,1
												,''
												,GETDATE()
												,DATEADD(HOUR,@OpenHours,GETDATE())
												,@RuleId,0)

												set @StadiumId=SCOPE_IDENTITY()

												INSERT INTO [Stadium].[Sports]
												   ([StadiumId]
												   ,[SportId])
											  select @StadiumId, Stadium.RuleSports.SportId from Stadium.RuleSports with (nolock) where Stadium.RuleSports.RuleId=@RuleId

											  INSERT INTO [Stadium].[Category]
												   ([StadiumId]
												   ,[CategoryId])
											 select @StadiumId,Stadium.RuleCategory.CategoryId from Stadium.RuleCategory with (nolock) where Stadium.RuleCategory.RuleId=@RuleId

											 INSERT INTO [Stadium].Tournament
												   ([StadiumId]
												   ,TournamentId)
											 select @StadiumId,Stadium.RuleTournament.TournamentId from Stadium.RuleTournament with (nolock) where Stadium.RuleTournament.RuleId=@RuleId

											  INSERT INTO [Stadium].[Events]
												   ([StadiumId]
												   ,BetradarMatchId)
											values (@StadiumId,-1)

									end
								else 
									begin
										if (@IsRepeat=1)
											begin
												
												INSERT INTO [Stadium].[Stadium]
											   ([BranchId]
											   ,[EntranceFee]
											   ,[CurrencyId]
											   ,[MaxPlayer]
											   ,[MinPlayer]
											   ,[MinOddValue]
											   ,[MaxOddValue]
											   ,[ServiceFee]
											   ,[CardChangeCount]
											   ,[CardView]
											   ,[CreateDate]
											   ,[IsActive]
											   ,[Comment]
											   ,[StartDate]
											   ,[EndDate]
											   ,[CreateRuleId],ActivePlayerCount)
												SELECT [BranchId],[EntranceFee],[CurrencyId],[MaxPlayer],[MinPlayer],[MinOddValue],[MaxOddValue],[ServiceFee],[CardChangeCount],[CardView],GETDATE(),1,[Comment],GETDATE(),DATEADD(HOUR,@OpenHours,GETDATE()),@RuleId,0
												FROM [Stadium].[Stadium] with (nolock) where [CreateRuleId] =@RuleId and MaxPlayer=ActivePlayerCount  and Stadium.Stadium.BranchId=@BranchId and Stadium.Stadium.IsActive=1 and Stadium.Stadium.EndDate>GETDATE()


												set @StadiumId=SCOPE_IDENTITY()
												if(@StadiumId is not null)
													begin
														INSERT INTO [Stadium].[Sports]
														   ([StadiumId]
														   ,[SportId])
													  select @StadiumId, Stadium.RuleSports.SportId from Stadium.RuleSports with (nolock) where Stadium.RuleSports.RuleId=@RuleId

													  INSERT INTO [Stadium].[Category]
														   ([StadiumId]
														   ,[CategoryId])
													 select @StadiumId,Stadium.RuleCategory.CategoryId from Stadium.RuleCategory with (nolock) where Stadium.RuleCategory.RuleId=@RuleId

													 INSERT INTO [Stadium].Tournament
														   ([StadiumId]
														   ,TournamentId)
													 select @StadiumId,Stadium.RuleTournament.TournamentId from Stadium.RuleTournament with (nolock) where Stadium.RuleTournament.RuleId=@RuleId

													  INSERT INTO [Stadium].[Events]
														   ([StadiumId]
														   ,BetradarMatchId)
													values (@StadiumId,-1)

													end

											end


									end

										
							end
								fetch next from cur111 into @RuleId,@BranchId,@OpenHours,@EntranceFee,@CurrencyId,@MaxPlayer,@MinPlayer,@MinOddvalue,@MaxOddValue,@ServiceFee,@CardChangeCount,@CardView,@IsRepeat,@CreateDate,@RuleStartDate,@RuleEndDate,@RuleIsActive
			
						end
					close cur111
					deallocate cur111	




END


GO
