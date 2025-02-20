USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcOddsEvaluateOLD]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcOddsEvaluateOLD]   
  
as 

BEGIN TRAN

declare @OddStateId int
declare @inserted table(

[OddsResultId] [int]  NOT NULL,
	[MatchId] [bigint] NOT NULL,
	[OddsTypeId] [int] NOT NULL,
	[Outcome] [nvarchar](50) NOT NULL,
	[SpecialBetValue] [nvarchar](50) NULL,
	[VoidFactor] [float] NULL,
	[OutcomeId] [int] NULL,
	[PlayerId] [int] NULL,
	[CompetitorId] [int] NULL,
	[Status] [bit] NULL,
	[Reason] [nvarchar](50) NULL,
	[BetradarOddTypeId] [bigint] NULL,
	[IsEvoluate] [bit] NULL

)




declare @MatchId bigint, @OddTypeId int,@OddId bigint,@OutCome nvarchar(50) ,@VoidFactor nvarchar(10),@SpecialBetValue nvarchar(50),@Statuss bit,@SlipTypeId int,@ParameterOddId int

insert @inserted
select   [OddsResultId]
      ,[MatchId]
      ,[OddsTypeId]
      ,[Outcome]
      ,[SpecialBetValue]
      ,[VoidFactor]
      ,[OutcomeId]
      ,[PlayerId]
      ,[CompetitorId]
      ,[Status]
      ,[Reason]
      ,[BetradarOddTypeId]
      ,[IsEvoluate]
from Match.OddsResult with (nolock)
where Match.OddsResult.IsEvoluate=0 


delete from Match.OddsResult where OddsResultId in (Select OddsResultId from @inserted)

insert Match.OddsResult 
select [MatchId]
      ,[OddsTypeId]
      ,[Outcome]
      ,[SpecialBetValue]
      ,[VoidFactor]
      ,[OutcomeId]
      ,[PlayerId]
      ,[CompetitorId]
      ,[Status]
      ,[Reason]
      ,[BetradarOddTypeId]
      ,1 from @inserted


update Archive.OddTypeSetting  
set OddTypeSetting.StateId=3
FROM Archive.OddTypeSetting  AS OddTypeSetting with (nolock)
INNER JOIN @inserted AS inserted  
on inserted.OddsTypeId=OddTypeSetting.OddTypeId and inserted.MatchId=OddTypeSetting.MatchId


update Archive.Setting 
set Setting.StateId=3
FROM Archive.Setting  AS Setting with (nolock)
INNER JOIN @inserted AS inserted  
on  inserted.MatchId=Setting.MatchId

declare @OddResultTable table (OddId bigint,OddTypeId int,MatchId bigint,Outcome nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS,VoidFactor nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS,Statuss bit,SpecialBetValue nvarchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS,ParameterOddId int)

if exists (Select Odds.OddId
From Archive.Odd as Odds with (nolock) INNER JOIN
@inserted as ins  ON Odds.OddsTypeId=ins.OddsTypeId and Odds.MatchId=ins.MatchId
 and Odds.OutCome COLLATE SQL_Latin1_General_CP1_CI_AS=ins.OutCome 
 and Odds.SpecialBetValue COLLATE SQL_Latin1_General_CP1_CI_AS=ins.SpecialBetValue )
insert @OddResultTable
Select Odds.OddId,ins.OddsTypeId,ins.MatchId,Odds.OutCome,ins.VoidFactor,ins.[Status],ins.SpecialBetValue,Odds.ParameterOddId
From Archive.Odd as Odds with (nolock) INNER JOIN
@inserted as ins  ON Odds.OddsTypeId=ins.OddsTypeId and Odds.MatchId=ins.MatchId
 and Odds.OutCome COLLATE SQL_Latin1_General_CP1_CI_AS=ins.OutCome 
 and Odds.SpecialBetValue COLLATE SQL_Latin1_General_CP1_CI_AS=ins.SpecialBetValue
 else
insert @OddResultTable
Select Odds.OddId,ins.OddsTypeId,ins.MatchId,Odds.OutCome,ins.VoidFactor,ins.[Status],ins.SpecialBetValue,Odds.ParameterOddId
From Match.Odd as Odds with (nolock) INNER JOIN
@inserted as ins  ON Odds.OddsTypeId=ins.OddsTypeId and Odds.MatchId=ins.MatchId
 and Odds.OutCome COLLATE SQL_Latin1_General_CP1_CI_AS=ins.OutCome 
 and Odds.SpecialBetValue COLLATE SQL_Latin1_General_CP1_CI_AS=ins.SpecialBetValue


