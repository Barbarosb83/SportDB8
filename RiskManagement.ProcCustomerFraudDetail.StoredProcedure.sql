USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerFraudDetail]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCustomerFraudDetail] 
@IpAddress nvarchar(20),
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100),
@LangId int
AS

BEGIN
SET NOCOUNT ON;


declare @sqlcommand nvarchar(max)
declare @sqlcommand2 nvarchar(max)


declare @total int 

select @total=COUNT(DISTINCT Customer.Customer.CustomerId) 
FROM          Customer.Customer INNER JOIN
					  Customer.Ip ON Customer.Ip.CustomerId=Customer.Customer.CustomerId INNER JOIN
                      Parameter.Branch ON Customer.Customer.BranchId = Parameter.Branch.BranchId INNER JOIN
                      Parameter.Currency ON Customer.Customer.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.Language ON Customer.Customer.LanguageId = Language.Language.LanguageId INNER JOIN
                      Parameter.TimeZone ON Customer.Customer.TimeZoneId = Parameter.TimeZone.TimeZoneId INNER JOIN
                      Parameter.Country ON Customer.Customer.CountryId = Parameter.Country.CountryId INNER JOIN
                      Parameter.OddsFormat ON Customer.Customer.OddsFormatId = Parameter.OddsFormat.OddsFormatId INNER JOIN
                      Parameter.PasswordQuestion ON Customer.Customer.PasswordQuestionId = Parameter.PasswordQuestion.PasswordQuestionId INNER JOIN
                      Parameter.PhoneCode ON Customer.Customer.PhoneCodeId = Parameter.PhoneCode.PhoneCodeId INNER JOIN
                      Parameter.Salutation ON Customer.Customer.SalutationId = Parameter.Salutation.SalutationId 
                      where Customer.Ip.IpAddress=@IpAddress; 
                     
WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.Customer.CustomerId) AS RowNum,
   Customer.Customer.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CurrencyId, Parameter.Currency.Currency, Parameter.Currency.Sybol, 
                      Customer.Customer.Balance, Customer.Customer.Username, dbo.UserTimeZoneDate(@Username,Customer.Customer.CreateDate,0) as CreateDate,dbo.UserTimeZoneDate(@Username,Customer.Customer.LastLoginDate,0) as LastLoginDate, Customer.Customer.IpAddress, 
                      Customer.Customer.Email, Customer.Customer.Birthday, Customer.Customer.PhoneNumber, Customer.Customer.LanguageId, Language.Language.Language, 
                      Parameter.Branch.BranchId, Parameter.Branch.BrancName, Customer.Customer.Password, Customer.Customer.CustomerSurname, Customer.Customer.IsActive, 
                      Customer.Customer.OddsFormatId, Customer.Customer.PhoneCodeId, Customer.Customer.SalutationId, Customer.Customer.CountryId, 
                      Customer.Customer.TimeZoneId, Customer.Customer.Address, Customer.Customer.AddressAdditional, Customer.Customer.ZipCode, 
                      Customer.Customer.IsOddDecreasements, Customer.Customer.IsOddIncreasement, Customer.Customer.City, Customer.Customer.PasswordQuestionId, 
                      Parameter.PasswordQuestion.PasswordQuestion, Parameter.Salutation.Salutation, Parameter.Country.Country, Parameter.OddsFormat.OddsFormatName, 
                      Parameter.PhoneCode.PhoneCode, Parameter.TimeZone.TimeZone,Customer.PasswordQuestion as PasswordAnswer,Parameter.CustomerGroup.CustomerGroupId,Parameter.CustomerGroup.GroupName
FROM         Customer.Customer INNER JOIN
					  Customer.Ip ON Customer.Ip.CustomerId=Customer.Customer.CustomerId INNER JOIN
					  Parameter.CustomerGroup ON Customer.Customer.GroupId =  Parameter.CustomerGroup.CustomerGroupId INNER JOIN
                      Parameter.Branch ON Customer.Customer.BranchId = Parameter.Branch.BranchId INNER JOIN
                      Parameter.Currency ON Customer.Customer.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.Language ON Customer.Customer.LanguageId = Language.Language.LanguageId INNER JOIN
                      Parameter.TimeZone ON Customer.Customer.TimeZoneId = Parameter.TimeZone.TimeZoneId INNER JOIN
                      Parameter.Country ON Customer.Customer.CountryId = Parameter.Country.CountryId INNER JOIN
                      Parameter.OddsFormat ON Customer.Customer.OddsFormatId = Parameter.OddsFormat.OddsFormatId INNER JOIN
                      Parameter.PasswordQuestion ON Customer.Customer.PasswordQuestionId = Parameter.PasswordQuestion.PasswordQuestionId INNER JOIN
                      Parameter.PhoneCode ON Customer.Customer.PhoneCodeId = Parameter.PhoneCode.PhoneCodeId INNER JOIN
                      Parameter.Salutation ON Customer.Customer.SalutationId = Parameter.Salutation.SalutationId
                      where Customer.Ip.IpAddress=@IpAddress
)  
SELECT DISTINCT CustomerId, CustomerName, CurrencyId, Currency,Sybol, 
                      Balance, Username, CreateDate, LastLoginDate, IpAddress, 
                      Email, Birthday,PhoneNumber,LanguageId, Language, 
                      BranchId, BrancName, Password, CustomerSurname, IsActive, 
                      OddsFormatId, PhoneCodeId, SalutationId, CountryId, 
                      TimeZoneId, Address, AddressAdditional, ZipCode, 
                      IsOddDecreasements,IsOddIncreasement,City, PasswordQuestionId, 
                     PasswordQuestion, Salutation, Country, OddsFormatName, 
                      PhoneCode, TimeZone,PasswordQuestion as PasswordAnswer,CustomerGroupId,GroupName,@total as totalrow 
