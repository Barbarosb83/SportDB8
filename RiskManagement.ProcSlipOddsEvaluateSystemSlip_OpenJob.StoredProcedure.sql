USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSlipOddsEvaluateSystemSlip_OpenJob]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [RiskManagement].[ProcSlipOddsEvaluateSystemSlip_OpenJob] 
 as

begin    

 declare @SlipId bigint
declare @Amount money
declare @CustomerId bigint
declare @TotalOdd float
declare @tempSlip table (SlipId bigint,CustomerId bigint,Amount money,SlipTyepId int,Systems nvarchar(300),SystemSlipId bigint)
declare @SlipTypeId int
declare @IsBranchCustomer bit
declare @Systems nvarchar(300)
declare @SystemSlipId bigint
insert @tempSlip
	select DISTINCT Customer.Slip.SlipId,Customer.Slip.CustomerId,Customer.Slip.Amount,Customer.Slip.SlipTypeId,Customer.SlipSystem.[System],Customer.SlipSystemSlip.SystemSlipId
					FROM         Customer.SlipOdd with (nolock)  INNER JOIN
                      Customer.Slip with (nolock)  ON Customer.SlipOdd.SlipId = Customer.Slip.SlipId INNER JOIN Customer.SlipSystemSlip 
					  ON Customer.SlipSystemSlip.SlipId=Customer.Slip.SlipId INNER JOIN
					  Customer.SlipSystem with (nolock) ON Customer.SlipSystem.SystemSlipId=Customer.SlipSystemSlip.SystemSlipId
					where  Customer.SlipSystem.NewSlipTypeId=4 and Customer.SlipOdd.SlipId in (select SlipId FROM            Customer.Slip with (nolock)
WHERE     (SlipId IN
                             (SELECT        SlipId
                               FROM            Customer.SlipSystemSlip with (nolock)
                               WHERE        (SystemSlipId IN
                                                             (SELECT        SystemSlipId
                                                               FROM            Customer.SlipSystem with (nolock)
                                                               WHERE        (NewSlipTypeId = 4) AND (SlipStateId = 1) AND (SystemSlipId IN
                                                                                             (SELECT        SystemSlipId
                                                                                               FROM            Customer.SlipSystemSlip AS SlipSystemSlip_1 with (nolock)
                                                                                               WHERE        (SlipId IN
                                                                                                                             (SELECT        SlipId
                                                                                                                               FROM            Customer.SlipOdd
                                                                                                                               WHERE        (StateId <> 1))))))))))

set nocount on
					declare cur111 cursor local for(
					select SlipId,CustomerId,Amount,SlipTyepId,Systems,SystemSlipId From @tempSlip

						)

						open cur111
					fetch next from cur111 into @SlipId,@CustomerId,@Amount, @SlipTypeId,@Systems,@SystemSlipId
					while @@fetch_status=0
						begin
							begin

DECLARE @Delimeter char(1)
SET @Delimeter = ','
declare @sayac int=0
DECLARE @tblOdd TABLE( SystemCount nvarchar(10))
DECLARE @tbltemp TABLE(Id int)
DECLARE @ak nvarchar(10)
DECLARE @StartPos int, @Length int
WHILE LEN(@Systems) > 0
  BEGIN
    SET @StartPos = CHARINDEX(@Delimeter, @Systems)
    IF @StartPos < 0 SET @StartPos = 0
    SET @Length = LEN(@Systems) - @StartPos - 1
    IF @Length < 0 SET @Length = 0
    IF @StartPos > 0
      BEGIN
        SET @ak = SUBSTRING(@Systems, 1, @StartPos - 1)
        SET @Systems = SUBSTRING(@Systems, @StartPos + 1, LEN(@Systems) - @StartPos)
        set @sayac=@sayac+1
      END
    ELSE
      BEGIN
        SET @ak = @Systems
        SET @Systems = ''
        set @sayac=@sayac+1
      END
    INSERT @tblOdd ( SystemCount) VALUES(@ak)
END




	

select @IsBranchCustomer=IsBranchCustomer from Customer.Customer with (nolock) where CustomerId=@CustomerId
declare @SystemCount int=999
declare @WinAmount money=0
declare @TotalWinAmount money=0
declare @OddValue float
declare @Odds nvarchar(300)=''
declare @say int=0
declare @BankoOddValue float =1
declare @IsBanko int=0

	if not exists (Select Customer.SlipOdd.SlipId from Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId=4 and Banko=1)
	begin

