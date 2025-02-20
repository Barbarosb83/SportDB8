USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchSettingInsert]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[ProcMatchSettingInsert]
@TournamentId bigint,
@MatchId bigint
AS

Declare @SportId bigint=0
Declare @CategoryId bigint=0
BEGIN


select @CategoryId= Parameter.Tournament.CategoryId from Parameter.Tournament with (nolock)
where Parameter.Tournament.TournamentId=@TournamentId

select @SportId=Parameter.Category.SportId from Parameter.Category with (nolock)
where Parameter.Category.CategoryId=@CategoryId


--Eğer Turnuva için bir kural varsa o kurallar ekleniyor.
if exists (select [RiskManagement].[Rule].RuleId from [RiskManagement].[Rule] with (nolock) where [RiskManagement].[Rule].TournamentId=@TournamentId and [RiskManagement].[Rule].CompetitorId=-1 and [RiskManagement].[Rule].IsActive=1 and cast([RiskManagement].[Rule].StopDate as DATE)>CAST(GETDATE() as DATE) )
begin
	insert 	Match.Setting(MatchId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,IsPopular,MaxGainLimit)
	select top 1 @MatchId,[RiskManagement].[Rule].StateId,[RiskManagement].[Rule].LossLimit,[RiskManagement].[Rule].LimitPerTicket,
	[RiskManagement].[Rule].StakeLimit,[RiskManagement].[Rule].AvailabilityId,[RiskManagement].[Rule].MinCombiBranch,[RiskManagement].[Rule].MinCombiInternet,[RiskManagement].[Rule].MinCombiMachine,[RiskManagement].[Rule].IsPopular,[RiskManagement].[Rule].MaxGainTicket
	from [RiskManagement].[Rule] with (nolock)
	where [RiskManagement].[Rule].TournamentId=@TournamentId and [RiskManagement].[Rule].IsActive=1 
	and cast([RiskManagement].[Rule].StopDate as DATE)>CAST(GETDATE() as DATE)
	--Order By [RiskManagement].[Rule].RuleId desc
end
else if exists (select [RiskManagement].[Rule].RuleId from [RiskManagement].[Rule] with (nolock) where [RiskManagement].[Rule].CategoryId=@CategoryId  and [RiskManagement].[Rule].TournamentId=-1 and [RiskManagement].[Rule].IsActive=1 and cast([RiskManagement].[Rule].StopDate as DATE)>CAST(GETDATE() as DATE))
begin
	insert 	Match.Setting(MatchId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,IsPopular,MaxGainLimit)
	select top 1 @MatchId,[RiskManagement].[Rule].StateId,[RiskManagement].[Rule].LossLimit,[RiskManagement].[Rule].LimitPerTicket,
	[RiskManagement].[Rule].StakeLimit,[RiskManagement].[Rule].AvailabilityId,[RiskManagement].[Rule].MinCombiBranch,[RiskManagement].[Rule].MinCombiInternet,[RiskManagement].[Rule].MinCombiMachine,[RiskManagement].[Rule].IsPopular,[RiskManagement].[Rule].MaxGainTicket
	from [RiskManagement].[Rule]  with (nolock)
	where [RiskManagement].[Rule].CategoryId=@CategoryId and [RiskManagement].[Rule].IsActive=1 
	and cast([RiskManagement].[Rule].StopDate as DATE)>CAST(GETDATE() as DATE)
	--Order By [RiskManagement].[Rule].RuleId desc
end
else if exists(select [RiskManagement].[Rule].RuleId from [RiskManagement].[Rule] with (nolock) where [RiskManagement].[Rule].SportId=@SportId and [RiskManagement].[Rule].CategoryId=-1  and [RiskManagement].[Rule].TournamentId=-1  and [RiskManagement].[Rule].IsActive=1 and cast([RiskManagement].[Rule].StopDate as DATE)>CAST(GETDATE() as DATE))
begin
	insert 	Match.Setting(MatchId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,IsPopular,MaxGainLimit)
	select top 1 @MatchId,[RiskManagement].[Rule].StateId,[RiskManagement].[Rule].LossLimit,[RiskManagement].[Rule].LimitPerTicket,
	[RiskManagement].[Rule].StakeLimit,[RiskManagement].[Rule].AvailabilityId,[RiskManagement].[Rule].MinCombiBranch,[RiskManagement].[Rule].MinCombiInternet,[RiskManagement].[Rule].MinCombiMachine,[RiskManagement].[Rule].IsPopular,[RiskManagement].[Rule].MaxGainTicket
	from [RiskManagement].[Rule] with (nolock)
	where [RiskManagement].[Rule].SportId=@SportId and [RiskManagement].[Rule].CategoryId=-1  and [RiskManagement].[Rule].TournamentId=-1 and [RiskManagement].[Rule].IsActive=1 and cast([RiskManagement].[Rule].StopDate as DATE)>CAST(GETDATE() as DATE)
	--Order By [RiskManagement].[Rule].RuleId desc
end
else
begin
	insert 	Match.Setting(MatchId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,IsPopular,MaxGainLimit)
	select top 1 @MatchId,[RiskManagement].[Rule].StateId,[RiskManagement].[Rule].LossLimit,[RiskManagement].[Rule].LimitPerTicket,
	[RiskManagement].[Rule].StakeLimit,[RiskManagement].[Rule].AvailabilityId,[RiskManagement].[Rule].MinCombiBranch,[RiskManagement].[Rule].MinCombiInternet,[RiskManagement].[Rule].MinCombiMachine,0,[RiskManagement].[Rule].MaxGainTicket
	from [RiskManagement].[Rule] with (nolock)
	where [RiskManagement].[Rule].SportId=-1 and [RiskManagement].[Rule].IsActive=1 and cast([RiskManagement].[Rule].StopDate as DATE)>CAST(GETDATE() as DATE)
	--Order By [RiskManagement].[Rule].RuleId desc
end



END


GO
