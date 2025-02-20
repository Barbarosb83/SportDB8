USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Demo].[ClearPreMatchTables]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Demo].[ClearPreMatchTables] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
   truncate table Customer.SlipOdd
      truncate table Customer.[Transaction]
delete Customer.Slip
truncate table Match.FixtureCompetitor
truncate table Match.Setting
truncate table Match.OddSetting
truncate table Match.OddTypeSetting
truncate table Match.Card
truncate table Match.Corner
truncate table Match.Goal
truncate table Match.Information
truncate table Match.Odd
truncate table Match.OddsResult
truncate table Match.Probability
truncate table Match.ScoreComment
truncate table Match.ScoreInfo
truncate table Match.TVChannel
truncate table Match.FixtureDateInfo
truncate table Match.FixtureCompetitor
delete Match.Fixture
delete Match.Match
truncate table Archive.Card
truncate table Archive.Corner
truncate table Archive.Fixture
truncate table Archive.FixtureCompetitor
truncate table Archive.FixtureDateInfo
truncate table Archive.Goal
truncate table Archive.Information
truncate table Archive.Match
truncate table Archive.Odd
truncate table Archive.OddSetting
truncate table Archive.OddsResult
truncate table Archive.OddTypeSetting
truncate table Archive.Probability
truncate table Archive.ScoreComment
truncate table Archive.ScoreInfo
truncate table Archive.Setting
truncate table Archive.TVChannel
truncate table Log.ErrorLog
truncate table Log.TransactionLog
    

END


GO
