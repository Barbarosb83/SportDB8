USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerBitcoin]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [GamePlatform].[ProcCustomerBitcoin] 
@CustomerId bigint
AS

BEGIN
SET NOCOUNT ON;

SELECT Customer.Bitcoin.BitcoinAddress  from Customer.Bitcoin where Customer.Bitcoin.CustomerId=@CustomerId




END



GO
