USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[ProcOddsSetting]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [BetAcceptance].[ProcOddsSetting] 
@OddId bigint,
@BetType int,
@CustomerId bigint


AS

declare @Forbidden int=0
declare @OddTypeId int

if(@BetType=1)
	if exists (Select Customer.Customer.CustomerId from Customer.Customer with (nolock) where CustomerId=@CustomerId  )
		begin
			select @OddTypeId= OddsTypeId from Live.EventOdd with (nolock) where OddId=@OddId

			if exists (select [Parameter].[BranchForbiddenOddType].BranchId from  [Parameter].[BranchForbiddenOddType]  with (nolock)  where [ParameterOddTypeId]=@OddTypeId and (BranchId in (select ParentBranchId from Parameter.Branch  with (nolock) 
			 where BranchId= (select BranchId from Customer.Customer  with (nolock)  where CustomerId=@CustomerId)) or BranchId in ((select BranchId from Customer.Customer  with (nolock)  where CustomerId=@CustomerId) )  ) and BetTypeId=@BetType)
				SET @Forbidden=1
		end




--declare @systemCurrencyId int
--declare @CustomerCurrencyId int
--select top 1 @systemCurrencyId=General.Setting.SystemCurrencyId from General.Setting with (nolock)
--select top 1 @CustomerCurrencyId=Customer.Customer.CurrencyId from Customer.Customer with (nolock) where Customer.Customer.CustomerId=@CustomerId

declare @IsOddIncreasement bit=1
declare @IsOddDecreasements bit=1





if(@Forbidden=0)
begin
if (@BetType=0)
begin
	SELECT case when Match.Setting.StateId=2 then Match.Odd.StateId else Match.setting.StateId end  as StateId,
				Match.Setting.LossLimit as LossLimit, 
			Match.Setting.LimitPerTicket as LimitPerTicket,
				 Match.Setting.StakeLimit as StakeLimit, 
				 Match.Setting.AvailabilityId
				 ,Match.Setting.MinCombiBranch as MinCombiBranch,Match.Setting.MinCombiInternet as MinCombiInternet,Match.Setting.MinCombiMachine as MinCombiMachine
				 , Match.Odd.OddValue
				 ,Match.Match.BetradarMatchId as MatchId
					,cast(0 as money)  as CashFlow
					,0 as CategoryId
					 ,cast(ISNULL(@IsOddDecreasements,0) as int) as IsOddDecreasement,cast(ISNULL(@IsOddIncreasement,0) as int) as IsOddIncreasement
	FROM         Match.Odd with (nolock) 
	INNER JOIN  Match.Setting with (nolock) ON Match.Odd.MatchId = Match.Setting.MatchId 
	INNER JOIN  Match.Match with (nolock) ON Match.Match.MatchId=Match.Odd.MatchId
	--INNER JOIN  Match.Fixture with (nolock) ON Match.Match.MatchId=Match.Fixture.MatchId 
	--INNER JOIN  Match.FixtureDateInfo with (nolock) ON Match.FixtureDateInfo.FixtureId=Match.Fixture.FixtureId 
	where Match.Odd.OddId=@OddId 
end
else if (@BetType=1)
begin



	SELECT   case when (Live.EventOdd.OddValue>1 and Live.EventOdd.IsActive=1 )  then Live.EventOdd.StateId else 1 end as StateId, 
	Live.EventSetting.LossLimit as LossLimit, 
	Live.EventSetting.LimitPerTicket as LimitPerTicket, 
					Live.EventSetting.StakeLimit as StakeLimit
					,cast(1 as int) as AvailabilityId,Live.EventSetting.MinCombiBranch as MinCombiBranch,Live.EventSetting.MinCombiInternet as MinCombiInternet,Live.EventSetting.MinCombiMachine as MinCombiMachine
					, Live.EventOdd.OddValue,Live.EventOdd.BetradarMatchId as MatchId
										   ,cast(0 as money)  as CashFlow
										   ,0 as CategoryId
										   ,cast(ISNULL(@IsOddDecreasements,0) as int) as IsOddDecreasement,cast(ISNULL(@IsOddIncreasement,0) as int) as IsOddIncreasement
	FROM         Live.EventOdd with (nolock) 
						  INNER JOIN
						  Live.EventSetting with (nolock) ON Live.EventSetting.MatchId=Live.EventOdd.MatchId 
						  INNER JOIN Live.EventDetail ON Live.EventDetail.EventId=Live.EventOdd.MatchId and Live.EventDetail.BetStatus=2
	where Live.EventOdd.OddId=@OddId and Live.EventSetting.StateId=2 and Live.EventOdd.IsActive=1

