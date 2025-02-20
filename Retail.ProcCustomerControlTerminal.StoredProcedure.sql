USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCustomerControlTerminal]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcCustomerControlTerminal] 
@CustomerId bigint,
@Password nvarchar(150),
@BranchId int,
@LangId int
AS

BEGIN
SET NOCOUNT ON;
 declare @LockCount int=3
if(select COUNT(*) from Customer.Customer where (Customer.Customer.CustomerId=@CustomerId) and Customer.Customer.Password=@Password and Customer.Customer.IsActive=1)>0
	Begin
		if(select COUNT(*) from  Customer.Customer where (Customer.Customer.CustomerId=@CustomerId) and Customer.Customer.Password=@Password and (Customer.Customer.IsLockedOut=0 or Customer.Customer.IsLockedOut is null) and IsTempLock=0)>0	
			Begin
				if(select Count(*) from Customer.Customer INNER JOIN Parameter.Branch ON Customer.Customer.BranchId=Parameter.Branch.BranchId where Parameter.Branch.IsActive=1 and (Customer.Customer.CustomerId=@CustomerId) and Customer.Customer.Password=@Password and (Customer.Customer.IsLockedOut=0 or Customer.Customer.IsLockedOut is null) and IsTempLock=0 )>0
				begin
				SELECT  0 AS ResultCode, 'Success' AS ResultMessage,Customer.Customer.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CurrencyId,  Parameter.Currency.Sybol, 
                      Customer.Customer.Balance, Customer.Customer.Username,  Customer.Customer.LastLoginDate as LastLoginDate, Customer.Customer.IpAddress, 
                      Customer.Customer.Email, Customer.Customer.Birthday, Customer.Customer.PhoneNumber, Customer.Customer.LanguageId,
                      Customer.Customer.BranchId, Customer.Customer.Password, Customer.Customer.CustomerSurname+'-'+cast(Customer.Customer.CustomerId as nvarchar(20)) as CustomerSurname,Customer.Customer.Bonus
					  ,Parameter.Currency.DecimalFormat
				FROM        Customer.Customer INNER JOIN
                      Parameter.Branch ON Customer.Customer.BranchId = Parameter.Branch.BranchId INNER JOIN
                      Parameter.Currency ON Customer.Customer.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.Language ON Customer.Customer.LanguageId = Language.Language.LanguageId 
				Where (Customer.CustomerId=@CustomerId ) and Customer.Password=@Password
				
			
				--update Customer.Customer set LastLoginDate=GETDATE()
				--where (Customer.Customer.CustomerId=@CustomerId) and Customer.Customer.Password=@Password
				
				--insert Customer.Ip (CustomerId,IpAddress,LoginDate)
				--values(@CustomerId,@Ip,GETDATE())
				end
				else
					begin
						SELECT Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage,cast(0 as bigint) as CustomerId, '' as CustomerName, 0 as CurrencyId,'' as Sybol, 
                      cast('0' as money) as Balance,'' as Username, GETDATE() as LastLoginDate,'' as IpAddress, 
                      '' as Email, GETDATE() as Birthday, '' as PhoneNumber, 0 as LanguageId,
                      0 as BranchId, '' as Password, '' as CustomerSurname,cast('0' as money) as Bonus,'' as DecimalFormat
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
					FROM        Log.ErrorCodes
					where Log.ErrorCodes.ErrorCodeId=102 and Log.ErrorCodes.LangId=@LangId
				
			end
	end
ELSE
	begin
	if(select COUNT(*) from Customer.Customer where (Customer.Customer.CustomerId=@CustomerId) and IsActive=1)>0
		begin
			declare @AttempCount int=0
			
		declare @ErrorCodeId int
		declare @ErrorCode nvarchar(100)
		
		
			select @AttempCount=isnull(Customer.Customer.FailedPasswordAttemptCount,0)
			from Customer.Customer
			where Customer.Customer.CustomerId=@CustomerId
		
			if(@AttempCount+1)>=@LockCount
				begin
					update Customer.Customer set LastLockOutDate=GETDATE(),IsLockedOut=1,FailedPasswordAttemptCount=@AttempCount+1,LastLoginFailedDate=GETDATE()
					where Customer.Customer.CustomerId=@CustomerId
					
				
					
						SELECT Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage,cast(0 as bigint) as CustomerId, '' as CustomerName, 0 as CurrencyId,'' as Sybol, 
                      cast('0' as money) as Balance,'' as Username, GETDATE() as LastLoginDate,'' as IpAddress, 
                      '' as Email, GETDATE() as Birthday, '' as PhoneNumber, 0 as LanguageId,
                      0 as BranchId, '' as Password, '' as CustomerSurname,cast('0' as money) as Bonus,'' as DecimalFormat
					FROM        Log.ErrorCodes
					where Log.ErrorCodes.ErrorCodeId=102 and Log.ErrorCodes.LangId=@LangId
					
					
					
				end
			else
				begin
					update Customer.Customer set FailedPasswordAttemptCount=@AttempCount+1,LastLoginFailedDate=GETDATE()
					where Customer.Customer.CustomerId=@CustomerId 
				
				
						SELECT Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage,cast(0 as bigint) as CustomerId, '' as CustomerName, 0 as CurrencyId,'' as Sybol, 
                      cast('0' as money) as Balance,'' as Username, GETDATE() as LastLoginDate,'' as IpAddress, 
                      '' as Email, GETDATE() as Birthday, '' as PhoneNumber, 0 as LanguageId,
                      0 as BranchId, '' as Password, '' as CustomerSurname,cast('0' as money) as Bonus,'' as DecimalFormat
					FROM        Log.ErrorCodes
					where Log.ErrorCodes.ErrorCodeId=101 and Log.ErrorCodes.LangId=@LangId
				end
		end
		else
			begin
				if(select COUNT(*) from Customer.Customer where (Customer.Customer.CustomerId=@CustomerId ))>0
				begin
				
					
					SELECT Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage,cast(0 as bigint) as CustomerId, '' as CustomerName, 0 as CurrencyId,'' as Sybol, 
                      cast('0' as money) as Balance,'' as Username, GETDATE() as LastLoginDate,'' as IpAddress, 
                      '' as Email, GETDATE() as Birthday, '' as PhoneNumber, 0 as LanguageId,
                      0 as BranchId, '' as Password, '' as CustomerSurname,cast('0' as money) as Bonus,'' as DecimalFormat
					FROM        Log.ErrorCodes
					where Log.ErrorCodes.ErrorCodeId=152 and Log.ErrorCodes.LangId=@LangId
					end
				else
					begin
							SELECT Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage,cast(0 as bigint) as CustomerId, '' as CustomerName, 0 as CurrencyId,'' as Sybol, 
                      cast('0' as money) as Balance,'' as Username, GETDATE() as LastLoginDate,'' as IpAddress, 
                      '' as Email, GETDATE() as Birthday, '' as PhoneNumber, 0 as LanguageId,
                      0 as BranchId, '' as Password, '' as CustomerSurname,cast('0' as money) as Bonus,'' as DecimalFormat
					FROM        Log.ErrorCodes
					where Log.ErrorCodes.ErrorCodeId=101 and Log.ErrorCodes.LangId=@LangId
					end
				
			end
	
		
	
	END		


END


GO
