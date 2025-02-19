USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCategoryCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 03.03.2015
-- Description:	
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcCategoryCombo] 
@SportId int,
@username nvarchar(max)


AS


declare @LangId int

select @LangId=Users.Users.LanguageId from Users.Users where Users.UserName=@username
 

 Select Parameter.Category.CategoryId,Language.[Parameter.Category].CategoryName 
 from Parameter.Category INNER JOIN Language.[Parameter.Category] ON Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId
 where Parameter.Category.SportId=@SportId and Language.[Parameter.Category].LanguageId=1
 order by Language.[Parameter.Category].CategoryName 


GO
