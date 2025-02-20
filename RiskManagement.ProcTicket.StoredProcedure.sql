USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcTicket]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcTicket] 
@PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100)
AS

BEGIN
SET NOCOUNT ON;


declare @sqlcommand nvarchar(max)


--select RiskManagement.Ticket.TicketId
--,RiskManagement.Ticket.Subject
--,RiskManagement.Ticket.Description
--,RiskManagement.Ticket.CreateDate
--,RiskManagement.Ticket.TicketStatusId 
--,RiskManagement.Ticket.UploadFile
--from RiskManagement.Ticket INNER JOIN Parameter.TicketStatus On
--Parameter.TicketStatus.TicketStatusId=RiskManagement.Ticket.TicketStatusId 
 

 
--declare @total int 

--select @total=COUNT( RiskManagement.Ticket.TicketId) 
--FROM       RiskManagement.Ticket INNER JOIN Parameter.TicketStatus On
--Parameter.TicketStatus.TicketStatusId=RiskManagement.Ticket.TicketStatusId  ; 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY RiskManagement.Ticket.TicketId) AS RowNum,
-- RiskManagement.Ticket.TicketId
--,RiskManagement.Ticket.Subject
--,RiskManagement.Ticket.Description
--,RiskManagement.Ticket.CreateDate
--,RiskManagement.Ticket.TicketStatusId 
--,RiskManagement.Ticket.UploadFile
--,RiskManagement.Ticket.CustomerId
--,Customer.Customer.CustomerName+' '+Customer.CustomerSurname+'('+Customer.Customer.Username+')' as Customer
--FROM         RiskManagement.Ticket INNER JOIN Parameter.TicketStatus On
--Parameter.TicketStatus.TicketStatusId=RiskManagement.Ticket.TicketStatusId INNER JOIN Customer.Customer On
--Customer.Customer.CustomerId=RiskManagement.Ticket.CustomerId
--)  
--SELECT *,@total as totalrow 
--FROM OrdersRN 
--WHERE RowNum BETWEEN ((@PageNum-1 )*(@PageSize))+1 AND (@PageNum * @PageSize ) 




set @sqlcommand='declare @total int '+
'select @total=COUNT(RiskManagement.Ticket.TicketId) '+
'FROM       RiskManagement.Ticket INNER JOIN Parameter.TicketStatus On
Parameter.TicketStatus.TicketStatusId=RiskManagement.Ticket.TicketStatusId INNER JOIN Customer.Customer On
Customer.Customer.CustomerId=RiskManagement.Ticket.CustomerId '+
'WHERE    1=1  and  '+@where+ ' ;' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum,  '+
'  RiskManagement.Ticket.TicketId
,RiskManagement.Ticket.Subject
,RiskManagement.Ticket.Description
,RiskManagement.Ticket.CreateDate
,RiskManagement.Ticket.TicketStatusId 
,REPLACE(SUBSTRING(UploadFile,CHARINDEX(''support/'',UploadFile),LEN(UploadFile)),''support/'','''') as UploadFile ,RiskManagement.Ticket.CustomerId
,Customer.Customer.CustomerName+'' ''+Customer.CustomerSurname +''(''+Customer.Customer.Username+'')'' as Customer
,Parameter.TicketStatus.TicketStatus '+
'FROM         RiskManagement.Ticket INNER JOIN Parameter.TicketStatus On
Parameter.TicketStatus.TicketStatusId=RiskManagement.Ticket.TicketStatusId  INNER JOIN Customer.Customer On
Customer.Customer.CustomerId=RiskManagement.Ticket.CustomerId '+
'WHERE   1=1 and  '+@where+
 ' ) '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


execute (@sqlcommand)  

END




GO
