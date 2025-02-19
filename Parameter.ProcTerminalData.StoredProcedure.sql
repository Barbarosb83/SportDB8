USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Parameter].[ProcTerminalData]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Parameter].[ProcTerminalData] 
AS

BEGIN
SET NOCOUNT ON;

SELECT [OddDataId]
      ,[OddData] as Data
      ,[CreateDate]
      ,[UpdateDate]
      ,[Types]
  FROM [Parameter].[OddData]


END



GO
