USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerDepositTransferRequest]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCustomerDepositTransferRequest]
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


--SELECT   0 As totalrow,Customer.DepositTransfer.DepositTransferId, Customer.DepositTransfer.CustomerId, Customer.DepositTransfer.TransferDateTime, 
--                      Customer.DepositTransfer.TransferSourceId, Customer.DepositTransfer.CustomerNote, Customer.DepositTransfer.TransferBankId, 
--                      Customer.DepositTransfer.TransferBankAcountId, Customer.DepositTransfer.DepositAmount, Customer.DepositTransfer.CurrencyId, 
--                      Customer.DepositTransfer.IsBonus, Customer.DepositTransfer.DepositStatuId, Customer.DepositTransfer.CreateDate, Customer.DepositTransfer.UpdateDate, 
--                      Customer.DepositTransfer.UserId, Parameter.Currency.Currency, Parameter.DepositStatu.DepositStatu, Parameter.Bank.Bank, 
--                      Parameter.TransferSource.TransferSource, Parameter.BankAccount.IBAN, Parameter.BankAccount.Name + ' ' + Parameter.BankAccount.Surname AS BankAcountName, 
--                      Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname AS CustomerName, 
--                      Users.Users.Name + ' ' + Users.Users.Surname AS UserName
--FROM         Customer.DepositTransfer INNER JOIN
--                      Parameter.TransferSource ON Customer.DepositTransfer.TransferSourceId = Parameter.TransferSource.TransferSourceId INNER JOIN
--                      Parameter.Bank ON Customer.DepositTransfer.TransferBankId = Parameter.Bank.BankId INNER JOIN
--                      Parameter.BankAccount ON Parameter.Bank.BankId = Parameter.BankAccount.BankId AND 
--                      Customer.DepositTransfer.TransferBankAcountId = Parameter.BankAccount.BankAccountId INNER JOIN
--                      Parameter.Currency ON Customer.DepositTransfer.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
--                      Parameter.DepositStatu ON Customer.DepositTransfer.DepositStatuId = Parameter.DepositStatu.DepositStatuId INNER JOIN
--                      Customer.Customer ON Customer.DepositTransfer.CustomerId = Customer.Customer.CustomerId LEFT OUTER JOIN
--                      Users.Users ON Customer.DepositTransfer.UserId = Users.Users.UserId





set @sqlcommand='declare @total int '+
'select @total=COUNT(Customer.DepositTransfer.DepositTransferId) '+
'FROM         Customer.DepositTransfer INNER JOIN
                      Parameter.TransferSource ON Customer.DepositTransfer.TransferSourceId = Parameter.TransferSource.TransferSourceId INNER JOIN
                      Parameter.Bank ON Customer.DepositTransfer.TransferBankId = Parameter.Bank.BankId INNER JOIN
                      Parameter.BankAccount ON Parameter.Bank.BankId = Parameter.BankAccount.BankId AND 
                      Customer.DepositTransfer.TransferBankAcountId = Parameter.BankAccount.BankAccountId INNER JOIN
                      Parameter.Currency ON Customer.DepositTransfer.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Parameter.DepositStatu ON Customer.DepositTransfer.DepositStatuId = Parameter.DepositStatu.DepositStatuId INNER JOIN
                      Customer.Customer ON Customer.DepositTransfer.CustomerId = Customer.Customer.CustomerId LEFT OUTER JOIN
                      Users.Users ON Customer.DepositTransfer.UserId = Users.Users.UserId '+
'WHERE (1 = 1) and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '
set @sqlcommand2= '	Customer.DepositTransfer.DepositTransferId, Customer.DepositTransfer.CustomerId,dbo.UserTimeZoneDate('''+@Username+''', Customer.DepositTransfer.TransferDateTime,0) as TransferDateTime, 
                      Customer.DepositTransfer.TransferSourceId,(select PaymentType from Parameter.PaymentType where TransactionTypeId= Customer.DepositTransfer.TransactionTypeId) as CustomerNote, Customer.DepositTransfer.TransferBankId, 
                      Customer.DepositTransfer.TransferBankAcountId, Customer.DepositTransfer.DepositAmount, Customer.DepositTransfer.CurrencyId, 
                      Customer.DepositTransfer.IsBonus, case when (select RiskLevelId from Parameter.PaymentType where TransactionTypeId= Customer.DepositTransfer.TransactionTypeId)<3 then 1 else 3 end as DepositStatuId,dbo.UserTimeZoneDate('''+@Username+''', Customer.DepositTransfer.CreateDate,0)  as CreateDate,dbo.UserTimeZoneDate('''+@Username+''',Customer.DepositTransfer.UpdateDate,0) as UpdateDate, 
                      Customer.DepositTransfer.UserId, Parameter.Currency.Currency, Parameter.DepositStatu.DepositStatu, Parameter.Bank.Bank, 
                      Parameter.TransferSource.TransferSource, Parameter.BankAccount.IBAN, Parameter.BankAccount.Name + '' '' + Parameter.BankAccount.Surname AS BankAcountName, 
                      Customer.Customer.CustomerName + '' '' + Customer.Customer.CustomerSurname+ ''('' + Customer.Customer.Username+'')'' AS CustomerName, 
                      Users.Users.Name + '' '' + Users.Users.Surname AS UserName,Customer.DepositTransfer.UserComment,case when Customer.DepositTransfer.DepositAmount<2000 then 1 else 3 end as StatuColor '+
'FROM         Customer.DepositTransfer INNER JOIN
                      Parameter.TransferSource ON Customer.DepositTransfer.TransferSourceId = Parameter.TransferSource.TransferSourceId INNER JOIN
                      Parameter.Bank ON Customer.DepositTransfer.TransferBankId = Parameter.Bank.BankId INNER JOIN
                      Parameter.BankAccount ON Parameter.Bank.BankId = Parameter.BankAccount.BankId AND 
                      Customer.DepositTransfer.TransferBankAcountId = Parameter.BankAccount.BankAccountId INNER JOIN
                      Parameter.Currency ON Customer.DepositTransfer.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Parameter.DepositStatu ON Customer.DepositTransfer.DepositStatuId = Parameter.DepositStatu.DepositStatuId INNER JOIN
                      Customer.Customer ON Customer.DepositTransfer.CustomerId = Customer.Customer.CustomerId LEFT OUTER JOIN
                      Users.Users ON Customer.DepositTransfer.UserId = Users.Users.UserId '+
'WHERE (1 = 1) and '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


execute (@sqlcommand+@sqlcommand2)                   

END


GO
