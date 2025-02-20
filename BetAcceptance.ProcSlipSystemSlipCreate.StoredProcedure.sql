USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[ProcSlipSystemSlipCreate]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [BetAcceptance].[ProcSlipSystemSlipCreate] 
@SystemSlipId bigint,
@SlipId bigint


AS



update Customer.SlipSystem set   NewSlipTypeId= (Select SlipTypeId from Customer.slip with (nolock) where Customer.Slip.SlipId=@SlipId ) 
where SystemSlipId=@SystemSlipId


declare @SlipSystemSlip bigint=0


INSERT INTO [Customer].[SlipSystemSlip]
           ([SystemSlipId]
           ,[SlipId])
     VALUES
           (@SystemSlipId
		   ,@SlipId)


					set @SlipSystemSlip=SCOPE_IDENTITY()

		

return @SlipSystemSlip


GO
