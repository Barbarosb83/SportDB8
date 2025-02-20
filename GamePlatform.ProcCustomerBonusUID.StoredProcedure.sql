USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerBonusUID]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerBonusUID] 
@CustomerId bigint,
@BonusId  int,
@IsEnable bit,
@ActivityCode int
AS

BEGIN
SET NOCOUNT ON;

declare @ResultCode int=1
declare @ResultMessage nvarchar(100)

if(@ActivityCode=1)
begin
	update Customer.BonusRequest set IsEnable=@IsEnable where CustomerId=@CustomerId and BonusId=@BonusId
end

else if (@ActivityCode=2)
begin
		insert Customer.BonusRequest (CustomerId,IsEnable,CreateDate,BonusId,BonusStartDate) values(@CustomerId,@IsEnable,GETDATE(),@BonusId,GETDATE())
		set @ResultCode=1
		set @ResultMessage=''
end
else if (@ActivityCode=3)
begin
		if exists (select Customer.BonusRequest.BonusRequestId from  Customer.BonusRequest where CustomerId=@CustomerId and BonusId=@BonusId)
			begin
			set @ResultCode=2
			--select  @ResultMessage= CONVERT(VARCHAR, CreateDate, 104) + ' ' + CONVERT(VARCHAR, DATEPART(hh, CreateDate)) + ':' + RIGHT('0' + CONVERT(VARCHAR, DATEPART(mi, CreateDate)), 2) from  Customer.BonusRequest where CustomerId=@CustomerId and BonusId=@BonusId
			select  @ResultMessage= cast(CreateDate as nvarchar(100)) from  Customer.BonusRequest where CustomerId=@CustomerId and BonusId=@BonusId
			end
		else 
			set @ResultCode=-1
end
 
	


select @ResultCode as result,@ResultMessage as resultcode

END



GO
