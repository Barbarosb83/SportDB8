USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcLogin]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[ProcLogin] 
@Username nvarchar(50),
@Password nvarchar(95),
@Ip nvarchar(50)
AS
BEGIN
declare @LockCount int=3
--exec [Log].[ProcTransactionLogUID] 2,0,@Username,null,null,null,null

if(select COUNT(*) from Users.Users where Users.Users.UserName=@Username and Users.Users.Password=@Password and Users.Users.IsDeleted=0)>0
	Begin
 
	if(select COUNT(*) from  Users.Users where Users.Users.UserName=@Username and Users.Users.Password=@Password and (IsLockedOut=0 or IsLockedOut is null))>0
	begin
 
	SELECT     0 AS ResultCode, 'Branch Is Not Active' AS ResultMessage, ISNULL(Users.Users.IsLockedOut, 0) AS IsLockedOut, Users.Users.UserId, Users.Users.Name, Users.Users.Surname, 
                       Users.Users.LastLoginDate, Users.Users.IpAddress, Users.Users.LastLoginFailedDate, Users.UserRoles.RoleId, 
                      Parameter.TimeZone.TimeZoneId, Parameter.TimeZone.TimeZone, Parameter.TimeZone.AddTime,Users.Users.UnitCode,Parameter.Branch.BrancName as BranchName,Parameter.Branch.IsActive as BranchIsActive,
                      Users.Users.LanguageId,Users.Users.CurrencyId,Parameter.Currency.Currency
FROM         Users.UserRoles INNER JOIN
                      Users.Users ON Users.UserRoles.UserId = Users.Users.UserId AND Users.UserRoles.UserId = Users.Users.UserId INNER JOIN
                      Parameter.TimeZone ON Users.Users.TimeZoneId = Parameter.TimeZone.TimeZoneId INNER JOIN
                      Parameter.Branch ON Parameter.Branch.BranchId=Users.Users.UnitCode INNER JOIN 
					  Parameter.Currency ON Parameter.Currency.CurrencyId=Users.Users.CurrencyId
WHERE     (Users.Users.UserName = @Username) AND (Users.Users.Password = @Password)


		update Users.Users set LastLoginDate=GETDATE(),FailedPasswordAttemptCount=0,IpAddress=@Ip
	where Users.Users.UserName=@Username and Users.Users.Password=@Password
	end
	else
		begin
		SELECT    Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage, cast(1 as bit) as IsLockedOut, 0 as UserId, null as Name, null as Surname, 
                      getdate() as LastLoginDate,null as IpAddress,getdate() as LastLoginFailedDate,0 as RoleId,0 as TimeZoneId,null as TimeZone,0 as AddTime,0 as UnitCode,'' as BranchName,CAST(0 as bit) as BranchIsActive,
                       0 as LanguageId,0 as CurrencyId,'' as Currency
			FROM        Log.ErrorCodes
			where Log.ErrorCodes.ErrorCodeId=102 and LangId=1
		
		end
	end
	ELSE
	begin
	if(select COUNT(*) from Users.Users where Users.Users.UserName=@Username)>0
		begin
			declare @AttempCount int=0
			
		
			select @AttempCount=isnull(Users.Users.FailedPasswordAttemptCount,0)
			from Users.Users
			where Users.Users.UserName=@Username
		
			if(@AttempCount+1)>=@LockCount
				begin
					update Users.Users set LastLockOutDate=GETDATE(),IsLockedOut=1,FailedPasswordAttemptCount=@AttempCount+1,IpAddress=@Ip,LastLoginFailedDate=GETDATE()
					where Users.Users.UserName=@Username 
					
							SELECT    Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage, cast(1 as bit) as IsLockedOut, 0 as UserId, null as Name, null as Surname, 
                      getdate() as LastLoginDate,null as IpAddress,getdate() as LastLoginFailedDate,0 as RoleId,0 as TimeZoneId,null as TimeZone,0 as AddTime,0 as UnitCode,'' as BranchName,CAST(0 as bit) as BranchIsActive,
                       0 as LanguageId,0 as CurrencyId,'' as Currency
			FROM        Log.ErrorCodes
			where Log.ErrorCodes.ErrorCodeId=102
				end
			else
				begin
					update Users.Users set FailedPasswordAttemptCount=@AttempCount+1,IpAddress=@Ip,LastLoginFailedDate=GETDATE()
					where Users.Users.UserName=@Username 
					
							SELECT    Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage, cast(1 as bit) as IsLockedOut, 0 as UserId, null as Name, null as Surname, 
                      getdate() as LastLoginDate,null as IpAddress,getdate() as LastLoginFailedDate,0 as RoleId,0 as TimeZoneId,null as TimeZone,0 as AddTime,0 as UnitCode,'' as BranchName,CAST(0 as bit) as BranchIsActive,
                       0 as LanguageId,0 as CurrencyId,'' as Currency
			FROM        Log.ErrorCodes
			where Log.ErrorCodes.ErrorCodeId=101 and LangId=1
				end
		end
	else
		begin
					SELECT    Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage, cast(1 as bit) as IsLockedOut, 0 as UserId, null as Name, null as Surname, 
                      getdate() as LastLoginDate,null as IpAddress,getdate() as LastLoginFailedDate,0 as RoleId,0 as TimeZoneId,null as TimeZone,0 as AddTime,0 as UnitCode,'' as BranchName,CAST(0 as bit) as BranchIsActive,
                       0 as LanguageId,0 as CurrencyId,'' as Currency
			FROM        Log.ErrorCodes
			where Log.ErrorCodes.ErrorCodeId=101 and LangId=1
		end
	
		
	
	END

END


GO
