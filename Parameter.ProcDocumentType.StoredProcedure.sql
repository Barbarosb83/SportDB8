USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Parameter].[ProcDocumentType]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Parameter].[ProcDocumentType] 
@LangId int
AS

BEGIN
SET NOCOUNT ON;

Select * from Parameter.DocumentType


END



GO
