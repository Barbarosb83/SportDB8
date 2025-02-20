USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcLuckyStreakCustomerUID]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Casino].[ProcLuckyStreakCustomerUID]
@CustomerId bigint,
@GameId bigint,
@AuthCode nvarchar(max)


AS


BEGIN
SET NOCOUNT ON;




if exists (Select Casino.[LuckyStreak.Customer].LuckyStreakCustomerId from Casino.[LuckyStreak.Customer] where Casino.[LuckyStreak.Customer].CustomerId=@CustomerId and Casino.[LuckyStreak.Customer].GameId=@GameId)
	begin
		
		
		
		update Casino.[LuckyStreak.Customer] set 
		AuthCode=@AuthCode
		where CustomerId=@CustomerId and GameId=@GameId
	
	end
else
	begin
		insert Casino.[LuckyStreak.Customer](CustomerId,GameId,AuthCode)
		values (@CustomerId,@GameId,@AuthCode)
	end


END


GO
