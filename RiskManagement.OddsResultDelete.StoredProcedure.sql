USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[OddsResultDelete]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [RiskManagement].[OddsResultDelete]   
@MatchId int



AS
BEGIN
declare  @OddTypeId int


set nocount on
					declare cur111 cursor local for(
					SELECT MatchId,OddsTypeId  from Match.OddsResult where MatchId=@MatchId

						)

					open cur111
					fetch next from cur111 into @MatchId,@OddTypeId
					while @@fetch_status=0
						begin
							begin

--Kazanan Oddtype'ın bütün oddları lost yapılıyor.
update Archive.OddSetting set StateId=PreviousStateId where OddId in 
(select OddId from Archive.Odd where MatchId=@MatchId and OddsTypeId=@OddTypeId)

update Archive.OddTypeSetting  
set Archive.OddTypeSetting.StateId =Archive.OddTypeSetting.PreviousStateId
where OddTypeId=@OddTypeId and MatchId=@MatchId

Delete from Match.OddsResult where MatchId=@MatchId and OddsTypeId=@OddTypeId

update Customer.SlipOdd set StateId=1 where  MatchId=@MatchId and OddsTypeId=@OddTypeId

end
							fetch next from cur111 into @MatchId,@OddTypeId
			
						end
					close cur111
					deallocate cur111


end


GO
