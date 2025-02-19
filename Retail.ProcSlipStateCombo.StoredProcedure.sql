USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcSlipStateCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcSlipStateCombo] 
@username nvarchar(max),
@LangId int


AS

select 0 as StateId,' Alle' as State
UNION ALL
 Select SlipStateId as StateId,SlipState as State
 from  Language.[Parameter.SlipState] with (nolock) where SlipStateId<5 and LanguageId=@LangId


GO
