USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcBranchCommisionCalculate]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcBranchCommisionCalculate]   
@StartDate datetime,
@EndDate datetime,
@BranchId int,
@UserName nvarchar(100)
as 

BEGIN TRAN

declare @CurrencyId int
declare @BranchCommisionTypeId int
declare  @IsBonusDeducting bit


declare @Value1 money
declare @Value2 money
declare @CommissionRate float
declare @BetTypeId int

declare @amount money
declare @Turnover money
declare @Hold money



SELECT @CurrencyId=CurrencyId,@BranchCommisionTypeId=BranchCommisionTypeId 
						from Parameter.Branch 
						where Parameter.Branch.BranchId=@BranchId and IsActive=1




set nocount on
					declare cur cursor local for(
						SELECT Value1,Value2,CommissionRate,BetTypeId
						from RiskManagement.BranchValueCommission
						where RiskManagement.BranchValueCommission.BranchId=@BranchId

						)

					open cur
					fetch next from cur into @Value1,@Value2,@CommissionRate,@BetTypeId
					while @@fetch_status=0
						begin
							begin
								
								set nocount on
					declare cur1 cursor local for(
						SELECT SUM(Turnover),SUM(Hold)
						from Report.BranchCommission
						where Report.BranchCommission.BranchId=@BranchId and cast(ReportDate as date)>=cast(@StartDate as DATE)
						and cast(ReportDate as date)<=cast(@EndDate as DATE)
						and BetTypeId=@BetTypeId

						)

					open cur1
					fetch next from cur1 into @Turnover,@Hold
					while @@fetch_status=0
						begin
							begin
								
								if(@BranchCommisionTypeId=1) --Turnover
									begin
										if(@Value1<@Turnover and @Turnover<=@Value2)
											begin
												
												
												set @amount=@Turnover*(@CommissionRate/100)
												insert Report.BranchCommissionBalance(BranchId,Amount,CurrencyId,BetTypeId,StartDate,EndDate,IsPaid)
												values(@BranchId,@amount,@CurrencyId,@BetTypeId,@StartDate,@EndDate,0)
											
											end
										
										
									end
								else if(@BranchCommisionTypeId=2) --Hold
									begin
										if(@Value1<@Hold and @Hold<=@Value2)
											begin
											
												
												set @amount=@Hold*(@CommissionRate/100)
												insert Report.BranchCommissionBalance(BranchId,Amount,CurrencyId,BetTypeId,StartDate,EndDate,IsPaid)
												values(@BranchId,@amount,@CurrencyId,@BetTypeId,@StartDate,@EndDate,0)
											
											end
										
										
									end
								
								
							end
							fetch next from cur1 into @Turnover,@Hold
			
						end
					close cur1
					deallocate cur1
								
								
								
								
							end
							fetch next from cur into @Value1,@Value2,@CommissionRate,@BetTypeId
			
						end
					close cur
					deallocate cur
							



COMMIT TRAN


GO
