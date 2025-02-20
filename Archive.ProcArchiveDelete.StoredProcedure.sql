USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Archive].[ProcArchiveDelete]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Archive].[ProcArchiveDelete]


AS

BEGIN TRAN 



truncate table [RiskManagement].[BranchMoneyTransaction]

declare @tmparchmatches table (matchid bigint)

insert @tmparchmatches
Select MatchId from Archive.Fixture with (nolock)  INNER JOIN Archive.FixtureDateInfo with (nolock) ON Archive.FixtureDateInfo.FixtureId=Archive.Fixture.FixtureId  where Archive.FixtureDateInfo.MatchDate<DAteadd(day,-5,getdate())


-- removing cards
delete from [Archive].[Card] where [Archive].[Card].MatchId in (select matchid from @tmparchmatches)
-- removing code
-- code mantigi gelecek ????????????????????

-- removing corner
delete from [Archive].[Corner] where [Archive].[Corner].MatchId in (select matchid from @tmparchmatches)
-- removing goal
delete from [Archive].[Goal] where [Archive].[Goal].MatchId in (select matchid from @tmparchmatches)
-- removing information
delete from [Archive].Information where [Archive].Information.MatchId in (select matchid from @tmparchmatches)
-- removing score comment
delete from [Archive].ScoreComment where [Archive].ScoreComment.MatchId in (select matchid from @tmparchmatches)
-- removing score info
delete from [Archive].ScoreInfo where [Archive].ScoreInfo.MatchId in (select matchid from @tmparchmatches)
-- removing score info
delete from [Archive].Setting where [Archive].Setting.MatchId in (select matchid from @tmparchmatches)
-- removing tv channel
delete from [Archive].TVChannel where [Archive].TVChannel.MatchId in (select matchid from @tmparchmatches)

delete from [Archive].DoublePlayer where [Archive].DoublePlayer.MatchId in (select matchid from @tmparchmatches)


-- removing Odd

declare @tmparchodd table (OddId bigint)
insert @tmparchodd
Select OddId from Archive.Odd  with (nolock)  where [Archive].Odd.MatchId in (select matchid from @tmparchmatches)

-- Odd Setting
delete from [Archive].OddSetting where [Archive].OddSetting.OddId in (select OddId from @tmparchodd)
-- Odd Result
delete from [Archive].OddsResult where [Archive].OddsResult.MatchId in (select matchid from @tmparchmatches)
-- Odd Type Setting
delete from [Archive].OddTypeSetting where [Archive].OddTypeSetting.MatchId in (select matchid from @tmparchmatches)
-- Odd
delete from [Archive].Odd where [Archive].Odd.MatchId in (select matchid from @tmparchmatches)


-- removing fixture
declare @tmparchfixture table (fixtureid bigint)
insert @tmparchfixture
Select FixtureId from Archive.[Fixture]  with (nolock)  where [Archive].[Fixture].MatchId in (select matchid from @tmparchmatches)

-- removing fixture competitor
delete from [Archive].[FixtureCompetitor] where [Archive].[FixtureCompetitor].FixtureId in (select fixtureid from @tmparchfixture)
-- removing fixture dateinfo
delete from [Archive].FixtureDateInfo where [Archive].FixtureDateInfo.FixtureId in (select fixtureid from @tmparchfixture)

delete from [Archive].[Fixture] where [Archive].[Fixture].MatchId in (select matchid from @tmparchmatches)
delete from [Archive].[Match] where [Archive].[Match].MatchId in (select matchid from @tmparchmatches)


-- Live Events
declare @tmparchlive table (EventId bigint,BetradarMatchId bigint)

insert @tmparchlive
Select EventId,BetradarMatchId from Archive.[Live.Event]  with (nolock)  where Archive.[Live.Event].EventDate<DAteadd(DAY,-5,getdate())

delete from [Archive].[Live.EventDetail] where [Archive].[Live.EventDetail].EventId in (select EventId from @tmparchlive)

delete from Live.OddResult from Live.OddResult where Live.OddResult.BetradarMatchId in   (select BetradarMatchId from @tmparchlive)

delete From Archive.[Live.EventOddResult] where BetradarMatchId  in   (select BetradarMatchId from @tmparchlive)

declare @tmparchliveodd table (EventOddId bigint)

insert @tmparchliveodd
Select OddId from Archive.[Live.EventOdd]  with (nolock)  where [Archive].[Live.EventOdd].MatchId in (select EventId from @tmparchlive)

