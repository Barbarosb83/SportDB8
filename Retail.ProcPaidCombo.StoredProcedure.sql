USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcPaidCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcPaidCombo] 
@username nvarchar(max),
@LangId int


AS

select 0 as Id,' Alle' as result
UNION ALL
select 1 as Id,'Not Paid' as result
UNION ALL
select 32 as Id,'Paid' as result


GO
