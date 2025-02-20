USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerUID]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [GamePlatform].[ProcCustomerUID]
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
@LangId int,
@username nvarchar(max),
@ActivityCode int,
@NewValues nvarchar(max),
@IdNumber nvarchar(50),
@PassportNumber nvarchar(50),
@BirthPlace nvarchar(50),
@TaxNo nvarchar(50),
@IsPromotion bit


AS




BEGIN
SET NOCOUNT ON;

declare @SystemCurrency int
declare @OldValues nvarchar(max)
declare @resultcode bigint=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @BId int=1
select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
set @TimeZoneId=1
set @PhoneCodeId=45
set @CountryId=55
if @PhoneNumber is null
 set @PhoneNumber='1'
select @SystemCurrency=General.Setting.SystemCurrencyId from General.Setting



if @ActivityCode=1
	begin
	--	exec [Log].ProcConcatOldValues  'Customer','Customer','CustomerId',@CustomerId,@OldValues output
	
	--exec [Log].[ProcTransactionLogUID]  18,@ActivityCode,@Username,@CustomerId,'Customer.Customer'
	--,@NewValues,@OldValues
	
	update Customer.Customer set
	Email=@Email,
	CustomerName=@CustomerName,
	CustomerSurname=@CustomerSurname,
	Birthday=@Birthday,
	IsActive=@IsActive,
	--BranchId=@BranchId,
	--TimeZoneId=@TimeZoneId,
	OddsFormatId=@OddsFormatId,
	CountryId=@CountryId,
	--Password=@Password,
	--PasswordQuestionId=@PasswordQuestionId,
	--PasswordQuestion=@PasswordQuestion,
	--SalutationId=@SalutationId,
	ZipCode=@ZipCode,
	Address=@Address,
	AddressAdditional=@AddressAdditional,
	IsOddIncreasement=@IsOddIncreasement,
	IsOddDecreasements=@IsOddDecreasements,
	PhoneNumber=@PhoneNumber,
	City=@City,
	PhoneCodeId=@PhoneCodeId
	,IsPromotion=@IsPromotion
	--,IdNumber=@IdNumber
	--,PassportNumber=@PassportNumber
	,BirthPlace=@BirthPlace
	,@resultmessage=Customer.OasisId
	--,TaxNo=@TaxNo

	where CustomerId=@CustomerId
	
	select @resultcode=ErrorCodeId  from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
