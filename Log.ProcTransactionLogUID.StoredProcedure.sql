USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Log].[ProcTransactionLogUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Bahadır Babalı>
-- Create date: <28.02.2014>
-- Description:	<ekranlarda yapılan tüm işlemleri loglar>
-- =============================================
CREATE PROCEDURE [Log].[ProcTransactionLogUID]
@SpDescriptionId int,
@TransactionTypeId int,
@Username nvarchar(50),
@RowId int,
@TableName nvarchar(50),
@NewValues nvarchar(max),
@OldValues nvarchar(max)

AS
BEGIN 
	SET NOCOUNT ON;

    
	insert Log.TransactionLog(SpDescriptionId,TransactionTypeId,Username,RowId,TableName,CreateDate,
							  NewValues,OldValues)
					   values(@SpDescriptionId,@TransactionTypeId,@Username,@RowId,@TableName,GETDATE(),
							  @NewValues,@OldValues)
	
	
	
	
	
END


GO
