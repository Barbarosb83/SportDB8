USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Lsports].[ProcMatchFixtureCompetitor]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Lsports].[ProcMatchFixtureCompetitor]
@FixtureId bigint,
@LsCompetitorId bigint,
@CompetitorName nvarchar(250),
@Type int,
@Language nvarchar(10)
AS


declare @compId int=0
declare @lanId int=0

select @lanId=Language.Language.LanguageId from Language.Language where Language.Language.Language=@Language

BEGIN

	if exists (select Parameter.Competitor.CompetitorId from Parameter.Competitor with (nolock) where Parameter.Competitor.LSId=@LsCompetitorId)
			begin
				select top 1 @compId=Parameter.Competitor.CompetitorId from Parameter.Competitor with (nolock) where Parameter.Competitor.LSId=@LsCompetitorId

			end
	Else
		begin

			update Parameter.Competitor set LSId=@LsCompetitorId where Parameter.Competitor.CompetitorName=@CompetitorName

			select top 1 @compId=Parameter.Competitor.CompetitorId from Parameter.Competitor with (nolock) where Parameter.Competitor.LSId=@LsCompetitorId

			if @compId is null or @compId=0
			begin

				insert Parameter.Competitor(BetradarSuperId,CompetitorName,LSId)
				values (@LsCompetitorId,Replace(@CompetitorName,'-',' '),@LsCompetitorId)
			
				set @compId=SCOPE_IDENTITY()
			
						insert Language.ParameterCompetitor(CompetitorId,LanguageId,CompetitorName) --values (@compId,@lanId,@CompetitorName)
					select @compId,Language.Language.LanguageId,Replace(@CompetitorName,'-',' ') from Language.Language
			end
			
		end
		
		
		if not exists (select Language.ParameterCompetitor.CompetitorId from Language.ParameterCompetitor with (nolock) where Language.ParameterCompetitor.CompetitorId=@compId and Language.ParameterCompetitor.LanguageId=@lanId)
			begin
				insert Language.ParameterCompetitor(CompetitorId,LanguageId,CompetitorName) values (@compId,@lanId,Replace(@CompetitorName,'-',' '))
			end
		else
			begin
					--if not exists (select Language.ParameterCompetitor.CompetitorId from Language.ParameterCompetitor with (nolock) where Language.ParameterCompetitor.CompetitorId=@compId and Language.ParameterCompetitor.LanguageId=@lanId and Language.ParameterCompetitor.CompetitorName=@CompetitorName)
						if @lanId not in (2,3,6)
						update Language.ParameterCompetitor set Language.ParameterCompetitor.CompetitorName=Replace(@CompetitorName,'-',' ') where Language.ParameterCompetitor.CompetitorId=@compId and Language.ParameterCompetitor.LanguageId=@lanId
			end			
			
	if(@compId<>0)
	if not exists (select Match.FixtureCompetitor.FixtureCompetitorId from Match.FixtureCompetitor with (nolock) where Match.FixtureCompetitor.FixtureId=@FixtureId and Match.FixtureCompetitor.CompetitorId=@compId)
		if not exists (select Archive.FixtureCompetitor.FixtureCompetitorId from Archive.FixtureCompetitor where Archive.FixtureCompetitor.FixtureId=@FixtureId and Archive.FixtureCompetitor.CompetitorId=@compId)
			if not exists (select Match.FixtureCompetitor.FixtureCompetitorId from Match.FixtureCompetitor with (nolock) where Match.FixtureCompetitor.FixtureId=@FixtureId and Match.FixtureCompetitor.TypeId=@Type)
				insert Match.FixtureCompetitor(FixtureId,CompetitorId,TypeId) values (@FixtureId,@compId,@Type)
			else
				update  Match.FixtureCompetitor set CompetitorId=@compId where FixtureId=@FixtureId and TypeId=@Type
		
	
	

END


GO
