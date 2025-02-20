USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBranchCombo2]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcBranchCombo2]
@UserBranchId int



AS




BEGIN
SET NOCOUNT ON;

declare @TempTable table (Username nvarchar(150),BranchName nvarchar(150),BranchId int)

insert @TempTable
select (select top 1 Username from Users.Users with (nolock) where UnitCode=@UserBranchId order by UserId) as Username,'Alle' as BrancName, 0 as BranchId

insert @TempTable
select (select top 1 Username from Users.Users with (nolock) where UnitCode=Parameter.Branch.BranchId order by UserId ),BrancName,BranchId From Parameter.Branch with (nolock) where Isterminal=0 and (BranchId=@UserBranchId or ParentBranchId=@UserBranchId 
or BranchId in (select BranchId from Parameter.Branch as PB with (nolock) where PB.ParentBranchId in (select BranchId from Parameter.Branch as PBB with (nolock) where PBB.ParentBranchId=@UserBranchId)))
 Order by BrancName

 select * from @TempTable

END





GO
