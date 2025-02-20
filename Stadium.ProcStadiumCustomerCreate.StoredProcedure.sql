USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Stadium].[ProcStadiumCustomerCreate]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

 
CREATE PROCEDURE [Stadium].[ProcStadiumCustomerCreate] 
@StadiumId bigint,
@CustomerId bigint,
@SlipId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'

 
 
if not exists (select Stadium.Customers.StadiumId from Stadium.Customers where Stadium.Customers.StadiumId=@StadiumId and Stadium.Customers.CustomerId=@CustomerId)
	begin

			INSERT INTO [Stadium].[Customers]
           ([StadiumId]
           ,[CustomerId]
           ,[SlipId]
           ,[CreateDate]
           ,[CardChangeCount])
     VALUES
           (@StadiumId,@CustomerId,@SlipId,GETDATE(),0)

		   	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId

	end
else
		select @resultcode=-1,@resultmessage='Not insert' from Log.ErrorCodes where ErrorCodeId=106 and Log.ErrorCodes.LangId=@LangId

		select @resultcode as resultcode,@resultmessage as resultmessage

END


GO
