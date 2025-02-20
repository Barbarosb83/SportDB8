USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Dashboard].[ProcTop10CustomerBetStake]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Dashboard].[ProcTop10CustomerBetStake] 
@Username nvarchar(50)
AS

BEGIN
SET NOCOUNT ON;


declare @UserCurrencyId int
declare @UserBranchId int
select @UserCurrencyId=Users.Users.CurrencyId,
@UserBranchId=Users.Users.UnitCode
from Users.Users 
 where Users.Users.UserName=@Username

declare @temptable table (CustomerId bigint,Customer nvarchar(150),Stake money)



if(@UserBranchId=1)
	begin
	insert  @temptable
SELECT top 10  Customer.CustomerId,Customer.CustomerName+' '+Customer.CustomerSurname+' ('+Customer.Username+')' as Customer
, SUM(Customer.Slip.Amount) as Stake  
FROM         Customer.Customer with (nolock) INNER JOIN
		Customer.Slip with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId and IsBranchCustomer=0
		--where cast(Customer.Slip.CreateDate as date)>cast(DATEADD(DAY,-7,GETDATE()) as date) and cast(Customer.Slip.CreateDate as date)<=cast(GETDATE() as date)
GROUP BY Customer.CustomerId,Customer.CustomerName+' '+Customer.CustomerSurname+' ('+Customer.Username+')',Customer.Slip.CurrencyId
ORDER BY SUM(Customer.Slip.Amount) desc

--insert  @temptable
--SELECT top 10  Customer.CustomerId,Customer.CustomerName+' '+Customer.CustomerSurname+' ('+Customer.Username+')' as Customer
--,dbo.FuncCurrencyConverter(SUM(Archive.Slip.Amount),Archive.Slip.CurrencyId,@UserCurrencyId) as Stake  
--FROM         Customer.Customer with (nolock) INNER JOIN
--		Archive.Slip with (nolock) on Archive.Slip.CustomerId=Customer.Customer.CustomerId
--		where cast(Archive.Slip.CreateDate as date)>cast(DATEADD(DAY,-7,GETDATE()) as date) and cast(Archive.Slip.CreateDate as date)<=cast(GETDATE() as date)
--GROUP BY Customer.CustomerId,Customer.CustomerName+' '+Customer.CustomerSurname+' ('+Customer.Username+')',Archive.Slip.CurrencyId
--ORDER BY SUM(Archive.Slip.Amount) desc


end
else
	begin
	insert  @temptable
SELECT top 10  Customer.CustomerId,Customer.CustomerName+' '+Customer.CustomerSurname+' ('+Customer.Username+')' as Customer
, SUM(Customer.Slip.Amount)  as Stake  
FROM         Customer.Customer with (nolock) INNER JOIN
		Customer.Slip with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId and IsBranchCustomer=0
		where Customer.BranchId=@UserBranchId and cast(Customer.Slip.CreateDate as date)>cast(DATEADD(DAY,-7,GETDATE()) as date) and cast(Customer.Slip.CreateDate as date)<=cast(GETDATE() as date)
GROUP BY Customer.CustomerId,Customer.CustomerName+' '+Customer.CustomerSurname+' ('+Customer.Username+')',Customer.Slip.CurrencyId
ORDER BY SUM(Customer.Slip.Amount) desc

	insert  @temptable
SELECT top 10  Customer.CustomerId,Customer.CustomerName+' '+Customer.CustomerSurname+' ('+Customer.Username+')' as Customer
, SUM(Archive.Slip.Amount) as Stake  
FROM         Customer.Customer with (nolock) INNER JOIN
		Archive.Slip with (nolock) on Archive.Slip.CustomerId=Customer.Customer.CustomerId and IsBranchCustomer=0
		where Customer.BranchId=@UserBranchId and cast(Archive.Slip.CreateDate as date)>cast(DATEADD(DAY,-7,GETDATE()) as date) and cast(Archive.Slip.CreateDate as date)<=cast(GETDATE() as date)
GROUP BY Customer.CustomerId,Customer.CustomerName+' '+Customer.CustomerSurname+' ('+Customer.Username+')',Archive.Slip.CurrencyId
ORDER BY SUM(Archive.Slip.Amount) desc
end


select  top 10 CustomerId,Customer,ISNULL(SUM(Stake),0) AS Stake from @temptable GROUP BY CustomerId,Customer order by SUM(Stake) desc

END



GO
