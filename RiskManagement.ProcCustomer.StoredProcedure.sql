USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomer]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [RiskManagement].[ProcCustomer] 
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100)
AS

BEGIN
SET NOCOUNT ON;


declare @sqlcommand nvarchar(max)
declare @sqlcommand2 nvarchar(max)
declare @UserCurrencyId int
declare @BranchId int
declare @where2 nvarchar(max)=' and 1=1'

select @BranchId=Users.Users.UnitCode, @UserCurrencyId=Users.Users.CurrencyId from Users.Users where Users.Users.UserName=@Username

if(@BranchId<>1)
	begin

	set @where2='  and Customer.Customer.BranchId='+cast(@BranchId as nvarchar(7))

	end

--declare @total int 

--select @total=COUNT( Customer.Customer.CustomerId) 
--FROM          Customer.Customer INNER JOIN
--                      Parameter.Branch ON Customer.Customer.BranchId = Parameter.Branch.BranchId INNER JOIN
--                      Parameter.Currency ON Customer.Customer.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
--                      Language.Language ON Customer.Customer.LanguageId = Language.Language.LanguageId INNER JOIN
--                      Parameter.TimeZone ON Customer.Customer.TimeZoneId = Parameter.TimeZone.TimeZoneId INNER JOIN
--                      Parameter.Country ON Customer.Customer.CountryId = Parameter.Country.CountryId INNER JOIN
--                      Parameter.OddsFormat ON Customer.Customer.OddsFormatId = Parameter.OddsFormat.OddsFormatId INNER JOIN
--                      Parameter.PasswordQuestion ON Customer.Customer.PasswordQuestionId = Parameter.PasswordQuestion.PasswordQuestionId INNER JOIN
--                      Parameter.PhoneCode ON Customer.Customer.PhoneCodeId = Parameter.PhoneCode.PhoneCodeId INNER JOIN
--                      Parameter.Salutation ON Customer.Customer.SalutationId = Parameter.Salutation.SalutationId ; 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.Customer.CustomerId) AS RowNum,
--    Customer.Customer.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CurrencyId, Parameter.Currency.Currency, Parameter.Currency.Sybol, 
--                      Customer.Customer.Balance, Customer.Customer.Username, Customer.Customer.CreateDate, Customer.Customer.LastLoginDate, Customer.Customer.IpAddress, 
--                      Customer.Customer.Email, Customer.Customer.Birthday, Customer.Customer.PhoneNumber, Customer.Customer.LanguageId, Language.Language.Language, 
--                      Parameter.Branch.BranchId, Parameter.Branch.BrancName, Customer.Customer.Password, Customer.Customer.CustomerSurname, Customer.Customer.IsActive, 
--                      Customer.Customer.OddsFormatId, Customer.Customer.PhoneCodeId, Customer.Customer.SalutationId, Customer.Customer.CountryId, 
--                      Customer.Customer.TimeZoneId, Customer.Customer.Address, Customer.Customer.AddressAdditional, Customer.Customer.ZipCode, 
--                      Customer.Customer.IsOddDecreasements, Customer.Customer.IsOddIncreasement, Customer.Customer.City, Customer.Customer.PasswordQuestionId, 
--                      Parameter.PasswordQuestion.PasswordQuestion, Parameter.Salutation.Salutation, Parameter.Country.Country, Parameter.OddsFormat.OddsFormatName, 
--                      Parameter.PhoneCode.PhoneCode, Parameter.TimeZone.TimeZone,Customer.PasswordQuestion as PasswordAnswer,Parameter.CustomerGroup.CustomerGroupId,Parameter.CustomerGroup.GroupName,Customer.Customer.IsLockedOut,Customer.Customer.FailedPasswordAttemptCount,Customer.Customer.IsVerification,Customer.Customer.IdNumber
--					  ,Customer.Customer.PassportNumber,Customer.Customer.BirthPlace,Customer.Customer.TaxNo,Customer.Customer.RiskLevelId,Customer.Customer.Bonus,Customer.Customer.IsTempLock,Parameter.RiskLevel.RiskLevel,Case when Customer.Customer.RiskLevelId<3 then 1 else 3 end as RiskLevelColor,Customer.Customer.TempLockOutdate 
--FROM         Customer.Customer INNER JOIN
--					  Parameter.CustomerGroup ON Customer.Customer.GroupId =  Parameter.CustomerGroup.CustomerGroupId INNER JOIN
--                      Parameter.Branch ON Customer.Customer.BranchId = Parameter.Branch.BranchId INNER JOIN
--                      Parameter.Currency ON Customer.Customer.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
--                      Language.Language ON Customer.Customer.LanguageId = Language.Language.LanguageId INNER JOIN
--                      Parameter.TimeZone ON Customer.Customer.TimeZoneId = Parameter.TimeZone.TimeZoneId INNER JOIN
--                      Parameter.Country ON Customer.Customer.CountryId = Parameter.Country.CountryId INNER JOIN
--                      Parameter.OddsFormat ON Customer.Customer.OddsFormatId = Parameter.OddsFormat.OddsFormatId INNER JOIN
--                      Parameter.PasswordQuestion ON Customer.Customer.PasswordQuestionId = Parameter.PasswordQuestion.PasswordQuestionId INNER JOIN
--                      Parameter.PhoneCode ON Customer.Customer.PhoneCodeId = Parameter.PhoneCode.PhoneCodeId INNER JOIN
--                      Parameter.Salutation ON Customer.Customer.SalutationId = Parameter.Salutation.SalutationId  INNER JOIN 
--					  Parameter.RiskLevel On Parameter.RiskLevel.RiskLevelId=Customer.Customer.RiskLevelId
--)  
--SELECT *,@total as totalrow 
--FROM OrdersRN 
--WHERE RowNum BETWEEN ((@PageNum-1 )*(@PageSize))+1 AND (@PageNum * @PageSize ) 
if(@orderby='CustomerId desc')
	set @orderby=REPLACE(@orderby,'CustomerId','Customer.Customer.CustomerId')
