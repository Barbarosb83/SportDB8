USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Report].[ProcLast24HCustomerReport]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [Report].[ProcLast24HCustomerReport] 
@TransactionType int, --1 win,2 lose,3 new customer,4 deposit,5 withdraw,6 SUM(deposit)>1000 euro ,7 deposit,withdraw,bet stake vs...>1000
@UserId int
AS

BEGIN
SET NOCOUNT ON;


declare @StartDate date
declare @EndDate date
declare @UserCurrencyId int

select @UserCurrencyId=CurrencyId from Users.Users where UserId=@UserId


declare @TempTable table(CustomerId bigint,Username nvarchar(50),Amount decimal(18,2),TransactionType nvarchar(150))
declare @TempTable2 table(CustomerId bigint,Username nvarchar(50),Amount decimal(18,2))
declare @TempTable3 table(CustomerId bigint,Username nvarchar(50),Amount decimal(18,2))

if(@TransactionType=1) --win
begin
		insert @TempTable
		select top 20 customer.[Transaction].CustomerId,Username,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.[Transaction].Amount),Customer.[Transaction].CurrencyId,@UserCurrencyId),0),'Win'
		 from customer.[Transaction] with (nolock) INNER JOIN
		  Customer.Customer with (nolock) ON Customer.Customer.CustomerId=Customer.[Transaction].CustomerId and IsBranchCustomer<>1 and IsTerminalCustomer<>1 
		  where TransactionTypeId in (3,38,42,51) and TransactionDate>=DATEADD(Day,-1,GETDATE())
		  GROUP BY customer.[Transaction].CustomerId,Username,Customer.[Transaction].CurrencyId
		  order by ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.[Transaction].Amount),Customer.[Transaction].CurrencyId,@UserCurrencyId),0) desc
end
else if(@TransactionType=2)--lose
begin
		insert @TempTable2
		select  customer.[Transaction].CustomerId,Username,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.[Transaction].Amount),Customer.[Transaction].CurrencyId,@UserCurrencyId),0)
		 from customer.[Transaction] with (nolock) INNER JOIN
		  Customer.Customer with (nolock) ON Customer.Customer.CustomerId=Customer.[Transaction].CustomerId and IsBranchCustomer<>1 and IsTerminalCustomer<>1 
		  where TransactionTypeId  in (3,38,42,51) and TransactionDate>=DATEADD(Day,-1,GETDATE())
		  GROUP BY customer.[Transaction].CustomerId,Username,Customer.[Transaction].CurrencyId
		    order by ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.[Transaction].Amount),Customer.[Transaction].CurrencyId,@UserCurrencyId),0) desc

		  insert @TempTable3
		    select  customer.[Transaction].CustomerId,Username,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.[Transaction].Amount),Customer.[Transaction].CurrencyId,@UserCurrencyId),0)
 from customer.[Transaction] with (nolock) INNER JOIN
  Customer.Customer with (nolock) ON Customer.Customer.CustomerId=Customer.[Transaction].CustomerId and IsBranchCustomer<>1 and IsTerminalCustomer<>1 
  where TransactionTypeId in (4,39,43,50) and TransactionDate>=DATEADD(Day,-1,GETDATE())
  GROUP BY customer.[Transaction].CustomerId,Username,Customer.[Transaction].CurrencyId
    order by ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.[Transaction].Amount),Customer.[Transaction].CurrencyId,@UserCurrencyId),0) desc


  insert @TempTable
	select top 20 LT.CustomerId,LT.Username,ISNULL(SUM(Lt.Amount),0)-ISNULL(SUM(WT.Amount),0),'Lose' 
	from @TempTable2 as WT Inner JOIN @TempTable3 as LT ON WT.CustomerId=LT.CustomerId 
	GROUP BY LT.CustomerId,LT.Username
	ORDER BY ISNULL(SUM(Lt.Amount),0)-ISNULL(SUM(WT.Amount),0) desc

end
else if(@TransactionType=3) --new Customer
begin
		insert @TempTable
		select top 20 Customer.Customer.CustomerId,Username,0,'New Customer'
		 from Customer.Customer with (nolock)
		  where CreateDate>=DATEADD(Day,-1,GETDATE())  and IsBranchCustomer<>1 and IsTerminalCustomer<>1 
		  order by  CreateDate desc
