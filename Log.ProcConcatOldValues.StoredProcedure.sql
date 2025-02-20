USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Log].[ProcConcatOldValues]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yusuf AVCI
-- Create date: 04-03-2014
-- Description:	Loglama için eski kayıdı tek kolona döndürme
-- =============================================
CREATE PROCEDURE [Log].[ProcConcatOldValues] 
	@tableName VARCHAR(500),
	@schemaName VARCHAR(500),
	@uniqueColumn VARCHAR(500),
	@uniqueId int,
	@returnvalue nvarchar(max) output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

    	DECLARE @s VARCHAR(max)


	SELECT @S =  ISNULL( @S+ ')' +'+'' | ''+ ','') + 'RTRIM(convert(nvarchar(50), ISNULL(' + c.name +',''''))'    FROM 
		   sys.all_columns c join sys.tables  t 
		   ON  c.object_id = t.object_id
	WHERE t.name = @tableName and t.schema_id=SCHEMA_ID(REPLACE(REPLACE(@schemaName,'[',''),']',''))

	declare @result nvarchar(max)
	declare @table table (columnVal nvarchar(max))

	insert @table
	EXEC ('SELECT  ''''+' + @s + ')+' + ''''' FROM '+@schemaName+'.['+@tableName+'] with (nolock) Where '+@uniqueColumn+'='+@uniqueId)
	
	
	--select columnVal from @table
	select @returnvalue=cast(columnVal as nvarchar(max))  from @table
	
     --@returnvalue output 

END


GO