set nocount on
					declare cur111 cursor local for(
					SELECT  DISTINCT ODDS.MatchId,ODDS.OddTypeId,ODDS.OddId,ODDS.Outcome,ODDS.VoidFactor,ODDS.Statuss,Customer.Slip.SlipTypeId ,ODDS.ParameterOddId ,ODDS.SpecialBetValue
					from @OddResultTable as ODDS INNER JOIN Customer.SlipOdd with (nolock) On 
					Customer.SlipOdd.MatchId=ODDS.MatchId and BetTypeId=0 and Customer.SlipOdd.StateId=1 and Customer.SlipOdd.OddsTypeId=ODDS.OddTypeId
					INNER JOIN Customer.Slip with (nolock) ON Customer.Slip.SlipId=Customer.SlipOdd.SlipId and Customer.Slip.SlipStateId=1

						)

					open cur111
					fetch next from cur111 into @MatchId,@OddTypeId,@OddId ,@OutCome,@VoidFactor,@Statuss,@SlipTypeId,@ParameterOddId,@SpecialBetValue
					while @@fetch_status=0
						begin
							begin


if @MatchId is not null and @OddTypeId is not null
begin


--Oddtypeların stateleri evulate yapılıyor.




--sliplerdeki oddlar lost yapılıyor.

set @OddStateId=6
--sliplerdeki kazanan oddlar win yapılıyor.
--Void Factor dolu gelmiş olan odd resultlar varsa odd value güncelleniyor.
if(@VoidFactor is null)
	begin
	if @Statuss=1
		begin
		update Customer.SlipOdd set StateId=3 where MatchId=@MatchId and OddsTypeId=@OddTypeId and ParameterOddId=@ParameterOddId and SpecialBetValue=@SpecialBetValue and BetTypeId=0
		set @OddStateId=5
		end
	else
		begin
		update Customer.SlipOdd set StateId=4 where MatchId=@MatchId and OddsTypeId=@OddTypeId and ParameterOddId=@ParameterOddId and SpecialBetValue=@SpecialBetValue and BetTypeId=0
		set @OddStateId=6
		end
	end
else
begin
	if @Statuss=1
		begin
			update Customer.SlipOdd set StateId=5,OddValue=(OddValue*@VoidFactor)+@VoidFactor where MatchId=@MatchId and OddsTypeId=@OddTypeId and ParameterOddId=@ParameterOddId and SpecialBetValue=@SpecialBetValue and BetTypeId=0
			set @OddStateId=7
		end
	else
		begin
			update Customer.SlipOdd set StateId=5,OddValue=@VoidFactor where  MatchId=@MatchId and OddsTypeId=@OddTypeId and ParameterOddId=@ParameterOddId and SpecialBetValue=@SpecialBetValue and BetTypeId=0
			INSERT INTO [Customer].[SlipOddCancel]
           ([SlipOddCancelId]
           ,[SlipId]
           ,[OddId]
           ,[OddValue]
           ,[Amount]
           ,[StateId]
           ,[BetTypeId]
           ,[OutCome]
           ,[MatchId]
           ,[OddsTypeId]
           ,[SpecialBetValue]
           ,[ParameterOddId]
           ,[EventName]
           ,[EventDate]
           ,[CurrencyId]
           ,[Score]
           ,[ScoreTimeStatu]
           ,[SportId]
           ,[Banko]
           ,[BetradarMatchId]
           ,[OddProbValue])
			select * from Customer.SlipOdd with (nolock)  where  MatchId=@MatchId and OddsTypeId=@OddTypeId and ParameterOddId=@ParameterOddId and SpecialBetValue=@SpecialBetValue and BetTypeId=0
			
			
			set @OddStateId=7
		end
end


--if(@SlipTypeId<4)
--update Customer.SlipOdd set StateId=4 where  MatchId=@MatchId and OddsTypeId=@OddTypeId and StateId not in (3,5,6) and BetTypeId=0 and SlipId in (Select SlipId from Customer.Slip where SlipTypeId<4 and SlipStateId=1)

--else
--	update Customer.SlipOdd set StateId=4 where  MatchId=@MatchId and OddsTypeId=@OddTypeId and ParameterOddId<>@ParameterOddId and SpecialBetValue=@SpecialBetValue and StateId not in (3,5,6) and BetTypeId=0 and SlipId in (Select SlipId from Customer.Slip where SlipTypeId in (4,5) and SlipStateId=1)


--update Match.OddsResult set Match.OddsResult.IsEvoluate=1 where Match.OddsResult.MatchId=@MatchId and Match.OddsResult.OddsTypeId=@OddTypeId
update Archive.Odd set StateId=@OddStateId where OddId=@OddId
	if(@SlipTypeId<4)
		exec [RiskManagement].[ProcSlipOddsEvaluate] @MatchId,@OddTypeId,0
	else if(@SlipTypeId=4)
		exec  [RiskManagement].[ProcSlipOddsEvaluateSystem]  @MatchId,@OddTypeId,0
	else if(@SlipTypeId=5)
		exec  [RiskManagement].[ProcSlipOddsEvaluateMulti]   @MatchId,@OddTypeId,0

end
end
							fetch next from cur111 into @MatchId,@OddTypeId,@OddId,@OutCome,@VoidFactor,@Statuss,@SlipTypeId,@ParameterOddId,@SpecialBetValue
			
						end
					close cur111
					deallocate cur111	




--update Match.OddsResult set Match.OddsResult.IsEvoluate=1 where Match.OddsResult.MatchId in 
--(select MatchId
--from @inserted)

COMMIT TRAN




GO
