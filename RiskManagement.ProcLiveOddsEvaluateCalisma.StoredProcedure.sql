USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcLiveOddsEvaluateCalisma]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcLiveOddsEvaluateCalisma]   
as 
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

BEGIN
BEGIN TRAN


declare @inserted table(
OddresultId bigint,
	BetradarOddId bigint,
	OddsTypeId int,
	OutCome nvarchar(150)  COLLATE SQL_Latin1_General_CP1_CI_AS ,
	SpecialBetValue nvarchar(150),
	OddResult bit,
	VoidFactor float,
	IsCanceled bit ,
	IsEvaluated bit ,
	OddFactor float,
	EvaluatedDate datetime,
	BetradarOddsTypeId bigint,
	BetradarOddsSubTypeId bigint,
	StateId int,
	BetradarMatchId bigint,
	OddId bigint)





declare @MatchId bigint, @OddTypeId int,@OddId bigint,@OutCome nvarchar(50),@VoidFactor nvarchar(10),@SpecialBetValue nvarchar(50),@OddResult bit,@BetradarMatchId bigint,@ParameterOddId int,@SlipTypeId int

insert  @inserted
select  OddresultId,
[BetradarOddId]
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
      ,[OddId]
from Live.EventOddResult with (nolock)
where Live.EventOddResult.IsEvaluated=0 
and Live.EventOddResult.IsCanceled is null 
and Live.EventOddResult.OddId is not null


UPDATE R 
SET R.StateId = 3 
FROM Live.EventOddTypeSetting AS R with (nolock)
INNER JOIN @inserted AS P 
       ON R.BetradarMatchId = P.BetradarMatchId and R.OddTypeId=P.OddsTypeId


--	   UPDATE R 
--SET R.StateId = 3 
--FROM Live.EventSetting AS R with (nolock)
--INNER JOIN @inserted AS P 
--       ON R.MatchId = P.e and R.OddTypeId=P.OddsTypeId



delete from Live.EventOddResult where OddresultId in (Select OddresultId from @inserted)

insert into Live.EventOddResult 
select [BetradarOddId]
      ,[OddsTypeId]
      ,[OutCome]
      ,[SpecialBetValue]
      ,[OddResult]
      ,[VoidFactor]
      ,[IsCanceled]
      ,1
      ,[OddFactor]
      ,[EvaluatedDate]
      ,[BetradarOddsTypeId]
      ,[BetradarOddsSubTypeId]
      ,[StateId]
      ,[BetradarMatchId]
      ,[OddId] from @inserted


	  declare @ResultTemp table (MatchId bigint,OddTypeId bigint,SlipTypeId int)

set nocount on
					declare cur111 cursor local for(
					SELECT DISTINCT Customer.SlipOdd.MatchId,INS.OddsTypeId,INS.OddId,INS.Outcome,VoidFactor,INS.OddResult,INS.SpecialBetValue,INS.BetradarMatchId
					,Customer.SlipOdd.ParameterOddId  ,Customer.Slip.SlipTypeId
					from @inserted as INS INNER JOIN Customer.SlipOdd with (nolock) On Customer.SlipOdd.BetradarMatchId=INS.BetradarMatchId 
					and Customer.SlipOdd.OddsTypeId=INs.OddsTypeId and Customer.SlipOdd.BetTypeId=1 and Customer.SlipOdd.StateId=1 -- and Customer.SlipOdd.OutCome=INS.OutCome and Customer.SlipOdd.SpecialBetValue=INS.SpecialBetValue
					and (Customer.SlipOdd.SpecialBetValue=INS.SpecialBetValue or (INS.SpecialBetValue is null))
					INNER JOIN Customer.Slip with (nolock) ON Customer.Slip.SlipId=Customer.SlipOdd.SlipId  and Customer.Slip.SlipStateId=1
					INNER JOIN Live.[Parameter.Odds] with (nolock) On Live.[Parameter.Odds].OddsId=Customer.SlipOdd.ParameterOddId and INS.OutCome=Live.[Parameter.Odds].Outcomes
						)

					open cur111
					fetch next from cur111 into @MatchId,@OddTypeId,@OddId ,@OutCome,@VoidFactor,@OddResult,@SpecialBetValue,@BetradarMatchId,@ParameterOddId,@SlipTypeId
					while @@fetch_status=0
						begin
							begin

								if @MatchId is not null and @OddTypeId is not null
								begin

									--sliplerdeki oddlar lost yapılıyor.
									if(@OddResult=0 and @VoidFactor is null)
										begin
											update Customer.SlipOdd set StateId=4 where  OddId=@OddId and StateId not in (3,6) and BetTypeId=1
										end
									else if(@OddResult=0 and @VoidFactor is not null)
										begin
											update Customer.SlipOdd set StateId=5,OddValue=@VoidFactor where OddId=@OddId and BetTypeId=1
										end
									--sliplerdeki kazanan oddlar win yapılıyor.
									--Void Factor dolu gelmiş olan odd resultlar varsa odd value güncelleniyor.
									else if(@OddResult=1)
										begin
											if(@VoidFactor is null)
												begin
													update Customer.SlipOdd set StateId=3 where OddId=@OddId and BetTypeId=1
												end
											else
												begin
													update Customer.SlipOdd set StateId=5,OddValue=(OddValue*@VoidFactor)+@VoidFactor where OddId=@OddId and BetTypeId=1
												end
										end
									

									insert @ResultTemp values (@MatchId,@OddTypeId,@SlipTypeId)


								end
							end
							fetch next from cur111 into @MatchId,@OddTypeId,@OddId,@OutCome,@VoidFactor,@OddResult,@SpecialBetValue,@BetradarMatchId,@ParameterOddId,@SlipTypeId
			
						end
					close cur111
					deallocate cur111	

					
				set nocount on
					declare cur0111 cursor local for(
						select DISTINCT MatchId,OddTypeId,SlipTypeId from @ResultTemp
						)

					open cur0111
					fetch next from cur0111 into @MatchId,@OddTypeId,@SlipTypeId
					while @@fetch_status=0
						begin
							begin

								if(@SlipTypeId<4)
									exec [RiskManagement].[ProcSlipOddsEvaluate] @MatchId,@OddTypeId,1
								else if (@SlipTypeId=4)
									exec  [RiskManagement].[ProcSlipOddsEvaluateSystem]  @MatchId,@OddTypeId,1
								else if (@SlipTypeId=5)
									exec  [RiskManagement].[ProcSlipOddsEvaluateMulti]  @MatchId,@OddTypeId,1

							end
							fetch next from cur0111 into @MatchId,@OddTypeId,@SlipTypeId
			
						end
					close cur0111
					deallocate cur0111
					 
