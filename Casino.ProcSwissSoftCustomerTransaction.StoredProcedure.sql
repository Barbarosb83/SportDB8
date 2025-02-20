USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcSwissSoftCustomerTransaction]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Casino].[ProcSwissSoftCustomerTransaction]
@CustomerId bigint,
@SessionId nvarchar(150),
@Action nvarchar(50),
@Amount money,
@CurrencyId int,
@ActionId nvarchar(150),
@GameId nvarchar(100)


AS


BEGIN
SET NOCOUNT ON;

declare @TransactionTypeId int=42
declare @TypeId int=1
declare @CurrencyParity money=1
declare @SwissSoftTransactionId bigint=0
declare @CustomerCurrencyId int


INSERT INTO [dbo].[spintest]
           ([CustomerID]
           ,[GameId]
           ,[TransId]
           ,[Amount]
           ,[CreateDate])
     VALUES(@CustomerId,@SessionId,@Action,@Amount,Getdate())


select @CustomerCurrencyId=CurrencyId from Customer.Customer where CustomerId=@CustomerId

if(@Action<>'win')
begin
if((select dbo.FuncCurrencyConverter(Customer.Customer.Balance,Customer.Customer.CurrencyId,3)-@Amount
From Customer.Customer
where Customer.Customer.CustomerId=@CustomerId)>=0)
begin


if(select COUNT(Casino.[SwissSoft.CustomerTransaction].SwissSoftTransactionId) from Casino.[SwissSoft.CustomerTransaction] where CustomerId=@CustomerId and ActionId=@ActionId and [Action]=@Action)=0
begin

set @Amount=dbo.FuncCurrencyConverter(@Amount,3,@CustomerCurrencyId)

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



set @TransactionTypeId =42
set @TypeId =1
if(@Action='bet')
begin
set @TransactionTypeId=43
	 set @TypeId=0
set @Amount=@Amount
end

exec [Job].[FuncCustomerBooking2] @CustomerId,@Amount,@TypeId,@TransactionTypeId,@SwissSoftTransactionId

--------------------------------------------Para Hesaptan Düşülecek Yada Eklenecek--------------------------
end
else
begin
select @SwissSoftTransactionId= Casino.[SwissSoft.CustomerTransaction].SwissSoftTransactionId from Casino.[SwissSoft.CustomerTransaction] where CustomerId=@CustomerId and ActionId=@ActionId
end

select cast(dbo.FuncCurrencyConverter(Customer.Customer.Balance,Customer.Customer.CurrencyId,3) as decimal(18,2)) as Balance,
Parameter.Currency.Symbol3 as currency,@SwissSoftTransactionId as TransactionId
From Customer.Customer INNER JOIN 
Parameter.Currency ON Parameter.Currency.CurrencyId=3
where Customer.Customer.CustomerId=@CustomerId

end

else
begin



select cast('-1' as decimal(18,2)) as Balance,
Parameter.Currency.Symbol3 as currency,@SwissSoftTransactionId as TransactionId
From Customer.Customer INNER JOIN 
Parameter.Currency ON Parameter.Currency.CurrencyId=3
where Customer.Customer.CustomerId=@CustomerId
end

end
else
begin


if(select COUNT(Casino.[SwissSoft.CustomerTransaction].SwissSoftTransactionId) from Casino.[SwissSoft.CustomerTransaction] where CustomerId=@CustomerId and ActionId=@ActionId and [Action]=@Action)=0
begin

set @Amount=dbo.FuncCurrencyConverter(@Amount,3,@CustomerCurrencyId)

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



set @TransactionTypeId =42
set @TypeId =1
if(@Action='bet')
begin
set @TransactionTypeId=43
	 set @TypeId=0
set @Amount=@Amount
end

exec [Job].[FuncCustomerBooking2] @CustomerId,@Amount,@TypeId,@TransactionTypeId,@SwissSoftTransactionId

--------------------------------------------Para Hesaptan Düşülecek Yada Eklenecek--------------------------
end
else
begin
select @SwissSoftTransactionId= Casino.[SwissSoft.CustomerTransaction].SwissSoftTransactionId from Casino.[SwissSoft.CustomerTransaction] where CustomerId=@CustomerId and ActionId=@ActionId
end

select cast(dbo.FuncCurrencyConverter(Customer.Customer.Balance,Customer.Customer.CurrencyId,3) as decimal(18,2)) as Balance,
Parameter.Currency.Symbol3 as currency,@SwissSoftTransactionId as TransactionId
From Customer.Customer INNER JOIN 
Parameter.Currency ON Parameter.Currency.CurrencyId=3
where Customer.Customer.CustomerId=@CustomerId

end

END





GO
