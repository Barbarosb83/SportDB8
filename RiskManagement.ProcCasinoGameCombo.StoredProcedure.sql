USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCasinoGameCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcCasinoGameCombo] 

AS

BEGIN
SET NOCOUNT ON;


select Casino.[Parameter.GameSource].GameSourceId
,Casino.[Parameter.GameSource].SourceName
 from Casino.[Parameter.GameSource]



END



GO
