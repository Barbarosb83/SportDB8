USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Job].[CustomerLockOut]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Job].[CustomerLockOut]

AS

BEGIN

	
	

	update Customer.Customer set IsLockedOut=0 , LastLockOutDate=null,FailedPasswordAttemptCount=0 where CustomerId in (
	select CustomerId  from Customer.Customer where IsLockedOut=1 and DATEDIFF(MINUTE,LastLockOutDate,GETDATE())>=30 and FailedPasswordAttemptCount>=5)







END



GO
