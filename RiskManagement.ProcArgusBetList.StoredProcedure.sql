USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcArgusBetList]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcArgusBetList] 

AS
BEGIN
SET NOCOUNT ON;

declare @Day int=-1

select Case when Customer.Customer.IsTerminalCustomer=1 OR Customer.Customer.IsBranchCustomer=1 
then 0 else Customer.Customer.CustomerId end as playerId
,Customer.Slip.SlipId as betId
,Customer.Slip.CreateDate as time
,Customer.Slip.Amount as stake
,CAST(0 as money) as profit
,case when (Select COUNT(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where Customer.SlipOdd.SlipId=Customer.Slip.SlipId)>1
then 'multiple' 
else ISNULL((Select Parameter.Sport.SportName from Customer.SlipOdd with (nolock) INNER JOIN Parameter.Sport ON Parameter.Sport.SportId=Customer.SlipOdd.SportId 
and Customer.SlipOdd.SlipId=Customer.Slip.SlipId),'soccer') end as sport
,case when (Select COUNT(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where Customer.SlipOdd.SlipId=Customer.Slip.SlipId)>1
then 'multiple' 
else ISNULL((Select Customer.SlipOdd.EventName from Customer.SlipOdd with (nolock)  where Customer.SlipOdd.SlipId=Customer.Slip.SlipId),'') end as eventname
,case when (Select COUNT(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where Customer.SlipOdd.SlipId=Customer.Slip.SlipId)>1
then null
else (Select  Customer.SlipOdd.EventDate   from Customer.SlipOdd with (nolock)  where Customer.SlipOdd.SlipId=Customer.Slip.SlipId) end as eventdate
,case when (Select COUNT(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where Customer.SlipOdd.SlipId=Customer.Slip.SlipId)>1
then 'XX' 
else 'DE' end as eventCountry
,case when Customer.Slip.SlipTypeId=2 then 'combine' else case when Customer.Slip.SlipTypeId>3 then 'system' else 'combine' end end as type
,'hosted' as distribution
,REPLACE(Parameter.SlipState.State,'Open','accepted') as status
,'passed' as oasisCheck
from Customer.Customer with (nolock) INNER JOIN Customer.Slip with (nolock) INNER JOIN Parameter.SlipState On Parameter.SlipState.StateId=Customer.Slip.SlipStateId
On Customer.Customer.CustomerId=Customer.Slip.CustomerId
where cast(Customer.Slip.CreateDate as date)=CAST(DATEADD(DAY,@Day,GETDATE()) as date)



END




GO
