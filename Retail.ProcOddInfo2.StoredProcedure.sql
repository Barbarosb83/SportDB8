USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcOddInfo2]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [Retail].[ProcOddInfo2] 

 @MatchCode nvarchar(10),  --67ACDF  256ABD
 @3way nvarchar(10),
 @FirtHalf nvarchar(10),
 @DoubleChance nvarchar(10),
 @FirstHalf3Way nvarchar(10),
 @Handicap nvarchar(10),
 @NextGoal nvarchar(10),
 @OverUnder nvarchar(10),
 @YesNo nvarchar(10),
 @Rest3way nvarchar(10),
 @RestFirstHalf3way nvarchar(10),
 @Special nvarchar(10),
 @LangId int

 AS
  

BEGIN
SET NOCOUNT ON;







INSERT INTO [dbo].[testslip]
           ([MatchCode]
           ,[3way]
           ,[FirtHalf]
           ,[DoubleChance]
           ,[FirstHalf3Way]
           ,[Handicap]
           ,[NextGoal]
           ,[OverUnder]
           ,[YesNo]
           ,[Rest3way]
           ,[RestFirstHalf3way]
           ,[Special],CreateDate)
     VALUES(@MatchCode,@3way,@FirtHalf,@DoubleChance,@FirstHalf3Way,@Handicap,@NextGoal,@OverUnder,@YesNo,@Rest3way,@RestFirstHalf3way,@Special,GETDATE())



	  
DECLARE @tblOdd TABLE(Tip nvarchar(20),DoubleChance nvarchar(20),FirstHalf3Way nvarchar(20),Handicap nvarchar(20),NextGoal nvarchar(20),Rest3way nvarchar(20),YesNo nvarchar(20),OverUnder nvarchar(20),Special nvarchar(20))
DECLARE @ak nvarchar(10)
DECLARE @StartPos int, @Length int
WHILE LEN(@3way) > 0
  BEGIN
   -- SET @StartPos = CHARINDEX(@Delimeter, @OddId)
     SET @StartPos = 1
    SET @Length = LEN(@3way) 
    IF @Length < 0 SET @Length = 0
    IF @StartPos > 0
      BEGIN
        SET @ak = SUBSTRING(@3way,1, @StartPos)
        SET @3way = SUBSTRING(@3way, @StartPos+1, LEN(@3way) - @StartPos)
      END
    ELSE
      BEGIN
        SET @ak = @3way
		--select @ak as aaaa
        SET @3way = ''
 
      END
    INSERT @tblOdd (Tip) VALUES(@ak)
	end

	WHILE LEN(@DoubleChance) > 0
  BEGIN
   -- SET @StartPos = CHARINDEX(@Delimeter, @OddId)
     SET @StartPos = 2
    SET @Length = LEN(@DoubleChance) 
    IF @Length < 0 SET @Length = 0
    IF @StartPos > 0
      BEGIN
        SET @ak = SUBSTRING(@DoubleChance,1, @StartPos)
        SET @DoubleChance = SUBSTRING(@DoubleChance, @StartPos+1, LEN(@DoubleChance) - @StartPos)
      END
    ELSE
      BEGIN
        SET @ak = @DoubleChance
		--select @ak as aaaa
        SET @DoubleChance = ''
 
      END
    INSERT @tblOdd (DoubleChance) VALUES(@ak)
	end
	 

	--WHILE LEN(@FirstHalf3Way) > 0
 -- BEGIN
 --  -- SET @StartPos = CHARINDEX(@Delimeter, @OddId)
 --    SET @StartPos = 1
 --   SET @Length = LEN(@FirstHalf3Way) 
 --   IF @Length < 0 SET @Length = 0
 --   IF @StartPos > 0
 --     BEGIN
 --       SET @ak = SUBSTRING(@FirstHalf3Way,1, @StartPos)
 --       SET @FirstHalf3Way = SUBSTRING(@FirstHalf3Way, @StartPos+1, LEN(@FirstHalf3Way) - @StartPos)
 --     END
 --   ELSE
 --     BEGIN
 --       SET @ak = @FirstHalf3Way
	--	--select @ak as aaaa
 --       SET @FirstHalf3Way = ''
 
 --     END
 --   INSERT @tblOdd (FirstHalf3Way) VALUES(@ak)
	--end

		WHILE LEN(@Handicap) > 0
  BEGIN
   -- SET @StartPos = CHARINDEX(@Delimeter, @OddId)
     SET @StartPos = 1
    SET @Length = LEN(@Handicap) 
    IF @Length < 0 SET @Length = 0
    IF @StartPos > 0
      BEGIN
        SET @ak = SUBSTRING(@Handicap,1, @StartPos)
        SET @Handicap = SUBSTRING(@Handicap, @StartPos+1, LEN(@Handicap) - @StartPos)
      END
    ELSE
      BEGIN
        SET @ak = @Handicap
		--select @ak as aaaa
        SET @Handicap = ''
 
      END
    INSERT @tblOdd (Handicap) VALUES(@ak)
	end

		WHILE LEN(@NextGoal) > 0
  BEGIN
   -- SET @StartPos = CHARINDEX(@Delimeter, @OddId)
     SET @StartPos = 1
    SET @Length = LEN(@NextGoal) 
    IF @Length < 0 SET @Length = 0
    IF @StartPos > 0
      BEGIN
        SET @ak = SUBSTRING(@NextGoal,1, @StartPos)
        SET @NextGoal = SUBSTRING(@NextGoal, @StartPos+1, LEN(@NextGoal) - @StartPos)
      END
    ELSE
      BEGIN
        SET @ak = @NextGoal
	--	select @ak as aaaa
        SET @NextGoal = ''
 
      END
    INSERT @tblOdd (NextGoal) VALUES(@ak)
	end

		WHILE LEN(@OverUnder) > 0
  BEGIN
   -- SET @StartPos = CHARINDEX(@Delimeter, @OddId)
     SET @StartPos = 5
    SET @Length = LEN(@OverUnder) 
    IF @Length < 0 SET @Length = 0
    IF @StartPos > 0
      BEGIN
        SET @ak = SUBSTRING(@OverUnder,1, @StartPos)
        SET @OverUnder = SUBSTRING(@OverUnder, @StartPos+1, LEN(@OverUnder) - @StartPos)
      END
    ELSE
      BEGIN
        SET @ak = @OverUnder
		---select @ak as aaaa
        SET @OverUnder = ''
 
      END
    INSERT @tblOdd (OverUnder) VALUES(@ak)
	end

		WHILE LEN(@YesNo) > 0
  BEGIN
   -- SET @StartPos = CHARINDEX(@Delimeter, @OddId)
     SET @StartPos = 1
    SET @Length = LEN(@YesNo) 
    IF @Length < 0 SET @Length = 0
    IF @StartPos > 0
      BEGIN
        SET @ak = SUBSTRING(@YesNo,1, @StartPos)
        SET @YesNo = SUBSTRING(@YesNo, @StartPos+1, LEN(@YesNo) - @StartPos)
      END
    ELSE
      BEGIN
        SET @ak = @YesNo
		--select @ak as aaaa
        SET @YesNo = ''
 
      END
    INSERT @tblOdd (YesNo) VALUES(@ak)
	end

	WHILE LEN(@Rest3way) > 0
  BEGIN
   -- SET @StartPos = CHARINDEX(@Delimeter, @OddId)
     SET @StartPos = 1
    SET @Length = LEN(@Rest3way) 
    IF @Length < 0 SET @Length = 0
    IF @StartPos > 0
      BEGIN
        SET @ak = SUBSTRING(@Rest3way,1, @StartPos)
        SET @Rest3way = SUBSTRING(@Rest3way, @StartPos+1, LEN(@Rest3way) - @StartPos)
      END
    ELSE
      BEGIN
        SET @ak = @Rest3way
		--select @ak as aaaa
        SET @Rest3way = ''
 
      END
    INSERT @tblOdd (Rest3way) VALUES(@ak)
	end

	  	if (LEN(@Special)>0)
			insert @tblOdd (Special) Values (@Special)

