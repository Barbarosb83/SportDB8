USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [RiskManagement].[ProcCustomerUID]
@CustomerId bigint,
@CustomerName nvarchar(200),
@CurrencyId int,
@CustomerUsername nvarchar(250),
@CustomerSurname nvarchar(250),
@Password nvarchar(250),
@IpAddress nvarchar(50),
@Email nvarchar(50),
@Birthday datetime,
@PhoneNumber nvarchar(50),
@CustomerLanguageId int,
@BranchId int,
@IsActive bit,
@TimeZoneId int,
@OddsFormatId nvarchar(150),
@CountryId int,
@PasswordQuestionId int,
@PasswordQuestion nvarchar(150),
@SalutationId int,
@ZipCode nvarchar(15),
@Address nvarchar(250),
@AddressAdditional nvarchar(250),
@IsOddIncreasement bit,
@IsOddDecreasements bit,
@City nvarchar(150),
@PhoneCodeId int,
@GroupId int,
@FailedPasswordAttemptCount int,
@IsLockedOut bit,
@IsVerification bit,
@RiskLevelId int,
@LangId int,
@username nvarchar(max),
@ActivityCode int,
@NewValues nvarchar(max)


AS




BEGIN
SET NOCOUNT ON;

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId


if @ActivityCode=1
	begin
		exec [Log].ProcConcatOldValues  'Customer','Customer','CustomerId',@CustomerId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  18,@ActivityCode,@Username,@CustomerId,'Customer.Customer'
	,@NewValues,@OldValues
	
	update Customer.Customer set
	Email=@Email,
	CustomerName=@CustomerName,
	CustomerSurname=@CustomerSurname,
	Birthday=@Birthday,
	IsActive=@IsActive,
	--BranchId=@BranchId,
	TimeZoneId=@TimeZoneId,
	OddsFormatId=@OddsFormatId,
	CountryId=@CountryId,
	--Password=@Password,
	PasswordQuestionId=@PasswordQuestionId,
	PasswordQuestion=@PasswordQuestion,
	--SalutationId=@SalutationId,
	ZipCode=@ZipCode,
	Address=@Address,
	AddressAdditional=@AddressAdditional,
	IsOddIncreasement=1,
	IsOddDecreasements=1,
	PhoneNumber=@PhoneNumber,
	City=@City,
	PhoneCodeId=@PhoneCodeId
	,IsVerification=@IsVerification
	,RiskLevelId=@RiskLevelId
	where CustomerId=@CustomerId

	--if(@IsOddDecreasements=0)
	--	delete from Customer.Card where CustomerId=@CustomerId

	if(@IsActive=0)
		update Customer.Customer set IsActiveChangeUser=@username,IsActiveChangeDate=Getdate() where CustomerId=@CustomerId
	else
		update Customer.Customer set FailedPasswordAttemptCount=0  where CustomerId=@CustomerId

	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
