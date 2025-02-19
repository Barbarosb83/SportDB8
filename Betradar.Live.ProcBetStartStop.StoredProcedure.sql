USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcBetStartStop]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Live.ProcBetStartStop]
           @BetradarMatchId bigint,
           @BetStatus int,
@BetradarTimeStamp datetime

AS
BEGIN
	
	--insert dbo.betslip values (@BetradarMatchId,CAST(@BetStatus as nvarchar(50)),GETDATE())

			UPDATE [Live].[EventDetail]
				SET [BetStatus] = @BetStatus,BetradarTimeStamp=@BetradarTimeStamp 
					Where [Live].[EventDetail].BetradarMatchIds=@BetradarMatchId
					if(@BetStatus<>2 )
						update Live.EventOdd set IsActive=0 where BetradarMatchId=@BetradarMatchId
					--if(@BetStatus<>2)
					--begin
				 
					--   --  update Live.EventOdd set IsActive=0 where BetradarMatchId=@BetradarMatchId
					--   if  exists(select Live.EventOddProb.OddId from Live.EventOddProb with (nolock) where Live.EventOddProb.BetradarMatchId=@BetradarMatchId and CashoutStatus<>-1)
					--	 update  Live.EventOddProb set CashoutStatus=-1 where BetradarMatchId=@BetradarMatchId
					--end

	
END


GO