declare @BetType int
declare @OddId bigint
declare @Outcome nvarchar(50)
declare @SpecialBetValue nvarchar(50)
declare @MatchId bigint=0
declare @SportId int=0
declare @BetradarOddTypeId int=0
declare @BetradarSubTyepId int=0
select top 1 @MatchId=Match.Code.MatchId,@BetType=Match.Code.BetTypeId from Match.Code where Code=@MatchCode order by BetTypeId
  declare @Tipp nvarchar(10)

 declare @temptable table (
 MatchId bigint,
 EventName nvarchar(250),
 OddId1 bigint,
 OddValue1 float,
 OutCome nvarchar(150),
 SpecialBetValue nvarchar(150),
 OddsTypeId int,
 OddsType nvarchar(100),
 Banko bit,
 [Enable] bit,
 BetType int )
 declare @T3Way nvarchar(20)
 declare @TDoubleChance nvarchar(20)
 declare @TFirstHalf3Way nvarchar(20)
 declare @THandicap nvarchar(20)
 declare @TNextGoal nvarchar(20)
 declare @TRest3way nvarchar(20)
  declare @TYesNo nvarchar(20)
   declare @TOverUnder nvarchar(20)

 set nocount on
					declare cur111 cursor local for(
					select ISNULL(Tip,''),ISNULL(DoubleChance,'') ,ISNULL(FirstHalf3Way,'') ,ISNULL(Handicap,'') ,ISNULL(NextGoal,'') ,ISNULL(Rest3way,''),ISNULL(YesNo,'') ,ISNULL(OverUnder,'') from @tblOdd

						)

					open cur111
					fetch next from cur111 into @T3Way,@TDoubleChance,@TFirstHalf3Way,@THandicap,@TNextGoal,@TRest3way,@TYesNo,@TOverUnder
					while @@fetch_status=0
						begin
							begin
	
	--select  @T3Way,@TDoubleChance,@TFirstHalf3Way,@THandicap,@TNextGoal,@TRest3way,@TYesNo,@TOverUnder

	select top 1 @BetradarOddTypeId=BetradarOddTypeId,@BetradarSubTyepId=BetradarSubTyepId,@Outcome=OutCome,@SpecialBetValue=SpecialBetValue from Parameter.OddsTypeCode2 with (nolock)  where
	   [RestFirstHalf3way]=@RestFirstHalf3way and FirstHalf=@FirtHalf  and BetType=@BetType and (Tip=@T3Way and DoubleChance=@TDoubleChance  
	   and Handicap=@THandicap and NextGoal=@TNextGoal and OverUnder=@TOverUnder and FirstHalfTip=@FirstHalf3Way and YesNo=@TYesNo and  [Rest3way]=@TRest3way) and  Special=@Special
	 
	-- select @BetradarOddTypeId,@BetradarSubTyepId,@Outcome,@SpecialBetValue
