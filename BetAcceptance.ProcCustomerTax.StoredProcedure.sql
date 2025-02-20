USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[ProcCustomerTax]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [BetAcceptance].[ProcCustomerTax] 
@CustomerId bigint,
@SlipId bigint,
@TotalAmount money,
@SlipAmount money,
@TaxAmount money,
@CurrencyId int,
@TransactionTypeId int,
@TaxStatusId int,
@SourceId int
AS

BEGIN
SET NOCOUNT ON;


declare @IsBranchCustomer bit=0
declare @BranchId bigint=0
declare @Balance money=0
--declare @SlipType int=0

select @CurrencyId=Customer.Customer.CurrencyId,@IsBranchCustomer=IsBranchCustomer,@BranchId=BranchId,@Balance=Balance from Customer.Customer with (nolock) where Customer.Customer.CustomerId=@CustomerId
--select @SlipType=Customer.Slip.SlipTypeId from Customer.Slip where Customer.Slip.SlipId=@SlipId

--if(@SlipType<>3)
--begin
 insert Customer.Tax ([CustomerId],[SlipId],[TotalAmount],[SlipAmount],[TaxAmount],[CurrencyId],[TransactionTypeId],[TaxStatusId],SourceId,CreateDate,SlipTypeId)
 values (
 @CustomerId
 ,@SlipId
 ,@TotalAmount
 ,@SlipAmount
 ,@TaxAmount
 ,@CurrencyId
 ,@TransactionTypeId
 ,@TaxStatusId
 ,@SourceId
 ,GETDATE()
 ,2
 )





insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment,TransactionBalance)
values(@CustomerId,@TaxAmount,@CurrencyId,GETDATE(),@TransactionTypeId,1,cast(@SlipId as nvarchar(20)),@Balance-@TaxAmount)

if(@IsBranchCustomer=0)
begin
--select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer where Customer.CustomerId=@CustomerId


--set @Balance=@Balance-@TaxAmount

update Customer.Customer set Balance=Balance-@TaxAmount where CustomerId=@CustomerId
end
else
begin
--select @Balance=Parameter.Branch.Balance from  Parameter.Branch where Parameter.Branch.BranchId=@BranchId
--set @Balance=@Balance-@TaxAmount
update Parameter.Branch set Balance=Balance-@TaxAmount where Parameter.Branch.BranchId=@BranchId





end
--end

select @Balance as Balance

END


GO
