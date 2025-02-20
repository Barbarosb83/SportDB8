USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCustomerUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Retail].[ProcCustomerUID]
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
@OddsFormatId int,
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
@IdNumber nvarchar(150),
@Nationalty nvarchar(150),
@PlaceOfBirth nvarchar(150),
@CountryOfBirth nvarchar(150),
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
	TimeZoneId=@TimeZoneId,
	OddsFormatId=@OddsFormatId,
	CountryId=@CountryId,
	--Password=@Password,
	PasswordQuestionId=@PasswordQuestionId,
	PasswordQuestion=@PasswordQuestion,   --STREET olarak kullanılıyor
	SalutationId=@SalutationId,
	ZipCode=@ZipCode,
	Address=@Address,
	AddressAdditional=@AddressAdditional,
	IsOddIncreasement=@IsOddIncreasement,
	IsOddDecreasements=@IsOddDecreasements,
	PhoneNumber=@PhoneNumber,
	City=@City,
	PhoneCodeId=@PhoneCodeId
	,CountryOfBirth=@CountryOfBirth
	,BirthPlace=@PlaceOfBirth

	where CustomerId=@CustomerId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
else if @ActivityCode=2
	begin
 --insert dbo.betslip values(@CustomerId,@CustomerName+' '+@CustomerSurname+' '+CAST(@Birthday as nvarchar(50)),GETDATE())
	if(select COUNT(Customer.Customer.CustomerId) from Customer.Customer where Customer.Customer.Email=@Email)=0
		begin
			if(select COUNT(Customer.Customer.CustomerId) from Customer.Customer where Customer.Customer.Username=@CustomerUsername)=0
				begin
					if(select COUNT(Customer.Customer.CustomerId) from Customer.Customer where Customer.Customer.CustomerName=@CustomerName and Customer.customer.CustomerSurname=@CustomerSurname and Customer.Birthday=@Birthday)=0
					begin
					--exec [Log].[ProcTransactionLogUID]  18,@ActivityCode,@Username,@CustomerId,'Customer.Customer'
					--,@NewValues,null
					if(@PhoneCodeId=0)
						set @PhoneCodeId=44
						if @PhoneNumber is null
						 set @PhoneNumber='1'
					--set  @Password	=  dbo.[FuncGenPass](Rand())

					insert Customer.Customer(CustomerName,CurrencyId,Balance,Username,Password,CreateDate,IpAddress,IsLockedOut,CustomerSurname,Email,Birthday,PhoneNumber,LanguageId,BranchId,IsActive,TimeZoneId,OddsFormatId,CountryId,PasswordQuestionId,PasswordQuestion,SalutationId,ZipCode,Address,AddressAdditional,IsOddIncreasement,IsOddDecreasements,City,IsTempLock,PhoneCodeId,GroupId,Bonus,FailedPasswordAttemptCount,IsBranchCustomer,RiskLevelId,SourceId,IsPromotion
					,IdNumber,CountryOfBirth,Nationalty,IsTerminalCustomer)
					values(@CustomerName,@CurrencyId,0,@CustomerUsername,@Password,GETDATE(),@IpAddress,0,@CustomerSurname,@Email,@Birthday,@PhoneNumber,@CustomerLanguageId,@BranchId,@IsActive,@TimeZoneId,@OddsFormatId,55,@PasswordQuestionId,@PasswordQuestion,@SalutationId,@ZipCode,@Address,@AddressAdditional,@IsOddIncreasement,@IsOddDecreasements,@City,0,@PhoneCodeId,@GroupId,0,0,0,2,4,1
					,@IdNumber,@CountryOfBirth,@Nationalty,0)
					set @CustomerId=SCOPE_IDENTITY()
					
					insert Customer.Limit(CustomerId,StakeDailyLimit,StakeWeeklyLimit,StakeMonthlyLimit,DepositDailyLimit,DepositWeeklyLimit,DepositMonthlyLimit,LossDailyLimit,LossWeeklyLimit,LossMonthlyLimit)
					select @CustomerId,StakeDailyLimit,StakeWeeklyLimit,StakeMonthlyLimit,DepositDailyLimit,DepositWeeklyLimit,DepositMonthlyLimit,LossDailyLimit,LossWeeklyLimit,LossMonthlyLimit
					from Parameter.CustomerLimit
					
						insert Customer.StakeLimit(CustomerId,CreditLimit,LimitPerTicket,MaxStakeGame,MaxStakeFactor,MaxStakeGamePercent,LimitPerLiveTicket,StakeDay,StakeWeek,StakeMonth,MinCombiBranch,MinCombiInternet,MinCombiMachine,PendingTime,DepositDay,DepositWeek,DepositMonth,LossDay,LossWeek,LossMonth)
					select @CustomerId,CreditLimit,LimitPerTicket,MaxStakeGame,MaxStakeFactor,MaxStakeGamePercent,LimitPerLiveTicket,StakeDay,StakeWeek,StakeMonth,MinCombiBranch,MinCombiInternet,MinCombiMachine,10,DepositDailyLimit,DepositWeeklyLimit,DepositMonthlyLimit,LossDailyLimit,LossWeeklyLimit,LossMonthlyLimit
					from Parameter.CustomerLimit
					
					insert Customer.PEPControl (CustomerId,CreateDate) values (@CustomerId,Getdate())
					--insert Customer.Ip (CustomerId,IpAddress,LoginDate)
					--values (@CustomerId,@IpAddress,GETDATE())
					
					--if(select COUNT(DISTINCT Customer.Ip.CustomerId) from Customer.Ip where Customer.Ip.IpAddress=@IpAddress)>1
					--	exec [Users].[Notification] 1,0,3,129,''
					
					select @resultcode=@CustomerId,@resultmessage=@Password from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
					end
						else
						select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId	
				end
			else
				select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId		
		end
	else
		select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=110 and Log.ErrorCodes.LangId=@LangId
	
	end
else if @ActivityCode=4
	begin
	--	exec [Log].ProcConcatOldValues  'Customer','Customer','CustomerId',@CustomerId,@OldValues output
	
	--exec [Log].[ProcTransactionLogUID]  18,@ActivityCode,@Username,@CustomerId,'Customer.Customer'
	--,@NewValues,@OldValues
	
	update Customer.Customer set
	
	 OasisId=@PlaceOfBirth
	
	where CustomerId=@CustomerId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end


	select @resultcode as resultcode,@resultmessage as resultmessage
END





GO
