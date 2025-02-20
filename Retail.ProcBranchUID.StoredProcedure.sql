USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBranchUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [Retail].[ProcBranchUID]
@BranchId int,
@CreateUserName nvarchar(150),
@BranchName nvarchar(150),
@Balance money,
@CommisionRate float,
@IsActive bit,
@CurrencyId int,
@BranchCommisionTypeId int,
@IsBonusDeducting bit,
@MaxWiningLimit money,
@MaxCopySlip int,
@MinTicketLimit money,
@MaxEventForTicket int,
@ParentBranchId int,
@IsWebPos bit,
@LangId int,
@Adress nvarchar(max),
@username nvarchar(max),
@ActivityCode int,
@NewValues nvarchar(max)


AS




BEGIN
SET NOCOUNT ON;

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @BranchBalance money=0
declare @ParentBranchBalance money
declare @Control int=0
declare @UserId int
declare @UserRoleId int
declare @UserBranchId int 
select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
			declare @TransactionTypeId int
				declare @Amount money 
select @UserRoleId=Users.UserRoles.RoleId,@UserId=Users.Users.UserId,@UserBranchId=Users.Users.UnitCode from Users.UserRoles INNER JOIN Users.Users ON Users.UserRoles.UserId=Users.Users.UserId where UserName=@username



if @ActivityCode=1
	begin
	--	exec [Log].ProcConcatOldValues     'Branch','[Parameter]','BranchId',@BranchId,@OldValues output
	
	--exec [Log].[ProcTransactionLogUID]  35,@ActivityCode,@Username,@BranchId,'Parameter.Branch'
	--,@NewValues,@OldValues
	
	update Parameter.Branch set
	--BrancName=@BranchName,
--	Balance=@Balance,
	BranchCommisionTypeId=@BranchCommisionTypeId,
	IsBonusDeducting=@IsBonusDeducting,
	IsActive=@IsActive,
	MaxCopySlip=@MaxCopySlip
	,Address=@Adress
	,MaxWinningLimit=@MaxWiningLimit,
	MinTicketLimit=@MinTicketLimit,
	MaxEventForTicket=@MaxEventForTicket
	--,ParentBranchId=@ParentBranchId
	,IsWebPos=@IsWebPos
--	CommisionRate=@CommisionRate

	where Parameter.Branch.BranchId=@BranchId
	

	select @BranchBalance=Balance from Parameter.Branch where BranchId=@BranchId
	select @ParentBranchBalance=Balance from Parameter.Branch where BranchId=@UserBranchId
	if(@BranchBalance<>@Balance and (@ParentBranchId=@UserBranchId or @UserRoleId=1)) --Sadece Parent Branch veya Admin kullanıcısı bakiyelerini değiştirebiliyor.
		begin
		

			if(@BranchBalance>@Balance)
				begin
					set @TransactionTypeId=5 --withdraw
					set @Amount=@BranchBalance-@Balance
					update Parameter.Branch set
							Balance=Balance+@Amount
							where Parameter.Branch.BranchId=@UserBranchId
				end
			else
				begin
				if(@ParentBranchBalance>=@Balance-@BranchBalance)
				begin
					set @TransactionTypeId=3 --deposit
					set @Amount=@Balance-@BranchBalance

					update Parameter.Branch set
							Balance=Balance-@Amount
							where Parameter.Branch.BranchId=@UserBranchId
				end
				else
				 set @Control=1
				end

					if(@Control=0)
					begin
					insert RiskManagement.BranchDepositRequest(RequestUserId,BranchId,RequestDate,Amount,CurrencyId,BranchNote,TransactionTypeId,IsApproved,ApprovedUserId,ApprovedDate)
				values (@UserId,@BranchId,GETDATE(),@Amount,@CurrencyId,'',@TransactionTypeId,1,@UserId,GETDATE())

				insert RiskManagement.BranchTransaction (BranchId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId)
						values(@BranchId,@TransactionTypeId,@Amount,@CurrencyId,GETDATE(),@UserId)

							update Parameter.Branch set
							Balance=@Balance
							where Parameter.Branch.BranchId=@BranchId

					end

		end
			if(@Control=0)
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	else
	select @resultcode=106,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=172 and Log.ErrorCodes.LangId=@LangId
	
	
	end
if @ActivityCode=2
	begin
		select @ParentBranchBalance=Balance from Parameter.Branch where BranchId=@UserBranchId
			if(@ParentBranchBalance<@Balance-@BranchBalance)
				 set @Control=1
