USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcMessageCreate]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[ProcMessageCreate] 
@FromUserId int,
@ToUserId int,
@Subject nvarchar(150),
@Message nvarchar(max)

AS
BEGIN
SET NOCOUNT ON;

 
 if(@ToUserId<>0)
 begin
insert Users.[Message] (FromUserId,ToUserId,[Subject],[Message],CreateDate,IsRead,IsDeleted,IsFavorite,IsFlag)
values(@FromUserId,@ToUserId,@Subject,@Message,GETDATE(),0,0,0,1)
end
else
insert Users.[Message] (FromUserId,ToUserId,[Subject],[Message],CreateDate,IsRead,IsDeleted,IsFavorite,IsFlag)
select @FromUserId,UserId,@Subject,@Message,GETDATE(),0,0,0,1 from Users.Users where UnitCode in (Select BranchId from Parameter.Branch where IsTerminal=0 and BranchId not in (1))

select 1 as codes,'' as messages


 
END


GO