if(@MatchId>0)
	begin
		
		--if(@3way<>'' )
		--	begin
		--		--if(@Special='') -- 3way Oynanmış
		--		--	begin
		--			if(@BetType=0)
		--				begin
							 
		--							select @OddId=Match.Odd.OddId from 
		--								Match.Odd with (nolock) where MatchId=@MatchId and BetradarOddTypeId=@BetradarOddTypeId and OutCome=@Outcome 
		--								and SpecialBetValue=@SpecialBetValue
							 

		--				end
		--			else if (@BetType=1)
		--				begin
		--					-- select @BetradarOddTypeId,@BetradarSubTyepId,@Outcome,@MatchId,@SpecialBetValue
		--							select @OddId=Live.EventOdd.OddId 
		--								from Live.EventOdd with (nolock)
		--								where Live.EventOdd.MatchId=@MatchId 
		--								and Live.EventOdd.BetradarOddsTypeId=@BetradarOddTypeId and Live.EventOdd.BetradarOddsSubTypeId=@BetradarSubTyepId --   in (select OddTypeId from Parameter.OddsTypeCode where
		--								--Tip=@3way and DoubleChance=@DoubleChance and FirstHalfTip=@FirstHalf3Way and Handicap=@Handicap and NextGoal=@NextGoal and OverUnder=@OverUnder
		--								--and Special=@Special and BetType=@BetType) 
		--								and Live.EventOdd.Outcome=@Outcome 
		--							--	and  Live.EventOdd.SpecialBetValue=case when @SpecialBetValue<>'' then @SpecialBetValue else Live.EventOdd.SpecialBetValue end

 
		--				end
		--			--end
		--		--else
		--		--	begin
						
								
		--		--				if(@BetType=0)
		--		--					begin

		--		--				select @OddId=Match.Odd.OddId from 
		--		--						Match.Odd with (nolock) where MatchId=@MatchId and BetradarOddTypeId=@BetradarOddTypeId and OutCome=@Outcome 
		--		--						and SpecialBetValue=@SpecialBetValue
												
		--		--				--		set @BetradarOddTypeId=47
		--		--				--		select @OddId=Match.Odd.OddId from 
		--		--				--		Match.Odd where MatchId=@MatchId and BetradarOddTypeId=@BetradarOddTypeId and OutCome=@3way
		--		--					end
		--		--				else
		--		--					begin
		--		--						select @OddId=Live.EventOdd.OddId 
		--		--						from Live.EventOdd with (nolock)
		--		--						where Live.EventOdd.MatchId=@MatchId 
		--		--						and Live.EventOdd.OddsTypeId in (select OddTypeId from Parameter.OddsTypeCode where
		--		--						Tip=@3way and DoubleChance=@DoubleChance and FirstHalfTip=@FirstHalf3Way and Handicap=@Handicap and NextGoal=@NextGoal and OverUnder=@OverUnder
		--		--						and Special=@Special and BetType=@BetType) 
		--		--						and Live.EventOdd.Outcome=@Outcome and  Live.EventOdd.SpecialBetValue=case when @SpecialBetValue<>'' then @SpecialBetValue else Live.EventOdd.SpecialBetValue end

		--		--					end
			
		--		--	end
		--	end
		--else
		--	begin
				if(@BetType=0)
									begin
										select @OddId=Match.Odd.OddId from 
										Match.Odd with (nolock) where MatchId=@MatchId 
										and BetradarOddTypeId=@BetradarOddTypeId and OutCome=@Outcome and SpecialBetValue=@SpecialBetValue



										select @SportId=Parameter.Category.SportId from Match.Match with (nolock) INNER JOIN Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Match.TournamentId INNER JOIN
							Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId and Match.MatchId=@MatchId
								if(@SportId=5 and @BetradarOddTypeId=10)
													set @BetradarOddTypeId=382
													else if(@SportId=5 and @BetradarOddTypeId=42)
									begin
													set @BetradarOddTypeId=204
													set @SpecialBetValue=1
									end
									else if(@SportId=5 and @Special=67)
									begin
											set @OverUnder='O 5.5'
									end
								else if(@SportId=5 and @Special=68)
									begin
											set @OverUnder='U 5.5'
									end
										
										if(@OverUnder<>'O 5.5' and @OverUnder<>'U 5.5' )
											select @OddId=Match.Odd.OddId from 
												Match.Odd with (nolock) where MatchId=@MatchId and BetradarOddTypeId=@BetradarOddTypeId and 
												OutCome=@Outcome and SpecialBetValue=@SpecialBetValue
										else
											begin
												if(@SportId=2) --Basketball Over / Under
													begin
														select top 1 @OddId=Match.Odd.OddId from 
															Match.Odd with (nolock) where MatchId=@MatchId 
															and BetradarOddTypeId=@BetradarOddTypeId and OutCome=@Outcome order by SpecialBetValue desc
													end
													else if (@SportId=5) -- Tenis Over / Under
														begin
															set @BetradarOddTypeId=226
															select top 1 @OddId=Match.Odd.OddId from 
															Match.Odd with (nolock) where MatchId=@MatchId and BetradarOddTypeId=@BetradarOddTypeId and OutCome=@Outcome order by SpecialBetValue desc

														end
													else if (@SportId=6) -- HandBall Over / Under
														begin
															
															select top 1 @OddId=Match.Odd.OddId from 
															Match.Odd with (nolock) where MatchId=@MatchId and BetradarOddTypeId=@BetradarOddTypeId and OutCome=@Outcome order by SpecialBetValue desc

														end

											end
										if (@Special='1235' or @Special='1237'  or @Special='1258'  or @Special='1268') 
											if(@SportId=5) -- Tenis Score
												begin
													set @BetradarOddTypeId=233
													select @OddId=Match.Odd.OddId from 
													Match.Odd with (nolock) where MatchId=@MatchId and BetradarOddTypeId=@BetradarOddTypeId and OutCome=@Outcome and SpecialBetValue=@SpecialBetValue
												end
										if(@Tipp='1' or @Tipp='2')
											begin
											if(@SportId=5) 
												begin
													if (@Special='2') -- -- Tenis second set winner
													begin
														set @BetradarOddTypeId=231
														select @OddId=Match.Odd.OddId from 
														Match.Odd with (nolock) where MatchId=@MatchId and BetradarOddTypeId=@BetradarOddTypeId and OutCome=@Outcome 
													end
													else -- Tenis First Set Winner
														begin
														set @BetradarOddTypeId=204
														select @OddId=Match.Odd.OddId from 
														Match.Odd with (nolock) where MatchId=@MatchId and BetradarOddTypeId=@BetradarOddTypeId and OutCome=@Outcome 
														end
												end
												end
										if (@Special='12' or @Special='13') 
											if(@SportId=5) -- Tenis Set Sayısı
												begin
													set @BetradarOddTypeId=206
													if(@Special='12')
														set @Outcome='2 sets'
													else
														set @Outcome='3 sets'
													select @OddId=Match.Odd.OddId from 
													Match.Odd with (nolock) where MatchId=@MatchId and BetradarOddTypeId=@BetradarOddTypeId and OutCome=@Outcome --and SpecialBetValue=@SpecialBetValue
												end


								--		set @BetradarOddTypeId=47
								--		select @OddId=Match.Odd.OddId from 
								--		Match.Odd where MatchId=@MatchId and BetradarOddTypeId=@BetradarOddTypeId and OutCome=@3way
									end
								else if(@BetType=1)
									begin
											select @SportId = Parameter.Category.SportId from Live.Event INNER JOIN Parameter.Tournament On Parameter.Tournament.TournamentId=Live.Event.TournamentId INNER JOIN
									Parameter.Category On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId and Live.Event.EventId=@MatchId
										if (@TRest3way<>'' or @RestFirstHalf3way<>'' or @TNextGoal<>'')
											select @SpecialBetValue=CAST( cast( SUBSTRING(Live.EventDetail.Score,0, CHARINDEX(':', Live.EventDetail.Score)) as int)+cast(SUBSTRING(Live.EventDetail.Score,CHARINDEX(':', Live.EventDetail.Score)+1, LEN(Live.EventDetail.Score)) as int)+1 as nvarchar(50)) from Live.EventDetail with (nolock) where EventId=@MatchId
										if(@SportId<>5)
										begin
										if (LEn( @SpecialBetValue)>0)
											begin
										select @OddId=Live.EventOdd.OddId 
										from Live.EventOdd with (nolock)
										where Live.EventOdd.MatchId=@MatchId 
										--and Live.EventOdd.OddsTypeId in (select OddTypeId from Parameter.OddsTypeCode where
										--Tip=@3way 
										--and DoubleChance=@DoubleChance 
										--and FirstHalfTip=@FirstHalf3Way 
										--and Handicap=@Handicap 
										--and NextGoal=@NextGoal 
										--and OverUnder=@OverUnder
										--and Special=@Special and FirstHalf=@FirtHalf and YesNo=@YesNo and  [Rest3way]=@Rest3way and [RestFirstHalf3way]=@RestFirstHalf3way 
										--and BetType=@BetType) 
										and Live.EventOdd.BetradarOddsTypeId=@BetradarOddTypeId and BetradarOddsSubTypeId=@BetradarSubTyepId
										and Live.EventOdd.Outcome=@Outcome 
										 and  Live.EventOdd.SpecialBetValue=  @SpecialBetValue 
										 end
										else
											begin
												select @OddId=Live.EventOdd.OddId 
										from Live.EventOdd with (nolock)
										where Live.EventOdd.MatchId=@MatchId 
										--and Live.EventOdd.OddsTypeId in (select OddTypeId from Parameter.OddsTypeCode where
										--Tip=@3way 
										--and DoubleChance=@DoubleChance 
										--and FirstHalfTip=@FirstHalf3Way 
										--and Handicap=@Handicap 
										--and NextGoal=@NextGoal 
										--and OverUnder=@OverUnder
										--and Special=@Special and FirstHalf=@FirtHalf and YesNo=@YesNo and  [Rest3way]=@Rest3way and [RestFirstHalf3way]=@RestFirstHalf3way 
										--and BetType=@BetType) 
										and Live.EventOdd.BetradarOddsTypeId=@BetradarOddTypeId and BetradarOddsSubTypeId=@BetradarSubTyepId
										and Live.EventOdd.Outcome=@Outcome 
											end
										end
										else
										begin
											if (@BetradarOddTypeId=2 and @BetradarSubTyepId=0)
												begin
													set @BetradarOddTypeId=7
													set @BetradarSubTyepId=10
												end
													if (LEn( @SpecialBetValue)>0)
											begin
										select @OddId=Live.EventOdd.OddId 
										from Live.EventOdd with (nolock)
										where Live.EventOdd.MatchId=@MatchId 
										--and Live.EventOdd.OddsTypeId in (select OddTypeId from Parameter.OddsTypeCode where
										--Tip=@3way 
										--and DoubleChance=@DoubleChance 
										--and FirstHalfTip=@FirstHalf3Way 
										--and Handicap=@Handicap 
										--and NextGoal=@NextGoal 
										--and OverUnder=@OverUnder
										--and Special=@Special and FirstHalf=@FirtHalf and YesNo=@YesNo and  [Rest3way]=@Rest3way and [RestFirstHalf3way]=@RestFirstHalf3way 
										--and BetType=@BetType) 
										and Live.EventOdd.BetradarOddsTypeId=@BetradarOddTypeId and BetradarOddsSubTypeId=@BetradarSubTyepId
										and Live.EventOdd.Outcome=@Outcome 
										 and  Live.EventOdd.SpecialBetValue=  @SpecialBetValue 
										 end
										else
											begin
												select @OddId=Live.EventOdd.OddId 
										from Live.EventOdd with (nolock)
										where Live.EventOdd.MatchId=@MatchId 
										--and Live.EventOdd.OddsTypeId in (select OddTypeId from Parameter.OddsTypeCode where
										--Tip=@3way 
										--and DoubleChance=@DoubleChance 
										--and FirstHalfTip=@FirstHalf3Way 
										--and Handicap=@Handicap 
										--and NextGoal=@NextGoal 
										--and OverUnder=@OverUnder
										--and Special=@Special and FirstHalf=@FirtHalf and YesNo=@YesNo and  [Rest3way]=@Rest3way and [RestFirstHalf3way]=@RestFirstHalf3way 
										--and BetType=@BetType) 
										and Live.EventOdd.BetradarOddsTypeId=@BetradarOddTypeId and BetradarOddsSubTypeId=@BetradarSubTyepId
										and Live.EventOdd.Outcome=@Outcome 
											end

										end
									--	 select @Outcome

									end
									else if (@BetType=2)
									begin
												select @OddId =Outrights.Odd.OddId from Outrights.Odd with (nolock) where Outrights.Odd.MatchId=@MatchId and SWCode=@Special

									end
			
			--end	

	End








