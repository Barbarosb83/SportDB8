USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCountryTaxValue]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCountryTaxValue] 
@ISO nvarchar(20)
AS

BEGIN
SET NOCOUNT ON;

declare @Tax float=0

--insert dbo.TaxTest values(@ISO,GETDATE())

if exists (select  Parameter.TaxCountry.CountryTaxId from Parameter.TaxCountry where Iso=@ISO)
	select @Tax =Parameter.TaxCountry.Tax from Parameter.TaxCountry where Iso=@ISO

select @Tax as Tax

END


GO