FROM OrdersRN 
WHERE RowNum BETWEEN ((@PageNum-1 )*(@PageSize))+1 AND (@PageNum * @PageSize ) 


--set @sqlcommand='declare @total int '+
--'select @total=COUNT( Customer.Customer.CustomerId) '+
--'FROM          Customer.Customer INNER JOIN
--                      Parameter.Branch ON Customer.Customer.BranchId = Parameter.Branch.BranchId INNER JOIN
--                      Parameter.Currency ON Customer.Customer.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
--                      Language.Language ON Customer.Customer.LanguageId = Language.Language.LanguageId INNER JOIN
--                      Parameter.TimeZone ON Customer.Customer.TimeZoneId = Parameter.TimeZone.TimeZoneId INNER JOIN
--                      Parameter.Country ON Customer.Customer.CountryId = Parameter.Country.CountryId INNER JOIN
--                      Parameter.OddsFormat ON Customer.Customer.OddsFormatId = Parameter.OddsFormat.OddsFormatId INNER JOIN
--                      Parameter.PasswordQuestion ON Customer.Customer.PasswordQuestionId = Parameter.PasswordQuestion.PasswordQuestionId INNER JOIN
--                      Parameter.PhoneCode ON Customer.Customer.PhoneCodeId = Parameter.PhoneCode.PhoneCodeId INNER JOIN
--                      Parameter.Salutation ON Customer.Customer.SalutationId = Parameter.Salutation.SalutationId '+
--'WHERE (1 = 1) and '+@where +' ; ' +
--'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
--' Customer.Customer.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CurrencyId, Parameter.Currency.Currency, Parameter.Currency.Sybol, 
--                      Customer.Customer.Balance, Customer.Customer.Username, Customer.Customer.CreateDate, Customer.Customer.LastLoginDate, Customer.Customer.IpAddress, 
--                      Customer.Customer.Email, Customer.Customer.Birthday, Customer.Customer.PhoneNumber, Customer.Customer.LanguageId, Language.Language.Language, 
--                      Parameter.Branch.BranchId, Parameter.Branch.BrancName, Customer.Customer.Password, Customer.Customer.CustomerSurname, Customer.Customer.IsActive, 
--                      Customer.Customer.OddsFormatId, Customer.Customer.PhoneCodeId, Customer.Customer.SalutationId, Customer.Customer.CountryId, 
--                      Customer.Customer.TimeZoneId, Customer.Customer.Address, Customer.Customer.AddressAdditional, Customer.Customer.ZipCode, 
--                      Customer.Customer.IsOddDecreasements, Customer.Customer.IsOddIncreasement, Customer.Customer.City, Customer.Customer.PasswordQuestionId, 
--                      Parameter.PasswordQuestion.PasswordQuestion, Parameter.Salutation.Salutation, Parameter.Country.Country, Parameter.OddsFormat.OddsFormatName, 
--                      Parameter.PhoneCode.PhoneCode, Parameter.TimeZone.TimeZone,Customer.PasswordQuestion as PasswordAnswer,Parameter.CustomerGroup.CustomerGroupId,Parameter.CustomerGroup.GroupName '
--set @sqlcommand2='FROM        Customer.Customer INNER JOIN
--						Parameter.CustomerGroup ON Customer.Customer.GroupId =  Parameter.CustomerGroup.CustomerGroupId INNER JOIN
--                      Parameter.Branch ON Customer.Customer.BranchId = Parameter.Branch.BranchId INNER JOIN
--                      Parameter.Currency ON Customer.Customer.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
--                      Language.Language ON Customer.Customer.LanguageId = Language.Language.LanguageId INNER JOIN
--                      Parameter.TimeZone ON Customer.Customer.TimeZoneId = Parameter.TimeZone.TimeZoneId INNER JOIN
--                      Parameter.Country ON Customer.Customer.CountryId = Parameter.Country.CountryId INNER JOIN
--                      Parameter.OddsFormat ON Customer.Customer.OddsFormatId = Parameter.OddsFormat.OddsFormatId INNER JOIN
--                      Parameter.PasswordQuestion ON Customer.Customer.PasswordQuestionId = Parameter.PasswordQuestion.PasswordQuestionId INNER JOIN
--                      Parameter.PhoneCode ON Customer.Customer.PhoneCodeId = Parameter.PhoneCode.PhoneCodeId INNER JOIN
--                      Parameter.Salutation ON Customer.Customer.SalutationId = Parameter.Salutation.SalutationId '+
--'WHERE (1= 1) and '+@where+
-- ') '+  
--'SELECT *,@total as totalrow '+
--  'FROM OrdersRN '+
-- ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '





execute (@sqlcommand+@sqlcommand2)

END


GO
