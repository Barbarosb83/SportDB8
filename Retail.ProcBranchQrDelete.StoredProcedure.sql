USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBranchQrDelete]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [Retail].[ProcBranchQrDelete]
@BranchId bigint,
@LangId int



AS




BEGIN
SET NOCOUNT ON;

     delete from  [Customer].[QrCode] where [BranchId]=@BranchId

		select 1


 

END





GO
