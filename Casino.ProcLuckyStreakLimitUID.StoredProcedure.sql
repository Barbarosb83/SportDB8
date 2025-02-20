USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcLuckyStreakLimitUID]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Casino].[ProcLuckyStreakLimitUID]
@LimitGroupId bigint,
@TypeId int

AS


BEGIN
SET NOCOUNT ON;

declare @LimitId bigint






if exists (Select Casino.[LuckyStreak.Limit].LimitId from Casino.[LuckyStreak.Limit] where Casino.[LuckyStreak.Limit].LimitGroupId=@LimitGroupId)
	begin
		
		Select @LimitId=Casino.[LuckyStreak.Limit].LimitId from Casino.[LuckyStreak.Limit] where Casino.[LuckyStreak.Limit].LimitGroupId=@LimitGroupId
		
		
	update 	Casino.[LuckyStreak.Limit] set 
	[Type]=@TypeId
	where LimitGroupId=@LimitGroupId
		
	
	
	end
else
	begin
		insert 	Casino.[LuckyStreak.Limit](LimitGroupId,Type)
		values (@LimitGroupId,@TypeId)
		set @LimitId=SCOPE_IDENTITY()
	end


select @LimitId as LimitId

END





GO