else if @ActivityCode=2
	begin

	if(select COUNT(Customer.Customer.CustomerId) from Customer.Customer where Customer.Customer.Email=@Email)=0
		begin
			if(select COUNT(Customer.Customer.CustomerId) from Customer.Customer where Customer.Customer.Username=@CustomerUsername)=0
				begin
					if(select COUNT(Customer.Customer.CustomerId) from Customer.Customer where Customer.Customer.PhoneNumber=@PhoneNumber)=0
					begin
						if(select COUNT(Customer.Customer.CustomerId) from Customer.Customer where Customer.Customer.Birthday=@Birthday and Customer.Customer.BirthPlace=@BirthPlace and RTRIM(Customer.Customer.[Address])=RTRIM(@Address))=0
						begin
						if(select COUNT(Customer.Customer.CustomerId) from Customer.Customer where Customer.Customer.CustomerName=@CustomerName and Customer.Customer.CustomerSurname=@CustomerSurname and  Customer.Customer.Birthday=@Birthday)=0
						begin
					--exec [Log].[ProcTransactionLogUID]  18,@ActivityCode,@Username,@CustomerId,'Customer.Customer'
					--,@NewValues,null
					
					if(@BranchId<>1)
						begin
						if not exists (select Parameter.Branch.BranchId from Parameter.Branch where BranchId=@BranchId) 
							begin
						
							set @BranchId=1

							end
						end

					insert Customer.Customer(CustomerName,CurrencyId,Balance,Username,Password,CreateDate,IpAddress,IsLockedOut,CustomerSurname,Email,Birthday,PhoneNumber,LanguageId,BranchId,IsActive,TimeZoneId,OddsFormatId,CountryId,PasswordQuestionId,PasswordQuestion,SalutationId,ZipCode,Address,AddressAdditional,IsOddIncreasement,IsOddDecreasements,City,IsTempLock,PhoneCodeId,GroupId,FailedPasswordAttemptCount,Bonus,IsBranchCustomer,IsTerminalCustomer,IdNumber,PassportNumber,BirthPlace,TaxNo,IsVerification,RiskLevelId,SourceId,IsPromotion)
					values(@CustomerName,@CurrencyId,0,@CustomerUsername,@Password,GETDATE(),@IpAddress,0,@CustomerSurname,@Email,@Birthday,@PhoneNumber,@CustomerLanguageId,32643,0,@TimeZoneId,@OddsFormatId,@CountryId,1,@PasswordQuestion,@SalutationId,@ZipCode,@Address,@AddressAdditional,@IsOddIncreasement,@IsOddDecreasements,@City,0,@PhoneCodeId,@GroupId,@FailedPasswordAttemptCount,0,0,0,@IdNumber,@PassportNumber,@BirthPlace,@TaxNo,0,2,1,@IsPromotion)
					set @CustomerId=SCOPE_IDENTITY()
					
					insert Customer.Limit(CustomerId,StakeDailyLimit,StakeWeeklyLimit,StakeMonthlyLimit,DepositDailyLimit,DepositWeeklyLimit,DepositMonthlyLimit,LossDailyLimit,LossWeeklyLimit,LossMonthlyLimit,StakeDailyLimitConsumed,StakeWeeklyLimitConsumed,StakeMonthlyLimitConsumed,DepositDailyLimitConsumed,DepositWeeklyLimitConsumed,DepositMonthlyLimitConsumed,LossDailyLimitConsumed,LossWeeklyLimitConsumed,LossMonthlyLimitConsumed)
					select @CustomerId,dbo.FuncCurrencyConverter(StakeDailyLimit,@SystemCurrency,@CurrencyId),dbo.FuncCurrencyConverter(StakeWeeklyLimit,@SystemCurrency,@CurrencyId)
					,dbo.FuncCurrencyConverter(StakeMonthlyLimit,@SystemCurrency,@CurrencyId),dbo.FuncCurrencyConverter(DepositDailyLimit,@SystemCurrency,@CurrencyId),dbo.FuncCurrencyConverter(DepositWeeklyLimit,@SystemCurrency,@CurrencyId),dbo.FuncCurrencyConverter(DepositMonthlyLimit,@SystemCurrency,@CurrencyId),dbo.FuncCurrencyConverter(LossDailyLimit,@SystemCurrency,@CurrencyId),dbo.FuncCurrencyConverter(LossWeeklyLimit,@SystemCurrency,@CurrencyId),dbo.FuncCurrencyConverter(LossMonthlyLimit,@SystemCurrency,@CurrencyId)
					,dbo.FuncCurrencyConverter(StakeDailyLimit,@SystemCurrency,@CurrencyId),dbo.FuncCurrencyConverter(StakeWeeklyLimit,@SystemCurrency,@CurrencyId)
					,dbo.FuncCurrencyConverter(StakeMonthlyLimit,@SystemCurrency,@CurrencyId),dbo.FuncCurrencyConverter(DepositDailyLimit,@SystemCurrency,@CurrencyId),dbo.FuncCurrencyConverter(DepositWeeklyLimit,@SystemCurrency,@CurrencyId),dbo.FuncCurrencyConverter(DepositMonthlyLimit,@SystemCurrency,@CurrencyId),dbo.FuncCurrencyConverter(LossDailyLimit,@SystemCurrency,@CurrencyId),dbo.FuncCurrencyConverter(LossWeeklyLimit,@SystemCurrency,@CurrencyId),dbo.FuncCurrencyConverter(LossMonthlyLimit,@SystemCurrency,@CurrencyId)
					from Parameter.CustomerLimit
					
						insert Customer.StakeLimit(CustomerId,CreditLimit,LimitPerTicket,MaxStakeGame,MaxStakeFactor,MaxStakeGamePercent,LimitPerLiveTicket,StakeDay,StakeWeek,StakeMonth,MinCombiBranch,MinCombiInternet,MinCombiMachine,PendingTime,DepositDay,DepositWeek,DepositMonth,LossDay,LossWeek,LossMonth)
					select @CustomerId,CreditLimit,100,MaxStakeGame,MaxStakeFactor,MaxStakeGamePercent,100,StakeDay,StakeWeek,StakeMonth,MinCombiBranch,MinCombiInternet,MinCombiMachine,10,DepositDailyLimit,DepositWeeklyLimit,DepositMonthlyLimit,LossDailyLimit,LossWeeklyLimit,LossMonthlyLimit
					from Parameter.CustomerLimit
					
					insert Customer.Ip (CustomerId,IpAddress,LoginDate)
					values (@CustomerId,@IpAddress,GETDATE())
					
					insert Customer.PEPControl (CustomerId,CreateDate,IsDoc,IsPep,IsSanction) values (@CustomerId,Getdate(),0,1,1)

					update Customer.Customer set Customer.RecoveryCode=null,RecoveryDate=null,IsActive=1
		where Customer.CustomerId=@CustomerId
					--Otomatik activation
					--exec  [GamePlatform].[ProcCustomerEmailConfirmed] @CustomerId,@LangId

					--if(select COUNT(DISTINCT Customer.Ip.CustomerId) from Customer.Ip where Customer.Ip.IpAddress=@IpAddress)>1
					--	exec [Users].[Notification] 1,0,3,129,''
					
					select @resultcode=@CustomerId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=151 and Log.ErrorCodes.LangId=@LangId
					end
					else
						select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=179 and Log.ErrorCodes.LangId=@LangId
						end
						else
							select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=178 and Log.ErrorCodes.LangId=@LangId
					end
					else
						select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=177 and Log.ErrorCodes.LangId=@LangId	
				end
			else
				select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId		
		end
	else
		select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=110 and Log.ErrorCodes.LangId=@LangId
	
	end
