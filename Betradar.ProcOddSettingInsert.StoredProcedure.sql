USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcOddSettingInsert]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[ProcOddSettingInsert]
@OddTypeId bigint,
@OddId bigint,
@MatchId int,
@SportId int,
 @CategoryId int,
 @TournamentId int
AS


BEGIN

 

--select top 1 @OddTypeId=Parameter.OddsType.OddsTypeId from Parameter.OddsType with (nolock) where Parameter.OddsType.BetradarOddsTypeId=@OddTypeId and Parameter.OddsType.SportId=@SportId

--Eğer Turnuva için bir kural varsa o kurallar ekleniyor.
--if exists (select [RiskManagement].[Rule].RuleId from --[RiskManagement].[RuleOddType] with (nolock) INNER JOIN 
--RiskManagement.[Rule] with (nolock) -- ON RiskManagement.RuleOddType.RuleId=RiskManagement.[Rule].RuleId 
--where  [RiskManagement].[Rule].IsActive=1 and cast([RiskManagement].[Rule].StopDate as DATE)>CAST(GETDATE() as DATE) and TournamentId=@TournamentId and CompetitorId=-1 )
--begin
--	if not exists (select Match.OddTypeSetting.OddTypeSettingId from Match.OddTypeSetting with (nolock) where MatchId=@MatchId and OddTypeId=@OddTypeId)
--		begin
--			insert Match.OddTypeSetting(OddTypeId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,MatchId,IsPopular,MaxGainLimit)
--			select top 1 [RiskManagement].[RuleOddType].OddTypeId,[RiskManagement].[RuleOddType].StateId,[RiskManagement].[RuleOddType].LossLimit,[RiskManagement].[RuleOddType].LimitPerTicket,
--			[RiskManagement].[RuleOddType].StakeLimit,[RiskManagement].[RuleOddType].AvailabilityId,[RiskManagement].[RuleOddType].MinCombiBranch,[RiskManagement].[RuleOddType].MinCombiInternet,[RiskManagement].[RuleOddType].MinCombiMachine,@MatchId,[RiskManagement].[RuleOddType].IsPopular,[RiskManagement].[RuleOddType].MaxGainTicket
--			from [RiskManagement].[RuleOddType] with (nolock) INNER JOIN RiskManagement.[Rule] with (nolock) On RiskManagement.[RuleOddType].RuleId=RiskManagement.[Rule].RuleId
--			where [RiskManagement].[RuleOddType].OddTypeId=@OddTypeId 
--			and [RiskManagement].[Rule].IsActive=1 and  TournamentId=@TournamentId and CompetitorId=-1 and cast([RiskManagement].[Rule].StopDate as DATE)>CAST(GETDATE() as DATE)
--			--Order By [RiskManagement].[RuleOddType].RuleOddTypeId desc
--		end
--			--insert Match.OddSetting(OddId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine)
--			--select top 1 @OddId,[RiskManagement].[RuleOddType].StateId,[RiskManagement].[RuleOddType].LossLimit,[RiskManagement].[RuleOddType].LimitPerTicket,
--			--[RiskManagement].[RuleOddType].StakeLimit,[RiskManagement].[RuleOddType].AvailabilityId,[RiskManagement].[RuleOddType].MinCombiBranch,[RiskManagement].[RuleOddType].MinCombiInternet,[RiskManagement].[RuleOddType].MinCombiMachine
--			--from [RiskManagement].[RuleOddType]  with (nolock) INNER JOIN RiskManagement.[Rule] with (nolock) On RiskManagement.[RuleOddType].RuleId=RiskManagement.[Rule].RuleId
--			--where [RiskManagement].[RuleOddType].OddTypeId=@OddTypeId and [RiskManagement].[Rule].IsActive=1 and  TournamentId=@TournamentId and CompetitorId=-1 and cast([RiskManagement].[Rule].StopDate as DATE)>CAST(GETDATE() as DATE)
--			--Order By [RiskManagement].[RuleOddType].RuleOddTypeId desc
--end
--else if exists(select RiskManagement.[Rule].RuleId from --[RiskManagement].[RuleOddType] with (nolock) INNER JOIN 
--RiskManagement.[Rule] with (nolock) --ON RiskManagement.RuleOddType.RuleId=RiskManagement.[Rule].RuleId 
--where  [RiskManagement].[Rule].IsActive=1 and cast([RiskManagement].[Rule].StopDate as DATE)>CAST(GETDATE() as DATE) and CategoryId=@CategoryId and TournamentId=-1 )
--begin
--	if not exists (select Match.OddTypeSetting.OddTypeSettingId from Match.OddTypeSetting with (nolock) where MatchId=@MatchId and OddTypeId=@OddTypeId)
--		begin
--			insert Match.OddTypeSetting(OddTypeId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,MatchId,IsPopular,MaxGainLimit)
--			select top 1 [RiskManagement].[RuleOddType].OddTypeId,[RiskManagement].[RuleOddType].StateId,[RiskManagement].[RuleOddType].LossLimit,[RiskManagement].[RuleOddType].LimitPerTicket,
--			[RiskManagement].[RuleOddType].StakeLimit,[RiskManagement].[RuleOddType].AvailabilityId,[RiskManagement].[RuleOddType].MinCombiBranch,[RiskManagement].[RuleOddType].MinCombiInternet,[RiskManagement].[RuleOddType].MinCombiMachine,@MatchId,[RiskManagement].[RuleOddType].IsPopular,[RiskManagement].[RuleOddType].MaxGainTicket
--			from [RiskManagement].[RuleOddType]  with (nolock) INNER JOIN RiskManagement.[Rule] with (nolock) On RiskManagement.[RuleOddType].RuleId=RiskManagement.[Rule].RuleId
--			where [RiskManagement].[RuleOddType].OddTypeId=@OddTypeId and [RiskManagement].[Rule].IsActive=1 and  CategoryId=@CategoryId and TournamentId=-1 and cast([RiskManagement].[Rule].StopDate as DATE)>CAST(GETDATE() as DATE)
--			--Order By [RiskManagement].[RuleOddType].RuleOddTypeId desc
--		end
--			--insert Match.OddSetting(OddId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine)
--			--select top 1 @OddId,[RiskManagement].[RuleOddType].StateId,[RiskManagement].[RuleOddType].LossLimit,[RiskManagement].[RuleOddType].LimitPerTicket,
--			--[RiskManagement].[RuleOddType].StakeLimit,[RiskManagement].[RuleOddType].AvailabilityId,[RiskManagement].[RuleOddType].MinCombiBranch,[RiskManagement].[RuleOddType].MinCombiInternet,[RiskManagement].[RuleOddType].MinCombiMachine
--			--from [RiskManagement].[RuleOddType]   with (nolock) INNER JOIN RiskManagement.[Rule] with (nolock) On RiskManagement.[RuleOddType].RuleId=RiskManagement.[Rule].RuleId
--			--where [RiskManagement].[RuleOddType].OddTypeId=@OddTypeId and [RiskManagement].[Rule].IsActive=1 and  CategoryId=@CategoryId and TournamentId=-1 and cast([RiskManagement].[Rule].StopDate as DATE)>CAST(GETDATE() as DATE)
--			--Order By [RiskManagement].[RuleOddType].RuleOddTypeId desc
--end
--else if exists (select RiskManagement.[Rule].RuleId from --[RiskManagement].[RuleOddType] with (nolock) INNER JOIN 
--RiskManagement.[Rule] with (nolock) -- ON RiskManagement.RuleOddType.RuleId=RiskManagement.[Rule].RuleId 
-- where  [RiskManagement].[Rule].IsActive=1 and cast([RiskManagement].[Rule].StopDate as DATE)>CAST(GETDATE() as DATE) and SportId=@SportId and CategoryId=-1 )
--begin
--	if not exists (select Match.OddTypeSetting.OddTypeSettingId from Match.OddTypeSetting with (nolock) where MatchId=@MatchId and OddTypeId=@OddTypeId)
--		begin
--			insert Match.OddTypeSetting(OddTypeId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,MatchId,IsPopular,MaxGainLimit)
--			select top 1 [RiskManagement].[RuleOddType].OddTypeId,[RiskManagement].[RuleOddType].StateId,[RiskManagement].[RuleOddType].LossLimit,[RiskManagement].[RuleOddType].LimitPerTicket,
--			[RiskManagement].[RuleOddType].StakeLimit,[RiskManagement].[RuleOddType].AvailabilityId,[RiskManagement].[RuleOddType].MinCombiBranch,[RiskManagement].[RuleOddType].MinCombiInternet,[RiskManagement].[RuleOddType].MinCombiMachine,@MatchId,[RiskManagement].[RuleOddType].IsPopular,[RiskManagement].[RuleOddType].MaxGainTicket
--			from [RiskManagement].[RuleOddType]   with (nolock) INNER JOIN RiskManagement.[Rule] with (nolock) On RiskManagement.[RuleOddType].RuleId=RiskManagement.[Rule].RuleId
--			where [RiskManagement].[RuleOddType].OddTypeId=@OddTypeId and [RiskManagement].[Rule].IsActive=1 and  SportId=@SportId and CategoryId=-1 and cast([RiskManagement].[Rule].StopDate as DATE)>CAST(GETDATE() as DATE)
--			--Order By [RiskManagement].[RuleOddType].RuleOddTypeId desc
--		end
--			--insert Match.OddSetting(OddId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine)
--			--select top 1 @OddId,[RiskManagement].[RuleOddType].StateId,[RiskManagement].[RuleOddType].LossLimit,[RiskManagement].[RuleOddType].LimitPerTicket,
--			--[RiskManagement].[RuleOddType].StakeLimit,[RiskManagement].[RuleOddType].AvailabilityId,[RiskManagement].[RuleOddType].MinCombiBranch,[RiskManagement].[RuleOddType].MinCombiInternet,[RiskManagement].[RuleOddType].MinCombiMachine
--			--from [RiskManagement].[RuleOddType]  with (nolock) INNER JOIN RiskManagement.[Rule] with (nolock) On RiskManagement.[RuleOddType].RuleId=RiskManagement.[Rule].RuleId
--			--where [RiskManagement].[RuleOddType].OddTypeId=@OddTypeId and [RiskManagement].[Rule].IsActive=1 and  SportId=@SportId and CategoryId=-1 and cast([RiskManagement].[Rule].StopDate as DATE)>CAST(GETDATE() as DATE)
--			--Order By [RiskManagement].[RuleOddType].RuleOddTypeId desc
--end
--else if exists(select RiskManagement.[Rule].RuleId from --[RiskManagement].[RuleOddType] with (nolock) INNER JOIN 
--RiskManagement.[Rule] with (nolock)-- ON RiskManagement.RuleOddType.RuleId=RiskManagement.[Rule].RuleId 
--where  [RiskManagement].[Rule].IsActive=1 and cast([RiskManagement].[Rule].StopDate as DATE)>CAST(GETDATE() as DATE) and SportId=-1)
--begin
--	if not exists(select  Match.OddTypeSetting.OddTypeSettingId from Match.OddTypeSetting with (nolock) where MatchId=@MatchId and OddTypeId=@OddTypeId)
--		begin
--			insert Match.OddTypeSetting(OddTypeId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,MatchId,IsPopular,MaxGainLimit)
--			select top 1 [RiskManagement].[RuleOddType].OddTypeId,[RiskManagement].[RuleOddType].StateId,[RiskManagement].[RuleOddType].LossLimit,[RiskManagement].[RuleOddType].LimitPerTicket,
--			[RiskManagement].[RuleOddType].StakeLimit,[RiskManagement].[RuleOddType].AvailabilityId,[RiskManagement].[RuleOddType].MinCombiBranch,[RiskManagement].[RuleOddType].MinCombiInternet,[RiskManagement].[RuleOddType].MinCombiMachine,@MatchId,[RiskManagement].[RuleOddType].IsPopular,[RiskManagement].[RuleOddType].MaxGainTicket
--			from [RiskManagement].[RuleOddType]  with (nolock) INNER JOIN RiskManagement.[Rule] with (nolock) On RiskManagement.[RuleOddType].RuleId=RiskManagement.[Rule].RuleId
--			where [RiskManagement].[RuleOddType].OddTypeId=@OddTypeId and [RiskManagement].[Rule].IsActive=1 and  SportId=-1  and cast([RiskManagement].[Rule].StopDate as DATE)>CAST(GETDATE() as DATE)
--			--Order By [RiskManagement].[RuleOddType].RuleOddTypeId desc
--		end
--			--insert Match.OddSetting(OddId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine)
--			--select top 1 @OddId,[RiskManagement].[RuleOddType].StateId,[RiskManagement].[RuleOddType].LossLimit,[RiskManagement].[RuleOddType].LimitPerTicket,
--			--[RiskManagement].[RuleOddType].StakeLimit,[RiskManagement].[RuleOddType].AvailabilityId,[RiskManagement].[RuleOddType].MinCombiBranch,[RiskManagement].[RuleOddType].MinCombiInternet,[RiskManagement].[RuleOddType].MinCombiMachine
--			--from [RiskManagement].[RuleOddType] with (nolock) INNER JOIN RiskManagement.[Rule] with (nolock) On RiskManagement.[RuleOddType].RuleId=RiskManagement.[Rule].RuleId
--			--where [RiskManagement].[RuleOddType].OddTypeId=@OddTypeId and [RiskManagement].[Rule].IsActive=1 and  SportId=-1  and cast([RiskManagement].[Rule].StopDate as DATE)>CAST(GETDATE() as DATE)
--			--Order By [RiskManagement].[RuleOddType].RuleOddTypeId desc
--end
--else
--begin
	if not exists(select  Match.OddTypeSetting.OddTypeSettingId from Match.OddTypeSetting with (nolock) where MatchId=@MatchId and OddTypeId=@OddTypeId)
		begin
			insert Match.OddTypeSetting(OddTypeId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,MatchId,IsPopular,MaxGainLimit)
			values(@OddTypeId,2,100000,100000,100000,1,1,1,1,@MatchId,0,10000)
		end
--			--insert Match.OddSetting(OddId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine)
--			--values(@OddId,1,0,0,0,1,3,3,3)
--end



END


GO
