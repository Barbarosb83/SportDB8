USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcArgusLoginList]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcArgusLoginList] 

AS
BEGIN
SET NOCOUNT ON;

declare @Day int=-1


Select Customer.Activity.CustomerId as playerId
,Customer.Activity.CustomerActivityId as loginId
,Customer.Activity.CreateDate as time
,  'successful' as status
,'passed' as oasisCheck
 ,cast(0 as int) as session
 ,Customer.Activity.CreateDate as unbanned
 ,'' as unbanType
from   Customer.Activity where ActivtyId=1 and cast(CreateDate as date)=cast(DATEADD(DAY,@Day,GETDATE()) as date)
 



END




GO
