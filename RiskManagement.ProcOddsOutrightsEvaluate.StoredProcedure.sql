USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcOddsOutrightsEvaluate]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcOddsOutrightsEvaluate]   
  
as 

BEGIN TRAN


declare @inserted table(MatchId bigint,OddId bigint,Outcome nvarchar(50))

declare @MatchId bigint, @OddTypeId int,@OddId bigint,@OutCome nvarchar(50),@VoidFactor nvarchar(10),@SpecialBetValue nvarchar(50)


insert @inserted
select Outrights.OddResult.MatchId,Outrights.OddResult.OddId,Outrights.OddResult.CompetitorId
from Outrights.OddResult
where Outrights.OddResult.IsEvoluate=0 and RankNo=1



set nocount on
					declare cur111 cursor local for(
					SELECT MatchId,OddId,Outcome  from @inserted

						)

					open cur111
					fetch next from cur111 into @MatchId,@OddId ,@OutCome
					while @@fetch_status=0
						begin
							begin


if @MatchId is not null
begin

select @OddTypeId =Outrights.Odd.OddsTypeId from Outrights.Odd where Outrights.Odd.OddId=@OddId


--Oddların stateleri geri dönebilmesi için eski stateleri kayıt ediliyor.
update Outrights.OddSetting set PreviousStateId=StateId where OddId in 
(select OddId from Outrights.Odd where MatchId=@MatchId and OddsTypeId=@OddTypeId) and StateId not in (5,7)
--Kazanan Oddtype'ın bütün oddları lost yapılıyor.
update Outrights.OddSetting set StateId=6 where OddId in 
(select OddId from Outrights.Odd  where MatchId=@MatchId and OddsTypeId=@OddTypeId) and StateId not in (5,7)

--Kazanan oddlar win state dönüyor.

update Outrights.OddSetting set StateId=5 where OddId=@OddId



--Oddtypeların stateleri geri dönebilmesi için eski stateleri kayıt ediliyor.
update Outrights.OddTypeSetting  
set Outrights.OddTypeSetting.PreviousStateId=Outrights.OddTypeSetting.StateId 
where OddTypeId=@OddTypeId and MatchId=@MatchId

--Oddtypeların stateleri evulate yapılıyor.
update Outrights.OddTypeSetting  
set Outrights.OddTypeSetting.StateId=3 
where OddTypeId=@OddTypeId and MatchId=@MatchId

--Maçın state'i close yapılıyor.
update Outrights.Event
set Outrights.Event.IsActive=0 
where  EventId=@MatchId

--sliplerdeki oddlar lost yapılıyor.
update Customer.SlipOdd set StateId=4 where  MatchId=@MatchId and OddsTypeId=@OddTypeId and StateId not in (3,6) and BetTypeId=2

--sliplerdeki kazanan oddlar win yapılıyor.

update Customer.SlipOdd set StateId=3 where OddId=@OddId and BetTypeId=2

	exec [RiskManagement].[ProcSlipOddsEvaluate] @MatchId,@OddTypeId,2

end
end
							fetch next from cur111 into @MatchId,@OddId ,@OutCome
			
						end
					close cur111
					deallocate cur111	


update Outrights.OddResult set Outrights.OddResult.IsEvoluate=1 where Outrights.OddResult.MatchId in 
(select MatchId
from @inserted)

COMMIT TRAN


GO
