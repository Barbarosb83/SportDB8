USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCustomerOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Retail].[ProcCustomerOne]
@CustomerId bigint


AS




BEGIN
SET NOCOUNT ON;



select [CustomerId]
      ,[SalutationId]
      ,[CustomerName]
      ,[CurrencyId]
      ,[Balance]
      ,[Username]
      ,[Password]
      ,[CreateDate]
      ,[LastLoginDate]
      ,[LastPasswordChangeDate]
      ,[FailedPasswordAttemptCount]
      ,[IpAddress]
      ,[LastLoginFailedDate]
      ,[IsLockedOut]
      ,[CustomerSurname]
      ,[Email]
      ,[Birthday]
      ,[PhoneCodeId]
      ,[PhoneNumber]
      ,[LanguageId]
      ,[BranchId]
      ,[IsActive]
      ,[LastLockOutDate]
      ,[TimeZoneId]
      ,1 as [OddsFormatId]
      ,[CountryId]
      ,[PasswordQuestionId]
      ,[PasswordQuestion]
      ,[ZipCode]
      ,[Address]
      ,[AddressAdditional]
      ,[IsOddIncreasement]
      ,[IsOddDecreasements]
      ,[City]
      ,[IsTempLock]
      ,[TempLockOutdate]
      ,[RecoveryCode]
      ,[RecoveryDate]
      ,[GroupId]
      ,[Bonus]
      ,[IsVerification]
      ,[IsBranchCustomer]
      ,[IsTerminalCustomer]
      ,[IdNumber]
      ,[PassportNumber]
      ,[BirthPlace]
      ,[TaxNo]
      ,[RiskLevelId]
      ,[SourceId]
      ,[IsPromotion]
      ,[IsActiveChangeUser]
      ,[IsActiveChangeDate]
      ,[ChangeTempLockOutDate]
      ,[CountryOfBirth]
      ,[Nationalty]
      ,[OasisId]
      ,[AccountLockReason]
,(Select top 1  Customer.[Document].DocumentFile from   Customer.[Document] with (nolock) where   Customer.[Document].CustomerId=Customer.Customer.CustomerId and  Customer.[Document].DocumentTypeId=4 order by CreateDate) as Document1
  ,(Select top 1  Customer.[Document].DocumentFile from   Customer.[Document] with (nolock) where   Customer.[Document].CustomerId=Customer.Customer.CustomerId and  Customer.[Document].DocumentTypeId=1 order by CreateDate desc) as Document2
  

 from Customer.Customer where CustomerId=@CustomerId
                      

END



GO
