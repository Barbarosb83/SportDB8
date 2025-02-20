USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerDocumentControl]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [GamePlatform].[ProcCustomerDocumentControl] 
@CustomerId bigint
AS

BEGIN
SET NOCOUNT ON;

 
declare @PEPStatus int=1



 


if exists (select CustomerId from Customer.PEPControl where Customer.PEPControl.CustomerId=@CustomerId and ExpriedDate>GETDATE() and ExpriedDate is not null)
	set @PepStatus=1

	 

	select Parameter.DocumentState.DocumentStateId,Parameter.DocumentState.DocumentState,Parameter.DocumentType.DocumentType,Customer.Document.CreateDate,[Customer].[Document].DocumentFile ,@PEPStatus as PEPStatus
from [Customer].[Document] INNER JOIN Parameter.DocumentType On Customer.Document.[DocumentTypeId]=Parameter.DocumentType.DocumentTypeId INNER JOIN
Parameter.DocumentState On Customer.Document.[DocumentStatus]=Parameter.DocumentState.DocumentStateId

where CustomerId=@CustomerId




END



GO
