USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcResultMatchScoreUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcResultMatchScoreUID]
@ScoreInfoId int,
@MatchId int,
@MatchTimeTypeId int,
@Score nvarchar(20),
@DecidedByFA bit,
@Comment nvarchar(250),
@HomeScore int,
@AwayScore int,
@LangId int,
@username nvarchar(max),
@ActivityCode int,
@NewValues nvarchar(max)


AS

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'


BEGIN
SET NOCOUNT ON;


select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId




if(@ActivityCode=1)
	begin
	
	
	
	--delete from Match.OddsResult where  MatchId=@MatchId
	if(select COUNT(*) from Match.ScoreInfo where ScoreInfoId=@ScoreInfoId)>0
		begin
			exec [Log].ProcConcatOldValues  'ScoreInfo','[Match]','ScoreInfoId',@ScoreInfoId,@OldValues output
	
			exec [Log].[ProcTransactionLogUID] 7,@ActivityCode,@Username,@ScoreInfoId,'Match.ScoreInfo'
			,@NewValues,@OldValues
			
			update Match.ScoreInfo set
			Score=@Score,
			Comment=@Comment,
			MatchTimeTypeId=@MatchTimeTypeId,
			DecidedByFA=@DecidedByFA
			where ScoreInfoId=@ScoreInfoId
		end
	else
		begin
			exec [Log].ProcConcatOldValues  'ScoreInfo','[Archive]','ScoreInfoId',@ScoreInfoId,@OldValues output
	
			exec [Log].[ProcTransactionLogUID] 7,@ActivityCode,@Username,@ScoreInfoId,'Archive.ScoreInfo'
			,@NewValues,@OldValues
		
			update Archive.ScoreInfo set
			Score=@Score,
			Comment=@Comment,
			MatchTimeTypeId=@MatchTimeTypeId,
			DecidedByFA=@DecidedByFA
			where ScoreInfoId=@ScoreInfoId
		end
	--Maç skoru update edildiğinde O maçın tüm kazanan odd resultları siliniyor.
	
	--Maçın odd result hesaplama spsi çalıştırılıyor.
	--exec [RiskManagement].[ProcOddResultInsert] @MatchId,@MatchTimeTypeId,@Score,@HomeScore,@AwayScore
	
	
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId

	end
else if(@ActivityCode=2)
	begin
	

	exec [Log].[ProcTransactionLogUID] 7,@ActivityCode,@Username,@ScoreInfoId,'Match.ScoreInfo'
	,@NewValues,null

		insert Match.ScoreInfo(MatchId,MatchTimeTypeId,Score,DecidedByFA,Comment)
		values(@MatchId,@MatchTimeTypeId,@Score,@DecidedByFA,@Comment)

	--exec [RiskManagement].[ProcOddResultInsert] @MatchId,@MatchTimeTypeId,@Score,@HomeScore,@AwayScore
	
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId

	end
else if(@ActivityCode=3)
	begin
	

	
	
		
	--delete from Match.OddsResult where  MatchId=@MatchId
	if(select COUNT(*) from Match.ScoreInfo where ScoreInfoId=@ScoreInfoId)>0
		begin
			exec [Log].ProcConcatOldValues  'ScoreInfo','[Match]','ScoreInfoId',@ScoreInfoId,@OldValues output
	
			exec [Log].[ProcTransactionLogUID] 7,@ActivityCode,@Username,@ScoreInfoId,'Match.ScoreInfo'
			,null,@OldValues
			delete from Match.ScoreInfo where ScoreInfoId=@ScoreInfoId
			
			--exec [RiskManagement].[ProcOddResultDelete] @MatchId
		end
	else
		begin
			exec [Log].ProcConcatOldValues  'ScoreInfo','[Archive]','ScoreInfoId',@ScoreInfoId,@OldValues output
	
			exec [Log].[ProcTransactionLogUID] 7,@ActivityCode,@Username,@ScoreInfoId,'Archive.ScoreInfo'
			,null,@OldValues
			delete from Archive.ScoreInfo where ScoreInfoId=@ScoreInfoId
			
			--exec [RiskManagement].[ProcOddResultDelete] @MatchId
		end
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId

	end



	select @resultcode as resultcode,@resultmessage as resultmessage




END


GO
