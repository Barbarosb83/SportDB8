USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Virtual.ProcOddSettingInsert]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Virtual.ProcOddSettingInsert]
@OddTypeId bigint,
@OddId bigint,
@MatchId int
AS


BEGIN

declare @SportId int
declare @CategoryId int
declare @TournamentId int

SELECT    @SportId= Parameter.Category.SportId,@CategoryId= Parameter.Category.CategoryId,@TournamentId=Parameter.Tournament.TournamentId
FROM         Parameter.Category INNER JOIN
                      Parameter.Tournament ON Parameter.Category.CategoryId = Parameter.Tournament.CategoryId INNER JOIN
                      Match.Match ON Parameter.Tournament.TournamentId = Match.Match.TournamentId
WHERE     (Match.Match.MatchId = @MatchId)


--Eğer Turnuva için bir kural varsa o kurallar ekleniyor.
if(select COUNT([Virtual].[RiskManagement.RuleOddType].RuleOddTypeId) from [Virtual].[RiskManagement.RuleOddType] where [Virtual].[RiskManagement.RuleOddType].OddTypeId=@OddTypeId and (select Count([Virtual].[RiskManagement.Rule].RuleId) from [Virtual].[RiskManagement.Rule] where [Virtual].[RiskManagement.Rule].IsActive=1 and cast([Virtual].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) and TournamentId=@TournamentId and CompetitorId=-1 and [Virtual].[RiskManagement.Rule].RuleId in (select [Virtual].[RiskManagement.RuleOddType].RuleId from [Virtual].[RiskManagement.RuleOddType] where [Virtual].[RiskManagement.RuleOddType].OddTypeId=@OddTypeId ))>0 )>0
begin
	if(select COUNT(*) from [Virtual].[EventOddTypeSetting] where MatchId=@MatchId and OddTypeId=@OddTypeId)=0
		begin
			insert [Virtual].[EventOddTypeSetting](OddTypeId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,MatchId,IsPopular,MaxGainLimit)
			select top 1 [Virtual].[RiskManagement.RuleOddType].OddTypeId,[Virtual].[RiskManagement.RuleOddType].StateId,[Virtual].[RiskManagement.RuleOddType].LossLimit,[Virtual].[RiskManagement.RuleOddType].LimitPerTicket,
			[Virtual].[RiskManagement.RuleOddType].StakeLimit,[Virtual].[RiskManagement.RuleOddType].AvailabilityId,[Virtual].[RiskManagement.RuleOddType].MinCombiBranch,[Virtual].[RiskManagement.RuleOddType].MinCombiInternet,[Virtual].[RiskManagement.RuleOddType].MinCombiMachine,@MatchId,[Virtual].[RiskManagement.RuleOddType].IsPopular,[Virtual].[RiskManagement.RuleOddType].MaxGainTicket
			from [Virtual].[RiskManagement.RuleOddType]
			where [Virtual].[RiskManagement.RuleOddType].OddTypeId=@OddTypeId and [Virtual].[RiskManagement.RuleOddType].RuleId in (select [Virtual].[RiskManagement.Rule].RuleId from [Virtual].[RiskManagement.Rule] where [Virtual].[RiskManagement.Rule].IsActive=1 and  TournamentId=@TournamentId and CompetitorId=-1 and cast([Virtual].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) )
			Order By [Virtual].[RiskManagement.RuleOddType].RuleOddTypeId desc
		end
			insert [Virtual].[EventOddSetting](OddId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine)
			select top 1 @OddId,[Virtual].[RiskManagement.RuleOddType].StateId,[Virtual].[RiskManagement.RuleOddType].LossLimit,[Virtual].[RiskManagement.RuleOddType].LimitPerTicket,
			[Virtual].[RiskManagement.RuleOddType].StakeLimit,[Virtual].[RiskManagement.RuleOddType].AvailabilityId,[Virtual].[RiskManagement.RuleOddType].MinCombiBranch,[Virtual].[RiskManagement.RuleOddType].MinCombiInternet,[Virtual].[RiskManagement.RuleOddType].MinCombiMachine
			from [Virtual].[RiskManagement.RuleOddType]
			where [Virtual].[RiskManagement.RuleOddType].OddTypeId=@OddTypeId and [Virtual].[RiskManagement.RuleOddType].RuleId in (select [Virtual].[RiskManagement.Rule].RuleId from [Virtual].[RiskManagement.Rule] where [Virtual].[RiskManagement.Rule].IsActive=1 and  TournamentId=@TournamentId and CompetitorId=-1 and cast([Virtual].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) )
			Order By [Virtual].[RiskManagement.RuleOddType].RuleOddTypeId desc
