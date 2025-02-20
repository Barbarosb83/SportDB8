USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCustomerCard]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcCustomerCard] 
@CustomerId bigint,
@UserId int,
@LangId int,
@ActivityCode int
AS
BEGIN
SET NOCOUNT ON;

declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
insert dbo.temptabl values(@CustomerId,@UserId,GETDATE(),@ActivityCode)
if @ActivityCode=1 --Control
	begin

		if exists (Select [CustomerCardId] from [Customer].[Card] where [CustomerId]=@CustomerId)
			select @resultcode=-1,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=173 and Log.ErrorCodes.LangId=@LangId
		else
			begin
				select @resultcode=0,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=174 and Log.ErrorCodes.LangId=@LangId
				--INSERT INTO [Customer].[Card]
				--	   ([CustomerId]
				--	   ,[UserId]
				--	   ,[CreateDate])
				-- VALUES
				--	   (
				--	   @CustomerId
				--	   ,@UserId
				--	   ,GETDATE()
				--	   )
			end
	end
else if @ActivityCode=2
	begin
		
			--INSERT INTO [Customer].[Card]
			--		   ([CustomerId]
			--		   ,[UserId]
			--		   ,[CreateDate])
			--	 VALUES
			--		   (
			--		   @CustomerId
			--		   ,@UserId
			--		   ,GETDATE()
			--		   )

					   	select @resultcode=1,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
	end



	
	select @resultcode as resultcode,@resultmessage as resultmessage



END



GO
