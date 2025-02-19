USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSlipOddsManuelUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcSlipOddsManuelUID] 
 @SlipOddId bigint,
 @StateId int
as 

BEGIN

INSERT INTO [RiskManagement].[SlipManuelEvo]
           ([SlipOddId]
           ,[StateId]
           ,[CreateDate]
           ,[IsEvo])
     VALUES (@SlipOddId,@StateId,GETDATE(),0)

END
 

GO
