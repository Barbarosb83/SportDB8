USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcRegisterScreen]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcRegisterScreen] 

AS

BEGIN
SET NOCOUNT ON;



SELECT [RegisterScreenId]
      ,[FieldName]
      ,[IsVisible]
      ,[IsRequried]
      ,[DefalutValue]
  FROM [Parameter].[RegisterScreen]


end



GO
