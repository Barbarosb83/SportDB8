USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Dashboard].[ProcWithdrawStats]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Dashboard].[ProcWithdrawStats] 
@Username nvarchar(50)
AS

BEGIN
SET NOCOUNT ON;


declare @UserCurrencyId int
declare @UserBranchId int
select @UserCurrencyId=Users.Users.CurrencyId,
@UserBranchId=Users.Users.UnitCode
from Users.Users 
 where Users.Users.UserName=@Username

  
declare @OpenWithdraw money
declare @ApprovWithdraw money
declare @RejectWithdraw money


select @OpenWithdraw=SUM(Amount) from RiskManagement.WithdrawRequest with (nolock) where IsApproved is null

select @ApprovWithdraw=SUM(Amount) from RiskManagement.WithdrawRequest with (nolock) where IsApproved=1

select @RejectWithdraw=SUM(Amount) from RiskManagement.WithdrawRequest with (nolock) where IsApproved=0

 
 select @OpenWithdraw as OpenWithdraw
 ,@ApprovWithdraw as ApprovWithdraw
 ,@RejectWithdraw as RejectWithdraw


END




GO