end
else if(@TransactionType=4) --Deposit
begin
		insert @TempTable
		select top 20 customer.[Transaction].CustomerId,Username,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.[Transaction].Amount),Customer.[Transaction].CurrencyId,@UserCurrencyId),0),'Deposit'
		 from customer.[Transaction] with (nolock) INNER JOIN
		  Customer.Customer with (nolock) ON Customer.Customer.CustomerId=Customer.[Transaction].CustomerId and IsBranchCustomer<>1 and IsTerminalCustomer<>1 
		  where TransactionTypeId in (1,11,13,15,17,19,21,23,25,27,29,30,32,46,55,57,59) and TransactionDate>=DATEADD(Day,-1,GETDATE())
		  GROUP BY customer.[Transaction].CustomerId,Username,Customer.[Transaction].CurrencyId
		  order by ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.[Transaction].Amount),Customer.[Transaction].CurrencyId,@UserCurrencyId),0) desc
end
else if(@TransactionType=5) --Withdraw
begin
		insert @TempTable
		select top 20 customer.[Transaction].CustomerId,Username,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.[Transaction].Amount),Customer.[Transaction].CurrencyId,@UserCurrencyId),0),'Withdraw'
		 from customer.[Transaction] with (nolock) INNER JOIN
		  Customer.Customer with (nolock) ON Customer.Customer.CustomerId=Customer.[Transaction].CustomerId and IsBranchCustomer<>1 and IsTerminalCustomer<>1 
		  where TransactionTypeId in (2,10,12,14,16,18,20,22,24,26,28,31,62,56,58,60) and TransactionDate>=DATEADD(Day,-1,GETDATE())
		  GROUP BY customer.[Transaction].CustomerId,Username,Customer.[Transaction].CurrencyId
		  order by ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.[Transaction].Amount),Customer.[Transaction].CurrencyId,@UserCurrencyId),0) desc
end
else if(@TransactionType=6) --Deposit>1000 Euro
begin
		insert @TempTable
		select top 20 customer.[Transaction].CustomerId,Username,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.[Transaction].Amount),Customer.[Transaction].CurrencyId,@UserCurrencyId),0),'Sum Deposit>=1000'
		 from customer.[Transaction] with (nolock) INNER JOIN
		  Customer.Customer with (nolock) ON Customer.Customer.CustomerId=Customer.[Transaction].CustomerId and IsBranchCustomer<>1 and IsTerminalCustomer<>1 
		  where TransactionTypeId in (1,11,13,15,17,19,21,23,25,27,29,30,32,46,55,57,59) and TransactionDate>=DATEADD(Day,-1,GETDATE()) 
		  GROUP BY customer.[Transaction].CustomerId,Username,Customer.[Transaction].CurrencyId
		  HAVING (ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.[Transaction].Amount),Customer.[Transaction].CurrencyId,3),0))>=1000
		  order by ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.[Transaction].Amount),Customer.[Transaction].CurrencyId,@UserCurrencyId),0) desc
	
end
else if(@TransactionType=7) --deposit,withdraw,bet stake vs...>1000
begin
		insert @TempTable
		select top 20 customer.[Transaction].CustomerId,Username,ISNULL(dbo.FuncCurrencyConverter(Customer.[Transaction].Amount,Customer.[Transaction].CurrencyId,@UserCurrencyId),0),Parameter.TransactionType.TransactionType
		 from customer.[Transaction] with (nolock) INNER JOIN
		  Customer.Customer with (nolock) ON Customer.Customer.CustomerId=Customer.[Transaction].CustomerId and IsBranchCustomer<>1 and IsTerminalCustomer<>1 INNER JOIN
		  Parameter.TransactionType with (nolock) ON Customer.[Transaction].TransactionTypeId=Parameter.TransactionType.TransactionTypeId
		  where Customer.[Transaction].TransactionTypeId in (1,9,11,13,15,17,19,21,23,25,27,29,30,32,46,55,57,59,2,10,12,14,16,18,20,22,24,26,28,31,62,56,58,60,3,38,42,51,4,39,43,50) and TransactionDate>=DATEADD(Day,-1,GETDATE()) and ISNULL(dbo.FuncCurrencyConverter(Customer.[Transaction].Amount,Customer.[Transaction].CurrencyId,3),0)>=1000
		  order by ISNULL(dbo.FuncCurrencyConverter(Customer.[Transaction].Amount,Customer.[Transaction].CurrencyId,@UserCurrencyId),0) desc
