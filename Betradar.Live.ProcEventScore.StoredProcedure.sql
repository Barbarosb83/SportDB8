USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventScore]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Live.ProcEventScore]
           @BetradarMAtchId bigint,
           @Score nvarchar(15)
		   ,@ScoreTime bigint
          

AS


 --declare @HomeScore int
 --declare @AwayScore int
 -- declare @LastHomeScore int
 --declare @LastAwayScore int

 --declare @LastScore nvarchar(15)
BEGIN 
 declare @BetradarScoreCardId bigint
			--if (@Score is not null and @Score<>'' and @Score<>':')
			--	if exists (SELECT [ScoreId]  FROM [Live].[Score] with (nolock) where [BetradarMatchId]=@BetradarMAtchId)
			--	if not exists(SELECT [ScoreId]  FROM [Live].[Score] with (nolock) where [BetradarMatchId]=@BetradarMAtchId and [Score]=@Score)
			--	begin

			--		select top 1 @LastScore=[Score]  FROM [Live].[Score] with (nolock) where [BetradarMatchId]=@BetradarMAtchId  order by ScoreId desc

			--		INSERT INTO [Live].[Score] 
			--		       ([BetradarMatchId],[Score],ScoreTime)
			--			VALUES (@BetradarMAtchId,@Score,@ScoreTime)

			--			set @BetradarScoreCardId=SCOPE_IDENTITY()

			--			select @LastHomeScore=cast( SUBSTRING(@LastScore,0, CHARINDEX(':', @LastScore)) as int),@LastAwayScore=cast(SUBSTRING(@LastScore,CHARINDEX(':', @LastScore)+1, LEN(@LastScore)) as int)

			--			select @HomeScore=cast( SUBSTRING(@Score,0, CHARINDEX(':', @Score)) as int),@AwayScore=cast(SUBSTRING(@Score,CHARINDEX(':', @Score)+1, LEN(@Score)) as int)
			--			if(@LastHomeScore<>@HomeScore)
			--				exec [Retail].[Live.ProcScoreCardSummary] @BetradarScoreCardId,@BetradarMAtchId,1,1,'',1,0,0,@ScoreTime
			--			else
			--				exec [Retail].[Live.ProcScoreCardSummary] @BetradarScoreCardId,@BetradarMAtchId,1,1,'',2,0,0,@ScoreTime


			--end


END


GO
