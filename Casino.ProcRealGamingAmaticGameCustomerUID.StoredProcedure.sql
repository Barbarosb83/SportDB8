USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcRealGamingAmaticGameCustomerUID]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Casino].[ProcRealGamingAmaticGameCustomerUID]
@CustomerId bigint,
@GameId bigint,
@AuthCode nvarchar(max)


AS


BEGIN
SET NOCOUNT ON;




if exists (Select Casino.[RealGaming.AmaticGameCustomer].AmaticGameCustomerId from Casino.[RealGaming.AmaticGameCustomer] where Casino.[RealGaming.AmaticGameCustomer].CustomerId=@CustomerId and Casino.[RealGaming.AmaticGameCustomer].GameId=@GameId)
	begin
		
		
		
		update Casino.[RealGaming.AmaticGameCustomer] set 
		AuthCode=@AuthCode
		where CustomerId=@CustomerId and GameId=@GameId
	
	end
else
	begin
		insert Casino.[RealGaming.AmaticGameCustomer](CustomerId,GameId,AuthCode)
		values (@CustomerId,@GameId,@AuthCode)
	end


END


GO
