USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [dbo].[INDEXORGANIZE]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[INDEXORGANIZE]
AS
BEGIN

--ALTER INDEX [IX_Slip] ON [Archive].[Slip]
--REORGANIZE 

--ALTER INDEX [IX_Slip_1] ON [Archive].[Slip]
--REORGANIZE 

--ALTER INDEX [IX_Slip_3] ON [Archive].[Slip]
--REORGANIZE 

--ALTER INDEX [IX_Slip_5] ON [Archive].[Slip]
--REORGANIZE 

--ALTER INDEX [PK_Slip_1] ON [Archive].[Slip]
--REORGANIZE 

--ALTER INDEX [IX_SlipOdd_3] ON [Archive].[SlipOdd]
--REORGANIZE 

--ALTER INDEX [PK_SlipOdd_1] ON [Archive].[SlipOdd]
--REORGANIZE 

--ALTER INDEX [IX_Bonus] ON [Customer].[Bonus]
--REORGANIZE 

--ALTER INDEX [PK_Bonus] ON [Customer].[Bonus]
--REORGANIZE 

ALTER INDEX [IX_Competitor] ON [Parameter].[Competitor]
REORGANIZE 

ALTER INDEX [IX_EventTopOdd] ON [Live].[EventTopOdd]
REORGANIZE 

ALTER INDEX [IX_EventTopOdd_1] ON [Live].[EventTopOdd]
REORGANIZE 

ALTER INDEX [IX_EventTopOdd_2] ON [Live].[EventTopOdd]
REORGANIZE 

ALTER INDEX [PK_EventTopOdd] ON [Live].[EventTopOdd]
REORGANIZE 



--ALTER INDEX [IX_Customer] ON [Customer].[Customer]
--REORGANIZE 

--ALTER INDEX [IX_Customer_1] ON [Customer].[Customer]
--REORGANIZE 

--ALTER INDEX [IX_Customer_2] ON [Customer].[Customer]
--REORGANIZE 

--ALTER INDEX [IX_Customer_3] ON [Customer].[Customer]
--REORGANIZE 

--ALTER INDEX [PK_Customer] ON [Customer].[Customer]
--REORGANIZE 

--ALTER INDEX [IX_Ip] ON [Customer].[Ip]
--REORGANIZE 

--ALTER INDEX [PK_Ip] ON [Customer].[Ip]
--REORGANIZE 

ALTER INDEX [IX_Slip_1] ON [Customer].[Slip]
REORGANIZE 

ALTER INDEX [IX_Slip_2] ON [Customer].[Slip]
REORGANIZE 

ALTER INDEX [IX_Slip_4] ON [Customer].[Slip]
REORGANIZE 

ALTER INDEX [IX_Slip_6] ON [Customer].[Slip]
REORGANIZE 

ALTER INDEX [PK_Slip] ON [Customer].[Slip]
REORGANIZE 

--ALTER INDEX [IX_SlipCashOut] ON [Customer].[SlipCashOut]
--REORGANIZE 

--ALTER INDEX [PK_SlipCashOut] ON [Customer].[SlipCashOut]
--REORGANIZE 

ALTER INDEX [IX_SlipOdd] ON [Customer].[SlipOdd]
REORGANIZE 

ALTER INDEX [IX_SlipOdd_1] ON [Customer].[SlipOdd]
REORGANIZE 

ALTER INDEX [IX_SlipOdd_2] ON [Customer].[SlipOdd]
REORGANIZE 

ALTER INDEX [IX_SlipOdd_4] ON [Customer].[SlipOdd]
REORGANIZE 

ALTER INDEX [IX_SlipOdd_5] ON [Customer].[SlipOdd]
REORGANIZE 

ALTER INDEX [IX_SlipOdd_6] ON [Customer].[SlipOdd]
REORGANIZE 

ALTER INDEX [IX_SlipOdd_7] ON [Customer].[SlipOdd]
REORGANIZE 

ALTER INDEX [IX_SlipOdd_8] ON [Customer].[SlipOdd]
REORGANIZE 

ALTER INDEX [IX_SlipSystem] ON [Customer].[SlipSystem]
REORGANIZE 

ALTER INDEX [IX_SlipSystem_1] ON [Customer].[SlipSystem]
REORGANIZE 

ALTER INDEX [IX_SlipSystem_2] ON [Customer].[SlipSystem]
REORGANIZE 

ALTER INDEX [PK_SystemSlip] ON [Customer].[SlipSystem]
REORGANIZE 

ALTER INDEX [IX_SlipSystemSlip] ON [Customer].[SlipSystemSlip]
REORGANIZE 

ALTER INDEX [IX_SlipSystemSlip_1] ON [Customer].[SlipSystemSlip]
REORGANIZE 

ALTER INDEX [PK_SlipSystemSlip] ON [Customer].[SlipSystemSlip]
REORGANIZE 

--ALTER INDEX [IX_Tax] ON [Customer].[Tax]
--REORGANIZE 