if (@BetType=0)--pre match
begin
if(SELECT count(Match.Match.MatchId)
			FROM         Match.Setting with (nolock)  INNER JOIN
								  Parameter.Competitor with (nolock)  INNER JOIN
								  Match.FixtureCompetitor AS FixtureCompetiTip_1 with (nolock)  ON Parameter.Competitor.CompetitorId = FixtureCompetiTip_1.CompetitorId INNER JOIN
								  Match.Match with (nolock) INNER JOIN
								  Match.Fixture with (nolock) ON Match.Match.MatchId = Match.Fixture.MatchId ON FixtureCompetiTip_1.FixtureId = Match.Fixture.FixtureId INNER JOIN
								  Parameter.Competitor AS CompetiTip_1 with (nolock)  INNER JOIN
								  Match.FixtureCompetitor with (nolock) ON CompetiTip_1.CompetitorId = Match.FixtureCompetitor.CompetitorId ON Match.Fixture.FixtureId = Match.FixtureCompetitor.FixtureId ON 
								  Match.Setting.MatchId = Match.Match.MatchId INNER JOIN
								  Match.Odd with (nolock) ON Match.Match.MatchId = Match.Odd.MatchId INNER JOIN
								  Language.ParameterCompetitor with (nolock) ON Language.ParameterCompetitor.CompetitorId=Parameter.Competitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId INNER JOIN
								  Language.ParameterCompetitor  as LangComp with (nolock) ON LangComp.CompetitorId=CompetiTip_1.CompetitorId and LangComp.LanguageId=@LangId INNER JOIN
								  Parameter.OddsType with (nolock) ON Match.Odd.OddsTypeId = Parameter.OddsType.OddsTypeId INNER JOIN
								  Language.[Parameter.OddsType] with (nolock) ON Language.[Parameter.OddsType].OddsTypeId=Match.Odd.OddsTypeId AND Language.[Parameter.OddsType].LanguageId=@LangId INNER JOIN
								  Language.[Parameter.Odds] with (nolock) ON Language.[Parameter.Odds].OddsId=Match.Odd.ParameterOddId AND Language.[Parameter.Odds].LanguageId=@LangId
			WHERE     (FixtureCompetiTip_1.TypeId = 1) AND (Match.FixtureCompetitor.TypeId = 2) AND Match.Odd.OddId=@OddId)=0
			begin
