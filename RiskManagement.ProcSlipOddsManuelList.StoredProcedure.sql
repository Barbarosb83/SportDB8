USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSlipOddsManuelList]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcSlipOddsManuelList] 

as 

BEGIN


SELECT  [SlipOddId]
      ,[StateId]
      ,[CreateDate]
  FROM [RiskManagement].[SlipManuelEvo]


  delete from [RiskManagement].[SlipManuelEvo]

END
 

GO
