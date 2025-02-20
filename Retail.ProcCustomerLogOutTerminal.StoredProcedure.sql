USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCustomerLogOutTerminal]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [Retail].[ProcCustomerLogOutTerminal] 
@UserId int
AS
BEGIN
declare @LockCount int=3
--exec [Log].[ProcTransactionLogUID] 2,0,@Username,null,null,null,null
declare @branchId bigint


select @branchId=UnitCode from Users.Users with (nolock) where UserId=@UserId
 if exists (Select BranchId from Customer.QrCode with (nolock) where BranchId=@branchId)
	delete from Customer.QrCode where BranchId=@branchId

--if exists(select [Users].UserId from Users.Users with (nolock) where Users.Users.UserId=@UserId  and Users.Users.IsDeleted=0)
--	Begin
 
	if exists (select [Users].UserId from  Users.Users with (nolock) where Users.Users.UserId=@UserId  and IsLockedOut=0)
	begin
 
	SELECT     0 AS ResultCode, 'Branch Is Not Active' AS ResultMessage, ISNULL(Users.Users.IsLockedOut, 0) AS IsLockedOut, Users.Users.UserId, Users.Users.Name, Users.Users.Surname, 
                     CAST(null as Datetime) as LastLoginDate, Users.Users.IpAddress, Users.Users.LastLoginFailedDate, Users.UserRoles.RoleId, 
                      Parameter.TimeZone.TimeZoneId, Parameter.TimeZone.TimeZone, Parameter.TimeZone.AddTime,Users.Users.UnitCode,Parameter.Branch.BrancName as BranchName,Parameter.Branch.IsActive as BranchIsActive,
                      Users.Users.LanguageId,Users.Users.CurrencyId,Parameter.Currency.Currency,Customer.Customer.CustomerId,Parameter.Branch.IsWebPos,ISNULL((select Tax from Parameter.TaxCountry where CountryId=Customer.CountryId),0) as Tax,
					  Parameter.Currency.DecimalFormat
					  ,Parameter.Branch.[Address] as BranchAddress
					  ,(Select top 1  [General].[Setting].Address from [General].[Setting]) as CompAddress,
					  Parameter.Branch.ParentBranchId,Users.Users.UserName,Parameter.Branch.Balance
FROM         Users.UserRoles with (nolock) INNER JOIN
                      Users.Users with (nolock) ON Users.UserRoles.UserId = Users.Users.UserId AND Users.UserRoles.UserId = Users.Users.UserId INNER JOIN
                      Parameter.TimeZone with (nolock) ON Users.Users.TimeZoneId = Parameter.TimeZone.TimeZoneId INNER JOIN
                      Parameter.Branch with (nolock) ON Parameter.Branch.BranchId=Users.Users.UnitCode INNER JOIN 
					  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId=Users.Users.CurrencyId INNER JOIN Customer.Customer ON
					  Customer.Customer.BranchId=Users.Users.UnitCode and Customer.Customer.IsBranchCustomer=1
