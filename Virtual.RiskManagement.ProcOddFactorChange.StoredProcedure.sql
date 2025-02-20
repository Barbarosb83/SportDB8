USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Virtual].[RiskManagement.ProcOddFactorChange]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Virtual].[RiskManagement.ProcOddFactorChange]
@OddId bigint,
@UpDown int

AS

BEGIN

		declare @OddFactor float
		declare @FedOdd float
		declare @NewOddValue float
		
		declare @VirtualEventId bigint
		declare @OutCome nvarchar(50)
		declare @SpecialBetValue nvarchar(50)
		declare @IsActive bit
		declare @Change int
		declare @OddTypeId int
		
		select @OddFactor=Virtual.EventOdd.OddFactor,
				@FedOdd=Virtual.EventOdd.Suggestion,
				@VirtualEventId=Virtual.EventOdd.MatchId,
				@OutCome=Virtual.EventOdd.OutCome,
				@SpecialBetValue=Virtual.EventOdd.SpecialBetValue,
				@IsActive=Virtual.EventOdd.IsActive,
				@OddTypeId=Virtual.EventOdd.OddsTypeId from Virtual.EventOdd with (nolock) 
			where Virtual.EventOdd.OddId=@OddId
		
		if (@UpDown=1)
			set @OddFactor=@OddFactor+(0.01)
		else
			set @OddFactor=@OddFactor-(0.01)
		
		set @NewOddValue=@OddFactor*@FedOdd

		UPDATE [Virtual].[EventOdd]
		   SET 
			   [OddFactor] = @OddFactor
			  ,[OddValue] = @NewOddValue
		 WHERE Virtual.EventOdd.OddId=@OddId

		declare @ChangeValue int=0
		
		if (@UpDown=1)
			set @ChangeValue=1
		else
			set @ChangeValue=2
		
		exec [Betradar].[Virtual.ProcEventTopOdd] @VirtualEventId, @OutCome, @SpecialBetValue,@NewOddValue,@OddId,@IsActive,@ChangeValue,@OddTypeId

END


GO
