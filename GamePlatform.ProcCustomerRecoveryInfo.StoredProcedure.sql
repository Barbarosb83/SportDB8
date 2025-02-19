USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerRecoveryInfo]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcCustomerRecoveryInfo] 
@CustomerId bigint
AS

BEGIN
SET NOCOUNT ON;


SELECT [CustomerId]
      ,[RecoveryCode]
  FROM [Customer].[Customer]
  where [CustomerId]=@CustomerId




END



GO
