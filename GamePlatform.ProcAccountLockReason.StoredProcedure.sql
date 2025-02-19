USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcAccountLockReason]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcAccountLockReason] 
 
@LanguageId int


AS


SELECT [AcountLockId]
      ,[LockReason]
 
  FROM [Parameter].[AcountLockReason] where [LangId]=@LanguageId


GO
