USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Cache].[FillSports]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Cache].[FillSports]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @temptable  table (SportId int,EventCount int,  EndDay int)
    
    insert @temptable exec [Cache].[FillSportsbyDay] 7

	insert @temptable exec [Cache].[FillSportsbyDay] 4
		
	insert @temptable exec [Cache].[FillSportsbyDay] 2
		
	insert @temptable exec [Cache].[FillSportsbyDay] 1
    
    truncate table Cache.Sport
    
    insert Cache.Sport ([SportId]
           ,[EventCount]
           ,[EndDay]) 
    select SportId ,EventCount ,  EndDay
    from @temptable
    order by SportId
END


GO
