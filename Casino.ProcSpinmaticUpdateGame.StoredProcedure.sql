USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcSpinmaticUpdateGame]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Casino].[ProcSpinmaticUpdateGame]
@Id bigint,
@Name nvarchar(150),
@FriendlyName nvarchar(150)


AS


BEGIN
SET NOCOUNT ON;

declare @result bigint=-1


if exists (Select Casino.[Spinmatic.Game].GameId from Casino.[Spinmatic.Game] where Casino.[Spinmatic.Game].GameId=@Id)
	begin
		
		
		
		update Casino.[Spinmatic.Game] set 
		Name=@Name,FriendlyName=@FriendlyName
		where GameId=@Id
	
	end
else
	begin
		insert Casino.[Spinmatic.Game](GameId,Name,FriendlyName,IsPopular,IsEnable)
		values (@Id,@Name,@FriendlyName,1,1)
		
	end

	select @result
END

GO
