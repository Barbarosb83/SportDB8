USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventOddNoOutCome]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Betradar].[Live.ProcEventOddNoOutCome]
    @BetradarMatchId bigint,
    @SpecialBetValue nvarchar(50),
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
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    
    -- SpecialBetValue kontrolü
    IF CHARINDEX('sr:', @SpecialBetValue) > 0
        SET @SpecialBetValue = NULL;

    -- Update işlemi
    UPDATE EO WITH (ROWLOCK)
    SET IsActive = @IsActive,
        BetradarTimeStamp = @BetradarTimeStamp,
        UpdatedDate = GETDATE()
    FROM Live.EventOdd EO WITH (INDEX = IX_EventOdd_NoOutcome_Optimized)
    WHERE BetradarPlayerId = @BettradarOddId
    AND BetradarMatchId = @BetradarMatchId
    AND (@SpecialBetValue IS NULL OR EO.SpecialBetValue = @SpecialBetValue)
    OPTION (OPTIMIZE FOR UNKNOWN, MAXDOP 1);
END



GO
