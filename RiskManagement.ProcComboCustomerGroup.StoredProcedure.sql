USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcComboCustomerGroup]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcComboCustomerGroup]



AS




BEGIN
SET NOCOUNT ON;


select Parameter.CustomerGroup.CustomerGroupId,Parameter.CustomerGroup.GroupName
From Parameter.CustomerGroup

END

GO
