USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcTerminalQrControl]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Retail].[ProcTerminalQrControl]
@TerminalId bigint,
@LangId int



AS


--insert dbo.betslip values (@TerminalId,'QR:'+cast(@LangId as nvarchar(50)),GETDATE())
 


BEGIN
SET NOCOUNT ON;

		declare @CustomerId bigint=0
		declare @CustomerBranchId bigint=0

		if  exists (Select BranchId from  [Customer].[QrCode] where [BranchId]=@TerminalId)
		begin
		select @CustomerId = CustomerId from  [Customer].[QrCode] where [BranchId]=@TerminalId
		select @CustomerBranchId= BranchId from Customer.Customer where CustomerId=@customerId 

			if (@CustomerBranchId = (@TerminalId) or @CustomerBranchId in (Select BranchId from Parameter.Branch where ParentBranchId=@TerminalId)  or @CustomerBranchId in  ( Select ParentBranchId from Parameter.Branch where BranchId=@TerminalId))
			begin
				select top 1 @CustomerId = CustomerId from  [Customer].[QrCode] where [BranchId]=@TerminalId order by CreateDate desc
		
				select @CustomerBranchId = BranchId from Customer.Customer where CustomerId=@CustomerId
				delete from  [Customer].[QrCode] where [BranchId]=@TerminalId
				select @CustomerId as CustomerId,'Success' as ResultMessage
			end
			else
				begin
				set @CustomerId = -1
					delete from  [Customer].[QrCode] where [BranchId]=@TerminalId
				select @CustomerId as CustomerId,'Customer is not affiliated with this dealer' as ResultMessage
				end
		end
		else
			select @CustomerId as CustomerId,'' as ResultMessage


 

END





GO
