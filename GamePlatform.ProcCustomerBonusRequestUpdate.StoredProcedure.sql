USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerBonusRequestUpdate]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerBonusRequestUpdate] 
@CustomerId bigint,
@IsEnable  bit
AS

BEGIN
SET NOCOUNT ON;

if exists (select Customer.BonusRequest.CustomerId from Customer.BonusRequest where CustomerId=@CustomerId)
update Customer.BonusRequest set IsEnable=@IsEnable,CreateDate=GETDATE() where CustomerId=@CustomerId
else
	insert Customer.BonusRequest (CustomerId,IsEnable,CreateDate,BonusStartDate) values(@CustomerId,@IsEnable,GETDATE(),GETDATE())


select 1 as result

END



GO
