USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Dashboard].[ProcDailyNewCustomerStats]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Dashboard].[ProcDailyNewCustomerStats] 
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


declare @NewCustomerDailyCount int
declare @NewCustomerDailyDeposit money
declare @NewCustomerDailyBetStake money
declare @NewCustomerDailySlipCount int


if(@UserBranchId=1)
	begin
		select @NewCustomerDailyCount=count(Customer.CustomerId) from Customer.Customer with (nolock) where cast(Customer.CreateDate as date)=CAST(GETDATE() as date)


		SELECT  @NewCustomerDailyDeposit= SUM(Customer.[Transaction].Amount)
		FROM         Customer.Customer with (nolock) INNER JOIN
							  Customer.[Transaction] with (nolock) ON Customer.Customer.CustomerId = Customer.[Transaction].CustomerId INNER JOIN
							  Parameter.TransactionType with (nolock) ON Customer.[Transaction].TransactionTypeId = Parameter.TransactionType.TransactionTypeId and IsBranchCustomer=0
		WHERE     (Parameter.TransactionType.TransactionTypeId in (1,11,13,15,17,19,21,23,25,27,29,30,32,64,59,57,46)) and  cast(Customer.Customer.CreateDate as date)=CAST(GETDATE() as date)
		GROUP BY Customer.[Transaction].CurrencyId


		SELECT    @NewCustomerDailySlipCount=COUNT(Customer.Slip.SlipId),
		@NewCustomerDailyBetStake=SUM(Customer.Slip.Amount)
		FROM         Customer.Slip  with (nolock) INNER JOIN
							  Customer.Customer with (nolock)  ON Customer.Slip.CustomerId = Customer.Customer.CustomerId and IsBranchCustomer=0
		WHERE     Customer.Slip.SlipStatu in (1,3) and  cast(Customer.Customer.CreateDate as date)=CAST(GETDATE() as date)

	end
else
	begin
		select @NewCustomerDailyCount=count(Customer.CustomerId) from Customer.Customer with (nolock) where cast(Customer.CreateDate as date)=CAST(GETDATE() as date) and Customer.BranchId=@UserBranchId


		SELECT  @NewCustomerDailyDeposit= SUM(Customer.[Transaction].Amount) 
		FROM         Customer.Customer with (nolock) INNER JOIN
							  Customer.[Transaction] with (nolock) ON Customer.Customer.CustomerId = Customer.[Transaction].CustomerId INNER JOIN
							  Parameter.TransactionType with (nolock) ON Customer.[Transaction].TransactionTypeId = Parameter.TransactionType.TransactionTypeId and IsBranchCustomer=0
		WHERE     (Parameter.TransactionType.TransactionTypeId in (1,11,13,15,17,19,21,23,25,27,29,30,32,64,59,57,46)) and  cast(Customer.Customer.CreateDate as date)=CAST(GETDATE() as date) and Customer.BranchId=@UserBranchId
		GROUP BY Customer.[Transaction].CurrencyId

		SELECT    @NewCustomerDailySlipCount=COUNT(Customer.Slip.SlipId),
		@NewCustomerDailyBetStake= SUM(Customer.Slip.Amount ) 
		FROM         Customer.Slip with (nolock) INNER JOIN
							  Customer.Customer with (nolock) ON Customer.Slip.CustomerId = Customer.Customer.CustomerId and IsBranchCustomer=0
		WHERE     Customer.Slip.SlipStatu in (1,3) and  cast(Customer.Customer.CreateDate as date)=CAST(GETDATE() as date) and Customer.BranchId=@UserBranchId

	end	


select @NewCustomerDailyCount as NewCustomerCount
,@NewCustomerDailyDeposit as NewCustomerDeposit
,@NewCustomerDailyBetStake as NewCustomerBetstake
,@NewCustomerDailySlipCount as NewCustomerSlipCount


END



GO
