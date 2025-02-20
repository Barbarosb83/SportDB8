USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcTransactionPasswordUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcTransactionPasswordUID]
@TransactionId Bigint,
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
	
		update [RiskManagement].[BranchTransactionPass] set [Password]=@Password where [BranchTransactionId] =@TransactionId

	 
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	 
	
	end
if @ActivityCode=2
	begin

		if not exists(select [RiskManagement].[BranchTransactionPass].BranchTransactionId from [RiskManagement].[BranchTransactionPass] where [RiskManagement].[BranchTransactionPass].BranchTransactionId=@TransactionId)
		begin
			insert [RiskManagement].[BranchTransactionPass]([BranchTransactionId] ,[Password],IsPaid,CreateDate) values (@TransactionId,@Password,0,GETDATE())
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId
		end

	end
if @ActivityCode=3
	begin
			if exists (select [RiskManagement].[BranchTransactionPass].BranchTransactionId from [RiskManagement].[BranchTransactionPass] where BranchTransactionId=@TransactionId and  [Password]=@Password and IsPaid=0) --Ödeme Daha önce 
				begin
						declare @BranchId int
						
						select @BranchId=BranchId from RiskManagement.BranchTransaction where BranchTransactionId=(select top 1 BranchTransactionId from [RiskManagement].[BranchTransactionPass] where BranchTransactionId=@TransactionId and  [Password]=@Password and IsPaid=0)
				 
						
						if exists (select Parameter.Branch.BranchId from Parameter.Branch where (Parameter.Branch.ParentBranchId=@UserBranchId and BranchId=@BranchId) or (@UserBranchId=@BranchId) or ((Select ParentBranchId from Parameter.Branch where BranchId=@UserBranchId)=(Select ParentBranchId from Parameter.Branch where BranchId=@BranchId)))  --Ödeme Bu bayiden yapılabilir.
							select @resultcode=1,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId
						else --Bu ödeme bu bayiden yapılamaz.
							select @resultcode=3,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId

				end
			else if exists (select [RiskManagement].[BranchTransactionPass].BranchTransactionId from [RiskManagement].[BranchTransactionPass] where BranchTransactionId=@TransactionId and  [Password]=@Password and IsPaid=1)
				begin
					select @resultcode=2,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId
				end
			else
				select @resultcode=-1,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId
			
	end

--		 if(select count(Customer.Slip.SlipId) from Customer.Slip where Customer.Slip.SlipId=@SlipId )>0
--		 begin
--			if(select count(Customer.Slip.SlipId) from Customer.Slip where Customer.Slip.SlipId=@SlipId and Customer.Slip.SlipTypeId<>3)>0
--			begin
--			  if exists (select * from Customer.SlipPassword where SlipId=@SlipId and Password=@Password)
--				begin
--				select @resultcode=ErrorCodeId,@resultmessage='success' from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId
--						exec [Log].ProcConcatOldValues  'SlipPassword','[Customer]','SlipId',@SlipId,@OldValues output
	
--			exec [Log].[ProcTransactionLogUID]  41,@ActivityCode,@Username,@SlipId,'[Customer].[SlipPassword]'
--			,@NewValues,@OldValues
--				end
--				else
--				select @resultcode=106,@resultmessage='Wrong secret code' from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId
--			end
--			else
--			begin
--			 if exists (select * from Customer.SlipPassword where SlipId in (Select SlipId from Customer.SlipSystemSlip where SystemSlipId=(Select SystemSlipId from Customer.SlipSystemSlip where SlipId=@SlipId)) and Password=@Password)
--				begin
--				select @resultcode=ErrorCodeId,@resultmessage='success' from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId
--						exec [Log].ProcConcatOldValues  'SlipPassword','[Customer]','SlipId',@SlipId,@OldValues output
	
--			exec [Log].[ProcTransactionLogUID]  41,@ActivityCode,@Username,@SlipId,'[Customer].[SlipPassword]'
--			,@NewValues,@OldValues
--				end
--				else
--				select @resultcode=106,@resultmessage='Wrong secret code' from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId

--			end
--		end
--		else
--			begin
--				if(select count(Archive.Slip.SlipId) from Archive.Slip where Archive.Slip.SlipId=@SlipId and Archive.Slip.SlipTypeId<>3)>0
--			begin
--			  if exists (select * from Customer.SlipPassword where SlipId=@SlipId and Password=@Password)
--				begin
--				select @resultcode=ErrorCodeId,@resultmessage='success' from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId
--						exec [Log].ProcConcatOldValues  'SlipPassword','[Customer]','SlipId',@SlipId,@OldValues output
	
--			exec [Log].[ProcTransactionLogUID]  41,@ActivityCode,@Username,@SlipId,'[Customer].[SlipPassword]'
--			,@NewValues,@OldValues
--				end
--				else
--				select @resultcode=106,@resultmessage='Wrong secret code' from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId
--			end
--			else
--			begin
--			 if exists (select * from Customer.SlipPassword where SlipId in (Select SlipId from Customer.SlipSystemSlip where SystemSlipId=(Select SystemSlipId from Customer.SlipSystemSlip where SlipId=@SlipId)) and Password=@Password)
--				begin
--				select @resultcode=ErrorCodeId,@resultmessage='success' from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId
--						exec [Log].ProcConcatOldValues  'SlipPassword','[Customer]','SlipId',@SlipId,@OldValues output
	
--			exec [Log].[ProcTransactionLogUID]  41,@ActivityCode,@Username,@SlipId,'[Customer].[SlipPassword]'
--			,@NewValues,@OldValues
--				end
--				else
--				select @resultcode=106,@resultmessage='Wrong secret code' from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId

--			end
--			end

		

--	end



	select @resultcode as resultcode,@resultmessage as resultmessage
END




GO
