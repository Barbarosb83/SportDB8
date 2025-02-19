USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcUsernameCheck]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [GamePlatform].[ProcUsernameCheck] 
@Username nvarchar(50)
AS

BEGIN
SET NOCOUNT ON;


declare @result int=0

if(select COUNT(Customer.Customer.CustomerId) from Customer.Customer where Customer.Customer.Username=@Username)>0
	set @result=1


	select @result as result

END



GO
