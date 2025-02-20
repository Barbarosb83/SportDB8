USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Job].[ProcMatchCodeCreate]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Job].[ProcMatchCodeCreate]
 
AS

BEGIN

declare @BetradarMatchId bigint
declare @MatchId bigint
declare @BetTypeId int=0


set nocount on
					declare cur111 cursor local for(
select BetradarMatchId,MatchId from Cache.Fixture where MatchId not in (Select Match.Code.MatchId from Match.Code where BetTypeId=0)
					
						)

					open cur111
					fetch next from cur111 into @BetradarMatchId,@MatchId
					while @@fetch_status=0
						begin
							begin
									exec Betradar.ProcMatchCodeCreate  @BetradarMatchId,@MatchId,@BetTypeId
							end
								fetch next from cur111 into @BetradarMatchId,@MatchId
			
						end
					close cur111
					deallocate cur111	
 


 set nocount on
					declare cur1112 cursor local for(
select BetradarMatchId,EventId from Live.[Event] where EventDate>Getdate() and EventDate<DATEADD(DAY,15,GETDATE()) and EventId not in (Select Match.Code.MatchId from Match.Code where BetTypeId=1)
					
						)

					open cur1112
					fetch next from cur1112 into @BetradarMatchId,@MatchId
					while @@fetch_status=0
						begin
							begin
									exec Betradar.ProcMatchCodeCreate  @BetradarMatchId,@MatchId,1
							end
								fetch next from cur1112 into @BetradarMatchId,@MatchId
			
						end
					close cur1112
					deallocate cur1112	




END


GO
