USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcComboPhoneCode]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcComboPhoneCode]
 


AS




BEGIN
SET NOCOUNT ON;


select *
from  [Parameter].[PhoneCode]


END



GO
