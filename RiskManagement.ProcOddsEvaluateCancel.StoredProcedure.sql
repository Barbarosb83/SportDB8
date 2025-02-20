USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcOddsEvaluateCancel]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcOddsEvaluateCancel]   
@MatchId bigint
as 

BEGIN TRAN




if @MatchId is not null 
begin





update Archive.Odd set StateId=4 where MatchId=@MatchId


--Oddtypeların stateleri geri dönebilmesi için eski stateleri kayıt ediliyor.
update Archive.OddTypeSetting  
set Archive.OddTypeSetting.PreviousStateId=Archive.OddTypeSetting.StateId 
where  MatchId=@MatchId

--Oddtypeların stateleri cancel yapılıyor.
update Archive.OddTypeSetting  
set Archive.OddTypeSetting.StateId=4
where  MatchId=@MatchId

--Maçın state'i close yapılıyor.
update Archive.Setting  
set Archive.Setting.StateId=1 
where  MatchId=@MatchId



--update Customer.SlipOdd set StateId=2,OddValue=1 where MatchId=@MatchId and BetTypeId=0


--	exec [RiskManagement].[ProcSlipOddsEvaluateCancel] @MatchId

end


COMMIT TRAN


GO
