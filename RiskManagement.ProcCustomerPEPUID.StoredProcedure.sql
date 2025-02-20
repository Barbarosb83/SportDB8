USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerPEPUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcCustomerPEPUID] 
@CustomerId bigint,
@Description nvarchar(150),
@ExpriedDate datetime,
@IsPep bit,
@IsSanction bit,
@IsDoc bit,
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

	--exec [Log].ProcConcatOldValues  'StakeLimit','Customer','CustomerId',@CustomerId,@OldValues output
	
	--exec [Log].[ProcTransactionLogUID]  20,@ActivityCode,@Username,@CustomerId,'Customer.StakeLimit'
	--,@NewValues,@OldValues

	if(@ActivityCode=1)
	begin
	if exists (Select * from Customer.PEPControl where CustomerId=@CustomerId)
		begin
		  update Customer.PEPControl set Description=@Description,ExpriedDate=@ExpriedDate,IsPep=@IsPep,IsSanction=@IsSanction,
		  UpdateDate=Getdate(),UpdateUserId=@UserId,IsDoc=@IsDoc
		  where CustomerId=@CustomerId
		  if(@IsDoc=1)
			update Customer.StakeLimit set StakeDay=30000,StakeWeek=210000,StakeMonth=900000,DepositDay=30000,DepositWeek=30000,DepositMonth=30000,UpdateUser='DocumentControl',UpdateDate=GETDATE() where CustomerId=@CustomerId

		end
	else
		INSERT INTO [Customer].[PEPControl]
           ([CustomerId]
           ,[CreateDate]
           ,[Description]
           ,[ExpriedDate]
           ,[IsPep]
           ,[IsSanction]
           ,[IsDoc]
           ,[UpdateUserId]
           ,[UpdateDate])
     VALUES (@CustomerId,GETDATE(),@Description,@ExpriedDate,@IsPep,@IsSanction,@IsDoc,@UserId,GETDATE())
  end
  else if (@ActivityCode=2)
		INSERT INTO [Customer].[PEPControl]
           ([CustomerId]
           ,[CreateDate]
           ,[Description]
           ,[ExpriedDate]
           ,[IsPep]
           ,[IsSanction]
           ,[IsDoc]
           ,[UpdateUserId]
           ,[UpdateDate])
     VALUES (@CustomerId,GETDATE(),@Description,@ExpriedDate,@IsPep,@IsSanction,@IsDoc,@UserId,GETDATE())


  select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId

  	select @resultcode as resultcode,@resultmessage as resultmessage

END



GO
