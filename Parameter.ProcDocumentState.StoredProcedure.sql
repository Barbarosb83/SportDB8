USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Parameter].[ProcDocumentState]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Parameter].[ProcDocumentState] 
@LangId int
AS

BEGIN
SET NOCOUNT ON;

Select * from Parameter.DocumentState


END



GO
