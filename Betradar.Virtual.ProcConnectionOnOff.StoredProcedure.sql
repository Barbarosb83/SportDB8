USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Virtual.ProcConnectionOnOff]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Virtual.ProcConnectionOnOff]
           @ConnectionStatus int
AS
BEGIN
	
	
			UPDATE [Virtual].[Event]
				SET [Virtual].[Event].ConnectionStatu = @ConnectionStatus
					
		if (@ConnectionStatus=1)
			begin
				UPDATE [Virtual].[EventDetail]
						SET [BetStatus] = 3
			end

	
END


GO
