USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSportOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcSportOne]
@SportIdId int,
@username nvarchar(max)

AS



BEGIN
SET NOCOUNT ON;


SELECT     Parameter.Sport.SportId, Parameter.Sport.SportName, Parameter.Sport.IsActive, Parameter.Sport.Icon, Parameter.Sport.IconColor, Parameter.Sport.Limit, 
                      Parameter.Sport.LimitPerTicket, Parameter.MatchAvailability.AvailabilityId, Parameter.MatchAvailability.Availability
FROM         Parameter.Sport INNER JOIN
                      Parameter.MatchAvailability ON Parameter.Sport.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
WHERE       Parameter.Sport.SportId=@SportIdId             




END


GO