if(@Control=0)
	begin
	
	declare @timezoneId int

	if @MinTicketLimit=2
		set @MinTicketLimit=1.90
	select @timezoneId=Users.Users.TimeZoneId from Users.Users where Users.UserId=@UserId

	if(select COUNT(*) from [Users].Users where UserName=@CreateUserName )=0 and (select Count(*) from Parameter.Branch where BrancName=@BranchName)=0
		begin

			exec [Log].[ProcTransactionLogUID]  35,@ActivityCode,@Username,@BranchId,'Parameter.Branch'
				,@NewValues,null
	
			insert Parameter.Branch(BrancName,CreateDate,Balance,CommisionRate,IsActive,CurrencyId,BranchCommisionTypeId,IsBonusDeducting,MaxWinningLimit,MaxCopySlip,[MinTicketLimit],MaxEventForTicket,ParentBranchId,IsWebPos,IsTerminal,Api_url,Address)
			values(@BranchName,GETDATE(),@Balance,@CommisionRate,@IsActive,@CurrencyId,1,@IsBonusDeducting,@MaxWiningLimit,@MaxCopySlip,@MinTicketLimit,@MaxEventForTicket,@ParentBranchId,@IsWebPos,0,'',@Adress)
	
			set @BranchId=SCOPE_IDENTITY()

			update Parameter.Branch set BrachCode=@BranchId where BranchId=@BranchId
				set @BranchBalance=0
	
			if(@BranchBalance<>@Balance and (@ParentBranchId=@UserBranchId or @UserRoleId=1) and @Balance>0) --Sadece Parent Branch veya Admin kullanıcısı bakiyelerini değiştirebiliyor.
				begin
	

					if(@BranchBalance>@Balance)
						begin
							set @TransactionTypeId=5 --withdraw
							set @Amount=@BranchBalance-@Balance
										update Parameter.Branch set
									Balance=Balance+@Amount
									where Parameter.Branch.BranchId=@UserBranchId
						end
					else
						begin
							set @TransactionTypeId=3 --deposit
							set @Amount=@Balance-@BranchBalance
								update Parameter.Branch set
									Balance=Balance-@Amount
									where Parameter.Branch.BranchId=@UserBranchId
						end

			
				
			
							insert RiskManagement.BranchDepositRequest(RequestUserId,BranchId,RequestDate,Amount,CurrencyId,BranchNote,TransactionTypeId,IsApproved,ApprovedUserId,ApprovedDate)
						values (@UserId,@BranchId,GETDATE(),@Amount,@CurrencyId,'',@TransactionTypeId,1,@UserId,GETDATE())

						insert RiskManagement.BranchTransaction (BranchId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId)
								values(@BranchId,@TransactionTypeId,@Amount,@CurrencyId,GETDATE(),@UserId)

									update Parameter.Branch set
									Balance=@Balance
									where Parameter.Branch.BranchId=@BranchId

		end

	declare @Passwords nvarchar(20)

		set  @Passwords	=  dbo.[FuncGenPass](Rand())
		declare @CountryId int

		select @CountryId= CountryId from Customer.Customer where BranchId=@ParentBranchId and IsBranchCustomer=1

			insert [Users].Users(UserName,Password,Name,Surname,Email,GsmNo,TimeZoneId,CurrencyId,LanguageId,CreateDate,IsLockedOut,FailedPasswordAttemptCount,UnitCode,[Multiplier],MultipDate)
			values (@CreateUserName,@Passwords,@CreateUserName,@CreateUserName,@CreateUserName,@CreateUserName,@timezoneId,@CurrencyId,@LangId,GETDATE(),0,0,@BranchId,1,GETDATE())
			 
			set @UserId=SCOPE_IDENTITY()
			execute Retail.[ProcUsersRoleUID]   0,2,@UserId,2,'',@username

			declare @CustomerId bigint
				insert Customer.Customer(CustomerName,CurrencyId,Balance,Username,Password,CreateDate,IpAddress,IsLockedOut,CustomerSurname,Email,Birthday,PhoneNumber,LanguageId,BranchId,IsActive,TimeZoneId,OddsFormatId,CountryId,PasswordQuestionId,PasswordQuestion,SalutationId,ZipCode,Address,AddressAdditional,IsOddIncreasement,IsOddDecreasements,City,IsTempLock,PhoneCodeId,GroupId,Bonus,FailedPasswordAttemptCount,IsBranchCustomer,IsTerminalCustomer)
					values(cast(@BranchId as nvarchar(20))+'_branch',@CurrencyId,0,cast(@BranchId as nvarchar(20))+'_branch',@Passwords,GETDATE(),'',0,' ',cast(@BranchId as nvarchar(20))+'_branch',GETDATE(),111111111,@LangId,@BranchId,@IsActive,1,1,@CountryId,1,'',1,'','','',1,1,1,0,1,1,0,0,1,0)
					set @CustomerId=SCOPE_IDENTITY()
					
					insert Customer.Limit(CustomerId,StakeDailyLimit,StakeWeeklyLimit,StakeMonthlyLimit,DepositDailyLimit,DepositWeeklyLimit,DepositMonthlyLimit,LossDailyLimit,LossWeeklyLimit,LossMonthlyLimit)
					select @CustomerId,StakeDailyLimit,StakeWeeklyLimit,StakeMonthlyLimit,DepositDailyLimit,DepositWeeklyLimit,DepositMonthlyLimit,LossDailyLimit,LossWeeklyLimit,LossMonthlyLimit
					from Parameter.CustomerLimit
					
						insert Customer.StakeLimit(CustomerId,CreditLimit,LimitPerTicket,MaxStakeGame,MaxStakeFactor,MaxStakeGamePercent,LimitPerLiveTicket,StakeDay,StakeWeek,StakeMonth,MinCombiBranch,MinCombiInternet,MinCombiMachine,PendingTime)
					select @CustomerId,CreditLimit,LimitPerTicket,MaxStakeGame,MaxStakeFactor,MaxStakeGamePercent,LimitPerLiveTicket,StakeDay,StakeWeek,StakeMonth,MinCombiBranch,MinCombiInternet,MinCombiMachine,10
					from Parameter.CustomerLimit


	select @resultcode=ErrorCodeId,@resultmessage=@Passwords from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
	
		end
	else
		select @resultcode=106,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId

	end
	else
		select @resultcode=106,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=172 and Log.ErrorCodes.LangId=@LangId

	end


	select @resultcode as resultcode,@resultmessage as resultmessage
END




GO
