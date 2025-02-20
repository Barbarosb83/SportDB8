USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBranchOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Retail].[ProcBranchOne]
@BranchId int


AS




BEGIN
SET NOCOUNT ON;



Select Parameter.Branch.BranchId,Parameter.Branch.BrancName,Parameter.Branch.Balance
,Parameter.Branch.CommisionRate
,Parameter.Branch.CreateDate
,Parameter.Branch.IsActive,Parameter.Branch.CurrencyId,
Parameter.Branch.BranchCommisionTypeId,
Parameter.Branch.IsTerminal as IsBonusDeducting,Parameter.Branch.MaxCopySlip,Parameter.Branch.MaxWinningLimit,
Parameter.Branch.MinTicketLimit,
Parameter.Branch.MaxEventForTicket
,Parameter.Branch.ParentBranchId
,[IsBetOn]
      ,[IsSportOn]
      ,[IsCashout]
      ,[IsLiveOn]
      ,[ShowCashoutButton]
      ,[TemporaryBet],IsJacktimeActive
,case when Parameter.Branch.IsTerminal=1 then cast(0 as bit) else Parameter.Branch.IsWebPos end as IsWebPos
,Parameter.Branch.Address,Parameter.Branch.MaxTicketLimit
,IsOnlineEnabled,Parameter.Branch.TerminalID,IsPINActive,IsPayOut,IsOnlyDeposit,Retail.TerminalConfig.IsAnonymousBet,Retail.TerminalConfig.MinStakeLimit,Retail.TerminalConfig.WorkStartTime,Retail.TerminalConfig.WorkEndTime
from Parameter.Branch INNER JOIN Retail.TerminalConfig On Retail.TerminalConfig.TerminalId=Parameter.Branch.BranchId
where Parameter.Branch.BranchId=@BranchId

END




GO
