USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [CasinoGame].[ProcCreateGameToken]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CasinoGame].[ProcCreateGameToken]
@CustomerId bigint ,
@Token nvarchar(250)

AS


BEGIN
SET NOCOUNT ON;

declare @result bigint=1

 

if exists (Select CasinoGameCustomerId  FROM [CasinoGame].[Customer] with (nolock) where [CustomerId]=@CustomerId)
	begin
		
		update [CasinoGame].[Customer] set [Token]=@Token where CustomerId=@CustomerId

	end
else 
	begin
		insert [CasinoGame].[Customer](CustomerId,[Token])
		values (@CustomerId,@Token)

		 

	end

	return @result
	
END

GO
