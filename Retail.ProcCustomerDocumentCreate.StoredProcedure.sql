USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCustomerDocumentCreate]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcCustomerDocumentCreate] 
@CustomerId bigint,
@Document nvarchar(250),
@DocumentId int,
@LangId int

AS

BEGIN
SET NOCOUNT ON;


if not exists(select  [Customer].[Document].DocumentId from  [Customer].[Document] with (nolock) where  [Customer].[Document].CustomerId=@CustomerId and DocumentTypeId=@DocumentId )
	begin
			INSERT INTO [Customer].[Document]
           ([CustomerId]
           ,DocumentStatus
           ,DocumentFile
		   ,DocumentTypeId
           ,[CreateDate])
     VALUES
	 ( @CustomerId
	 ,1
	 ,@Document
	 ,@DocumentId
	 ,GETDATE()
)
	end
else
	begin
		delete from    [Customer].[Document] where  [Customer].[Document].CustomerId=@CustomerId and DocumentTypeId=@DocumentId
	
		INSERT INTO [Customer].[Document]
           ([CustomerId]
           ,DocumentStatus
           ,DocumentFile
		   ,DocumentTypeId
           ,[CreateDate])
     VALUES
	 ( @CustomerId
	 ,1
	 ,@Document
	 ,@DocumentId
	 ,GETDATE()
)
	end


select 1 as resultcode,'' as resultmessage




END



GO
