USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcTerminalLastSlip]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Retail].[ProcTerminalLastSlip]
@BranchId bigint


AS




BEGIN
 
 declare @results bigint=0


select top 1  @results=SlipId from RiskManagement.BranchTransaction where BranchId=@BranchId and TransactionTypeId=7 order by BranchTransactionId desc



		select @results as results

END




GO
