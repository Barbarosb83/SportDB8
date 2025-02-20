USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventTopOdd]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Live.ProcEventTopOdd]
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
SET NOCOUNT ON;

declare @SportId int

-- 3W
if (@OddTypeId=708 and @OutCome='1')
begin
select @SportId=Parameter.Category.SportId
from Live.[Event] with (nolock) INNER JOIN 
Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Live.[Event].TournamentId INNER JOIN
Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId
where Live.[Event].BetradarMatchId=@EventId

		if(@SportId<>2)
		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWay1] = @OddValue,[ThreeWay1State] = @IsActive
		  -- ,[ThreeWay1Change] = @Change
		   ,[ThreeWay1Id] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
	
end
else if (@OddTypeId=708 and @OutCome='x')
begin
	select @SportId=Parameter.Category.SportId
from Live.[Event] with (nolock) INNER JOIN 
Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Live.[Event].TournamentId INNER JOIN
Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId
where Live.[Event].BetradarMatchId=@EventId

		if(@SportId<>2)
		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWayX] = @OddValue,[ThreeWayXState] = @IsActive
		   --,[ThreeWayXChange] = @Change
		   ,[ThreeWayXId] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
	
end
else if (@OddTypeId=708 and @OutCome='2')
begin
	select @SportId=Parameter.Category.SportId
from Live.[Event] with (nolock) INNER JOIN 
Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Live.[Event].TournamentId INNER JOIN
Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId
where Live.[Event].BetradarMatchId=@EventId

		if(@SportId<>2)
		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWay2] = @OddValue,[ThreeWay2State] = @IsActive
		   --,[ThreeWay2Change] = @Change
		   ,[ThreeWay2Id] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
	
end
-- Cricet 2w
else if (@OddTypeId=490 and @OutCome='1' )
begin

select @SportId=Parameter.Category.SportId
from Live.[Event] with (nolock) INNER JOIN 
Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Live.[Event].TournamentId INNER JOIN
Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId
where Live.[Event].BetradarMatchId=@EventId

	if (@SportId=18)
		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWay1] = @OddValue,[ThreeWay1State] = @IsActive
		   --,[ThreeWay1Change] = @Change
		   ,[ThreeWay1Id] = @OddId 
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
		
		--UPDATE [Live].[EventTopOdd]
		--   SET [ThreeWayXState] = 1
		--WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
end
else if (@OddTypeId=490 and @OutCome='2'   )
begin
	
	select @SportId=Parameter.Category.SportId
from Live.[Event] with (nolock) INNER JOIN 
Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Live.[Event].TournamentId INNER JOIN
Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId
where Live.[Event].BetradarMatchId=@EventId

	if (@SportId=18)
		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWay2] = @OddValue,[ThreeWay2State] = @IsActive
		   --,[ThreeWay2Change] = @Change
		   ,[ThreeWay2Id] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
	
end



-- Tennis 2w
else if (@OddTypeId=8 and @OutCome='1'  )
begin

select @SportId=Parameter.Category.SportId
from Live.[Event] with (nolock) INNER JOIN 
Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Live.[Event].TournamentId INNER JOIN
Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId
where Live.[Event].BetradarMatchId=@EventId

	if( @SportId=5)
		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWay1] = @OddValue,[ThreeWay1State] = @IsActive
		  -- ,[ThreeWay1Change] = @Change
		   ,[ThreeWay1Id] = @OddId 
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
	
		--	UPDATE [Live].[EventTopOdd]
		--   SET [ThreeWayXState] = 1
		--WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
end	
else if (@OddTypeId=8 and @OutCome='2' )
begin
	select @SportId=Parameter.Category.SportId
from Live.[Event] with (nolock) INNER JOIN 
Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Live.[Event].TournamentId INNER JOIN
Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId
where Live.[Event].BetradarMatchId=@EventId

	if( @SportId=5)
		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWay2] = @OddValue,[ThreeWay2State] = @IsActive
		 --  ,[ThreeWay2Change] = @Change
		   ,[ThreeWay2Id] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
	
end

-- Voleyball/Darts Next Set
else if (@OddTypeId=97 and @OutCome='1')
begin
	select @SportId=Parameter.Category.SportId
from Live.[Event] with (nolock) INNER JOIN 
Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Live.[Event].TournamentId INNER JOIN
Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId
where Live.[Event].BetradarMatchId=@EventId

	if(  @SportId=20)
		UPDATE [Live].[EventTopOdd]
		   SET [NextGoal1] = @OddValue,[NextGoal1State] = @IsActive
		 --  ,[NextGoal1Change] = @Change
		   ,[NextGoal1Id] = @OddId,[NextGoalXState] = 1
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
	else if(  @SportId=19)
		UPDATE [Live].[EventTopOdd]
		   SET [NextGoal1] = @OddValue,[NextGoal1State] = @IsActive
		 --  ,[NextGoal1Change] = @Change
		   ,[NextGoal1Id] = @OddId,[NextGoalXState] = 1
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
		
		--UPDATE [Live].[EventTopOdd]
		--   SET [NextGoalXState] = 1
		--WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 

