USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Outrights.ProcEventCompetitor]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Betradar].[Outrights.ProcEventCompetitor]
@EventId bigint,
@BetradarSuperId bigint,
@CompetitorName nvarchar(250),
@Type int,
@Language nvarchar(10),
@BetradarCompetitorId bigint
AS


declare @compId int=0
declare @lanId int=0

select @lanId=Language.Language.LanguageId from Language.Language with (nolock) where Language.Language.Language=@Language

declare @LangComp int=@lanId


if(@LangComp not in (2,3,6))
	set @LangComp=2



BEGIN

	if exists (select Parameter.Competitor.CompetitorId from Parameter.Competitor with (nolock) where Parameter.Competitor.BetradarSuperId=@BetradarSuperId)
			begin
				select @compId=Parameter.Competitor.CompetitorId from Parameter.Competitor with (nolock) where Parameter.Competitor.BetradarSuperId=@BetradarSuperId

			end
	Else
		begin
			insert Parameter.Competitor(BetradarSuperId,CompetitorName)
			values (@BetradarSuperId,Replace(@CompetitorName,'-',' '))
			
			set @compId=SCOPE_IDENTITY()
			
					insert Language.ParameterCompetitor(CompetitorId,LanguageId,CompetitorName) --values (@compId,@lanId,@CompetitorName)
				select @compId,Language.Language.LanguageId,Replace(@CompetitorName,'-',' ') from Language.Language with (nolock) where LanguageId in (1,2,3,6)
			
		end
		
		
		if not exists (select Language.ParameterCompetitor.CompetitorId from Language.ParameterCompetitor with (nolock) where Language.ParameterCompetitor.CompetitorId=@compId and Language.ParameterCompetitor.LanguageId=@LangComp)
			begin
				insert Language.ParameterCompetitor(CompetitorId,LanguageId,CompetitorName) values (@compId,@LangComp,Replace(@CompetitorName,'-',' '))
			end
		--else
		--	begin
		--			--if not exists (select Language.ParameterCompetitor.CompetitorId from Language.ParameterCompetitor with (nolock) where Language.ParameterCompetitor.CompetitorId=@compId and Language.ParameterCompetitor.LanguageId=@lanId and Language.ParameterCompetitor.CompetitorName=@CompetitorName)
		--				--update Language.ParameterCompetitor set Language.ParameterCompetitor.CompetitorName=Replace(@CompetitorName,'-',' ') where Language.ParameterCompetitor.CompetitorId=@compId and Language.ParameterCompetitor.LanguageId=@lanId
		--	end			
			
			

	if exists (SELECT [EventCompetitorId] FROM [Outrights].[Competitor] with (nolock) where [Outrights].[Competitor].[EventId]=@EventId and [Outrights].[Competitor].CompetitorId=@compId)
	begin
	
		UPDATE [Outrights].[Competitor]
			   SET [EventId] = @EventId
				  ,[CompetitorId] = @compId
				  ,[CompetitorBetradarId] = @BetradarCompetitorId
			 WHERE [Outrights].[Competitor].[EventId]=@EventId and [Outrights].[Competitor].CompetitorId=@compId


	end
	else
	begin
		INSERT INTO [Outrights].[Competitor]
           ([EventId]
           ,[CompetitorId]
           ,[CompetitorBetradarId])
					 VALUES
						   (@EventId
						   ,@compId
						   ,@BetradarCompetitorId)
	end
	
	




END


GO
