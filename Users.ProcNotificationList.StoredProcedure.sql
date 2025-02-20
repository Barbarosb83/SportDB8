USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcNotificationList]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[ProcNotificationList] 
@ToUserId int


AS





BEGIN 
	SET NOCOUNT ON;
 
 
	select COUNT(N2.NotificationFormId) as NotyCount,U1.Name+' '+u1.Surname as UserName,U1.UnitName
	,N2.NotificationForm
	,case when U2.Name='Riskmanagement/Customer.aspx' then 'Riskmanagement/CustomerDashboard.aspx?up='+CAST(N1.CustomerId as nvarchar(10)) ELSE U2.Name end  as Link
	,[Notification]
	,IsNotyRead
	,N1.NotificationFormId
	,N1.ControlId
	,CONVERT(varchar,N1.CreateDate,104) as NotificationDate
	from Users.Notifications N1 INNER JOIN
	Users.Users U1 ON U1.UserId=N1.FromUserId INNER JOIN
	Users.NotificationForm N2 ON N2.NotificationFormId=N1.NotificationFormId INNER JOIN
	Users.Controls U2 ON U2.ControlId=N1.ControlId 
	where ToUserId=@ToUserId and (IsNotyRead=0 or IsNotyRead is null)
	Group By U1.Name,u1.Surname,U1.UnitName,N2.NotificationForm,U2.Name,[Notification],IsNotyRead,N1.NotificationFormId
	,N1.ControlId,CONVERT(varchar,N1.CreateDate,104),N1.CustomerId
	order by CONVERT(varchar,N1.CreateDate,104) desc
 
END


GO
