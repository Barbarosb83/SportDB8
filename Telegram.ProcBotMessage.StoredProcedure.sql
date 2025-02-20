USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Telegram].[ProcBotMessage]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Telegram].[ProcBotMessage] 
@Mesaj nvarchar(max)
as
BEGIN
	declare @SlipId bigint
		declare @SHAPasswords nvarchar(250)
				declare @Password nvarchar(20)
				declare @Username nvarchar(50)
				declare @StartDate nvarchar(20)=cast(cast(GETDATE() as date) as nvarchar(20))
	declare @Enddate nvarchar(20)=cast(cast(DATEADD(DAY,1,GETDATE()) as date) as nvarchar(20))
DECLARE @Delimeter char(1)
SET @Delimeter = ' '
declare @sayac int=0
DECLARE @tblmesaage TABLE(messagess nvarchar(200),rownum int)

DECLARE @ak nvarchar(100)
DECLARE @StartPos int, @Length int
WHILE LEN(@Mesaj) > 0
  BEGIN
    SET @StartPos = CHARINDEX(@Delimeter, @Mesaj)
    IF @StartPos < 0 SET @StartPos = 0
    SET @Length = LEN(@Mesaj) - @StartPos - 1
    IF @Length < 0 SET @Length = 0
    IF @StartPos > 0
      BEGIN
        SET @ak = SUBSTRING(@Mesaj, 1, @StartPos - 1)
        SET @Mesaj = SUBSTRING(@Mesaj, @StartPos + 1, LEN(@Mesaj) - @StartPos)
        set @sayac=@sayac+1
      END
    ELSE
      BEGIN
        SET @ak = @Mesaj
        SET @Mesaj = ''
        set @sayac=@sayac+1
      END
    INSERT @tblmesaage (messagess,rownum) VALUES(@ak,@sayac)
END
declare @terminalId bigint
declare @MessageTable table (messagee nvarchar(max))
	declare @reportDate datetime=GETDATE()
		declare @reportDate1 datetime=GETDATE()

if(select top 1 messagess from @tblmesaage order by rownum)='TerminalCheck'
	begin
 
		
			select top 1 @terminalId=cast(messagess as bigint) from @tblmesaage order by rownum desc
	insert @MessageTable
		execute [Retail].[ProcTerminalBoxCheckMessage] @terminalId

	end
else if(select top 1 messagess from @tblmesaage order by rownum)='TerminalPassword'
	begin
	
		
			select top 1 @terminalId=cast(messagess as bigint) from @tblmesaage order by rownum desc
	insert @MessageTable
		select 'Terminal Password :'+Users.Users.Password from Users.Users with (nolock) where Users.Users.UnitCode= @terminalId

	end
else if(select top 1 messagess from @tblmesaage order by rownum)='BranchProfit'
	begin
	
		set @reportDate =GETDATE()
		set @reportDate1 =GETDATE()
			select top 1 @terminalId=cast(messagess as bigint) from @tblmesaage order by rownum desc
	insert @MessageTable
		execute [Retail].[ProcCashReportMessage] @terminalId,@reportDate,@reportDate1,2

	end
else if(select top 1 messagess from @tblmesaage order by rownum)='Profit'
	begin
	set @StartDate  =cast(cast(GETDATE() as date) as nvarchar(20))
	set @Enddate  =cast(cast(DATEADD(DAY,1,GETDATE()) as date) as nvarchar(20))
		
			select top 1 @Username= messagess  from @tblmesaage order by rownum desc
	insert @MessageTable
		execute [Retail].[ProcSummaryBranchBettingMessage2] @Username,@StartDate,@Enddate

	end
else if(select top 1 messagess from @tblmesaage order by rownum)='ProfitW'
	begin
	set @StartDate  =cast(cast(DATEADD(DAY,-7,GETDATE())as date) as nvarchar(20))
	set @Enddate  =cast(cast(DATEADD(DAY,1,GETDATE()) as date) as nvarchar(20))
		
			select top 1 @Username= messagess  from @tblmesaage order by rownum desc
	insert @MessageTable
		execute [Retail].[ProcSummaryBranchBettingMessage2] @Username,@StartDate,@Enddate

	end
