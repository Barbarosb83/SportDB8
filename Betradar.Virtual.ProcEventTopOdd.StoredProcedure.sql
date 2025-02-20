USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Virtual.ProcEventTopOdd]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Virtual.ProcEventTopOdd]
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

-- 3W
if (@OddTypeId=675 and @OutCome='1')
begin

		UPDATE [Virtual].[EventTopOdd]
		   SET [ThreeWay1] = @OddValue,[ThreeWay1State] = @IsActive,[ThreeWay1Change] = @Change,[ThreeWay1Id] = @OddId
		WHERE [Virtual].[EventTopOdd].EventId=@EventId 
	
end

if (@OddTypeId=675 and @OutCome='x')
begin
	
		UPDATE [Virtual].[EventTopOdd]
		   SET [ThreeWayX] = @OddValue,[ThreeWayXState] = @IsActive,[ThreeWayXChange] = @Change,[ThreeWayXId] = @OddId
		WHERE [Virtual].[EventTopOdd].EventId=@EventId 
	
end
	
if (@OddTypeId=675 and @OutCome='2')
begin
	
		UPDATE [Virtual].[EventTopOdd]
		   SET [ThreeWay2] = @OddValue,[ThreeWay2State] = @IsActive,[ThreeWay2Change] = @Change,[ThreeWay2Id] = @OddId
		WHERE [Virtual].[EventTopOdd].EventId=@EventId 
	
end


-- Tennis 2w
if (@OddTypeId=9 and @OutCome='1')
begin

		UPDATE [Virtual].[EventTopOdd]
		   SET [ThreeWay1] = @OddValue,[ThreeWay1State] = @IsActive,[ThreeWay1Change] = @Change,[ThreeWay1Id] = @OddId
		WHERE [Virtual].[EventTopOdd].EventId=@EventId 
	
end

if (@OddTypeId=9)
begin
	
		UPDATE [Virtual].[EventTopOdd]
		   SET [ThreeWayXState] = 1
		WHERE [Virtual].[EventTopOdd].EventId=@EventId 
end
	
if (@OddTypeId=9 and @OutCome='2')
begin
	
		UPDATE [Virtual].[EventTopOdd]
		   SET [ThreeWay2] = @OddValue,[ThreeWay2State] = @IsActive,[ThreeWay2Change] = @Change,[ThreeWay2Id] = @OddId
		WHERE [Virtual].[EventTopOdd].EventId=@EventId 
	
end

-- Basketball 2w
if (@OddTypeId=34 and @OutCome='1')
begin

		UPDATE [Virtual].[EventTopOdd]
		   SET [ThreeWay1] = @OddValue,[ThreeWay1State] = @IsActive,[ThreeWay1Change] = @Change,[ThreeWay1Id] = @OddId
		WHERE [Virtual].[EventTopOdd].EventId=@EventId 
	
end

if (@OddTypeId=34)
begin
	
		UPDATE [Virtual].[EventTopOdd]
		   SET [ThreeWayXState] = 1
		WHERE [Virtual].[EventTopOdd].EventId=@EventId 
end
	
if (@OddTypeId=34 and @OutCome='2')
begin
	
		UPDATE [Virtual].[EventTopOdd]
		   SET [ThreeWay2] = @OddValue,[ThreeWay2State] = @IsActive,[ThreeWay2Change] = @Change,[ThreeWay2Id] = @OddId
		WHERE [Virtual].[EventTopOdd].EventId=@EventId 
	
end


-- Rest 3W
if (@OddTypeId=20 and @OutCome='1')
begin
	
		UPDATE [Virtual].[EventTopOdd]
		   SET [RestThreeWay1] = @OddValue,[RestThreeWay1State] = @IsActive,[RestThreeWay1Change] = @Change,[RestThreeWay1Id] = @OddId
		WHERE [Virtual].[EventTopOdd].EventId=@EventId 
	
end

if (@OddTypeId=20 and @OutCome='x')
begin
		UPDATE [Virtual].[EventTopOdd]
		   SET [RestThreeWayX] = @OddValue,[RestThreeWayXState] = @IsActive,[RestThreeWayXChange] = @Change,[RestThreeWayXId] = @OddId
		WHERE [Virtual].[EventTopOdd].EventId=@EventId 
	
end
	
