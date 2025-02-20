USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcOddsLanguage]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Betradar].[Live.ProcOddsLanguage]
	@OddId int
    ,@Outcomes nvarchar(20)
    ,@Language nvarchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @LanId int
	if not exists (select [Language].[Language].LanguageId from [Language].[Language]  with (nolock) where [Language].[Language].Language=@Language)
			begin
				insert [Language].[Language] values(@Language,'',1)
				set @LanId=SCOPE_IDENTITY()
			end
		else
			select @LanId= [Language].[Language].LanguageId from [Language].[Language] with (nolock)  where [Language].[Language].Language=@Language


	if not exists(select Language.[Parameter.LiveOdds].ParameterLiveOddId from Language.[Parameter.LiveOdds] with (nolock) where Language.[Parameter.LiveOdds].OddsId=@OddId and Language.[Parameter.LiveOdds].LanguageId=@LanId)
		begin

			insert  Language.[Parameter.LiveOdds](OddsId,LanguageId,OutComes)
			select @OddId,[Language].[Language].LanguageId,@Outcomes
		from [Language].[Language] with (nolock)
		where [Language].[Language].LanguageId not in (select Language.[Parameter.LiveOdds].LanguageId from Language.[Parameter.LiveOdds] with (nolock) where Language.[Parameter.LiveOdds].OddsId=@OddId)
		end
	else
		begin
		if (@LanId=5 or @LanId>10)
			update Language.[Parameter.LiveOdds] set Outcomes=@Outcomes where Language.[Parameter.LiveOdds].OddsId=@OddId and Language.[Parameter.LiveOdds].LanguageId=@LanId
		end
END


GO