else if(select top 1 messagess from @tblmesaage order by rownum)='ProfitM'
	begin
		declare @DayOfMount int=0
		select @DayOfMount=DAY(GETDATE())
		set @StartDate=cast(cast(DATEADD(DAY,-(@DayOfMount-1),GETDATE())as date) as nvarchar(20))
		set @Enddate=cast(cast(DATEADD(DAY,1,GETDATE()) as date) as nvarchar(20))
	 
			select top 1 @Username= messagess  from @tblmesaage order by rownum desc
	insert @MessageTable
		execute [Retail].[ProcSummaryBranchBettingMessage2] @Username,@StartDate,@Enddate

	end

else if(select top 1 messagess from @tblmesaage order by rownum)='BranchList'
	begin
	
		 
	insert @MessageTable
			Select cast(Parameter.Branch.BranchId as nvarchar(20))+' '+ Parameter.Branch.BrancName
		from Parameter.Branch where IsTerminal=0 and BranchId<>1

	end
else if(select top 1 messagess from @tblmesaage order by rownum)='TerminalList'
	begin
		select top 1 @terminalId=cast(messagess as bigint) from @tblmesaage order by rownum desc
		 
	insert @MessageTable
			Select cast(Parameter.Branch.BranchId as nvarchar(20))+' '+ Parameter.Branch.BrancName
		from Parameter.Branch where IsTerminal=1 and ParentBranchId=@terminalId

	end
	else if(select top 1 messagess from @tblmesaage order by rownum)='BranchPass'
	begin
	
		
			select top 1 @terminalId=cast(messagess as bigint) from @tblmesaage order by rownum desc
	insert @MessageTable
		select  'Username:'+users.UserName+' Password:'+Users.Users.Password from Users.Users with (nolock) where Users.Users.UnitCode= @terminalId

	end

	else if(select top 1 messagess from @tblmesaage order by rownum)='BranchProfitW'
	begin

		set @reportDate =DATEADD(DAY,-7,GETDATE())
		set @reportDate1 =GETDATE()
	
			select top 1 @terminalId=cast(messagess as bigint) from @tblmesaage order by rownum desc
	insert @MessageTable
		execute [Retail].[ProcCashReportMessage] @terminalId,@reportDate,@reportDate1,2

	end

		else if(select top 1 messagess from @tblmesaage order by rownum)='BranchProfitM'
	begin

		set @reportDate =DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) , 0)
		set @reportDate1 =GETDATE()
	
			select top 1 @terminalId=cast(messagess as bigint) from @tblmesaage order by rownum desc
	insert @MessageTable
		execute [Retail].[ProcCashReportMessage] @terminalId,@reportDate,@reportDate1,2

	end
		else if(select top 1 messagess from @tblmesaage order by rownum)='Slippassword0'
	begin

	
				select top 1 @Password=SlipPassword,@SHAPasswords=SHAPassword from Parameter.SlipPasswords order by NEWID()
		select top 1 @SlipId=cast(messagess as bigint) from @tblmesaage order by rownum desc
	 
		if exists( select SLipId from Customer.SlipPassword where SlipId=@SlipId)
			begin
				

				update Customer.SlipPassword set Customer.SlipPassword.Password=@SHAPasswords,TryCount=0 where SlipId=@SlipId

			end
		else
			insert Customer.SlipPassword (SlipId,[Password],TryCount) values (@SlipId,@SHAPasswords,0)

			insert @MessageTable values ('Password :'+@Password)
	 
	 
	end
		else if(select top 1 messagess from @tblmesaage order by rownum)='Slippassword'
	begin

	 
				select top 1 @Password=SlipPassword,@SHAPasswords=SHAPassword from Parameter.SlipPasswords order by NEWID()
		select top 1 @SlipId=cast(messagess as bigint) from @tblmesaage order by rownum desc
	 
		if exists( select SLipId from Customer.SlipPassword where SlipId=@SlipId)
			begin
				

				update Customer.SlipPassword set Customer.SlipPassword.Password=@SHAPasswords,TryCount=0 where SlipId=@SlipId

			end
		else
			insert Customer.SlipPassword (SlipId,[Password],TryCount) values (@SlipId,@SHAPasswords,0)

			insert @MessageTable values ('Password :'+@Password)
		--		select top 1 @Password=SlipPassword,@SHAPasswords=SHAPassword from Parameter.SlipPasswords order by NEWID()
		--select top 1 @SlipId=cast(messagess as bigint) from @tblmesaage order by rownum desc
		--if exists(Select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId )
		--begin
		--if exists( select SLipId from Customer.SlipPassword with (nolock) where SlipId=@SlipId)
		--	begin
				

		--		update Customer.SlipPassword set Customer.SlipPassword.Password=@SHAPasswords where SlipId=@SlipId

		--	end
		--else
		--	insert Customer.SlipPassword (SlipId,[Password]) values (@SlipId,@SHAPasswords)

		--	insert @MessageTable values ('Password :'+@Password)
		--End
		--else
		--	begin
		--	insert @MessageTable values ('Please contact for system administrator.')
		--	end
	end
		else if(select top 1 messagess from @tblmesaage order by rownum)='Slipstate'
	begin

	
				--select top 1 @Password=SlipPassword,@SHAPasswords=SHAPassword from Parameter.SlipPasswords order by NEWID()
		select top 1 @SlipId=cast(messagess as bigint) from @tblmesaage order by rownum desc
	 declare @txt nvarchar(100)=' Kupon Bulunamadı'
		if exists( select SLipId from Archive.SlipOld with (nolock) where SlipId=@SlipId)
			begin
				
				if (Select SlipTypeId from Archive.SlipOld where SlipId=@SlipId)<3
				begin
				select @txt='State:'+ cast([State] as nvarchar(5))+'  / Odendi mi? :'+ case when IsPayOut=0 then N'Hayır' else 'Evet' end +N' /Kazanılan Tutar:'+ case When SlipStateId<>4
				then CAST(cast(TotalOddValue*Amount as decimal(18,2)) As nvarchar(30)) else '0' end+'€'
				from Archive.SlipOld INNER JOIN Parameter.SlipState On Archive.SlipOld.SlipStateId=Parameter.SlipState.StateId where SlipId=@SlipId
				end
				else
					begin
					select @txt='State:'+ cast([State] as nvarchar(5))+'  / Odendi mi? :'+ case when IsPayOut=0 then N'Hayır' else 'Evet' end
				from Archive.SlipOld INNER JOIN Parameter.SlipState On Archive.SlipOld.SlipStateId=Parameter.SlipState.StateId where SlipId=@SlipId

					declare @SystemSlipId bigint

					select @SystemSlipId =SystemSlipId from Archive.SlipSystemSlip where SlipId=@SlipId

					select  @txt+= N' /Kazanılan Tutar:'+ case When SlipStateId<>4
					then CAST(cast(MaxGain as decimal(18,2)) As nvarchar(30)) else '0' end+'€' from Archive.SlipSystem where SystemSlipId=@SystemSlipId

					end
			end
		 

			insert @MessageTable values (@txt)
	 
	 
	end
		else if(select top 1 messagess from @tblmesaage order by rownum)='Slippay'
	begin
	select top 1 @SlipId=cast(messagess as bigint) from @tblmesaage order by rownum desc
			update Archive.SlipOld set IsPayOut=1 where SlipId=@SlipId
			insert @MessageTable values (N'Kupon Ödendi Olarak İşaretlendi '+cast(@SlipId as nvarchar(50)))
	end
		else if(select top 1 messagess from @tblmesaage order by rownum)='EventClose'
	begin
	select top 1 @SlipId=cast(messagess as bigint) from @tblmesaage order by rownum desc
			update Live.EventSetting set StateId=1 where MatchId=@SlipId
			insert @MessageTable values (N'Live Match Closed '+cast(@SlipId as nvarchar(50)))
	end
	else if(select top 1 messagess from @tblmesaage order by rownum)='PreLive'
	begin
	select top 1 @SlipId=cast(messagess as bigint) from @tblmesaage order by rownum desc
			exec [Betradar].[Live.ProcPreLiveInsert] @SlipId
			insert @MessageTable values (N'Live Match Insert '+cast(@SlipId as nvarchar(50)))
	end
	else if(select top 1 messagess from @tblmesaage order by rownum)='Bonus'
	begin

	
				--select top 1 @Password=SlipPassword,@SHAPasswords=SHAPassword from Parameter.SlipPasswords order by NEWID()
		select top 1 @SlipId=cast(messagess as bigint) from @tblmesaage order by rownum desc
	 set  @txt =' Kupon Bulunamadı'
		if exists( select CustomerBonusId from Customer.Bonus with (nolock) where CustomerId=@SlipId and IsUsed=0)
			begin
				update Customer.Bonus set IsUsed=1 where CustomerId=@SlipId
				update Customer.BonusControl set IsOk=1 where CustomerId=@SlipId
				set @txt='Ok'
			end
		 

			insert @MessageTable values (@txt)
	 
	 
	end

	select * from @MessageTable


END



GO
