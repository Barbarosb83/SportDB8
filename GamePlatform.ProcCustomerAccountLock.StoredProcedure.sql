USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerAccountLock]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerAccountLock] 
@CustomerId bigint,
@LockDayCount int,
@LangId int
AS

BEGIN
SET NOCOUNT ON;

declare @resultcode int=106
declare @resultmessage nvarchar(max)='Error'

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId

update Customer.Customer set IsTempLock=1,TempLockOutdate=DATEADD(DAY,@LockDayCount,GETDATE())
where Customer.Customer.CustomerId=@CustomerId
if (@LockDayCount<>9999)
select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=117 and Log.ErrorCodes.LangId=@LangId
else
select @resultcode=117,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=180 and Log.ErrorCodes.LangId=@LangId
	


	select @resultcode as resultcode,@resultmessage as resultmessage

END


GO
