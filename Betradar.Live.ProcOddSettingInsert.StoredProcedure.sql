USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcOddSettingInsert]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Betradar].[Live.ProcOddSettingInsert]
@OddTypeId bigint,
@OddId bigint,
@MatchId int,
@BetradarMatchId bigint
AS


BEGIN

--declare @SportId int
--declare @CategoryId int
--declare @TournamentId int

--SELECT    @SportId= Parameter.Category.SportId,@CategoryId= Parameter.Category.CategoryId,@TournamentId=Parameter.Tournament.TournamentId
--FROM         Parameter.Category with (nolock) INNER JOIN
--                    Parameter.Tournament with (nolock) ON Parameter.Category.CategoryId = Parameter.Tournament.CategoryId INNER JOIN
--                    Live.[Event] with (nolock) ON Parameter.Tournament.TournamentId =  Live.[Event].TournamentId
--where Live.Event.BetradarMatchId=@BetradarMatchId


----Eğer Turnuva için bir kural varsa o kurallar ekleniyor.
--if exists (select [Live].[RiskManagement.Rule].RuleId from --[Live].[RiskManagement.RuleOddType] with (nolock) INNER JOIN 
--Live.[RiskManagement.Rule] with (nolock)-- ON [Live].[RiskManagement.RuleOddType].RuleId=Live.[RiskManagement.Rule].RuleId  where [Live].[RiskManagement.RuleOddType].OddTypeId=@OddTypeId 
-- where [Live].[RiskManagement.Rule].IsActive=1 and cast([Live].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) and  TournamentId=@TournamentId and CompetitorId=-1 )
--begin
--	if not exists (select [Live].[EventOddTypeSetting].OddTypeSettingId from [Live].[EventOddTypeSetting] with (nolock) where MatchId=@MatchId and OddTypeId=@OddTypeId)
--		begin
--			insert [Live].[EventOddTypeSetting](OddTypeId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,MatchId,IsPopular,MaxGainLimit,BetradarMatchId)
--			select top 1 @OddTypeId,[Live].[RiskManagement.RuleOddType].StateId,[Live].[RiskManagement.RuleOddType].LossLimit,[Live].[RiskManagement.RuleOddType].LimitPerTicket,
--			[Live].[RiskManagement.RuleOddType].StakeLimit,[Live].[RiskManagement.RuleOddType].AvailabilityId,[Live].[RiskManagement.RuleOddType].MinCombiBranch,[Live].[RiskManagement.RuleOddType].MinCombiInternet,[Live].[RiskManagement.RuleOddType].MinCombiMachine,@MatchId,[Live].[RiskManagement.RuleOddType].IsPopular,[Live].[RiskManagement.RuleOddType].MaxGainTicket,@BetradarMatchId
--			from [Live].[RiskManagement.RuleOddType] with (nolock) INNER JOIN [Live].[RiskManagement.Rule] with (nolock) ON [Live].[RiskManagement.RuleOddType].RuleId=[Live].[RiskManagement.Rule].RuleId
--			where /*[Live].[RiskManagement.RuleOddType].OddTypeId=@OddTypeId and */ [Live].[RiskManagement.Rule].IsActive=1
--			and  TournamentId=@TournamentId and CompetitorId=-1 and cast([Live].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) 
			 
