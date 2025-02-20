USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcSlipPasswordUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Retail].[ProcSlipPasswordUID]
@SlipId Bigint,
@Password nvarchar(150),
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
declare @BranchBalance money
declare @ParentBranchBalance money
declare @Control int=0
declare @TryCount int=0
declare @SystemSlipId bigint=0
--declare @UserId int
--declare @UserRoleId int
--declare @UserBranchId int 
select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
			declare @TransactionTypeId int
--				declare @Amount money 
--select @UserRoleId=Users.UserRoles.RoleId,@UserId=Users.Users.UserId,@UserBranchId=Users.Users.UnitCode 
--from Users.UserRoles with (nolock) INNER JOIN Users.Users ON Users.UserRoles.UserId=Users.Users.UserId where UserName=@username


 --insert dbo.betslip (CreateDate,data,id) values (GETDATE(),@Password,@SlipId)

if @ActivityCode=1
	begin
	--	exec [Log].ProcConcatOldValues     'Branch','[Parameter]','BranchId',@BranchId,@OldValues output
	
	--exec [Log].[ProcTransactionLogUID]  35,@ActivityCode,@Username,@BranchId,'Parameter.Branch'
	--,@NewValues,@OldValues
	
		update Customer.SlipPassword set [Password]=@Password,TryCount=0 where SlipId=@SlipId

	 
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	 
	
	end
if @ActivityCode=2
	begin

	if not exists (Select Customer.SlipPassword.SlipId From Customer.SlipPassword with (nolock) where SlipId=@SlipId)
	  insert Customer.SlipPassword(SlipId,[Password],TryCount) values (@SlipId,@Password,0)
		select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId

	end
if @ActivityCode=3
	begin

		 if exists (select Customer.Slip.SlipId from Customer.Slip with (nolock) where Customer.Slip.SlipId=@SlipId )
		 begin
			--if exists (select Customer.Slip.SlipId from Customer.Slip with (nolock) where Customer.Slip.SlipId=@SlipId /*and Customer.Slip.SlipTypeId<3*/)
			--begin
			if exists (select Customer.SlipPassword.SlipId from Customer.SlipPassword with (nolock) where SlipId=@SlipId )
				begin
			  if exists (select Customer.SlipPassword.SlipId from Customer.SlipPassword with (nolock) where SlipId=@SlipId and Password=@Password)
				begin
				select @resultcode=ErrorCodeId,@resultmessage='success' from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId
					
				end
				else
					begin
						 if exists (select Customer.SlipPassword.SlipId from Customer.SlipPassword with (nolock) where SlipId=@SlipId and TryCount<3)
						 begin
						 

							select @TryCount=TryCount+1 from Customer.SlipPassword where SlipId=@SlipId

							update Customer.SlipPassword set TryCount=@TryCount where SlipId=@SlipId

							select @resultcode=106,@resultmessage='falscher Sicherheitscode' from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId

						end
						else
							select @resultcode=106,@resultmessage='Sicherheitsnummer gesperrt. Bitte wenden Sie sich an den Systemadministrator.' from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId
					end
				end
			else
				select @resultcode=106,@resultmessage='falscher Sicherheitscode' from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId
			--end
			--else
			--begin
				 
			-- if exists (select Customer.SlipPassword.SlipId from Customer.SlipPassword with (nolock) where SlipId in (Select SlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId=(Select SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)) and Password=@Password)
			--	begin
			--	select @resultcode=ErrorCodeId,@resultmessage='success' from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId
			--			exec [Log].ProcConcatOldValues  'SlipPassword','[Customer]','SlipId',@SlipId,@OldValues output
	
			--exec [Log].[ProcTransactionLogUID]  41,@ActivityCode,@Username,@SlipId,'[Customer].[SlipPassword]'
			--,@NewValues,@OldValues
			--	end
			--	else
			--	select @resultcode=106,@resultmessage='falscher Sicherheitscode' from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId

			--end
		end
		else
			begin
				if exists (select Archive.Slip.SlipId from Archive.Slip with (nolock) where Archive.Slip.SlipId=@SlipId /*and Archive.Slip.SlipTypeId<3*/)
					begin
						if exists (select Customer.SlipPassword.SlipId from Customer.SlipPassword with (nolock) where SlipId=@SlipId )
							begin
								if exists (select Customer.SlipPassword.SlipId from Customer.SlipPassword with (nolock)  where SlipId=@SlipId and Password=@Password)
									begin
										select @resultcode=ErrorCodeId,@resultmessage='success' from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId
										
									end
									else
										begin
											 if exists (select Customer.SlipPassword.SlipId from Customer.SlipPassword with (nolock) where SlipId=@SlipId and TryCount<3)
											 begin
												

												select @TryCount=TryCount+1 from Customer.SlipPassword where SlipId=@SlipId

												update Customer.SlipPassword set TryCount=@TryCount where SlipId=@SlipId

												select @resultcode=106,@resultmessage='falscher Sicherheitscode' from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId

											end
											else
												select @resultcode=106,@resultmessage='Sicherheitsnummer gesperrt. Bitte wenden Sie sich an den Systemadministrator.' from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId
										end
							end
						else
						  select @resultcode=106,@resultmessage='falscher Sicherheitscode' from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId
					end
				--else
				--	begin
				--		if exists (select Customer.SlipPassword.SlipId from Customer.SlipPassword with (nolock) where SlipId in (Select SlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId=(Select SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)) and Password=@Password)
				--			begin
				--				select @resultcode=ErrorCodeId,@resultmessage='success' from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId
				--						exec [Log].ProcConcatOldValues  'SlipPassword','[Customer]','SlipId',@SlipId,@OldValues output
	
				--				exec [Log].[ProcTransactionLogUID]  41,@ActivityCode,@Username,@SlipId,'[Customer].[SlipPassword]'
				--				,@NewValues,@OldValues
				--			end
				--		else
				--		select @resultcode=106,@resultmessage='falscher Sicherheitscode' from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId

				--	end
			end

		

	end



	select @resultcode as resultcode,@resultmessage as resultmessage
END




GO
