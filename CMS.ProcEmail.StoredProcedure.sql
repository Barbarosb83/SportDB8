USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [CMS].[ProcEmail]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CMS].[ProcEmail]

AS


BEGIN
SET NOCOUNT ON;

SELECT       EmailTemplateId, 
				TemplateName, 
					Purpose, 
						General.EmailTemplate.LanguageId,
							 HTML,
								 MailSubject
								  ,Language.[Language].[Language]
FROM            General.EmailTemplate
inner join  Language.[Language] on Language.[LanguageId]= General.EmailTemplate.LanguageId




END


GO
