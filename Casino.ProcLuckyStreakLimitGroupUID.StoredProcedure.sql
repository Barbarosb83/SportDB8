USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcLuckyStreakLimitGroupUID]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Casino].[ProcLuckyStreakLimitGroupUID]
@GameId bigint,
@GroupId nvarchar(24),
@Name nvarchar(150)

AS


BEGIN
SET NOCOUNT ON;

declare @LimitGroupId bigint


if exists (Select Casino.[LuckyStreak.LimitGroup].LimitGroupId from Casino.[LuckyStreak.LimitGroup] where Casino.[LuckyStreak.LimitGroup].GroupId=@GroupId and Casino.[LuckyStreak.LimitGroup].GameId=@GameId)
	begin
		
		select @LimitGroupId=Casino.[LuckyStreak.LimitGroup].LimitGroupId from Casino.[LuckyStreak.LimitGroup]
		where GroupId=@GroupId and GameId=@GameId
		
		
	update 	Casino.[LuckyStreak.LimitGroup] set 
	GameId=@GameId
	,Name=@Name
	where LimitGroupId=@LimitGroupId
		
	
	
	end
else
	begin
		insert Casino.[LuckyStreak.LimitGroup](GameId,Name,GroupId)
		values (@GameId,@Name,@GroupId)
		set @LimitGroupId=SCOPE_IDENTITY()
	end


select @LimitGroupId as LimitGroupId

END





GO
