USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSlipInfoTransfer]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcSlipInfoTransfer] 
 @TransferTypeId int --1 first slips , 2  300€ plus slips
AS
BEGIN
SET NOCOUNT ON;
 

declare @Stardate datetime


select top 1 @Stardate=  [TransferDate]      
  FROM [Parameter].[BetTransferDate] with (nolock) where [TransferType]=@TransferTypeId


  delete from [Parameter].[BetTransferDate] where [TransferType]=@TransferTypeId


INSERT INTO [Parameter].[BetTransferDate]
           ([TransferDate]
           ,[TransferType])
     VALUES (GETDATE(),@TransferTypeId)

	 declare @TempTable table (SlipId bigint,CustomerId bigint,Amount money,BetDate datetime,SettlementDate datetime,TerminalId int)

	 declare @RemoveCustomerList table ( CustomerId bigint)

			declare @SlipList table (SlipId bigint,CustomerId bigint)

	 if(@TransferTypeId=1) -- Müşterilerin Günlük ilk Kuponları
		begin
			
			
				
			insert @RemoveCustomerList
				select DISTINCT CustomerId from Customer.Slip with (nolock) where cast(CreateDate as date)>cast(DATEADD(DAY,-1,GETDATE()) as date) and CreateDate<=@Stardate 

				insert @SlipList
				select  MIN(SlipId), CustomerId from Customer.Slip with (nolock) where CreateDate>@Stardate and CreateDate<=GETDATE() and CustomerId not in (select CustomerId from @RemoveCustomerList) and CustomerId not in (Select CustomerId from Customer.customer where (IsTerminalCustomer=1 or IsBranchCustomer=1))  GROUP BY CustomerId

				select Customer.Slip.*,ISNULL(Customer.Customer.OasisId,'') as ApiId
				,Customer.BranchId as TransactionBranchId
				--,ISNULL((select top 1 BranchId from RiskManagement.BranchTransaction with (nolock) where SlipId=Customer.Slip.SlipId),32643) as TransactionBranchId
,Customer.CustomerName,Customer.CustomerSurname,Customer.City,Customer.Birthday,Customer.ZipCode,Customer.Email,Customer.BranchId
from Customer.Slip  with (nolock)  INNER JOIN Customer.Customer  with (nolock)  On Customer.CustomerId=Customer.Slip.CustomerId where SlipId in (select SlipId from @SlipList) and BranchId not in (31673,31620 )
			

		end
	else if  (@TransferTypeId=100) --  ilk login
		begin
			 

			
						insert @RemoveCustomerList
			select DISTINCT CustomerId from Customer.Customer with (nolock) where cast(LastLoginDate as date)>cast(DATEADD(DAY,-1,GETDATE()) as date) and LastLoginDate<=@Stardate 

	  
				 
				select   CustomerId,ISNULL(Customer.Customer.OasisId,'') as ApiId,BranchId as  TransactionBranchId
				,Customer.CustomerName,Customer.CustomerSurname,Customer.City,Customer.Birthday,Customer.ZipCode,Customer.Email,Customer.BranchId
				 from Customer.Customer with (nolock) where LastLoginDate>@Stardate and LastLoginDate<=GETDATE() and BranchId not in (31673,31620 ) and CustomerId not in (select CustomerId from @RemoveCustomerList)   order by CustomerId 
			

		end
	else
		begin
				select Customer.Slip.*,ISNULL(Customer.Customer.OasisId,'') as ApiId
				,ISNULL((select top 1 BranchId from RiskManagement.BranchTransaction with (nolock) where SlipId=Customer.Slip.SlipId),32643) as TransactionBranchId
				,Customer.CustomerName,Customer.CustomerSurname,Customer.City,Customer.Birthday,Customer.ZipCode,Customer.Email,Customer.BranchId
				from Customer.Slip  with (nolock)  INNER JOIN Customer.Customer  with (nolock)  On Customer.CustomerId=Customer.Slip.CustomerId where Amount>300 and 
				Customer.Slip.CreateDate>@Stardate and Customer.Slip.CreateDate<=GETDATE() and BranchId not in (31673,31620 )  and Customer.CustomerId not in (Select CustomerId from Customer.customer where (IsTerminalCustomer=1 or IsBranchCustomer=1))
			

		end



END




     --bet.betId = result.ToString();
     --                           bet.bookingId = "00000";
     --                           bet.fileId = "aaaaaaa-aaa";
     --                           bet.certId = "aaaaa";
     --                           bet.amount = Amount;
     --                           bet.playerId = CustomerId.ToString();
     --                           bet.currency = "EUR";
     --                           bet.betDate = DateTime.Now.ToString();
     --                           bet.settlementDate = DateTime.Now.ToString();
     --                           bet.terminalId = CustomerId.ToString();
     --                           bet.cancellationDate = DateTime.Now.ToString();
     --                           //   bet.channel = chanell;
     --                           bet.partnerId = "f83bee26-7586-4553-a7a1-4c20c6adb83a";
GO
