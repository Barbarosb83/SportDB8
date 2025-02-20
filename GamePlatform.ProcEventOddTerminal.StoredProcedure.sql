USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcEventOddTerminal]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcEventOddTerminal] @LangId int,
                                                       @OddTypeGroupId int,
                                                       @EventDate datetime,
                                                       @SportId int,
                                                       @CategoryId int,
                                                       @TournamentId int
AS

BEGIN
    SET NOCOUNT ON;
    declare @TempTable table
                       (
                           MatchId bigint
                       )


    --insert dbo.betslip values (@SportId,cast(@OddTypeGroupId as nvarchar(10)),GETDATE())
    --select * from dbo.betslip order by CreateDate desc
    declare @Endatee nvarchar(50)
    if (@OddTypeGroupId <> 2)
        begin
            if (@CategoryId = 0 and @TournamentId = 0)
                begin
                    if (@SportId > 0)
                        begin
                            if exists (SELECT Cache.Fixture.MatchId
                                       FROM Cache.Fixture with (nolock)
                                       Where Cache.Fixture.SportId = @SportId
                                         and ((CAST(Cache.Fixture.MatchDate AS Date) = (CAST(@EventDate AS Date))))
                                         and Cache.Fixture.MatchDate > DATEADD(MINUTE, 2, GETDATE()))
                                begin
                                    SELECT ROW_NUMBER() over (PARTITION BY Match.ODd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
                                           Match.Odd.OddId,
                                           case
                                               when Language.[Parameter.Odds].OutComes is not null
                                                   Then Language.[Parameter.Odds].OutComes
                                               else Match.Odd.OutCome end                                                                                    as OutCome,
                                           Match.Odd.OddValue,
                                           Cache.Fixture.TournamentId,
                                           case
                                               when Parameter.Odds.OddsId IN
                                                    (1578, 1544, 1648, 1646, 1644, 1642, 2247, 2321, 2325, 2465, 2541,
                                                     2543, 3010, 3052, 3079, 3371, 3393)
                                                   then CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                               else case
                                                        when Match.Odd.OddsTypeId in (1497, 1911, 1493, 1851, 1951, 1864, 1968)
                                                            then case
                                                                     when cast(Match.Odd.SpecialBetValue AS float) < 0
                                                                         then '0:' +
                                                                              CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                                     else ISNULL(Match.Odd.SpecialBetValue, '') + ':0' end
                                                        else ISNULL(Match.Odd.SpecialBetValue, '') end end                                                   AS SpecialBetValue,
                                           Language.[Parameter.OddsType].OddsType,
                                           Parameter.OddsType.OutcomesDescription,
                                           Match.Setting.IsPopular,
                                           Match.Odd.OddsTypeId                                                                                              as OddTypeId,
                                           Match.Setting.MatchId,
                                           ISNULL(Parameter.OddsType.SeqNumber, 999)                                                                         as SeqNumber,
                                           Language.[Parameter.OddsType].ShortOddType
                                            ,
                                           Match.Odd.ParameterOddId
                                            ,
                                           ISNULL((Select MIN(PODD.OddTypeGroupId)
                                                   from Parameter.OddTypeGroupOddType PODD with (nolock)
                                                   where PODD.OddTypeId = Match.Odd.OddsTypeId
                                                     and PODD.OddTypeGroupId not in (2, 12)),
                                                  2)                                                                                                         as OddTypeGroupId
                                    FROM Match.Odd with (nolock)
                                             INNER JOIN
                                         Parameter.Odds with (nolock)
                                         ON Parameter.Odds.OddsId = Match.Odd.ParameterOddId
                                             INNER JOIN
                                         Cache.Fixture with (nolock) ON Cache.Fixture.MatchId = Match.Odd.MatchId
                                             INNER JOIN
                                         Parameter.OddsType with (nolock)
                                         ON Parameter.OddsType.OddsTypeId = Match.Odd.OddsTypeId
                                             INNER JOIN
                                         Language.[Parameter.OddsType] with (nolock)
                                         ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId and
                                            Language.[Parameter.OddsType].LanguageId = @LangId
                                             INNER JOIN
                                         Language.[Parameter.Odds] with (nolock)
                                         ON Language.[Parameter.Odds].OddsId = Match.Odd.ParameterOddId AND
                                            Language.[Parameter.Odds].LanguageId = @LangId
                                             INNER JOIN
                                         Parameter.OddTypeGroupOddType with (nolock)
                                         ON Parameter.OddTypeGroupOddType.OddTypeId = Parameter.OddsType.OddsTypeId and
                                            Parameter.OddTypeGroupOddType.OddTypeGroupId = @OddTypeGroupId
                                             INNER JOIN
                                         Match.Setting with (nolock)
                                         ON Match.ODd.OddsTypeId = Parameter.OddTypeGroupOddType.OddTypeId AND
                                            Match.Odd.OddsTypeId = Parameter.OddTypeGroupOddType.OddTypeId and
                                            Match.Setting.MatchId = Match.Odd.MatchId
                                    WHERE Match.Odd.StateId = 2
                                      and Match.Setting.StateId = 2
                                      and Match.Odd.OddValue > 1
                                      AND (Parameter.OddsType.IsActive = 1 or Parameter.OddsType.OddsTypeId = 1834)
                                      and Cache.Fixture.SportId = @SportId
                                      and ((CAST(Cache.Fixture.MatchDate AS Date) = (CAST(@EventDate AS Date))))
                                      and Cache.Fixture.MatchDate > DATEADD(MINUTE, 2, GETDATE())
                                    --Order By RowNumber
                                end
                            else
                                begin
                                    SELECT ROW_NUMBER() over (PARTITION BY Match.Odd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
                                           Match.Odd.OddId,
                                           case
                                               when Language.[Parameter.Odds].OutComes is not null
                                                   Then Language.[Parameter.Odds].OutComes
                                               else Match.Odd.OutCome end                                                                                    as OutCome,
                                           Match.Odd.OddValue,
                                           Cache.Fixture.TournamentId,
                                           case
                                               when Parameter.Odds.OddsId IN
                                                    (1578, 1544, 1648, 1646, 1644, 1642, 2247, 2321, 2325, 2465, 2541,
                                                     2543, 3010, 3052, 3079, 3371, 3393)
                                                   then CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                               else case
                                                        when Match.Odd.OddsTypeId in (1497, 1911, 1493, 1851, 1951, 1864, 1968)
                                                            then case
                                                                     when cast(Match.Odd.SpecialBetValue AS float) < 0
                                                                         then '0:' +
                                                                              CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                                     else ISNULL(Match.Odd.SpecialBetValue, '') + ':0' end
                                                        else ISNULL(Match.Odd.SpecialBetValue, '') end end                                                   AS SpecialBetValue,
                                           Language.[Parameter.OddsType].OddsType,
                                           Parameter.OddsType.OutcomesDescription,
                                           Match.Setting.IsPopular,
                                           Match.Odd.OddsTypeId                                                                                              as OddTypeId,
                                           Match.Setting.MatchId,
                                           ISNULL(Parameter.OddsType.SeqNumber, 999)                                                                         as SeqNumber,
                                           Language.[Parameter.OddsType].ShortOddType
                                            ,
                                           Match.Odd.ParameterOddId
                                            ,
                                           ISNULL((Select MIN(PODD.OddTypeGroupId)
                                                   from Parameter.OddTypeGroupOddType PODD with (nolock)
                                                   where PODD.OddTypeId = Match.Odd.OddsTypeId
                                                     and PODD.OddTypeGroupId not in (2, 12)),
                                                  2)                                                                                                         as OddTypeGroupId
                                    FROM Match.Odd with (nolock)
                                             INNER JOIN
                                         Parameter.Odds with (nolock)
                                         ON Parameter.Odds.OddsId = Match.Odd.ParameterOddId
                                             INNER JOIN
                                         Cache.Fixture with (nolock) ON Cache.Fixture.MatchId = Match.Odd.MatchId
                                             INNER JOIN
                                         Parameter.OddsType with (nolock)
                                         ON Parameter.OddsType.OddsTypeId = Match.Odd.OddsTypeId
                                             INNER JOIN
                                         Language.[Parameter.OddsType] with (nolock)
                                         ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId and
                                            Language.[Parameter.OddsType].LanguageId = @LangId
                                             INNER JOIN
                                         Language.[Parameter.Odds] with (nolock)
                                         ON Language.[Parameter.Odds].OddsId = Match.Odd.ParameterOddId AND
                                            Language.[Parameter.Odds].LanguageId = @LangId
                                             INNER JOIN
                                         Parameter.OddTypeGroupOddType with (nolock)
                                         ON Parameter.OddTypeGroupOddType.OddTypeId = Parameter.OddsType.OddsTypeId and
                                            Parameter.OddTypeGroupOddType.OddTypeGroupId = @OddTypeGroupId
                                             INNER JOIN
                                         Match.Setting with (nolock)
                                         ON Match.Odd.OddsTypeId = Parameter.OddTypeGroupOddType.OddTypeId AND
                                            Match.Odd.OddsTypeId = Parameter.OddTypeGroupOddType.OddTypeId and
                                            Match.Setting.MatchId = Match.Odd.MatchId
                                    WHERE (Match.Odd.StateId = 2)
                                      and Match.Odd.OddValue > 1
                                      AND (Parameter.OddsType.IsActive = 1 or Parameter.OddsType.OddsTypeId = 1834)
                                      and Cache.Fixture.SportId = @SportId
                                      and Cache.Fixture.MatchDate >= DATEADD(MINUTE, 2, GETDATE())
                                      and cast(Cache.Fixture.MatchDate as date) < DATEADD(DAY, 1, GETDATE())

                                end
                        end
                    else
                        if (@SportId = 0)
                            begin
                                SELECT ROW_NUMBER() over (PARTITION BY Match.Odd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
                                       Match.Odd.OddId,
                                       case
                                           when Language.[Parameter.Odds].OutComes is not null
                                               Then Language.[Parameter.Odds].OutComes
                                           else Match.Odd.OutCome end                                                                                    as OutCome,
                                       Match.Odd.OddValue,
                                       Cache.Fixture.TournamentId,
                                       case
                                           when Parameter.Odds.OddsId IN
                                                (1578, 1544, 1648, 1646, 1644, 1642, 2247, 2321, 2325, 2465, 2541, 2543,
                                                 3010, 3052, 3079, 3371, 3393)
                                               then CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                           else case
                                                    when Match.Odd.OddsTypeId in (1497, 1911, 1493, 1851, 1951, 1864, 1968)
                                                        then case
                                                                 when cast(Match.Odd.SpecialBetValue AS float) < 0 then
                                                                     '0:' +
                                                                     CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                                 else ISNULL(Match.Odd.SpecialBetValue, '') + ':0' end
                                                    else ISNULL(Match.Odd.SpecialBetValue, '') end end                                                   AS SpecialBetValue,
                                       Language.[Parameter.OddsType].OddsType,
                                       ''                                                                                                                as OutcomesDescription,
                                       Match.Setting.IsPopular,
                                       Match.Odd.OddsTypeId                                                                                              as OddTypeId,
                                       Match.Setting.MatchId,
                                       ISNULL(Parameter.OddTypeGroupOddType.SeqNumber, 999)                                                              as SeqNumber,
                                       Language.[Parameter.OddsType].ShortOddType
                                        ,
                                       Match.Odd.ParameterOddId
                                        ,
                                       ISNULL((Select MIN(PODD.OddTypeGroupId)
                                               from Parameter.OddTypeGroupOddType PODD with (nolock)
                                               where PODD.OddTypeId = Match.Odd.OddsTypeId
                                                 and PODD.OddTypeGroupId not in (2, 12)),
                                              2)                                                                                                         as OddTypeGroupId
                                FROM Match.Odd with (nolock)
                                         INNER JOIN
                                     Parameter.Odds with (nolock) ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
                                         INNER JOIN
                                     Cache.Fixture with (nolock) ON Match.Odd.MatchId = Cache.Fixture.MatchId
                                         INNER JOIN
                                     Parameter.OddsType with (nolock)
                                     ON Parameter.OddsType.OddsTypeId = Parameter.Odds.OddTypeId
                                         INNER JOIN
                                     Language.[Parameter.OddsType] with (nolock)
                                     ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId
                                         INNER JOIN
                                     Match.Setting with (nolock)
                                     ON Language.[Parameter.OddsType].OddsTypeId = Match.Odd.OddsTypeId AND
                                        Match.Setting.MatchId = Cache.Fixture.MatchId
                                         INNER JOIN
                                     Language.[Parameter.Odds] with (nolock)
                                     ON Parameter.Odds.OddsId = Language.[Parameter.Odds].OddsId AND
                                        Language.[Parameter.OddsType].LanguageId = @LangId and
                                        Language.[Parameter.Odds].LanguageId = @LangId
                                         INNER JOIN
                                     Parameter.OddTypeGroupOddType with (nolock)
                                     ON Parameter.OddTypeGroupOddType.OddTypeId = Parameter.OddsType.OddsTypeId
                                WHERE (Match.Odd.StateId = 2)
                                  and Match.Odd.OddValue > 1
                                  AND (Parameter.OddsType.IsActive = 1 or Parameter.OddsType.OddsTypeId = 1834)
                                  and Cache.Fixture.SportId in (1, 2, 3, 4, 5, 6, 19, 20, 35)
                                  and ((CAST(Cache.Fixture.MatchDate AS Date) = (CAST(@EventDate AS Date))))
                                  and Cache.Fixture.MatchDate > DATEADD(MINUTE, 10, GETDATE())
                                --Order By RowNumber

                            end
                        else
                            if (@SportId = -1)
                                begin
                                    SELECT ROW_NUMBER() over (PARTITION BY Match.Odd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
                                           Match.Odd.OddId,
                                           case
                                               when Language.[Parameter.Odds].OutComes is not null
                                                   Then Language.[Parameter.Odds].OutComes
                                               else Match.Odd.OutCome end                                                                                    as OutCome,
                                           Match.Odd.OddValue,
                                           Cache.Fixture.TournamentId,
                                           case
                                               when Parameter.Odds.OddsId IN
                                                    (1578, 1544, 1648, 1646, 1644, 1642, 2247, 2321, 2325, 2465, 2541,
                                                     2543, 3010, 3052, 3079, 3371, 3393)
                                                   then CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                               else case
                                                        when Match.Odd.OddsTypeId in (1497, 1911, 1493, 1851, 1951, 1864, 1968)
                                                            then case
                                                                     when cast(Match.Odd.SpecialBetValue AS float) < 0
                                                                         then '0:' +
                                                                              CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                                     else ISNULL(Match.Odd.SpecialBetValue, '') + ':0' end
                                                        else ISNULL(Match.Odd.SpecialBetValue, '') end end                                                   AS SpecialBetValue,
                                           Language.[Parameter.OddsType].OddsType,
                                           ''                                                                                                                as OutcomesDescription,
                                           Match.Setting.IsPopular,
                                           Match.Odd.OddsTypeId                                                                                              as OddTypeId,
                                           Match.Setting.MatchId,
                                           ISNULL((Select MIN(PODD.SeqNumber)
                                                   from Parameter.OddTypeGroupOddType PODD with (nolock)
                                                   where PODD.OddTypeId = Match.Odd.OddsTypeId),
                                                  999)                                                                                                       as SeqNumber,
                                           Language.[Parameter.OddsType].ShortOddType
                                            ,
                                           Match.Odd.ParameterOddId
                                            ,
                                           ISNULL((Select MIN(PODD.OddTypeGroupId)
                                                   from Parameter.OddTypeGroupOddType PODD with (nolock)
                                                   where PODD.OddTypeId = Match.Odd.OddsTypeId
                                                     and PODD.OddTypeGroupId not in (2, 12)),
                                                  2)                                                                                                         as OddTypeGroupId
                                    FROM Match.Odd with (nolock)
                                             INNER JOIN
                                         Parameter.Odds with (nolock)
                                         ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
                                             INNER JOIN
                                         Cache.Fixture with (nolock) ON Match.Odd.MatchId = Cache.Fixture.MatchId
                                             INNER JOIN
                                         Parameter.OddsType with (nolock)
                                         ON Parameter.OddsType.OddsTypeId = Parameter.Odds.OddTypeId
                                             INNER JOIN
                                         Language.[Parameter.OddsType] with (nolock)
                                         ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId
                                             INNER JOIN
                                         Match.Setting with (nolock)
                                         ON Language.[Parameter.OddsType].OddsTypeId = Match.Odd.OddsTypeId AND
                                            Match.Setting.MatchId = Cache.Fixture.MatchId
                                             INNER JOIN
                                         Language.[Parameter.Odds] with (nolock)
                                         ON Parameter.Odds.OddsId = Language.[Parameter.Odds].OddsId AND
                                            Language.[Parameter.OddsType].LanguageId = @LangId and
                                            Language.[Parameter.Odds].LanguageId = @LangId
                                             INNER JOIN Parameter.Tournament
                                                        On Parameter.Tournament.TournamentId = Cache.Fixture.TournamentId
                                    WHERE (Match.Odd.StateId = 2)
                                      and Match.Odd.OddValue > 1
                                      AND (Parameter.OddsType.IsActive = 1 or Parameter.OddsType.OddsTypeId = 1834)
                                      and Cache.Fixture.IsPopular = 1
                                      and Cache.Fixture.SportId in (1, 2, 3, 4, 5, 6, 19, 20, 35)
                                      and Cache.Fixture.MatchDate > DATEADD(MINUTE, 10, GETDATE())
                                    --and  cast(Cache.Fixture.MatchDate as date)<  cast(@EventDate as date)
                                    --Order By RowNumber

                                end
                            else
                                if (@SportId = -2)
                                    begin


                                        insert @TempTable
                                        SELECT top 32 Customer.SlipOdd.MatchId
                                        FROM Customer.SlipOdd with (nolock)
                                        WHERE (CAST(Customer.SlipOdd.EventDate AS date) >= CAST(GETDATE() AS date))
                                        group by Customer.SlipOdd.MatchId
                                        ORDER BY COUNT(Customer.SlipOdd.MatchId) desc


                                        if ((select count(MatchId) from @TempTable) < 4)
                                            begin
                                                insert @TempTable
                                                SELECT top 50 Cache.Fixture.MatchId
                                                FROM Cache.Fixture with (nolock)
                                                WHERE Cache.Fixture.IsPopular = 1
                                                  and MatchId not in (select MatchId from @TempTable)
                                            end

                                        SELECT ROW_NUMBER() over (PARTITION BY Match.Odd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
                                               Match.Odd.OddId,
                                               case
                                                   when Language.[Parameter.Odds].OutComes is not null
                                                       Then Language.[Parameter.Odds].OutComes
                                                   else Match.Odd.OutCome end                                                                                    as OutCome,
                                               Match.Odd.OddValue,
                                               Fixture.TournamentId,
                                               case
                                                   when Parameter.Odds.OddsId IN
                                                        (1578, 1544, 1648, 1646, 1644, 1642, 2247, 2321, 2325, 2465,
                                                         2541, 2543, 3010, 3052, 3079, 3371, 3393)
                                                       then CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                   else case
                                                            when Match.Odd.OddsTypeId in (1497, 1911, 1493, 1851, 1951, 1864, 1968)
                                                                then case
                                                                         when cast(Match.Odd.SpecialBetValue AS float) < 0
                                                                             then '0:' +
                                                                                  CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                                         else ISNULL(Match.Odd.SpecialBetValue, '') + ':0' end
                                                            else ISNULL(Match.Odd.SpecialBetValue, '') end end                                                   AS SpecialBetValue,
                                               Language.[Parameter.OddsType].OddsType,
                                               ''                                                                                                                as OutcomesDescription,
                                               Match.Setting.IsPopular,
                                               Match.Odd.OddsTypeId                                                                                              as OddTypeId,
                                               Match.Setting.MatchId,
                                               ISNULL(Parameter.OddTypeGroupOddType.SeqNumber, 999)                                                              as SeqNumber,
                                               Language.[Parameter.OddsType].ShortOddType
                                                ,
                                               Match.Odd.ParameterOddId
                                                ,
                                               ISNULL((Select MIN(PODD.OddTypeGroupId)
                                                       from Parameter.OddTypeGroupOddType PODD with (nolock)
                                                       where PODD.OddTypeId = Match.Odd.OddsTypeId
                                                         and PODD.OddTypeGroupId not in (2, 12)),
                                                      2)                                                                                                         as OddTypeGroupId
                                        FROM Match.Odd with (nolock)
                                                 INNER JOIN
                                             Parameter.Odds with (nolock)
                                             ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
                                                 INNER JOIN
                                             Cache.Programme2 Fixture with (nolock)
                                             ON Match.Odd.MatchId = Fixture.MatchId
                                                 INNER JOIN
                                             Parameter.OddsType with (nolock)
                                             ON Parameter.OddsType.OddsTypeId = Parameter.Odds.OddTypeId
                                                 INNER JOIN
                                             Language.[Parameter.OddsType] with (nolock)
                                             ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId
                                                 INNER JOIN
                                             Match.Setting with (nolock)
                                             ON Language.[Parameter.OddsType].OddsTypeId = Match.Odd.OddsTypeId AND
                                                Match.Setting.MatchId = Fixture.MatchId
                                                 INNER JOIN
                                             @TempTable AS temp ON Fixture.MatchId = temp.MatchId
                                                 INNER JOIN
                                             Language.[Parameter.Odds] with (nolock)
                                             ON Parameter.Odds.OddsId = Language.[Parameter.Odds].OddsId AND
                                                Language.[Parameter.OddsType].LanguageId = @LangId and
                                                Language.[Parameter.Odds].LanguageId = @LangId
                                                 INNER JOIN
                                             Parameter.OddTypeGroupOddType with (nolock)
                                             ON Parameter.OddTypeGroupOddType.OddTypeId = Parameter.OddsType.OddsTypeId
                                        WHERE (Match.Odd.StateId = 2)
                                          and Match.Odd.OddValue > 1
                                          AND (Parameter.OddsType.IsActive = 1 or Parameter.OddsType.OddsTypeId = 1834)
                                          and Fixture.SportId in (1, 2, 3, 4, 5, 6, 19, 20, 35)
                                          and Fixture.MatchDate > DATEADD(MINUTE, 10, GETDATE())
                                        -- and  cast(Fixture.MatchDate as date)<cast(DATEADD(WEEK,3,GETDATE()) as date)
                                        --Order By RowNumber

                                    end
                                else
                                    if (@SportId = -3)
                                        begin


                                            SELECT ROW_NUMBER() over (PARTITION BY Match.Odd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
                                                   Match.Odd.OddId,
                                                   case
                                                       when Language.[Parameter.Odds].OutComes is not null
                                                           Then Language.[Parameter.Odds].OutComes
                                                       else Match.Odd.OutCome end                                                                                    as OutCome,
                                                   Match.Odd.OddValue,
                                                   Fixture.TournamentId,
                                                   case
                                                       when Parameter.Odds.OddsId IN
                                                            (1578, 1544, 1648, 1646, 1644, 1642, 2247, 2321, 2325, 2465,
                                                             2541, 2543, 3010, 3052, 3079, 3371, 3393)
                                                           then CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                       else case
                                                                when Match.Odd.OddsTypeId in (1497, 1911, 1493, 1851, 1951, 1864, 1968)
                                                                    then case
                                                                             when cast(Match.Odd.SpecialBetValue AS float) < 0
                                                                                 then '0:' +
                                                                                      CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                                             else ISNULL(Match.Odd.SpecialBetValue, '') + ':0' end
                                                                else ISNULL(Match.Odd.SpecialBetValue, '') end end                                                   AS SpecialBetValue,
                                                   Language.[Parameter.OddsType].OddsType,
                                                   ''                                                                                                                as OutcomesDescription,
                                                   Match.Setting.IsPopular,
                                                   Match.Odd.OddsTypeId                                                                                              as OddTypeId,
                                                   Match.Setting.MatchId,
                                                   ISNULL(Parameter.OddsType.SeqNumber, 999)                                                                         as SeqNumber,
                                                   Language.[Parameter.OddsType].ShortOddType
                                                    ,
                                                   Match.Odd.ParameterOddId
                                                    ,
                                                   ISNULL((Select MIN(PODD.OddTypeGroupId)
                                                           from Parameter.OddTypeGroupOddType PODD with (nolock)
                                                           where PODD.OddTypeId = Match.Odd.OddsTypeId
                                                             and PODD.OddTypeGroupId not in (2, 12)),
                                                          2)                                                                                                         as OddTypeGroupId
                                            FROM Match.Odd with (nolock)
                                                     INNER JOIN
                                                 Parameter.Odds with (nolock)
                                                 ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
                                                     INNER JOIN
                                                 Cache.Programme2 Fixture with (nolock)
                                                 ON Match.Odd.MatchId = Fixture.MatchId
                                                     INNER JOIN
                                                 Parameter.OddsType with (nolock)
                                                 ON Parameter.OddsType.OddsTypeId = Parameter.Odds.OddTypeId
                                                     INNER JOIN
                                                 Language.[Parameter.OddsType] with (nolock)
                                                 ON Parameter.OddsType.OddsTypeId =
                                                    Language.[Parameter.OddsType].OddsTypeId
                                                     INNER JOIN
                                                 Match.Setting with (nolock)
                                                 ON Language.[Parameter.OddsType].OddsTypeId = Match.Odd.OddsTypeId AND
                                                    Match.Setting.MatchId = Fixture.MatchId
                                                     INNER JOIN
                                                 Language.[Parameter.Odds] with (nolock)
                                                 ON Parameter.Odds.OddsId = Language.[Parameter.Odds].OddsId AND
                                                    Language.[Parameter.OddsType].LanguageId = @LangId and
                                                    Language.[Parameter.Odds].LanguageId = @LangId
                                                     INNER JOIN
                                                 Parameter.OddTypeGroupOddType with (nolock)
                                                 ON Parameter.OddTypeGroupOddType.OddTypeId =
                                                    Parameter.OddsType.OddsTypeId and
                                                    Parameter.OddTypeGroupOddType.OddTypeGroupId = @OddTypeGroupId
                                            WHERE (Match.Odd.StateId = 2)
                                              and Match.Odd.OddValue > 1
                                              AND (Parameter.OddsType.IsActive = 1 or Parameter.OddsType.OddsTypeId = 1834)
                                              and Fixture.SportId in (1, 2, 3, 4, 5, 6, 19, 20, 35)
                                              and Match.Setting.[IsHighlights] = 1
                                              and Fixture.MatchDate > DATEADD(MINUTE, 10, GETDATE())
                                            -- and  cast(Fixture.MatchDate as date)<cast(DATEADD(WEEK,3,GETDATE()) as date)
                                            --Order By RowNumber

                                        end
                                    else
                                        if (@SportId = -4)
                                            begin


                                                set @Endatee =
                                                        cast(Cast(DATEADD(DAY, 1, GETDATE()) as date) as nvarchar(10)) +
                                                        ' 00:00:00.000'


                                                SELECT ROW_NUMBER() over (PARTITION BY Match.Odd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
                                                       Match.Odd.OddId,
                                                       case
                                                           when Language.[Parameter.Odds].OutComes is not null
                                                               Then Language.[Parameter.Odds].OutComes
                                                           else Match.Odd.OutCome end                                                                                    as OutCome,
                                                       Match.Odd.OddValue,
                                                       Fixture.TournamentId,
                                                       case
                                                           when Parameter.Odds.OddsId IN
                                                                (1578, 1544, 1648, 1646, 1644, 1642, 2247, 2321, 2325,
                                                                 2465, 2541, 2543, 3010, 3052, 3079, 3371, 3393)
                                                               then CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                           else case
                                                                    when Match.Odd.OddsTypeId in (1497, 1911, 1493, 1851, 1951, 1864, 1968)
                                                                        then case
                                                                                 when cast(Match.Odd.SpecialBetValue AS float) < 0
                                                                                     then '0:' +
                                                                                          CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                                                 else ISNULL(Match.Odd.SpecialBetValue, '') + ':0' end
                                                                    else ISNULL(Match.Odd.SpecialBetValue, '') end end                                                   AS SpecialBetValue,
                                                       Language.[Parameter.OddsType].OddsType,
                                                       ''                                                                                                                as OutcomesDescription,
                                                      cast (1 as bit) as IsPopular,
                                                       Match.Odd.OddsTypeId                                                                                              as OddTypeId,
                                                       Fixture.MatchId as MatchId,
                                                       ISNULL((Select MIN(PODD.SeqNumber)
                                                               from Parameter.OddTypeGroupOddType PODD with (nolock)
                                                               where PODD.OddTypeId = Match.Odd.OddsTypeId
                                                                 and PODD.OddTypeGroupId in (2, 12)),
                                                              2)                                                                                                         as SeqNumber,
                                                       Language.[Parameter.OddsType].ShortOddType
                                                        ,
                                                       Match.Odd.ParameterOddId
                                                        ,
                                                       ISNULL((Select MIN(PODD.OddTypeGroupId)
                                                               from Parameter.OddTypeGroupOddType PODD with (nolock)
                                                               where PODD.OddTypeId = Match.Odd.OddsTypeId
                                                                 and PODD.OddTypeGroupId not in (2, 12)),
                                                              2)                                                                                                         as OddTypeGroupId
                                                FROM Match.Odd with (nolock)
                                                         INNER JOIN
                                                     Parameter.Odds with (nolock)
                                                     ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
                                                         INNER JOIN
                                                     Cache.Programme2 Fixture with (nolock)
                                                     ON Match.Odd.MatchId = Fixture.MatchId
                                                         Inner JOIN
                                                     Cache.Fixture as CFF with (nolock) ON CFF.MatchId = Fixture.MatchId
                                                         Inner JOIN
                                                   
                                                     Parameter.OddsType with (nolock)
                                                     ON Parameter.OddsType.OddsTypeId = Parameter.Odds.OddTypeId
                                                         INNER JOIN
                                                     Language.[Parameter.OddsType] with (nolock)
                                                     ON Parameter.OddsType.OddsTypeId =
                                                        Language.[Parameter.OddsType].OddsTypeId
                                                         
                                                     and Language.[Parameter.OddsType].OddsTypeId =
                                                        Match.Odd.OddsTypeId  
                                                        
                                                         INNER JOIN
                                                     Language.[Parameter.Odds] with (nolock)
                                                     ON Parameter.Odds.OddsId = Language.[Parameter.Odds].OddsId AND
                                                        Language.[Parameter.OddsType].LanguageId = @LangId and
                                                        Language.[Parameter.Odds].LanguageId = @LangId 
                                                    INNER JOIN
                                                        Parameter.OddTypeGroupOddType with (nolock) ON Parameter.OddTypeGroupOddType.OddTypeId=Parameter.OddsType.OddsTypeId and  Parameter.OddTypeGroupOddType.OddTypeGroupId=1
                                                WHERE (Match.Odd.StateId = 2)
                                                  and Match.Odd.OddValue > 1
                                                  AND (Parameter.OddsType.IsActive = 1 or Parameter.OddsType.OddsTypeId = 1834)
                                                  and Fixture.SportId in (1, 2, 3, 4, 5, 6, 19, 20, 35)
                                                  and Fixture.MatchDate > GETDATE()
                                                  and Fixture.MatchDate < DATEADD(HOUR, 9, @Endatee)
                                                -- and  cast(Fixture.MatchDate as date)<cast(DATEADD(WEEK,3,GETDATE()) as date)
                                                --Order By RowNumber

                                            end
                end
            else
                if (@CategoryId <> 0 and @TournamentId = 0)
                    begin
                        SELECT ROW_NUMBER() over (PARTITION BY Match.Odd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
                               Match.Odd.OddId,
                               case
                                   when Language.[Parameter.Odds].OutComes is not null
                                       Then Language.[Parameter.Odds].OutComes
                                   else Match.Odd.OutCome end                                                                                    as OutCome,
                               Match.Odd.OddValue,
                               Cache.Fixture.TournamentId,
                               case
                                   when Parameter.Odds.OddsId IN
                                        (1578, 1544, 1648, 1646, 1644, 1642, 2247, 2321, 2325, 2465, 2541, 2543, 3010,
                                         3052, 3079, 3371, 3393)
                                       then CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                   else case
                                            when Match.Odd.OddsTypeId in (1497, 1911, 1493, 1851, 1951, 1864, 1968)
                                                then case
                                                         when cast(Match.Odd.SpecialBetValue AS float) < 0 then '0:' +
                                                                                                                CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                         else ISNULL(Match.Odd.SpecialBetValue, '') + ':0' end
                                            else ISNULL(Match.Odd.SpecialBetValue, '') end end                                                   AS SpecialBetValue,
                               Language.[Parameter.OddsType].OddsType,
                               Parameter.OddsType.OutcomesDescription,
                               Match.Setting.IsPopular,
                               Match.Odd.OddsTypeId                                                                                              as OddTypeId,
                               Match.Setting.MatchId,
                               ISNULL(Parameter.OddTypeGroupOddType.SeqNumber, 999)                                                              as SeqNumber,
                               Language.[Parameter.OddsType].ShortOddType
                                ,
                               Match.Odd.ParameterOddId
                                ,
                               ISNULL((Select MIN(PODD.OddTypeGroupId)
                                       from Parameter.OddTypeGroupOddType PODD with (nolock)
                                       where PODD.OddTypeId = Match.Odd.OddsTypeId
                                         and PODD.OddTypeGroupId not in (2, 12)),
                                      2)                                                                                                         as OddTypeGroupId
                        FROM Match.Odd with (nolock)
                                 INNER JOIN
                             Parameter.Odds with (nolock) ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
                                 INNER JOIN
                             Cache.Fixture with (nolock) ON Match.Odd.MatchId = Cache.Fixture.MatchId
                                 INNER JOIN
                             Parameter.OddsType with (nolock)
                             ON Parameter.OddsType.OddsTypeId = Parameter.Odds.OddTypeId
                                 INNER JOIN
                             Language.[Parameter.OddsType] with (nolock)
                             ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId
                                 INNER JOIN
                             Match.Setting with (nolock)
                             ON Language.[Parameter.OddsType].OddsTypeId = Match.ODd.OddsTypeId AND
                                Match.Setting.MatchId = Cache.Fixture.MatchId
                                 INNER JOIN
                             Language.[Parameter.Odds] with (nolock)
                             ON Parameter.Odds.OddsId = Language.[Parameter.Odds].OddsId AND
                                Language.[Parameter.OddsType].LanguageId = Language.[Parameter.Odds].LanguageId
                                 INNER JOIN
                             Parameter.OddTypeGroupOddType with (nolock)
                             ON Parameter.OddTypeGroupOddType.OddTypeId = Parameter.OddsType.OddsTypeId
                        WHERE (Match.Odd.StateId = 2)
                          and Match.Odd.OddValue > 1
                          AND (Parameter.OddsType.IsActive = 1 or Parameter.OddsType.OddsTypeId = 1834)
                          and (Language.[Parameter.OddsType].LanguageId = @LangId)
                          and Parameter.OddTypeGroupOddType.OddTypeGroupId = @OddTypeGroupId
                          and Cache.Fixture.SportId = @SportId
                          and Cache.Fixture.TournamentId in (Select TournamentId
                                                             from Parameter.Tournament with (nolock)
                                                             where CategoryId = @CategoryId)
                          and ((CAST(Cache.Fixture.MatchDate AS Date) >= (CAST(@EventDate AS Date))))
                          and Cache.Fixture.MatchDate > DATEADD(MINUTE, 10, GETDATE())
                        -- Order By RowNumber -- Match.Odd.SpecialBetValue,Match.Odd.OddId
                    end
                else
                    if (@CategoryId = 0 and @TournamentId <> 0)
                        begin
                            if (@SportId <> -5)
                                begin
                                    SELECT ROW_NUMBER() over (PARTITION BY Match.Odd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
                                           Match.Odd.OddId,
                                           case
                                               when Language.[Parameter.Odds].OutComes is not null
                                                   Then Language.[Parameter.Odds].OutComes
                                               else Match.Odd.OutCome end                                                                                    as OutCome,
                                           Match.Odd.OddValue,
                                           Cache.Fixture.TournamentId,
                                           case
                                               when Parameter.Odds.OddsId IN
                                                    (1578, 1544, 1648, 1646, 1644, 1642, 2247, 2321, 2325, 2465, 2541,
                                                     2543, 3010, 3052, 3079, 3371, 3393)
                                                   then CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                               else case
                                                        when Match.Odd.OddsTypeId in (1497, 1911, 1493, 1851, 1951, 1864, 1968)
                                                            then case
                                                                     when cast(Match.Odd.SpecialBetValue AS float) < 0
                                                                         then '0:' +
                                                                              CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                                     else ISNULL(Match.Odd.SpecialBetValue, '') + ':0' end
                                                        else ISNULL(Match.Odd.SpecialBetValue, '') end end                                                   AS SpecialBetValue,
                                           Language.[Parameter.OddsType].OddsType,
                                           Parameter.OddsType.OutcomesDescription,
                                           Match.Setting.IsPopular,
                                           Match.Odd.OddsTypeId                                                                                              as OddTypeId,
                                           Match.Setting.MatchId,
                                           ISNULL(Parameter.OddTypeGroupOddType.SeqNumber, 999)                                                              as SeqNumber,
                                           Language.[Parameter.OddsType].ShortOddType
                                            ,
                                           Match.Odd.ParameterOddId
                                            ,
                                           ISNULL((Select MIN(PODD.OddTypeGroupId)
                                                   from Parameter.OddTypeGroupOddType PODD with (nolock)
                                                   where PODD.OddTypeId = Match.Odd.OddsTypeId
                                                     and PODD.OddTypeGroupId not in (2, 12)),
                                                  2)                                                                                                         as OddTypeGroupId
                                    FROM Match.Odd with (nolock)
                                             INNER JOIN
                                         Parameter.Odds with (nolock)
                                         ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
                                             INNER JOIN
                                         Cache.Fixture with (nolock) ON Match.Odd.MatchId = Cache.Fixture.MatchId
                                             INNER JOIN
                                         Parameter.OddsType with (nolock)
                                         ON Parameter.OddsType.OddsTypeId = Parameter.Odds.OddTypeId
                                             INNER JOIN
                                         Language.[Parameter.OddsType] with (nolock)
                                         ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId
                                             INNER JOIN
                                         Match.Setting with (nolock)
                                         ON Language.[Parameter.OddsType].OddsTypeId = Match.Odd.OddsTypeId AND
                                            Match.Setting.MatchId = Cache.Fixture.MatchId
                                             INNER JOIN
                                         Language.[Parameter.Odds] with (nolock)
                                         ON Parameter.Odds.OddsId = Language.[Parameter.Odds].OddsId AND
                                            Language.[Parameter.OddsType].LanguageId =
                                            Language.[Parameter.Odds].LanguageId
                                             INNER JOIN
                                         Parameter.OddTypeGroupOddType with (nolock)
                                         ON Parameter.OddTypeGroupOddType.OddTypeId = Parameter.OddsType.OddsTypeId
                                    WHERE (Match.Odd.StateId = 2)
                                      and Match.Odd.OddValue > 1
                                      AND (Parameter.OddsType.IsActive = 1 or Parameter.OddsType.OddsTypeId = 1834)
                                      and (Language.[Parameter.OddsType].LanguageId = @LangId)
                                      and Parameter.OddTypeGroupOddType.OddTypeGroupId = @OddTypeGroupId --- and Cache.Fixture.SportId=@SportId
                                      and Cache.Fixture.TournamentId in (select TournamentId
                                                                         from Parameter.Tournament with (nolock)
                                                                         where TerminalTournamentId = @TournamentId)

                                      --and ((CAST(Cache.Fixture.MatchDate AS Date)=(CAST(@EventDate AS Date))))
                                      and Cache.Fixture.MatchDate > DATEADD(MINUTE, 10, GETDATE())
                                    -- Order By RowNumber-- Order By Match.Odd.SpecialBetValue,Match.Odd.OddId
                                end
                            else
                                begin
                                    SELECT ROW_NUMBER() over (PARTITION BY Match.Odd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
                                           Match.Odd.OddId,
                                           case
                                               when Language.[Parameter.Odds].OutComes is not null
                                                   Then Language.[Parameter.Odds].OutComes
                                               else Match.Odd.OutCome end                                                                                    as OutCome,
                                           Match.Odd.OddValue,
                                           Cache.Fixture.TournamentId,
                                           case
                                               when Parameter.Odds.OddsId IN
                                                    (1578, 1544, 1648, 1646, 1644, 1642, 2247, 2321, 2325, 2465, 2541,
                                                     2543, 3010, 3052, 3079, 3371, 3393)
                                                   then CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                               else case
                                                        when Match.Odd.OddsTypeId in (1497, 1911, 1493, 1851, 1951, 1864, 1968)
                                                            then case
                                                                     when cast(Match.Odd.SpecialBetValue AS float) < 0
                                                                         then '0:' +
                                                                              CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                                     else ISNULL(Match.Odd.SpecialBetValue, '') + ':0' end
                                                        else ISNULL(Match.Odd.SpecialBetValue, '') end end                                                   AS SpecialBetValue,
                                           Language.[Parameter.OddsType].OddsType,
                                           Parameter.OddsType.OutcomesDescription,
                                           Match.Setting.IsPopular,
                                           Match.Odd.OddsTypeId                                                                                              as OddTypeId,
                                           Match.Setting.MatchId,
                                           ISNULL(Parameter.OddTypeGroupOddType.SeqNumber, 999)                                                              as SeqNumber,
                                           Language.[Parameter.OddsType].ShortOddType
                                            ,
                                           Match.Odd.ParameterOddId
                                            ,
                                           ISNULL((Select MIN(PODD.OddTypeGroupId)
                                                   from Parameter.OddTypeGroupOddType PODD with (nolock)
                                                   where PODD.OddTypeId = Match.Odd.OddsTypeId
                                                     and PODD.OddTypeGroupId not in (2, 12)),
                                                  2)                                                                                                         as OddTypeGroupId
                                    FROM Match.Odd with (nolock)
                                             INNER JOIN
                                         Parameter.Odds with (nolock)
                                         ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
                                             INNER JOIN
                                         Cache.Fixture with (nolock) ON Match.Odd.MatchId = Cache.Fixture.MatchId
                                             INNER JOIN
                                         Parameter.OddsType with (nolock)
                                         ON Parameter.OddsType.OddsTypeId = Parameter.Odds.OddTypeId
                                             INNER JOIN
                                         Language.[Parameter.OddsType] with (nolock)
                                         ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId
                                             INNER JOIN
                                         Match.Setting with (nolock)
                                         ON Language.[Parameter.OddsType].OddsTypeId = Match.Odd.OddsTypeId AND
                                            Match.Setting.MatchId = Cache.Fixture.MatchId
                                             INNER JOIN
                                         Language.[Parameter.Odds] with (nolock)
                                         ON Parameter.Odds.OddsId = Language.[Parameter.Odds].OddsId AND
                                            Language.[Parameter.OddsType].LanguageId =
                                            Language.[Parameter.Odds].LanguageId
                                             INNER JOIN
                                         Parameter.OddTypeGroupOddType with (nolock)
                                         ON Parameter.OddTypeGroupOddType.OddTypeId = Parameter.OddsType.OddsTypeId
                                    WHERE (Match.Odd.StateId = 2)
                                      and Match.Odd.OddValue > 1
                                      AND (Parameter.OddsType.IsActive = 1 or Parameter.OddsType.OddsTypeId = 1834)
                                      and (Language.[Parameter.OddsType].LanguageId = @LangId)
                                      and Parameter.OddTypeGroupOddType.OddTypeGroupId = @OddTypeGroupId --- and Cache.Fixture.SportId=@SportId
                                      and Cache.Fixture.TournamentId = @TournamentId

                                      and ((Cache.Fixture.MatchDate <= @EventDate))
                                      and Cache.Fixture.MatchDate > DATEADD(MINUTE, 3, GETDATE())
                                    -- Order By RowNumber-- Order By Match.Odd.SpecialBetValue,Match.Odd.OddId
                                end
                        end
                    else
                        begin
                            SELECT ROW_NUMBER() over (PARTITION BY Match.Odd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
                                   Match.Odd.OddId,
                                   case
                                       when Language.[Parameter.Odds].OutComes is not null
                                           Then Language.[Parameter.Odds].OutComes
                                       else Match.Odd.OutCome end                                                                                    as OutCome,
                                   Match.Odd.OddValue,
                                   Cache.Fixture.TournamentId,
                                   case
                                       when Parameter.Odds.OddsId IN
                                            (1578, 1544, 1648, 1646, 1644, 1642, 2247, 2321, 2325, 2465, 2541, 2543,
                                             3010, 3052, 3079, 3371, 3393)
                                           then CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                       else case
                                                when Match.Odd.OddsTypeId in (1497, 1911, 1493, 1851, 1951, 1864, 1968)
                                                    then case
                                                             when cast(Match.Odd.SpecialBetValue AS float) < 0 then
                                                                 '0:' +
                                                                 CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                             else ISNULL(Match.Odd.SpecialBetValue, '') + ':0' end
                                                else ISNULL(Match.Odd.SpecialBetValue, '') end end                                                   AS SpecialBetValue,
                                   Language.[Parameter.OddsType].OddsType,
                                   Parameter.OddsType.OutcomesDescription,
                                   Match.Setting.IsPopular,
                                   Match.Odd.OddsTypeId                                                                                              as OddTypeId,
                                   Match.Setting.MatchId,
                                   ISNULL(Parameter.OddTypeGroupOddType.SeqNumber, 999)                                                              as SeqNumber,
                                   Language.[Parameter.OddsType].ShortOddType
                                    ,
                                   Match.Odd.ParameterOddId
                                    ,
                                   ISNULL((Select MIN(PODD.OddTypeGroupId)
                                           from Parameter.OddTypeGroupOddType PODD with (nolock)
                                           where PODD.OddTypeId = Match.Odd.OddsTypeId
                                             and PODD.OddTypeGroupId not in (2, 12)),
                                          2)                                                                                                         as OddTypeGroupId
                            FROM Match.Odd with (nolock)
                                     INNER JOIN
                                 Parameter.Odds with (nolock) ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
                                     INNER JOIN
                                 Cache.Fixture with (nolock) ON Match.Odd.MatchId = Cache.Fixture.MatchId
                                     INNER JOIN
                                 Parameter.OddsType with (nolock)
                                 ON Parameter.OddsType.OddsTypeId = Parameter.Odds.OddTypeId
                                     INNER JOIN
                                 Language.[Parameter.OddsType] with (nolock)
                                 ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId
                                     INNER JOIN
                                 Match.Setting with (nolock)
                                 ON Language.[Parameter.OddsType].OddsTypeId = Match.ODd.OddsTypeId AND
                                    Match.Setting.MatchId = Cache.Fixture.MatchId
                                     INNER JOIN
                                 Language.[Parameter.Odds] with (nolock)
                                 ON Parameter.Odds.OddsId = Language.[Parameter.Odds].OddsId AND
                                    Language.[Parameter.OddsType].LanguageId = Language.[Parameter.Odds].LanguageId
                                     INNER JOIN
                                 Parameter.OddTypeGroupOddType with (nolock)
                                 ON Parameter.OddTypeGroupOddType.OddTypeId = Parameter.OddsType.OddsTypeId
                            WHERE (Match.Odd.StateId = 2)
                              and Match.Odd.OddValue > 1
                              AND (Parameter.OddsType.IsActive = 1 or Parameter.OddsType.OddsTypeId = 1834)
                              and (Language.[Parameter.OddsType].LanguageId = @LangId)
                              and Parameter.OddTypeGroupOddType.OddTypeGroupId = @OddTypeGroupId
                              and Cache.Fixture.SportId in (1, 2, 3, 4, 5, 6, 19, 20, 35)--and Cache.Fixture.SportId=@SportId
                              and ((CAST(Cache.Fixture.MatchDate AS Date) = (CAST(@EventDate AS Date))))
                              and Cache.Fixture.MatchDate > DATEADD(MINUTE, 10, GETDATE())
                            -- Order By RowNumber-- Order By Match.Odd.SpecialBetValue,Match.Odd.OddId
                        end
        end
    else
        begin

            if (@CategoryId = 0 and @TournamentId = 0)
                begin
                    if (@SportId > 0)
                        begin
                            if exists (SELECT Cache.Fixture.MatchId
                                       FROM Cache.Fixture with (nolock)
                                       Where Cache.Fixture.SportId = @SportId
                                         and ((CAST(Cache.Fixture.MatchDate AS Date) = (CAST(@EventDate AS Date))))
                                         and Cache.Fixture.MatchDate > DATEADD(MINUTE, 2, GETDATE()))
                                begin
                                    SELECT ROW_NUMBER() over (PARTITION BY Match.ODd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
                                           Match.Odd.OddId,
                                           case
                                               when Language.[Parameter.Odds].OutComes is not null
                                                   Then Language.[Parameter.Odds].OutComes
                                               else Match.Odd.OutCome end                                                                                    as OutCome,
                                           Match.Odd.OddValue,
                                           Cache.Fixture.TournamentId,
                                           case
                                               when Parameter.Odds.OddsId IN
                                                    (1578, 1544, 1648, 1646, 1644, 1642, 2247, 2321, 2325, 2465, 2541,
                                                     2543, 3010, 3052, 3079, 3371, 3393)
                                                   then CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                               else case
                                                        when Match.Odd.OddsTypeId in (1497, 1911, 1493, 1851, 1951, 1864, 1968)
                                                            then case
                                                                     when cast(Match.Odd.SpecialBetValue AS float) < 0
                                                                         then '0:' +
                                                                              CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                                     else ISNULL(Match.Odd.SpecialBetValue, '') + ':0' end
                                                        else ISNULL(Match.Odd.SpecialBetValue, '') end end                                                   AS SpecialBetValue,
                                           Language.[Parameter.OddsType].OddsType,
                                           Parameter.OddsType.OutcomesDescription,
                                           Match.Setting.IsPopular,
                                           Match.Odd.OddsTypeId                                                                                              as OddTypeId,
                                           Match.Setting.MatchId,
                                           ISNULL(Parameter.OddsType.SeqNumber, 999)                                                                         as SeqNumber,
                                           Language.[Parameter.OddsType].OddsType                                                                            as ShortOddType
                                            ,
                                           Match.Odd.ParameterOddId
                                            ,
                                           ISNULL((Select MIN(PODD.OddTypeGroupId)
                                                   from Parameter.OddTypeGroupOddType PODD with (nolock)
                                                   where PODD.OddTypeId = Match.Odd.OddsTypeId
                                                     and PODD.OddTypeGroupId not in (2, 12)),
                                                  2)                                                                                                         as OddTypeGroupId
                                    FROM Match.Odd with (nolock)
                                             INNER JOIN
                                         Parameter.Odds with (nolock)
                                         ON Parameter.Odds.OddsId = Match.Odd.ParameterOddId
                                             INNER JOIN
                                         Cache.Fixture with (nolock) ON Cache.Fixture.MatchId = Match.Odd.MatchId
                                             INNER JOIN
                                         Parameter.OddsType with (nolock)
                                         ON Parameter.OddsType.OddsTypeId = Match.Odd.OddsTypeId
                                             INNER JOIN
                                         Language.[Parameter.OddsType] with (nolock)
                                         ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId and
                                            Language.[Parameter.OddsType].LanguageId = @LangId
                                             INNER JOIN
                                         Language.[Parameter.Odds] with (nolock)
                                         ON Language.[Parameter.Odds].OddsId = Match.Odd.ParameterOddId AND
                                            Language.[Parameter.Odds].LanguageId = @LangId
                                             INNER JOIN
                                         Match.Setting with (nolock) ON
                                             Match.Setting.MatchId = Match.Odd.MatchId
                                    WHERE Match.Odd.StateId = 2
                                      and Match.Setting.StateId = 2
                                      and Match.Odd.OddValue > 1
                                      AND (Parameter.OddsType.IsActive = 1 or Parameter.OddsType.OddsTypeId = 1834)
                                      and Cache.Fixture.SportId = @SportId
                                      and ((CAST(Cache.Fixture.MatchDate AS Date) <= (CAST(@EventDate AS Date))))
                                      and Cache.Fixture.MatchDate > DATEADD(MINUTE, 2, GETDATE())
                                    --Order By RowNumber
                                end
                            else
                                begin
                                    SELECT ROW_NUMBER() over (PARTITION BY Match.Odd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
                                           Match.Odd.OddId,
                                           case
                                               when Language.[Parameter.Odds].OutComes is not null
                                                   Then Language.[Parameter.Odds].OutComes
                                               else Match.Odd.OutCome end                                                                                    as OutCome,
                                           Match.Odd.OddValue,
                                           Cache.Fixture.TournamentId,
                                           case
                                               when Parameter.Odds.OddsId IN
                                                    (1578, 1544, 1648, 1646, 1644, 1642, 2247, 2321, 2325, 2465, 2541,
                                                     2543, 3010, 3052, 3079, 3371, 3393)
                                                   then CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                               else case
                                                        when Match.Odd.OddsTypeId in (1497, 1911, 1493, 1851, 1951, 1864, 1968)
                                                            then case
                                                                     when cast(Match.Odd.SpecialBetValue AS float) < 0
                                                                         then '0:' +
                                                                              CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                                     else ISNULL(Match.Odd.SpecialBetValue, '') + ':0' end
                                                        else ISNULL(Match.Odd.SpecialBetValue, '') end end                                                   AS SpecialBetValue,
                                           Language.[Parameter.OddsType].OddsType,
                                           Parameter.OddsType.OutcomesDescription,
                                           Match.Setting.IsPopular,
                                           Match.Odd.OddsTypeId                                                                                              as OddTypeId,
                                           Match.Setting.MatchId,
                                           ISNULL(Parameter.OddsType.SeqNumber, 999)                                                                         as SeqNumber,
                                           Language.[Parameter.OddsType].OddsType                                                                            as ShortOddType
                                            ,
                                           Match.Odd.ParameterOddId
                                            ,
                                           ISNULL((Select MIN(PODD.OddTypeGroupId)
                                                   from Parameter.OddTypeGroupOddType PODD with (nolock)
                                                   where PODD.OddTypeId = Match.Odd.OddsTypeId
                                                     and PODD.OddTypeGroupId not in (2, 12)),
                                                  2)                                                                                                         as OddTypeGroupId
                                    FROM Match.Odd with (nolock)
                                             INNER JOIN
                                         Parameter.Odds with (nolock)
                                         ON Parameter.Odds.OddsId = Match.Odd.ParameterOddId
                                             INNER JOIN
                                         Cache.Fixture with (nolock) ON Cache.Fixture.MatchId = Match.Odd.MatchId
                                             INNER JOIN
                                         Parameter.OddsType with (nolock)
                                         ON Parameter.OddsType.OddsTypeId = Match.Odd.OddsTypeId
                                             INNER JOIN
                                         Language.[Parameter.OddsType] with (nolock)
                                         ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId and
                                            Language.[Parameter.OddsType].LanguageId = @LangId
                                             INNER JOIN
                                         Language.[Parameter.Odds] with (nolock)
                                         ON Language.[Parameter.Odds].OddsId = Match.Odd.ParameterOddId AND
                                            Language.[Parameter.Odds].LanguageId = @LangId
                                             INNER JOIN
                                         Match.Setting with (nolock) ON
                                             Match.Setting.MatchId = Match.Odd.MatchId
                                    WHERE (Match.Odd.StateId = 2)
                                      and Match.Odd.OddValue > 1
                                      AND (Parameter.OddsType.IsActive = 1 or Parameter.OddsType.OddsTypeId = 1834)
                                      and Cache.Fixture.SportId = @SportId
                                      and Cache.Fixture.MatchDate >= DATEADD(MINUTE, 2, GETDATE())
                                      and cast(Cache.Fixture.MatchDate as date) < DATEADD(DAY, 1, GETDATE())

                                end
                        end
                    else
                        if (@SportId = 0)
                            begin
                                SELECT ROW_NUMBER() over (PARTITION BY Match.Odd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
                                       Match.Odd.OddId,
                                       case
                                           when Language.[Parameter.Odds].OutComes is not null
                                               Then Language.[Parameter.Odds].OutComes
                                           else Match.Odd.OutCome end                                                                                    as OutCome,
                                       Match.Odd.OddValue,
                                       Cache.Fixture.TournamentId,
                                       case
                                           when Parameter.Odds.OddsId IN
                                                (1578, 1544, 1648, 1646, 1644, 1642, 2247, 2321, 2325, 2465, 2541, 2543,
                                                 3010, 3052, 3079, 3371, 3393)
                                               then CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                           else case
                                                    when Match.Odd.OddsTypeId in (1497, 1911, 1493, 1851, 1951, 1864, 1968)
                                                        then case
                                                                 when cast(Match.Odd.SpecialBetValue AS float) < 0 then
                                                                     '0:' +
                                                                     CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                                 else ISNULL(Match.Odd.SpecialBetValue, '') + ':0' end
                                                    else ISNULL(Match.Odd.SpecialBetValue, '') end end                                                   AS SpecialBetValue,
                                       Language.[Parameter.OddsType].OddsType,
                                       ''                                                                                                                as OutcomesDescription,
                                       Match.Setting.IsPopular,
                                       Match.Odd.OddsTypeId                                                                                              as OddTypeId,
                                       Match.Setting.MatchId,
                                       ISNULL(Parameter.OddsType.SeqNumber, 999)                                                                         as SeqNumber,
                                       Language.[Parameter.OddsType].OddsType                                                                            as ShortOddType
                                        ,
                                       Match.Odd.ParameterOddId
                                        ,
                                       ISNULL((Select MIN(PODD.OddTypeGroupId)
                                               from Parameter.OddTypeGroupOddType PODD with (nolock)
                                               where PODD.OddTypeId = Match.Odd.OddsTypeId
                                                 and PODD.OddTypeGroupId not in (2, 12)),
                                              2)                                                                                                         as OddTypeGroupId
                                FROM Match.Odd with (nolock)
                                         INNER JOIN
                                     Parameter.Odds with (nolock) ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
                                         INNER JOIN
                                     Cache.Fixture with (nolock) ON Match.Odd.MatchId = Cache.Fixture.MatchId
                                         INNER JOIN
                                     Parameter.OddsType with (nolock)
                                     ON Parameter.OddsType.OddsTypeId = Parameter.Odds.OddTypeId
                                         INNER JOIN
                                     Language.[Parameter.OddsType] with (nolock)
                                     ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId
                                         INNER JOIN
                                     Match.Setting with (nolock)
                                     ON Language.[Parameter.OddsType].OddsTypeId = Match.Odd.OddsTypeId AND
                                        Match.Setting.MatchId = Cache.Fixture.MatchId
                                         INNER JOIN
                                     Language.[Parameter.Odds] with (nolock)
                                     ON Parameter.Odds.OddsId = Language.[Parameter.Odds].OddsId AND
                                        Language.[Parameter.OddsType].LanguageId = @LangId and
                                        Language.[Parameter.Odds].LanguageId = @LangId

                                WHERE (Match.Odd.StateId = 2)
                                  and Match.Odd.OddValue > 1
                                  AND (Parameter.OddsType.IsActive = 1 or Parameter.OddsType.OddsTypeId = 1834)
                                  and Cache.Fixture.SportId in (1, 2, 3, 4, 5, 6, 19, 20, 35)
                                  and ((CAST(Cache.Fixture.MatchDate AS Date) = (CAST(@EventDate AS Date))))
                                  and Cache.Fixture.MatchDate > DATEADD(MINUTE, 10, GETDATE())
                                --Order By RowNumber

                            end
                        else
                            if (@SportId = -1)
                                begin
                                    SELECT ROW_NUMBER() over (PARTITION BY Match.Odd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
                                           Match.Odd.OddId,
                                           case
                                               when Language.[Parameter.Odds].OutComes is not null
                                                   Then Language.[Parameter.Odds].OutComes
                                               else Match.Odd.OutCome end                                                                                    as OutCome,
                                           Match.Odd.OddValue,
                                           Cache.Fixture.TournamentId,
                                           case
                                               when Parameter.Odds.OddsId IN
                                                    (1578, 1544, 1648, 1646, 1644, 1642, 2247, 2321, 2325, 2465, 2541,
                                                     2543, 3010, 3052, 3079, 3371, 3393)
                                                   then CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                               else case
                                                        when Match.Odd.OddsTypeId in (1497, 1911, 1493, 1851, 1951, 1864, 1968)
                                                            then case
                                                                     when cast(Match.Odd.SpecialBetValue AS float) < 0
                                                                         then '0:' +
                                                                              CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                                     else ISNULL(Match.Odd.SpecialBetValue, '') + ':0' end
                                                        else ISNULL(Match.Odd.SpecialBetValue, '') end end                                                   AS SpecialBetValue,
                                           Language.[Parameter.OddsType].OddsType,
                                           ''                                                                                                                as OutcomesDescription,
                                           Match.Setting.IsPopular,
                                           Match.Odd.OddsTypeId                                                                                              as OddTypeId,
                                           Match.Setting.MatchId,
                                           ISNULL(Parameter.OddsType.SeqNumber, 999)                                                                         as SeqNumber,
                                           Language.[Parameter.OddsType].OddsType                                                                            as ShortOddType
                                            ,
                                           Match.Odd.ParameterOddId
                                            ,
                                           ISNULL((Select MIN(PODD.OddTypeGroupId)
                                                   from Parameter.OddTypeGroupOddType PODD with (nolock)
                                                   where PODD.OddTypeId = Match.Odd.OddsTypeId
                                                     and PODD.OddTypeGroupId not in (2, 12)),
                                                  2)                                                                                                         as OddTypeGroupId
                                    FROM Match.Odd with (nolock)
                                             INNER JOIN
                                         Parameter.Odds with (nolock)
                                         ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
                                             INNER JOIN
                                         Cache.Fixture with (nolock) ON Match.Odd.MatchId = Cache.Fixture.MatchId
                                             INNER JOIN
                                         Parameter.OddsType with (nolock)
                                         ON Parameter.OddsType.OddsTypeId = Parameter.Odds.OddTypeId
                                             INNER JOIN
                                         Language.[Parameter.OddsType] with (nolock)
                                         ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId
                                             INNER JOIN
                                         Match.Setting with (nolock)
                                         ON Language.[Parameter.OddsType].OddsTypeId = Match.Odd.OddsTypeId AND
                                            Match.Setting.MatchId = Cache.Fixture.MatchId
                                             INNER JOIN
                                         Language.[Parameter.Odds] with (nolock)
                                         ON Parameter.Odds.OddsId = Language.[Parameter.Odds].OddsId AND
                                            Language.[Parameter.OddsType].LanguageId = @LangId and
                                            Language.[Parameter.Odds].LanguageId = @LangId
                                             INNER JOIN Parameter.Tournament
                                                        On Parameter.Tournament.TournamentId = Cache.Fixture.TournamentId
                                    WHERE (Match.Odd.StateId = 2)
                                      and Match.Odd.OddValue > 1
                                      AND (Parameter.OddsType.IsActive = 1 or Parameter.OddsType.OddsTypeId = 1834)
                                      and Cache.Fixture.IsPopular = 1
                                      and Cache.Fixture.SportId in (1, 2, 3, 4, 5, 6, 19, 20, 35)
                                      and Cache.Fixture.MatchDate > DATEADD(MINUTE, 10, GETDATE())
                                    --and  cast(Cache.Fixture.MatchDate as date)<  cast(@EventDate as date)
                                    --Order By RowNumber

                                end
                            else
                                if (@SportId = -2)
                                    begin


                                        insert @TempTable
                                        SELECT top 32 Customer.SlipOdd.MatchId
                                        FROM Customer.SlipOdd with (nolock)
                                        WHERE (CAST(Customer.SlipOdd.EventDate AS date) >= CAST(GETDATE() AS date))
                                        group by Customer.SlipOdd.MatchId
                                        ORDER BY COUNT(Customer.SlipOdd.MatchId) desc


                                        if ((select count(MatchId) from @TempTable) < 4)
                                            begin
                                                insert @TempTable
                                                SELECT top 50 Cache.Fixture.MatchId
                                                FROM Cache.Fixture with (nolock)
                                                WHERE Cache.Fixture.IsPopular = 1
                                                  and MatchId not in (select MatchId from @TempTable)
                                            end

                                        SELECT ROW_NUMBER() over (PARTITION BY Match.Odd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
                                               Match.Odd.OddId,
                                               case
                                                   when Language.[Parameter.Odds].OutComes is not null
                                                       Then Language.[Parameter.Odds].OutComes
                                                   else Match.Odd.OutCome end                                                                                    as OutCome,
                                               Match.Odd.OddValue,
                                               Fixture.TournamentId,
                                               case
                                                   when Parameter.Odds.OddsId IN
                                                        (1578, 1544, 1648, 1646, 1644, 1642, 2247, 2321, 2325, 2465,
                                                         2541, 2543, 3010, 3052, 3079, 3371, 3393)
                                                       then CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                   else case
                                                            when Match.Odd.OddsTypeId in (1497, 1911, 1493, 1851, 1951, 1864, 1968)
                                                                then case
                                                                         when cast(Match.Odd.SpecialBetValue AS float) < 0
                                                                             then '0:' +
                                                                                  CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                                         else ISNULL(Match.Odd.SpecialBetValue, '') + ':0' end
                                                            else ISNULL(Match.Odd.SpecialBetValue, '') end end                                                   AS SpecialBetValue,
                                               Language.[Parameter.OddsType].OddsType,
                                               ''                                                                                                                as OutcomesDescription,
                                               Match.Setting.IsPopular,
                                               Match.Odd.OddsTypeId                                                                                              as OddTypeId,
                                               Match.Setting.MatchId,
                                               ISNULL(Parameter.OddsType.SeqNumber, 999)                                                                         as SeqNumber,
                                               Language.[Parameter.OddsType].OddsType                                                                            as ShortOddType
                                                ,
                                               Match.Odd.ParameterOddId
                                                ,
                                               ISNULL((Select MIN(PODD.OddTypeGroupId)
                                                       from Parameter.OddTypeGroupOddType PODD with (nolock)
                                                       where PODD.OddTypeId = Match.Odd.OddsTypeId
                                                         and PODD.OddTypeGroupId not in (2, 12)),
                                                      2)                                                                                                         as OddTypeGroupId
                                        FROM Match.Odd with (nolock)
                                                 INNER JOIN
                                             Parameter.Odds with (nolock)
                                             ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
                                                 INNER JOIN
                                             Cache.Programme2 Fixture with (nolock)
                                             ON Match.Odd.MatchId = Fixture.MatchId
                                                 INNER JOIN
                                             Parameter.OddsType with (nolock)
                                             ON Parameter.OddsType.OddsTypeId = Parameter.Odds.OddTypeId
                                                 INNER JOIN
                                             Language.[Parameter.OddsType] with (nolock)
                                             ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId
                                                 INNER JOIN
                                             Match.Setting with (nolock)
                                             ON Language.[Parameter.OddsType].OddsTypeId = Match.Odd.OddsTypeId AND
                                                Match.Setting.MatchId = Fixture.MatchId
                                                 INNER JOIN
                                             @TempTable AS temp ON Fixture.MatchId = temp.MatchId
                                                 INNER JOIN
                                             Language.[Parameter.Odds] with (nolock)
                                             ON Parameter.Odds.OddsId = Language.[Parameter.Odds].OddsId AND
                                                Language.[Parameter.OddsType].LanguageId = @LangId and
                                                Language.[Parameter.Odds].LanguageId = @LangId
                                        WHERE (Match.Odd.StateId = 2)
                                          and Match.Odd.OddValue > 1
                                          AND (Parameter.OddsType.IsActive = 1 or Parameter.OddsType.OddsTypeId = 1834)
                                          and Fixture.SportId in (1, 2, 3, 4, 5, 6, 19, 20, 35)
                                          and Fixture.MatchDate > DATEADD(MINUTE, 10, GETDATE())
                                        -- and  cast(Fixture.MatchDate as date)<cast(DATEADD(WEEK,3,GETDATE()) as date)
                                        --Order By RowNumber

                                    end
                                else
                                    if (@SportId = -3)
                                        begin


                                            SELECT ROW_NUMBER() over (PARTITION BY Match.Odd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
                                                   Match.Odd.OddId,
                                                   case
                                                       when Language.[Parameter.Odds].OutComes is not null
                                                           Then Language.[Parameter.Odds].OutComes
                                                       else Match.Odd.OutCome end                                                                                    as OutCome,
                                                   Match.Odd.OddValue,
                                                   Fixture.TournamentId,
                                                   case
                                                       when Parameter.Odds.OddsId IN
                                                            (1578, 1544, 1648, 1646, 1644, 1642, 2247, 2321, 2325, 2465,
                                                             2541, 2543, 3010, 3052, 3079, 3371, 3393)
                                                           then CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                       else case
                                                                when Match.Odd.OddsTypeId in (1497, 1911, 1493, 1851, 1951, 1864, 1968)
                                                                    then case
                                                                             when cast(Match.Odd.SpecialBetValue AS float) < 0
                                                                                 then '0:' +
                                                                                      CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                                             else ISNULL(Match.Odd.SpecialBetValue, '') + ':0' end
                                                                else ISNULL(Match.Odd.SpecialBetValue, '') end end                                                   AS SpecialBetValue,
                                                   Language.[Parameter.OddsType].OddsType,
                                                   ''                                                                                                                as OutcomesDescription,
                                                   Match.Setting.IsPopular,
                                                   Match.Odd.OddsTypeId                                                                                              as OddTypeId,
                                                   Match.Setting.MatchId,
                                                   ISNULL(Parameter.OddsType.SeqNumber, 999)                                                                         as SeqNumber,
                                                   Language.[Parameter.OddsType].OddsType                                                                            as ShortOddType
                                                    ,
                                                   Match.Odd.ParameterOddId
                                                    ,
                                                   ISNULL((Select MIN(PODD.OddTypeGroupId)
                                                           from Parameter.OddTypeGroupOddType PODD with (nolock)
                                                           where PODD.OddTypeId = Match.Odd.OddsTypeId
                                                             and PODD.OddTypeGroupId not in (2, 12)),
                                                          2)                                                                                                         as OddTypeGroupId
                                            FROM Match.Odd with (nolock)
                                                     INNER JOIN
                                                 Parameter.Odds with (nolock)
                                                 ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
                                                     INNER JOIN
                                                 Cache.Programme2 Fixture with (nolock)
                                                 ON Match.Odd.MatchId = Fixture.MatchId
                                                     INNER JOIN
                                                 Parameter.OddsType with (nolock)
                                                 ON Parameter.OddsType.OddsTypeId = Parameter.Odds.OddTypeId
                                                     INNER JOIN
                                                 Language.[Parameter.OddsType] with (nolock)
                                                 ON Parameter.OddsType.OddsTypeId =
                                                    Language.[Parameter.OddsType].OddsTypeId
                                                     INNER JOIN
                                                 Match.Setting with (nolock)
                                                 ON Language.[Parameter.OddsType].OddsTypeId = Match.Odd.OddsTypeId AND
                                                    Match.Setting.MatchId = Fixture.MatchId
                                                     INNER JOIN
                                                 Language.[Parameter.Odds] with (nolock)
                                                 ON Parameter.Odds.OddsId = Language.[Parameter.Odds].OddsId AND
                                                    Language.[Parameter.OddsType].LanguageId = @LangId and
                                                    Language.[Parameter.Odds].LanguageId = @LangId
                                            WHERE (Match.Odd.StateId = 2)
                                              and Match.Odd.OddValue > 1
                                              AND (Parameter.OddsType.IsActive = 1 or Parameter.OddsType.OddsTypeId = 1834)
                                              and Fixture.SportId in (1, 2, 3, 4, 5, 6, 19, 20, 35)
                                              and Match.Setting.[IsHighlights] = 1
                                              and Fixture.MatchDate > DATEADD(MINUTE, 10, GETDATE())
                                            -- and  cast(Fixture.MatchDate as date)<cast(DATEADD(WEEK,3,GETDATE()) as date)
                                            --Order By RowNumber

                                        end
                                    else
                                        if (@SportId = -4)
                                            begin


                                                set @Endatee =
                                                        cast(Cast(DATEADD(DAY, 1, GETDATE()) as date) as nvarchar(10)) +
                                                        ' 00:00:00.000'


                                                SELECT ROW_NUMBER() over (PARTITION BY Match.Odd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
                                                       Match.Odd.OddId,
                                                       case
                                                           when Language.[Parameter.Odds].OutComes is not null
                                                               Then Language.[Parameter.Odds].OutComes
                                                           else Match.Odd.OutCome end                                                                                    as OutCome,
                                                       Match.Odd.OddValue,
                                                       Fixture.TournamentId,
                                                       case
                                                           when Parameter.Odds.OddsId IN
                                                                (1578, 1544, 1648, 1646, 1644, 1642, 2247, 2321, 2325,
                                                                 2465, 2541, 2543, 3010, 3052, 3079, 3371, 3393)
                                                               then CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                           else case
                                                                    when Match.Odd.OddsTypeId in (1497, 1911, 1493, 1851, 1951, 1864, 1968)
                                                                        then case
                                                                                 when cast(Match.Odd.SpecialBetValue AS float) < 0
                                                                                     then '0:' +
                                                                                          CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                                                 else ISNULL(Match.Odd.SpecialBetValue, '') + ':0' end
                                                                    else ISNULL(Match.Odd.SpecialBetValue, '') end end                                                   AS SpecialBetValue,
                                                       Language.[Parameter.OddsType].OddsType,
                                                       ''                                                                                                                as OutcomesDescription,
                                                       Match.Setting.IsPopular,
                                                       Match.Odd.OddsTypeId                                                                                              as OddTypeId,
                                                       Match.Setting.MatchId,
                                                       ISNULL(Parameter.OddsType.SeqNumber, 999)                                                                         as SeqNumber,
                                                       Language.[Parameter.OddsType].OddsType                                                                            as ShortOddType
                                                        ,
                                                       Match.Odd.ParameterOddId
                                                        ,
                                                       ISNULL((Select MIN(PODD.OddTypeGroupId)
                                                               from Parameter.OddTypeGroupOddType PODD with (nolock)
                                                               where PODD.OddTypeId = Match.Odd.OddsTypeId
                                                                 and PODD.OddTypeGroupId not in (2, 12)),
                                                              2)                                                                                                         as OddTypeGroupId
                                                FROM Match.Odd with (nolock)
                                                         INNER JOIN
                                                     Parameter.Odds with (nolock)
                                                     ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
                                                         INNER JOIN
                                                     Cache.Programme2 Fixture with (nolock)
                                                     ON Match.Odd.MatchId = Fixture.MatchId
                                                         Inner JOIN
                                                     Cache.Fixture as CFF with (nolock) ON CFF.MatchId = Fixture.MatchId
                                                         Inner JOIN
                                                   
                                                     Parameter.OddsType with (nolock)
                                                     ON Parameter.OddsType.OddsTypeId = Parameter.Odds.OddTypeId
                                                         INNER JOIN
                                                     Language.[Parameter.OddsType] with (nolock)
                                                     ON Parameter.OddsType.OddsTypeId =
                                                        Language.[Parameter.OddsType].OddsTypeId
                                                         INNER JOIN
                                                     Match.Setting with (nolock)
                                                     ON Language.[Parameter.OddsType].OddsTypeId =
                                                        Match.Odd.OddsTypeId AND
                                                        Match.Setting.MatchId = Fixture.MatchId
                                                         INNER JOIN
                                                     Language.[Parameter.Odds] with (nolock)
                                                     ON Parameter.Odds.OddsId = Language.[Parameter.Odds].OddsId AND
                                                        Language.[Parameter.OddsType].LanguageId = @LangId and
                                                        Language.[Parameter.Odds].LanguageId = @LangId --INNER JOIN
                                                --	  Parameter.OddTypeGroupOddType with (nolock) ON Parameter.OddTypeGroupOddType.OddTypeId=Parameter.OddsType.OddsTypeId and  Parameter.OddTypeGroupOddType.OddTypeGroupId=12
                                                WHERE (Match.Odd.StateId = 2)
                                                  and Match.Odd.OddValue > 1
                                                  AND (Parameter.OddsType.IsActive = 1 or Parameter.OddsType.OddsTypeId = 1834)
                                                  and Fixture.SportId in (1, 2, 3, 4, 5, 6, 19, 20, 35)
                                                  and Fixture.MatchDate > GETDATE()
                                                  and Fixture.MatchDate < DATEADD(HOUR, 9, @Endatee)
                                                -- and  cast(Fixture.MatchDate as date)<cast(DATEADD(WEEK,3,GETDATE()) as date)
                                                --Order By RowNumber

                                            end
                end
            else
                if (@CategoryId <> 0 and @TournamentId = 0)
                    begin
                        SELECT ROW_NUMBER() over (PARTITION BY Match.Odd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
                               Match.Odd.OddId,
                               case
                                   when Language.[Parameter.Odds].OutComes is not null
                                       Then Language.[Parameter.Odds].OutComes
                                   else Match.Odd.OutCome end                                                                                    as OutCome,
                               Match.Odd.OddValue,
                               Cache.Fixture.TournamentId,
                               case
                                   when Parameter.Odds.OddsId IN
                                        (1578, 1544, 1648, 1646, 1644, 1642, 2247, 2321, 2325, 2465, 2541, 2543, 3010,
                                         3052, 3079, 3371, 3393)
                                       then CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                   else case
                                            when Match.Odd.OddsTypeId in (1497, 1911, 1493, 1851, 1951, 1864, 1968)
                                                then case
                                                         when cast(Match.Odd.SpecialBetValue AS float) < 0 then '0:' +
                                                                                                                CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                         else ISNULL(Match.Odd.SpecialBetValue, '') + ':0' end
                                            else ISNULL(Match.Odd.SpecialBetValue, '') end end                                                   AS SpecialBetValue,
                               Language.[Parameter.OddsType].OddsType,
                               Parameter.OddsType.OutcomesDescription,
                               Match.Setting.IsPopular,
                               Match.Odd.OddsTypeId                                                                                              as OddTypeId,
                               Match.Setting.MatchId,
                               ISNULL(Parameter.OddsType.SeqNumber, 999)                                                                         as SeqNumber,
                               Language.[Parameter.OddsType].OddsType                                                                            as ShortOddType
                                ,
                               Match.Odd.ParameterOddId
                                ,
                               ISNULL((Select MIN(PODD.OddTypeGroupId)
                                       from Parameter.OddTypeGroupOddType PODD with (nolock)
                                       where PODD.OddTypeId = Match.Odd.OddsTypeId
                                         and PODD.OddTypeGroupId not in (2, 12)),
                                      2)                                                                                                         as OddTypeGroupId
                        FROM Match.Odd with (nolock)
                                 INNER JOIN
                             Parameter.Odds with (nolock) ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
                                 INNER JOIN
                             Cache.Fixture with (nolock) ON Match.Odd.MatchId = Cache.Fixture.MatchId
                                 INNER JOIN
                             Parameter.OddsType with (nolock)
                             ON Parameter.OddsType.OddsTypeId = Parameter.Odds.OddTypeId
                                 INNER JOIN
                             Language.[Parameter.OddsType] with (nolock)
                             ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId
                                 INNER JOIN
                             Match.Setting with (nolock)
                             ON Language.[Parameter.OddsType].OddsTypeId = Match.ODd.OddsTypeId AND
                                Match.Setting.MatchId = Cache.Fixture.MatchId
                                 INNER JOIN
                             Language.[Parameter.Odds] with (nolock)
                             ON Parameter.Odds.OddsId = Language.[Parameter.Odds].OddsId AND
                                Language.[Parameter.OddsType].LanguageId = Language.[Parameter.Odds].LanguageId
                        WHERE (Match.Odd.StateId = 2)
                          and Match.Odd.OddValue > 1
                          AND (Parameter.OddsType.IsActive = 1 or Parameter.OddsType.OddsTypeId = 1834)
                          and (Language.[Parameter.OddsType].LanguageId = @LangId)
                          and Cache.Fixture.SportId = @SportId
                          and Cache.Fixture.TournamentId in (Select TournamentId
                                                             from Parameter.Tournament with (nolock)
                                                             where CategoryId = @CategoryId)
                          and ((CAST(Cache.Fixture.MatchDate AS Date) = (CAST(@EventDate AS Date))))
                          and Cache.Fixture.MatchDate > DATEADD(MINUTE, 10, GETDATE())
                        -- Order By RowNumber -- Match.Odd.SpecialBetValue,Match.Odd.OddId
                    end
                else
                    if (@CategoryId = 0 and @TournamentId <> 0)
                        begin
                            if (@SportId <> -5)
                                begin
                                    SELECT ROW_NUMBER() over (PARTITION BY Match.Odd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
                                           Match.Odd.OddId,
                                           case
                                               when Language.[Parameter.Odds].OutComes is not null
                                                   Then Language.[Parameter.Odds].OutComes
                                               else Match.Odd.OutCome end                                                                                    as OutCome,
                                           Match.Odd.OddValue,
                                           Cache.Fixture.TournamentId,
                                           case
                                               when Parameter.Odds.OddsId IN
                                                    (1578, 1544, 1648, 1646, 1644, 1642, 2247, 2321, 2325, 2465, 2541,
                                                     2543, 3010, 3052, 3079, 3371, 3393)
                                                   then CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                               else case
                                                        when Match.Odd.OddsTypeId in (1497, 1911, 1493, 1851, 1951, 1864, 1968)
                                                            then case
                                                                     when cast(Match.Odd.SpecialBetValue AS float) < 0
                                                                         then '0:' +
                                                                              CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                                     else ISNULL(Match.Odd.SpecialBetValue, '') + ':0' end
                                                        else ISNULL(Match.Odd.SpecialBetValue, '') end end                                                   AS SpecialBetValue,
                                           Language.[Parameter.OddsType].OddsType,
                                           Parameter.OddsType.OutcomesDescription,
                                           Match.Setting.IsPopular,
                                           Match.Odd.OddsTypeId                                                                                              as OddTypeId,
                                           Match.Setting.MatchId,
                                           ISNULL(Parameter.OddsType.SeqNumber, 999)                                                                         as SeqNumber,
                                           Language.[Parameter.OddsType].OddsType                                                                            as ShortOddType
                                            ,
                                           Match.Odd.ParameterOddId
                                            ,
                                           ISNULL((Select MIN(PODD.OddTypeGroupId)
                                                   from Parameter.OddTypeGroupOddType PODD with (nolock)
                                                   where PODD.OddTypeId = Match.Odd.OddsTypeId
                                                     and PODD.OddTypeGroupId not in (2, 12)),
                                                  2)                                                                                                         as OddTypeGroupId
                                    FROM Match.Odd with (nolock)
                                             INNER JOIN
                                         Parameter.Odds with (nolock)
                                         ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
                                             INNER JOIN
                                         Cache.Fixture with (nolock) ON Match.Odd.MatchId = Cache.Fixture.MatchId
                                             INNER JOIN
                                         Parameter.OddsType with (nolock)
                                         ON Parameter.OddsType.OddsTypeId = Parameter.Odds.OddTypeId
                                             INNER JOIN
                                         Language.[Parameter.OddsType] with (nolock)
                                         ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId
                                             INNER JOIN
                                         Match.Setting with (nolock)
                                         ON Language.[Parameter.OddsType].OddsTypeId = Match.Odd.OddsTypeId AND
                                            Match.Setting.MatchId = Cache.Fixture.MatchId
                                             INNER JOIN
                                         Language.[Parameter.Odds] with (nolock)
                                         ON Parameter.Odds.OddsId = Language.[Parameter.Odds].OddsId AND
                                            Language.[Parameter.OddsType].LanguageId =
                                            Language.[Parameter.Odds].LanguageId
                                    WHERE (Match.Odd.StateId = 2)
                                      and Match.Odd.OddValue > 1
                                      AND (Parameter.OddsType.IsActive = 1 or Parameter.OddsType.OddsTypeId = 1834)
                                      and (Language.[Parameter.OddsType].LanguageId = @LangId)
                                      --- and Cache.Fixture.SportId=@SportId
                                      and Cache.Fixture.TournamentId in (select TournamentId
                                                                         from Parameter.Tournament with (nolock)
                                                                         where TerminalTournamentId = @TournamentId)

                                      --and ((CAST(Cache.Fixture.MatchDate AS Date)=(CAST(@EventDate AS Date))))
                                      and Cache.Fixture.MatchDate > DATEADD(MINUTE, 10, GETDATE())
                                    -- Order By RowNumber-- Order By Match.Odd.SpecialBetValue,Match.Odd.OddId
                                end
                            else
                                begin
                                    SELECT ROW_NUMBER() over (PARTITION BY Match.Odd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
                                           Match.Odd.OddId,
                                           case
                                               when Language.[Parameter.Odds].OutComes is not null
                                                   Then Language.[Parameter.Odds].OutComes
                                               else Match.Odd.OutCome end                                                                                    as OutCome,
                                           Match.Odd.OddValue,
                                           Cache.Fixture.TournamentId,
                                           case
                                               when Parameter.Odds.OddsId IN
                                                    (1578, 1544, 1648, 1646, 1644, 1642, 2247, 2321, 2325, 2465, 2541,
                                                     2543, 3010, 3052, 3079, 3371, 3393)
                                                   then CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                               else case
                                                        when Match.Odd.OddsTypeId in (1497, 1911, 1493, 1851, 1951, 1864, 1968)
                                                            then case
                                                                     when cast(Match.Odd.SpecialBetValue AS float) < 0
                                                                         then '0:' +
                                                                              CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                                     else ISNULL(Match.Odd.SpecialBetValue, '') + ':0' end
                                                        else ISNULL(Match.Odd.SpecialBetValue, '') end end                                                   AS SpecialBetValue,
                                           Language.[Parameter.OddsType].OddsType,
                                           Parameter.OddsType.OutcomesDescription,
                                           Match.Setting.IsPopular,
                                           Match.Odd.OddsTypeId                                                                                              as OddTypeId,
                                           Match.Setting.MatchId,
                                           ISNULL(Parameter.OddsType.SeqNumber, 999)                                                                         as SeqNumber,
                                           Language.[Parameter.OddsType].OddsType                                                                            as ShortOddType
                                            ,
                                           Match.Odd.ParameterOddId
                                            ,
                                           ISNULL((Select MIN(PODD.OddTypeGroupId)
                                                   from Parameter.OddTypeGroupOddType PODD with (nolock)
                                                   where PODD.OddTypeId = Match.Odd.OddsTypeId
                                                     and PODD.OddTypeGroupId not in (2, 12)),
                                                  2)                                                                                                         as OddTypeGroupId
                                    FROM Match.Odd with (nolock)
                                             INNER JOIN
                                         Parameter.Odds with (nolock)
                                         ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
                                             INNER JOIN
                                         Cache.Fixture with (nolock) ON Match.Odd.MatchId = Cache.Fixture.MatchId
                                             INNER JOIN
                                         Parameter.OddsType with (nolock)
                                         ON Parameter.OddsType.OddsTypeId = Parameter.Odds.OddTypeId
                                             INNER JOIN
                                         Language.[Parameter.OddsType] with (nolock)
                                         ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId
                                             INNER JOIN
                                         Match.Setting with (nolock)
                                         ON Language.[Parameter.OddsType].OddsTypeId = Match.Odd.OddsTypeId AND
                                            Match.Setting.MatchId = Cache.Fixture.MatchId
                                             INNER JOIN
                                         Language.[Parameter.Odds] with (nolock)
                                         ON Parameter.Odds.OddsId = Language.[Parameter.Odds].OddsId AND
                                            Language.[Parameter.OddsType].LanguageId =
                                            Language.[Parameter.Odds].LanguageId
                                    WHERE (Match.Odd.StateId = 2)
                                      and Match.Odd.OddValue > 1
                                      AND (Parameter.OddsType.IsActive = 1 or Parameter.OddsType.OddsTypeId = 1834)
                                      and (Language.[Parameter.OddsType].LanguageId = @LangId) --- and Cache.Fixture.SportId=@SportId
                                      and Cache.Fixture.TournamentId = @TournamentId

                                      and ((Cache.Fixture.MatchDate <= @EventDate))
                                      and Cache.Fixture.MatchDate > DATEADD(MINUTE, 3, GETDATE())
                                    -- Order By RowNumber-- Order By Match.Odd.SpecialBetValue,Match.Odd.OddId
                                end
                        end
                    else
                        begin
                            SELECT ROW_NUMBER() over (PARTITION BY Match.Odd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
                                   Match.Odd.OddId,
                                   case
                                       when Language.[Parameter.Odds].OutComes is not null
                                           Then Language.[Parameter.Odds].OutComes
                                       else Match.Odd.OutCome end                                                                                    as OutCome,
                                   Match.Odd.OddValue,
                                   Cache.Fixture.TournamentId,
                                   case
                                       when Parameter.Odds.OddsId IN
                                            (1578, 1544, 1648, 1646, 1644, 1642, 2247, 2321, 2325, 2465, 2541, 2543,
                                             3010, 3052, 3079, 3371, 3393)
                                           then CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                       else case
                                                when Match.Odd.OddsTypeId in (1497, 1911, 1493, 1851, 1951, 1864, 1968)
                                                    then case
                                                             when cast(Match.Odd.SpecialBetValue AS float) < 0 then
                                                                 '0:' +
                                                                 CAST(cast(Match.Odd.SpecialBetValue AS float) * -1 AS nvarchar(10))
                                                             else ISNULL(Match.Odd.SpecialBetValue, '') + ':0' end
                                                else ISNULL(Match.Odd.SpecialBetValue, '') end end                                                   AS SpecialBetValue,
                                   Language.[Parameter.OddsType].OddsType,
                                   Parameter.OddsType.OutcomesDescription,
                                   Match.Setting.IsPopular,
                                   Match.Odd.OddsTypeId                                                                                              as OddTypeId,
                                   Match.Setting.MatchId,
                                   ISNULL(Parameter.OddsType.SeqNumber, 999)                                                                         as SeqNumber,
                                   Language.[Parameter.OddsType].OddsType                                                                            as ShortOddType
                                    ,
                                   Match.Odd.ParameterOddId
                                    ,
                                   ISNULL((Select MIN(PODD.OddTypeGroupId)
                                           from Parameter.OddTypeGroupOddType PODD with (nolock)
                                           where PODD.OddTypeId = Match.Odd.OddsTypeId
                                             and PODD.OddTypeGroupId not in (2, 12)),
                                          2)                                                                                                         as OddTypeGroupId
                            FROM Match.Odd with (nolock)
                                     INNER JOIN
                                 Parameter.Odds with (nolock) ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
                                     INNER JOIN
                                 Cache.Fixture with (nolock) ON Match.Odd.MatchId = Cache.Fixture.MatchId
                                     INNER JOIN
                                 Parameter.OddsType with (nolock)
                                 ON Parameter.OddsType.OddsTypeId = Parameter.Odds.OddTypeId
                                     INNER JOIN
                                 Language.[Parameter.OddsType] with (nolock)
                                 ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId
                                     INNER JOIN
                                 Match.Setting with (nolock)
                                 ON Language.[Parameter.OddsType].OddsTypeId = Match.ODd.OddsTypeId AND
                                    Match.Setting.MatchId = Cache.Fixture.MatchId
                                     INNER JOIN
                                 Language.[Parameter.Odds] with (nolock)
                                 ON Parameter.Odds.OddsId = Language.[Parameter.Odds].OddsId AND
                                    Language.[Parameter.OddsType].LanguageId = Language.[Parameter.Odds].LanguageId
                            WHERE (Match.Odd.StateId = 2)
                              and Match.Odd.OddValue > 1
                              AND (Parameter.OddsType.IsActive = 1 or Parameter.OddsType.OddsTypeId = 1834)
                              and (Language.[Parameter.OddsType].LanguageId = @LangId)
                              and Cache.Fixture.SportId in (1, 2, 3, 4, 5, 6, 19, 20, 35)--and Cache.Fixture.SportId=@SportId
                              and ((CAST(Cache.Fixture.MatchDate AS Date) = (CAST(@EventDate AS Date))))
                              and Cache.Fixture.MatchDate > DATEADD(MINUTE, 10, GETDATE())
                            -- Order By RowNumber-- Order By Match.Odd.SpecialBetValue,Match.Odd.OddId
                        end


        end

END
GO
