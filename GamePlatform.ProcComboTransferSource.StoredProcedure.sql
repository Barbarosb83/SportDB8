USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcComboTransferSource]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcComboTransferSource] 
@LangId int
AS

BEGIN
SET NOCOUNT ON;

SELECT    Parameter.TransferSource.TransferSourceId,Parameter.TransferSource.TransferSource
FROM    Parameter.TransferSource




END


GO
