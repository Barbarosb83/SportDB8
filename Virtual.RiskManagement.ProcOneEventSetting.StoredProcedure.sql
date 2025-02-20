USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Virtual].[RiskManagement.ProcOneEventSetting]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Virtual].[RiskManagement.ProcOneEventSetting]
	@EventId bigint,
	@LangId int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT     Virtual.EventSetting.SettingId, Parameter.MatchState.StateId, Parameter.MatchState.State, Parameter.MatchState.StatuColor, Virtual.EventSetting.LossLimit, 
                      Virtual.EventSetting.LimitPerTicket, Virtual.EventSetting.StakeLimit, Virtual.EventSetting.MaxGainLimit, Parameter.MatchAvailability.AvailabilityId, 
                      Parameter.MatchAvailability.Availability
FROM         Virtual.EventSetting INNER JOIN
                      Parameter.MatchState ON Virtual.EventSetting.StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability ON Virtual.EventSetting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
  Where Virtual.EventSetting.MatchId=@EventId
    
END


GO
