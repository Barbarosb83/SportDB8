USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcLogin]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Retail].[ProcLogin] 
@Username nvarchar(50),
@Password nvarchar(150),
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
                     convert(nvarchar(MAX),case when Users.Users.LastLoginDate is not null then Users.Users.LastLoginDate else GETDATE() end, 25)  as LastLoginDate, Users.Users.IpAddress, Users.Users.LastLoginFailedDate, Users.UserRoles.RoleId, 
                      Parameter.TimeZone.TimeZoneId, Parameter.TimeZone.TimeZone, Parameter.TimeZone.AddTime,Users.Users.UnitCode,Parameter.Branch.BrancName as BranchName,Parameter.Branch.IsActive as BranchIsActive,
                      Users.Users.LanguageId,Users.Users.CurrencyId,Parameter.Currency.Currency,Customer.Customer.CustomerId,Parameter.Branch.IsWebPos,ISNULL((select Tax from Parameter.TaxCountry with (nolock) where CountryId=Customer.CountryId),0) as Tax,
					  Parameter.Currency.DecimalFormat
					  ,Parameter.Branch.[Address] as BranchAddress
					  ,(Select top 1  [General].[Setting].Address from [General].[Setting]) as CompAddress,
					  Parameter.Branch.ParentBranchId, Parameter.Currency.Multiplier,Parameter.Branch.Api_url,Parameter.Branch.IsAnonymousBet
					  ,(select TaxType from Parameter.TaxCountry with (nolock) where CountryId=Customer.CountryId) as TaxTypeId
FROM         Users.UserRoles INNER JOIN
                      Users.Users ON Users.UserRoles.UserId = Users.Users.UserId AND Users.UserRoles.UserId = Users.Users.UserId INNER JOIN
                      Parameter.TimeZone ON Users.Users.TimeZoneId = Parameter.TimeZone.TimeZoneId INNER JOIN
                      Parameter.Branch ON Parameter.Branch.BranchId=Users.Users.UnitCode INNER JOIN 
					  Parameter.Currency ON Parameter.Currency.CurrencyId=Users.Users.CurrencyId INNER JOIN Customer.Customer ON
					  Customer.Customer.BranchId=Users.Users.UnitCode and Customer.Customer.IsBranchCustomer=1
WHERE     (Users.Users.UserName = @Username) AND (Users.Users.Password = @Password)

declare @UserId int=0
		update Users.Users set LastLoginDate=GETDATE(),FailedPasswordAttemptCount=0,IpAddress=@Ip,@UserId= Users.Users.UserId
	where Users.Users.UserName=@Username and Users.Users.Password=@Password

		INSERT INTO [Users].[Ip]
           ([UserId]
           ,[IpAddress]
           ,[LoginDate])
     VALUES
           (@UserId
           ,@Ip
           ,GETDATE())

	end
	else
		begin
		SELECT    Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage, cast(1 as bit) as IsLockedOut, 0 as UserId, '' as Name, '' as Surname, 
                      convert(nvarchar(MAX),GETDATE(), 25)   as LastLoginDate,'' as IpAddress,getdate() as LastLoginFailedDate,0 as RoleId,0 as TimeZoneId,'' as TimeZone,0 as AddTime,0 as UnitCode,'' as BranchName,CAST(0 as bit) as BranchIsActive,
                       0 as LanguageId,0 as CurrencyId,'' as Currency,cast(0 as bigint) as CustomerId,cast(0 as bit) as IsWebPos,cast(0 as float) as Tax,'' as DecimalFormat
					   ,'' as BranchAddress,'' as CompAddress,0 as ParentBranchId,0 as Multiplier,'' as Api_url,CAST(0 as bit) as IsAnonymousBet
					   ,cast(1 as int) as TaxTypeId
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
					
							SELECT    Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage, cast(1 as bit) as IsLockedOut, 0 as UserId, '' as Name, '' as Surname, 
                      convert(nvarchar(MAX),GETDATE(), 25) as LastLoginDate,'' as IpAddress,getdate() as LastLoginFailedDate,0 as RoleId,0 as TimeZoneId,'' as TimeZone,0 as AddTime,0 as UnitCode,'' as BranchName,CAST(0 as bit) as BranchIsActive,
                       0 as LanguageId,0 as CurrencyId,'' as Currency,cast(0 as bigint) as CustomerId,cast(0 as bit) as IsWebPos,cast(0 as float) as Tax,'' as DecimalFormat
					   ,'' as BranchAddress,'' as CompAddress,0 as ParentBranchId,0 as Multiplier,'' as Api_url,CAST(0 as bit) as IsAnonymousBet
					  ,cast(1 as int) as TaxTypeId
			FROM        Log.ErrorCodes
			where Log.ErrorCodes.ErrorCodeId=102 and LangId=1
				end
			else
				begin
					update Users.Users set FailedPasswordAttemptCount=@AttempCount+1,IpAddress=@Ip,LastLoginFailedDate=GETDATE()
					where Users.Users.UserName=@Username 
					
							SELECT    Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage, cast(1 as bit) as IsLockedOut, 0 as UserId, '' as Name, '' as Surname, 
                      convert(nvarchar(MAX),GETDATE(), 25)  as LastLoginDate,'' as IpAddress,getdate() as LastLoginFailedDate,0 as RoleId,0 as TimeZoneId,'' as TimeZone,0 as AddTime,0 as UnitCode,'' as BranchName,CAST(0 as bit) as BranchIsActive,
                       0 as LanguageId,0 as CurrencyId,'' as Currency,cast(0 as bigint) as CustomerId,cast(0 as bit) as IsWebPos,cast(0 as float) as Tax,'' as DecimalFormat
					   ,'' as BranchAddress,'' as CompAddress,0 as ParentBranchId,0 as Multiplier,'' as Api_url,CAST(0 as bit) as IsAnonymousBet
					   ,cast(1 as int) as TaxTypeId
			FROM        Log.ErrorCodes
			where Log.ErrorCodes.ErrorCodeId=101 and LangId=1
				end
		end
	else
		begin
					SELECT    Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage, cast(1 as bit) as IsLockedOut, 0 as UserId, '' as Name, '' as Surname, 
                      convert(nvarchar(MAX),GETDATE(), 25)  as LastLoginDate,'' as IpAddress,getdate() as LastLoginFailedDate,0 as RoleId,0 as TimeZoneId,'' as TimeZone,0 as AddTime,0 as UnitCode,'' as BranchName,CAST(0 as bit) as BranchIsActive,
                       0 as LanguageId,0 as CurrencyId,'' as Currency,cast(0 as bigint) as CustomerId,cast(0 as bit) as IsWebPos,cast(0 as float) as Tax,'' as DecimalFormat
					   ,'' as BranchAddress,'' as CompAddress,0 as ParentBranchId,0 as Multiplier,'' as Api_url,CAST(0 as bit) as IsAnonymousBet
					    ,cast(1 as int) as TaxTypeId
			FROM        Log.ErrorCodes
			where Log.ErrorCodes.ErrorCodeId=101 and LangId=1
		end
	
		
	
	END

END


GO
