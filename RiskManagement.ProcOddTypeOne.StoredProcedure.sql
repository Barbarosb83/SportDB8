USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcOddTypeOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcOddTypeOne]
@OddsTypeId int,
@username nvarchar(max)

AS



BEGIN
SET NOCOUNT ON;


SELECT     Parameter.OddsType.OddsTypeId, Parameter.OddsType.OddsType, Parameter.OddsType.OutcomesDescription, Parameter.OddsType.AvailabilityId, 
                      Parameter.MatchAvailability.Availability, Parameter.OddsType.IsActive, Parameter.OddsType.ShortSign,Parameter.OddsType.IsPopular,Parameter.OddsType.SeqNumber
FROM         Parameter.OddsType INNER JOIN
                      Parameter.MatchAvailability ON Parameter.OddsType.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
                      where Parameter.OddsType.OddsTypeId=@OddsTypeId




END


GO