delete from [Archive].[Live.EventOddSetting] where [Archive].[Live.EventOddSetting].OddId in (select EventOddId from @tmparchliveodd)
delete from [Archive].[Live.EventOdd] where [Archive].[Live.EventOdd].MatchId in (select EventId from @tmparchlive)
delete from [Archive].[Live.EventOddTypeSetting] where [Archive].[Live.EventOddTypeSetting].MatchId in (select EventId from @tmparchlive)
delete from [Archive].[Live.EventSetting] where [Archive].[Live.EventSetting].MatchId in (select EventId from @tmparchlive)
delete from [Archive].[Live.ScoreCardSummary] where [Archive].[Live.ScoreCardSummary].EventId in (select EventId from @tmparchlive)
delete from [Archive].[Live.Event] where [Archive].[Live.Event].EventId in (select EventId from @tmparchlive)

-- removing outrights

-- Outrights ta eklenecek ????????????????????????????

-- slips

declare @tmparchslip table (SlipId bigint)

insert @tmparchslip
Select SlipId from [Archive].[Slip]  with (nolock)  where  cast([Archive].[Slip].EvaluateDate as date) <cast(DAteadd(DAY,-45,getdate()) as date) and CustomerId not in (select CustomerId from Customer.Customer where BranchId=32643 )

Begin TRY

	insert  [Archive].[SlipOld] 
	Select * from [Archive].[Slip]  with (nolock) where SlipId in (select SlipId from @tmparchslip)

end try
BEGIN CATCH 

	delete from  [Archive].[SlipOld] where SlipId in (select SlipId from @tmparchslip)

	insert  [Archive].[SlipOld] 
	Select * from [Archive].[Slip]  with (nolock)  where SlipId in (select SlipId from @tmparchslip)

END CATCH 

Begin TRY
	
	insert  [Archive].[SlipOddOld]
	select * from Archive.SlipOdd  with (nolock)  where SlipId in (select SlipId from @tmparchslip)

end try
BEGIN CATCH 

	delete from  [Archive].[SlipOddOld] where SlipId in (select SlipId from @tmparchslip)

	insert  [Archive].[SlipOddOld]
	select * from Archive.SlipOdd  with (nolock)  where SlipId in (select SlipId from @tmparchslip)

END CATCH 

delete from Archive.SlipOdd where SlipId in (select SlipId from @tmparchslip)
delete from Archive.Slip where SlipId in (select SlipId from @tmparchslip)


INSERT INTO [Archive].[SlipPassword]
           ([SlipPasswordId]
           ,[SlipId]
           ,[Password]
           ,[TryCount])
	select [SlipPasswordId]
           ,[SlipId]
           ,[Password]
           ,[TryCount] from Customer.SlipPassword where SlipId in (select SlipId from @tmparchslip)


		   delete from Customer.SlipPassword where SlipId in (select SlipId from @tmparchslip)
--SystemSlip

declare @tmparchslipsystem table (SystemSlipId bigint)

insert @tmparchslipsystem
Select SystemSlipId from Customer.SlipSystem   with (nolock)  where  cast(Customer.SlipSystem.EvaluateDate as date) <cast(DAteadd(DAY,-45,getdate()) as date) and SlipStateId<>1 and CustomerId not in (select CustomerId from Customer.Customer where BranchId=32643 )


Begin TRY
	insert  [Archive].[SlipSystem]
	Select * from Customer.SlipSystem  with (nolock)   where SystemSlipId in (select SystemSlipId from @tmparchslipsystem)
end try
BEGIN CATCH 

	delete from  [Archive].[SlipSystem]  where SystemSlipId in (select SystemSlipId from @tmparchslipsystem)

	insert  [Archive].[SlipSystem]
	Select * from Customer.SlipSystem  with (nolock)   where SystemSlipId in (select SystemSlipId from @tmparchslipsystem)

END CATCH 


Begin TRY

	insert  [Archive].[SlipSystemSlip]
	select * from Customer.SlipSystemSlip  with (nolock)  where SystemSlipId in (select SystemSlipId from @tmparchslipsystem)

end try
BEGIN CATCH 

	delete from  [Archive].[SlipSystemSlip] where SystemSlipId in (select SystemSlipId from @tmparchslipsystem)

	insert  [Archive].[SlipSystemSlip]
	select * from Customer.SlipSystemSlip  with (nolock)  where SystemSlipId in (select SystemSlipId from @tmparchslipsystem)

END CATCH 

delete from Customer.SlipSystemSlip where SystemSlipId in (select SystemSlipId from @tmparchslipsystem)

delete from Customer.SlipSystem where SystemSlipId in (select SystemSlipId from @tmparchslipsystem)

COMMIT TRAN
GO
