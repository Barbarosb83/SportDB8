USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcPaymentTypeUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcPaymentTypeUID]
@PaymentTypeId int,
@PaymentType nvarchar(150),
@TypeId int,
@TransactionTypeId int,
@MinValue decimal(18,2),
@MaxValue decimal(18,2),
@RiskLevelId int,
@IsActive bit,
@Description nvarchar(150),
@Username nvarchar(150),
@ActivityCode int,
@LangId int


AS




BEGIN
SET NOCOUNT ON;
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'


select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId

	UPDATE [Parameter].[PaymentType] set
      MinValue = @MinValue
      ,MaxValue = @MaxValue
      ,[IsActive] = @IsActive
      ,[RiskLevelId] = @RiskLevelId
 WHERE PaymentTypeId=@PaymentTypeId


	
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId

			
	select @resultcode as resultcode,@resultmessage as resultmessage

END



GO
