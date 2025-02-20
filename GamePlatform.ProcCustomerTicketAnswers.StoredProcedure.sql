USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerTicketAnswers]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerTicketAnswers] 
@TicketId bigint
AS

BEGIN
SET NOCOUNT ON;


declare @sqlcommand nvarchar(max)


update RiskManagement.Ticket set IsRead=1 where TicketId=@TicketId

update RiskManagement.TicketAnswers set IsRead=1 where TicketId=@TicketId

SELECT [TicketAnswerId]
      ,[TicketId]
      ,[Answer]
      ,[CreateDate]
      ,case when  [UserId] is null 
	  then (select CustomerName+' '+CustomerSurname from Customer.Customer where CustomerId=(Select CustomerId from RiskManagement.Ticket where TicketId=@TicketId))
	  else (select Username from Users.Users where UserId=RiskManagement.TicketAnswers.UserId) end as ReplyUser
      ,[UploadFile]
	  ,IsRead
  FROM [RiskManagement].[TicketAnswers]
  where TicketId=@TicketId

 



END




GO
