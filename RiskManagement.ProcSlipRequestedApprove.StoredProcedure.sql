USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSlipRequestedApprove]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcSlipRequestedApprove] 
@SlipId bigint,
@IsApproved bit,
@Username nvarchar(50)
AS

BEGIN
SET NOCOUNT ON;

declare @UserId int

select @UserId=Users.Users.UserId from Users.Users where Users.Users.UserName=@Username

if(@IsApproved=1)
begin
	update Customer.Slip set Customer.Slip.SlipStatu=3 where Customer.Slip.SlipId=@SlipId
	insert Customer.SlipHistory(SlipOddId,ActionType,ActionDate,UserId)
	values(@SlipId,1,GETDATE(),@UserId)
end
Else
begin
update Customer.Slip set Customer.Slip.SlipStatu=4 where Customer.Slip.SlipId=@SlipId
	insert Customer.SlipHistory(SlipOddId,ActionType,ActionDate,UserId)
	values(@SlipId,2,GETDATE(),@UserId)
	
	declare @Amount money
	declare @CustomerId bigint
	
	select @Amount=Customer.Slip.Amount,@CustomerId=Customer.Slip.CustomerId from Customer.Slip where Customer.Slip.SlipId=@SlipId
	
	update Customer.Customer set Customer.Customer.Balance=Customer.Customer.Balance+@Amount where Customer.Customer.CustomerId=@CustomerId
	
	
	
end

select 1

END


GO
