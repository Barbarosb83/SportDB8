USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcAccountLockDay]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcAccountLockDay] 
 
@LanguageId int


AS

SELECT [AcountLockDayId]
      ,[AcountLockDay]
  
  FROM [Parameter].[AcountLockDay] where [LangId]=@LanguageId


GO