--		end
--			--insert [Live].[EventOddSetting](OddId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine)
--			--select top 1 @OddId,[Live].[RiskManagement.RuleOddType].StateId,[Live].[RiskManagement.RuleOddType].LossLimit,[Live].[RiskManagement.RuleOddType].LimitPerTicket,
--			--[Live].[RiskManagement.RuleOddType].StakeLimit,[Live].[RiskManagement.RuleOddType].AvailabilityId,[Live].[RiskManagement.RuleOddType].MinCombiBranch,[Live].[RiskManagement.RuleOddType].MinCombiInternet,[Live].[RiskManagement.RuleOddType].MinCombiMachine
--			--from [Live].[RiskManagement.RuleOddType] with (nolock)  INNER JOIN [Live].[RiskManagement.Rule] with (nolock) ON [Live].[RiskManagement.RuleOddType].RuleId=[Live].[RiskManagement.Rule].RuleId
--			--where [Live].[RiskManagement.RuleOddType].OddTypeId=@OddTypeId and [Live].[RiskManagement.Rule].IsActive=1 and  TournamentId=@TournamentId and CompetitorId=-1 and cast([Live].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) 
--			--Order By [Live].[RiskManagement.RuleOddType].RuleOddTypeId desc
--end
--else if exists (select  [Live].[RiskManagement.Rule].RuleId 
--from Live.[RiskManagement.Rule] with (nolock) 
--where  [Live].[RiskManagement.Rule].IsActive=1 and cast([Live].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) 
--and CategoryId=@CategoryId and TournamentId=-1 )
--begin
--	if not exists (select [Live].[EventOddTypeSetting].OddTypeSettingId  from [Live].[EventOddTypeSetting] with (nolock) where MatchId=@MatchId and OddTypeId=@OddTypeId)
--		begin
--			insert [Live].[EventOddTypeSetting](OddTypeId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,MatchId,IsPopular,MaxGainLimit,BetradarMatchId)
--			select top 1 @OddTypeId,[Live].[RiskManagement.RuleOddType].StateId,[Live].[RiskManagement.RuleOddType].LossLimit
--			,[Live].[RiskManagement.RuleOddType].LimitPerTicket,
--			[Live].[RiskManagement.RuleOddType].StakeLimit,[Live].[RiskManagement.RuleOddType].AvailabilityId
--			,[Live].[RiskManagement.RuleOddType].MinCombiBranch
--			,[Live].[RiskManagement.RuleOddType].MinCombiInternet,[Live].[RiskManagement.RuleOddType].MinCombiMachine,@MatchId
--			,[Live].[RiskManagement.RuleOddType].IsPopular,[Live].[RiskManagement.RuleOddType].MaxGainTicket,@BetradarMatchId
--			from [Live].[RiskManagement.RuleOddType] with (nolock) INNER JOIN [Live].[RiskManagement.Rule] with (nolock) ON 
--			[Live].[RiskManagement.RuleOddType].RuleId=[Live].[RiskManagement.Rule].RuleId
--			where  [Live].[RiskManagement.Rule].IsActive=1 and  CategoryId=@CategoryId and TournamentId=-1 and cast([Live].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) 
			
--		end
			
--end
--else if exists (select [Live].[RiskManagement.Rule].RuleId 
--from Live.[RiskManagement.Rule] with (nolock)
--where   [Live].[RiskManagement.Rule].IsActive=1 and cast([Live].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) and SportId=@SportId and CategoryId=-1 )
--begin
--	if not exists (select [Live].[EventOddTypeSetting].OddTypeSettingId from [Live].[EventOddTypeSetting] with (nolock) where MatchId=@MatchId and OddTypeId=@OddTypeId)
--		begin
--			insert [Live].[EventOddTypeSetting](OddTypeId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,MatchId,IsPopular,MaxGainLimit,BetradarMatchId)
--			select top 1 @OddTypeId,[Live].[RiskManagement.RuleOddType].StateId,[Live].[RiskManagement.RuleOddType].LossLimit
--			,[Live].[RiskManagement.RuleOddType].LimitPerTicket,
--			[Live].[RiskManagement.RuleOddType].StakeLimit,[Live].[RiskManagement.RuleOddType].AvailabilityId
--			,[Live].[RiskManagement.RuleOddType].MinCombiBranch,
--			[Live].[RiskManagement.RuleOddType].MinCombiInternet,[Live].[RiskManagement.RuleOddType].MinCombiMachine,@MatchId
--			,[Live].[RiskManagement.RuleOddType].IsPopular,[Live].[RiskManagement.RuleOddType].MaxGainTicket,@BetradarMatchId
--			from [Live].[RiskManagement.RuleOddType] with (nolock) INNER JOIN [Live].[RiskManagement.Rule] with (nolock) ON 
--			[Live].[RiskManagement.RuleOddType].RuleId=[Live].[RiskManagement.Rule].RuleId
--			where  [Live].[RiskManagement.Rule].IsActive=1 and  SportId=@SportId and CategoryId=-1 
--			and cast([Live].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) 
			
