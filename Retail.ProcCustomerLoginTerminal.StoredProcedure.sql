USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCustomerLoginTerminal]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Retail].[ProcCustomerLoginTerminal] 
@UserId int,
@BranchId int,
@CustomerId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;
 declare @CustomerBranchId int=0

 select @CustomerBranchId=Customer.Customer.BranchId from Customer.Customer with (nolock) where CustomerId=@CustomerId

 --if not exists(Select Customer.Card.CustomerCardId from Customer.Card with (nolock) where CustomerId=@CustomerId)
	--  INSERT INTO [Customer].[Card] ([CustomerId],[UserId],[CreateDate])  VALUES (@CustomerId,@UserId,GETDATE())
		 
declare @LockCount int=3
if(select COUNT(*) from Customer.Customer with (nolock) where (Customer.Customer.CustomerId=@CustomerId and Customer.Customer.IsActive=1)
)>0
	Begin
		if(select COUNT(*) from  Customer.Customer with (nolock) where (Customer.Customer.CustomerId=@CustomerId)  and (Customer.Customer.IsLockedOut=0 or Customer.Customer.IsLockedOut is null) and IsTempLock=0)>0	
			Begin
				if(select Count(*) from Customer.Customer with (nolock) INNER JOIN Parameter.Branch ON Customer.Customer.BranchId=Parameter.Branch.BranchId where Parameter.Branch.IsActive=1 and Customer.Customer.CustomerId=@CustomerId and (Customer.Customer.IsLockedOut=0 or Customer.Customer.IsLockedOut is null) and IsTempLock=0 )>0
				begin
					if(@CustomerBranchId=@BranchId or (Select Parameter.Branch.ParentBranchId from Parameter.Branch with (nolock) where BranchId=@BranchId)=@CustomerBranchId)
					begin
						SELECT  1 AS ResultCode, 'Success' AS ResultMessage,Customer.Customer.CustomerId, Customer.Customer.Username as CustomerName, Customer.Customer.CurrencyId,  Parameter.Currency.Sybol, 
							  Customer.Customer.Balance, (select UserName from Users.Users where UserId=@UserId) as Username,  Customer.Customer.LastLoginDate as LastLoginDate, Customer.Customer.IpAddress, 
							  Customer.Customer.Email, Customer.Customer.Birthday, Customer.Customer.PhoneNumber, Customer.Customer.LanguageId,
							  @BranchId as BranchId, Customer.Customer.Password, Customer.Customer.CustomerSurname+'-'+cast(Customer.Customer.CustomerId as nvarchar(20)) as CustomerSurname,Customer.Customer.Bonus
							  ,Parameter.Currency.DecimalFormat,(select ParentBranchId from Parameter.Branch where BranchId=@BranchId) as ParentBranchId,case when Customer.IsActive=1 then cast(1 as int) else cast(0 as int) end as TimeZoneId
							  ,@UserId as UserId,Parameter.Currency.Currency,ISNULL((select Tax from Parameter.TaxCountry where CountryId=(select top 1 Customer.CountryId from Customer.Customer where BranchId=@BranchId and IsTerminalCustomer=1)),0) as Tax
							  ,(Select top 1  [General].[Setting].Address from [General].[Setting]) as CompAddress,(select Parameter.Branch.[Address] from Parameter.Branch where BranchId=@BranchId) as BranchAddress
						FROM        Customer.Customer with (nolock) INNER JOIN
							  Parameter.Currency with (nolock) ON Customer.Customer.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
							  Language.Language with (nolock) ON Customer.Customer.LanguageId = Language.Language.LanguageId 
						Where Customer.Customer.CustomerId=@CustomerId


						  INSERT INTO [Customer].[QrCodeLog]
				   ([BranchId]
				   ,[CustomerId]
				   ,[CreateDate],Comment)
			 VALUES (@BranchId,@CustomerId,GETDATE(),'CardLogin')


					end
					else
						begin
							SELECT  -1 AS ResultCode, 'Success' AS ResultMessage,Customer.Customer.CustomerId, Customer.Customer.Username as CustomerName, Customer.Customer.CurrencyId,  Parameter.Currency.Sybol, 
							  Customer.Customer.Balance, (select UserName from Users.Users where UserId=@UserId) as Username,  Customer.Customer.LastLoginDate as LastLoginDate, Customer.Customer.IpAddress, 
							  Customer.Customer.Email, Customer.Customer.Birthday, Customer.Customer.PhoneNumber, Customer.Customer.LanguageId,
							  @BranchId as BranchId, Customer.Customer.Password, Customer.Customer.CustomerSurname+'-'+cast(Customer.Customer.CustomerId as nvarchar(20)) as CustomerSurname,Customer.Customer.Bonus
							  ,Parameter.Currency.DecimalFormat,(select ParentBranchId from Parameter.Branch where BranchId=@BranchId) as ParentBranchId,case when Customer.IsActive=1 then cast(1 as int) else cast(0 as int) end as TimeZoneId
							  ,@UserId as UserId,Parameter.Currency.Currency,ISNULL((select Tax from Parameter.TaxCountry where CountryId=(select top 1 Customer.CountryId from Customer.Customer where BranchId=@BranchId and IsTerminalCustomer=1)),0) as Tax
							  ,(Select top 1  [General].[Setting].Address from [General].[Setting]) as CompAddress,(select Parameter.Branch.[Address] from Parameter.Branch where BranchId=@BranchId) as BranchAddress
						FROM        Customer.Customer with (nolock) INNER JOIN
							  Parameter.Currency with (nolock) ON Customer.Customer.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
							  Language.Language with (nolock) ON Customer.Customer.LanguageId = Language.Language.LanguageId 
						Where Customer.Customer.CustomerId=@CustomerId

						end
			 
				
				update Customer.Customer set LastLoginDate=GETDATE(),FailedPasswordAttemptCount=0 
				where Customer.Customer.CustomerId=@CustomerId
				
				insert Customer.Ip (CustomerId,IpAddress,LoginDate)
				values(@CustomerId,'0',GETDATE())
				end
				else
					begin
						SELECT Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage,cast(0 as bigint) as CustomerId, '' as CustomerName, 0 as CurrencyId,'' as Sybol, 
                      cast('0' as money) as Balance,'' as Username, GETDATE() as LastLoginDate,'' as IpAddress, 
                      '' as Email, GETDATE() as Birthday, '' as PhoneNumber, 0 as LanguageId,
                      0 as BranchId, '' as Password, '' as CustomerSurname,cast('0' as money) as Bonus,'' as DecimalFormat,0 as ParentBranchId,0 as TimeZoneId,0 as UserId,'' as Currency,cast('0' as float)  as Tax
					  ,'' as CompAddress,'' as BranchAddress
					FROM        Log.ErrorCodes with (nolock)
					where Log.ErrorCodes.ErrorCodeId=102 and Log.ErrorCodes.LangId=@LangId
					end
				
			end
		else
			begin
				SELECT Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage,cast(0 as bigint) as CustomerId, '' as CustomerName, 0 as CurrencyId,'' as Sybol, 
                      cast('0' as money) as Balance,'' as Username, GETDATE() as LastLoginDate,'' as IpAddress, 
                      '' as Email, GETDATE() as Birthday, '' as PhoneNumber, 0 as LanguageId,
                      0 as BranchId, '' as Password, '' as CustomerSurname,cast('0' as money) as Bonus,'' as DecimalFormat,0 as ParentBranchId,0 as TimeZoneId,0 as UserId,'' as Currency,cast('0' as float)  as Tax
					  ,'' as CompAddress,'' as BranchAddress
					FROM        Log.ErrorCodes with (nolock)
					where Log.ErrorCodes.ErrorCodeId=102 and Log.ErrorCodes.LangId=@LangId
				
			end
	end
