USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcComboCountry]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcComboCountry]
 


AS




BEGIN
SET NOCOUNT ON;


select Parameter.Country.CountryId,Parameter.Country.Country
from Parameter.Country


END



GO
