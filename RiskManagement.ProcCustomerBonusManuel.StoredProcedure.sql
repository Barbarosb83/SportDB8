USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerBonusManuel]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCustomerBonusManuel] 
@Amount money,
@CustomerId bigint
as

BEGIN

	declare @TransactionType int=35
	declare @CurrencyId int=71
	declare @Username nvarchar(50)='administrator'


						declare @BonusAmount money
						declare @MaxBonusAmount money
						declare @BonusRate float
						select top 1 @MaxBonusAmount=Bonus.[Rule].MaxAmount,@BonusRate=Bonus.[Rule].BonusRate from Bonus.[Rule] where cast(Bonus.[Rule].BonusStartDate as date)<=CAST(GETDATE() as date) and CAST(Bonus.[Rule].BonusEndDate as date)>CAST(GETDATE() as date) and Bonus.[Rule].BonusTypeId=1
						if(@Amount>=@MaxBonusAmount)
							set @BonusAmount=(@MaxBonusAmount/100)*@BonusRate
						else
							set @BonusAmount=(@Amount/100)*@BonusRate


							
						EXEC	[RiskManagement].[ProcCustomerDeposit]
									@TransactionId = 0,
									@CustomerId = @CustomerId,
									@PinCode = N'''''',
									@Amount = @BonusAmount,
									@TransactionTypeId = 35,
									@CurrenyId = @CurrencyId,
									@Comments = N'''''',
									@LangId = 1,
									@username =@Username,
									@ActivityCode = 2,
									@NewValues = N''''''

end
GO
