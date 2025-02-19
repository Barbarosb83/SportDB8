USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcMatchTimeTypeCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcMatchTimeTypeCombo] 
@LangId int,
@UserName nvarchar(50)
AS

BEGIN
SET NOCOUNT ON;




select Parameter.MatchTimeType.MatchTimeTypeId,Parameter.MatchTimeType.MatchTimeType
from Parameter.MatchTimeType
Order by Parameter.MatchTimeType.MatchTimeType


END


GO
