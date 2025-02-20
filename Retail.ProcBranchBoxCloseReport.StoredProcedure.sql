USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBranchBoxCloseReport]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcBranchBoxCloseReport]
@BranchId int,
@StartDate datetime,
@EndDate datetime,
@LangId int
AS


BEGIN
SET NOCOUNT ON;

SELECT [BranchCloseBoxId]
      ,Parameter.Branch.BranchId
	  ,Parameter.Branch.BrancName
      ,[UserId]
      ,[Username]
      ,[RiskManagement].[BranchCloseBoxReport].[CreateDate]
      ,[CustomerDeposit]
      ,[CustomerWithdraw]
      ,[CustomerTotal]
      ,[BetStake]
      ,[Tax]
      ,[CancelBet]
      ,[BetPayout]
      ,[BetTotal]
      ,[CreditVoucher]
      ,[RiskManagement].[BranchCloseBoxReport].[Balance]
  FROM [RiskManagement].[BranchCloseBoxReport] with (nolock) INNER JOIN Parameter.Branch with (nolock) ON Parameter.Branch.BranchId=[RiskManagement].[BranchCloseBoxReport].BranchId where [RiskManagement].[BranchCloseBoxReport].BranchId=@BranchId and cast([RiskManagement].[BranchCloseBoxReport].CreateDate as date)>=cast(@StartDate as date) and cast([RiskManagement].[BranchCloseBoxReport].CreateDate as date)<=cast(@EndDate as date)



END



GO
