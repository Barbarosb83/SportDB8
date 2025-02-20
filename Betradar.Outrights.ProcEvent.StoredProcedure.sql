USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Outrights.ProcEvent]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Betradar].[Outrights.ProcEvent]
@EventBetradarId bigint,
@BetradarTournamentId bigint,
@IsActive bit,
@EventDate datetime,
@EventStartDate datetime,
@EventEndDate datetime,
@StageId bigint,
@AAmsOutrightIDs nvarchar(50)
AS

BEGIN

declare @TournamentId int
declare @EventId bigint
declare @CategoryId int=CAST(@AAmsOutrightIDs as int)
--IsActive Hep 0 geliyor
--set @IsActive=1

--insert dbo.betslip values (@EventBetradarId,'OUTEvent-'+cast(@IsActive as nvarchar(10))+'-Category-'+@AAmsOutrightIDs+'BetradarTournament-'+cast(@BetradarTournamentId as nvarchar(20)),GETDATE())
--select @CategoryId=Parameter.Category.CategoryId from Parameter.Category with (nolock)
--		where Parameter.Category.BetradarCategoryId=CAST(@AAmsOutrightIDs as int)


select @TournamentId=Parameter.TournamentOutrights.TournamentId from Parameter.TournamentOutrights with (nolock)  
where Parameter.TournamentOutrights.BetradarTournamentId=@BetradarTournamentId 
and CategoryId=@CategoryId

--if(@TournamentId is null)
--	select @TournamentId=Parameter.TournamentOutrights.TournamentId from Parameter.TournamentOutrights with (nolock)  where Parameter.TournamentOutrights.BetradarTournamentId=@BetradarTournamentId 


if exists (SELECT [EventId] FROM  [Outrights].[Event] with (nolock)  where [EventBetradarId]=@EventBetradarId)
begin
	UPDATE [Outrights].[Event]
			   SET 
			   --[TournamentId] = @TournamentId
				  [EventDate] = @EventDate
				  ,[EventStartDate] = @EventStartDate
				  ,[EventEndDate] = @EventEndDate
				  ,[StageId] = @StageId
				  ,IsActive=@IsActive
			 WHERE [EventBetradarId]=@EventBetradarId

			 SELECT @EventId=[EventId] FROM  [Outrights].[Event] with (nolock)  where [EventBetradarId]=@EventBetradarId
			
end
else
begin
	if(@TournamentId is not null)
	begin
	INSERT INTO [Outrights].[Event]
           ([EventBetradarId]
           ,[TournamentId]
           ,[IsActive]
           ,[EventDate]
           ,[EventStartDate]
           ,[EventEndDate]
           ,[StageId])
     VALUES
           (@EventBetradarId
           ,@TournamentId
           ,@IsActive
           ,@EventDate
           ,@EventStartDate
           ,@EventEndDate
           ,@StageId)

		   	set @EventId=SCOPE_IDENTITY()


	end
end

				if(@EventDate<DATEADD(DAY,20,GETDATE()) and @EventId is not null)
						execute [Betradar].[ProcMatchCodeCreate] @EventBetradarId,@EventId,2

	 	
	
	return @EventId

END


GO
