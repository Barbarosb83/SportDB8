USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchCodeCreate]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Betradar].[ProcMatchCodeCreate]
@BetradarMatchId bigint,
@MatchId bigint,
@BetTypeId int
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Code nvarchar(6) = '';
    DECLARE @TargetBetTypeId int = CASE WHEN @BetTypeId < 2 THEN @BetTypeId ELSE 2 END;
    
    -- Mevcut kodu kontrol et
    IF NOT EXISTS (
        SELECT 1 
        FROM Match.Code WITH (NOLOCK)
        WHERE BetradarMatchId = @BetradarMatchId 
        AND BetTypeId = @TargetBetTypeId
        AND MatchId = @MatchId
    )
    BEGIN
        -- Kullanılmamış kod bul
        SELECT TOP 1 @Code = Code 
        FROM Parameter.MatchCode WITH (NOLOCK, INDEX = IX_MatchCode_IsUsed)
        WHERE IsUsed = 0;
        
        IF @Code != '' AND @Code IS NOT NULL
        BEGIN
            BEGIN TRANSACTION;
            
            -- Kodu kullan
            INSERT Match.Code (BetradarMatchId, MatchId, Code, BetTypeId)
            VALUES (@BetradarMatchId, @MatchId, @Code, @TargetBetTypeId);
            
            -- Kodu işaretle
            UPDATE Parameter.MatchCode WITH (ROWLOCK)
            SET IsUsed = 1 
            WHERE Code = @Code;
            
            COMMIT TRANSACTION;
        END;
    END;
END;



GO