end
else if (@OddTypeId=97 and @OutCome='2')
begin

select @SportId=Parameter.Category.SportId
from Live.[Event] with (nolock) INNER JOIN 
Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Live.[Event].TournamentId INNER JOIN
Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId
where Live.[Event].BetradarMatchId=@EventId

	if(  @SportId=20)
		UPDATE [Live].[EventTopOdd]
		   SET [NextGoal2] = @OddValue,[NextGoal2State] = @IsActive
		   --,[NextGoal2Change] = @Change
		   ,[NextGoal2Id] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
	else if(  @SportId=19)
		UPDATE [Live].[EventTopOdd]
		   SET [NextGoal2] = @OddValue,[NextGoal2State] = @IsActive
		   --,[NextGoal2Change] = @Change
		   ,[NextGoal2Id] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 

end

else if (@OddTypeId=9 )
begin
	select @SportId=Parameter.Category.SportId
from Live.[Event] with (nolock) INNER JOIN 
Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Live.[Event].TournamentId INNER JOIN
Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId
where Live.[Event].BetradarMatchId=@EventId

	if(  @SportId=5)
		begin
			if(@OutCome='1')
		UPDATE [Live].[EventTopOdd]
		   SET [NextGoal1] = @OddValue,[NextGoal1State] = @IsActive
		 --  ,[NextGoal1Change] = @Change
		   ,[NextGoal1Id] = @OddId,[NextGoalXState] = 1
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
			else if (@OutCome='2')
				UPDATE [Live].[EventTopOdd]
		   SET [NextGoal2] = @OddValue,[NextGoal2State] = @IsActive
		 --  ,[NextGoal1Change] = @Change
		   ,[NextGoal2Id] = @OddId 
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
		end
		--UPDATE [Live].[EventTopOdd]
		--   SET [NextGoalXState] = 1
		--WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 

end
 
 
-- Beysboll 2w , Basketball 2way inculuding overtime
else if (@OddTypeId=34 and @OutCome='1')
begin
select @SportId=Parameter.Category.SportId
from Live.[Event] with (nolock) INNER JOIN 
Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Live.[Event].TournamentId INNER JOIN
Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId
where Live.[Event].BetradarMatchId=@EventId

	if(@SportId in (2,3))
		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWay1] = @OddValue,[ThreeWay1State] = @IsActive
		  -- ,[ThreeWay1Change] = @Change
		   ,[ThreeWay1Id] = @OddId,[ThreeWayXState] = 0
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 

	 
		--UPDATE [Live].[EventTopOdd]
		--   SET [ThreeWayXState] = 1
		--WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
end

else if (@OddTypeId=34 and @OutCome='2')
begin
	select @SportId=Parameter.Category.SportId
from Live.[Event] with (nolock) INNER JOIN 
Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Live.[Event].TournamentId INNER JOIN
Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId
where Live.[Event].BetradarMatchId=@EventId

	if(@SportId in (2,3))
		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWay2] = @OddValue,[ThreeWay2State] = @IsActive
		   --,[ThreeWay2Change] = @Change
		   ,[ThreeWay2Id] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 

		 
	
end


-- Voleyball/Darts 2w
else if (@OddTypeId=96 and @OutCome='1'   )
begin
select @SportId=Parameter.Category.SportId
from Live.[Event] with (nolock) INNER JOIN 
Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Live.[Event].TournamentId INNER JOIN
Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId
where Live.[Event].BetradarMatchId=@EventId

	if(@SportId=31)
		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWay1] = @OddValue,[ThreeWay1State] = @IsActive
		  -- ,[ThreeWay1Change] = @Change
		   ,[ThreeWay1Id] = @OddId 
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 

	 else if(@SportId=26)
		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWay1] = @OddValue,[ThreeWay1State] = @IsActive
		  -- ,[ThreeWay1Change] = @Change
		   ,[ThreeWay1Id] = @OddId 
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
	else if(@SportId=17)
		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWay1] = @OddValue,[ThreeWay1State] = @IsActive
		   --,[ThreeWay1Change] = @Change
		   ,[ThreeWay1Id] = @OddId 
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
	else if(  @SportId=20)
		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWay1] = @OddValue,[ThreeWay1State] = @IsActive
		   --,[ThreeWay1Change] = @Change
		   ,[ThreeWay1Id] = @OddId 
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
	else if(  @SportId=19)
		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWay1] = @OddValue,[ThreeWay1State] = @IsActive
		   --,[ThreeWay1Change] = @Change
		   ,[ThreeWay1Id] = @OddId 
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 	
		--UPDATE [Live].[EventTopOdd]
		--   SET [ThreeWayXState] = 1
		--WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
	
