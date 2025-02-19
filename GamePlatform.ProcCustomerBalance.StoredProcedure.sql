USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerBalance]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerBalance] 
@CustomerId bigint
AS

BEGIN
SET NOCOUNT ON;

SELECT Customer.Customer.Balance,Customer.Customer.Bonus  
from Customer.Customer with (nolock) 
where Customer.Customer.CustomerId=@CustomerId




END


GO
