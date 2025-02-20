USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerDocumentUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcCustomerDocumentUID] 
@DocumentId bigint,
@DocumentStatu int,
@DocExpriedDate datetime,
@UserId int,
@LangId int,
@Username nvarchar(50),
@ActivityCode int,
@NewValues nvarchar(max)
AS

BEGIN
SET NOCOUNT ON;

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId

	if(@ActivityCode=1)
	begin
	  update Customer.Document set DocumentStatus=@DocumentStatu,
	  UpdateDate=Getdate(),UpdateUserId=@UserId,DocExpriedDate=@DocExpriedDate
	  where DocumentId=@DocumentId

	  select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	end
	else if(@ActivityCode=3)
	begin
	 delete from Customer.Document where DocumentId=@DocumentId

	  select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId
	end
  	select @resultcode as resultcode,@resultmessage as resultmessage

END



GO
