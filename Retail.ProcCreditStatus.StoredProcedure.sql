USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCreditStatus]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcCreditStatus] 
@BranchId int,
@UserId int,
@LangId int
AS
BEGIN
SET NOCOUNT ON;



declare @UserCurrencyId int


--declare @SystemCurrencyId int
--select top 1 @SystemCurrencyId=SystemCurrencyId from General.Setting 
--select  @UserCurrencyId=Users.Users.CurrencyId from Users.Users with (nolock) where Users.Users.UserId=@UserId
declare @CreditLimit money=0
declare @CreditLimit1 money=0
declare @CreditAvailable money=0
declare @CreditCurrent money=0


select    @CreditLimit= SUM(Amount)  from RiskManagement.BranchDepositRequest with (nolock) where BranchId=@BranchId and TransactionTypeId=3 and IsApproved=1 GROUP BY CurrencyId
	select    @CreditLimit1= SUM(Amount)  from RiskManagement.BranchDepositRequest with (nolock) where BranchId=@BranchId and TransactionTypeId=5 and IsApproved=1 GROUP BY CurrencyId
set @CreditLimit=@CreditLimit-@CreditLimit1

select @CreditAvailable= Balance   from Parameter.Branch with (nolock) where BranchId=@BranchId


set @CreditCurrent=@CreditLimit-@CreditAvailable


select @CreditCurrent as CreditCurrent,@CreditLimit as CreditLimit,@CreditAvailable as CreditAvailable



END



GO
