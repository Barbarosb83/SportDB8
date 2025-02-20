USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerDepositCepBankRequest]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCustomerDepositCepBankRequest]
@PageSize  INT,
@PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100)


AS




BEGIN
SET NOCOUNT ON;

declare @sqlcommand nvarchar(max)


--SELECT   0 As totalrow,Customer.DepositCepBank.DepositCepBankId, Customer.DepositCepBank.CustomerId, Customer.DepositCepBank.CepBankId, Parameter.CepBank.CepBank, 
--                      Customer.DepositCepBank.RefNoOrGsmPass, Customer.DepositCepBank.SourceTCKN, Customer.DepositCepBank.SourceGSMNo, 
--                      Customer.DepositCepBank.ReciverGSMNo, Customer.DepositCepBank.ReciverBirthday, Customer.DepositCepBank.DepositAmount, 
--                      Customer.DepositCepBank.CurrencyId, Parameter.Currency.Currency, Customer.DepositCepBank.IsBonus, Parameter.DepositStatu.DepositStatuId, 
--                      Parameter.DepositStatu.DepositStatu, Customer.DepositCepBank.CreateDate, Customer.DepositCepBank.UpdateDate, Customer.DepositCepBank.UserId, 
--                      Users.Users.Name + ' ' + Users.Users.Surname AS UserName,  Customer.Customer.CustomerName+' '+ Customer.Customer.CustomerSurname +' ( '+Customer.Customer.Username +' )' as Customer
--FROM         Customer.DepositCepBank INNER JOIN
--                      Parameter.CepBank ON Customer.DepositCepBank.CepBankId = Parameter.CepBank.CepBankId INNER JOIN
--                      Parameter.Currency ON Customer.DepositCepBank.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
--                      Parameter.DepositStatu ON Customer.DepositCepBank.DepositStatuId = Parameter.DepositStatu.DepositStatuId INNER JOIN
--                      Customer.Customer ON Customer.DepositCepBank.CustomerId = Customer.Customer.CustomerId LEFT OUTER JOIN
--                      Users.Users ON Customer.DepositCepBank.UserId = Users.Users.UserId
                      





set @sqlcommand='declare @total int '+
'select @total=COUNT(Customer.DepositCepBank.DepositCepBankId) '+
'FROM         Customer.DepositCepBank INNER JOIN
                      Parameter.CepBank ON Customer.DepositCepBank.CepBankId = Parameter.CepBank.CepBankId INNER JOIN
                      Parameter.Currency ON Customer.DepositCepBank.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Parameter.DepositStatu ON Customer.DepositCepBank.DepositStatuId = Parameter.DepositStatu.DepositStatuId INNER JOIN
                      Customer.Customer ON Customer.DepositCepBank.CustomerId = Customer.Customer.CustomerId LEFT OUTER JOIN
                      Users.Users ON Customer.DepositCepBank.UserId = Users.Users.UserId '+
'WHERE (1 = 1) and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	Customer.DepositCepBank.DepositCepBankId, Customer.DepositCepBank.CustomerId, Customer.DepositCepBank.CepBankId, Parameter.CepBank.CepBank, 
                      Customer.DepositCepBank.RefNoOrGsmPass, Customer.DepositCepBank.SourceTCKN, Customer.DepositCepBank.SourceGSMNo, 
                      Customer.DepositCepBank.ReciverGSMNo, Customer.DepositCepBank.ReciverBirthday, Customer.DepositCepBank.DepositAmount, 
                      Customer.DepositCepBank.CurrencyId, Parameter.Currency.Currency, Customer.DepositCepBank.IsBonus, Parameter.DepositStatu.DepositStatuId, 
                      Parameter.DepositStatu.DepositStatu, Customer.DepositCepBank.CreateDate, Customer.DepositCepBank.UpdateDate, Customer.DepositCepBank.UserId, 
                      Users.Users.Name + '' '' + Users.Users.Surname AS UserName,  Customer.Customer.CustomerName+'' ''+ Customer.Customer.CustomerSurname +'' ('' +Customer.Customer.Username +'' )'' as Customer '+
'FROM         Customer.DepositCepBank INNER JOIN
                      Parameter.CepBank ON Customer.DepositCepBank.CepBankId = Parameter.CepBank.CepBankId INNER JOIN
                      Parameter.Currency ON Customer.DepositCepBank.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Parameter.DepositStatu ON Customer.DepositCepBank.DepositStatuId = Parameter.DepositStatu.DepositStatuId INNER JOIN
                      Customer.Customer ON Customer.DepositCepBank.CustomerId = Customer.Customer.CustomerId LEFT OUTER JOIN
                      Users.Users ON Customer.DepositCepBank.UserId = Users.Users.UserId '+
'WHERE (1 = 1) and '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


execute (@sqlcommand)                   

END


GO
