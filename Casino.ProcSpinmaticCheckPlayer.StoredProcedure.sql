USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcSpinmaticCheckPlayer]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Casino].[ProcSpinmaticCheckPlayer]
@CustomerId bigint 


AS


BEGIN
SET NOCOUNT ON;

declare @result bigint=0


if (Select COUNT(Casino.[Spinmatic.Player].SpinmaticId) from Casino.[Spinmatic.Player] where Casino.[Spinmatic.Player].CustomerId=@CustomerId)>0
	begin
		
		Select @result= Casino.[Spinmatic.Player].SpinmaticId from Casino.[Spinmatic.Player] where Casino.[Spinmatic.Player].CustomerId=@CustomerId

	end

	select @result
END

GO
