USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcGoldenBoxCustomerUID]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Casino].[ProcGoldenBoxCustomerUID]
@CustomerId bigint,
@TokenId nvarchar(150)


AS


BEGIN
SET NOCOUNT ON;




if exists (Select [GoldenBoxCustomerId] from [Casino].[GoldenBox.Customer] where  [Casino].[GoldenBox.Customer].CustomerId=@CustomerId )
	begin
		
		
		
		update [Casino].[GoldenBox.Customer] set 
		Token=@TokenId
		where CustomerId=@CustomerId
	
	end
else
	begin
		insert [Casino].[GoldenBox.Customer](CustomerId,[Token])
		values (@CustomerId,@TokenId)
	end

	select 1 as resultcode
END

GO
