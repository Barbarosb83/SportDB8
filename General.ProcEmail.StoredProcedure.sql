USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [General].[ProcEmail]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [General].[ProcEmail]
	@Purpose nvarchar(max),
	@LangId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT      HTML,MailSubject
FROM         General.EmailTemplate
Where Purpose=@Purpose and LanguageId=@LangId

END


GO
