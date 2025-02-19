USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcProfitCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcProfitCombo] 
@username nvarchar(max),
@LangId int


AS

select 0 as Id,' ' as result
UNION ALL
select 1 as Id,'All' as result
UNION ALL
select 2 as Id,'Profit' as result
UNION ALL
select 3 as Id,'Lost' as result


GO
