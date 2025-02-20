USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[Notification]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 20.03.2014
-- Description:	Avans Talep ekranındaki insert,delete,update işlemlerini yapar
-- =============================================
CREATE PROCEDURE [Users].[Notification]
@FromUserId int,
@ToUserId int,
@NotificationFormId int,
@ControlId int,
@Notification nvarchar(max)
AS

declare @UserId int
declare @FromName nvarchar(50)=''


--Slip request Notification insert
	if(@ControlId=90)
		Begin
		
		select @FromName=Name+' '+Surname from Users.Users where UserId=@FromUserId
		set @Notification='Waiting slip request'
			set nocount on
				declare cur cursor local for(
						SELECT     Users.UserRoles.UserId
			FROM         Users.RoleControls INNER JOIN
                      Users.UserRoles ON Users.RoleControls.RoleId = Users.UserRoles.RoleId
				WHERE     (Users.RoleControls.ControlId = @ControlId) AND (Users.RoleControls.IsUpdate = 1)

				)
				open cur
					fetch next from cur into @ToUserId
						while @@fetch_status=0
							begin
								begin
								
								
			
				insert Users.Notifications(FromUserId,ToUserId,NotificationFormId,ControlId,Notification,CreateDate,IsEmailSend,IsNotyRead,IsSmsSend)
				values(@FromUserId,@ToUserId,@NotificationFormId,@ControlId,@Notification,GETDATE(),0,0,0)
		
								end
							fetch next from cur into @ToUserId
							end
				close cur
				deallocate cur

		
		end
	else if(@ControlId=127) --Withdraw Request
		Begin
		
		select @FromName=Name+' '+Surname from Users.Users where UserId=@FromUserId
		set @Notification='Waiting withdraw request'
			set nocount on
				declare cur cursor local for(
						SELECT     Users.UserRoles.UserId
			FROM         Users.RoleControls INNER JOIN
                      Users.UserRoles ON Users.RoleControls.RoleId = Users.UserRoles.RoleId
				WHERE     (Users.RoleControls.ControlId = @ControlId) AND (Users.RoleControls.IsUpdate = 1)

				)
				open cur
					fetch next from cur into @ToUserId
						while @@fetch_status=0
							begin
								begin
								
								
			
				insert Users.Notifications(FromUserId,ToUserId,NotificationFormId,ControlId,Notification,CreateDate,IsEmailSend,IsNotyRead,IsSmsSend)
				values(@FromUserId,@ToUserId,@NotificationFormId,@ControlId,@Notification,GETDATE(),0,0,0)
		
								end
							fetch next from cur into @ToUserId
							end
				close cur
				deallocate cur

		
		end
	else if(@ControlId=131) --Deposit Cep Bank Request
		Begin
		
		select @FromName=Name+' '+Surname from Users.Users where UserId=@FromUserId
		set @Notification='Waiting deposit cep bank request'
			set nocount on
				declare cur cursor local for(
						SELECT     Users.UserRoles.UserId
			FROM         Users.RoleControls INNER JOIN
                      Users.UserRoles ON Users.RoleControls.RoleId = Users.UserRoles.RoleId
				WHERE     (Users.RoleControls.ControlId = @ControlId) AND (Users.RoleControls.IsUpdate = 1)

				)
				open cur
					fetch next from cur into @ToUserId
						while @@fetch_status=0
							begin
								begin
								
								
			
				insert Users.Notifications(FromUserId,ToUserId,NotificationFormId,ControlId,Notification,CreateDate,IsEmailSend,IsNotyRead,IsSmsSend)
				values(@FromUserId,@ToUserId,@NotificationFormId,@ControlId,@Notification,GETDATE(),0,0,0)
		
								end
							fetch next from cur into @ToUserId
							end
				close cur
				deallocate cur

		
		end
	else if(@ControlId=132) --Deposit Transfer Request
		Begin
		
		select @FromName=Name+' '+Surname from Users.Users where UserId=@FromUserId
		set @Notification='Waiting deposit transfer request'
			set nocount on
				declare cur cursor local for(
						SELECT     Users.UserRoles.UserId
			FROM         Users.RoleControls INNER JOIN
                      Users.UserRoles ON Users.RoleControls.RoleId = Users.UserRoles.RoleId
				WHERE     (Users.RoleControls.ControlId = @ControlId) AND (Users.RoleControls.IsUpdate = 1)

				)
				open cur
					fetch next from cur into @ToUserId
						while @@fetch_status=0
							begin
								begin
								
								
			
				insert Users.Notifications(FromUserId,ToUserId,NotificationFormId,ControlId,Notification,CreateDate,IsEmailSend,IsNotyRead,IsSmsSend)
				values(@FromUserId,@ToUserId,@NotificationFormId,@ControlId,@Notification,GETDATE(),0,0,0)
		
								end
							fetch next from cur into @ToUserId
							end
				close cur
				deallocate cur

		
		end
		else if(@ControlId=158) --Credit Card Request
		Begin
		
		select @FromName=Name+' '+Surname from Users.Users where UserId=@FromUserId
		set @Notification='Waiting credit card request'
			set nocount on
				declare cur cursor local for(
						SELECT     Users.UserRoles.UserId
			FROM         Users.RoleControls INNER JOIN
                      Users.UserRoles ON Users.RoleControls.RoleId = Users.UserRoles.RoleId
				WHERE     (Users.RoleControls.ControlId = @ControlId) AND (Users.RoleControls.IsUpdate = 1)

				)
				open cur
					fetch next from cur into @ToUserId
						while @@fetch_status=0
							begin
								begin
								
								
			
				insert Users.Notifications(FromUserId,ToUserId,NotificationFormId,ControlId,Notification,CreateDate,IsEmailSend,IsNotyRead,IsSmsSend)
				values(@FromUserId,@ToUserId,@NotificationFormId,@ControlId,@Notification,GETDATE(),0,0,0)
		
								end
							fetch next from cur into @ToUserId
							end
				close cur
				deallocate cur

		
		end
	else if(@ControlId=138) --Branch Deposit Request
		Begin
		
		select @FromName=Name+' '+Surname from Users.Users where UserId=@FromUserId
		set @Notification='Waiting branch deposit/withdraw request'
			set nocount on
				declare cur cursor local for(
						SELECT     Users.UserRoles.UserId
			FROM         Users.RoleControls INNER JOIN
                      Users.UserRoles ON Users.RoleControls.RoleId = Users.UserRoles.RoleId
				WHERE     (Users.RoleControls.ControlId = @ControlId) AND (Users.RoleControls.IsUpdate = 1) and UserId in 
				(select UserId from Users.Users where UnitCode in (Select ParentBranchId from Parameter.Branch where BranchId=@ToUserId))

				)
				open cur
					fetch next from cur into @ToUserId
						while @@fetch_status=0
							begin
								begin
								
								
			
				insert Users.Notifications(FromUserId,ToUserId,NotificationFormId,ControlId,Notification,CreateDate,IsEmailSend,IsNotyRead,IsSmsSend)
				values(@FromUserId,@ToUserId,@NotificationFormId,@ControlId,@Notification,GETDATE(),0,0,0)
		
								end
							fetch next from cur into @ToUserId
							end
				close cur
				deallocate cur

		
		end
	else if(@ControlId=139) --Branch Deposit Approved/rejected
		Begin
		
		select @FromName=Name+' '+Surname from Users.Users where UserId=@FromUserId
		set @Notification='A deposit/withdraw request has been confirmed.'
			set nocount on
				declare cur cursor local for(
						SELECT     Users.UserRoles.UserId
			FROM         Users.RoleControls INNER JOIN
                      Users.UserRoles ON Users.RoleControls.RoleId = Users.UserRoles.RoleId
				WHERE     (Users.RoleControls.ControlId = @ControlId) AND (Users.RoleControls.IsUpdate = 1)

				)
				open cur
					fetch next from cur into @ToUserId
						while @@fetch_status=0
							begin
								begin
								
								
			
				insert Users.Notifications(FromUserId,ToUserId,NotificationFormId,ControlId,Notification,CreateDate,IsEmailSend,IsNotyRead,IsSmsSend)
				values(@FromUserId,@ToUserId,@NotificationFormId,@ControlId,@Notification,GETDATE(),0,0,0)
		
								end
							fetch next from cur into @ToUserId
							end
				close cur
				deallocate cur

		
		end
	else if(@ControlId=99) --Customer Note Create
		Begin
		declare @CustomerId bigint=@ToUserId
		select @FromName=Name+' '+Surname from Users.Users where UserId=@FromUserId
		set @Notification=CAST(@CustomerId as nvarchar(10))+' Customer add note'
			set nocount on
				declare cur cursor local for(
						SELECT     Users.UserRoles.UserId
			FROM         Users.RoleControls INNER JOIN
                      Users.UserRoles ON Users.RoleControls.RoleId = Users.UserRoles.RoleId
				WHERE     (Users.RoleControls.ControlId = @ControlId) AND (Users.RoleControls.IsUpdate = 1) and  Users.UserRoles.UserId!=@FromUserId

				)
				open cur
					fetch next from cur into @ToUserId
						while @@fetch_status=0
							begin
								begin
								
								
			
				insert Users.Notifications(FromUserId,ToUserId,NotificationFormId,ControlId,Notification,CreateDate,IsEmailSend,IsNotyRead,IsSmsSend,CustomerId)
				values(@FromUserId,@ToUserId,@NotificationFormId,@ControlId,@Notification,GETDATE(),0,0,0,@CustomerId)
		
								end
							fetch next from cur into @ToUserId
							end
				close cur
				deallocate cur

		
		end
	else if(@ControlId=129) --Fraud
		Begin
		
		select @FromName=Name+' '+Surname from Users.Users where UserId=@FromUserId
		set @Notification='Fraud Notification'
			set nocount on
				declare cur cursor local for(
						SELECT     Users.UserRoles.UserId
			FROM         Users.RoleControls INNER JOIN
                      Users.UserRoles ON Users.RoleControls.RoleId = Users.UserRoles.RoleId
				WHERE     (Users.RoleControls.ControlId = @ControlId) AND (Users.RoleControls.IsSelect = 1)

				)
				open cur
					fetch next from cur into @ToUserId
						while @@fetch_status=0
							begin
								begin
								
								
			
				insert Users.Notifications(FromUserId,ToUserId,NotificationFormId,ControlId,Notification,CreateDate,IsEmailSend,IsNotyRead,IsSmsSend)
				values(@FromUserId,@ToUserId,@NotificationFormId,@ControlId,@Notification,GETDATE(),0,0,0)
		
								end
							fetch next from cur into @ToUserId
							end
				close cur
				deallocate cur

		
		end



GO
