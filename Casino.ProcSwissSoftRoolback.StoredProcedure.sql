USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcSwissSoftRoolback]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [Casino].[ProcSwissSoftRoolback]
@SessionId  nvarchar(150),
@ActionId nvarchar(150),
@OriginalActionId nvarchar(150),
@GameId nvarchar(100)


AS


BEGIN
SET NOCOUNT ON;



declare @SwissSoftTransactionId bigint=0
declare @Amount money=0
declare @Action nvarchar(20)
declare @CustomerId bigint
declare @OrginalSwissSoftTransactionId bigint=0

select top 1 @Amount=Casino.[SwissSoft.CustomerTransaction].Amount
,@Action=Casino.[SwissSoft.CustomerTransaction].Action
,@CustomerId=Casino.[SwissSoft.CustomerTransaction].CustomerId,
@OrginalSwissSoftTransactionId=Casino.[SwissSoft.CustomerTransaction].[SwissSoftTransactionId]
from Casino.[SwissSoft.CustomerTransaction]
where Casino.[SwissSoft.CustomerTransaction].SessionId=@SessionId and Casino.[SwissSoft.CustomerTransaction].ActionId=@OriginalActionId

--------------------------------------------Para Hesaptan Düşülecek Yada Eklenecek--------------------------


insert Casino.[SwissSoft.CustomerTransaction](
CustomerId
,[SessionId]
,[Action]
,[Amount]
,[ActionId]
,[CreateDate]
,GameId
)
values (
@CustomerId
,@SessionId
,@Action
,@Amount
,@ActionId
,GETDATE()
,@GameId
)

set @SwissSoftTransactionId=SCOPE_IDENTITY()


--------------------------------------------Para Hesaptan Düşülecek Yada Eklenecek--------------------------



declare @TransactionTypeId int=41
declare @TypeId int=1
if(@Action='win')
	begin
	set @TransactionTypeId=41
	 
	set @Amount=@Amount
	end

exec [Job].[FuncCustomerBooking2] @CustomerId,@Amount,@TypeId,@TransactionTypeId,@OrginalSwissSoftTransactionId



--------------------------------------------Para Hesaptan Düşülecek Yada Eklenecek--------------------------

select Customer.Customer.Balance,
Parameter.Currency.Symbol3 as currency,@SwissSoftTransactionId as TransactionId
From Customer.Customer INNER JOIN 
Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.CurrencyId
where Customer.Customer.CustomerId=@CustomerId



END

GO