end
else if(@TransactionType=8) --Customers hitting €2000 deposits in 180 days
begin
		insert @TempTable
			select   customer.DepositTransfer.CustomerId,Username,ISNULL(dbo.FuncCurrencyConverter(customer.DepositTransfer.DepositAmount,customer.DepositTransfer.CurrencyId,3),0),'Customers hitting €2000 deposits in 180 days'
		 from customer.DepositTransfer with (nolock) INNER JOIN
		  Customer.Customer with (nolock) ON Customer.Customer.CustomerId=customer.DepositTransfer.CustomerId and IsBranchCustomer<>1 and IsTerminalCustomer<>1 
		  where customer.DepositTransfer.DepositStatuId=1 and customer.DepositTransfer.TransferDateTime>=DATEADD(Day,-180,GETDATE())
		  and ISNULL(dbo.FuncCurrencyConverter(customer.DepositTransfer.DepositAmount,customer.DepositTransfer.CurrencyId,3),0)>=2000
		  order by ISNULL(dbo.FuncCurrencyConverter(customer.DepositTransfer.DepositAmount,customer.DepositTransfer.CurrencyId,3),0) desc
end
else if(@TransactionType=9) --Customer using high risk payment methods
begin
		insert @TempTable
		  select DISTINCT Customer.Customer.CustomerId,Username,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.[Transaction].Amount),customer.[Transaction].CurrencyId,3),0),
		  'Customer using high risk payment methods'
from Customer.Customer with (nolock) INNER JOIN Customer.[Transaction] with (nolock) 
On Customer.[transaction].CustomerId=Customer.CustomerId
where (Customer.[Transaction].TransactionTypeId in (select TransactionTypeId from Parameter.PaymentType where RiskLevelId=3) ) 
GROUP BY customer.[Transaction].CurrencyId,Customer.Customer.CustomerId,Username
HAVING dbo.FuncCurrencyConverter(SUM(Customer.[Transaction].Amount),customer.[Transaction].CurrencyId,3)>1

end
else if(@TransactionType=10) --IP mismatch within last 7 days
begin
		insert @TempTable
		 select Customer.Activity.CustomerId,Customer.Customer.Username,0,'IP mismatch within last 7 days' 
from Customer.Activity with (nolock) INNER JOIN Customer.Customer with (nolock) ON Customer.Customer.CustomerId=Customer.Activity.CustomerId
where Customer.Customer.IsBranchCustomer=0 and   cast(Customer.Activity.CreateDate as date)>cast(DATEADD(DAY,-7,GETDATE()) as DATE)
GROUP BY Customer.Activity.CustomerId,Customer.Customer.Username
 HAVING COUNT(Customer.Activity.IpAddress)>1 

end
else if(@TransactionType=11) --Bets Stake> Deposit+Withdrawal last 7 days
begin
		
declare @TempTablee table (CustomerId bigint,Amount money)

insert @TempTablee 
select CustomerId, SUM(Amount) from Customer.[Transaction] where TransactionTypeId=4 and cast(TransactionDate as date)>=cast(DATEADD(DAY,-7,GETDATE()) as date) GROUP BY CustomerId

insert @TempTable
select TT.CustomerId,Username, TT.Amount,'Bets Stake> Deposit+Withdrawal last 7 days' from @TempTablee as TT INNER JOIN Customer.Customer On Customer.Customer.CustomerId=TT.CustomerId 
where Customer.Customer.IsBranchCustomer=0 and TT.Amount>(select  SUM(Amount) from Customer.[Transaction] where Customer.[Transaction].TransactionTypeId in (1,2,7,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,44,46,61,62,55,56,57,58,59,60,64,65) and cast(TransactionDate as date)>=cast(DATEADD(DAY,-7,GETDATE()) as date) and CustomerId=TT.CustomerId)


end
else if(@TransactionType=12) --'Last Login 30 day ago and Balance>0'
begin
		insert @TempTable
		 select CustomerId,Username,Balance,'Last Login 30 day ago and Balance>0' from Customer.Customer where cast(Customer.LastLoginDate as date)<CAST(DATEADD(MONTH,-1,GETDATE()) as date) and Balance>0 
		 ORDER BY Customer.LastLoginDate

