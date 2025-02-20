USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerWithDrawRequestScreen]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerWithDrawRequestScreen] 
	@CustomerId bigint,
 
	@TransactionType int
 
AS

BEGIN
SET NOCOUNT ON;

 
 declare @IsActive bit=0
 declare @IsChange bit=0
if exists (Select Customer.WithDrawRequest.CustomerWithdrawId from Customer.WithDrawRequest where CustomerId=@CustomerId and TransactionTypeId=@TransactionType)
	begin
		 
		 Select @IsActive= Customer.WithDrawRequest.IsActive,@IsChange = case when CreateDate<=DATEADD(DAY,-7,GETDATE()) then 1 else 0 end from Customer.WithDrawRequest where CustomerId=@CustomerId and TransactionTypeId=@TransactionType

		 SELECT  
       [CustomerId]
      
      ,[Amount]
      ,[CurrencyId]
      ,[TransactionType]
      
      ,[AccountId]
      ,[BankId]
      ,[CustomerNote]
     ,@IsActive as IsActive
	 ,@IsChange as IsChange
  FROM [RiskManagement].[WithdrawRequestAuto] where CustomerId=@CustomerId and TransactionType=@TransactionType


	end
else
	begin
	 		 SELECT  
       @CustomerId as [CustomerId]
      
      , CAST(0 as money) [Amount]
      ,CAST(3 as int) [CurrencyId]
      ,@TransactionType as [TransactionType]
      
      ,'' as [AccountId]
      ,CAST(1 as int) as [BankId]
      ,'' as [CustomerNote]
     ,@IsActive as IsActive
	 ,CAST(1 as bit) as IsChange

	end
	 

END


GO
