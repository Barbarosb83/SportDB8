USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Bonus].[ProcBonusCustomer]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Bonus].[ProcBonusCustomer]
@CustomerId bigint,
@Amount money,
@CurrencyId int,
@CustomerCreateDate datetime,
@BonusType int --- 2 gelirse deposit bonus,1 gelirse welcome bonus


AS



BEGIN
SET NOCOUNT ON;



declare @TransactionDate datetime


if (@BonusType=2)
begin

select @TransactionDate=MAX(Customer.[Transaction].TransactionDate) From Customer.[Transaction] with (nolock) where Customer.[Transaction].CustomerId=@CustomerId and Customer.[Transaction].TransactionTypeId in (62,67,68,70,71,74,72,11,15)  


if exists (select CustomerId from Customer.Customer with (nolock) where BranchId=32643 and CustomerId=@CustomerId) 
	if(select COUNT(*) from Bonus.[Rule] INNER JOIN Bonus.RuleCashType ON Bonus.[Rule].BonusRuleId=Bonus.RuleCashType.RuleId where cast(Bonus.[Rule].BonusStartDate as date)<=CAST(GETDATE() as date) and CAST(Bonus.[Rule].BonusEndDate as date)>CAST(GETDATE() as date) and Bonus.[Rule].BonusTypeId in (1,3) and Bonus.[Rule].MinAmount<@Amount and Bonus.RuleCashType.CashTypeId=5 )>0
			BEGIN
				
				declare @BonusId int=0
				declare @BonusOccurences int=0
				declare @BonusStartDate datetime
				declare @BonusName nvarchar(50)
				select top 1  @BonusId=Bonus.[Rule].BonusRuleId,@BonusOccurences=Bonus.[Rule].BonusOccurences,@BonusStartDate=BonusStartDate,@BonusName=BonusName from Bonus.[Rule] INNER JOIN Bonus.RuleCashType ON Bonus.[Rule].BonusRuleId=Bonus.RuleCashType.RuleId where cast(Bonus.[Rule].BonusStartDate as date)<=CAST(GETDATE() as date) and CAST(Bonus.[Rule].BonusEndDate as date)>CAST(GETDATE() as date) and Bonus.[Rule].BonusTypeId=3 and Bonus.[Rule].BonusTypeId in (1,3) and Bonus.[Rule].MinAmount<@Amount and Bonus.RuleCashType.CashTypeId=5
								
				if(DATEDIFF(DAY,@CustomerCreateDate,@TransactionDate)<=180)
				if(select Count(Customer.[Transaction].TransactionId) From Customer.[Transaction] with (nolock) where Customer.[Transaction].CustomerId=@CustomerId and Customer.[Transaction].TransactionTypeId in (62,67,68,70,71,74,72,11,15) )=1
					begin
						if not exists(Select Customer.Bonus.BonusId from Customer.Bonus where CustomerId=@CustomerId and BonusId=@BonusId and (Customer.Bonus.IsUsed=0 or Customer.Bonus.IsUsed is null) and (Customer.Bonus.IsActive=0 or Customer.Bonus.IsActive is null))
						begin
						declare @BonusAmount money
						declare @MaxBonusAmount money
						declare @BonusRate float
						declare @BonusExpiredDay int
						select top 1 @MaxBonusAmount=Bonus.[Rule].MaxAmount,@BonusRate=Bonus.[Rule].BonusRate,@BonusExpiredDay=Bonus.[Rule].BonusExpiredDay from Bonus.[Rule] where Bonus.[Rule].BonusRuleId=@BonusId
						if(@Amount>=@MaxBonusAmount)
							set @BonusAmount=(@MaxBonusAmount/100)*@BonusRate
						else
							set @BonusAmount=(@Amount/100)*@BonusRate

								insert Customer.Bonus (CustomerId,BonusId,CreateDate,BonusAmount,DepositAmount,ExpriedDate,IsActive,IsUsed) values (@CustomerId,@BonusId,GETDATE(),@BonusAmount,@Amount,DATEADD(DAY,@BonusExpiredDay,GETDATE()) ,1,0)

						insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment)
						values(@CustomerId,@BonusAmount,@CurrencyId,GETDATE(),75,1,@BonusName)

						--select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer where Customer.CustomerId=@CustomerId

						--set @Balance=@Balance+@BonusAmount

						update Customer.Customer set Balance=ISNULL(Balance,0)+@BonusAmount where CustomerId=@CustomerId
						end

					end

			END
end

END


GO