end
else if(select COUNT([Virtual].[RiskManagement.RuleOddType].RuleOddTypeId) from [Virtual].[RiskManagement.RuleOddType] where [Virtual].[RiskManagement.RuleOddType].OddTypeId=@OddTypeId and (select Count([Virtual].[RiskManagement.Rule].RuleId) from [Virtual].[RiskManagement.Rule] where [Virtual].[RiskManagement.Rule].IsActive=1 and cast([Virtual].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) and CategoryId=@CategoryId and TournamentId=-1 and [Virtual].[RiskManagement.Rule].RuleId in (select [Virtual].[RiskManagement.RuleOddType].RuleId from [Virtual].[RiskManagement.RuleOddType] where [Virtual].[RiskManagement.RuleOddType].OddTypeId=@OddTypeId ))>0 )>0
begin
	if(select COUNT(*) from [Virtual].[EventOddTypeSetting] where MatchId=@MatchId and OddTypeId=@OddTypeId)=0
		begin
			insert [Virtual].[EventOddTypeSetting](OddTypeId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,MatchId,IsPopular,MaxGainLimit)
			select top 1 [Virtual].[RiskManagement.RuleOddType].OddTypeId,[Virtual].[RiskManagement.RuleOddType].StateId,[Virtual].[RiskManagement.RuleOddType].LossLimit,[Virtual].[RiskManagement.RuleOddType].LimitPerTicket,
			[Virtual].[RiskManagement.RuleOddType].StakeLimit,[Virtual].[RiskManagement.RuleOddType].AvailabilityId,[Virtual].[RiskManagement.RuleOddType].MinCombiBranch,[Virtual].[RiskManagement.RuleOddType].MinCombiInternet,[Virtual].[RiskManagement.RuleOddType].MinCombiMachine,@MatchId,[Virtual].[RiskManagement.RuleOddType].IsPopular,[Virtual].[RiskManagement.RuleOddType].MaxGainTicket
			from [Virtual].[RiskManagement.RuleOddType]
			where [Virtual].[RiskManagement.RuleOddType].OddTypeId=@OddTypeId and [Virtual].[RiskManagement.RuleOddType].RuleId in (select [Virtual].[RiskManagement.Rule].RuleId from [Virtual].[RiskManagement.Rule] where [Virtual].[RiskManagement.Rule].IsActive=1 and  CategoryId=@CategoryId and TournamentId=-1 and cast([Virtual].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) )
			Order By [Virtual].[RiskManagement.RuleOddType].RuleOddTypeId desc
		end
			insert [Virtual].[EventOddSetting](OddId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine)
			select top 1 @OddId,[Virtual].[RiskManagement.RuleOddType].StateId,[Virtual].[RiskManagement.RuleOddType].LossLimit,[Virtual].[RiskManagement.RuleOddType].LimitPerTicket,
			[Virtual].[RiskManagement.RuleOddType].StakeLimit,[Virtual].[RiskManagement.RuleOddType].AvailabilityId,[Virtual].[RiskManagement.RuleOddType].MinCombiBranch,[Virtual].[RiskManagement.RuleOddType].MinCombiInternet,[Virtual].[RiskManagement.RuleOddType].MinCombiMachine
			from [Virtual].[RiskManagement.RuleOddType]
			where [Virtual].[RiskManagement.RuleOddType].OddTypeId=@OddTypeId and [Virtual].[RiskManagement.RuleOddType].RuleId in (select [Virtual].[RiskManagement.Rule].RuleId from [Virtual].[RiskManagement.Rule] where [Virtual].[RiskManagement.Rule].IsActive=1 and  CategoryId=@CategoryId and TournamentId=-1 and cast([Virtual].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) )
			Order By [Virtual].[RiskManagement.RuleOddType].RuleOddTypeId desc
