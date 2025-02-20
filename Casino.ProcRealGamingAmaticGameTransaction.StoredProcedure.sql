USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcRealGamingAmaticGameTransaction]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Casino].[ProcRealGamingAmaticGameTransaction]
@GameId bigint,
@CustomerId bigint,
@TradeId nvarchar(250),
@BetAmount money,
@CurrencyId int,
@WinLose money,
@BetInfo nvarchar(250),
@Matrix nvarchar(250),
@IpAddress nvarchar(150),
@CreateDate datetime


AS


BEGIN
SET NOCOUNT ON;

declare @CurrencyParity money=40000
declare @AmaticGameTransactionId bigint




if(select Customer.Customer.Balance-@BetAmount
From Customer.Customer INNER JOIN 
Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.CurrencyId INNER JOIN
[Casino].[RealGaming.ParameterCurrency] ON [Casino].[RealGaming.ParameterCurrency].[ParameterCurrencyId]=Parameter.Currency.CurrencyId
where Customer.Customer.CustomerId=@CustomerId)>=0
begin

set @BetAmount=@BetAmount*@CurrencyParity
set @WinLose=@WinLose*@CurrencyParity


insert Casino.[RealGaming.AmaticGameTransaction] (
GameId
,CustomerId
,TradeId
,BetAmount
,CurrencyId
,WinLose
,BetInfo
,CreateDate
,Matrix
,IpAddress
)
values (
@GameId
,@CustomerId
,@TradeId
,@BetAmount
,@CurrencyId
,@WinLose
,@BetInfo
,@CreateDate
,@Matrix
,@IpAddress
)

set @AmaticGameTransactionId=SCOPE_IDENTITY()


declare @TransactionTypeId int=42
declare @TypeId int=1
if(@WinLose<0)
	begin
	set @TransactionTypeId=43
	set @TypeId=0
	set @WinLose=@WinLose*-1
	end

exec [Job].[FuncCustomerBooking2] @CustomerId,@WinLose,@TypeId,@TransactionTypeId,@AmaticGameTransactionId


select cast((Customer.Customer.Balance/@CurrencyParity) as decimal(18,2)) as Balance,
cast([Casino].[RealGaming.ParameterCurrency].[AmaticGameParameterCurrency] as nvarchar(3)) as currency
From Customer.Customer INNER JOIN 
Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.CurrencyId INNER JOIN
[Casino].[RealGaming.ParameterCurrency] ON [Casino].[RealGaming.ParameterCurrency].[ParameterCurrencyId]=Parameter.Currency.CurrencyId
where Customer.Customer.CustomerId=@CustomerId

end
else
begin


select cast((Customer.Customer.Balance/@CurrencyParity) as decimal(18,2)) as Balance,
cast([Casino].[RealGaming.ParameterCurrency].[AmaticGameParameterCurrency] as nvarchar(3)) as currency
From Customer.Customer INNER JOIN 
Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.CurrencyId INNER JOIN
[Casino].[RealGaming.ParameterCurrency] ON [Casino].[RealGaming.ParameterCurrency].[ParameterCurrencyId]=Parameter.Currency.CurrencyId
where Customer.Customer.CustomerId=@CustomerId

end

END





GO