else if(@orderby='CustomerId asc')
	set @orderby=REPLACE(@orderby,'CustomerId','Customer.Customer.CustomerId')

set @sqlcommand='declare @total int '+
'select @total=COUNT( Customer.Customer.CustomerId) '+
'FROM          Customer.Customer with (nolock) INNER JOIN
                      Parameter.Branch with (nolock)  ON Customer.Customer.BranchId = Parameter.Branch.BranchId INNER JOIN
                      Parameter.Currency with (nolock)  ON Customer.Customer.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.Language with (nolock)  ON Customer.Customer.LanguageId = Language.Language.LanguageId INNER JOIN
                      Parameter.TimeZone with (nolock)  ON Customer.Customer.TimeZoneId = Parameter.TimeZone.TimeZoneId INNER JOIN
                      Parameter.Country with (nolock)  ON Customer.Customer.CountryId = Parameter.Country.CountryId INNER JOIN
                     
                      
                      Parameter.PhoneCode with (nolock)  ON Customer.Customer.PhoneCodeId = Parameter.PhoneCode.PhoneCodeId 
                      
					   '+
'WHERE (1 = 1) and (Customer.Customer.IsBranchCustomer=0 or Customer.Customer.IsBranchCustomer is null)  and (Customer.Customer.IsTerminalCustomer=0 or Customer.Customer.IsTerminalCustomer is null) '+@where2+ ' and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
' Customer.Customer.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CurrencyId, Parameter.Currency.Currency, Parameter.Currency.Sybol, 
                      Customer.Customer.Balance, Customer.Customer.Username as Username,dbo.UserTimeZoneDate('''+@Username+''',Customer.Customer.CreateDate,0) as CreateDate,dbo.UserTimeZoneDate('''+@Username+''',Customer.Customer.LastLoginDate,0) as  LastLoginDate, Customer.Customer.IpAddress, 
                      Customer.Customer.Email, Customer.Customer.Birthday, Customer.Customer.PhoneNumber, Customer.Customer.LanguageId, Language.Language.Language, 
                      Parameter.Branch.BranchId, Parameter.Branch.BrancName, Customer.Customer.Password, Customer.Customer.CustomerSurname, Customer.Customer.IsActive, 
                      1 as OddsFormatId, Customer.Customer.PhoneCodeId, Customer.Customer.SalutationId, Customer.Customer.CountryId, 
                      Customer.Customer.TimeZoneId, Customer.Customer.Address, Customer.Customer.AddressAdditional, Customer.Customer.ZipCode, 
                      Customer.Customer.IsOddDecreasements, ISNULL(Customer.BonusRequest.IsEnable,0) as IsOddIncreasement, Customer.Customer.City, Customer.Customer.PasswordQuestionId, 
                      '''' as PasswordQuestion, '''' as Salutation, Parameter.Country.Country, ''Decimal'' as OddsFormatName, 
                      '''' as PhoneCode, Parameter.TimeZone.TimeZone,Customer.PasswordQuestion as PasswordAnswer,Parameter.CustomerGroup.CustomerGroupId,ISNULL(cast(Customer.Bonusrequest.BonusStartDate as nvarchar(50)),'''') as GroupName,Customer.Customer.IsLockedOut,Customer.Customer.FailedPasswordAttemptCount,Customer.Customer.IsVerification,Customer.Customer.IdNumber
					  ,Customer.Customer.PassportNumber,Customer.Customer.BirthPlace,Customer.Customer.TaxNo,Customer.Customer.RiskLevelId,Customer.Customer.Bonus,Customer.Customer.IsTempLock,'''' as RiskLevel,Case when Customer.Customer.RiskLevelId<3 then 1 else 3 end as RiskLevelColor,CASE when DATEDIFF(DAY,GETDATE(),ISNULL(Customer.Customer.TempLockOutdate,GETDATE()))<1000 then Customer.Customer.TempLockOutdate else null end as TempLockOutdate,Customer.Customer.IsActiveChangeUser,Customer.Customer.IsActiveChangeDate,CASE when DATEDIFF(DAY,GETDATE(),ISNULL(Customer.Customer.TempLockOutdate,GETDATE()))>1000 then cast(1 as Bit) else cast(0 as bit) end IsTempLockUnlimit   '
set @sqlcommand2='FROM        Customer.Customer with (nolock) INNER JOIN
						Parameter.CustomerGroup with (nolock)  ON Customer.Customer.GroupId =  Parameter.CustomerGroup.CustomerGroupId INNER JOIN
                      Parameter.Branch with (nolock)  ON Customer.Customer.BranchId = Parameter.Branch.BranchId INNER JOIN
                      Parameter.Currency with (nolock)  ON Customer.Customer.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.Language with (nolock)  ON Customer.Customer.LanguageId = Language.Language.LanguageId INNER JOIN
                      Parameter.TimeZone with (nolock)  ON Customer.Customer.TimeZoneId = Parameter.TimeZone.TimeZoneId INNER JOIN
                      Parameter.Country with (nolock)  ON Customer.Customer.CountryId = Parameter.Country.CountryId  LEFt OUTER JOIN 
					  Customer.BonusRequest ON Customer.Bonusrequest.CustomerId=Customer.Customer.CustomerId
                      
                     '+
'WHERE (1= 1) and (Customer.Customer.IsBranchCustomer=0 or Customer.Customer.IsBranchCustomer is null)  and (Customer.Customer.IsTerminalCustomer=0 or Customer.Customer.IsTerminalCustomer is null) '+@where2+ ' and '+@where+
 ') '+  
'SELECT DISTINCT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '





execute (@sqlcommand+@sqlcommand2)
END




GO
