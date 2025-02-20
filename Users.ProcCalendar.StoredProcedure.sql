USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcCalendar]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[ProcCalendar] 
@Username nvarchar(50),
@UserId int
AS
BEGIN
SET NOCOUNT ON;
 

select   [Subject], [Description], CalendarStartDate,CalendarEndDate,
     Link
FROM         Users.Calendar
WHERE     IsDeleted=0
   

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



 
END


GO
