USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Stadium].[ProcStadiumCreate]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Stadium].[ProcStadiumCreate] 
@BranchId bigint,
@EntranceFee money,
@CurrencyId int,
@MaxPlayer int,
@MinPlayer int,
@MinOddvalue float,
@MaxOddValue float,
@ServiceFee float,
@CardChangeCount int,
@CardView bit,
@IsRepeat bit,
@StartDate datetime,
@EndHour int,
@IsActive bit,
@LangId int,
@UserId int
AS

BEGIN
SET NOCOUNT ON;


------------------------------------------------------------------

 declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'

declare @StadiumId bigint



										INSERT INTO [Stadium].[Stadium]
											   ([BranchId]
											   ,[EntranceFee]
											   ,[CurrencyId]
											   ,[MaxPlayer]
											   ,[MinPlayer]
											   ,[MinOddValue]
											   ,[MaxOddValue]
											   ,[ServiceFee]
											   ,[CardChangeCount]
											   ,[CardView]
											   ,[CreateDate]
											   ,[IsActive]
											   ,[Comment]
											   ,[StartDate]
											   ,[EndDate]
											   ,[CreateRuleId],ActivePlayerCount,CreateUserId)
										 values (
												@BranchId
												,@EntranceFee
												,@CurrencyId
												,@MaxPlayer
												,@MinPlayer
												,@MinOddvalue
												,@MaxOddValue
												,@ServiceFee
												,@CardChangeCount
												,@CardView
												,GETDATE()
												,@IsActive
												,''
												,@StartDate
												,DATEADD(HOUR,@EndHour,GETDATE())
												,-1,0,@UserId)

												set @StadiumId=SCOPE_IDENTITY()

												  	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId

select @resultcode as resultcode,@resultmessage as resultmessage,@StadiumId as StadiumId 

END


GO
