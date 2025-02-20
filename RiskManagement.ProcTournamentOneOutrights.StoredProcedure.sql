USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcTournamentOneOutrights]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcTournamentOneOutrights]
@TournamentId int,
@username nvarchar(max)

AS



BEGIN
SET NOCOUNT ON;


SELECT     Parameter.TournamentOutrights.TournamentId, Parameter.TournamentOutrights.TournamentName, Parameter.TournamentOutrights.IsActive, Parameter.TournamentOutrights.Limit, 
                      Parameter.TournamentOutrights.LimitPerTicket, Parameter.TournamentOutrights.AvailabilityId, Parameter.TournamentOutrights.SequenceNumber
FROM         Parameter.TournamentOutrights 
Where      Parameter.TournamentOutrights.TournamentId=@TournamentId                 




END


GO
