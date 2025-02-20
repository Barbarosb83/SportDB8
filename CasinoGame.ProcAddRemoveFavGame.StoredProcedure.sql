USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [CasinoGame].[ProcAddRemoveFavGame]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CasinoGame].[ProcAddRemoveFavGame]
@CustomerId bigint,
@GameId bigint,
@ActionType int --1 insert, 2 Delete

AS


BEGIN
SET NOCOUNT ON;
 


 if(@ActionType=1)
		INSERT INTO [CasinoGame].[FavGames]
           ([CustomerId]
           ,[GameId])
     VALUES (@CustomerId,@GameId)
else if (@ActionType=2)
	delete from  [CasinoGame].[FavGames] where CustomerId=@CustomerId and GameId=@GameId

	return 1

END

GO
