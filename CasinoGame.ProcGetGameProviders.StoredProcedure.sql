USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [CasinoGame].[ProcGetGameProviders]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CasinoGame].[ProcGetGameProviders]


AS


BEGIN
SET NOCOUNT ON;


SELECT [ProviderId]
      ,[ProviderName]
      ,[ProviderKey]
      ,[ProviderText]
      ,[Img]
      ,[Logo]
      ,[RowNumber]
      ,[IsEnabled]
  FROM [CasinoGame].[Provider] where IsEnabled=1


	
END

GO
