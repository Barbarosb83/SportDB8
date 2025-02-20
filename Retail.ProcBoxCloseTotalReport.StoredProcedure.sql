USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBoxCloseTotalReport]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcBoxCloseTotalReport]
@BranchId int,
@StartDate datetime,
@EndDate datetime,
@LangId int
AS


BEGIN
SET NOCOUNT ON;

declare @TempTable table (CreateDate datetime,BranchId int,BranchName nvarchar(50),Balance money)
declare @TempTable2 table (CreateDate datetime,BranchId int,BranchName nvarchar(50),Balance money)
insert @TempTable
SELECT  
		cast([RiskManagement].[TerminalCloseBoxReport].CreateDate as date) as CreateDate
	  ,Parameter.Branch.ParentBranchId
	  ,(Select top 1 PB.BrancName from Parameter.Branch as PB where PB.BranchId=@BranchId) as BranchName
   
      ,SUM([RiskManagement].[TerminalCloseBoxReport].[Balance])
  
  FROM [RiskManagement].[TerminalCloseBoxReport] INNER JOIN Parameter.Branch ON Parameter.Branch.BranchId=[RiskManagement].[TerminalCloseBoxReport].BranchId where Parameter.Branch.ParentBranchId=@BranchId 
  and cast([RiskManagement].[TerminalCloseBoxReport].CreateDate as date)>=cast(@StartDate as date) and cast([RiskManagement].[TerminalCloseBoxReport].CreateDate as date)<=cast(@EndDate as date)
  GROUP BY cast([RiskManagement].[TerminalCloseBoxReport].CreateDate as date)  
	  ,Parameter.Branch.ParentBranchId

	  insert @TempTable
	  	  SELECT 
		  cast([RiskManagement].[BranchCloseBoxReport].[CreateDate] as date)
      ,Parameter.Branch.BranchId
	  ,Parameter.Branch.BrancName
      
      ,SUM([RiskManagement].[BranchCloseBoxReport].[Balance])
  FROM [RiskManagement].[BranchCloseBoxReport] INNER JOIN Parameter.Branch ON Parameter.Branch.BranchId=[RiskManagement].[BranchCloseBoxReport].BranchId where [RiskManagement].[BranchCloseBoxReport].BranchId=@BranchId 
  and cast([RiskManagement].[BranchCloseBoxReport].CreateDate as date)>=cast(@StartDate as date) and cast([RiskManagement].[BranchCloseBoxReport].CreateDate as date)<=cast(@EndDate as date)
  GROUP BY   Parameter.Branch.BranchId
	  ,Parameter.Branch.BrancName
   ,cast([RiskManagement].[BranchCloseBoxReport].[CreateDate] as date)

   insert @TempTable2 
   select CreateDate,BranchId,BranchName,SUM(ISNULL(Balance,0)) from @TempTable GROUP BY CreateDate,BranchId,BranchName


   select * from @TempTable2



END



GO