set nocount on
					declare cur1112 cursor local for(
					select SystemCount From @tblOdd 

						)
					order by cast( SystemCount as int)
					open cur1112
					fetch next from cur1112 into @SystemCount
					while @@fetch_status=0
						begin
							begin
							set @say=@say+1
							
								if not exists (Select Customer.SlipOdd.SlipId from Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId=4 and Banko=1)
								begin
									if not exists(Select Customer.SlipOdd.SlipId from Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId=1)
										begin
											if(select COUNT(*) from Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId in (3,2,5))>=@SystemCount
												begin
												set @BankoOddValue=1
													set nocount on
															declare cur11123 cursor local for(
															select case when stateid =3 then OddValue else 1 end,Banko From Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId in (3,2)

																)

															open cur11123
															fetch next from cur11123 into @OddValue,@IsBanko
															while @@fetch_status=0
																begin
																	begin
																		if(@IsBanko=0)
																			set @Odds=@Odds+cast(@OddValue as nvarchar(10))+';'
																		else
																		begin
																		--set @Odds=@Odds+cast('1' as nvarchar(10))+';'
																			set @BankoOddValue=@BankoOddValue*@OddValue
																			end
																	end
																	fetch next from cur11123 into @OddValue,@IsBanko
			
																end
															close cur11123
															deallocate cur11123

															set @Odds=SUBSTRING(@Odds,1,LEN(@Odds)-1)
															select @WinAmount=[RiskManagement].[FuncSlipSystemEvaluate]   (@SystemCount,@Odds,@Amount)
															--set @WinAmount=@WinAmount*@BankoOddValue
															set @TotalWinAmount=@TotalWinAmount+ @WinAmount

															set @Odds=''
										

												end
										end
									else
										begin
										if(@say=1)
											begin
												if((Select Count(*) from Customer.SlipOdd with (nolock) where SlipId=@SlipId)-ISNULL((select ISNULL(COUNT(*),0) from Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId =4),0) )<@SystemCount
													begin
																					 
														update Customer.SlipSystem set SlipStateId=4,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId
														update Customer.Slip set SlipStateId=4 ,EvaluateDate=GETDATE() where SlipId=@SlipId
														update Customer.Tax set TaxStatusId=3 where SlipId =@SystemSlipId and SlipTypeId=3
													 
													end
												--else if exists (Select Customer.SlipOdd.SlipId  from Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId=1) and (Select COUNT(*) from Customer.Slip where SlipId=@SlipId and SlipStateId=4)>0
												--		begin
												--			update Customer.SlipSystem set SlipStateId=1  where SystemSlipId=@SystemSlipId
												--			update Customer.Slip set SlipStateId=1   where SlipId=@SlipId
												--		end
										end
										end
								end
								else
									begin
										 									 
											update Customer.SlipSystem set SlipStateId=4,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId
												update Customer.Slip set SlipStateId=4 ,EvaluateDate=GETDATE() where SlipId=@SlipId
												update Customer.Tax set TaxStatusId=3 where SlipId =@SystemSlipId and SlipTypeId=3
												 
											
										 
									end
							end
							fetch next from cur1112 into @SystemCount
			
						end
					close cur1112
					deallocate cur1112

					if(@TotalWinAmount>0)
							begin
									set @TotalWinAmount=@TotalWinAmount*@BankoOddValue
									 if not exists(Select Customer.SlipOdd.SlipId  from Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId=1)
										begin
										if not exists (select Customer.Slip.SlipId from Customer.Slip where SlipId=@SlipId and SlipStateId=3 and IsPayOut=1)
										begin
											exec Job.FuncCustomerBooking @CustomerId,@TotalWinAmount,1,@SlipId
											update Customer.SlipSystem set SlipStateId=3 ,MaxGain=@TotalWinAmount,EvaluateDate=GETDATE(),IsPayOut= Case when @IsBranchCustomer=1 then 0 else 1 end where SystemSlipId=@SystemSlipId
											update Customer.Slip set SlipStateId=3 ,EvaluateDate=GETDATE(),IsPayOut  =Case when @IsBranchCustomer=1 then 0 else 1 end where SlipId=@SlipId
											update Customer.Tax set TaxStatusId=3 where SlipId =@SystemSlipId and SlipTypeId=3

											if (select EXP(SUM(LOG(OddValue))) from Customer.SlipOdd with (nolock) where SlipId=@SlipId)=1 -- Eğer kupondaki tüm maçlar cancel olduysa tax da geri yükleniyor.
													begin
														declare @TaxAmount money=0
														declare @TaxId bigint=0
														select @TaxAmount=TaxAmount,@TaxId=Customer.Tax.TaxId from Customer.Tax where SlipId=@SystemSlipId and SlipTypeId=3
														update Customer.Tax set TaxStatusId=2 where SlipId=@SlipId
																update Customer.SlipSystem set  MaxGain=@TotalWinAmount+@TaxAmount  where SystemSlipId=@SystemSlipId
														exec  [Job].[FuncCustomerBooking2]  @CustomerId,@TaxAmount,1,54,@TaxId

													end

										end
									
									 end
							end
						else
							begin
								 if not exists(Select Customer.SlipOdd.SlipId from Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId=1)
								begin
								if((Select Count(*) from Customer.SlipOdd with (nolock) where SlipId=@SlipId)-ISNULL((select ISNULL(COUNT(*),0) from Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId =4),0) )<(select top 1 cast(SystemCount as int) From @tblOdd order by cast( SystemCount as int))
									begin
																			 
									update Customer.SlipSystem set SlipStateId=4,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId
									update Customer.Slip set SlipStateId=4 ,EvaluateDate=GETDATE() where SlipId=@SlipId
									update Customer.Tax set TaxStatusId=3 where SlipId =@SystemSlipId and SlipTypeId=3
								 
									end
									 end
							 
							end
end
else
	begin
										 
		update Customer.SlipSystem set SlipStateId=4,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId
		update Customer.Slip set SlipStateId=4 ,EvaluateDate=GETDATE() where SlipId=@SlipId
		update Customer.Tax set TaxStatusId=3 where SlipId =@SystemSlipId and SlipTypeId=3
 
	end

						
	set @say=0
	set @TotalWinAmount=0
	set @WinAmount=0
 delete from  @tblOdd

end
							fetch next from cur111 into @SlipId,@CustomerId,@Amount,@SlipTypeId,@Systems,@SystemSlipId
			
						end
					close cur111
					deallocate cur111

					delete @tempSlip
end


GO
