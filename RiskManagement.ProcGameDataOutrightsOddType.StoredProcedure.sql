USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameDataOutrightsOddType]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 03.03.2015
-- Description:
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcGameDataOutrightsOddType] 
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(200),
@orderby nvarchar(100),
@MatchId int,
@LangId int
AS
BEGIN
SET NOCOUNT ON;


declare @sqlcommand nvarchar(max)

declare @total int 

select @total=COUNT(Outrights.OddTypeSetting.OddTypeSettingId)
FROM         Outrights.OddTypeSetting INNER JOIN
                      Parameter.MatchAvailability ON Outrights.OddTypeSetting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
                      Parameter.MatchState ON Outrights.OddTypeSetting.StateId = Parameter.MatchState.StateId
					  INNER JOIN
					   Outrights.EventName ON Outrights.EventName.EventId=Outrights.OddTypeSetting.MatchId 
WHERE     (Outrights.EventName.LanguageId = @LangId) AND (Outrights.OddTypeSetting.MatchId = @MatchId);
WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY dbo.FuncCashFlow(Outrights.OddTypeSetting.OddTypeId,Outrights.OddTypeSetting.MatchId,1,3),Outrights.OddTypeSetting.OddTypeId desc) AS RowNum,
  Outrights.OddTypeSetting.OddTypeSettingId, Outrights.OddTypeSetting.OddTypeId, Outrights.OddTypeSetting.StateId, Outrights.OddTypeSetting.LossLimit, 
                      Outrights.OddTypeSetting.LimitPerTicket, Outrights.OddTypeSetting.AvailabilityId, Outrights.OddTypeSetting.StakeLimit, Outrights.OddTypeSetting.MinCombiBranch, 
                      Outrights.OddTypeSetting.MinCombiInternet, Outrights.OddTypeSetting.MinCombiMachine, Outrights.OddTypeSetting.MatchId, Outrights.OddTypeSetting.IsPopular, 
                      Outrights.EventName.EventName as OddsType, Parameter.MatchState.State, Parameter.MatchState.StatuColor, Parameter.MatchAvailability.Availability,
                      (select top 1 ISNULL(Outrights.Odd.SpecialBetValue,'') from Outrights.Odd where Outrights.Odd.MatchId=Outrights.OddTypeSetting.MatchId and Outrights.Odd.OddsTypeId=Outrights.OddTypeSetting.OddTypeId) as SpecialBetValue,dbo.FuncCashFlow(Outrights.OddTypeSetting.OddTypeId,Outrights.OddTypeSetting.MatchId,1,3) as Cashflow
FROM         Outrights.OddTypeSetting INNER JOIN
                      Parameter.MatchAvailability ON Outrights.OddTypeSetting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
                      Parameter.MatchState ON Outrights.OddTypeSetting.StateId = Parameter.MatchState.StateId
					   INNER JOIN
					   Outrights.EventName ON Outrights.EventName.EventId=Outrights.OddTypeSetting.MatchId 
WHERE     (Outrights.EventName.LanguageId = @LangId) AND ( Outrights.OddTypeSetting.MatchId = @MatchId)
)  
			 SELECT *,@total as totalrow 
  FROM OrdersRN
 WHERE RowNum BETWEEN (@PageNum-1)*(@PageSize + 1) AND (@PageNum * @PageSize) 


--set @sqlcommand=   'declare @total int '+
--' select @total=COUNT(*) from  '+
--' Customer.Address INNER JOIN
--                      Parameter.AddressType ON Customer.Address.AddressTypeId = Parameter.AddressType.AddressTypeId INNER JOIN
--                      Parameter.DataEntrySource ON Customer.Address.DataEntrySourceId = Parameter.DataEntrySource.DataEntrySourceId INNER JOIN
--                      Parameter.Country ON Customer.Address.CountryId = Parameter.Country.CountryId INNER JOIN
--                      Parameter.City ON Customer.Address.CityId = Parameter.City.CityId AND Parameter.Country.CountryId = Parameter.City.CountryId INNER JOIN
--                      Parameter.District ON Customer.Address.DistrictId = Parameter.District.DistrictId AND Parameter.City.CityId = Parameter.District.CityId INNER JOIN
--                      Customer.Role ON Customer.Address.CustomerId = Customer.Role.SubCustomerId INNER JOIN
--                      Customer.Customer ON Customer.Role.SubCustomerId = Customer.Customer.CustomerId AND Customer.Role.SubCustomerId = Customer.Customer.CustomerId AND 
--                      Customer.Role.SubCustomerId = Customer.Customer.CustomerId AND Customer.Role.SubCustomerId = Customer.Customer.CustomerId AND 
--                      Customer.Role.SubCustomerId = Customer.Customer.CustomerId AND Customer.Role.SubCustomerId = Customer.Customer.CustomerId
--                       WHERE     (Customer.Role.MainCustomerId ='+cast(@CustomerId as nvarchar(10))+') and  (Customer.Address.IsDeleted = 0) and '+@where+ ' ; '+
--' WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY  '+@orderby+ ') AS RowNum,  '+
--'  Customer.Address.AddressId, Customer.Address.CustomerId, Customer.Address.DataEntrySourceId, Parameter.DataEntrySource.DataEntrySource, 
--                      Customer.Address.AddressTypeId, Parameter.AddressType.AddressType, Customer.Address.IsContactAddress,Case when Customer.Address.IsContactAddress=1 then ''Evet'' else ''Hayır'' end as Contact, Customer.Address.Address, 
--                      Parameter.Country.CountryId, Parameter.Country.Country, Parameter.City.CityId, Parameter.City.City, Parameter.District.DistrictId, Parameter.District.District, 
--                      Customer.Address.ZipCode, Customer.Customer.Name + '' '' + Customer.Customer.Surname AS CustomerName '+
--' FROM         Customer.Address INNER JOIN
--                      Parameter.AddressType ON Customer.Address.AddressTypeId = Parameter.AddressType.AddressTypeId INNER JOIN
--                      Parameter.DataEntrySource ON Customer.Address.DataEntrySourceId = Parameter.DataEntrySource.DataEntrySourceId INNER JOIN
--                      Parameter.Country ON Customer.Address.CountryId = Parameter.Country.CountryId INNER JOIN
--                      Parameter.City ON Customer.Address.CityId = Parameter.City.CityId AND Parameter.Country.CountryId = Parameter.City.CountryId INNER JOIN
--                      Parameter.District ON Customer.Address.DistrictId = Parameter.District.DistrictId AND Parameter.City.CityId = Parameter.District.CityId INNER JOIN
--                      Customer.Role ON Customer.Address.CustomerId = Customer.Role.SubCustomerId INNER JOIN
--                      Customer.Customer ON Customer.Role.SubCustomerId = Customer.Customer.CustomerId AND Customer.Role.SubCustomerId = Customer.Customer.CustomerId AND 
--                      Customer.Role.SubCustomerId = Customer.Customer.CustomerId AND Customer.Role.SubCustomerId = Customer.Customer.CustomerId AND 
--                      Customer.Role.SubCustomerId = Customer.Customer.CustomerId AND Customer.Role.SubCustomerId = Customer.Customer.CustomerId '+
--' WHERE     (Customer.Role.MainCustomerId ='+cast(@CustomerId as nvarchar(10))+') and  (Customer.Address.IsDeleted = 0) and '+@where +
--'  )  '+
--'			 SELECT *,@total as totalrow '+
--'  FROM OrdersRN'+
--' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(20))+')*('+cast(@PageSize  as nvarchar(10))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '






exec (@sqlcommand)
END


GO
