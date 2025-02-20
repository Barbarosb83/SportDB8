USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcArgusOperationList]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcArgusOperationList] 

AS
BEGIN
SET NOCOUNT ON;


declare @Day int=-1

Select Customer.StakeLimit.CustomerId as playerId
,Customer.StakeLimit.CustomerStakeId as limitId
,'stake' as type
,'increase' as change
,Customer.StakeLimit.StakeDay as newLimit
,UpdateDate as request 
,'granted' as status
,UpdateDate as completion
from   Customer.StakeLimit where  cast(UpdateDate as date)=cast(DATEADD(DAY,@Day,GETDATE()) as date)
 



END




GO
