USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Bonus].[ProcCashTypesCombo]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Bonus].[ProcCashTypesCombo]
@LangId int


AS



BEGIN
SET NOCOUNT ON;


SELECT    Parameter.CashType.CashTypeId,Parameter.CashType.CashType,'' as CashType2
from Parameter.CashType



END


GO
