USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Lsports].[ProcTournament]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Lsports].[ProcTournament]
@LsTournamentId bigint,
@LsLocationId bigint,
@LsSportId bigint,
@TournamentName nvarchar(max)
AS

Declare @TournamentId int=0
Declare @ParameterLangId int=0
declare @IsoId int=0
declare @CategoryId int=0
declare @LanId int=0
declare @SportId int=0

BEGIN

Select @SportId=Parameter.Sport.SportId from Parameter.Sport where Parameter.Sport.LSId=@LsSportId

Select @CategoryId=Parameter.Category.CategoryId from Parameter.Category where Parameter.Category.LSId=@LsLocationId and Parameter.Category.SportId=@SportId

declare @counttournament int=0

select @counttournament=count(Parameter.Tournament.TournamentId) from
Parameter.Tournament
where Parameter.Tournament.CategoryId=@CategoryId and Parameter.Tournament.TournamentName=@TournamentName

if @counttournament=1
begin
	Update Parameter.Tournament set Parameter.Tournament.LSId=@LsTournamentId 
	where Parameter.Tournament.CategoryId=@CategoryId and Parameter.Tournament.TournamentName=@TournamentName
end

END




GO
