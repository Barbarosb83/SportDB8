USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventOdd]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Betradar].[Live.ProcEventOdd]
    @BetradarMatchId bigint,
    @BetradarOddTypeId bigint,
    @BetradarOddSubTypeId bigint,
    @OutCome nvarchar(100),
    @OutComeId int,
    @BetRadarPlayerId bigint,
    @BetradarTeamId bigint,
    @OddValue float,
    @SpecialBetValue nvarchar(100),
    @BettradarOddId bigint,
    @IsActive bit,
    @Combination bigint,
    @ForTheRest nchar(30),
    @Comment nchar(30),
    @MostBalanced bit,
    @Changed bit,
    @BetradarTimeStamp datetime
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Değişken tanımlamaları tek blokta
    DECLARE 
        @BetradarOddSubTypeId2 bigint = ISNULL(@BetradarOddSubTypeId, -1),
        @OddsTypeId int,
        @oddId int,
        @PlayerId int = 0,
        @TeamId int = 0,
        @EventId bigint,
        @parameterOddId int,
        @IsChange int,
        @OddFactor float,
        @eventoddid bigint,
        @IsOddValueLock bit,
        @OldOddValue float,
        @ChangeValue int = 0,
        @newoldvalue float = @OddValue;

    -- OddType kontrolü
    IF NOT EXISTS (
        SELECT 1 
        FROM Live.[Parameter.OddType] WITH (NOLOCK) 
        WHERE BetradarOddsTypeId = @BetradarOddTypeId 
        AND BetradarOddsSubTypeId = @BetradarOddSubTypeId2 
        AND IsActive = 1
    )
    RETURN;

    -- SpecialBetValue düzeltmeleri
    IF @BetradarOddTypeId = 8 AND @BetradarOddSubTypeId IN (32,28,25,18,144,145,1537,140,24,1032,423)
        SET @SpecialBetValue = NULL;

    -- OutCome düzeltmeleri
    IF @BetradarOddTypeId = 7 AND @BetradarOddSubTypeId IN (21,7)
    BEGIN
        SET @OutCome = CASE @OutCome 
            WHEN '1' THEN 'u'
            WHEN '2' THEN 'o'
            ELSE @OutCome
        END;
    END

    -- Mevcut odd kontrolü
    SELECT @eventoddid = OddId
    FROM Live.EventOdd WITH (NOLOCK, INDEX = IX_EventOdd_7)
    WHERE BettradarOddId = @BettradarOddId
    AND BetradarMatchId = @BetradarMatchId
    AND OutCome = @OutCome 
    AND ISNULL(SpecialBetValue,'') = ISNULL(@SpecialBetValue,'');

    -- Update veya Insert işlemi
    IF @eventoddid IS NOT NULL
    BEGIN
        UPDATE Live.EventOdd WITH (ROWLOCK)
        SET OddValue = @OddValue,
            IsActive = CASE WHEN @OddValue <= 1.01 THEN 0 ELSE @IsActive END,
            BetradarTimeStamp = @BetradarTimeStamp,
            UpdatedDate = GETDATE(),
            BetradarPlayerId = CASE WHEN @BetradarMatchId < 0 THEN @BetradarTeamId ELSE BetradarPlayerId END,
            OddFactor = @ForTheRest,
            GenuisId = CASE WHEN @BetradarMatchId < 0 THEN @BetRadarPlayerId ELSE GenuisId END
        WHERE OddId = @eventoddid
        AND BetradarTimeStamp < @BetradarTimeStamp;
    END
    ELSE
    BEGIN
        -- OddsTypeId belirleme
        SELECT @OddsTypeId = OddTypeId 
        FROM Live.[Parameter.OddType] WITH (NOLOCK)
        WHERE BetradarOddsTypeId = @BetradarOddTypeId
        AND (@BetradarOddSubTypeId IS NULL OR BetradarOddsSubTypeId = @BetradarOddSubTypeId2);

        -- ParameterOddId belirleme
        SELECT @parameterOddId = OddsId 
        FROM Live.[Parameter.Odds] WITH (NOLOCK)
        WHERE OddTypeId = @OddsTypeId 
        AND Outcomes = @OutCome;

        IF @parameterOddId IS NULL
            SELECT TOP 1 @parameterOddId = OddsId 
            FROM Live.[Parameter.Odds] WITH (NOLOCK)
            WHERE OddTypeId = @OddsTypeId;

        -- Insert işlemi
        IF @BetradarMatchId IS NOT NULL AND @OddsTypeId IS NOT NULL
        BEGIN
            INSERT INTO Live.EventOdd (
                OddId, OddsTypeId, OutCome, SpecialBetValue, 
                OddValue, MatchId, BettradarOddId, Suggestion,
                ParameterOddId, IsOddValueLock, IsChanged, IsActive,
                BetradarTimeStamp, BetradarMatchId, BetradarOddsTypeId,
                BetradarOddsSubTypeId, StateId, BetradarPlayerId, 
                OddFactor, GenuisId
            )
            VALUES (
                @BettradarOddId, @OddsTypeId, @OutCome, ISNULL(@SpecialBetValue,''),
                @OddValue, @BetradarMatchId, @BettradarOddId, @OddValue,
                @parameterOddId, 0, 0, 
                CASE WHEN @OddValue <= 1.01 THEN 0 ELSE @IsActive END,
                @BetradarTimeStamp, @BetradarMatchId, @BetradarOddTypeId,
                @BetradarOddSubTypeId2, 2, @BetradarTeamId,
                @ForTheRest, 
                CASE WHEN @BetradarMatchId < 0 THEN @BetRadarPlayerId ELSE NULL END
            );

            SET @eventoddid = @BettradarOddId;
            
            EXEC [Betradar].[Live.ProcOddSettingInsert] 
                @OddsTypeId, @eventoddid, @BetradarMatchId, @BetradarMatchId;
        END
    END
END
GO
