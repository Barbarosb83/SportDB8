USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventOddNoOutCome]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE[Betradar].[Live.ProcEventOddNoOutCome]
@BetradarMatchId bigint,
@SpecialBetValue nvarchar(50),
@BettradarOddId bigint,
@IsActive bit,
@Combination bigint,
@ForTheRest nchar(30),
@Comment nchar(30),
@MostBalanced bit,
@Changed bit,
@BetradarTimeStamp datetime

AS

declare @OddTypeId int

BEGIN
--insert dbo.betslip values (@BetradarMatchId,cast(@BettradarOddId as nvarchar(50))+'NOOUTCOME-'+ISNULL(@SpecialBetValue,'')+'-'+CAST(@IsActive as nvarchar(50)),GETDATE())
 if (CHARINDEX('sr:',@SpecialBetValue) > 0)
	set @SpecialBetValue=null


		if(@SpecialBetValue is not null)
		begin
	
						UPDATE [Live].[EventOdd]
						   SET 
							  [IsActive] = @IsActive
							--  ,@OddTypeId=Live.EventOdd.OddsTypeId
					    --,[Live].[EventOdd].StateId=case when @IsActive=1 then 2 else 1 end
							  ,BetradarTimeStamp=@BetradarTimeStamp
							  ,UpdatedDate=GETDATE()
						 WHERE Live.EventOdd.BetradarPlayerId=@BettradarOddId and (live.EventOdd.SpecialBetValue=@SpecialBetValue) 
						 and Live.EventOdd.BetradarMatchId=@BetradarMatchId  -- and [Live].[EventOdd].BetradarTimeStamp<@BetradarTimeStamp
		end
		else
		begin
				UPDATE [Live].[EventOdd]
						   SET 
							  [IsActive] = @IsActive
							  ,BetradarTimeStamp=@BetradarTimeStamp
							   ,UpdatedDate=GETDATE()
							--   ,@OddTypeId=Live.EventOdd.OddsTypeId
							  --,[Live].[EventOdd].StateId=case when @IsActive=1 then 2 else 1 end
						 WHERE Live.EventOdd.BetradarPlayerId=@BettradarOddId  and Live.EventOdd.BetradarMatchId=@BetradarMatchId  -- and [Live].[EventOdd].BetradarTimeStamp<@BetradarTimeStamp
		end	

END



GO
