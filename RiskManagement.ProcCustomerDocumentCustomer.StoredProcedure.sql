USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerDocumentCustomer]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [RiskManagement].[ProcCustomerDocumentCustomer] 
@CustomerId bigint
AS

BEGIN
SET NOCOUNT ON;

select Customer.Document.CustomerId
,Customer.Customer.CustomerName
,Customer.Customer.CustomerSurname
,Customer.Customer.Username
,Customer.Document.CreateDate
,Customer.Document.DocumentFile
,Customer.Document.DocumentId
,Customer.Document.DocumentStatus
,Customer.Document.DocumentTypeId
,DocExpriedDate
,Parameter.DocumentState.DocumentState
,Parameter.DocumentType.DocumentType
,Customer.Document.UpdateDate
,(Select Username From Users.Users with (nolock) where UserId=Customer.Document.UpdateUserId) as UpdateUser
from Customer.Document INNER JOIN Customer.Customer with (nolock) On Customer.Customer.CustomerId=Customer.Document.CustomerId 
INNER JOIN Parameter.DocumentState with (nolock) ON Customer.Document.DocumentStatus=Parameter.DocumentState.DocumentStateId 
INNER JOIn Parameter.DocumentType with (nolock) On Customer.Document.DocumentTypeId=Parameter.DocumentType.DocumentTypeId
where Customer.Document.CustomerId=@CustomerId

END



GO
