USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Dashboard].[ProcPendingTaskSlipRequest]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Dashboard].[ProcPendingTaskSlipRequest] 

AS

BEGIN
SET NOCOUNT ON;



select COUNT(DISTINCT Customer.Slip.SlipId) 
FROM         Customer.Customer with (nolock) INNER JOIN
                      Customer.Slip with (nolock) ON Customer.Customer.CustomerId = Customer.Slip.CustomerId 
WHERE  Customer.Slip.SlipStatu=2


END


GO
