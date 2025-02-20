USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerStatus]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcCustomerStatus]
@Email nvarchar(150),
@Status int,
@ActivityCode int


AS




BEGIN
SET NOCOUNT ON;

declare @CustomerId bigint

select @CustomerId=Customer.Customer.CustomerId from Customer.Customer with (nolock) where Email=@Email
 
if @ActivityCode=1
	begin
		if(@Status=1) -- Sanction
		update Customer.PEPControl set IsSanction=1,IsDoc=0,UpdateDate=GETDATE() where CustomerId=@CustomerId 

		if(@Status=2) -- Document
		update Customer.PEPControl set IsSanction=1,IsDoc=1,UpdateDate=GETDATE() where CustomerId=@CustomerId 
	 if (@Status=-1)
		update Customer.Customer set IsActive=0,IsActiveChangeDate=GETDATE(),IsActiveChangeUser='Darmstadt' where CustomerId=@CustomerId
	
	
	end
--if @ActivityCode=2
--	begin

	
--	select Case when Customer.PEPControl.IsSanction=0 then 0 Else 
--	case when  Customer.PEPControl.IsSanction=1 then 1 else
--	case when Customer.PEPControl.IsDoc=0 then 1 else 2 end end end as CustomerStatus
--	from Customer.PEPControl where CustomerId=@CustomerId
	 
--	end
	
--	if @ActivityCode=3
--	begin

--	--	exec [Log].ProcConcatOldValues  'BranchBetTypeCommision','[RiskManagement]','BranchBetTypeCommisionId',@BranchBetTypeCommisionId,@OldValues output
	
--	--exec [Log].[ProcTransactionLogUID]  37,@ActivityCode,@Username,@BranchBetTypeCommisionId,'RiskManagement.BranchBetTypeCommision'
--	--,null,@OldValues
	
--	delete from [RiskManagement].[Ticket] where TicketId=@TicketId
	
--	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId
	
	
--	end
 
 
   if(	select  case when Customer.BranchId=32643 then Case when Customer.PEPControl.IsSanction=0  then 0 Else 
	case when  Customer.PEPControl.IsDoc=1  then 2 else
	case when Customer.PEPControl.IsSanction=1   then 1 else 0 end end end else 2 end as CustomerStatus
	from Customer.PEPControl inner join Customer.Customer on Customer.CustomerId=Customer.PepControl.CustomerId   where Customer.PepControl.CustomerId=@CustomerId
)=0
begin
	update Customer.StakeLimit set StakeDay=100,StakeMonth=100,StakeWeek=100,DepositDay=100,DepositWeek=700,DepositMonth=3000 where CustomerId=@CustomerId and UpdateUser is null
	
end
else if (	select  case when Customer.BranchId=32643 then Case when Customer.PEPControl.IsSanction=0  then 0 Else 
	case when  Customer.PEPControl.IsDoc=1  then 2 else
	case when Customer.PEPControl.IsSanction=1   then 1 else 0 end end end else 2 end as CustomerStatus
	from Customer.PEPControl inner join Customer.Customer on Customer.CustomerId=Customer.PepControl.CustomerId   where Customer.PepControl.CustomerId=@CustomerId
)=2
begin

update Customer.Document set DocumentStatus=2 where CustomerId=@CustomerId

update Customer.StakeLimit set LimitPerLiveTicket= case when LimitPerLiveTicket<500 then 500 else LimitPerLiveTicket end,LimitPerTicket= case when LimitPerTicket<500 then 500 else LimitPerTicket end, StakeDay=30000,StakeMonth=case when StakeMonth<30000 then  30000 else 300000 end,StakeWeek=case when StakeWeek<30000 then  30000 else 300000 end,DepositDay=30000,DepositWeek=30000,DepositMonth=30000
 where CustomerId=@CustomerId   and UpdateUser is null

 end

		select  case when Customer.BranchId=32643 then Case when Customer.PEPControl.IsSanction=0  then 0 Else 
	case when  Customer.PEPControl.IsDoc=1  then 2 else
	case when Customer.PEPControl.IsSanction=1   then 1 else 0 end end end else 2 end as CustomerStatus
	from Customer.PEPControl inner join Customer.Customer on Customer.CustomerId=Customer.PepControl.CustomerId   where Customer.PepControl.CustomerId=@CustomerId
   
	

END




GO
