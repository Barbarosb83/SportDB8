USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcGoldenBoxBet]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Casino].[ProcGoldenBoxBet]
@CustomerId bigint,
@TicketId bigint,
@Token nvarchar(250),
@Amount money,
@Currency nvarchar(10),
@Action nvarchar(10)

AS


BEGIN
SET NOCOUNT ON;
--insert dbo.spintest values (@CustomerId,@TicketId,@Token,@Amount,@Action,getdate())
declare @CurrencyId int
declare @OldBalance  money=0
declare @OldBonus money=0
declare @CustomerCurrencyId int
declare @OrgAmount money
select @CurrencyId=Parameter.Currency.CurrencyId from Parameter.Currency where Parameter.Currency.Symbol3=@Currency

select @CustomerCurrencyId= CurrencyId from Customer.Customer where Customer.CustomerId=@CustomerId

declare @GoldenBoxTransId bigint=1
declare @Control int=0
if(select COUNT(*) from [Casino].[GoldenBox.Customertransaction] where TicketId=@TicketId and [Action]=@Action)>0
begin
	set @Control=1
end

set @OrgAmount=dbo.FuncCurrencyConverter(@Amount,@CurrencyId,@CustomerCurrencyId)


if((select Balance from Customer.Customer where CustomerId=@CustomerId)<@OrgAmount and @Action='bet')
	set @Control=1

if(@OrgAmount is null)
begin
	set @Control=1
end


if(@Action='cancel')
	begin
		if(select COUNT(*) from [Casino].[GoldenBox.Customertransaction] where TicketId=@TicketId and [Action]='win')>0
			set @Control=1
	end
if(@Amount is null)
	set @Control=1

if(@Control=0 )
begin
INSERT INTO [Casino].[GoldenBox.Customertransaction]
           ([CustomerId]
           ,[Token]
           ,[TicketId]
           ,[Amount]
           ,[CurrencyId]
           ,[CreateDate]
           ,[Action])
     VALUES (
@CustomerId
,@Token
,@TicketId
,@OrgAmount
,@CustomerCurrencyId
,GETDATE()
,@Action
)

set @GoldenBoxTransId=SCOPE_IDENTITY()


select @OldBalance= Customer.Customer.Balance
From Customer.Customer
where Customer.Customer.CustomerId=@CustomerId

declare @TransactionTypeId int=50
declare @TypeId int=0
if(@Action='win')
	begin
	set  @TransactionTypeId =51
	set @TypeId=1

	end
else if(@Action='cancel')
	begin
	set  @TransactionTypeId =52
	set @TypeId=1

	end


--select @Amount= dbo.FuncCurrencyConverter(@Amount,@CurrencyId,@CustomerCurrencyId)


exec [Job].[FuncCustomerBooking2] @CustomerId,@OrgAmount,@TypeId,@TransactionTypeId,@GoldenBoxTransId


--insert dbo.spintest  
--select @CustomerId,@TicketId,dbo.FuncCurrencyConverter(Customer.Customer.Balance,@CustomerCurrencyId,@CurrencyId) as Balance
--, dbo.FuncCurrencyConverter(@OldBalance,@CustomerCurrencyId,@CurrencyId) as OldBalance
--,@GoldenBoxTransId as TransId,GETDATE()
--From Customer.Customer INNER JOIN 
--Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.CurrencyId
--where Customer.Customer.CustomerId=@CustomerId


select dbo.FuncCurrencyConverter(Customer.Customer.Balance,@CustomerCurrencyId,@CurrencyId) as Balance
,cast(0 as money) Bonus
, dbo.FuncCurrencyConverter(@OldBalance,@CustomerCurrencyId,@CurrencyId) as OldBalance
,@OldBonus as OldBonus
,@GoldenBoxTransId as TransId
From Customer.Customer INNER JOIN 
Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.CurrencyId
where Customer.Customer.CustomerId=@CustomerId
end
else
begin
	select dbo.FuncCurrencyConverter(Customer.Customer.Balance,@CustomerCurrencyId,@CurrencyId) as Balance
	,cast(0 as money) Bonus
	,dbo.FuncCurrencyConverter(Customer.Customer.Balance,@CustomerCurrencyId,@CurrencyId) as OldBalance
	,@OldBonus as OldBonus
	,@GoldenBoxTransId as TransId
From Customer.Customer INNER JOIN 
Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.CurrencyId
where Customer.Customer.CustomerId=@CustomerId

end



END



GO
