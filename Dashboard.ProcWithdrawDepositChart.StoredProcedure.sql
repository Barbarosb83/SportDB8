USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Dashboard].[ProcWithdrawDepositChart]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Dashboard].[ProcWithdrawDepositChart] 
@Username nvarchar(50)
AS

BEGIN
SET NOCOUNT ON;


declare @UserCurrencyId int


declare @UserBranchId int
declare @RoleId int


select top 1  @RoleId=Users.UserRoles.RoleId, @UserCurrencyId=Users.Users.CurrencyId,
@UserBranchId=Users.Users.UnitCode
from Users.Users INNER JOIN Users.UserRoles ON Users.UserRoles.UserId=Users.Users.UserId 
where Users.Users.UserName=@Username



declare @SystemCurrencyId int
declare @temptable table(reportdate date,deposit money,withdraw money)

select top 1  @SystemCurrencyId= Parameter.Branch.CurrencyId from Parameter.Branch where BranchId=1




if(@UserBranchId=1)
	begin


		insert @temptable
		SELECT    cast(Customer.[Transaction].TransactionDate as date)
			,SUM( Amount)
			,0
From   Customer.[Transaction] with (nolock)
		WHERE      ( Customer.[Transaction] .TransactionTypeId in (1,64,67,68,69,70,71,72,74)) and cast(Customer.[Transaction].TransactionDate as date)>DATEADD(MONTH,-2,GETDATE())
		GROUP BY  cast(Customer.[Transaction].TransactionDate as date)

		insert @temptable
			SELECT    cast(Customer.[Transaction].TransactionDate as date)
			,0
			,SUM( Amount)
From   Customer.[Transaction]  with (nolock)
		WHERE      ( Customer.[Transaction] .TransactionTypeId in (2,31,65,66,73)) and cast(Customer.[Transaction].TransactionDate as date)>DATEADD(MONTH,-2,GETDATE())
		GROUP BY  cast( Customer.[Transaction].TransactionDate as date)
	end
else
	begin

		insert @temptable
		SELECT     cast(Customer.[Transaction].TransactionDate as date)
		, SUM(Customer.[Transaction].Amount)
		,0
From Parameter.TransactionType with (nolock) INNER JOIN 
	Customer.[Transaction] with (nolock) ON Customer.[Transaction].TransactionTypeId=Parameter.TransactionType.TransactionTypeId
		WHERE      Parameter.TransactionType.TransactionTypeId in (1,7,9,11,13,15,17,19,21,23,25,27,29,30,32,64,59,57,46) and Parameter.TransactionType.TransactionTypeId<>4 and Customer.[Transaction].CustomerId in (select Customer.Customer.CustomerId from Customer.Customer where Customer.BranchId=@UserBranchId)
		GROUP BY   cast(Customer.[Transaction].TransactionDate as date)

		insert @temptable
		SELECT   cast(Customer.[Transaction].TransactionDate as date),0
		, SUM(Customer.[Transaction].Amount)
From Parameter.TransactionType with (nolock) INNER JOIN 
	Customer.[Transaction] with (nolock) ON Customer.[Transaction].TransactionTypeId=Parameter.TransactionType.TransactionTypeId
		WHERE     Parameter.TransactionType.TransactionTypeId in (2,6,12,14,16,18,20,22,24,26,28,31,58,60,65,66,62) and Parameter.TransactionType.TransactionTypeId<>3 and Customer.[Transaction].CustomerId in (select Customer.Customer.CustomerId from Customer.Customer where Customer.BranchId=@UserBranchId)
		GROUP BY   cast(Customer.[Transaction].TransactionDate as date)
	end



if(@RoleId<>156)
begin
select reportdate,SUM(deposit) as deposit,SUM(withdraw) as withdraw
from @temptable
GROUP BY reportdate
end
else
begin
select reportdate,SUM(deposit)/5 as deposit,SUM(withdraw)/5 as withdraw
from @temptable
GROUP BY reportdate
end

END



GO
