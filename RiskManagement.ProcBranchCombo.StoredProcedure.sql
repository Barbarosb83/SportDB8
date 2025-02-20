USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcBranchCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcBranchCombo]
@UserId int


AS




BEGIN
SET NOCOUNT ON;

declare @UserBrancId int

select @UserBrancId= UnitCode from Users.Users where Users.Users.UserId=@UserId



if(@UserBrancId=1)
begin
		Select Parameter.Branch.BranchId,Parameter.Branch.BrancName,Parameter.Branch.Balance
		,Parameter.Branch.CommisionRate
		,Parameter.Branch.CreateDate
		,Parameter.Branch.IsActive,Parameter.Branch.CurrencyId,
		Parameter.Branch.BranchCommisionTypeId,
		Parameter.Branch.IsBonusDeducting,Parameter.Branch.MaxCopySlip,Parameter.Branch.MaxWinningLimit,
		Parameter.Branch.MinTicketLimit,
		Parameter.Branch.MaxEventForTicket
		,Parameter.Branch.ParentBranchId
		from Parameter.Branch where IsTerminal=0
end
else
	begin
		Select Parameter.Branch.BranchId,Parameter.Branch.BrancName,Parameter.Branch.Balance
		,Parameter.Branch.CommisionRate
		,Parameter.Branch.CreateDate
		,Parameter.Branch.IsActive,Parameter.Branch.CurrencyId,
		Parameter.Branch.BranchCommisionTypeId,
		Parameter.Branch.IsBonusDeducting,Parameter.Branch.MaxCopySlip,Parameter.Branch.MaxWinningLimit,
		Parameter.Branch.MinTicketLimit,
		Parameter.Branch.MaxEventForTicket
		,Parameter.Branch.ParentBranchId
		from Parameter.Branch
		where (ParentBranchId=@UserBrancId or BranchId=@UserBrancId) and IsTerminal=0
end

 

END



GO
