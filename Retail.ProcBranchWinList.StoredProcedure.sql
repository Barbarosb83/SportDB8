USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBranchWinList]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcBranchWinList]
@BranchId bigint,
@LangId int


AS




BEGIN
SET NOCOUNT ON;
 

 declare @temptab table (BranchName nvarchar(50),Amount money,WinAmount money,EventCount int)

 insert @temptab
 select PB.BrancName,Amount,Amount*TotalOddValue,EventCount 
 from Customer.Slip with (nolock) INNER JOIN Customer.Customer with (nolock)  On Customer.Customer.CustomerId=Customer.slip.CustomerId
 Inner JOIN Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId INNER JOIN
 Parameter.Branch as PB On PB.BranchId= case when Parameter.Branch.IsTerminal=1 then Parameter.Branch.ParentBranchId else Parameter.Branch.BranchId end
 where SlipTypeId<3 and SlipStateId=3 and cast(EvaluateDate as date)=CAST(GETDATE() as date)
 
  insert @temptab
  select PB.BrancName,Amount,MaxGain,EventCount 
 from Customer.SlipSystem with (nolock) INNER JOIN Customer.Customer with (nolock)  On Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId
 Inner JOIN Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
 INNER JOIN
 Parameter.Branch as PB On PB.BranchId= case when Parameter.Branch.IsTerminal=1 then Parameter.Branch.ParentBranchId else Parameter.Branch.BranchId end
 where   SlipStateId=3 and cast(EvaluateDate as date)=CAST(GETDATE() as date)





 select top 30  REPLACE(BranchName,'WettarenaO','Online') as BranchName,Amount,WinAmount,EventCount from @temptab order by WinAmount desc

END





GO
