USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcSpinmaticRegisterPlayer]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Casino].[ProcSpinmaticRegisterPlayer]
@SpinmaticId bigint,
@CustomerId bigint ,
@Status nvarchar(50),
@Balance money,
@Currency nvarchar(10)

AS


BEGIN
SET NOCOUNT ON;

declare @result bigint=0


if exists (Select Casino.[Spinmatic.Player].SpinmaticId from Casino.[Spinmatic.Player] where Casino.[Spinmatic.Player].CustomerId=@CustomerId)
	begin
		
		Select @result= Casino.[Spinmatic.Player].SpinmaticId from Casino.[Spinmatic.Player] where Casino.[Spinmatic.Player].CustomerId=@CustomerId

	end
else 
	begin
		insert Casino.[Spinmatic.Player](SpinmaticId,CustomerId,Status,Balance,Currency)
		values (@SpinmaticId,@CustomerId,@Status,@Balance,@Currency)

		set @result=SCOPE_IDENTITY()

	end

	select @result
END

GO
