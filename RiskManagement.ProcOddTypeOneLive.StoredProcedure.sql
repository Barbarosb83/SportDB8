USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcOddTypeOneLive]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcOddTypeOneLive]
@OddsTypeId int,
@username nvarchar(max)

AS



BEGIN
SET NOCOUNT ON;



					  select Live.[Parameter.OddType].OddTypeId as OddsTypeId, Live.[Parameter.OddType].OddType as OddsType, Live.[Parameter.OddType].OutcomesDescription as OutcomesDescription, 
                     Live.[Parameter.OddType].IsActive, Live.[Parameter.OddType].ShortSign, Live.[Parameter.OddType].IsPopular,ISNULL(Live.[Parameter.OddType].SeqNumber,999) as SeqNumber
FROM        Live.[Parameter.OddType] 
where Live.[Parameter.OddType].OddTypeId=@OddsTypeId



END



GO
