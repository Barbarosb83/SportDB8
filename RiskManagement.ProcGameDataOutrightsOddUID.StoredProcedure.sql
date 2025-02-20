USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameDataOutrightsOddUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcGameDataOutrightsOddUID]
@OddId int,
@OddValue float,
@StateId int,
@Limit money,
@LimitPerTicket money,
@StakeLimit money,
@Availabity nvarchar(20),
@MinCombiBranch int,
@MinCombiInternet int,
@MinCombiMachine int,
@IsOddValueLock bit,
@LangId int,
@username nvarchar(max),
@ActivityCode int,
@NewValues nvarchar(max)


AS

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @AvailabityId int=0
declare @oddSettingId int


BEGIN
SET NOCOUNT ON;

select @AvailabityId=Parameter.MatchAvailability.AvailabilityId from Parameter.MatchAvailability
where Parameter.MatchAvailability.Availability=@Availabity

select @oddSettingId=Outrights.OddSetting.OddSettingId
from Outrights.OddSetting
where Outrights.OddSetting.OddId=@OddId

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId

declare @FixtureId int



if(@ActivityCode=1)
	begin
	
	--exec [Log].ProcConcatOldValues  'Odd','[Outrights]','OddId',@OddId,@OldValues output
	
	--exec [Log].[ProcTransactionLogUID] 32,@ActivityCode,@Username,@OddId,'Outrights.OddId'
	--,@NewValues,@OldValues
	

	
	--update Outrights.OddSetting set
	--LossLimit=@Limit,
	--StateId=@StateId,
	--LimitPerTicket=@LimitPerTicket,
	--AvailabilityId=@AvailabityId,
	--MinCombiBranch=@MinCombiBranch,
	--MinCombiInternet=@MinCombiInternet,
	--MinCombiMachine=@MinCombiMachine,
	--StakeLimit=@StakeLimit
	--where OddSettingId=@oddSettingId
	
	update Outrights.Odd set
	OddValue=@OddValue,
	IsOddValueLock=@IsOddValueLock
	where Outrights.Odd.OddId=@OddId


declare @CompetitorId bigint
			declare @MatchId bigint
			declare @OddTypeId int
	if(@StateId=5)
		begin
			
			select @CompetitorId=Outrights.Odd.CompetitorId,
			@MatchId=Outrights.Odd.MatchId
			 from Outrights.Odd where Outrights.Odd.OddId=@OddId
			 if (select Count(Outrights.OddResult.OddsResultId) from Outrights.OddResult where Outrights.OddResult.MatchId=@MatchId and CompetitorId=@CompetitorId)=0
				begin
					insert Outrights.OddResult(MatchId,OddId,RankNo,CompetitorId,IsEvoluate)
					values(@MatchId,@OddId,1,@CompetitorId,0)
				end
			
			
		end
	else if (@StateId in (2,4,6))
		begin
			
			select @CompetitorId=Outrights.Odd.CompetitorId,
			@MatchId=Outrights.Odd.MatchId,@OddTypeId=Outrights.Odd.OddsTypeId
			 from Outrights.Odd where Outrights.Odd.OddId=@OddId
			if (select Count(Outrights.OddResult.OddsResultId) from Outrights.OddResult where Outrights.OddResult.MatchId=@MatchId and CompetitorId=@CompetitorId)>0
				begin
					if (select Count(Outrights.OddResult.OddsResultId) from Outrights.OddResult where Outrights.OddResult.MatchId=@MatchId and CompetitorId=@CompetitorId and IsEvoluate=1)>0					
						begin
							--Eğer odd daha önce won yapıldıysa ve geri alınıyorsa o odd'un olduğu won kupon varmı diye bakılıyor. 
							if(select COUNT(Customer.SlipOdd.SlipOddId) FROM Customer.Slip with (nolock) INNER JOIN
							Customer.SlipOdd with (nolock) ON Customer.Slip.SlipId = Customer.SlipOdd.SlipId
								where Customer.SlipOdd.OddId=@OddId and BetTypeId=2 and Customer.Slip.SlipStateId in (3,5,6))>0
									begin
									--eğer varsa o kuponlar open veya lost durumuna getirelecek.
									if(@StateId=6)
										begin
											update Customer.SlipOdd set StateId=4 where OddId=@OddId and BetTypeId=2
											
											exec [RiskManagement].[ProcSlipOddsEvaluate] @MatchId,@OddTypeId,2
								
										end
									end
						end
					else
						begin
							delete from Outrights.OddResult where Outrights.OddResult.MatchId=@MatchId and CompetitorId=@CompetitorId
						end
				end
		
		end
	

			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId

	end



	select @resultcode as resultcode,@resultmessage as resultmessage




END


GO
