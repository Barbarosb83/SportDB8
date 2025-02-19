USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSlipEventNameCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 12.12.2018
-- Description:	
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcSlipEventNameCombo] 
@username nvarchar(max),
@LangId int


AS


  
  select Distinct TOp 100  MatchId,EventName+ case when BetTypeId=1 then ' (Live)' else '' end as EventName from Customer.SlipOdd where StateId=1 Order By EventName


GO
