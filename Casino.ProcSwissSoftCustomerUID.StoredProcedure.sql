USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcSwissSoftCustomerUID]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [Casino].[ProcSwissSoftCustomerUID]
@CustomerId bigint,
@TokenId nvarchar(150),
@SesionId nvarchar(150)


AS


BEGIN
SET NOCOUNT ON;




if exists (Select Casino.[SwissSoft.Customer].CustomerId from Casino.[SwissSoft.Customer] where Casino.[SwissSoft.Customer].CustomerId=@CustomerId )
	begin
		
		
		
		update Casino.[SwissSoft.Customer] set 
		SesionId=@SesionId
		where CustomerId=@CustomerId  
	
	end
else
	begin
		insert Casino.[SwissSoft.Customer](CustomerId,TokenId,SesionId)
		values (@CustomerId,@TokenId,@SesionId)
	end

	select 1 as resultcode
END


GO
