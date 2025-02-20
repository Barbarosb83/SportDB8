USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcXprressRegisterPlayer]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [Casino].[ProcXprressRegisterPlayer]
@XprressId bigint,
@CustomerId bigint ,
@Status nvarchar(50),
@Balance money,
@Currency nvarchar(10)

AS


BEGIN
SET NOCOUNT ON;

declare @result bigint=0


if exists (Select Casino.[XprressGaming.Player].Id from Casino.[XprressGaming.Player] where Casino.[XprressGaming.Player].CustomerId=@CustomerId)
	begin
		
		Select @result= Casino.[XprressGaming.Player].XprressId from Casino.[XprressGaming.Player] where Casino.[XprressGaming.Player].CustomerId=@CustomerId

	end
else 
	begin
		insert Casino.[XprressGaming.Player](XprressId,CustomerId,Status,Balance,Currency)
		values (@XprressId,@CustomerId,@Status,@Balance,@Currency)

		set @result=SCOPE_IDENTITY()

	end

	select @result
END

GO
