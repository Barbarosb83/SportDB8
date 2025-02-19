USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcAvailabilityCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 03.03.2015
-- Description:	
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcAvailabilityCombo] 
@username nvarchar(max)


AS


 Select Parameter.MatchAvailability.AvailabilityId,Parameter.MatchAvailability.Availability
 from  Parameter.MatchAvailability


GO
