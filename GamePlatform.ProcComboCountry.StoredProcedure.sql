USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcComboCountry]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcComboCountry] 

AS

BEGIN
SET NOCOUNT ON;


select Parameter.Country.CountryId,Parameter.Country.Country,Parameter.Country.CountryIcon
 from Parameter.Country with (nolock) where CountryId in (55)


END


GO
