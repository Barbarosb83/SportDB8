USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcUsersCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcUsersCombo] 


AS


 Select UserId,Users.Users.UserName,Users.Users.Name+' '+Users.Users.Surname+'('+Users.Users.UserName+')' as Users
 from Users.Users



GO
