USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchOddClose]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [Betradar].[ProcMatchOddClose]
 @BetradarMatchId bigint,
 @OddTypeId int,
 @SpecialBetValue nvarchar(50)
AS
declare @OddIdd bigint
Declare @TempTournamentId bigint=0
Declare @TempMonitoringMatchId bigint=0
declare @TournamentId int=0
declare @MatchId bigint=0
declare @BetradarOddTypeId bigint
 
 



if(@OddTypeId in (48,49,202,553,206,232,233,332,234,453))
	set @SpecialBetValue=''

	
BEGIN
 --insert dbo.betslip values (@BetradarMatchId,'MatchOddClose-'+cast(@OddTypeId as nvarchar(50)),GETDATE())
		if exists (Select MatchId from Match.Match with (nolock) where BetradarMatchId=@BetradarMatchId)
			begin
			 
			--update Match.Setting set StateId=1 where MatchId=@MatchId
				if  @SpecialBetValue is not null
				begin
				update Match.Odd set StateId=1  where Match.Odd.BetradarMatchId=@BetradarMatchId and Match.Odd.BetradarOddTypeId=@OddTypeId and SpecialBetValue=@SpecialBetValue
				
				--update Match.OddSetting set StateId=1 where Match.OddSetting.OddId=@OddIdd and Match.Odd
				end
				else
				begin
				update Match.Odd set StateId=1 where Match.Odd.BetradarMatchId=@BetradarMatchId and Match.Odd.BetradarOddTypeId=@OddTypeId 
				--update Match.OddSetting set StateId=1 where Match.OddSetting.OddId in (Select OddId from Match.Odd with (nolock) where MatchId=@MatchId and Match.Odd.BetradarOddTypeId=@OddTypeId )
				end
			end
		
	return @MatchId

END


GO
