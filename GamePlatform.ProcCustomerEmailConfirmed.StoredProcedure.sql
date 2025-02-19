USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerEmailConfirmed]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcCustomerEmailConfirmed] 
@CustomerId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;

declare @resultcode int=116
declare @resultmessage nvarchar(max)='Hata oluştu'

	
		update Customer.Customer set Customer.RecoveryCode=null,RecoveryDate=null,IsActive=1,IsVerification=1
		where Customer.CustomerId=@CustomerId
		
		select @resultcode=@CustomerId,@resultmessage='OK'
	

select @resultcode as resultcode,@resultmessage as resultmessage

End


GO