insert @temptable (MatchId,EventName,OddsTypeId,OddId1,OddValue1,Banko,Enable)
SELECT DISTINCT 
								  TOP (100) PERCENT Match.Match.MatchId, Language.ParameterCompetitor.CompetitorName + '-' + LangComp.CompetitorName AS EventName,0,0,0,0,0
			FROM          
								  Parameter.Competitor with (nolock)  INNER JOIN
								  Match.FixtureCompetitor AS FixtureCompetiTip_1 with (nolock) ON Parameter.Competitor.CompetitorId = FixtureCompetiTip_1.CompetitorId INNER JOIN
								  Match.Match with (nolock)  INNER JOIN
								  Match.Fixture with (nolock) ON Match.Match.MatchId = Match.Fixture.MatchId ON FixtureCompetiTip_1.FixtureId = Match.Fixture.FixtureId INNER JOIN
								  Parameter.Competitor AS CompetiTip_1 with (nolock)  INNER JOIN
								  Match.FixtureCompetitor with (nolock) ON CompetiTip_1.CompetitorId = Match.FixtureCompetitor.CompetitorId ON Match.Fixture.FixtureId = Match.FixtureCompetitor.FixtureId  INNER JOIN
								  Language.ParameterCompetitor with (nolock) ON Language.ParameterCompetitor.CompetitorId=Parameter.Competitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId INNER JOIN
								  Language.ParameterCompetitor as LangComp with (nolock) ON LangComp.CompetitorId=CompetiTip_1.CompetitorId and LangComp.LanguageId=@LangId 
			WHERE     (FixtureCompetiTip_1.TypeId = 1) AND (Match.FixtureCompetitor.TypeId = 2) AND Match.MatchId=@MatchId
			end

			insert @temptable
			SELECT DISTINCT 
								  TOP (100) PERCENT Match.Match.MatchId, Language.ParameterCompetitor.CompetitorName + '-' + LangComp.CompetitorName AS EventName, Match.Odd.OddId AS OddId1, 
								  Match.Odd.OddValue AS OddValue1,
								    case when Match.Odd.OddsTypeId  in (1460,1461,1462,1463,1464,1465,1466,1484,1485,1486,1490,1492,1494,1495,1496,1504,1513,1514,1515,1521,1522,1523,1524,1525,1537,1538,1539,1540,1541,1562,1563,1564,1565,1566,1567,1568,1569,1570,1571,1572,1573,1574,1575,1576,1577,1578,1579,1580,1581,1582,1583,1615,1616,1617,1619,1621,1632,1633,1638,1639,1645,1646,1649,1650,1651,1657,1658,1659,1662,1663,1664,1665,1666,1667,1668,1669,1670,1671,1684,1685,1686,1689,1699,1700,1701,1708,1709,1717,1718,1719,1720,1740,1741,1742,1743,1744,1745,1746,1747,1752,1753,1754,1755,1764,1768,1771,1777,1785,1786,1787,1799,1804,1813,1816,1820,1832,1834,1835,1837,1839,1840,1846,1851,1861,1862,1869,1870,1873,1876,1878,1881,1888,1889,1890,1891,1892,1910,1917,1920,1923,1928,1953,1956,1960,1963,1964,1965,1968,1970,1971,1972,1978,1979,1981,1983,1985,1987,1988,1989,1992,1993,1995,1996,1997,1998) 
			 then case when Match.Odd.OutCome='1' or Match.Odd.OutCome='home' then '[home!]' else case when Match.Odd.OutCome='2' or Match.Odd.OutCome='away' then '[away!]' 
			 else case when   Match.Odd.OutCome='X' or Match.Odd.OutCome='None' or Match.Odd.OutCome='Both teams' then Language.[Parameter.Odds].OutComes else Match.Odd.OutCome end  end end else 
			 case when Language.[Parameter.Odds].OutComes is not null Then Language.[Parameter.Odds].OutComes 
			 else Match.Odd.OutCome end end as OutCome, 
								  case when Match.Odd.ParameterOddId IN (2892,1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Match.Odd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Match.Odd.SpecialBetValue, '') end AS SpecialBetValue,
								   Match.Odd.OddsTypeId, Language.[Parameter.OddsType].OddsType,cast(0 as bit) as Banko,cast(1 as bit) as [Enable],@BetType as BetType
			FROM         Match.Setting with (nolock) INNER JOIN
								  Parameter.Competitor with (nolock) INNER JOIN
								  Match.FixtureCompetitor AS FixtureCompetiTip_1 with (nolock) ON Parameter.Competitor.CompetitorId = FixtureCompetiTip_1.CompetitorId INNER JOIN
								  Match.Match with (nolock) INNER JOIN
								  Match.Fixture with (nolock) ON Match.Match.MatchId = Match.Fixture.MatchId ON FixtureCompetiTip_1.FixtureId = Match.Fixture.FixtureId INNER JOIN
								  Parameter.Competitor AS CompetiTip_1 with (nolock) INNER JOIN
								  Match.FixtureCompetitor with (nolock) ON CompetiTip_1.CompetitorId = Match.FixtureCompetitor.CompetitorId ON Match.Fixture.FixtureId = Match.FixtureCompetitor.FixtureId ON 
								  Match.Setting.MatchId = Match.Match.MatchId INNER JOIN
								  Match.Odd with (nolock) ON Match.Match.MatchId = Match.Odd.MatchId INNER JOIN
								  Language.ParameterCompetitor with (nolock) ON Language.ParameterCompetitor.CompetitorId=Parameter.Competitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId INNER JOIN
								  Language.ParameterCompetitor as LangComp ON LangComp.CompetitorId=CompetiTip_1.CompetitorId and LangComp.LanguageId=@LangId INNER JOIN
								  Parameter.OddsType with (nolock) ON Match.Odd.OddsTypeId = Parameter.OddsType.OddsTypeId INNER JOIN
								  Language.[Parameter.OddsType] with (nolock) ON Language.[Parameter.OddsType].OddsTypeId=Match.Odd.OddsTypeId AND Language.[Parameter.OddsType].LanguageId=@LangId INNER JOIN
								  Language.[Parameter.Odds] with (nolock) ON Language.[Parameter.Odds].OddsId=Match.Odd.ParameterOddId AND Language.[Parameter.Odds].LanguageId=@LangId
			WHERE     (FixtureCompetiTip_1.TypeId = 1) AND (Match.FixtureCompetitor.TypeId = 2) AND Match.Odd.OddId=@OddId


			
