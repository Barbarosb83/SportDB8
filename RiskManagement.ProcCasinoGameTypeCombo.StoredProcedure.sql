USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCasinoGameTypeCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [RiskManagement].[ProcCasinoGameTypeCombo] 

AS

BEGIN
SET NOCOUNT ON;


select Casino.[Parameter.GameType].ParameterGameTypeId,Casino.[Parameter.GameType].GameType from Casino.[Parameter.GameType]


END



GO
