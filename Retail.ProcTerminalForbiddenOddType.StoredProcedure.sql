USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcTerminalForbiddenOddType]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Retail].[ProcTerminalForbiddenOddType] 
 @BranchId bigint 
AS

BEGIN
SET NOCOUNT ON;


select ParameterOddTypeId as OddTypeId,BetTypeId  from [Parameter].[BranchForbiddenOddType] where BranchId=@BranchId



END
GO
