USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBranchUserCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcBranchUserCombo] 
@BranchId bigint,
@UserBranchId int
AS

BEGIN
SET NOCOUNT ON;


if(@BranchId!=0)
begin
select 0 as UserId,'' as UserName
UNION ALL
select UserId,UserName from Users.Users where UnitCode=@BranchId
end
else
begin

select 0 as UserId,'' as UserName
UNION ALL
select UserId,UserName from Users.Users where UnitCode in (select BranchId from Parameter.Branch where (BranchId=@UserBranchId or ParentBranchId=@UserBranchId or ParentBranchId in (select BranchId from Parameter.Branch  where (BranchId=@UserBranchId or ParentBranchId=@UserBranchId) )))
end

END





GO