else if @ActivityCode=2
	begin

	if(select COUNT(Customer.Customer.CustomerId) from Customer.Customer where Customer.Customer.Email=@Email)=0
		begin
			if(select COUNT(Customer.Customer.CustomerId) from Customer.Customer where Customer.Customer.Username=@CustomerUsername)=0
				begin
					exec [Log].[ProcTransactionLogUID]  18,@ActivityCode,@Username,@CustomerId,'Customer.Customer'
					,@NewValues,null
					
					insert Customer.Customer(CustomerName,CurrencyId,Balance,Username,Password,CreateDate,IpAddress,IsLockedOut,CustomerSurname,Email,Birthday,PhoneNumber,LanguageId,BranchId,IsActive,TimeZoneId,OddsFormatId,CountryId,PasswordQuestionId,PasswordQuestion,SalutationId,ZipCode,Address,AddressAdditional,IsOddIncreasement,IsOddDecreasements,City,IsTempLock,PhoneCodeId,GroupId,Bonus,IsVerification,FailedPasswordAttemptCount,IsBranchCustomer,IsTerminalCustomer,RiskLevelId,IsPromotion)
					values(@CustomerName,@CurrencyId,0,@CustomerUsername,@Password,GETDATE(),@IpAddress,0,@CustomerSurname,@Email,@Birthday,@PhoneNumber,@CustomerLanguageId,@BranchId,@IsActive,@TimeZoneId,@OddsFormatId,@CountryId,@PasswordQuestionId,@PasswordQuestion,1,@ZipCode,@Address,@AddressAdditional,1,1,@City,0,@PhoneCodeId,@GroupId,0,0,0,0,0,@RiskLevelId,1)
					set @CustomerId=SCOPE_IDENTITY()
					
					insert Customer.Limit(CustomerId,StakeDailyLimit,StakeWeeklyLimit,StakeMonthlyLimit,DepositDailyLimit,DepositWeeklyLimit,DepositMonthlyLimit,LossDailyLimit,LossWeeklyLimit,LossMonthlyLimit)
					select @CustomerId,StakeDailyLimit,StakeWeeklyLimit,StakeMonthlyLimit,DepositDailyLimit,DepositWeeklyLimit,DepositMonthlyLimit,LossDailyLimit,LossWeeklyLimit,LossMonthlyLimit
					from Parameter.CustomerLimit
					
						insert Customer.StakeLimit(CustomerId,CreditLimit,LimitPerTicket,MaxStakeGame,MaxStakeFactor,MaxStakeGamePercent,LimitPerLiveTicket,StakeDay,StakeWeek,StakeMonth,MinCombiBranch,MinCombiInternet,MinCombiMachine,PendingTime)
					select @CustomerId,CreditLimit,LimitPerTicket,MaxStakeGame,MaxStakeFactor,MaxStakeGamePercent,LimitPerLiveTicket,StakeDay,StakeWeek,StakeMonth,MinCombiBranch,MinCombiInternet,MinCombiMachine,10
					from Parameter.CustomerLimit
					
					insert Customer.PEPControl (CustomerId,CreateDate) values (@CustomerId,Getdate())

					insert Customer.Ip (CustomerId,IpAddress,LoginDate)
					values (@CustomerId,@IpAddress,GETDATE())
					
					--if(select COUNT(DISTINCT Customer.Ip.CustomerId) from Customer.Ip where Customer.Ip.IpAddress=@IpAddress)>1
					--	exec [Users].[Notification] 1,0,3,129,''
					
					select @resultcode=@CustomerId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
				end
			else
				select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId		
		end
	else
		select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=110 and Log.ErrorCodes.LangId=@LangId
	
	end
else if @ActivityCode=4
	begin
		--exec [Log].ProcConcatOldValues  'Customer','Customer','CustomerId',@CustomerId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  18,@ActivityCode,@Username,@CustomerId,'Customer.Customer'
	,@NewValues,@OldValues
	declare @TempLockOutDate datetime
	if(@SalutationId>0)
		set @TempLockOutDate=DATEADD(DAY,@SalutationId,GETDATE())


	update Customer.Customer set
	Email=@Email,
	CustomerName=@CustomerName,
	CustomerSurname=@CustomerSurname,
	Birthday=@Birthday,
	IsActive=@IsActive,
	BranchId=@BranchId,
	TimeZoneId=@TimeZoneId,
	OddsFormatId=@OddsFormatId,
	CountryId=@CountryId,
	PhoneNumber=@PhoneNumber,
	PhoneCodeId=@PhoneCodeId,
	BirthPlace=@PasswordQuestion
	--Password=@Password,
	--PasswordQuestionId=@PasswordQuestionId,
	--PasswordQuestion=@PasswordQuestion,
	--SalutationId=@SalutationId,
	,ZipCode=@ZipCode,
	Address=@Address,
	--AddressAdditional=@AddressAdditional,
	IsOddIncreasement=1,
	IsOddDecreasements=1,
	IsTempLock=@IsVerification,
	City=@City,
	@resultmessage=Customer.OasisId,
		GroupId=@GroupId
			,FailedPasswordAttemptCount=0
	,IsLockedOut=@IsLockedOut
		,RiskLevelId=@RiskLevelId
		,TempLockOutdate= case when @TempLockOutDate is null  then TempLockOutdate else case when DATEDIFF(DAY,ChangeTempLockOutDate,GETDATE())>2 or ChangeTempLockOutDate is null  then @TempLockOutDate else TempLockOutdate end end
		,ChangeTempLockOutDate= case when @TempLockOutDate is null then ChangeTempLockOutDate else GETDATE() end
	where CustomerId=@CustomerId

		if(@IsOddDecreasements=0)
		delete from Customer.Card where CustomerId=@CustomerId
	
	select @resultcode=ErrorCodeId from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
else if @ActivityCode=5
	begin
 
	
	update Customer.Customer set
	
	OasisId=@City
	
	where CustomerId=@CustomerId

	 
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end


	select @resultcode as resultcode,@resultmessage as resultmessage
END




GO
