USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerLogin]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
 
CREATE PROCEDURE [GamePlatform].[ProcCustomerLogin] 
@Username nvarchar(50),
@Password nvarchar(95),
@Ip nvarchar(50),
@LangId int
AS

BEGIN
SET NOCOUNT ON;
declare @CustomerId bigint=0
declare @LockCount int=5
if exists (select Customer.Customer.CustomerId from Customer.Customer with (nolock) where (Customer.Customer.UserName=@Username or Customer.Customer.Email=@Username) and Customer.Customer.Password=@Password and Customer.Customer.IsActive=1)
	Begin
		if exists (select Customer.Customer.CustomerId from  Customer.Customer with (nolock) where (Customer.Customer.UserName=@Username or Customer.Customer.Email=@Username) and Customer.Customer.Password=@Password and (Customer.Customer.IsLockedOut=0 or Customer.Customer.IsLockedOut is null) and IsTempLock=0)
			Begin
				if exists (select Customer.Customer.CustomerId from Customer.Customer with (nolock) INNER JOIN Parameter.Branch with (nolock)  ON Customer.Customer.BranchId=Parameter.Branch.BranchId where Parameter.Branch.IsActive=1 and (Customer.Customer.UserName=@Username or Customer.Customer.Email=@Username) and Customer.Customer.Password=@Password and (Customer.Customer.IsLockedOut=0 or Customer.Customer.IsLockedOut is null) and IsTempLock=0 )
				begin
				SELECT  0 AS ResultCode, 'Success' AS ResultMessage,Customer.Customer.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CurrencyId,  Parameter.Currency.Sybol, 
                      Customer.Customer.Balance, Customer.Customer.Username,  ISNULL(Customer.Customer.LastLoginDate,GETDATE()) as LastLoginDate, Customer.Customer.IpAddress, 
                      Customer.Customer.Email, Customer.Customer.Birthday, Customer.Customer.PhoneNumber, Customer.Customer.LanguageId,
                      Customer.Customer.BranchId, Customer.Customer.Password, Customer.Customer.CustomerSurname+'-'+cast(Customer.Customer.CustomerId as nvarchar(20)) as CustomerSurname,Customer.Customer.Bonus
					  ,Parameter.Currency.DecimalFormat
					  ,ISNULL((select Count(TicketId) from RiskManagement.TicketAnswers where IsRead=0 and UserId<>@CustomerId and  TicketId in (select TicketId from Riskmanagement.Ticket where CustomerId=Customer.Customer.CustomerId)),0) as UnreadTicketCount 
					   , case when Customer.BranchId<>32643 then ISNULL((Select top 1 Parameter.TaxCountry.Tax from Parameter.TaxCountry where CountryId=Customer.Customer.CountryId),0) else 0 end as TaxRate
					   ,Customer.Customer.IBAN
				FROM        Customer.Customer with (nolock)  INNER JOIN
                      Parameter.Branch with (nolock)  ON Customer.Customer.BranchId = Parameter.Branch.BranchId INNER JOIN
                      Parameter.Currency with (nolock)  ON Customer.Customer.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.Language with (nolock)  ON Customer.Customer.LanguageId = Language.Language.LanguageId 
				Where (Customer.Username=@Username or Customer.Email=@Username) and Customer.Password=@Password
				
				select @CustomerId=Customer.Customer.CustomerId
				from Customer.Customer with (nolock)  where (Customer.Username=@Username or Customer.Email=@Username) and Customer.Password=@Password
				
				update Customer.Customer set LastLoginDate=GETDATE(),FailedPasswordAttemptCount=0,IpAddress=@Ip
				where CustomerId=@CustomerId
				
				insert Customer.Ip (CustomerId,IpAddress,LoginDate)
				values(@CustomerId,@Ip,GETDATE())
				end
				else
					begin
						SELECT Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage,cast(0 as bigint) as CustomerId, '' as CustomerName, 0 as CurrencyId,'' as Sybol, 
                      cast('0' as money) as Balance,'' as Username, GETDATE() as LastLoginDate,'' as IpAddress, 
                      '' as Email, GETDATE() as Birthday, '' as PhoneNumber, 0 as LanguageId,
                      0 as BranchId, '' as Password, '' as CustomerSurname,cast('0' as money) as Bonus,'' as DecimalFormat
					  ,0 as UnreadTicketCount
					    ,cast(0 as float) as TaxRate,'' as IBAN
					FROM        Log.ErrorCodes
					where Log.ErrorCodes.ErrorCodeId=102 and Log.ErrorCodes.LangId=@LangId
					end
				
			end
		else
			begin
				SELECT Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage,cast(0 as bigint) as CustomerId, '' as CustomerName, 0 as CurrencyId,'' as Sybol, 
                      cast('0' as money) as Balance,'' as Username, GETDATE() as LastLoginDate,'' as IpAddress, 
                      '' as Email, GETDATE() as Birthday, '' as PhoneNumber, 0 as LanguageId,
                      0 as BranchId, '' as Password, '' as CustomerSurname,cast('0' as money) as Bonus,'' as DecimalFormat
					  ,0 as UnreadTicketCount
					    ,cast(0 as float) as TaxRate,'' as IBAN
					FROM        Log.ErrorCodes
					where Log.ErrorCodes.ErrorCodeId=102 and Log.ErrorCodes.LangId=@LangId
				
			end
	end
