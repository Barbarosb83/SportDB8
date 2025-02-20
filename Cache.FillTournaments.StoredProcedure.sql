USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Cache].[FillTournaments]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [Cache].[FillTournaments]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @temptable  table (TournamentId int, CategoryId int,TournamentSportEventCount int,EndDay int,OddCount int)
    
    insert @temptable exec [Cache].[FillTournamentsbyDay] 7

	insert @temptable exec [Cache].[FillTournamentsbyDay] 4
		
	insert @temptable exec [Cache].[FillTournamentsbyDay] 2
		
	insert @temptable exec [Cache].[FillTournamentsbyDay] 1
    
    truncate table Cache.[Tournament]
    
INSERT INTO [Cache].[Tournament]
           ([TournamentId]
           ,[CategoryId]
           ,[TournamentSportEventCount]
           ,[EndDay])
    select TournamentId , CategoryId ,TournamentSportEventCount ,EndDay 
    from @temptable
    Where OddCount>0
    group by [TournamentId]
           ,[CategoryId]
           ,[TournamentSportEventCount]
           ,[EndDay]
    
    
END


GO
