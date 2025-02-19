USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCustomerPasswordChange]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Retail].[ProcCustomerPasswordChange]
@CustomerId bigint,
@Password nvarchar(250)

AS




BEGIN
SET NOCOUNT ON;

	update Customer.Customer set
	
	Password=@Password
	,FailedPasswordAttemptCount=0
	,IsLockedOut=0


	where CustomerId=@CustomerId
	
	

	select 1 as resultcode,'' as resultmessage
END





GO
