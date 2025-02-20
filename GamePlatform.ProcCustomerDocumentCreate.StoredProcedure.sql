USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerDocumentCreate]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [GamePlatform].[ProcCustomerDocumentCreate] 
@CustomerId bigint,
@Document nvarchar(250),
@DocumentId int,
@LangId int

AS

BEGIN
SET NOCOUNT ON;



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
	


select Parameter.DocumentState.DocumentStateId,Parameter.DocumentState.DocumentState,Parameter.DocumentType.DocumentType,Customer.Document.CreateDate
from [Customer].[Document] INNER JOIN Parameter.DocumentType On Customer.Document.[DocumentTypeId]=Parameter.DocumentType.DocumentTypeId INNER JOIN
Parameter.DocumentState On Customer.Document.[DocumentStatus]=Parameter.DocumentState.DocumentStateId

where CustomerId=@CustomerId




END



GO
