USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcPasswordChange]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[ProcPasswordChange] 
@Username nvarchar(50),
@Password nvarchar(250), 
@NewPassword nvarchar(250),
@LangId int
AS
BEGIN
SET NOCOUNT ON;
 
 declare @resultcode int=0

if exists (Select UserId from Users.Users with (nolock) where UserName=@Username and Password=@Password)
begin
	set @resultcode=1
		update Users.Users set Password=@NewPassword where UserName=@Username
end

return @resultcode
END


GO
