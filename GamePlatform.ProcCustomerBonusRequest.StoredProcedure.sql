USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerBonusRequest]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [GamePlatform].[ProcCustomerBonusRequest] 
@CustomerId bigint
AS

BEGIN
SET NOCOUNT ON;

SELECT IsEnable,CreateDate as CreateDate  from Customer.BonusRequest where Customer.BonusRequest.CustomerId=@CustomerId




END




GO
