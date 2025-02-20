USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Virtual].[RiskManagement.ProcOddHistory]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Virtual].[RiskManagement.ProcOddHistory]
	@OddId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT 
	   [ChangeDate]
      ,[OutCome]
      ,[SpecialBetValue]
      ,[OddValue]
      ,[Suggestion]
      ,case when [IsActive]=1 then 'Active' else 'Passive' end as Active
      ,case when [OddResult] is null then '' else (case when [OddResult]=1 then 'Won' else 'Lost' end) end as Result
      ,[VoidFactor]
      ,case when [IsCanceled] is null then '' else (case when [IsCanceled]=1 then 'Canceled' else '' end) end as Cancelled
      ,case when [IsEvaluated] is null then '' else (case when [IsEvaluated]=1 then 'Evaluated' else '' end) end as Evaluated
      ,[OddFactor]      
  FROM [Virtual].[EventOddHistory]
  Where OddId=@OddId
    
END


GO
