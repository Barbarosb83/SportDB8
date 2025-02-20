USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcTicketAnswers]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcTicketAnswers] 
@TicketId bigint,
@PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100)
AS

BEGIN
SET NOCOUNT ON;


declare @sqlcommand nvarchar(max)


update RiskManagement.TicketAnswers set IsRead=1 where TicketId=@TicketId

SELECT [TicketAnswerId]
      ,[TicketId]
      ,[Answer]
      ,[CreateDate]
      ,case when  [UserId] is null 
	  then (select CustomerName+' '+CustomerSurname from Customer.Customer where CustomerId=(Select CustomerId from RiskManagement.Ticket where TicketId=@TicketId))
	  else (select Username from Users.Users where UserId=RiskManagement.TicketAnswers.UserId) end as ReplyUser
      ,[UploadFile]
  FROM [RiskManagement].[TicketAnswers]
  where TicketId=@TicketId

 



--set @sqlcommand='declare @total int '+
--'select @total=COUNT(Customer.Ip.CustomerIpId) '+
--'FROM        Customer.Ip '+
--'WHERE     (Customer.Ip.CustomerId = '+cast(@CustomerId as nvarchar(10))+' ) and  '+@where+' ;' +
--'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.Ip.LoginDate) AS RowNum,  '+
--'CustomerIpId,CustomerId,IpAddress,dbo.UserTimeZoneDate('''+@Username+''', LoginDate ,0) as LoginDate '+
--'FROM         Customer.Ip '+
--'WHERE   IpAddress is not null and  IpAddress<>'''' and  (Customer.Ip.CustomerId  = '+cast(@CustomerId as nvarchar(10))+') and  '+@where+
-- ' ) '+  
--'SELECT *,@total as totalrow '+
--  'FROM OrdersRN '+
-- ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


execute (@sqlcommand)  

END




GO
