USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcComboBetType]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcComboBetType]



AS




BEGIN
SET NOCOUNT ON;


select Parameter.BetType.BetTypeId,Parameter.BetType.BetType from Parameter.BetType

END


GO
