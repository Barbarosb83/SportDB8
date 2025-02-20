USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Log].[ProcErrorLogUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Bahadır Babalı>
-- Create date: <28.02.2014>
-- Description:	<ekranlarda alınan hataları loglar>
-- =============================================
CREATE PROCEDURE [Log].[ProcErrorLogUID]
@Username nvarchar(max),
@MethodName nvarchar(max),
@SpName nvarchar(max),
@Message nvarchar(max),
@StackTrace nvarchar(max),
@Parameters nvarchar(max) 
 
AS
BEGIN 
	SET NOCOUNT ON;

    
	--if (@MethodName<>'SendEmail')
		insert Log.ErrorLog(Username,MethodName,SpName,[Message],StackTrace,[Parameters],CreateDate)
			    values(@Username,@MethodName,@SpName,@Message,@StackTrace,@Parameters,GETDATE())
	
		if(@MethodName='CashoutHandler')
			delete from Live.EventOddProb
	
	
	
END


GO
