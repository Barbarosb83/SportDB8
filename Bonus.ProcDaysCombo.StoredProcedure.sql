USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Bonus].[ProcDaysCombo]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Bonus].[ProcDaysCombo]
@LangId int


AS



BEGIN
SET NOCOUNT ON;


SELECT    Parameter.Days.DaysId,Parameter.Days.Days,'' as Days2
from Parameter.Days



END


GO
