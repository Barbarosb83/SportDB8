USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerLoginFirst]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [GamePlatform].[ProcCustomerLoginFirst] 
@CustomerId bigint
AS

BEGIN
SET NOCOUNT ON;


declare @result int=0



if(select COUNT(Customer.Customer.CustomerId) from Customer.Customer where Customer.Customer.CustomerId=@CustomerId and GroupId=0 )>0
	set @result=1



	select @result as result




END



GO
