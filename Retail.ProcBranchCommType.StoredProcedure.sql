USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBranchCommType]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcBranchCommType]



AS




BEGIN
SET NOCOUNT ON;


select Parameter.BranchCommisionType.BranchCommisionTypeId,Parameter.BranchCommisionType.CommissionType 
from Parameter.BranchCommisionType with (nolock)

END




GO
