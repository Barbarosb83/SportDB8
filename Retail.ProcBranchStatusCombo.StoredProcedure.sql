USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBranchStatusCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcBranchStatusCombo] 

AS

BEGIN
SET NOCOUNT ON;

select -1 as [BranchStatusId],'' as [BranchStatus]
UNION ALL
SELECT [BranchStatusId]
      ,[BranchStatus]
  FROM [Parameter].[Branchstatus] with (nolock)


END





GO
