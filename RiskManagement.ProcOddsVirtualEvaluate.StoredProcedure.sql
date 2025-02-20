USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcOddsVirtualEvaluate]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcOddsVirtualEvaluate]   
  
as 

BEGIN TRAN


declare @inserted table(OddId bigint,MatchId bigint,OddsTypeId int,Outcome nvarchar(50),VoidFactor nvarchar(10),SpecialBetValue nvarchar(50),OddResult bit)
declare @MatchId bigint, @OddTypeId int,@OddId bigint,@OutCome nvarchar(50),@VoidFactor nvarchar(10),@SpecialBetValue nvarchar(50),@OddResult bit

insert @inserted
select Virtual.EventOdd.OddId,Virtual.EventOdd.MatchId,Virtual.EventOdd.OddsTypeId,Virtual.EventOdd.Outcome,Virtual.EventOdd.VoidFactor,Virtual.EventOdd.SpecialBetValue,Virtual.EventOdd.OddResult
from Virtual.EventOdd
where Virtual.EventOdd.IsEvaluated=0 and Virtual.EventOdd.IsCanceled is null



set nocount on
					declare cur111 cursor local for(
					SELECT MatchId,OddsTypeId,OddId,Outcome,VoidFactor,OddResult  from @inserted

						)

					open cur111
					fetch next from cur111 into @MatchId,@OddTypeId,@OddId ,@OutCome,@VoidFactor,@OddResult
					while @@fetch_status=0
						begin
							begin


if @MatchId is not null and @OddTypeId is not null
begin


--sliplerdeki oddlar lost yapılıyor.
if(@OddResult=0 and @VoidFactor is null)
update Customer.SlipOdd set StateId=4 where  OddId=@OddId and StateId not in (3,6) and BetTypeId=3

--sliplerdeki kazanan oddlar win yapılıyor.
--Void Factor dolu gelmiş olan odd resultlar varsa odd value güncelleniyor.
if(@OddResult=1)
begin
if(@VoidFactor is null)
update Customer.SlipOdd set StateId=3 where OddId=@OddId and BetTypeId=3
else
update Customer.SlipOdd set StateId=5,OddValue=@VoidFactor where OddId=@OddId and BetTypeId=3
end

if(@OddResult=0 and @VoidFactor is not null)
begin
update Customer.SlipOdd set StateId=5,OddValue=@VoidFactor where OddId=@OddId and BetTypeId=3

end


update Virtual.EventOdd set Virtual.EventOdd.IsEvaluated=1 where Virtual.EventOdd.OddId=@OddId 

	exec [RiskManagement].[ProcSlipOddsEvaluate] @MatchId,@OddTypeId,3

end
end
							fetch next from cur111 into @MatchId,@OddTypeId,@OddId,@OutCome,@VoidFactor,@OddResult
			
						end
					close cur111
					deallocate cur111	



COMMIT TRAN


GO
