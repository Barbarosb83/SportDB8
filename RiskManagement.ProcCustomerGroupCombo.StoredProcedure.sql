USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerGroupCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCustomerGroupCombo]



AS




BEGIN
SET NOCOUNT ON;


Select * from Parameter.CustomerGroup
                      

END


GO
