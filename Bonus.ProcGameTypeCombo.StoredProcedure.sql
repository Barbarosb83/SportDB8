USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Bonus].[ProcGameTypeCombo]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Bonus].[ProcGameTypeCombo]
@LangId int


AS



BEGIN
SET NOCOUNT ON;


SELECT    Parameter.GameType.GameTypeId,Parameter.GameType.GameType
from Parameter.GameType



END


GO
