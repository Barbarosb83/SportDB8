USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCategoryCombo]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCategoryCombo] 
@SportId int,
@LanguageId int


AS


 Select Parameter.Category.CategoryId,Language.[Parameter.Category].CategoryName 
 from Parameter.Category with (nolock) inner join Language.[Parameter.Category] with (nolock)
 on Parameter.Category.CategoryId=Language.[Parameter.Category].CategoryId and 
 Language.[Parameter.Category].LanguageId=@LanguageId
 where Parameter.Category.SportId=@SportId
 order by Parameter.Category.CategoryName


GO
