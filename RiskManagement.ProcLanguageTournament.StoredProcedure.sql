USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcLanguageTournament]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcLanguageTournament]
@TournamentId bigint,
@Tournament nvarchar(250),
@BetradarId bigint,
@Language nvarchar(50)
 
AS



BEGIN
SET NOCOUNT ON;


INSERT INTO [Language].[NewTournament]
           (TournamentId,
		   [BetradarId]
           ,[TournamentName]
           ,[Lang])
     VALUES
           ( 
@TournamentId ,
@BetradarId ,
@Tournament ,
 
@Language)


END


GO
