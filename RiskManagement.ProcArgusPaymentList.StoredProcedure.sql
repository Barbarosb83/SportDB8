USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcArgusPaymentList]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcArgusPaymentList] 

AS
BEGIN
SET NOCOUNT ON;


declare @Day int=-1

Select Customer.Customer.CustomerId as playerId
,Customer.[Transaction].TransactionId as operationId
,Customer.[Transaction].TransactionDate as time
,case when Parameter.TransactionType.Direction=0 then 'payout' else 'deposit' end as type
,Customer.[Transaction].Amount as amount
,Parameter.TransactionType.TransactionType as paymentType
,'successful' as status
from   Customer.[Transaction] with (nolock) INNER JOIN Customer.Customer with (nolock) 
On Customer.Customer.CustomerId=Customer.[Transaction].CustomerId INNER JOIN 
Parameter.TransactionType On Customer.[Transaction].TransactionTypeId=Parameter.TransactionType.TransactionTypeId
where Customer.Customer.IsTerminalCustomer=0 and IsBranchCustomer=0 and Customer.[Transaction].TransactionTypeId in (1,2,67) 
and cast(Customer.[Transaction].TransactionDate as date)=CAST(DATEADD(DAY,@Day,GETDATE()) as date)
 
 



END




GO
