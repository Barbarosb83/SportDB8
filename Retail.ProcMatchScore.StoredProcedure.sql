USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcMatchScore]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [Retail].[ProcMatchScore]
@MatchId bigint,
@HalfTimeScore nvarchar(20),
@FullTimeScore nvarchar(20),
@MatchDate datetime


AS

BEGIN
 
 

if not exists (select Match.[Score].MatchId from [Match].[Score] with (nolock) where MatchId=@MatchId )
begin
	 INSERT INTO [Match].[Score]
           ([MatchId]
           ,[HalfTimeScore]
           ,[FullTimeScore]
           ,[MatchDate])
     VALUES (@MatchId,@HalfTimeScore,@FullTimeScore,@MatchDate)
	

	
end
ELSE
	UPDATE [Match].[Score] set
	[HalfTimeScore]=@HalfTimeScore,
	[FullTimeScore]=@FullTimeScore
	where MatchId=@MatchId  
	
 

	select 1
END


GO