ELSE
	begin
	if exists (select Customer.Customer.CustomerId from Customer.Customer with (nolock)  where (Customer.Customer.UserName=@Username or Customer.Customer.Email=@Username) and IsActive=1)
		begin
			declare @AttempCount int=0
			
		declare @ErrorCodeId int
		declare @ErrorCode nvarchar(100)
		
		
			select @AttempCount=isnull(Customer.Customer.FailedPasswordAttemptCount,0)
			from Customer.Customer with (nolock)
			where Customer.Customer.UserName=@Username or Customer.Customer.Email=@Username
		
			if(@AttempCount+1)>=@LockCount
				begin
					update Customer.Customer set LastLockOutDate=GETDATE(),IsLockedOut=1,FailedPasswordAttemptCount=@AttempCount+1,IpAddress=@Ip,LastLoginFailedDate=GETDATE()
					where Customer.Customer.UserName=@Username or Customer.Customer.Email=@Username
					
				
					
						SELECT Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage,cast(0 as bigint) as CustomerId, '' as CustomerName, 0 as CurrencyId,'' as Sybol, 
                      cast('0' as money) as Balance,'' as Username, GETDATE() as LastLoginDate,'' as IpAddress, 
                      '' as Email, GETDATE() as Birthday, '' as PhoneNumber, 0 as LanguageId,
                      0 as BranchId, '' as Password, '' as CustomerSurname,cast('0' as money) as Bonus,'' as DecimalFormat
					  ,0 as UnreadTicketCount
  ,cast(0 as float) as TaxRate,'' as IBAN
					FROM        Log.ErrorCodes
					where Log.ErrorCodes.ErrorCodeId=102 and Log.ErrorCodes.LangId=@LangId
					
					
					
				end
			else
				begin
					update Customer.Customer set FailedPasswordAttemptCount=@AttempCount+1,IpAddress=@Ip,LastLoginFailedDate=GETDATE()
					where Customer.Customer.UserName=@Username or Customer.Customer.Email=@Username
				
				
						SELECT Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage,cast(0 as bigint) as CustomerId, '' as CustomerName, 0 as CurrencyId,'' as Sybol, 
                      cast('0' as money) as Balance,'' as Username, GETDATE() as LastLoginDate,'' as IpAddress, 
                      '' as Email, GETDATE() as Birthday, '' as PhoneNumber, 0 as LanguageId,
                      0 as BranchId, '' as Password, '' as CustomerSurname,cast('0' as money) as Bonus,'' as DecimalFormat
					  ,0 as UnreadTicketCount
					    ,cast(0 as float) as TaxRate,'' as IBAN
					FROM        Log.ErrorCodes
					where Log.ErrorCodes.ErrorCodeId=101 and Log.ErrorCodes.LangId=@LangId
				end
		end
		else
			begin
				if exists (select Customer.Customer.CustomerId from Customer.Customer with (nolock) where (Customer.Customer.UserName=@Username or Customer.Customer.Email=@Username))
				begin
				
					
					SELECT Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage,cast(0 as bigint) as CustomerId, '' as CustomerName, 0 as CurrencyId,'' as Sybol, 
                      cast('0' as money) as Balance,'' as Username, GETDATE() as LastLoginDate,'' as IpAddress, 
                      '' as Email, GETDATE() as Birthday, '' as PhoneNumber, 0 as LanguageId,
                      0 as BranchId, '' as Password, '' as CustomerSurname,cast('0' as money) as Bonus,'' as DecimalFormat
					  ,0 as UnreadTicketCount
					    ,cast(0 as float) as TaxRate,'' as IBAN
					FROM        Log.ErrorCodes
					where Log.ErrorCodes.ErrorCodeId=152 and Log.ErrorCodes.LangId=@LangId
					end
				else
					begin
							SELECT Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage,cast(0 as bigint) as CustomerId, '' as CustomerName, 0 as CurrencyId,'' as Sybol, 
                      cast('0' as money) as Balance,'' as Username, GETDATE() as LastLoginDate,'' as IpAddress, 
                      '' as Email, GETDATE() as Birthday, '' as PhoneNumber, 0 as LanguageId,
                      0 as BranchId, '' as Password, '' as CustomerSurname,cast('0' as money) as Bonus,'' as DecimalFormat
					  ,0 as UnreadTicketCount
					    ,cast(0 as float) as TaxRate,'' as IBAN
					FROM        Log.ErrorCodes
					where Log.ErrorCodes.ErrorCodeId=101 and Log.ErrorCodes.LangId=@LangId
					end
				
			end
	
		
	
	END		                 



END


GO
