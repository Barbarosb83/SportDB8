USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcDepositControl2]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [GamePlatform].[ProcDepositControl2] 
@CustomerId bigint,
@TypeId int
AS

BEGIN
SET NOCOUNT ON;

declare @Balance money
declare @BranchId bigint

select @BranchId=Customer.Customer.BranchId from Customer.Customer where CustomerId=@CustomerId
 
 if(@CustomerId>0)
 begin
if(@BranchId=31673  or @BranchId=32643 or @BranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId=32603 or ParentBranchId=32603 or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId=32603 or ParentBranchId=32603) ))))
begin
	if(@TypeId=1) --Deposit
select   [PaymentTypeId]
      ,[PaymentType]
      ,TransactionTypeId as [DepositTypeId]
      ,MinValue
      ,MaxValue
      ,[IsActive]
      ,[RiskLevelId]
      ,[Description]
  FROM [Parameter].[PaymentType] where IsActive=1 and TypeId=1
	else if(@TypeId=2) --withdraw
  select   [PaymentTypeId]
      ,[PaymentType]
      ,TransactionTypeId as [DepositTypeId]
      ,MinValue
      ,MaxValue
      ,[IsActive]
      ,[RiskLevelId]
      ,[Description]
  FROM [Parameter].[PaymentType] where IsActive=1 and TypeId=2
  end
  end
else
	begin
	if(@TypeId=1) --Deposit
select   [PaymentTypeId]
      ,[PaymentType]
      ,TransactionTypeId as [DepositTypeId]
      ,MinValue
      ,MaxValue
      ,[IsActive]
      ,[RiskLevelId]
      ,[Description]
  FROM [Parameter].[PaymentType] where IsActive=1 and TypeId=1
	else if(@TypeId=2) --withdraw
  select   [PaymentTypeId]
      ,[PaymentType]
      ,TransactionTypeId as [DepositTypeId]
      ,MinValue
      ,MaxValue
      ,[IsActive]
      ,[RiskLevelId]
      ,[Description]
  FROM [Parameter].[PaymentType] where IsActive=1 and TypeId=2
	end
 

END



GO
