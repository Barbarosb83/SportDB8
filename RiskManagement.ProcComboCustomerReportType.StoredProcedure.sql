USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcComboCustomerReportType]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcComboCustomerReportType] 
@UserId int
AS

BEGIN
SET NOCOUNT ON;


declare @StartDate date
declare @EndDate date
declare @UserCurrencyId int

select @UserCurrencyId=CurrencyId from Users.Users where UserId=@UserId


declare @TempTable table(TypeId int,TransactionType nvarchar(150))


insert @TempTable
	select 1,'Last 24H Win Customer'

insert @TempTable
	select 2,'Last 24H Lost Customer'

insert @TempTable
	select 3,'Last 24H New Customer'

insert @TempTable
	select 4,'Last 24H Deposit'

insert @TempTable
	select 5,'Last 24H Withdraw'

insert @TempTable
	select 6,'Last 24H Sum Deposit > 1000€'

insert @TempTable
	select 7,'Single Transaction > 1000€'
insert @TempTable
	select 8,'Customers hitting €2000 deposits in 180 days'
insert @TempTable
	select 9,'Customer using high risk payment methods'
insert @TempTable
	select 10,'IP mismatch within last 7 days'
insert @TempTable
	select 11,'Bets Stake> Deposit+Withdrawal last 7 days'
insert @TempTable
	select 12,'Last Login 30 day ago and Balance>0'
insert @TempTable
	select 13,'Large Volume Won'
insert @TempTable
	select 14,'Customer sum deposits >= €2000'
insert @TempTable
	select 15,'Customer sum withdraw >= €2000'
insert @TempTable
	select 16,'Last Login 11 months ago '
insert @TempTable
	select 17,'suspicious transactions '

select * from @TempTable



END


GO