--ALTER INDEX [IX_Tax_1] ON [Customer].[Tax]
--REORGANIZE 

--ALTER INDEX [IX_Tax_2] ON [Customer].[Tax]
--REORGANIZE 

--ALTER INDEX [PK_Tax] ON [Customer].[Tax]
--REORGANIZE 

--ALTER INDEX [IX_Transaction] ON [Customer].[Transaction]
--REORGANIZE 

--ALTER INDEX [IX_Transaction_1] ON [Customer].[Transaction]
--REORGANIZE 

--ALTER INDEX [IX_Transaction_2] ON [Customer].[Transaction]
--REORGANIZE 

--ALTER INDEX [IX_Transaction_3] ON [Customer].[Transaction]
--REORGANIZE 

--ALTER INDEX [PK_Transaction] ON [Customer].[Transaction]
--REORGANIZE 

ALTER INDEX [IX_Event_2] ON [Live].[Event]
REORGANIZE 

ALTER INDEX [IX_Event_5] ON [Live].[Event]
REORGANIZE 

ALTER INDEX [IX_Event_6] ON [Live].[Event]
REORGANIZE 

ALTER INDEX [IX_Event_7] ON [Live].[Event]
REORGANIZE 

ALTER INDEX [IX_Event_8] ON [Live].[Event]
REORGANIZE 

ALTER INDEX [PK_Event_2] ON [Live].[Event]
REORGANIZE 

ALTER INDEX [IX_BBL] ON [Live].[EventDetail]
REORGANIZE 

ALTER INDEX [IX_EventDetail_1] ON [Live].[EventDetail]
REORGANIZE 

ALTER INDEX [IX_EventDetail_2] ON [Live].[EventDetail]
REORGANIZE 

ALTER INDEX [IX_EventDetail_3] ON [Live].[EventDetail]
REORGANIZE 

ALTER INDEX [IX_EventDetail_4] ON [Live].[EventDetail]
REORGANIZE 

ALTER INDEX [PK_EventDetail] ON [Live].[EventDetail]
REORGANIZE 

ALTER INDEX [IX_EventOdd_2] ON [Live].[EventOdd]
REORGANIZE 

ALTER INDEX [IX_EventOdd_3] ON [Live].[EventOdd]
REORGANIZE 

ALTER INDEX [IX_EventOdd_4] ON [Live].[EventOdd]
REORGANIZE 

ALTER INDEX [IX_EventOdd_5] ON [Live].[EventOdd]
REORGANIZE 

ALTER INDEX [IX_EventOdd_6] ON [Live].[EventOdd]
REORGANIZE 

ALTER INDEX [IX_EventOdd_7] ON [Live].[EventOdd]
REORGANIZE 

ALTER INDEX [IX_EventOdd_8] ON [Live].[EventOdd]
REORGANIZE 


ALTER INDEX [IX_EventOdd_9] ON [Live].[EventOdd]
REORGANIZE 

ALTER INDEX [IX_EventOdd_10] ON [Live].[EventOdd]
REORGANIZE 

ALTER INDEX [IX_EventOdd_11] ON [Live].[EventOdd]
REORGANIZE 

ALTER INDEX [PK_Odd] ON [Live].[EventOdd]
REORGANIZE 

ALTER INDEX [IX_EventSetting] ON [Live].[EventSetting]
REORGANIZE 

ALTER INDEX [PK_Setting] ON [Live].[EventSetting]
REORGANIZE 

ALTER INDEX [PK_OddTypeSetting] ON [Live].[EventOddTypeSetting]
REORGANIZE 

ALTER INDEX [IX_EventOddTypeSetting] ON [Live].[EventOddTypeSetting]
REORGANIZE 

ALTER INDEX [IX_EventOddTypeSetting_1] ON [Live].[EventOddTypeSetting]
REORGANIZE 

ALTER INDEX [IX_Parameter.Odds] ON [Live].[Parameter.Odds]
REORGANIZE 

ALTER INDEX [PK_Parameter.Odds] ON [Live].[Parameter.Odds]
REORGANIZE 

ALTER INDEX [BB_FX] ON [Match].[Fixture]
REORGANIZE 

ALTER INDEX [PK_Fixture] ON [Match].[Fixture]
REORGANIZE 

ALTER INDEX [IX_FixtureCompetiTip_2] ON [Match].[FixtureCompetitor]
REORGANIZE 

ALTER INDEX [PK_FixtureCompetitor] ON [Match].[FixtureCompetitor]
REORGANIZE 

ALTER INDEX [IX_FixtureDateInfo_1] ON [Match].[FixtureDateInfo]
REORGANIZE 

ALTER INDEX [IX_FixtureDateInfo_2] ON [Match].[FixtureDateInfo]
REORGANIZE 

ALTER INDEX [PK_FixtureDateInfo] ON [Match].[FixtureDateInfo]
REORGANIZE 