delete @ResultTemp
set nocount on
					declare cur1112 cursor local for(
					SELECT DISTINCT Customer.SlipOdd.MatchId,Customer.SlipOdd.OddsTypeId,Customer.SlipOdd.OddId,Customer.SlipOdd.OutCome,VoidFactor,INS.OddResult,INS.SpecialBetValue,INS.BetradarMatchId
					,Customer.SlipOdd.ParameterOddId  ,Customer.Slip.SlipTypeId
					from @inserted as INS INNER JOIN Customer.SlipOdd with (nolock) On Customer.SlipOdd.BetradarMatchId=INS.BetradarMatchId 
					 and Customer.SlipOdd.BetTypeId=0 and Customer.SlipOdd.StateId=1 -- and Customer.SlipOdd.OutCome=INS.OutCome and Customer.SlipOdd.SpecialBetValue=INS.SpecialBetValue
					and (Customer.SlipOdd.SpecialBetValue=INS.SpecialBetValue or (INS.SpecialBetValue is null))
					INNER JOIN Customer.Slip with (nolock) ON Customer.Slip.SlipId=Customer.SlipOdd.SlipId  and Customer.Slip.SlipStateId=1 --and Customer.Slip.CustomerId in (1021,1976)
					INNER JOIN Live.[Parameter.Odds] with (nolock) On Live.[Parameter.Odds].OddTypeId=INS.OddsTypeId and INS.OutCome=Live.[Parameter.Odds].Outcomes INNER JOIN
					Parameter.Odds On Parameter.Odds.LiveOddId=Live.[Parameter.Odds].OddsId and Parameter.Odds.OddsId=Customer.SlipOdd.ParameterOddId


						)

					open cur1112
					fetch next from cur1112 into @MatchId,@OddTypeId,@OddId ,@OutCome,@VoidFactor,@OddResult,@SpecialBetValue,@BetradarMatchId,@ParameterOddId,@SlipTypeId
					while @@fetch_status=0
						begin
							begin


if @MatchId is not null and @OddTypeId is not null
begin

if(@OddResult=0 and @VoidFactor is null)
begin
update Customer.SlipOdd set StateId=4 where  OddId=@OddId and StateId not in (3,6) and BetTypeId=0
	insert @ResultTemp values (@MatchId,@OddTypeId,@SlipTypeId)
end

	
end
end
							fetch next from cur1112 into @MatchId,@OddTypeId,@OddId,@OutCome,@VoidFactor,@OddResult,@SpecialBetValue,@BetradarMatchId,@ParameterOddId,@SlipTypeId
			
						end
					close cur1112
					deallocate cur1112	

					set nocount on
					declare cur00111 cursor local for(
						select DISTINCT MatchId,OddTypeId,SlipTypeId from @ResultTemp
						)

					open cur00111
					fetch next from cur00111 into @MatchId,@OddTypeId,@SlipTypeId
					while @@fetch_status=0
						begin
							begin

								if(@SlipTypeId<4)
									exec [RiskManagement].[ProcSlipOddsEvaluate] @MatchId,@OddTypeId,0
								else if (@SlipTypeId=4)
									exec  [RiskManagement].[ProcSlipOddsEvaluateSystem]  @MatchId,@OddTypeId,0
								else if (@SlipTypeId=5)
									exec  [RiskManagement].[ProcSlipOddsEvaluateMulti]  @MatchId,@OddTypeId,0

							end
							fetch next from cur00111 into @MatchId,@OddTypeId,@SlipTypeId
			
						end
					close cur00111
					deallocate cur00111





COMMIT TRAN


END
GO
