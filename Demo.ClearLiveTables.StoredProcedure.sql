USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Demo].[ClearLiveTables]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Demo].[ClearLiveTables] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	truncate table Live.EventCoverageInfo
	truncate table Live.EventDetail
	truncate table Live.EventExtraInfo
	truncate table Live.EventOdd
	truncate table Live.EventOddTypeSetting
	truncate table Live.EventSetting
	truncate table Live.EventOddSetting
	truncate table Live.EventStreamingChannel
	truncate table Live.EventTopOdd
	truncate table Live.EventTvChannel
	truncate table Live.ScoreCardSummary
	truncate table Live.[Event]
		truncate table Live.EventOddSetting
		truncate table Live.EventOddTypeSetting
		
	truncate table Archive.[Live.Event]
	truncate table Archive.[Live.EventDetail]
	truncate table Archive.[Live.EventOdd]
	truncate table Archive.[Live.EventOddSetting]
	truncate table Archive.[Live.EventOddTypeSetting]
	truncate table Archive.[Live.EventSetting]
	truncate table Archive.[Live.ScoreCardSummary]


	--delete from Live.EventCoverageInfo
	--delete from Live.EventDetail
	--delete from Live.EventExtraInfo
	--delete from Live.EventOdd
	--delete from Live.EventOddTypeSetting
	--delete from Live.EventSetting
	--delete from Live.EventOddSetting
	--delete from Live.EventStreamingChannel
	--delete from Live.EventTopOdd
	--delete from Live.EventTvChannel
	--delete from Live.ScoreCardSummary
	--delete from Live.[Event]
	--	delete from Live.EventOddSetting
	--	delete from Live.EventOddTypeSetting
		
	--delete from Archive.[Live.Event]
	--delete from Archive.[Live.EventDetail]
	--delete from Archive.[Live.EventOdd]
	--delete from Archive.[Live.EventOddSetting]
	--delete from Archive.[Live.EventOddTypeSetting]
	--delete from Archive.[Live.EventSetting]
	--delete from Archive.[Live.ScoreCardSummary]


		
END


GO
