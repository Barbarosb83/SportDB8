CREATE PROCEDURE [Live].[GamePlatform.ProcFixtureTerminal] @LangId int,
                                                           @SportId int
AS
BEGIN
    SET NOCOUNT ON;

    -- Optimize edilmiş geçici tablo yapısı
    CREATE TABLE #tEventDetail
    (
        [EventDetailId]      [bigint]        NOT NULL,
        [EventId]            [bigint]        NOT NULL,
        [IsActive]           [bit]           NULL,
        [EventStatu]         [int]           NULL,
        [BetStatus]          [int]           NULL,
        [LegScore]           [nvarchar](100) NULL,
        [MatchTime]          [bigint]        NULL,
        [MatchTimeExtended]  [nchar](15)     NULL,
        [Score]              [nchar](15)     NULL,
        [TimeStatu]          [int]           NULL,
        BetradarMatchIds     bigint          NOT NULL,
        TournamentName       nvarchar(200),
        CategoryName         nvarchar(200),
        SportName            nvarchar(150),
        SportNameOriginal    nvarchar(150),
        SportIcon            nvarchar(250),
        SportIconColor       nvarchar(100),
        HomeTeam             nvarchar(150),
        AwayTeam             nvarchar(150),
        EventDate            datetime,
        StatuColor           int,
        TimeStatuColor       nvarchar(50),
        HasStreaming         bit,
        SportId              int,
        SequenceNumber       int,
        TournamentId         int,
        BetReasonId          int,
        BetReason            nvarchar(250),
        MatchServer          int,
        Code                 nvarchar(20),
        IsoCode              nvarchar(3),
        RedCardTeam1         int,
        RedCardTeam2         int,
        HomeTeamId           bigint,
        AwayTeamId           bigint,
        BetradarTournamentId bigint,
        CategoryId           bigint,
        PRIMARY KEY CLUSTERED (EventId)
    )
    WITH (DATA_COMPRESSION = PAGE);

    -- Ortak WHERE koşulları için değişken
    DECLARE @CurrentTimeMinus30Sec datetime = DATEADD(SECOND, -30, GETDATE());
    DECLARE @CurrentTimeMinus25Min datetime = DATEADD(MINUTE, -25, GETDATE());

    -- Ana sorgu
    IF (@SportId = 0)
    BEGIN
        INSERT INTO #tEventDetail
        SELECT DISTINCT 
            ED.[EventDetailId],
            ED.[EventId],
            ED.[IsActive],
            ED.[EventStatu],
            ED.[BetStatus],
            ED.[LegScore],
            ED.[MatchTime],
            ED.[MatchTimeExtended],
            ED.[Score],
            ED.[TimeStatu],
            ED.BetradarMatchIds,
            LPT.TournamentName,
            LPC.CategoryName,
            LPS.SportName,
            PS.SportName AS SportNameOriginal,
            PS.Icon AS SportIcon,
            PS.IconColor AS SportIconColor,
            LPC1.CompetitorName AS HomeTeam,
            LPC2.CompetitorName AS AwayTeam,
            E.EventDate,
            LPTS.StatuColor,
            LPLTS.TimeStatu AS TimeStatuColor,
            CAST(0 AS bit) AS HasStreaming,
            PS.SportId,
            ISNULL(PT.SequenceNumber, 999) as SequenceNumber,
            PT.TournamentId,
            LPLBSR.ParameterReasonId,
            LPLBSR.ReasonT,
            ED.MatchServer,
            '' as Code,
            LOWER(PI.IsoName2),
            ISNULL(ED.RedCardsTeam1, 0) + ISNULL(ED.YellowRedCardsTeam1, 0),
            ISNULL(ED.RedCardsTeam2, 0) + ISNULL(ED.YellowRedCardsTeam2, 0),
            CASE WHEN PC1.BetradarSuperId < 0 THEN PC1.LSId ELSE PC1.BetradarSuperId END as HomeTeamId,
            CASE WHEN PC2.BetradarSuperId < 0 THEN PC2.LSId ELSE PC2.BetradarSuperId END as AwayTeamId,
            PT.NewBetradarId,
            PC.CategoryId
        FROM Live.EventDetail ED WITH (NOLOCK)
        INNER JOIN Live.Event E WITH (NOLOCK) ON E.EventId = ED.EventId
        INNER JOIN Live.EventSetting ES WITH (NOLOCK) ON ES.MatchId = E.EventId
        INNER JOIN Live.EventTopOdd ETO WITH (NOLOCK) ON ETO.EventId = E.EventId
        INNER JOIN Parameter.Tournament PT WITH (NOLOCK) ON E.TournamentId = PT.TournamentId
        INNER JOIN Parameter.Category PC WITH (NOLOCK) ON PT.CategoryId = PC.CategoryId
        INNER JOIN Parameter.Sport PS WITH (NOLOCK) ON PC.SportId = PS.SportId
        INNER JOIN Parameter.Competitor PC1 WITH (NOLOCK) ON E.HomeTeam = PC1.CompetitorId
        INNER JOIN Parameter.Competitor PC2 WITH (NOLOCK) ON E.AwayTeam = PC2.CompetitorId
        INNER JOIN Parameter.Iso PI WITH (NOLOCK) ON PI.IsoId = PC.IsoId
        INNER JOIN Language.[Parameter.Tournament] LPT WITH (NOLOCK) ON PT.TournamentId = LPT.TournamentId AND LPT.LanguageId = @LangId
        INNER JOIN Language.[Parameter.Sport] LPS WITH (NOLOCK) ON PS.SportId = LPS.SportId AND LPS.LanguageId = @LangId
        INNER JOIN Language.[Parameter.Category] LPC WITH (NOLOCK) ON PC.CategoryId = LPC.CategoryId AND LPC.LanguageId = @LangId
        INNER JOIN Language.ParameterCompetitor LPC1 WITH (NOLOCK) ON PC1.CompetitorId = LPC1.CompetitorId AND LPC1.LanguageId = @LangId
        INNER JOIN Language.ParameterCompetitor LPC2 WITH (NOLOCK) ON PC2.CompetitorId = LPC2.CompetitorId AND LPC2.LanguageId = @LangId
        INNER JOIN Live.[Parameter.TimeStatu] LPTS WITH (NOLOCK) ON ED.TimeStatu = LPTS.TimeStatuId
        INNER JOIN Language.[Parameter.LiveTimeStatu] LPLTS WITH (NOLOCK) ON LPTS.TimeStatuId = LPLTS.ParameterTimeStatuId AND LPLTS.LanguageId = @LangId
        LEFT JOIN Language.[Parameter.LiveBetStopReason] LPLBSR WITH (NOLOCK) ON ISNULL(ED.BetStopReasonId,0) = LPLBSR.ParameterReasonId AND LPLBSR.LanguageId = @LangId
        WHERE ED.Bases = 2
        AND ED.BetradarTimeStamp > @CurrentTimeMinus25Min
        AND EXISTS (SELECT 1 FROM Live.EventOdd WHERE MatchId = E.EventId)
        AND ES.StateId = 2
        AND (
            (ED.IsActive = 1 AND ED.TimeStatu NOT IN (0,1,5,14,15,27,84,21,22,23,24,25,26,11,86,83))
            OR (ED.IsActive = 1 AND ED.TimeStatu = 1 AND E.ConnectionStatu = 2 AND ED.BetStatus = 2 AND ED.Bases = 2)
            OR (ED.TimeStatu = 5 AND ED.BetradarTimeStamp > @CurrentTimeMinus30Sec)
        );

    END
    ELSE 
    BEGIN
         INSERT INTO #tEventDetail
        SELECT DISTINCT 
            ED.[EventDetailId],
            ED.[EventId],
            ED.[IsActive],
            ED.[EventStatu],
            ED.[BetStatus],
            ED.[LegScore],
            ED.[MatchTime],
            ED.[MatchTimeExtended],
            ED.[Score],
            ED.[TimeStatu],
            ED.BetradarMatchIds,
            LPT.TournamentName,
            LPC.CategoryName,
            LPS.SportName,
            PS.SportName AS SportNameOriginal,
            PS.Icon AS SportIcon,
            PS.IconColor AS SportIconColor,
            LPC1.CompetitorName AS HomeTeam,
            LPC2.CompetitorName AS AwayTeam,
            E.EventDate,
            LPTS.StatuColor,
            LPLTS.TimeStatu AS TimeStatuColor,
            CAST(0 AS bit) AS HasStreaming,
            PS.SportId,
            ISNULL(PT.SequenceNumber, 999) as SequenceNumber,
            PT.TournamentId,
            LPLBSR.ParameterReasonId,
            LPLBSR.ReasonT,
            ED.MatchServer,
            '' as Code,
            LOWER(PI.IsoName2),
            ISNULL(ED.RedCardsTeam1, 0) + ISNULL(ED.YellowRedCardsTeam1, 0),
            ISNULL(ED.RedCardsTeam2, 0) + ISNULL(ED.YellowRedCardsTeam2, 0),
            CASE WHEN PC1.BetradarSuperId < 0 THEN PC1.LSId ELSE PC1.BetradarSuperId END as HomeTeamId,
            CASE WHEN PC2.BetradarSuperId < 0 THEN PC2.LSId ELSE PC2.BetradarSuperId END as AwayTeamId,
            PT.NewBetradarId,
            PC.CategoryId
        FROM Live.EventDetail ED WITH (NOLOCK)
        INNER JOIN Live.Event E WITH (NOLOCK) ON E.EventId = ED.EventId
        INNER JOIN Live.EventSetting ES WITH (NOLOCK) ON ES.MatchId = E.EventId
        INNER JOIN Live.EventTopOdd ETO WITH (NOLOCK) ON ETO.EventId = E.EventId
        INNER JOIN Parameter.Tournament PT WITH (NOLOCK) ON E.TournamentId = PT.TournamentId
        INNER JOIN Parameter.Category PC WITH (NOLOCK) ON PT.CategoryId = PC.CategoryId
        INNER JOIN Parameter.Sport PS WITH (NOLOCK) ON PC.SportId = PS.SportId
        INNER JOIN Parameter.Competitor PC1 WITH (NOLOCK) ON E.HomeTeam = PC1.CompetitorId
        INNER JOIN Parameter.Competitor PC2 WITH (NOLOCK) ON E.AwayTeam = PC2.CompetitorId
        INNER JOIN Parameter.Iso PI WITH (NOLOCK) ON PI.IsoId = PC.IsoId
        INNER JOIN Language.[Parameter.Tournament] LPT WITH (NOLOCK) ON PT.TournamentId = LPT.TournamentId AND LPT.LanguageId = @LangId
        INNER JOIN Language.[Parameter.Sport] LPS WITH (NOLOCK) ON PS.SportId = LPS.SportId AND LPS.LanguageId = @LangId
        INNER JOIN Language.[Parameter.Category] LPC WITH (NOLOCK) ON PC.CategoryId = LPC.CategoryId AND LPC.LanguageId = @LangId
        INNER JOIN Language.ParameterCompetitor LPC1 WITH (NOLOCK) ON PC1.CompetitorId = LPC1.CompetitorId AND LPC1.LanguageId = @LangId
        INNER JOIN Language.ParameterCompetitor LPC2 WITH (NOLOCK) ON PC2.CompetitorId = LPC2.CompetitorId AND LPC2.LanguageId = @LangId
        INNER JOIN Live.[Parameter.TimeStatu] LPTS WITH (NOLOCK) ON ED.TimeStatu = LPTS.TimeStatuId
        INNER JOIN Language.[Parameter.LiveTimeStatu] LPLTS WITH (NOLOCK) ON LPTS.TimeStatuId = LPLTS.ParameterTimeStatuId AND LPLTS.LanguageId = @LangId
        LEFT JOIN Language.[Parameter.LiveBetStopReason] LPLBSR WITH (NOLOCK) ON ISNULL(ED.BetStopReasonId,0) = LPLBSR.ParameterReasonId AND LPLBSR.LanguageId = @LangId
        WHERE ED.Bases = 2
        AND ED.BetradarTimeStamp > @CurrentTimeMinus25Min
        AND EXISTS (SELECT 1 FROM Live.EventOdd WHERE MatchId = E.EventId)
        AND ES.StateId = 2
        AND (
            (ED.IsActive = 1 AND ED.TimeStatu NOT IN (0,1,5,14,15,27,84,21,22,23,24,25,26,11,86,83))
            OR (ED.IsActive = 1 AND ED.TimeStatu = 1 AND E.ConnectionStatu = 2 AND ED.BetStatus = 2 AND ED.Bases = 2)
            OR (ED.TimeStatu = 5 AND ED.BetradarTimeStamp > @CurrentTimeMinus30Sec)
        )   and LPS.SportId = @SportId;
    END

    -- Final select
    SELECT 
        EventId,
        TournamentName,
        CategoryName,
        SportName,
        SportNameOriginal,
        SportIcon,
        SportIconColor,
        HomeTeam,
        AwayTeam,
        EventDate,
        IsActive,
        EventStatu,
        BetStatus,
        CASE 
            WHEN BetradarMatchIds > 0 AND SportId = 1 AND TimeStatu = 2 AND MatchTime > 45 THEN CAST(45 AS bigint)
            WHEN SportId = 1 AND TimeStatu = 4 AND MatchTime > 90 THEN CAST(90 AS bigint)
            WHEN TimeStatu = 3 THEN NULL
            WHEN SportId IN (5,20,18) THEN NULL
            ELSE MatchTime 
        END AS MatchTime,
        CASE 
            WHEN BetradarMatchIds > 0 AND SportId = 1 AND TimeStatu = 2 AND MatchTime > 45 THEN '45+' + MatchTimeExtended
            WHEN BetradarMatchIds > 0 AND SportId = 1 AND TimeStatu = 4 AND MatchTime > 90 THEN '90+' + MatchTimeExtended
            ELSE NULL
        END AS MatchTimeExtended,
        Score,
        TimeStatu,
        StatuColor,
        TimeStatuColor,
        (
            SELECT COUNT(DISTINCT EO.OddsTypeId)
            FROM Live.EventOdd EO WITH (NOLOCK)
            INNER JOIN Live.[Parameter.OddType] POT WITH (NOLOCK) ON EO.OddsTypeId = POT.OddTypeId
            INNER JOIN [Live].[Parameter.OddTypeGroupOddType] POTGO WITH (NOLOCK) ON POTGO.OddTypeId = EO.OddsTypeId
            WHERE EO.MatchId = ED.EventId
            AND EO.IsActive = 1
            AND POT.IsActive = 1
            AND POTGO.OddTypeGroupId = 12
        ) AS ExtraOddCount,
        BetStatus,
        HasStreaming,
        LegScore AS GameScore,
        TournamentId,
        BetReasonId,
        BetReason,
        SequenceNumber,
        MatchServer,
        Code,
        IsoCode,
        BetradarMatchIds AS BetradarMatchId,
        RedCardTeam1,
        RedCardTeam2,
        HomeTeamId,
        AwayTeamId,
        BetradarTournamentId,
        CategoryId
    FROM #tEventDetail ED
   
    ORDER BY SportId, SequenceNumber;



	DROP TABLE #tEventDetail;

END