--		end
		
--end
--else if exists (select  [Live].[RiskManagement.Rule].RuleId 
--from Live.[RiskManagement.Rule] with (nolock) 
--where  [Live].[RiskManagement.Rule].IsActive=1 and cast([Live].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) and SportId=-1 )
--begin
--	if not exists (select [Live].[EventOddTypeSetting].OddTypeSettingId from [Live].[EventOddTypeSetting] with (nolock) where MatchId=@MatchId and OddTypeId=@OddTypeId)
--		begin
--			insert [Live].[EventOddTypeSetting](OddTypeId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,MatchId,IsPopular,MaxGainLimit,BetradarMatchId)
--			select top 1 @OddTypeId,[Live].[RiskManagement.RuleOddType].StateId,[Live].[RiskManagement.RuleOddType].LossLimit
--			,[Live].[RiskManagement.RuleOddType].LimitPerTicket,
--			[Live].[RiskManagement.RuleOddType].StakeLimit,[Live].[RiskManagement.RuleOddType].AvailabilityId,
--			[Live].[RiskManagement.RuleOddType].MinCombiBranch,[Live].[RiskManagement.RuleOddType].MinCombiInternet
--			,[Live].[RiskManagement.RuleOddType].MinCombiMachine,@MatchId
--			,[Live].[RiskManagement.RuleOddType].IsPopular,[Live].[RiskManagement.RuleOddType].MaxGainTicket,@BetradarMatchId
--			from [Live].[RiskManagement.RuleOddType] with (nolock) INNER JOIN [Live].[RiskManagement.Rule] with (nolock) 
--			ON [Live].[RiskManagement.RuleOddType].RuleId=[Live].[RiskManagement.Rule].RuleId
--			where  [Live].[RiskManagement.Rule].IsActive=1 and  SportId=-1  and cast([Live].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) 
	
--		end
--			--insert [Live].[EventOddSetting](OddId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine)
--			--select top 1 @OddId,[Live].[RiskManagement.RuleOddType].StateId,[Live].[RiskManagement.RuleOddType].LossLimit,[Live].[RiskManagement.RuleOddType].LimitPerTicket,
--			--[Live].[RiskManagement.RuleOddType].StakeLimit,[Live].[RiskManagement.RuleOddType].AvailabilityId,[Live].[RiskManagement.RuleOddType].MinCombiBranch,[Live].[RiskManagement.RuleOddType].MinCombiInternet,[Live].[RiskManagement.RuleOddType].MinCombiMachine
--			--from [Live].[RiskManagement.RuleOddType] with (nolock) INNER JOIN [Live].[RiskManagement.Rule] with (nolock) ON [Live].[RiskManagement.RuleOddType].RuleId=[Live].[RiskManagement.Rule].RuleId
--			--where [Live].[RiskManagement.RuleOddType].OddTypeId=@OddTypeId and  [Live].[RiskManagement.Rule].IsActive=1 and  SportId=-1  and cast([Live].[RiskManagement.Rule].StopDate as DATE)>CAST(GETDATE() as DATE) 
--			--Order By [Live].[RiskManagement.RuleOddType].RuleOddTypeId desc
--end
--else
--begin
	if not exists (select [Live].[EventOddTypeSetting].OddTypeSettingId from [Live].[EventOddTypeSetting] with (nolock) where MatchId=@MatchId and OddTypeId=@OddTypeId)
		begin
			insert [Live].[EventOddTypeSetting](OddTypeId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,MatchId,IsPopular,MaxGainLimit,BetradarMatchId)
			values(@OddTypeId,2,30000000,30000000,300000000,1,1,1,1,@MatchId,0,300000000,@BetradarMatchId)
		end
			--insert [Live].[EventOddSetting](OddId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine)
			--values(@OddId,1,30000000,30000000,300000000,1,1,1,1)
--end



END


GO