end
else if(@TransactionType=13) --'Large Volume Won'
begin
			insert @TempTable
		select Archive.Slip.CustomerId,Username+'- SlipId:'+cast(Archive.Slip.SlipId as nvarchar(50)) as Username,ISNULL(dbo.FuncCurrencyConverter(Archive.Slip.Amount,Archive.Slip.CurrencyId,@UserCurrencyId),0),'Bet Gain'
		 from Archive.Slip with (nolock) INNER JOIN
		  Customer.Customer with (nolock) ON Customer.Customer.CustomerId=Archive.Slip.CustomerId and IsBranchCustomer<>1 and IsTerminalCustomer<>1 
		  where Archive.Slip.SlipStateId in (3)  and ISNULL(dbo.FuncCurrencyConverter(Archive.Slip.Amount,Archive.Slip.CurrencyId,3),0)>=2000
		   and Archive.Slip.CreateDate>=DATEADD(Day,-180,GETDATE()) and TotalOddValue>1
		  order by ISNULL(dbo.FuncCurrencyConverter(Archive.Slip.Amount,Archive.Slip.CurrencyId,@UserCurrencyId),0) desc

end
else if(@TransactionType=14) --Customer sum deposits >= €2000 
begin
		insert @TempTable
			select   customer.DepositTransfer.CustomerId,Username
			,SUM(ISNULL(dbo.FuncCurrencyConverter(customer.DepositTransfer.DepositAmount,customer.DepositTransfer.CurrencyId,3),0)),'Customer sum deposits >= €2000 '
		 from customer.DepositTransfer with (nolock) INNER JOIN
		  Customer.Customer with (nolock) ON Customer.Customer.CustomerId=customer.DepositTransfer.CustomerId and IsBranchCustomer<>1 and IsTerminalCustomer<>1 
		  where customer.DepositTransfer.DepositStatuId=2 
		  --and SUM(ISNULL(dbo.FuncCurrencyConverter(customer.DepositTransfer.DepositAmount,customer.DepositTransfer.CurrencyId,3),0))>=2000
		  GROUP BY Customer.DepositTransfer.CustomerId,Customer.Customer.Username,customer.DepositTransfer.CurrencyId
		  HAVING SUM(ISNULL(dbo.FuncCurrencyConverter(customer.DepositTransfer.DepositAmount,customer.DepositTransfer.CurrencyId,3),0))>2000
		 -- order by SUM(ISNULL(dbo.FuncCurrencyConverter(customer.DepositTransfer.DepositAmount,customer.DepositTransfer.CurrencyId,3),0)) desc
end
else if(@TransactionType=15) --Customer sum withdraw >= €2000 
begin
		insert @TempTable
				select top 20 RiskManagement.WithdrawRequest.CustomerId,Username,ISNULL(dbo.FuncCurrencyConverter(SUM(RiskManagement.WithdrawRequest.Amount),RiskManagement.WithdrawRequest.CurrencyId,3),0),'Customer sum withdraw >= €2000'
		 from RiskManagement.WithdrawRequest  with (nolock) INNER JOIN
		  Customer.Customer with (nolock) ON Customer.Customer.CustomerId=RiskManagement.WithdrawRequest.CustomerId and IsBranchCustomer<>1 and IsTerminalCustomer<>1 
		  where IsApproved=1
		  GROUP BY RiskManagement.WithdrawRequest.CustomerId,Username,RiskManagement.WithdrawRequest.CurrencyId
		  HAVING SUM(ISNULL(dbo.FuncCurrencyConverter(RiskManagement.WithdrawRequest.Amount,RiskManagement.WithdrawRequest.CurrencyId,3),0))>2000
		  --order by ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.[Transaction].Amount),Customer.[Transaction].CurrencyId,@UserCurrencyId),0) desc
end
else if(@TransactionType=16) --'Last Login 12 mounts ago'
begin
		insert @TempTable
		 select CustomerId,Username,Balance,'Last Login 11 mounts ago' from Customer.Customer where cast(Customer.LastLoginDate as date)<CAST(DATEADD(MONTH,-11,GETDATE()) as date) and IsTempLock=0 and IsBranchCustomer<>1 and IsTerminalCustomer<>1 
		 ORDER BY Customer.LastLoginDate

