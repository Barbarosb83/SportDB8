USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcConnectionOnOff]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Betradar].[Live.ProcConnectionOnOff]
           @ConnectionStatus int,
@BetradarTimeStamp datetime 
AS
BEGIN
		--insert dbo.temptabl(MatchId,BettradarOddId,tarih) values (@ConnectionStatus,@ConnectionStatus,GETDATE())
	
	
			--UPDATE [Live].[Event]
			--	SET [Live].[Event].ConnectionStatu = @ConnectionStatus
					
		if (@ConnectionStatus=1)
			begin
				UPDATE [Live].[EventDetail]
						SET [BetStatus] = 3
						--,BetradarTimeStamp=@BetradarTimeStamp,UpdatedDate=GETDATE()						
						--[Live].[EventDetail].MatchTime=null,[Live].[EventDetail].Score='',[Live].[EventDetail].TimeStatu=0
					where	 Live.[EventDetail].TimeStatu not in (1,14,5,27,84,21,22,23,24,25,26,11)
			
			--UPDATE [Live].[EventOdd]
			--   SET [OddValue] = null				  
			--	  ,[BetradarTimeStamp] = GETDATE()
			--	  ,[UpdatedDate] = GETDATE()

				  -- update live.eventoddprob set CashoutStatus=-1

--UPDATE [Live].[EventTopOdd]
--   SET [ThreeWay1] = null
--      ,[ThreeWayX] = null
--      ,[ThreeWay2] = null
--      ,[RestThreeWay1] = null
--      ,[RestThreeWayX] = null
--      ,[RestThreeWay2] = null
--      ,[Total] = null
--      ,[TotalOver] = null
--      ,[TotalUnder] = null
--      ,[NextGoal1] = null
--      ,[NextGoalX] = null
--      ,[NextGoal2] = null
--      ,[ThreeWay1State] = null
--      ,[ThreeWayXState] = null
--      ,[ThreeWay2State] = null
--      ,[RestThreeWay1State] = null
--      ,[RestThreeWayXState] = null
--      ,[RestThreeWay2State] = null
--      ,[TotalOverState] = null
--      ,[TotalUnderState] = null
--      ,[NextGoal1State] =null
--      ,[NextGoalXState] = null
--      ,[NextGoal2State] = null
--      ,[ThreeWay1Change] = null
--      ,[ThreeWayXChange] = null
--      ,[ThreeWay2Change] = null
--      ,[RestThreeWay1Change] = null
--      ,[RestThreeWayXChange] = null
--      ,[RestThreeWay2Change] = null
--      ,[TotalOverChange] = null
--      ,[TotalUnderChange] = null
--      ,[NextGoal1Change] = null
--      ,[NextGoalXChange] = null
--      ,[NextGoal2Change] = null
--      ,[ThreeWay1Id] =null
--      ,[ThreeWayXId] = null
--      ,[ThreeWay2Id] = null
--      ,[RestThreeWay1Id] = null
--      ,[RestThreeWayXId] = null
--      ,[RestThreeWay2Id] = null
--      ,[TotalOverId] = null
--      ,[TotalUnderId] = null
--      ,[NextGoal1Id] =null
--      ,[NextGoalXId] = null
--      ,[NextGoal2Id] = null


				
			end

	
END


GO