else if @ActivityCode=4
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
	BranchId=@BranchId,
	TimeZoneId=@TimeZoneId,
	OddsFormatId=@OddsFormatId,
	CountryId=@CountryId,
	PhoneNumber=@PhoneNumber,
	--Password=@Password,
	PasswordQuestionId=@PasswordQuestionId,
	PasswordQuestion=@PasswordQuestion,
	SalutationId=@SalutationId,
	ZipCode=@ZipCode,
	Address=@Address,
	AddressAdditional=@AddressAdditional,
	IsOddIncreasement=@IsOddIncreasement,
	IsOddDecreasements=@IsOddDecreasements,
	City=@City,
		GroupId=@GroupId
			,FailedPasswordAttemptCount=@FailedPasswordAttemptCount
	,IsLockedOut=@IsLockedOut
		,IsPromotion=@IsPromotion
	where CustomerId=@CustomerId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
else if @ActivityCode=5
	begin
	 
	update Customer.Customer set
 
	OasisId=@CustomerName

	where CustomerId=@CustomerId
	
	select @resultcode=@CustomerId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=151 and Log.ErrorCodes.LangId=@LangId
	
	
	end
else if @ActivityCode=6
	begin
	 
		update Customer.Customer set
	CustomerName=@CustomerName,
	CustomerSurname=@CustomerSurname,
	PhoneNumber=@PhoneNumber,
	ZipCode=@ZipCode,
	Address=@Address,
	AddressAdditional=@AddressAdditional,
	City=@City,
	BirthPlace=@BirthPlace,
	OddsFormatId=@OddsFormatId
	where Email=@Email
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end


	select @resultcode as resultcode,@resultmessage as resultmessage
END




GO
