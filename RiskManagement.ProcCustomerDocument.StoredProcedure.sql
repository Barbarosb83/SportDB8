USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerDocument]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [RiskManagement].[ProcCustomerDocument] 
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100)
AS

BEGIN
SET NOCOUNT ON;

declare @sqlcommand0 nvarchar(max)
declare @sqlcommand1 nvarchar(max)
declare @sqlcommand nvarchar(max)
declare @sqlcommand2 nvarchar(max)


set @sqlcommand='declare @total int '+
'select @total=COUNT(Customer.Document.CustomerId)  '+
' from Customer.Document INNER JOIN Customer.Customer with (nolock) On Customer.Customer.CustomerId=Customer.Document.CustomerId 
INNER JOIN Parameter.DocumentState with (nolock) ON Customer.Document.DocumentStatus=Parameter.DocumentState.DocumentStateId 
INNER JOIn Parameter.DocumentType with (nolock) On Customer.Document.DocumentTypeId=Parameter.DocumentType.DocumentTypeId  ' +
                      'WHERE (1 = 1) and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.Document.CustomerId) AS RowNum, '+
' Customer.Document.CustomerId
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
INNER JOIn Parameter.DocumentType with (nolock) On Customer.Document.DocumentTypeId=Parameter.DocumentType.DocumentTypeId '+
                      'WHERE (1 = 1) and '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '



--declare @total int 
--select @total=COUNT(Customer.Document.CustomerId)  
--from Customer.Document INNER JOIN Customer.Customer with (nolock) On Customer.Customer.CustomerId=Customer.Document.CustomerId 
--INNER JOIN Parameter.DocumentState with (nolock) ON Customer.Document.DocumentStatus=Parameter.DocumentState.DocumentStateId 
--INNER JOIn Parameter.DocumentType with (nolock) On Customer.Document.DocumentTypeId=Parameter.DocumentType.DocumentTypeId
--                      WHERE (1 = 1)  ; 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.Document.CustomerId) AS RowNum, 
--Customer.Document.CustomerId
--,Customer.Customer.CustomerName
--,Customer.Customer.CustomerSurname
--,Customer.Customer.Username
--,Customer.Document.CreateDate
--,Customer.Document.DocumentFile
--,Customer.Document.DocumentId
--,Customer.Document.DocumentStatus
--,Customer.Document.DocumentTypeId
--,DocExpriedDate
--,Parameter.DocumentState.DocumentState
--,Parameter.DocumentType.DocumentType
--,Customer.Document.UpdateDate
--,(Select Username From Users.Users with (nolock) where UserId=Customer.Document.UpdateUserId) as UpdateUser
--from Customer.Document INNER JOIN Customer.Customer with (nolock) On Customer.Customer.CustomerId=Customer.Document.CustomerId 
--INNER JOIN Parameter.DocumentState with (nolock) ON Customer.Document.DocumentStatus=Parameter.DocumentState.DocumentStateId 
--INNER JOIn Parameter.DocumentType with (nolock) On Customer.Document.DocumentTypeId=Parameter.DocumentType.DocumentTypeId
-- WHERE (1 = 1) 
-- )   
--SELECT *,@total as totalrow 
--  FROM OrdersRN 



execute (@sqlcommand0+@sqlcommand1+@sqlcommand)
END



GO