ELSE
	begin
	if(select COUNT(*) from Customer.Customer with (nolock) where Customer.Customer.CustomerId=@CustomerId and IsActive=1)>0
		begin
			declare @AttempCount int=0
			
		declare @ErrorCodeId int
		declare @ErrorCode nvarchar(100)
		
		
			select @AttempCount=isnull(Customer.Customer.FailedPasswordAttemptCount,0)
			from Customer.Customer with (nolock)
			where Customer.Customer.CustomerId=@CustomerId
		
			if(@AttempCount+1)>=@LockCount
				begin
					update Customer.Customer set LastLockOutDate=GETDATE(),IsLockedOut=1,FailedPasswordAttemptCount=@AttempCount+1,IpAddress='0',LastLoginFailedDate=GETDATE()
					where Customer.Customer.CustomerId=@CustomerId
					
				
					
						SELECT Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage,cast(0 as bigint) as CustomerId, '' as CustomerName, 0 as CurrencyId,'' as Sybol, 
                      cast('0' as money) as Balance,'' as Username, GETDATE() as LastLoginDate,'' as IpAddress, 
                      '' as Email, GETDATE() as Birthday, '' as PhoneNumber, 0 as LanguageId,
                      0 as BranchId, '' as Password, '' as CustomerSurname,cast('0' as money) as Bonus,'' as DecimalFormat,0 as ParentBranchId,0 as TimeZoneId,0 as UserId,'' as Currency,cast('0' as float)  as Tax
					  ,'' as CompAddress,'' as BranchAddress
					FROM        Log.ErrorCodes with (nolock)
					where Log.ErrorCodes.ErrorCodeId=102 and Log.ErrorCodes.LangId=@LangId
					
					
					
				end
			else
				begin
					update Customer.Customer set FailedPasswordAttemptCount=@AttempCount+1,IpAddress='0',LastLoginFailedDate=GETDATE()
					where Customer.Customer.CustomerId=@CustomerId
				
				
						SELECT Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage,cast(0 as bigint) as CustomerId, '' as CustomerName, 0 as CurrencyId,'' as Sybol, 
                      cast('0' as money) as Balance,'' as Username, GETDATE() as LastLoginDate,'' as IpAddress, 
                      '' as Email, GETDATE() as Birthday, '' as PhoneNumber, 0 as LanguageId,
                      0 as BranchId, '' as Password, '' as CustomerSurname,cast('0' as money) as Bonus,'' as DecimalFormat,0 as ParentBranchId,0 as TimeZoneId,0 as UserId,'' as Currency,cast('0' as float)  as Tax
					  ,'' as CompAddress,'' as BranchAddress
					FROM        Log.ErrorCodes with (nolock)
					where Log.ErrorCodes.ErrorCodeId=101 and Log.ErrorCodes.LangId=@LangId
				end
		end
		else
			begin
				if(select COUNT(*) from Customer.Customer with (nolock) where Customer.Customer.CustomerId=@CustomerId)>0
				begin
				
					
					SELECT Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage,cast(0 as bigint) as CustomerId, '' as CustomerName, 0 as CurrencyId,'' as Sybol, 
                      cast('0' as money) as Balance,'' as Username, GETDATE() as LastLoginDate,'' as IpAddress, 
                      '' as Email, GETDATE() as Birthday, '' as PhoneNumber, 0 as LanguageId,
                      0 as BranchId, '' as Password, '' as CustomerSurname,cast('0' as money) as Bonus,'' as DecimalFormat,0 as ParentBranchId,0 as TimeZoneId,0 as UserId,'' as Currency,cast('0' as float)  as Tax
					  ,'' as CompAddress,'' as BranchAddress
					FROM        Log.ErrorCodes with (nolock)
					where Log.ErrorCodes.ErrorCodeId=152 and Log.ErrorCodes.LangId=@LangId
					end
				else
					begin
							SELECT Log.ErrorCodes.ErrorCodeId as ResultCode,Log.ErrorCodes.ErrorCode as ResultMessage,cast(0 as bigint) as CustomerId, '' as CustomerName, 0 as CurrencyId,'' as Sybol, 
                      cast('0' as money) as Balance,'' as Username, GETDATE() as LastLoginDate,'' as IpAddress, 
                      '' as Email, GETDATE() as Birthday, '' as PhoneNumber, 0 as LanguageId,
                      0 as BranchId, '' as Password, '' as CustomerSurname,cast('0' as money) as Bonus,'' as DecimalFormat,0 as ParentBranchId,0 as TimeZoneId,0 as UserId,'' as Currency,cast('0' as float)  as Tax
					  ,'' as CompAddress,'' as BranchAddress
					FROM        Log.ErrorCodes with (nolock)
					where Log.ErrorCodes.ErrorCodeId=101 and Log.ErrorCodes.LangId=@LangId
					end
				
			end
	
		
	
	END		                 



END


GO
