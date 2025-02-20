USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerCheckForgetPasswordCode]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerCheckForgetPasswordCode] 
@RecoveryCode char(36),
@LangId int
AS

BEGIN
SET NOCOUNT ON;

declare @resultcode int=116
declare @resultmessage nvarchar(max)='Hata oluştu'


select @resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId

--select @resultcode as resultcode,@resultmessage as resultmessage

declare @cid bigint
select @cid=Customer.CustomerId from Customer.Customer where (Customer.Customer.RecoveryCode=@RecoveryCode) and datediff(minute,Customer.Customer.RecoveryDate,GETDATE())<30

if(@cid is not null)
	begin
	
		--update Customer.Customer set Customer.RecoveryCode=null,RecoveryDate=null,IsActive=1
		--where Customer.CustomerId=@cid
		
		select @resultcode=@cid,@resultmessage='OK'
	end

select @resultcode as resultcode,@resultmessage as resultmessage

End


GO
