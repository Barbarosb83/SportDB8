USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcComboBetStatu]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcComboBetStatu]



AS




BEGIN
SET NOCOUNT ON;


select BetStatuId,BetStatu from Live.[Parameter.BetStatu]

END


GO
