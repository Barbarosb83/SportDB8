USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [RiskManagement].[ProcCustomerOne]
@CustomerId bigint


AS




BEGIN
SET NOCOUNT ON;


SELECT  Customer.Customer.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CurrencyId, Parameter.Currency.Currency, Parameter.Currency.Sybol, 
                      Customer.Customer.Balance, Customer.Customer.Username,Customer.Customer.CreateDate
                      ,Customer.Customer.LastLoginDate, Customer.Customer.IpAddress, 
                      Customer.Customer.Email, Customer.Customer.Birthday, Customer.Customer.PhoneNumber, Customer.Customer.LanguageId, Language.Language.Language, 
                      Parameter.Branch.BranchId, Parameter.Branch.BrancName, Customer.Customer.Password, Customer.Customer.CustomerSurname, Customer.Customer.IsActive, 
                      Customer.Customer.OddsFormatId as OddsFormatId, Customer.Customer.PhoneCodeId, Customer.Customer.SalutationId, Customer.Customer.CountryId, 
                      Customer.Customer.TimeZoneId, Customer.Customer.Address, Customer.Customer.AddressAdditional, Customer.Customer.ZipCode, 
                      case when (Select Count(*) from Customer.[Card] where Customer.[Card].CustomerId=@CustomerId)>0 then cast(1 as bit) else cast(0 as bit) end as IsOddDecreasements, Customer.Customer.IsOddIncreasement, Customer.Customer.City, cast( ISNULL(Customer.Customer.IsOddDecreasements,0) as int) as PasswordQuestionId, 
                      Customer.BirthPlace as PasswordQuestion, Parameter.Salutation.Salutation, Parameter.Country.Country, '' as OddsFormatName, 
                      Parameter.PhoneCode.PhoneCode, Parameter.TimeZone.TimeZone,Customer.PasswordQuestion as PasswordAnswer,Parameter.CustomerGroup.GroupName as GroupName,Parameter.CustomerGroup.CustomerGroupId as GroupId
                      ,Customer.Customer.IsLockedOut,Customer.Customer.FailedPasswordAttemptCount,Customer.Customer.IsVerification,Customer.Customer.IdNumber
					  ,Customer.Customer.PassportNumber,Customer.Customer.BirthPlace,Customer.Customer.TaxNo,Customer.Customer.RiskLevelId,Parameter.RiskLevel.RiskLevel,Customer.Customer.IsTempLock as IsPromotion ,CASE when DATEDIFF(DAY,GETDATE(),ISNULL(Customer.Customer.TempLockOutdate,GETDATE()))>1000 then cast(1 as Bit) else cast(0 as bit) end IsTempLockUnlimit,Customer.Customer.IsTempLock
					  ,(Select Customer.BonusRequest.BonusStartDate from Customer.BonusRequest where Customer.BonusRequest.CustomerId=Customer.Customer.CustomerId) as BonusStartDate
FROM         Customer.Customer INNER JOIN
Parameter.CustomerGroup ON Customer.Customer.GroupId =  Parameter.CustomerGroup.CustomerGroupId INNER JOIN
                      Parameter.Branch ON Customer.Customer.BranchId = Parameter.Branch.BranchId left outer JOIN
                      Parameter.Currency ON Customer.Customer.CurrencyId = Parameter.Currency.CurrencyId left outer JOIN
                      Language.Language ON Customer.Customer.LanguageId = Language.Language.LanguageId left outer JOIN
                      Parameter.TimeZone ON Customer.Customer.TimeZoneId = Parameter.TimeZone.TimeZoneId left outer JOIN
                      Parameter.Country ON Customer.Customer.CountryId = Parameter.Country.CountryId left outer JOIN
                     
                     
                      Parameter.PhoneCode ON Customer.Customer.PhoneCodeId = Parameter.PhoneCode.PhoneCodeId left outer JOIN
                      Parameter.Salutation ON Customer.Customer.SalutationId = Parameter.Salutation.SalutationId INNER JOIN
					  Parameter.RiskLevel ON Parameter.RiskLevel.RiskLevelId=Customer.Customer.RiskLevelId 
Where Customer.CustomerId=@CustomerId
                      

END



GO
