USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Archive].[ProcMatch]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
   CREATE PROCEDURE[Archive].[ProcMatch]


AS
 

 BEGIN


declare @TempTable table (MatchId bigint,FixtureId bigint)





insert @TempTable
SELECT     Match.Match.MatchId, Match.Fixture.FixtureId
FROM         Match.Fixture with (nolock) INNER JOIN
                      Match.FixtureDateInfo with (nolock) ON Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId INNER JOIN
                      Match.Match ON Match.Fixture.MatchId = Match.Match.MatchId
where Match.FixtureDateInfo.MatchDate<GETDATE() 
 
  



delete Match.TVChannel where Match.TVChannel.MatchId in (select MatchId from @TempTable)

delete Match.DoublePlayer where Match.DoublePlayer.MatchId in (select MatchId from @TempTable)

delete    Match.Setting where Match.Setting.MatchId in (select MatchId from @TempTable)

delete    Match.Probability where Match.Probability.MatchId in (select MatchId from @TempTable)

delete    Match.OddTypeSetting where Match.OddTypeSetting.MatchId in (select MatchId from @TempTable)

delete Match.Code where Match.Code.MatchId in (select MatchId from @TempTable) and BetTypeId=0


DELETE   FROM            Match.Score WHERE CAST(MatchDate AS date)<CAST(DATEADD(DAY,-2,GETDATE()) AS date)



delete    Match.Odd where Match.Odd.MatchId in (select MatchId from @TempTable)

delete     Match.Information where Match.Information.MatchId in (select MatchId from @TempTable)


delete    Match.FixtureDateInfo where Match.FixtureDateInfo.FixtureId in (select FixtureId from @TempTable)

delete     Match.FixtureCompetitor where Match.FixtureCompetitor.FixtureId in (select FixtureId from @TempTable)


delete   Match.Fixture where Match.Fixture.FixtureId in (select FixtureId from @TempTable)


delete  from     Match.Match where Match.Match.MatchId in (select MatchId from @TempTable)

 

delete from  Match.OddsResult  
WHERE   IsEvoluate=1





delete from Match.Odd where MatchId not in (Select MM.MatchId from Match.Match MM )

delete from Match.OddsResult where MatchId not in (Select MM.MatchId from Match.Match MM )

delete from Match.OddTypeSetting where MatchId not in (Select MM.MatchId from Match.Match MM )

delete from Match.Setting where MatchId not in (Select MM.MatchId from Match.Match MM )

delete from Match.Fixture where MatchId not in (Select MM.MatchId from Match.Match MM)


delete   from Match.Code where BetTypeId=0 and MatchId not in (Select MM.MatchId from Match.Match MM)


delete  from Match.Goal where   MatchId not in (Select MM.MatchId from Match.Match MM)


delete from Match.FixtureCompetitor 
where FixtureId not in (Select MF.FixtureId from Match.Match MM inner join Match.Fixture MF ON MF.MatchId=MM.MatchId)


delete from Match.FixtureDateInfo  
where FixtureId not in (Select MF.FixtureId from Match.Match MM inner join Match.Fixture MF ON MF.MatchId=MM.MatchId)




ALTER INDEX [BB_FX] ON [Match].[Fixture] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON (WAIT_AT_LOW_PRIORITY (MAX_DURATION = 0 MINUTES, ABORT_AFTER_WAIT = NONE)), ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_FixtureCompetitor] ON [Match].[FixtureCompetitor] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON (WAIT_AT_LOW_PRIORITY (MAX_DURATION = 0 MINUTES, ABORT_AFTER_WAIT = NONE)), ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_FixtureCompetitor_2] ON [Match].[FixtureCompetitor] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON (WAIT_AT_LOW_PRIORITY (MAX_DURATION = 0 MINUTES, ABORT_AFTER_WAIT = NONE)), ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_FixtureDateInfo_1] ON [Match].[FixtureDateInfo] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, IGNORE_DUP_KEY = OFF, ONLINE = ON (WAIT_AT_LOW_PRIORITY (MAX_DURATION = 0 MINUTES, ABORT_AFTER_WAIT = NONE)), ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_FixtureDateInfo_2] ON [Match].[FixtureDateInfo] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, IGNORE_DUP_KEY = OFF, ONLINE = ON (WAIT_AT_LOW_PRIORITY (MAX_DURATION = 0 MINUTES, ABORT_AFTER_WAIT = NONE)), ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_Match] ON [Match].[Match] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON (WAIT_AT_LOW_PRIORITY (MAX_DURATION = 0 MINUTES, ABORT_AFTER_WAIT = NONE)), ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_Match_2] ON [Match].[Match] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON (WAIT_AT_LOW_PRIORITY (MAX_DURATION = 0 MINUTES, ABORT_AFTER_WAIT = NONE)), ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [BB_INDEX1] ON [Match].[Odd] REBUILD PARTITION = ALL WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_BBM] ON [Match].[Odd] REBUILD PARTITION = ALL WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_Odd_10] ON [Match].[Odd] REBUILD PARTITION = ALL WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_Odd_11] ON [Match].[Odd] REBUILD PARTITION = ALL WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)



ALTER INDEX [IX_Odd_13] ON [Match].[Odd] REBUILD PARTITION = ALL WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_Odd_2] ON [Match].[Odd] REBUILD PARTITION = ALL WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_Odd_3] ON [Match].[Odd] REBUILD PARTITION = ALL WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_Odd_4] ON [Match].[Odd] REBUILD PARTITION = ALL WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_Odd_7] ON [Match].[Odd] REBUILD PARTITION = ALL WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_Odd_9] ON [Match].[Odd] REBUILD PARTITION = ALL WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_Odd_BB1] ON [Match].[Odd] REBUILD PARTITION = ALL WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_Odd_BB2] ON [Match].[Odd] REBUILD PARTITION = ALL WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_BBO] ON [Match].[OddTypeSetting] REBUILD PARTITION = ALL WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_OddTypeSetting_2] ON [Match].[OddTypeSetting] REBUILD PARTITION = ALL WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_OddTypeSetting_5] ON [Match].[OddTypeSetting] REBUILD PARTITION = ALL WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_OddTypeSetting_6] ON [Match].[OddTypeSetting] REBUILD PARTITION = ALL WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_Setting_1] ON [Match].[Setting] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON (WAIT_AT_LOW_PRIORITY (MAX_DURATION = 0 MINUTES, ABORT_AFTER_WAIT = NONE)), ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_Setting_2] ON [Match].[Setting] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON (WAIT_AT_LOW_PRIORITY (MAX_DURATION = 0 MINUTES, ABORT_AFTER_WAIT = NONE)), ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_Setting_3] ON [Match].[Setting] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON (WAIT_AT_LOW_PRIORITY (MAX_DURATION = 0 MINUTES, ABORT_AFTER_WAIT = NONE)), ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_BBMC] ON [Match].[Code] REBUILD PARTITION = ALL WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_Code_1] ON [Match].[Code] REBUILD PARTITION = ALL WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_Code_2] ON [Match].[Code] REBUILD PARTITION = ALL WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)

ALTER INDEX [IX_Code_3] ON [Match].[Code] REBUILD PARTITION = ALL WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)



END
GO
