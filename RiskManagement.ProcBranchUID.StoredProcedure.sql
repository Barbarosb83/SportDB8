USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcBranchUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 

CREATE PROCEDURE [RiskManagement].[ProcBranchUID]
@BranchId int,
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
@BranchUserName nvarchar(100),
@IsWebPos bit,
@Password nvarchar(50),
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
declare @UserRoleId int
declare @BranchBalance money
declare @UserId int
declare @UserBranchId int 
declare @TimeZoneId int
declare @CustomerId bigint
declare @OldParentBranchId int
select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
		declare @Amount money 
			declare @TransactionTypeId int
select @UserRoleId=Users.UserRoles.RoleId,@UserId=Users.Users.UserId,@UserBranchId=Users.Users.UnitCode,@TimeZoneId=Users.Users.TimeZoneId from Users.UserRoles INNER JOIN Users.Users ON Users.UserRoles.UserId=Users.Users.UserId where UserName=@username
declare @IsTerminal bit=@IsBonusDeducting

if @ActivityCode=1
	begin
		exec [Log].ProcConcatOldValues     'Branch','[Parameter]','BranchId',@BranchId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  35,@ActivityCode,@Username,@BranchId,'Parameter.Branch'
	,@NewValues,@OldValues
	
	select @BranchBalance=Balance,@IsTerminal=IsTerminal,@OldParentBranchId=ParentBranchId from Parameter.Branch where BranchId=@BranchId

	update Parameter.Branch set
	BrancName=@BranchName,
--	Balance=@Balance,
	BranchCommisionTypeId=@BranchCommisionTypeId,
	IsBonusDeducting=@IsBonusDeducting,
	IsActive=@IsActive,
	MaxCopySlip=@MaxCopySlip,
	MaxWinningLimit=@MaxWiningLimit,
	MinTicketLimit=@MinTicketLimit,
	MaxEventForTicket=@MaxEventForTicket
	,ParentBranchId=@ParentBranchId
--	CommisionRate=@CommisionRate

	where Parameter.Branch.BranchId=@BranchId

		update Customer.Customer set IsActive=@IsActive where BranchId=@BranchId and (IsTerminalCustomer=1 or IsBranchCustomer=1)

	if (@IsTerminal=1 and @ParentBranchId<>@OldParentBranchId) --Eğer terminalin bayisi değiştiriliyorsa Closecashbox yapılıyor.
		begin
			declare @TerminalUserId int
			select top 1  @TerminalUserId=Users.Users.UserId  from Users.UserRoles INNER JOIN Users.Users ON Users.UserRoles.UserId=Users.Users.UserId where UnitCode=@BranchId

			exec [Retail].[ProcTerminalBoxClose] @TerminalUserId,@LangId

		end

	

	if(@BranchBalance<>@Balance and (@ParentBranchId=@UserBranchId or @UserRoleId=1)) --Sadece Parent Branch veya Admin kullanıcısı bakiyelerini değiştirebiliyor.
		begin
		
		if @IsTerminal=0
		begin
			if(@BranchBalance>@Balance)
				begin
					set @TransactionTypeId=5 --withdraw
					set @Amount=@BranchBalance-@Balance
				end
			else
				begin
					set @TransactionTypeId=3 --deposit
					set @Amount=@Balance-@BranchBalance
				end

				insert RiskManagement.BranchDepositRequest(RequestUserId,BranchId,RequestDate,Amount,CurrencyId,BranchNote,TransactionTypeId,IsApproved,ApprovedUserId,ApprovedDate)
				values (@UserId,@BranchId,GETDATE(),@Amount,@CurrencyId,'',@TransactionTypeId,1,@UserId,GETDATE())

				insert RiskManagement.BranchTransaction (BranchId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId)
						values(@BranchId,@TransactionTypeId,@Amount,@CurrencyId,GETDATE(),@UserId)

							update Parameter.Branch set
							Balance=@Balance
							where Parameter.Branch.BranchId=@BranchId

		end
		else
			begin

			if(@BranchBalance<@Balance)
				begin
						set @TransactionTypeId=14 -- Terminal için transactiontype 14 terminal deposit
			update Parameter.Branch set
			Balance=Balance+@Amount
			where Parameter.Branch.BranchId=@UserBranchId

			declare @UserBalance money
			select top 1 @UserBalance=ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) from RiskManagement.BranchTransaction with (nolock)
						where BranchId=@BranchId order by CreateDate desc

			
			select top 1 @CustomerId=Customer.Customer.CustomerId from Customer.Customer with (nolock) where BranchId=@BranchId and IsTerminalCustomer=1

					insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance])
						values(@BranchId,@CustomerId,@TransactionTypeId,@Amount,@CurrencyId,GETDATE(),@UserId,@UserBalance)

				end
			 

		

			end
			
					


						


		end
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
if @ActivityCode=2
	begin

