USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[ProcSlipSystemSlipCreateTemp]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [BetAcceptance].[ProcSlipSystemSlipCreateTemp] 
@SystemSlipId bigint,
@SlipId bigint


AS

update Customer.SlipSystemTemp set NewSlipTypeId= (Select top 1 SlipTypeId from Customer.slip with (nolock) where Customer.Slip.SlipId=@SlipId ) where SystemSlipId=@SystemSlipId

declare @SlipSystemSlip bigint=0


INSERT INTO [Customer].[SlipSystemSlipTemp]
           ([SystemSlipId]
           ,[SlipId])
     VALUES
           (@SystemSlipId
		   ,@SlipId)


					set @SlipSystemSlip=SCOPE_IDENTITY()

		

return @SlipSystemSlip


GO
