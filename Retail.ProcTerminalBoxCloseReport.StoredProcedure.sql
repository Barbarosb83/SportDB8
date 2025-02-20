USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcTerminalBoxCloseReport]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcTerminalBoxCloseReport]
@BranchId int,
@StartDate datetime,
@EndDate datetime,
@LangId int
AS


BEGIN
SET NOCOUNT ON;

SELECT [TerminalCloseBoxId]
      ,Parameter.Branch.[BranchId]
	  ,Parameter.Branch.ParentBranchId
	  ,(Select PB.BrancName from Parameter.Branch as PB where PB.BranchId=@BranchId) as BranchName
      ,[UserId]
      ,[Username]
      ,[RiskManagement].[TerminalCloseBoxReport].[CreateDate]
      ,[CustomerDeposit]
      ,[CustomerWithdraw]
      ,[CustomerTotal]
      ,[BetStake]
      ,[Tax]
      ,[CancelBet]
      ,[BetPayout]
      ,[BetTotal]
      ,[CreditVoucher]
      ,[RiskManagement].[TerminalCloseBoxReport].[Balance]
      ,[TransactionId]
      ,[TerminalDeposit]
      ,[TerminalWithdraw]
      ,[TerminalTotal]
  FROM [RiskManagement].[TerminalCloseBoxReport] INNER JOIN Parameter.Branch ON Parameter.Branch.BranchId=[RiskManagement].[TerminalCloseBoxReport].BranchId where Parameter.Branch.ParentBranchId=@BranchId 
  and cast([RiskManagement].[TerminalCloseBoxReport].CreateDate as date)>=cast(@StartDate as date) and cast([RiskManagement].[TerminalCloseBoxReport].CreateDate as date)<=cast(@EndDate as date)



END



GO
