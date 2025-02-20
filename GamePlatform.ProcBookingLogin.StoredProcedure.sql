USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcBookingLogin]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcBookingLogin] 
@CustomerId bigint

AS

BEGIN
SET NOCOUNT ON;


declare @Deposit money=0
declare @WithDraw money=0
declare @OpenBet int
declare @WinBet money=0
declare @LostBet money
declare @TotalBet money=0
declare @Balance money=0
declare @Bonus money=0

select @Balance= Balance from Customer.Customer with (nolock) where CustomerId=@CustomerId

select @Deposit=ISNULL( SUM(Customer.[Transaction].Amount) ,0)
from Customer.[Transaction] with (nolock) INNER JOIN 
Parameter.TransactionType with (nolock) ON Customer.[Transaction].TransactionTypeId=Parameter.TransactionType.TransactionTypeId
where Customer.[Transaction].CustomerId=@CustomerId 
and Parameter.TransactionType.Direction=1 and Parameter.TransactionType.TransactionTypeId  not in (3,5,42,40,38,8,35,44,51,52,54,63,4) 
and Customer.[Transaction].TransactionDate>DATEADD(MONTH,-1,GETDATE())


select @WithDraw=ISNULL( SUM(Customer.[Transaction].Amount) ,0)
from Customer.[Transaction] with (nolock) 
where Customer.[Transaction].CustomerId=@CustomerId 
and Customer.[Transaction].TransactionTypeId in (2,31,60,65)
and Customer.[Transaction].TransactionDate>DATEADD(MONTH,-1,GETDATE())

select @Bonus=ISNULL( SUM(Customer.[Transaction].Amount) ,0)
from Customer.[Transaction] with (nolock) 
where Customer.[Transaction].CustomerId=@CustomerId 
and Customer.[Transaction].TransactionTypeId in (35)
and Customer.[Transaction].TransactionDate>DATEADD(MONTH,-1,GETDATE())

select @WinBet=ISNULL( SUM(Customer.[Transaction].Amount) ,0)
from Customer.[Transaction]  with (nolock)
where Customer.[Transaction].CustomerId=@CustomerId 
and Customer.[Transaction].TransactionTypeId in (3,63)
and Customer.[Transaction].TransactionDate>DATEADD(MONTH,-1,GETDATE())


select @LostBet= ISNULL(SUM(Customer.[Transaction].Amount),0)
from Customer.[Transaction]  with (nolock)
where Customer.[Transaction].CustomerId=@CustomerId 
and Customer.[Transaction].TransactionTypeId in (4,53)
and Customer.[Transaction].TransactionDate>DATEADD(MONTH,-1,GETDATE())

select @TotalBet=@WinBet - @LostBet

select @OpenBet=ISNULL(COUNT(SlipId),0) from Customer.Slip with (nolock) where SlipStateId=1 and CustomerId=@CustomerId and Customer.Slip.CreateDate>DATEADD(MONTH,-1,GETDATE())


select @Deposit as Deposit,@WinBet as WinAmount,@LostBet as LostAmount,@WithDraw as Withdraw,@TotalBet as TotalBet,@OpenBet as OpenCount,@Balance as Balance,@Bonus as Bonus


END


GO
