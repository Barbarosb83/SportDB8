USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcStateCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 03.03.2015
-- Description:	
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcStateCombo] 
@username nvarchar(max),
@LangId int


AS


 Select Parameter.MatchState.StateId,Parameter.MatchState.State
 from  Parameter.MatchState


GO