end
else if(select COUNT([Virtual].[RiskManagement.RuleOddType].RuleOddTypeId) from [Virtual].[RiskManagement.RuleOddType] where [Virtual].[RiskManagement.RuleOddType].OddTypeId=@OddTypeId and (select Count([Virtual].[RiskManagement.Rule].RuleId) from [Virtual].[RiskManagement.Rule] where [Virtual].[RiskManagement.Rule].IsActive=1 and cast([Virtual].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) and SportId=@SportId and CategoryId=-1 and [Virtual].[RiskManagement.Rule].RuleId in (select [Virtual].[RiskManagement.RuleOddType].RuleId from [Virtual].[RiskManagement.RuleOddType] where [Virtual].[RiskManagement.RuleOddType].OddTypeId=@OddTypeId ))>0 )>0
begin
	if(select COUNT(*) from [Virtual].[EventOddTypeSetting] where MatchId=@MatchId and OddTypeId=@OddTypeId)=0
		begin
			insert [Virtual].[EventOddTypeSetting](OddTypeId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,MatchId,IsPopular,MaxGainLimit)
			select top 1 [Virtual].[RiskManagement.RuleOddType].OddTypeId,[Virtual].[RiskManagement.RuleOddType].StateId,[Virtual].[RiskManagement.RuleOddType].LossLimit,[Virtual].[RiskManagement.RuleOddType].LimitPerTicket,
			[Virtual].[RiskManagement.RuleOddType].StakeLimit,[Virtual].[RiskManagement.RuleOddType].AvailabilityId,[Virtual].[RiskManagement.RuleOddType].MinCombiBranch,[Virtual].[RiskManagement.RuleOddType].MinCombiInternet,[Virtual].[RiskManagement.RuleOddType].MinCombiMachine,@MatchId,[Virtual].[RiskManagement.RuleOddType].IsPopular,[Virtual].[RiskManagement.RuleOddType].MaxGainTicket
			from [Virtual].[RiskManagement.RuleOddType]
			where [Virtual].[RiskManagement.RuleOddType].OddTypeId=@OddTypeId and [Virtual].[RiskManagement.RuleOddType].RuleId in (select [Virtual].[RiskManagement.Rule].RuleId from [Virtual].[RiskManagement.Rule] where [Virtual].[RiskManagement.Rule].IsActive=1 and  SportId=@SportId and CategoryId=-1 and cast([Virtual].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) )
			Order By [Virtual].[RiskManagement.RuleOddType].RuleOddTypeId desc
		end
			insert [Virtual].[EventOddSetting](OddId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine)
			select top 1 @OddId,[Virtual].[RiskManagement.RuleOddType].StateId,[Virtual].[RiskManagement.RuleOddType].LossLimit,[Virtual].[RiskManagement.RuleOddType].LimitPerTicket,
			[Virtual].[RiskManagement.RuleOddType].StakeLimit,[Virtual].[RiskManagement.RuleOddType].AvailabilityId,[Virtual].[RiskManagement.RuleOddType].MinCombiBranch,[Virtual].[RiskManagement.RuleOddType].MinCombiInternet,[Virtual].[RiskManagement.RuleOddType].MinCombiMachine
			from [Virtual].[RiskManagement.RuleOddType]
			where [Virtual].[RiskManagement.RuleOddType].OddTypeId=@OddTypeId and [Virtual].[RiskManagement.RuleOddType].RuleId in (select [Virtual].[RiskManagement.Rule].RuleId from [Virtual].[RiskManagement.Rule] where [Virtual].[RiskManagement.Rule].IsActive=1 and  SportId=@SportId and CategoryId=-1 and cast([Virtual].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) )
			Order By [Virtual].[RiskManagement.RuleOddType].RuleOddTypeId desc
