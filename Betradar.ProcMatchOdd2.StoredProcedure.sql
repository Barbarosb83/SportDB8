USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchOdd2]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[ProcMatchOdd2]
@MatchId bigint,
@BetradarOddTypeId bigint,
@OutCome nvarchar(50),
@OddValue float,
@SpecialBetValue nvarchar(50),
@BettradarOddId bigint,
@SportId int,
@Category int,
@TournamentId int,
@SqlReturn nvarchar(max) output

AS


SET NOCOUNT ON;

declare @OddsTypeId int
declare @oddId int
declare @MatchoddId int
declare @PlayerId int=0
declare @TeamId int=0

declare @startdate datetime=GetDate()

if(@SportId=1 and @BetradarOddTypeId=10)
	begin
		set @BetradarOddTypeId=381
	end

set @SqlReturn=@SqlReturn+' 1 : '+CAST(DATEDIFF(MICROSECOND,@startdate,GETDATE()) AS nvarchar(max))


SELECT  top 1  @OddsTypeId=Parameter.OddsType.OddsTypeId
FROM        Parameter.OddsType   with (nolock) 
where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and  Parameter.OddsType.SportId=@SportId

set @SqlReturn=@SqlReturn+' 2 : '+CAST(DATEDIFF(MICROSECOND,@startdate,GETDATE()) AS nvarchar(max))

SELECT  top 1   @oddId= Parameter.Odds.OddsId
FROM         Parameter.Odds   with (nolock)  INNER JOIN
                      Parameter.OddsType   with (nolock)  ON Parameter.Odds.OddTypeId = Parameter.OddsType.OddsTypeId
where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and  Parameter.OddsType.SportId=@SportId and Parameter.Odds.Outcomes=@OutCome

set @SqlReturn=@SqlReturn+' 3 : '+CAST(DATEDIFF(MICROSECOND,@startdate,GETDATE()) AS nvarchar(max))

if(@oddId is null)
begin
SELECT  top 1   @oddId= Parameter.Odds.OddsId
FROM         Parameter.Odds   with (nolock)  INNER JOIN
                      Parameter.OddsType   with (nolock)  ON Parameter.Odds.OddTypeId = Parameter.OddsType.OddsTypeId
where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and  Parameter.OddsType.SportId=30 and Parameter.Odds.Outcomes=@OutCome
end

set @SqlReturn=@SqlReturn+' 4 : '+CAST(DATEDIFF(MICROSECOND,@startdate,GETDATE()) AS nvarchar(max))

if(@oddId is null)
begin
SELECT  top 1   @oddId= Parameter.Odds.OddsId
FROM         Parameter.Odds   with (nolock)  INNER JOIN
                      Parameter.OddsType   with (nolock)  ON Parameter.Odds.OddTypeId = Parameter.OddsType.OddsTypeId
where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and  Parameter.OddsType.SportId=@SportId --and Parameter.Odds.Outcomes=@OutCome
end

set @SqlReturn=@SqlReturn+' 5 : '+CAST(DATEDIFF(MICROSECOND,@startdate,GETDATE()) AS nvarchar(max))

if(@OddsTypeId is null)
begin
SELECT  top 1  @OddsTypeId=Parameter.OddsType.OddsTypeId
FROM        Parameter.OddsType   with (nolock) 
where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and  Parameter.OddsType.SportId=30
end

set @SqlReturn=@SqlReturn+' 6 : '+CAST(DATEDIFF(MICROSECOND,@startdate,GETDATE()) AS nvarchar(max))

declare @OddIdCount bigint
if(@SpecialBetValue is null)
begin
	If EXISTS (select Match.Odd.OddId from Match.Odd   with (nolock)  where Match.Odd.ParameterOddId=@oddId and Match.Odd.MatchId=@MatchId)
		set @OddIdCount=1
end
else
begin
	If EXISTS (select (Match.Odd.OddId) from Match.Odd   with (nolock)  where Match.Odd.ParameterOddId=@oddId and Match.Odd.MatchId=@MatchId and Match.Odd.SpecialBetValue=@SpecialBetValue)
		set @OddIdCount=1
end

set @SqlReturn=@SqlReturn+' 7 : '+CAST(DATEDIFF(MICROSECOND,@startdate,GETDATE()) AS nvarchar(max))

if(@OddIdCount is null)
begin

	if (@OddsTypeId is not null)
		begin
		
		set @SqlReturn=@SqlReturn+''
		--set @SqlReturn=@SqlReturn+' insert into Match.Odd WITH (TABLOCK) (Match.Odd.OddsTypeId,Match.Odd.OutCome,Match.Odd.SpecialBetValue,Match.Odd.Suggestion,Match.Odd.OddValue,Match.Odd.MatchId,Match.Odd.BettradarOddId,Match.Odd.ParameterOddId,Match.Odd.BetradarOddTypeId,Match.Odd.ParameterSportId) values ('+cast(@OddsTypeId as nvarchar(10))+','+''''+ISNULL(@OutCome,'')+''','+''''+ISNULL(@SpecialBetValue,'')+''','+cast(@OddValue as nvarchar(10))+','+cast(@OddValue as nvarchar(10))+','+cast(@MatchId as nvarchar(30))+','+cast(@BettradarOddId as nvarchar(30))+','+cast(@oddId as nvarchar(30))+','+cast(@BetradarOddTypeId as nvarchar(30))+','+cast(@SportId as nvarchar(30))+'); set @MatchoddId=SCOPE_IDENTITY(); execute Betradar.ProcOddSettingInsert ' +cast(@OddsTypeId as nvarchar(10))+',@MatchoddId,'+cast(@MatchId as nvarchar(10))+','+cast(@SportId as nvarchar(10))+','+cast(@Category as nvarchar(10))+','+cast(@TournamentId as nvarchar(10))+';'
		
		set @SqlReturn=@SqlReturn+' 8 : '+CAST(DATEDIFF(MICROSECOND,@startdate,GETDATE()) AS nvarchar(max))
		
		end
end
else
	begin
		If EXISTS (select Match.Odd.OddId from Match.Odd    with (nolock)  where Match.Odd.ParameterOddId=@oddId and Match.Odd.MatchId=@MatchId and IsOddValueLock=1)
		begin
				set @SqlReturn=@SqlReturn+' update Match.Odd set Match.Odd.Suggestion='+CAST(@OddValue as nvarchar(10))+',OddValue='+CAST(@OddValue as nvarchar(10))+' where Match.Odd.ParameterOddId='+CAST(@oddId as nvarchar(10))+' and Match.Odd.MatchId='+CAST(@MatchId as nvarchar(10))+';'
			end
		else
			begin
				set @SqlReturn=@SqlReturn+' update Match.Odd set Match.Odd.Suggestion='+CAST(@OddValue as nvarchar(10))+' where Match.Odd.ParameterOddId='+CAST(@oddId as nvarchar(10))+' and Match.Odd.MatchId='+CAST(@MatchId as nvarchar(10))+';'
			end
			
			set @SqlReturn=@SqlReturn+' 9 : '+CAST(DATEDIFF(MICROSECOND,@startdate,GETDATE()) AS nvarchar(max))
	end
	
	
	set @SqlReturn=@SqlReturn+' 10 : '+CAST(DATEDIFF(MICROSECOND,@startdate,GETDATE()) AS nvarchar(max))


GO