end
else if (@BetType=2)
begin

	SELECT    case when Outrights.Event.EventEndDate>DATEADD(MINUTE,-1,GETDATE()) then Outrights.OddTypeSetting.StateId else cast(1 as int) end as StateId, 
	 Outrights.OddTypeSetting.LossLimit as LossLimit, 
	 Outrights.OddTypeSetting.LimitPerTicket as LimitPerTicket, 
					Outrights.OddTypeSetting.StakeLimit as StakeLimit, 
					Outrights.OddTypeSetting.AvailabilityId, 
						  Outrights.OddTypeSetting.MinCombiBranch, Outrights.OddTypeSetting.MinCombiInternet,
						   Outrights.OddTypeSetting.MinCombiMachine, Outrights.Odd.OddValue,Outrights.Odd.MatchId,
					  					   cast(0 as money)   as CashFlow, Parameter.TournamentOutrights.CategoryId as CategoryId
										   ,cast(ISNULL(@IsOddDecreasements,0) as int) as IsOddDecreasement,cast(ISNULL(@IsOddIncreasement,0) as int) as IsOddIncreasement
	FROM         Outrights.Odd with (nolock) INNER JOIN
                      Outrights.OddTypeSetting with (nolock) ON Outrights.Odd.OddsTypeId = Outrights.OddTypeSetting.OddTypeId INNER JOIN
                            Outrights.Event with (nolock) ON Outrights.Odd.MatchId = Outrights.Event.EventId and Outrights.OddTypeSetting.MatchId=Outrights.Event.EventId  INNER JOIN
                      Parameter.TournamentOutrights with (nolock) ON Outrights.Event.TournamentId = Parameter.TournamentOutrights.TournamentId
	where Outrights.Odd.OddId=@OddId --and Outrights.Event.EventEndDate>DATEADD(MINUTE,-1,GETDATE())
end
else if (@BetType=3)
begin

		SELECT     Virtual.EventOddSetting.StateId, 
	Virtual.EventOddSetting.LossLimit as LossLimit, 
Virtual.EventOddSetting.LimitPerTicket as LimitPerTicket, 
 Virtual.EventOddSetting.StakeLimit as StakeLimit, 
					Virtual.EventOddSetting.AvailabilityId, 
						  Virtual.EventOddSetting.MinCombiBranch, Virtual.EventOddSetting.MinCombiInternet,
						   Virtual.EventOddSetting.MinCombiMachine, Virtual.EventOdd.OddValue,Virtual.EventOdd.MatchId,
					  					  cast(0 as money) as CashFlow,0 as CategoryId
										   ,cast(ISNULL(@IsOddDecreasements,0) as int) as IsOddDecreasement,cast(ISNULL(@IsOddIncreasement,0) as int) as IsOddIncreasement
	FROM         Virtual.EventOdd with (nolock) INNER JOIN
						  Virtual.EventOddSetting with (nolock) ON Virtual.EventOdd.OddId = Virtual.EventOddSetting.OddId
	where Virtual.EventOdd.OddId=@OddId

end
end
else
	begin
		SELECT  cast('-100' as int) as StateId,
				cast(0 as money) as LossLimit, 
			cast(0 as money) as LimitPerTicket,
				 cast(0 as money) as StakeLimit, 
				 cast (0 as int) as AvailabilityId
				 ,cast (0 as int) as MinCombiBranch,cast (0 as int) as MinCombiInternet,cast (0 as int) as MinCombiMachine
				 , cast (0 as float) as OddValue
				 ,cast (0 as bigint) as  MatchId
					,cast(0 as money)  as CashFlow
					,0 as CategoryId
					 ,cast(ISNULL(@IsOddDecreasements,0) as int) as IsOddDecreasement,cast(ISNULL(@IsOddIncreasement,0) as int) as IsOddIncreasement
 
	end

GO
