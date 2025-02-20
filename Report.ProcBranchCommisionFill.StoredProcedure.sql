USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Report].[ProcBranchCommisionFill]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[ProcBranchCommisionFill]   
  
as 

BEGIN TRAN

declare @BranchId int
declare @CurrencyId int
declare @BranchCommisionTypeId int
declare  @IsBonusDeducting bit
declare @ReportDate datetime=dateadd(DAY,-1,GETDATE())


declare @Value1 money
declare @Value2 money
declare @CommissionRate float
declare @BetTypeId int

declare @amount money
declare @Turnover money
declare @Hold money


delete from BranchCommission where ReportDate=@ReportDate


--set nocount on
--					declare cur111 cursor local for(
--						SELECT BranchId,CurrencyId,BranchCommisionTypeId,IsBonusDeducting 
--						from Parameter.Branch 
--						where Parameter.Branch.BranchId!=1 and IsActive=1

--						)

--					open cur111
--					fetch next from cur111 into @BranchId,@CurrencyId,@BranchCommisionTypeId ,@IsBonusDeducting
--					while @@fetch_status=0
--						begin
--							begin
							
--								insert Report.BranchCommission(BranchId,CustomerId,BetTypeId,SlipId,Turnover,Hold,CurrencyId,ReportDate)
								
--select @BranchId,Customer.Customer.CustomerId,Customer.SLipOdd.BetTypeId,Customer.Slip.SlipId,
--								ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.SlipOdd.Amount),Customer.Slip.CurrencyId,@CurrencyId),0)
--								-
--								ISNULL((

--								select ISNULL(dbo.FuncCurrencyConverter(SUM(cslo.Amount),csl.CurrencyId,@CurrencyId),0)
--								from Customer.Customer as cs INNER JOIN
--								Customer.Slip as csl ON cs.CustomerId=csl.CustomerId INNER JOIN
--								Customer.SlipOdd as cslo ON cslo.SlipId=csl.SlipId
--								where cast(csl.CreateDate as date)=cast(@ReportDate as date) and cs.CustomerId=Customer.Customer.CustomerId and cslo.BetTypeId=Customer.SLipOdd.BetTypeId and csl.SlipStateId=2 
--								GROUP BY csl.CurrencyId
--								),0
--								) as TurnOver,

--								ISNULL((

--								select ISNULL(dbo.FuncCurrencyConverter(SUM(cslo.Amount),csl.CurrencyId,@CurrencyId),0)
--								from Customer.Customer as cs INNER JOIN
--								Customer.Slip as csl ON cs.CustomerId=csl.CustomerId INNER JOIN
--								Customer.SlipOdd as cslo ON cslo.SlipId=csl.SlipId and cslo.SlipId=Customer.Slip.SlipId
--								where cast(csl.CreateDate as date)=cast(@ReportDate as date) and cs.CustomerId=Customer.Customer.CustomerId and cslo.BetTypeId=Customer.SLipOdd.BetTypeId 
--								GROUP BY csl.CurrencyId
--								),0
--								)
--								-
--								ISNULL((

--								select ISNULL(dbo.FuncCurrencyConverter(SUM(cslo.Amount)*EXP(SUM(LOG(cslo.OddValue))),csl.CurrencyId,@CurrencyId),0)
--								from Customer.Customer as cs INNER JOIN
--								Customer.Slip as csl ON cs.CustomerId=csl.CustomerId INNER JOIN
--								Customer.SlipOdd as cslo ON cslo.SlipId=csl.SlipId and cslo.SlipId=Customer.Slip.SlipId
--								where cast(csl.CreateDate as date)=cast(@ReportDate as date) and cs.CustomerId=Customer.Customer.CustomerId and cslo.BetTypeId=Customer.SLipOdd.BetTypeId  and csl.SlipStateId in (3,5,6)
--								GROUP BY csl.CurrencyId
--								),0
--								) as Hold,@CurrencyId,@ReportDate

--								From Customer.Customer INNER JOIN Customer.Slip ON
--								Customer.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
--								Customer.SlipOdd ON Customer.SlipOdd.SlipId=Customer.SLip.SlipId
--								where cast(Customer.Slip.CreateDate as date)=cast(@ReportDate as DATE) and Customer.Slip.SlipStateId<>2 and Customer.Customer.BranchId=@BranchId
--								GROUP BY Customer.Customer.CustomerId,Customer.SLipOdd.BetTypeId,Customer.Slip.CurrencyId,Customer.Slip.SlipId
							
						
							

--							end
--							fetch next from cur111 into @BranchId,@CurrencyId,@BranchCommisionTypeId ,@IsBonusDeducting
			
--						end
--					close cur111
--					deallocate cur111	



COMMIT TRAN



GO
