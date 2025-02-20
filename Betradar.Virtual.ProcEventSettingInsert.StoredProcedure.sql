USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Virtual.ProcEventSettingInsert]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Virtual.ProcEventSettingInsert]
@TournamentId bigint,
@MatchId bigint
AS

Declare @SportId bigint=0
Declare @CategoryId bigint=0
BEGIN


select @CategoryId= Parameter.Tournament.CategoryId from Parameter.Tournament
where Parameter.Tournament.TournamentId=@TournamentId

select @SportId=Parameter.Category.SportId from Parameter.Category
where Parameter.Category.CategoryId=@CategoryId


--Eğer Turnuva için bir kural varsa o kurallar ekleniyor.
if(select COUNT([Virtual].[RiskManagement.Rule].RuleId) from [Virtual].[RiskManagement.Rule] where [Virtual].[RiskManagement.Rule].TournamentId=@TournamentId and [Virtual].[RiskManagement.Rule].CompetitorId=-1 and [Virtual].[RiskManagement.Rule].IsActive=1 and cast([Virtual].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) )>0
begin
	insert 	Virtual.EventSetting(MatchId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,IsPopular,MaxGainLimit)
	select top 1 @MatchId,[Virtual].[RiskManagement.Rule].StateId,[Virtual].[RiskManagement.Rule].LossLimit,[Virtual].[RiskManagement.Rule].LimitPerTicket,
	[Virtual].[RiskManagement.Rule].StakeLimit,[Virtual].[RiskManagement.Rule].AvailabilityId,[Virtual].[RiskManagement.Rule].MinCombiBranch,[Virtual].[RiskManagement.Rule].MinCombiInternet,[Virtual].[RiskManagement.Rule].MinCombiMachine,[Virtual].[RiskManagement.Rule].IsPopular,[Virtual].[RiskManagement.Rule].MaxGainTicket
	from [Virtual].[RiskManagement.Rule]
	where [Virtual].[RiskManagement.Rule].TournamentId=@TournamentId and [Virtual].[RiskManagement.Rule].IsActive=1 and cast([Virtual].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE)
	Order By [Virtual].[RiskManagement.Rule].RuleId desc
end
else if(select COUNT([Virtual].[RiskManagement.Rule].RuleId) from [Virtual].[RiskManagement.Rule] where [Virtual].[RiskManagement.Rule].CategoryId=@CategoryId  and [Virtual].[RiskManagement.Rule].TournamentId=-1 and [Virtual].[RiskManagement.Rule].IsActive=1 and cast([Virtual].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE))>0
begin
	insert 	Virtual.EventSetting(MatchId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,IsPopular,MaxGainLimit)
	select top 1 @MatchId,[Virtual].[RiskManagement.Rule].StateId,[Virtual].[RiskManagement.Rule].LossLimit,[Virtual].[RiskManagement.Rule].LimitPerTicket,
	[Virtual].[RiskManagement.Rule].StakeLimit,[Virtual].[RiskManagement.Rule].AvailabilityId,[Virtual].[RiskManagement.Rule].MinCombiBranch,[Virtual].[RiskManagement.Rule].MinCombiInternet,[Virtual].[RiskManagement.Rule].MinCombiMachine,[Virtual].[RiskManagement.Rule].IsPopular,[Virtual].[RiskManagement.Rule].MaxGainTicket
	from [Virtual].[RiskManagement.Rule]
	where [Virtual].[RiskManagement.Rule].CategoryId=@CategoryId and [Virtual].[RiskManagement.Rule].IsActive=1 and cast([Virtual].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE)
	Order By [Virtual].[RiskManagement.Rule].RuleId desc
end
else if(select COUNT([Virtual].[RiskManagement.Rule].RuleId) from [Virtual].[RiskManagement.Rule] where [Virtual].[RiskManagement.Rule].SportId=@SportId and [Virtual].[RiskManagement.Rule].CategoryId=-1  and [Virtual].[RiskManagement.Rule].TournamentId=-1  and [Virtual].[RiskManagement.Rule].IsActive=1 and cast([Virtual].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE))>0
begin
	insert 	Virtual.EventSetting(MatchId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,IsPopular,MaxGainLimit)
	select top 1 @MatchId,[Virtual].[RiskManagement.Rule].StateId,[Virtual].[RiskManagement.Rule].LossLimit,[Virtual].[RiskManagement.Rule].LimitPerTicket,
	[Virtual].[RiskManagement.Rule].StakeLimit,[Virtual].[RiskManagement.Rule].AvailabilityId,[Virtual].[RiskManagement.Rule].MinCombiBranch,[Virtual].[RiskManagement.Rule].MinCombiInternet,[Virtual].[RiskManagement.Rule].MinCombiMachine,[Virtual].[RiskManagement.Rule].IsPopular,[Virtual].[RiskManagement.Rule].MaxGainTicket
	from [Virtual].[RiskManagement.Rule]
	where [Virtual].[RiskManagement.Rule].SportId=@SportId and [Virtual].[RiskManagement.Rule].CategoryId=-1  and [Virtual].[RiskManagement.Rule].TournamentId=-1 and [Virtual].[RiskManagement.Rule].IsActive=1 and cast([Virtual].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE)
	Order By [Virtual].[RiskManagement.Rule].RuleId desc
end
else
begin
	

	insert 	Virtual.EventSetting(MatchId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,IsPopular,MaxGainLimit)
	select top 1 @MatchId,[Virtual].[RiskManagement.Rule].StateId,[Virtual].[RiskManagement.Rule].LossLimit,[Virtual].[RiskManagement.Rule].LimitPerTicket,
	[Virtual].[RiskManagement.Rule].StakeLimit,[Virtual].[RiskManagement.Rule].AvailabilityId,[Virtual].[RiskManagement.Rule].MinCombiBranch,[Virtual].[RiskManagement.Rule].MinCombiInternet,[Virtual].[RiskManagement.Rule].MinCombiMachine,[Virtual].[RiskManagement.Rule].IsPopular,[Virtual].[RiskManagement.Rule].MaxGainTicket
	from [Virtual].[RiskManagement.Rule]
	where [Virtual].[RiskManagement.Rule].SportId=-1 and [Virtual].[RiskManagement.Rule].IsActive=1 and cast([Virtual].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE)
	Order By [Virtual].[RiskManagement.Rule].RuleId desc
end



END


GO