WHERE      Users.Users.UserId=@UserId 


	--	update Users.Users set LastLoginDate=GETDATE(),FailedPasswordAttemptCount=0,IpAddress=''
	--where  Users.Users.UserId=@UserId 
	end
	else
		begin
		SELECT    Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage, cast(1 as bit) as IsLockedOut, 0 as UserId, '' as Name, '' as Surname, 
                      convert(nvarchar(MAX),GETDATE(), 25)   as LastLoginDate,'' as IpAddress,getdate() as LastLoginFailedDate,0 as RoleId,0 as TimeZoneId,'' as TimeZone,0 as AddTime,0 as UnitCode,'' as BranchName,CAST(0 as bit) as BranchIsActive,
                       0 as LanguageId,0 as CurrencyId,'' as Currency,cast(0 as bigint) as CustomerId,cast(0 as bit) as IsWebPos,cast(0 as float) as Tax,'' as DecimalFormat
					   ,'' as BranchAddress,'' as CompAddress,0 as ParentBranchId,'' as UserName,cast(0 as money) as Balance
			FROM        Log.ErrorCodes with (nolock)
			where Log.ErrorCodes.ErrorCodeId=102 and LangId=1
		
		end
	--end
	--ELSE
	--begin
	--if(select COUNT(*) from Users.Users with (nolock) where  Users.Users.UserId=@UserId )>0
	--	begin
	--		declare @AttempCount int=0
			
		
	--		select @AttempCount=isnull(Users.Users.FailedPasswordAttemptCount,0)
	--		from Users.Users
	--		where  Users.Users.UserId=@UserId 
		
	--		if(@AttempCount+1)>=@LockCount
	--			begin
	--				update Users.Users set LastLockOutDate=GETDATE(),IsLockedOut=1,FailedPasswordAttemptCount=@AttempCount+1,IpAddress='',LastLoginFailedDate=GETDATE()
	--				where  Users.Users.UserId=@UserId 
					
	--						SELECT    Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage, cast(1 as bit) as IsLockedOut, 0 as UserId, '' as Name, '' as Surname, 
 --                     convert(nvarchar(MAX),GETDATE(), 25) as LastLoginDate,'' as IpAddress,getdate() as LastLoginFailedDate,0 as RoleId,0 as TimeZoneId,'' as TimeZone,0 as AddTime,0 as UnitCode,'' as BranchName,CAST(0 as bit) as BranchIsActive,
 --                      0 as LanguageId,0 as CurrencyId,'' as Currency,cast(0 as bigint) as CustomerId,cast(0 as bit) as IsWebPos,cast(0 as float) as Tax,'' as DecimalFormat
	--				   ,'' as BranchAddress,'' as CompAddress,0 as ParentBranchId,'' as UserName,cast(0 as money) as Balance
	--		FROM        Log.ErrorCodes with (nolock)
	--		where Log.ErrorCodes.ErrorCodeId=102 and LangId=1
	--			end
	--		else
	--			begin
	--				update Users.Users set FailedPasswordAttemptCount=@AttempCount+1,IpAddress='',LastLoginFailedDate=GETDATE()
	--				where  Users.Users.UserId=@UserId 
					
	--						SELECT    Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage, cast(1 as bit) as IsLockedOut, 0 as UserId, '' as Name, '' as Surname, 
 --                     convert(nvarchar(MAX),GETDATE(), 25)  as LastLoginDate,'' as IpAddress,getdate() as LastLoginFailedDate,0 as RoleId,0 as TimeZoneId,'' as TimeZone,0 as AddTime,0 as UnitCode,'' as BranchName,CAST(0 as bit) as BranchIsActive,
 --                      0 as LanguageId,0 as CurrencyId,'' as Currency,cast(0 as bigint) as CustomerId,cast(0 as bit) as IsWebPos,cast(0 as float) as Tax,'' as DecimalFormat
	--				   ,'' as BranchAddress,'' as CompAddress,0 as ParentBranchId,'' as UserName,cast(0 as money) as Balance
	--		FROM        Log.ErrorCodes with (nolock)
	--		where Log.ErrorCodes.ErrorCodeId=101 and LangId=1
	--			end
	--	end
	--else
	--	begin
	--				SELECT    Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage, cast(1 as bit) as IsLockedOut, 0 as UserId, '' as Name, '' as Surname, 
 --                     convert(nvarchar(MAX),GETDATE(), 25)  as LastLoginDate,'' as IpAddress,getdate() as LastLoginFailedDate,0 as RoleId,0 as TimeZoneId,'' as TimeZone,0 as AddTime,0 as UnitCode,'' as BranchName,CAST(0 as bit) as BranchIsActive,
 --                      0 as LanguageId,0 as CurrencyId,'' as Currency,cast(0 as bigint) as CustomerId,cast(0 as bit) as IsWebPos,cast(0 as float) as Tax,'' as DecimalFormat
	--				   ,'' as BranchAddress,'' as CompAddress,0 as ParentBranchId,'' as UserName,cast(0 as money) as Balance
	--		FROM        Log.ErrorCodes with (nolock)
	--		where Log.ErrorCodes.ErrorCodeId=101 and LangId=1
	--	end
	
		
	
	--END

END


GO
