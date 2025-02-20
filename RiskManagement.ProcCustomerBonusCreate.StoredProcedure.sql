USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerBonusCreate]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [RiskManagement].[ProcCustomerBonusCreate] 
@CustomerId bigint,
@CurrencyId int,
@Balance money,
@Amount money
AS

BEGIN
SET NOCOUNT ON;

declare @SystemCurrencyId int
declare @BonusName nvarchar(50)

select @SystemCurrencyId=General.Setting.SystemCurrencyId from General.Setting





declare @CustomerBonusAmount money
			
			--Müşteri bonus almayı kabul etmiş mi
			if(select Count(*) from Customer.BonusRequest where CustomerId=@CustomerId and IsEnable=1)>0
				begin
				--Müşterinin mevcut aktif bonusu varmı?
					if(select Count(*) from Customer.Bonus where CustomerId=@CustomerId and IsActive=1)=0
						begin
					--Aktif Welcome bonus varmı?
						if(select COUNT(*) from Bonus.[Rule] where cast(Bonus.[Rule].BonusStartDate as date)<=CAST(GETDATE() as date) and CAST(Bonus.[Rule].BonusEndDate as date)>CAST(GETDATE() as date)  and Bonus.[Rule].MinAmount<=@Amount and Bonus.[Rule].BonusTypeId=1 and BonusRuleId not in (Select Customer.Bonus.BonusId from Customer.Bonus where CustomerId=@CustomerId) )>0
							BEGIN
				
								declare @BonusId int=0
								select top 1  @BonusId=Bonus.[Rule].BonusRuleId,@BonusName=Bonus.[Rule].BonusName from Bonus.[Rule] where cast(Bonus.[Rule].BonusStartDate as date)<=CAST(GETDATE() as date) and CAST(Bonus.[Rule].BonusEndDate as date)>CAST(GETDATE() as date) and Bonus.[Rule].BonusTypeId=1 and BonusRuleId not in (Select Customer.Bonus.BonusId from Customer.Bonus where CustomerId=@CustomerId) order by CreateDate desc
								--Bonus bugun geçerlimi?
								if(select Bonus.RuleDays.RuleId from Bonus.RuleDays where Bonus.RuleDays.ParameterDayId in (select  DATEPART(dw,GETDATE()) ) and Bonus.RuleDays.RuleId=@BonusId)>0
									begin
										--müşteri ilk defa mı para yüklüyor?
										if(select COUNT(Customer.[Transaction].TransactionId) from Customer.[Transaction] where Customer.[Transaction].CustomerId=@CustomerId and TransactionTypeId in (1,30,32,46))=1
											begin
												declare @BonusAmount money
												declare @MaxBonusAmount money
												declare @BonusRate float
												declare @ExpriedDay int
												select top 1 @MaxBonusAmount=Bonus.[Rule].MaxAmount,@BonusRate=Bonus.[Rule].BonusRate,@ExpriedDay=Bonus.[Rule].BonusExpiredDay from Bonus.[Rule] where BonusRuleId=@BonusId
								
												if(@Amount>=dbo.FuncCurrencyConverter(@MaxBonusAmount,@SystemCurrencyId,@CurrencyId))
													set @BonusAmount=(dbo.FuncCurrencyConverter(@MaxBonusAmount,@SystemCurrencyId,@CurrencyId)/100)*@BonusRate
												else
													set @BonusAmount=(@Amount/100)*@BonusRate


													insert Customer.Bonus (CustomerId,BonusId,CreateDate,BonusAmount,ExpriedDate,IsActive,IsUsed,DepositAmount) values (@CustomerId,@BonusId,GETDATE(),@BonusAmount,DATEADD(DAY,@ExpriedDay,GETDATE()),1,0,@Amount)


													insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment)
													values(@CustomerId,@BonusAmount,@CurrencyId,GETDATE(),35,1,cast(@BonusId as nvarchar(50))+' - '+ @BonusName)

													select @CustomerBonusAmount=ISNULL(Customer.Customer.Bonus,0) from Customer.Customer where Customer.CustomerId=@CustomerId

													set @CustomerBonusAmount=@CustomerBonusAmount+@BonusAmount

													update Customer.Customer set Bonus=@CustomerBonusAmount where CustomerId=@CustomerId

											end

									end

							END
						end
				end

END



GO
