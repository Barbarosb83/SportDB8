USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Dashboard].[ProcPendingTaskCreditCardRequest]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Dashboard].[ProcPendingTaskCreditCardRequest] 

AS

BEGIN
SET NOCOUNT ON;



select ISNULL(COUNT( Customer.CreditCard.CreditCardId),0) 
FROM    Customer.CreditCard with (nolock)
WHERE  Customer.CreditCard.IsApproved is null


END




GO
