USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSlipOddsEvaluateSystem_Old]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcSlipOddsEvaluateSystem_Old] 
@MatchId bigint,
@OddTypeId int,
@BetTypeId int
as 


begin    

declare @SlipId bigint
declare @Amount money
declare @Gain money
declare @CustomerId bigint
declare @TotalOdd float
declare @tempSlip table (SlipId bigint,Gain money,CustomerId bigint,Amount money,SlipTyepId int,Systems nvarchar(300),SystemSlipId bigint)
declare @SlipTypeId int
declare @IsBranchCustomer bit
declare @Systems nvarchar(300)
declare @SystemSlipId bigint
insert @tempSlip
	select DISTINCT Archive.Slip.SlipId,Archive.Slip.Amount*Archive.Slip.TotalOddValue,Archive.Slip.CustomerId,Archive.Slip.Amount,Archive.Slip.SlipTypeId,Customer.SlipSystem.[System],Customer.SlipSystemSlip.SystemSlipId
					FROM         Archive.SlipOdd with (nolock)  INNER JOIN
                      Archive.Slip with (nolock)  ON Archive.SlipOdd.SlipId = Archive.Slip.SlipId INNER JOIN Customer.SlipSystemSlip 
					  ON Customer.SlipSystemSlip.SlipId=Archive.Slip.SlipId INNER JOIN
					  Customer.SlipSystem ON Customer.SlipSystem.SystemSlipId=Customer.SlipSystemSlip.SystemSlipId
					where Archive.SlipOdd.SlipId=1751785	

set nocount on
					declare cur111 cursor local for(
					select SlipId,Gain,CustomerId,Amount,SlipTyepId,Systems,SystemSlipId From @tempSlip

						)

					open cur111
					fetch next from cur111 into @SlipId,@Gain,@CustomerId,@Amount, @SlipTypeId,@Systems,@SystemSlipId
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


declare @SystemCount int
declare @WinAmount money=0
declare @TotalWinAmount money=0
declare @OddValue float
declare @Odds nvarchar(300)=''
declare @say int=0
declare @BankoOddValue float =1
declare @IsBanko int=0
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
							select @SlipId
								if not exists (Select Archive.SlipOdd.SlipId from Archive.SlipOdd with (nolock) where SlipId=@SlipId and StateId=4 and Banko=1)
								begin
									if not exists(Select Archive.SlipOdd.SlipId from Archive.SlipOdd with (nolock) where SlipId=@SlipId and StateId=1)
										begin
											if(select COUNT(*) from Archive.SlipOdd with (nolock) where SlipId=@SlipId and StateId in (3,2))>=@SystemCount
												begin
												set @BankoOddValue=1
													set nocount on
															declare cur11123 cursor local for(
															select OddValue,Banko From Archive.SlipOdd with (nolock) where SlipId=@SlipId and StateId in (3,2)

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
															select @WinAmount
															set @Odds=''
										

												end
										end
									else
										begin
										if((Select Count(*) from Archive.SlipOdd with (nolock) where SlipId=@SlipId)-ISNULL((select ISNULL(COUNT(*),0) from Archive.SlipOdd with (nolock) where SlipId=@SlipId and StateId =4),0) )<@SystemCount and @say=1
										begin
														update Customer.SlipSystem set SlipStateId=4,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId
												update Archive.Slip set SlipStateId=4 ,EvaluateDate=GETDATE() where SlipId=@SlipId
												update Customer.Tax set TaxStatusId=3 where SlipId =@SystemSlipId and SlipTypeId=3
													end
										end
								end
								else
									begin
										 
											update Customer.SlipSystem set SlipStateId=4,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId
												update Archive.Slip set SlipStateId=4 ,EvaluateDate=GETDATE() where SlipId=@SlipId
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
									 if not exists(Select Archive.SlipOdd.SlipId  from Archive.SlipOdd with (nolock) where SlipId=@SlipId and StateId=1)
								begin
								    exec Job.FuncCustomerBooking @CustomerId,@TotalWinAmount,1,@SlipId
									update Customer.SlipSystem set SlipStateId=3 ,MaxGain=@TotalWinAmount,EvaluateDate=GETDATE(),IsPayOut= Case when @IsBranchCustomer=1 then 0 else 1 end where SystemSlipId=@SystemSlipId
									update Archive.Slip set SlipStateId=3 ,EvaluateDate=GETDATE(),IsPayOut  =Case when @IsBranchCustomer=1 then 0 else 1 end where SlipId=@SlipId
									update Customer.Tax set TaxStatusId=3 where SlipId =@SystemSlipId and SlipTypeId=3
									 end
							end
						else
							begin
								 if not exists(Select Archive.SlipOdd.SlipId from Archive.SlipOdd with (nolock) where SlipId=@SlipId and StateId=1)
								begin
									update Customer.SlipSystem set SlipStateId=4,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId
									update Archive.Slip set SlipStateId=4 ,EvaluateDate=GETDATE() where SlipId=@SlipId
									update Customer.Tax set TaxStatusId=3 where SlipId =@SystemSlipId and SlipTypeId=3
									 end
							end
	set @say=0
	set @TotalWinAmount=0
	set @WinAmount=0
 delete from  @tblOdd

end
							fetch next from cur111 into @SlipId,@Gain,@CustomerId,@Amount,@SlipTypeId,@Systems,@SystemSlipId
			
						end
					close cur111
					deallocate cur111

					delete @tempSlip
end


GO
