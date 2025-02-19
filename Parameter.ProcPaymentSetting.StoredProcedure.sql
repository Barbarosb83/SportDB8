USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Parameter].[ProcPaymentSetting]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Parameter].[ProcPaymentSetting]
@PaymentName nvarchar(50)


AS

BEGIN
SET NOCOUNT ON;

SELECT [PaymentSettingId]
      ,[PaymentName]
      ,[PaymentKey]
      ,[PaymentValue]
  FROM [Parameter].[PaymentSetting]
Where PaymentName=@PaymentName


END




GO