if (@OddTypeId=20 and @OutCome='2')
begin
	
		UPDATE [Virtual].[EventTopOdd]
		   SET [RestThreeWay2] = @OddValue,[RestThreeWay2State] = @IsActive,[RestThreeWay2Change] = @Change,[RestThreeWay2Id] = @OddId
		WHERE [Virtual].[EventTopOdd].EventId=@EventId 

end


-- Tennis Winner
if (@OddTypeId=8 and @OutCome='1')
begin
	
		UPDATE [Virtual].[EventTopOdd]
		   SET [RestThreeWay1] = @OddValue,[RestThreeWay1State] = @IsActive,[RestThreeWay1Change] = @Change,[RestThreeWay1Id] = @OddId
		WHERE [Virtual].[EventTopOdd].EventId=@EventId 
	
end

if (@OddTypeId=8)
begin
		UPDATE [Virtual].[EventTopOdd]
		   SET [ThreeWayXState] = 1
		WHERE [Virtual].[EventTopOdd].EventId=@EventId 	
end
	
if (@OddTypeId=8 and @OutCome='2')
begin
	
		UPDATE [Virtual].[EventTopOdd]
		   SET [RestThreeWay2] = @OddValue,[RestThreeWay2State] = @IsActive,[RestThreeWay2Change] = @Change,[RestThreeWay2Id] = @OddId
		WHERE [Virtual].[EventTopOdd].EventId=@EventId 

end


-- Total
if (@OddTypeId=681 and @OutCome='o')
begin

		UPDATE [Virtual].[EventTopOdd]
		   SET [Total] = @SpecialBetValue, [TotalOver] = @OddValue,[TotalOverState] = @IsActive,[TotalOverChange] = @Change,[TotalOverId] = @OddId
		WHERE [Virtual].[EventTopOdd].EventId=@EventId 

end

if (@OddTypeId=681 and @OutCome='u')
begin

		UPDATE [Virtual].[EventTopOdd]
		   SET [Total] = @SpecialBetValue, [TotalUnder] = @OddValue,[TotalUnderState] = @IsActive,[TotalUnderChange] = @Change,[TotalUnderId] = @OddId
		WHERE [Virtual].[EventTopOdd].EventId=@EventId 

end

-- Next Goal
if (@OddTypeId=12 and @OutCome='1')
begin
		UPDATE [Virtual].[EventTopOdd]
		   SET [NextGoal1] = @OddValue,[NextGoal1State] = @IsActive,[NextGoal1Change] = @Change,[NextGoal1Id] = @OddId
		WHERE [Virtual].[EventTopOdd].EventId=@EventId 

end

if (@OddTypeId=12 and @OutCome='x')
begin
		UPDATE [Virtual].[EventTopOdd]
		   SET [NextGoalX] = @OddValue,[NextGoalXState] = @IsActive,[NextGoalXChange] = @Change,[NextGoalXId] = @OddId
		WHERE [Virtual].[EventTopOdd].EventId=@EventId 
	
end
	
if (@OddTypeId=12 and @OutCome='2')
begin
		UPDATE [Virtual].[EventTopOdd]
		   SET [NextGoal2] = @OddValue,[NextGoal2State] = @IsActive,[NextGoal2Change] = @Change,[NextGoal2Id] = @OddId
		WHERE [Virtual].[EventTopOdd].EventId=@EventId 

end


-- Tennis Next Set
if (@OddTypeId=10 and @OutCome='1')
begin
		UPDATE [Virtual].[EventTopOdd]
		   SET [NextGoal1] = @OddValue,[NextGoal1State] = @IsActive,[NextGoal1Change] = @Change,[NextGoal1Id] = @OddId
		WHERE [Virtual].[EventTopOdd].EventId=@EventId 

end

if (@OddTypeId=10 )
begin
		UPDATE [Virtual].[EventTopOdd]
		   SET [NextGoalXState] = 1
		WHERE [Virtual].[EventTopOdd].EventId=@EventId 
	
end
	
if (@OddTypeId=10 and @OutCome='2')
begin
		UPDATE [Virtual].[EventTopOdd]
		   SET [NextGoal2] = @OddValue,[NextGoal2State] = @IsActive,[NextGoal2Change] = @Change,[NextGoal2Id] = @OddId
		WHERE [Virtual].[EventTopOdd].EventId=@EventId 

end

END


GO