end
else if (@BetType=1)--live
	begin
	insert @temptable
			Select Live.EventOdd.MatchId as MatchId, Language.ParameterCompetitor.CompetitorName+'-'+CompetitorAwayLangugage.CompetitorName as EventName,Live.EventOdd.OddId as OddId1,
				Live.EventOdd.OddValue as OddValue1, case when Language.[Parameter.LiveOdds].OutComes like '%player%' then  Live.EventOdd.OutCome else case when Language.[Parameter.LiveOdds].OutComes like '%none%'  then Live.EventOdd.OutCome 
				else case when Live.EventOdd.OutCome='1' or Live.EventOdd.OutCome='home'  then '[home!]' 
  else case when Live.EventOdd.OutCome='2' or Live.EventOdd.OutCome='away'  then '[away!]' else   Language.[Parameter.LiveOdds].OutComes end end end end as OutCome,
				case when Live.EventOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
  then CAST( cast(Live.EventOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
  else case when Live.EventOdd.SpecialBetValue<>'-1' then  ISNULL(Live.EventOdd.SpecialBetValue,'') else '' end end as SpecialBetValue
				, Live.EventOdd.OddsTypeId, Language.[Parameter.LiveOddType].OddsType as OddsType,cast(0 as bit) as Banko,cast(1 as bit) as [Enable],@BetType as BetType
	   
			from Live.EventOdd with (nolock) inner join Live.[Event] with (nolock) on Live.EventOdd.MatchId=Live.[Event].EventId INNER JOIN 
									 Parameter.Competitor with (nolock) on Live.[Event].HomeTeam=Parameter.Competitor.CompetitorId INNER JOIN
									 Language.ParameterCompetitor with (nolock) ON Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND  Language.ParameterCompetitor.LanguageId=@LangId INNER JOIN 
									 Parameter.Competitor as CompetitorAway with (nolock) on Live.[Event].AwayTeam=CompetitorAway.CompetitorId INNER JOIN
									 Language.ParameterCompetitor as CompetitorAwayLangugage with (nolock) ON CompetitorAwayLangugage.CompetitorId = CompetitorAway.CompetitorId AND  CompetitorAwayLangugage.LanguageId=@LangId INNER JOIN
									 Live.[Parameter.OddType] with (nolock) ON Live.EventOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId   INNER JOIN 
									 Language.[Parameter.LiveOddType] with (nolock) ON Language.[Parameter.LiveOddType].OddTypeId=Live.EventOdd.OddsTypeId and  Language.[Parameter.LiveOddType].LanguageId=@LangId INNER JOIN
									 Language.[Parameter.LiveOdds] with (nolock) ON Language.[Parameter.LiveOdds].OddsId=Live.EventOdd.ParameterOddId and Language.[Parameter.LiveOdds].LanguageId=@LangId
			Where Live.EventOdd.OddId=@OddId 
	end
else if (@BetType=2)--outrights
	begin
		insert @temptable 
						SELECT    Outrights.Odd.MatchId,
			[Language].[Parameter.Category].CategoryName +' '+ Outrights.[EventName].EventName as EventName, 
             Outrights.Odd.OddId as OddId1,
             Outrights.Odd.OddValue as OddValue1,
             Language.[ParameterCompetitor].CompetitorName as OutCome, 
             Outrights.Odd.SpecialBetValue,
             Outrights.OddTypeSetting.OddTypeId,
             Language.[Parameter.OddsType].OddsType,
             cast(0 as bit) as Banko,cast(1 as bit) as [Enable],@BetType as BetType
FROM         Outrights.Odd with (nolock)  INNER JOIN
                      Parameter.Odds with (nolock)  ON Outrights.Odd.ParameterOddId = Parameter.Odds.OddsId INNER JOIN
                      Outrights.[Event] with (nolock)  ON Outrights.Odd.MatchId = Outrights.[Event].EventId INNER JOIN 
                      Parameter.OddsType with (nolock)  on  Parameter.OddsType.OddsTypeId=Parameter.Odds.OddTypeId INNER JOIN
                      Language.[Parameter.OddsType] with (nolock)  ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId 
                      INNER JOIN Outrights.OddTypeSetting with (nolock)  ON 
                      Language.[Parameter.OddsType].OddsTypeId = Outrights.OddTypeSetting.OddTypeId and Outrights.OddTypeSetting.MatchId = Outrights.[Event].EventId 
                      inner join Language.[ParameterCompetitor] on Language.[ParameterCompetitor].CompetitorId=Outrights.Odd.CompetitorId and Language.[ParameterCompetitor].LanguageId=@LangId
                      inner join Outrights.[EventName] on Outrights.[Event].EventId = Outrights.[EventName].EventId inner join Parameter.TournamentOutrights on Outrights.[Event].TournamentId=Parameter.TournamentOutrights.TournamentId
		inner join Parameter.[Category] on Parameter.[Category].CategoryId=Parameter.TournamentOutrights.CategoryId 
		inner join Parameter.Sport on Parameter.[Category].SportId=Parameter.Sport.SportId 
		inner join [Language].[Parameter.Category] on [Language].[Parameter.Category].CategoryId=Parameter.[Category].CategoryId 
			and [Language].[Parameter.Category].LanguageId=1
				and Outrights.[EventName].LanguageId=@LangId
WHERE     (Outrights.Odd.OddId=@OddId) AND 
                      (Language.[Parameter.OddsType].LanguageId = @LangId)
	end
else if (@BetType=3)--virtual
	begin
		insert @temptable
			Select Virtual.EventOdd.MatchId as MatchId, Virtual.Team.Team+'-'+CompetitorAway.Team as EventName,Virtual.EventOdd.OddId as OddId1,
				Virtual.EventOdd.OddValue as OddValue1, Virtual.EventOdd.OutCome,Virtual.EventOdd.SpecialBetValue, Virtual.EventOdd.OddsTypeId, Virtual.[Parameter.OddType].OddType as OddsType,cast(0 as bit) as Banko,cast(1 as bit) as [Enable],@BetType as BetType
	   
			from Virtual.EventOdd inner join Virtual.[Event] on Virtual.EventOdd.MatchId=Virtual.[Event].EventId INNER JOIN 
									 Virtual.Team on Virtual.[Event].HomeTeam=Virtual.Team.TeamId INNER JOIN									 
									 Virtual.Team as CompetitorAway on Virtual.[Event].AwayTeam=CompetitorAway.TeamId INNER JOIN									 
									 Virtual.[Parameter.OddType] ON Virtual.EventOdd.OddsTypeId = Virtual.[Parameter.OddType].OddTypeId
			Where Virtual.EventOdd.OddId=@OddId
	end

		end
							fetch next from cur111 into @T3Way,@TDoubleChance,@TFirstHalf3Way,@THandicap,@TNextGoal,@TRest3way,@TYesNo,@TOverUnder
			
						end
					close cur111
					deallocate cur111	


		select distinct *,@MatchCode as MatchCode from @temptable

END


GO
