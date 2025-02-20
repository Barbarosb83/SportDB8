USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcTerminalLastWithdrawCoupon]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcTerminalLastWithdrawCoupon]
@BranchId bigint


AS




BEGIN
 
 declare @TicketNo bigint=0
 declare @TicketDate datetime
declare @ParentBranchId bigint
declare @Amount decimal(18,2)
select top 1  @TicketNo=BranchTransactionId,@TicketDate=CreateDate,@Amount=Amount from RiskManagement.BranchTransaction where BranchId=@BranchId and TransactionTypeId in  (15,2) order by BranchTransactionId desc

select @ParentBranchId =ParentBranchId from Parameter.Branch where BranchId=@BranchId


		select @BranchId as BranchId,@ParentBranchId as ParentBranchId,@TicketDate as TicketDate,@TicketNo as TicketNo,@Amount as Amount

END




GO
