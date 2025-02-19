USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcXprressClearPlayer]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [Casino].[ProcXprressClearPlayer]
@XprressId bigint,
@CustomerId bigint  

AS


BEGIN
SET NOCOUNT ON;

declare @result bigint=0


if exists (Select Casino.[XprressGaming.Player].Id from Casino.[XprressGaming.Player] where Casino.[XprressGaming.Player].CustomerId=@CustomerId)
	begin
		
		delete   from Casino.[XprressGaming.Player] where Casino.[XprressGaming.Player].CustomerId=@CustomerId
		set @result=1
	end
 
	select @result
END

GO
