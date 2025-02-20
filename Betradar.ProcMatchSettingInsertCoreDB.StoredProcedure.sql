USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchSettingInsertCoreDB]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Betradar].[ProcMatchSettingInsertCoreDB]
@MatchId bigint
AS

Declare @SportId bigint=0
Declare @CategoryId bigint=0
BEGIN

 	if not exists(select MatchId from Match.Setting with (nolock) where MatchId=@MatchId)
		begin
 
			INSERT INTO [Match].[Setting]
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
           ,[MaxGainLimit]
           ) 
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
           ,[MaxGainLimit] --,case when [StateId]=1 then 'System' else null end
            from [Tip_CoreDB].[Match].[Setting] where MatchId=@MatchId

		end
	else
		begin
			
		 update OddTypeSetting  
					set OddTypeSetting.LossLimit= inserted.LossLimit
					,OddTypeSetting.StakeLimit= inserted.StakeLimit
					,OddTypeSetting.LimitPerTicket= inserted.LimitPerTicket
					,OddTypeSetting.AvailabilityId= inserted.AvailabilityId
					,OddTypeSetting.MinCombiBranch= inserted.MinCombiBranch
					,OddTypeSetting.MinCombiInternet= inserted.MinCombiInternet
					,OddTypeSetting.MinCombiMachine= inserted.MinCombiMachine
					,OddTypeSetting.IsPopular= inserted.IsPopular
					,OddTypeSetting.StateId= inserted.StateId
					--,OddTypeSetting.Username= case when inserted.StateId=1 then 'System' else null end
					FROM  Match.Setting AS OddTypeSetting with (nolock)
						INNER JOIN [Tip_CoreDB].Match.Setting  AS inserted  
						on inserted.MatchId=OddTypeSetting.MatchId and OddTypeSetting.MatchId=@MatchId
		end
 


END


GO
