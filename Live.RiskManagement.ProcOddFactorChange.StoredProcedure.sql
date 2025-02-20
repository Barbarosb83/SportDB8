USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[RiskManagement.ProcOddFactorChange]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Live].[RiskManagement.ProcOddFactorChange]
@OddId bigint,
@UpDown int

AS

BEGIN

		declare @OddFactor float
		declare @FedOdd float
		declare @NewOddValue float
		
		declare @LiveEventId bigint
		declare @OutCome nvarchar(50)
		declare @SpecialBetValue nvarchar(50)
		declare @IsActive bit
		declare @Change int
		declare @OddTypeId int
		
		select @OddFactor=Live.EventOdd.OddFactor,
				@FedOdd=Live.EventOdd.Suggestion,
				@LiveEventId=Live.EventOdd.MatchId,
				@OutCome=Live.EventOdd.OutCome,
				@SpecialBetValue=Live.EventOdd.SpecialBetValue,
				@IsActive=Live.EventOdd.IsActive,
				@OddTypeId=Live.EventOdd.OddsTypeId from Live.EventOdd with (nolock) 
			where Live.EventOdd.OddId=@OddId
		
		if (@UpDown=1)
			set @OddFactor=@OddFactor+(0.01)
		else
			set @OddFactor=@OddFactor-(0.01)
		
		set @NewOddValue=@OddFactor*@FedOdd

		UPDATE [Live].[EventOdd]
		   SET 
			   [OddFactor] = @OddFactor
			  ,[OddValue] = @NewOddValue
		 WHERE Live.EventOdd.OddId=@OddId

		declare @ChangeValue int=0
		
		if (@UpDown=1)
			set @ChangeValue=1
		else
			set @ChangeValue=2
		
		exec [Betradar].[Live.ProcEventTopOdd] @LiveEventId, @OutCome, @SpecialBetValue,@NewOddValue,@OddId,@IsActive,@ChangeValue,@OddTypeId

END


GO
