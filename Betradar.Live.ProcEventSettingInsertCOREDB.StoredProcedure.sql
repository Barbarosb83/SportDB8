USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventSettingInsertCOREDB]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Betradar].[Live.ProcEventSettingInsertCOREDB]
 @MatchId bigint
AS

 
BEGIN

if not exists (Select MatchId from [Live].[EventSetting] with (nolock) where MatchId=@MatchId)
begin
INSERT INTO [Live].[EventSetting]
           ([MatchId]
           ,[StateId]
           ,[LossLimit]
           ,[LimitPerTicket]
           ,[StakeLimit]
           ,[AvailabilityId]
           ,[MinCombiBranch]
           ,[MinCombiInternet]
           ,[MinCombiMachine]
           ,[IsPopular]
           ,[MaxGainLimit])
     select [MatchId]
           ,[StateId]
           ,[LossLimit]
           ,[LimitPerTicket]
           ,[StakeLimit]
           ,[AvailabilityId]
           ,[MinCombiBranch]
           ,[MinCombiInternet]
           ,[MinCombiMachine]
           ,[IsPopular]
           ,[MaxGainLimit] from [Tip_CoreDB].[Live].[EventSetting] where MatchId=@MatchId

end

end
GO