end
	
else if (@OddTypeId=96 and @OutCome='2'  )
begin
	select @SportId=Parameter.Category.SportId
from Live.[Event] with (nolock) INNER JOIN 
Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Live.[Event].TournamentId INNER JOIN
Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId
where Live.[Event].BetradarMatchId=@EventId

	if(@SportId=31)
		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWay2] = @OddValue,[ThreeWay2State] = @IsActive
		  -- ,[ThreeWay2Change] = @Change
		   ,[ThreeWay2Id] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 

	else if(@SportId=26)
		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWay2] = @OddValue,[ThreeWay2State] = @IsActive
		   --,[ThreeWay2Change] = @Change
		   ,[ThreeWay2Id] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId
	else if(@SportId=17)
		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWay2] = @OddValue,[ThreeWay2State] = @IsActive
		   --,[ThreeWay2Change] = @Change
		   ,[ThreeWay2Id] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
	else if(  @SportId=20)
		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWay2] = @OddValue,[ThreeWay2State] = @IsActive
		   --,[ThreeWay2Change] = @Change
		   ,[ThreeWay2Id] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
		else if(  @SportId=19)
		UPDATE [Live].[EventTopOdd]
		   SET [ThreeWay2] = @OddValue,[ThreeWay2State] = @IsActive
		   --,[ThreeWay2Change] = @Change
		   ,[ThreeWay2Id] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
	
end
  
--  3W OT
else if (@OddTypeId=5 and @OutCome='1')
begin
	
		UPDATE [Live].[EventTopOdd]
		   SET ThreeWay1 = @OddValue,ThreeWay1State = @IsActive
		   --,[RestThreeWay1Change] = @Change
		   ,[ThreeWay1Id] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
	
end

else if (@OddTypeId=5 and @OutCome='x')
begin
		UPDATE [Live].[EventTopOdd]
		   SET ThreeWayX = @OddValue,ThreeWayXState = @IsActive
		  -- ,[RestThreeWayXChange] = @Change
		   ,ThreeWayXId = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
	
end
	
else if (@OddTypeId=5 and @OutCome='2')
begin
	
		UPDATE [Live].[EventTopOdd]
		   SET ThreeWay2 = @OddValue,ThreeWay2State = @IsActive
		   --,[RestThreeWay2Change] = @Change
		   ,ThreeWay2Id = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 

end
  
-- Rest 3W
else if (@OddTypeId=3 and @OutCome='1')
begin
	
		UPDATE [Live].[EventTopOdd]
		   SET [RestThreeWay1] = @OddValue,[RestThreeWay1State] = @IsActive
		   --,[RestThreeWay1Change] = @Change
		   ,[RestThreeWay1Id] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
	
end

else if (@OddTypeId=3 and @OutCome='x')
begin
		UPDATE [Live].[EventTopOdd]
		   SET [RestThreeWayX] = @OddValue,[RestThreeWayXState] = @IsActive
		  -- ,[RestThreeWayXChange] = @Change
		   ,[RestThreeWayXId] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
	
end
	
else if (@OddTypeId=3 and @OutCome='2')
begin
	
		UPDATE [Live].[EventTopOdd]
		   SET [RestThreeWay2] = @OddValue,[RestThreeWay2State] = @IsActive
		   --,[RestThreeWay2Change] = @Change
		   ,[RestThreeWay2Id] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 

end

--Overtime Rest 3W
else if (@OddTypeId=7 and @OutCome='1')
begin
	
		UPDATE [Live].[EventTopOdd]
		   SET [RestThreeWay1] = @OddValue,[RestThreeWay1State] = @IsActive
		   --,[RestThreeWay1Change] = @Change
		   ,[RestThreeWay1Id] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
	
end

else if (@OddTypeId=7 and @OutCome='x')
begin
		UPDATE [Live].[EventTopOdd]
		   SET [RestThreeWayX] = @OddValue,[RestThreeWayXState] = @IsActive
		  -- ,[RestThreeWayXChange] = @Change
		   ,[RestThreeWayXId] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
	
end
	
else if (@OddTypeId=7 and @OutCome='2')
begin
	
		UPDATE [Live].[EventTopOdd]
		   SET [RestThreeWay2] = @OddValue,[RestThreeWay2State] = @IsActive
		   --,[RestThreeWay2Change] = @Change
		   ,[RestThreeWay2Id] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 

