USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Outrights.ProcMatchOddResult]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [Betradar].[Outrights.ProcMatchOddResult]
@MatchId bigint,
@CompetitorId bigint,
@RankNo int

AS

BEGIN

declare @OddId bigint
--insert dbo.betslip values (@MatchId,'OUTR-'+cast(@CompetitorId as nvarchar(50))+'-'+cast(@RankNo as nvarchar(50)),GETDATE())

select @OddId=Outrights.Odd.OddId from Outrights.Odd  with (nolock) 
where Outrights.Odd.MatchId=@MatchId and Outrights.Odd.CompetitorId=@CompetitorId

if(@OddId is not null)
begin

if exists (select OddsResultId from Outrights.OddResult  with (nolock) where Outrights.OddResult.MatchId=@MatchId and Outrights.OddResult.OddId=@OddId)
begin

	UPDATE [Outrights].[OddResult]
	   SET [MatchId] = @MatchId
		  ,[OddId] = @OddId
		  ,[RankNo] = @RankNo
		  ,[CompetitorId] = @CompetitorId
		  ,[IsEvoluate] = 0
	 where Outrights.OddResult.MatchId=@MatchId and Outrights.OddResult.CompetitorId=@CompetitorId


end
else
begin
	INSERT INTO [Outrights].[OddResult]
			   ([MatchId]
			   ,[OddId]
			   ,[RankNo]
			   ,[CompetitorId]
			   ,[IsEvoluate])
		 VALUES
			   (@MatchId
			   ,@OddId
			   ,@RankNo
			   ,@CompetitorId
			   ,0)
end
end
END


GO
