USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcArgusPlayerList]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcArgusPlayerList] 

AS
BEGIN
SET NOCOUNT ON;

declare @Day int=-1


Select Customer.Customer.CustomerId,Birthday,'DE' as states,Customer.Customer.CreateDate,   Customer.PEPControl.UpdateDate  as idDate
, Case when Customer.PEPControl.IsSanction=0 then 'failed' Else 
	case when  Customer.PEPControl.IsDoc=1 then 'passed' else
	case when Customer.PEPControl.IsSanction=1 then 'ongoing' else 'failed' end end end 
	 as idStatus
	,'Insic AVS INJUVERS' as idProcedure
	,case when Customer.Customer.IsActive=1 then 'active' else 'disabled' end as accountStatus
	,case when IsActiveChangeDate is null then Customer.Customer.CreateDate else IsActiveChangeDate end as accountStatusChange
	,Balance as balance
	,StakeDay as limitStake
	,DepositDay as limitDepositDay
	,DepositWeek as limitDepositWeek
	,DepositMonth as limitDepositMonth
	,LossDay as limitLossDay
	,LossWeek as limitLossWeek
	,LossMonth as  limitLossMonth
from Customer.Customer INNER JOIN Customer.StakeLimit On Customer.StakeLimit.CustomerId=Customer.Customer.CustomerId INNER JOIN
Customer.PEPControl On Customer.PepControl.CustomerId=Customer.Customer.CustomerId
where cast(Customer.Customer.CreateDate as date)=cast(DATEADD(DAY,@Day,GETDATE()) as date) or cast(Customer.PEPControl.UpdateDate as date)=cast(DATEADD(DAY,@Day,GETDATE()) as date)
or cast(Customer.Customer.IsActiveChangeDate as date)=cast(DATEADD(DAY,@Day,GETDATE()) as date)



END




GO
