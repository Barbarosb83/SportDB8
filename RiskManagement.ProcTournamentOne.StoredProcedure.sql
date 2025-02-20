USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcTournamentOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcTournamentOne]
@TournamentId int,
@username nvarchar(max)

AS



BEGIN
SET NOCOUNT ON;


SELECT     Parameter.Tournament.TournamentId, Parameter.Tournament.TournamentName, Parameter.Tournament.IsActive, Parameter.Tournament.Limit, 
                      Parameter.Tournament.LimitPerTicket, Parameter.Tournament.AvailabilityId, Parameter.MatchAvailability.Availability,Parameter.Tournament.SequenceNumber
					  ,Parameter.Tournament.IsPopularTerminal
FROM         Parameter.Tournament INNER JOIN
                      Parameter.MatchAvailability ON Parameter.Tournament.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
Where      Parameter.Tournament.TournamentId=@TournamentId                 




END



GO
