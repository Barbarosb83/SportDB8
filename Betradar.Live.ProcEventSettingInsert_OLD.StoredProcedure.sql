USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventSettingInsert_OLD]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Betradar].[Live.ProcEventSettingInsert_OLD]
@TournamentId bigint,
@MatchId bigint
AS

 
BEGIN



Declare @SportId bigint=0
Declare @CategoryId bigint=0

SELECT    @CategoryId= Parameter.Category.CategoryId,@SportId= Parameter.Category.SportId
FROM         Parameter.Category with (nolock) INNER JOIN
                      Parameter.Tournament with (nolock) ON Parameter.Category.CategoryId = Parameter.Tournament.CategoryId
                      where Parameter.Tournament.TournamentId=@TournamentId


--Eğer Turnuva için bir kural varsa o kurallar ekleniyor.
if exists (select [Live].[RiskManagement.Rule].RuleId from [Live].[RiskManagement.Rule] with (nolock) where [Live].[RiskManagement.Rule].TournamentId=@TournamentId and [Live].[RiskManagement.Rule].CompetitorId=-1 and [Live].[RiskManagement.Rule].IsActive=1 and cast([Live].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) )
begin
	insert 	Live.EventSetting(MatchId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,IsPopular,MaxGainLimit)
	select top 1 @MatchId,[Live].[RiskManagement.Rule].StateId,[Live].[RiskManagement.Rule].LossLimit,[Live].[RiskManagement.Rule].LimitPerTicket,
	[Live].[RiskManagement.Rule].StakeLimit,[Live].[RiskManagement.Rule].AvailabilityId,[Live].[RiskManagement.Rule].MinCombiBranch,[Live].[RiskManagement.Rule].MinCombiInternet,[Live].[RiskManagement.Rule].MinCombiMachine,[Live].[RiskManagement.Rule].IsPopular,[Live].[RiskManagement.Rule].MaxGainTicket
	from [Live].[RiskManagement.Rule] with (nolock)
	where [Live].[RiskManagement.Rule].TournamentId=@TournamentId and [Live].[RiskManagement.Rule].CompetitorId=-1 and [Live].[RiskManagement.Rule].IsActive=1 and cast([Live].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE)
	Order By [Live].[RiskManagement.Rule].RuleId desc
end
else if exists(select  [Live].[RiskManagement.Rule].RuleId from [Live].[RiskManagement.Rule] with (nolock) where [Live].[RiskManagement.Rule].CategoryId=@CategoryId  and [Live].[RiskManagement.Rule].TournamentId=-1 and [Live].[RiskManagement.Rule].IsActive=1 and cast([Live].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE))
begin
	insert 	Live.EventSetting(MatchId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,IsPopular,MaxGainLimit)
	select top 1 @MatchId,[Live].[RiskManagement.Rule].StateId,[Live].[RiskManagement.Rule].LossLimit,[Live].[RiskManagement.Rule].LimitPerTicket,
	[Live].[RiskManagement.Rule].StakeLimit,[Live].[RiskManagement.Rule].AvailabilityId,[Live].[RiskManagement.Rule].MinCombiBranch,[Live].[RiskManagement.Rule].MinCombiInternet,[Live].[RiskManagement.Rule].MinCombiMachine,[Live].[RiskManagement.Rule].IsPopular,[Live].[RiskManagement.Rule].MaxGainTicket
	from [Live].[RiskManagement.Rule] with (nolock)
	where [Live].[RiskManagement.Rule].CategoryId=@CategoryId  and [Live].[RiskManagement.Rule].TournamentId=-1 and [Live].[RiskManagement.Rule].IsActive=1 and cast([Live].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE)
	Order By [Live].[RiskManagement.Rule].RuleId desc
end
else if exists (select [Live].[RiskManagement.Rule].RuleId from [Live].[RiskManagement.Rule] with (nolock) where [Live].[RiskManagement.Rule].SportId=@SportId and [Live].[RiskManagement.Rule].CategoryId=-1  and [Live].[RiskManagement.Rule].TournamentId=-1  and [Live].[RiskManagement.Rule].IsActive=1 and cast([Live].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE))
begin
	insert 	Live.EventSetting(MatchId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,IsPopular,MaxGainLimit)
	select top 1 @MatchId,[Live].[RiskManagement.Rule].StateId,[Live].[RiskManagement.Rule].LossLimit,[Live].[RiskManagement.Rule].LimitPerTicket,
	[Live].[RiskManagement.Rule].StakeLimit,[Live].[RiskManagement.Rule].AvailabilityId,[Live].[RiskManagement.Rule].MinCombiBranch,[Live].[RiskManagement.Rule].MinCombiInternet,[Live].[RiskManagement.Rule].MinCombiMachine,[Live].[RiskManagement.Rule].IsPopular,[Live].[RiskManagement.Rule].MaxGainTicket
	from [Live].[RiskManagement.Rule] with (nolock)
	where [Live].[RiskManagement.Rule].SportId=@SportId and [Live].[RiskManagement.Rule].CategoryId=-1  and [Live].[RiskManagement.Rule].TournamentId=-1  and [Live].[RiskManagement.Rule].IsActive=1 and cast([Live].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE)
	Order By [Live].[RiskManagement.Rule].RuleId desc
end
else
begin
	

	insert 	Live.EventSetting(MatchId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,IsPopular,MaxGainLimit)
	select top 1 @MatchId,[Live].[RiskManagement.Rule].StateId,[Live].[RiskManagement.Rule].LossLimit,[Live].[RiskManagement.Rule].LimitPerTicket,
	[Live].[RiskManagement.Rule].StakeLimit,[Live].[RiskManagement.Rule].AvailabilityId,[Live].[RiskManagement.Rule].MinCombiBranch,[Live].[RiskManagement.Rule].MinCombiInternet,[Live].[RiskManagement.Rule].MinCombiMachine,[Live].[RiskManagement.Rule].IsPopular,[Live].[RiskManagement.Rule].MaxGainTicket
	from [Live].[RiskManagement.Rule] with (nolock)
	where [Live].[RiskManagement.Rule].SportId=-1 and [Live].[RiskManagement.Rule].IsActive=1 and cast([Live].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE)
	Order By [Live].[RiskManagement.Rule].RuleId desc
end



END


GO