exec [Log].[ProcTransactionLogUID]  35,@ActivityCode,@Username,@BranchId,'Parameter.Branch'
	,@NewValues,null
	
	insert Parameter.Branch(BrancName,CreateDate,Balance,CommisionRate,IsActive,CurrencyId,BranchCommisionTypeId,IsBonusDeducting,MaxWinningLimit,MaxCopySlip,[MinTicketLimit],MaxEventForTicket,ParentBranchId,IsTerminal,IsWebPos)
	values(@BranchName,GETDATE(),0,@CommisionRate,@IsActive,@CurrencyId,1,@IsBonusDeducting,@MaxWiningLimit,@MaxCopySlip,@MinTicketLimit,@MaxEventForTicket,@ParentBranchId,@IsTerminal,@IsWebPos)
	
	set @BranchId=SCOPE_IDENTITY()





	update Parameter.Branch set BrachCode=@BranchId where BranchId=@BranchId


		insert [Users].Users(UserName,Password,Name,Surname,Email,GsmNo,TimeZoneId,CurrencyId,LanguageId,CreateDate,IsLockedOut,FailedPasswordAttemptCount,UnitCode,[Multiplier],MultipDate,PositionCode)
			values (@BranchUserName,@Password,@BranchUserName,'',@BranchUserName,'',1,@CurrencyId,@LangId,GETDATE(),0,0,@BranchId,1,'20180101','1')
			declare @NewUserId int
			set @NewUserId=SCOPE_IDENTITY()
		execute Retail.[ProcUsersRoleUID]  0,158,@NewUserId,2,'',@username

			 
				insert Customer.Customer(CustomerName,CurrencyId,Balance,Username,Password,CreateDate,IpAddress,IsLockedOut,CustomerSurname,Email,Birthday,PhoneNumber,LanguageId,BranchId,IsActive,TimeZoneId,OddsFormatId,CountryId,PasswordQuestionId,PasswordQuestion,SalutationId,ZipCode,Address,AddressAdditional,IsOddIncreasement,IsOddDecreasements,City,IsTempLock,PhoneCodeId,GroupId,Bonus,FailedPasswordAttemptCount,IsBranchCustomer,IsTerminalCustomer)
					values(cast(@BranchId as nvarchar(20))+'_branch',@CurrencyId,0,cast(@BranchId as nvarchar(20))+'_branch',@Password,GETDATE(),'',0,' ',cast(@BranchId as nvarchar(20))+'_branch',GETDATE(),111111111,@LangId,@BranchId,@IsActive,1,1,1,1,'',1,'','','',1,1,1,0,1,1,0,0,1,0)
					set @CustomerId=SCOPE_IDENTITY()
					
					insert Customer.Limit(CustomerId,StakeDailyLimit,StakeWeeklyLimit,StakeMonthlyLimit,DepositDailyLimit,DepositWeeklyLimit,DepositMonthlyLimit,LossDailyLimit,LossWeeklyLimit,LossMonthlyLimit)
					select @CustomerId,StakeDailyLimit,StakeWeeklyLimit,StakeMonthlyLimit,DepositDailyLimit,DepositWeeklyLimit,DepositMonthlyLimit,LossDailyLimit,LossWeeklyLimit,LossMonthlyLimit
					from Parameter.CustomerLimit
					
						insert Customer.StakeLimit(CustomerId,CreditLimit,LimitPerTicket,MaxStakeGame,MaxStakeFactor,MaxStakeGamePercent,LimitPerLiveTicket,StakeDay,StakeWeek,StakeMonth,MinCombiBranch,MinCombiInternet,MinCombiMachine,PendingTime)
					select @CustomerId,CreditLimit,LimitPerTicket,MaxStakeGame,MaxStakeFactor,MaxStakeGamePercent,LimitPerLiveTicket,StakeDay,StakeWeek,StakeMonth,MinCombiBranch,MinCombiInternet,MinCombiMachine,10
					from Parameter.CustomerLimit

	set @BranchBalance=0

	if(@BranchBalance<>@Balance and (@ParentBranchId=@UserBranchId or @UserRoleId=1) and @Balance>0) --Sadece Parent Branch veya Admin kullanıcısı bakiyelerini değiştirebiliyor.
		begin
	

			if(@BranchBalance>@Balance)
				begin
					set @TransactionTypeId=5 --withdraw
					set @Amount=@BranchBalance-@Balance
				end
			else
				begin
					set @TransactionTypeId=3 --deposit
					set @Amount=@Balance-@BranchBalance
				end

			
					insert RiskManagement.BranchDepositRequest(RequestUserId,BranchId,RequestDate,Amount,CurrencyId,BranchNote,TransactionTypeId,IsApproved,ApprovedUserId,ApprovedDate)
				values (@UserId,@BranchId,GETDATE(),@Amount,@CurrencyId,'',@TransactionTypeId,1,@UserId,GETDATE())

				insert RiskManagement.BranchTransaction (BranchId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId)
						values(@BranchId,@TransactionTypeId,@Amount,@CurrencyId,GETDATE(),@UserId)

							update Parameter.Branch set
							Balance=@Balance
							where Parameter.Branch.BranchId=@BranchId

		end


	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
	
	
	end


	select @resultcode as resultcode,@resultmessage as resultmessage
END



GO
