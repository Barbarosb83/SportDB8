USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCashoutKeyCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCashoutKeyCombo]



AS




BEGIN
SET NOCOUNT ON;
 
 Select 1 as TypeId,'Combine' as Typ
 UNION ALL
 Select 2 as TypeId,'System' as Typ
 UNION ALL
 Select 3 as TypeId,'Multi' as Typ


  

END



GO
