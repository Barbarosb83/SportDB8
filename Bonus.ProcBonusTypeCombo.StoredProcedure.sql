USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Bonus].[ProcBonusTypeCombo]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Bonus].[ProcBonusTypeCombo]
@LangId int


AS



BEGIN
SET NOCOUNT ON;


SELECT    Parameter.BonusType.BonusTypeId,Parameter.BonusType.Type
from Parameter.BonusType



END


GO