end
else if(@TransactionType=17) --'suspicious transactions'
begin


  declare @tempslip table (CustomerId bigint,SlipAmount money)

			insert @tempslip
		 select CustomerId
		 ,SUM(Amount)/(select Count(distinct cast(Createdate as date)) from Archive.Slip as Cs where Cs.CustomerId=Archive.Slip.CustomerId and Cs.CreateDate>DATEADD(DAY,-7,GETDATE())) 
		 from Archive.Slip  where CustomerId not in (Select CustomerId from Customer.Customer where IsTerminalCustomer=1 or IsBranchCustomer=1)
		  and CreateDate>DATEADD(DAY,-7,GETDATE())  GROUP BY CustomerId


	 
			insert @TempTable
		 select Customer.Slip.CustomerId,Username,SUM(Customer.Slip.Amount),'Daily Slip Amount > Average Daily Slip Amount ('+cast(TMS.SlipAmount as nvarchar(50))+' €)'
		 from Customer.Slip INNER JOIN Customer.Customer On Customer.Slip.CustomerId=Customer.CustomerId INNER JOIN
		 @tempslip as TMS On Tms.CustomerId=Customer.Slip.CustomerId  and Customer.CustomerId=TMS.CustomerId
		 where Customer.Customer.IsTerminalCustomer<>1 and IsBranchCustomer<>1 and cast(Customer.slip.CreateDate as date)=cast(GETDATE() as date)
		 GROUP By Customer.Slip.CustomerId,Username,TMS.SlipAmount
		 HAVING Sum(Customer.Slip.Amount)>TMS.SlipAmount


		   declare @tempslipcount table (CustomerId bigint,SlipCount int)

			insert @tempslipcount
		 select CustomerId
		 ,Count(SlipId)/(select Count(distinct cast(Createdate as date)) from Archive.Slip as Cs where Cs.CustomerId=Archive.Slip.CustomerId and Cs.CreateDate>DATEADD(DAY,-7,GETDATE())) 
		 from Archive.Slip  where CustomerId not in (Select CustomerId from Customer.Customer where IsTerminalCustomer=1 or IsBranchCustomer=1)
		  and CreateDate>DATEADD(DAY,-7,GETDATE())  GROUP BY CustomerId

 
 insert @TempTable
		 select Customer.Slip.CustomerId,Username,Count(Customer.Slip.SlipId),'Daily Slip Count > Average Slip Count ('+cast(TMS.SlipCount as nvarchar(50))+')'
		 from Customer.Slip INNER JOIN Customer.Customer On Customer.Slip.CustomerId=Customer.CustomerId INNER JOIN
		 @tempslipcount as TMS On Tms.CustomerId=Customer.Slip.CustomerId  and Customer.CustomerId=TMS.CustomerId
		 where Customer.Customer.IsTerminalCustomer<>1 and IsBranchCustomer<>1 and cast(Customer.slip.CreateDate as date)=cast(GETDATE() as date)
		 GROUP By Customer.Slip.CustomerId,Username,TMS.SlipCount
		 HAVING Count(Customer.Slip.SlipId)>TMS.SlipCount



	 declare @tempdeposit table (CustomerId bigint,Deposit money)

		 insert @tempdeposit
		 select CustomerId,SUM(DepositAmount)
		 from Customer.DepositTransfer where DepositStatuId=2 and CreateDate>DATEADD(Day,-10,GETDATE()) and cast(CreateDate as date)<cast(GETDATE() as date) GROUP By CustomerId

		 insert @TempTable
		  select Customer.DepositTransfer.CustomerId,Customer.Customer.Username,SUM(DepositAmount),'Daily Deposit Amount > Weekly deposit Amount ('+cast(TMP.Deposit as nvarchar(50))+' €)'
		 from Customer.DepositTransfer with (nolock) INNER JOIN
		  Customer.Customer with (nolock) ON Customer.Customer.CustomerId=customer.DepositTransfer.CustomerId and IsBranchCustomer<>1 and IsTerminalCustomer<>1 
		 INNER JOIN @tempdeposit as TMP On TMP.CustomerId=Customer.DepositTransfer.CustomerId
		 where DepositStatuId=2 and cast(Customer.DepositTransfer.CreateDate as date)=cast(GETDATE() as date) and DepositAmount>TMP.Deposit  GROUP By Customer.DepositTransfer.CustomerId,Customer.Customer.Username,TMP.Deposit

end
select * from @TempTable



END


GO