ALTER INDEX [IX_Match] ON [Match].[Match]
REORGANIZE 

ALTER INDEX [IX_Match_2] ON [Match].[Match]
REORGANIZE 

ALTER INDEX [PK_Match_2] ON [Match].[Match]
REORGANIZE 

ALTER INDEX [IX_OddsResult] ON [Match].[OddsResult]
REORGANIZE 

ALTER INDEX [IX_OddsResult_1] ON [Match].[OddsResult]
REORGANIZE 

ALTER INDEX [IX_OddsResult_3] ON [Match].[OddsResult]
REORGANIZE 

ALTER INDEX [PK_OddsResult] ON [Match].[OddsResult]
REORGANIZE 

ALTER INDEX [IX_BBO] ON [Match].[OddTypeSetting]
REORGANIZE 

--ALTER INDEX [IX_OddTypeSetting_1] ON [Match].[OddTypeSetting]
--REORGANIZE 

ALTER INDEX [IX_OddTypeSetting_2] ON [Match].[OddTypeSetting]
REORGANIZE 

ALTER INDEX [IX_OddTypeSetting_5] ON [Match].[OddTypeSetting]
REORGANIZE 

ALTER INDEX [IX_OddTypeSetting_6] ON [Match].[OddTypeSetting]
REORGANIZE 

ALTER INDEX [BB_INDEX1] ON [Match].[Odd]
REORGANIZE 

ALTER INDEX [IX_BBM] ON [Match].[Odd]
REORGANIZE 


ALTER INDEX [IX_Odd_10] ON [Match].[Odd]
REORGANIZE 


ALTER INDEX [IX_Odd_11] ON [Match].[Odd]
REORGANIZE 


ALTER INDEX [IX_Odd_13] ON [Match].[Odd]
REORGANIZE 


ALTER INDEX [IX_Odd_2] ON [Match].[Odd]
REORGANIZE 


ALTER INDEX [IX_Odd_3] ON [Match].[Odd]
REORGANIZE 


ALTER INDEX [IX_Odd_4] ON [Match].[Odd]
REORGANIZE 


ALTER INDEX [IX_Odd_7] ON [Match].[Odd]
REORGANIZE 


ALTER INDEX [IX_Odd_9] ON [Match].[Odd]
REORGANIZE 


ALTER INDEX [IX_Odd_BB1] ON [Match].[Odd]
REORGANIZE 

ALTER INDEX [IX_Odd_BB2] ON [Match].[Odd]
REORGANIZE 

ALTER INDEX [PK_Odd_1] ON [Match].[Odd]
REORGANIZE 





ALTER INDEX [PK_OddTypeSetting] ON [Match].[OddTypeSetting]
REORGANIZE 

ALTER INDEX [IX_Setting_1] ON [Match].[Setting]
REORGANIZE 

ALTER INDEX [IX_Setting_2] ON [Match].[Setting]
REORGANIZE 

ALTER INDEX [IX_Setting_3] ON [Match].[Setting]
REORGANIZE 

ALTER INDEX [PK_Setting] ON [Match].[Setting]
REORGANIZE 

ALTER INDEX [IX_Event_3] ON [Outrights].[Event]
REORGANIZE 

ALTER INDEX [IX_Event_4] ON [Outrights].[Event]
REORGANIZE 

ALTER INDEX [PK_Event_1] ON [Outrights].[Event]
REORGANIZE 

ALTER INDEX [IX_Odd_10] ON [Outrights].[Odd]
REORGANIZE 

ALTER INDEX [IX_Odd_11] ON [Outrights].[Odd]
REORGANIZE 

ALTER INDEX [IX_Odd_5] ON [Outrights].[Odd]
REORGANIZE 

ALTER INDEX [IX_Odd_6] ON [Outrights].[Odd]
REORGANIZE 

ALTER INDEX [PK_Odd_3] ON [Outrights].[Odd]
REORGANIZE 

--ALTER INDEX [IX_BranchTransaction] ON [RiskManagement].[BranchTransaction]
--REORGANIZE 

--ALTER INDEX [IX_BranchTransaction_1] ON [RiskManagement].[BranchTransaction]
--REORGANIZE 

--ALTER INDEX [IX_BranchTransaction_2] ON [RiskManagement].[BranchTransaction]
--REORGANIZE 

--ALTER INDEX [IX_BranchTransaction_3] ON [RiskManagement].[BranchTransaction]
--REORGANIZE 

--ALTER INDEX [IX_BranchTransaction_4] ON [RiskManagement].[BranchTransaction]
--REORGANIZE 

--ALTER INDEX [PK_BranchTransaction] ON [RiskManagement].[BranchTransaction]
--REORGANIZE 

--ALTER INDEX [IX_BranchTransactionPass] ON [RiskManagement].[BranchTransactionPass]
--REORGANIZE 

--ALTER INDEX [PK_BranchTransactionPass] ON [RiskManagement].[BranchTransactionPass]
--REORGANIZE 

end
GO
