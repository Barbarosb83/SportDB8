USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBranchQrControl]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [Retail].[ProcBranchQrControl]
@BranchId bigint,
@LangId int



AS




BEGIN
SET NOCOUNT ON;

		declare @CustomerId bigint=0
		declare @CustomerBranchId bigint=0

		if  exists (Select BranchId from  [Customer].[QrCode] where [BranchId]=@BranchId)
		begin
		select @CustomerId = CustomerId from  [Customer].[QrCode] where [BranchId]=@BranchId
		
				select @CustomerBranchId = BranchId from Customer.Customer where CustomerId=@CustomerId
			if (@CustomerBranchId = (@BranchId) or @CustomerBranchId in (Select BranchId from Parameter.Branch where ParentBranchId=@BranchId)  or @CustomerBranchId in  ( Select ParentBranchId from Parameter.Branch where BranchId=@BranchId))
			begin
				select @CustomerId = CustomerId from  [Customer].[QrCode] where [BranchId]=@BranchId
		
				select @CustomerBranchId = BranchId from Customer.Customer where CustomerId=@CustomerId
				delete from  [Customer].[QrCode] where [BranchId]=@BranchId
				select @CustomerId as CustomerId,'Success' as ResultMessage
			end
			else
				begin
					delete from  [Customer].[QrCode] where [BranchId]=@BranchId
				select CAST(-1 as bigint) as CustomerId,'Customer is not affiliated with this dealer' as ResultMessage
				end
		end
		else
			select @CustomerId as CustomerId,'' as ResultMessage


 

END





GO