end
else if(select COUNT([Virtual].[RiskManagement.RuleOddType].RuleOddTypeId) from [Virtual].[RiskManagement.RuleOddType] where [Virtual].[RiskManagement.RuleOddType].OddTypeId=@OddTypeId and (select Count([Virtual].[RiskManagement.Rule].RuleId) from [Virtual].[RiskManagement.Rule] where [Virtual].[RiskManagement.Rule].IsActive=1 and cast([Virtual].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) and SportId=-1 and [Virtual].[RiskManagement.Rule].RuleId in (select [Virtual].[RiskManagement.RuleOddType].RuleId from [Virtual].[RiskManagement.RuleOddType] where [Virtual].[RiskManagement.RuleOddType].OddTypeId=@OddTypeId ))>0 )>0
begin
	if(select COUNT(*) from [Virtual].[EventOddTypeSetting] where MatchId=@MatchId and OddTypeId=@OddTypeId)=0
		begin
			insert [Virtual].[EventOddTypeSetting](OddTypeId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,MatchId,IsPopular,MaxGainLimit)
			select top 1 [Virtual].[RiskManagement.RuleOddType].OddTypeId,[Virtual].[RiskManagement.RuleOddType].StateId,[Virtual].[RiskManagement.RuleOddType].LossLimit,[Virtual].[RiskManagement.RuleOddType].LimitPerTicket,
			[Virtual].[RiskManagement.RuleOddType].StakeLimit,[Virtual].[RiskManagement.RuleOddType].AvailabilityId,[Virtual].[RiskManagement.RuleOddType].MinCombiBranch,[Virtual].[RiskManagement.RuleOddType].MinCombiInternet,[Virtual].[RiskManagement.RuleOddType].MinCombiMachine,@MatchId,[Virtual].[RiskManagement.RuleOddType].IsPopular,[Virtual].[RiskManagement.RuleOddType].MaxGainTicket
			from [Virtual].[RiskManagement.RuleOddType]
			where [Virtual].[RiskManagement.RuleOddType].OddTypeId=@OddTypeId and [Virtual].[RiskManagement.RuleOddType].RuleId in (select [Virtual].[RiskManagement.Rule].RuleId from [Virtual].[RiskManagement.Rule] where [Virtual].[RiskManagement.Rule].IsActive=1 and  SportId=-1  and cast([Virtual].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) )
			Order By [Virtual].[RiskManagement.RuleOddType].RuleOddTypeId desc
		end
			insert [Virtual].[EventOddSetting](OddId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine)
			select top 1 @OddId,[Virtual].[RiskManagement.RuleOddType].StateId,[Virtual].[RiskManagement.RuleOddType].LossLimit,[Virtual].[RiskManagement.RuleOddType].LimitPerTicket,
			[Virtual].[RiskManagement.RuleOddType].StakeLimit,[Virtual].[RiskManagement.RuleOddType].AvailabilityId,[Virtual].[RiskManagement.RuleOddType].MinCombiBranch,[Virtual].[RiskManagement.RuleOddType].MinCombiInternet,[Virtual].[RiskManagement.RuleOddType].MinCombiMachine
			from [Virtual].[RiskManagement.RuleOddType]
			where [Virtual].[RiskManagement.RuleOddType].OddTypeId=@OddTypeId and [Virtual].[RiskManagement.RuleOddType].RuleId in (select [Virtual].[RiskManagement.Rule].RuleId from [Virtual].[RiskManagement.Rule] where [Virtual].[RiskManagement.Rule].IsActive=1 and  SportId=-1  and cast([Virtual].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) )
			Order By [Virtual].[RiskManagement.RuleOddType].RuleOddTypeId desc
end
else
begin
	if(select COUNT(*) from [Virtual].[EventOddTypeSetting] where MatchId=@MatchId and OddTypeId=@OddTypeId)=0
		begin
			insert [Virtual].[EventOddTypeSetting](OddTypeId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,MatchId,IsPopular,MaxGainLimit)
			values(@OddTypeId,1,0,0,0,1,3,3,3,@MatchId,0,0)
		end
			insert [Virtual].[EventOddSetting](OddId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine)
			values(@OddId,1,0,0,0,1,3,3,3)
end



END


GO
