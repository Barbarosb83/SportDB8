USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Job].[ProcCustomerAccountLockOut]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Job].[ProcCustomerAccountLockOut] 

AS

BEGIN


update Customer.Customer set IsTempLock=0,TempLockOutdate=NULL
where Customer.Customer.CustomerId in 
(select Customer.Customer.CustomerId 
from Customer.Customer 
where cast(Customer.Customer.TempLockOutdate as date)=cast(GETDATE() as date))


update Customer.Customer set IsTempLock=1,TempLockOutdate=DATEADD(DAY,9999,GETDATE())
where Customer.Customer.CustomerId in 
(select Customer.Customer.CustomerId 
from Customer.Customer 
where cast(Customer.LastLoginDate as date)<CAST(DATEADD(MONTH,-12,GETDATE()) as date) and IsTempLock=0 and IsBranchCustomer<>1 and IsTerminalCustomer<>1)


END


GO
