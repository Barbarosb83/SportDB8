USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [CMS].[ProcNotice]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [CMS].[ProcNotice]

AS


BEGIN
SET NOCOUNT ON;

select CMS.Notice.NoticeId
,CMS.Notice.Description
,CMS.Notice.EndDate
,CMS.Notice.IsActive
,CMS.Notice.LangId
,CMS.Notice.StartDate
,CMS.Notice.Title
,CMS.Notice.CreateDate
,Cms.Notice.CreateUser
,Language.Language.Language
from CMS.Notice with (nolock)  INNER JOIN
Language.Language with (nolock)  ON Language.Language.LanguageId=CMS.Notice.LangId  
  

END


GO
