USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Stadium].[ProcStadiumCustomerList]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Stadium].[ProcStadiumCustomerList] 
@StadiumId bigint
AS

BEGIN
SET NOCOUNT ON;

 
 select Customer.Customer.Username,Customer.CustomerId,Stadium.slip.SlipId,Stadium.slip.TotalOddValue,Stadium.Slip.SlipStateId,Stadium.Customers.IsWon
 from Stadium.Customers with (nolock)
 INNER join Customer.Customer with (nolock)
 On Stadium.Customers.CustomerId=Customer.Customer.CustomerId 
 INNER JOIN Stadium.Slip with (nolock)
 On Stadium.Customers.SlipId=Stadium.Slip.SlipId 
 where Stadium.Customers.StadiumId=@StadiumId
 Order By Stadium.slip.TotalOddValue desc




END


GO