end
 
-- Total
else if (@OddTypeId=710 and @OutCome='o')
begin

		UPDATE [Live].[EventTopOdd]
		   SET [Total] = @SpecialBetValue, [TotalOver] = @OddValue,[TotalOverState] = @IsActive
		   --,[TotalOverChange] = @Change
		   ,[TotalOverId] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 

end

else if (@OddTypeId=710 and @OutCome='u')
begin

		UPDATE [Live].[EventTopOdd]
		   SET [Total] = @SpecialBetValue, [TotalUnder] = @OddValue,[TotalUnderState] = @IsActive
		   --,[TotalUnderChange] = @Change
		   ,[TotalUnderId] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 

end
--Darts Total
else if (@OddTypeId=268 and @OutCome='o')
begin
	select @SportId=Parameter.Category.SportId
from Live.[Event] with (nolock) INNER JOIN 
Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Live.[Event].TournamentId INNER JOIN
Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId
where Live.[Event].BetradarMatchId=@EventId
		if(@SportId=19)
		UPDATE [Live].[EventTopOdd]
		   SET [Total] = @SpecialBetValue, [TotalOver] = @OddValue,[TotalOverState] = @IsActive
		   --,[TotalOverChange] = @Change
		   ,[TotalOverId] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 

end

else if (@OddTypeId=268 and @OutCome='u')
begin
	select @SportId=Parameter.Category.SportId
from Live.[Event] with (nolock) INNER JOIN 
Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Live.[Event].TournamentId INNER JOIN
Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId
where Live.[Event].BetradarMatchId=@EventId
		if(@SportId=19)
		UPDATE [Live].[EventTopOdd]
		   SET [Total] = @SpecialBetValue, [TotalUnder] = @OddValue,[TotalUnderState] = @IsActive
		   --,[TotalUnderChange] = @Change
		   ,[TotalUnderId] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 

end

-- Total uzatmalar
else if (@OddTypeId=6 and @OutCome='o')
begin

		UPDATE [Live].[EventTopOdd]
		   SET [Total] = @SpecialBetValue, [TotalOver] = @OddValue,[TotalOverState] = @IsActive
		   --,[TotalOverChange] = @Change
		   ,[TotalOverId] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 

end

else if (@OddTypeId=6 and @OutCome='u')
begin

		UPDATE [Live].[EventTopOdd]
		   SET [Total] = @SpecialBetValue, [TotalUnder] = @OddValue,[TotalUnderState] = @IsActive
		   --,[TotalUnderChange] = @Change
		   ,[TotalUnderId] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 

end

-- Next Goal
else if (@OddTypeId=11 and @OutCome='1')
begin
		UPDATE [Live].[EventTopOdd]
		   SET [NextGoal1] = @OddValue,[NextGoal1State] = @IsActive
		  -- ,[NextGoal1Change] = @Change
		   ,[NextGoal1Id] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 

end

else if (@OddTypeId=11 and @OutCome='x')
begin
		UPDATE [Live].[EventTopOdd]
		   SET [NextGoalX] = @OddValue,[NextGoalXState] = @IsActive
		   --,[NextGoalXChange] = @Change
		   ,[NextGoalXId] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
	
end
	
else if (@OddTypeId=11 and @OutCome='2')
begin
		UPDATE [Live].[EventTopOdd]
		   SET [NextGoal2] = @OddValue,[NextGoal2State] = @IsActive
		  -- ,[NextGoal2Change] = @Change
		   ,[NextGoal2Id] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 

end
-- Next Goal Overtime
else if (@OddTypeId=12 and @OutCome='1')
begin
		UPDATE [Live].[EventTopOdd]
		   SET [NextGoal1] = @OddValue,[NextGoal1State] = @IsActive
		  -- ,[NextGoal1Change] = @Change
		   ,[NextGoal1Id] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 

end

else if (@OddTypeId=12 and @OutCome='x')
begin
		UPDATE [Live].[EventTopOdd]
		   SET [NextGoalX] = @OddValue,[NextGoalXState] = @IsActive
		   --,[NextGoalXChange] = @Change
		   ,[NextGoalXId] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 
	
end
	
else if (@OddTypeId=12 and @OutCome='2')
begin
		UPDATE [Live].[EventTopOdd]
		   SET [NextGoal2] = @OddValue,[NextGoal2State] = @IsActive
		  -- ,[NextGoal2Change] = @Change
		   ,[NextGoal2Id] = @OddId
		WHERE [Live].[EventTopOdd].BetradarMatchId=@EventId 

end





END


GO
