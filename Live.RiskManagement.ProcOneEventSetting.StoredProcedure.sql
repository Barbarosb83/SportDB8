USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[RiskManagement.ProcOneEventSetting]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Live].[RiskManagement.ProcOneEventSetting]
	@EventId bigint,
	@LangId int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT     Live.EventSetting.SettingId, Parameter.MatchState.StateId, Parameter.MatchState.State, Parameter.MatchState.StatuColor, Live.EventSetting.LossLimit, 
                      Live.EventSetting.LimitPerTicket, Live.EventSetting.StakeLimit, Live.EventSetting.MaxGainLimit, Parameter.MatchAvailability.AvailabilityId, 
                      Parameter.MatchAvailability.Availability
FROM         Live.EventSetting with (nolock) INNER JOIN
                      Parameter.MatchState with (nolock) ON Live.EventSetting.StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability with (nolock) ON Live.EventSetting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
  Where Live.EventSetting.MatchId=@EventId
    
END


GO
