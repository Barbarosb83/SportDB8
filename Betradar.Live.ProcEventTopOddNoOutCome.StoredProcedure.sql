USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventTopOddNoOutCome]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Live.ProcEventTopOddNoOutCome]
@EventId bigint,
@OutCome nvarchar(50),
@SpecialBetValue nvarchar(50),
@OddValue float,
@OddId bigint,
@IsActive bit,
@Change int,
@OddTypeId int
AS

BEGIN


--declare @OddTypeId int

	if(@OddTypeId is null)
	select top 1 @OddTypeId=live.EventOdd.OddsTypeId from Live.EventOdd with (nolock)
	where Live.EventOdd.BetradarMatchId=@EventId and live.EventOdd.BettradarOddId=@OddId

-- 3W
if (@OddTypeId=708)
begin

		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWay1State] = @IsActive,[ThreeWayXState] = @IsActive,[ThreeWay2State] = @IsActive
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
		
		
	
end




-- Cricet 2w
else if (@OddTypeId=490 )
begin

		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWay1State] = @IsActive,[ThreeWay2State] = @IsActive
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
		
end


-- Tennis 2w
else if (@OddTypeId=8 )
begin

		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWay1State] = @IsActive,[ThreeWay2State] = @IsActive
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
		
end



-- Rest 3W
else if (@OddTypeId=3 )
begin
	
		UPDATE [Live].[EventTopOdd]
		   SET [RestThreeWay1State] = @IsActive,[RestThreeWayXState] = @IsActive,[RestThreeWay2State] = @IsActive
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
		
	
	
end




-- Total
else if (@OddTypeId=710 )
begin

		UPDATE [Live].[EventTopOdd]
		   SET  [TotalOverState] = @IsActive,[TotalUnderState] = @IsActive
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
	

end


-- Next Goal
else if (@OddTypeId=11)
begin
		UPDATE [Live].[EventTopOdd]
		   SET [NextGoal1State] = @IsActive,[NextGoalXState] = @IsActive,[NextGoal2State] = @IsActive
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
		
	

end



-- Tennis Next Set
else if (@OddTypeId=9 )
begin
		UPDATE [Live].[EventTopOdd]
		   SET [NextGoal1State] = @IsActive,[NextGoal2State] = @IsActive
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
		
		
end



-- Voleyball Next Set
else if (@OddTypeId=97 )
begin
		UPDATE [Live].[EventTopOdd]
		   SET [NextGoal1State] = @IsActive,[NextGoal2State] = @IsActive
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
		

end




-- Beysboll 2w
else if (@OddTypeId=34 )
begin

		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWay1State] = @IsActive,[ThreeWay2State] = @IsActive
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
		
		
end



-- Voleyball 2w
else if (@OddTypeId=96 )
begin

		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWay1State] = @IsActive,[ThreeWay2State] = @IsActive
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
		
		
	
end





END


GO
