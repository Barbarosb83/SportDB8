USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBranchCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcBranchCombo]
@UserBranchId int



AS




BEGIN
SET NOCOUNT ON;

select 'Alle' as BrancName, 0 as BranchId
 UNION ALL
select BrancName,BranchId From Parameter.Branch with (nolock) where Isterminal=0 and (BranchId=@UserBranchId or ParentBranchId=@UserBranchId 
or BranchId in (select BranchId from Parameter.Branch as PB with (nolock) where PB.ParentBranchId in (select BranchId from Parameter.Branch as PBB with (nolock) where PBB.ParentBranchId=@UserBranchId)))
 

END





GO
