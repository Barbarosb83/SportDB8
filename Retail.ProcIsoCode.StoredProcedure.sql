USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcIsoCode]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcIsoCode]
@IsoCode nvarchar(10),
@LangId int
AS


BEGIN
SET NOCOUNT ON;

select * from Parameter.Iso where IsoName3=@IsoCode  

END
GO
