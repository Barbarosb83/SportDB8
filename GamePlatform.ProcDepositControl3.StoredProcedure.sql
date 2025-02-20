USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcDepositControl3]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcDepositControl3] 
@CustomerId bigint,
@TypeId int,
@LangId int
AS

BEGIN
SET NOCOUNT ON;

declare @Balance money
declare @BranchId bigint
declare @CustomerDepositLimit money=0
select @BranchId=Customer.Customer.BranchId from Customer.Customer where CustomerId=@CustomerId
 
 if(@CustomerId>0)
 begin
if(@BranchId=31673 or @BranchId=32643 or @BranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId=32603 or ParentBranchId=32603 or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId=32603 or ParentBranchId=32603) ))))
begin
	if(@TypeId=1) --Deposit
	begin
	exec  @CustomerDepositLimit=  [dbo].[FuncCustomerDepositLimitControl] @CustomerId,1

select   [Parameter].[PaymentType].[PaymentTypeId]
      ,[PaymentType]
      ,TransactionTypeId as [DepositTypeId]
      , case when @CustomerDepositLimit<MinValue then cast(@CustomerDepositLimit as decimal) else MinValue end as MinValue
	  ,case when @CustomerDepositLimit<MaxValue then cast(@CustomerDepositLimit as decimal) else MaxValue end as MaxValue
	  --,MinValue
	  --,MaxValue
      ,[IsActive]
      ,[RiskLevelId]
      ,[Parameter].[PaymentType].[Description]
	  ,[Title]
	  ,[DescriptionTitle]
	  ,[Parameter].[PaymentTypeDescription].[Description] as DescriptionLong
  FROM [Parameter].[PaymentType] INNER JOIN [Parameter].[PaymentTypeDescription] ON [Parameter].[PaymentType].PaymentTypeId=[Parameter].[PaymentTypeDescription].[PaymentTypeId] and [Parameter].[PaymentTypeDescription].LanguageId=@LangId where IsActive=1 and TypeId=1
	end
	else if(@TypeId=2) --withdraw
			begin
				exec [GamePlatform].[ProcCustomerBonusTrackerInsert]  @CustomerId
				exec  @CustomerDepositLimit=  [dbo].[FuncCustomerDepositLimitControl] @CustomerId,2
		  select   [PaymentTypeId]
			  ,[PaymentType]
			  ,TransactionTypeId as [DepositTypeId]
			 , case when @CustomerDepositLimit<MinValue then cast(@CustomerDepositLimit as decimal) else MinValue end as MinValue
	  ,case when @CustomerDepositLimit<MaxValue then cast(@CustomerDepositLimit as decimal) else MaxValue end as MaxValue
			  ,[IsActive]
			  ,[RiskLevelId]
			  ,[Description]
				,'' as [Title]
			  ,'' as [DescriptionTitle]
			  ,''  as DescriptionLong
		  FROM [Parameter].[PaymentType] where IsActive=1 and TypeId=2
		  end
  end
  end
else
	begin
	if(@TypeId=1) --Deposit
	begin
	--	exec  @CustomerDepositLimit=  [dbo].[FuncCustomerDepositLimitControl] @CustomerId,1

select   [Parameter].[PaymentType].[PaymentTypeId]
      ,[PaymentType]
      ,TransactionTypeId as [DepositTypeId]
      --   , case when @CustomerDepositLimit<MinValue then cast(@CustomerDepositLimit as decimal) else MinValue end as MinValue
	  --,case when @CustomerDepositLimit<MaxValue then cast(@CustomerDepositLimit as decimal) else MaxValue end as MaxValue
	   ,MinValue
	  ,MaxValue
      ,[IsActive]
      ,[RiskLevelId]
      ,[Parameter].[PaymentType].[Description]
	  ,[Title]
	  ,[DescriptionTitle]
	  ,[Parameter].[PaymentTypeDescription].[Description] as DescriptionLong
  FROM [Parameter].[PaymentType] INNER JOIN [Parameter].[PaymentTypeDescription] ON [Parameter].[PaymentType].PaymentTypeId=[Parameter].[PaymentTypeDescription].[PaymentTypeId] and [Parameter].[PaymentTypeDescription].LanguageId=@LangId where IsActive=1 and TypeId=1
	end
	else if(@TypeId=2) --withdraw
  select   [PaymentTypeId]
      ,[PaymentType]
      ,TransactionTypeId as [DepositTypeId]
      ,MinValue
      ,MaxValue
      ,[IsActive]
      ,[RiskLevelId]
      ,[Description]
	     ,'' as [Title]
	  ,'' as [DescriptionTitle]
	  ,''  as DescriptionLong
  FROM [Parameter].[PaymentType] where IsActive=1 and TypeId=2
	end
 

END



GO
