USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Stadium].[ProcCustomerStadiumList]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Stadium].[ProcCustomerStadiumList] 
@CustomerId bigint,
@StateId int,
@LangId int
AS

BEGIN
SET NOCOUNT ON;

 if(@StateId=0) --Hepsi
 begin
 select Stadium.Customers.StadiumId,Customer.Customer.Username,Customer.CustomerId,Stadium.slip.SlipId,Stadium.slip.TotalOddValue,Stadium.Slip.SlipStateId,
 [EntranceFee],[MaxPlayer],ActivePlayerCount,[EndDate],Parameter.Currency.Sybol,Stadium.Stadium.[IsActive],Stadium.Customers.IsWon,Stadium.Customers.StateId
 from Stadium.Customers with (nolock)
 INNER join Customer.Customer with (nolock)
 On Stadium.Customers.CustomerId=Customer.Customer.CustomerId 
 INNER JOIN Stadium.Slip with (nolock)
 On Stadium.Customers.SlipId=Stadium.Slip.SlipId INNER JOIN 
 Stadium.Stadium ON Stadium.Stadium.StadiumId=Stadium.Customers.StadiumId  INNER JOIN Parameter.Currency  with (nolock)
  On [Stadium].[Stadium].CurrencyId=Parameter.Currency.CurrencyId
 where Stadium.Customers.CustomerId=@CustomerId
 Order By Stadium.Slip.CreateDate
 end
 else  if(@StateId=1) -- Open
 begin
 select Stadium.Customers.StadiumId,Customer.Customer.Username,Customer.CustomerId,Stadium.slip.SlipId,Stadium.slip.TotalOddValue,Stadium.Slip.SlipStateId,
 [EntranceFee],[MaxPlayer],ActivePlayerCount,[EndDate],Parameter.Currency.Sybol,Stadium.Stadium.[IsActive],Stadium.Customers.IsWon,Stadium.Customers.StateId
 from Stadium.Customers with (nolock)
 INNER join Customer.Customer with (nolock)
 On Stadium.Customers.CustomerId=Customer.Customer.CustomerId 
 INNER JOIN Stadium.Slip with (nolock)
 On Stadium.Customers.SlipId=Stadium.Slip.SlipId INNER JOIN 
 Stadium.Stadium ON Stadium.Stadium.StadiumId=Stadium.Customers.StadiumId  INNER JOIN Parameter.Currency  with (nolock)
  On [Stadium].[Stadium].CurrencyId=Parameter.Currency.CurrencyId
 where Stadium.Customers.CustomerId=@CustomerId and Stadium.Slip.SlipStateId=1
  Order By Stadium.Slip.CreateDate
 end
  else  if(@StateId=4) -- Lost
 begin
 select Stadium.Customers.StadiumId,Customer.Customer.Username,Customer.CustomerId,Stadium.slip.SlipId,Stadium.slip.TotalOddValue,Stadium.Slip.SlipStateId,
 [EntranceFee],[MaxPlayer],ActivePlayerCount,[EndDate],Parameter.Currency.Sybol,Stadium.Stadium.[IsActive],Stadium.Customers.IsWon,Stadium.Customers.StateId
 from Stadium.Customers with (nolock)
 INNER join Customer.Customer with (nolock)
 On Stadium.Customers.CustomerId=Customer.Customer.CustomerId 
 INNER JOIN Stadium.Slip with (nolock)
 On Stadium.Customers.SlipId=Stadium.Slip.SlipId INNER JOIN 
 Stadium.Stadium ON Stadium.Stadium.StadiumId=Stadium.Customers.StadiumId  INNER JOIN Parameter.Currency  with (nolock)
  On [Stadium].[Stadium].CurrencyId=Parameter.Currency.CurrencyId
 where Stadium.Customers.CustomerId=@CustomerId and Stadium.Slip.SlipStateId=4
  Order By Stadium.Slip.CreateDate
 end
   else  if(@StateId=3) -- won
 begin
 select Stadium.Customers.StadiumId,Customer.Customer.Username,Customer.CustomerId,Stadium.slip.SlipId,Stadium.slip.TotalOddValue,Stadium.Slip.SlipStateId,
 [EntranceFee],[MaxPlayer],ActivePlayerCount,[EndDate],Parameter.Currency.Sybol,Stadium.Stadium.[IsActive],Stadium.Customers.IsWon,Stadium.Customers.StateId
 from Stadium.Customers with (nolock)
 INNER join Customer.Customer with (nolock)
 On Stadium.Customers.CustomerId=Customer.Customer.CustomerId 
 INNER JOIN Stadium.Slip with (nolock)
 On Stadium.Customers.SlipId=Stadium.Slip.SlipId INNER JOIN 
 Stadium.Stadium ON Stadium.Stadium.StadiumId=Stadium.Customers.StadiumId  INNER JOIN Parameter.Currency  with (nolock)
  On [Stadium].[Stadium].CurrencyId=Parameter.Currency.CurrencyId
 where Stadium.Customers.CustomerId=@CustomerId and Stadium.Slip.SlipStateId=3
  Order By Stadium.Slip.CreateDate
 end
    else  if(@StateId=2) -- cancel
 begin
 select Stadium.Customers.StadiumId,Customer.Customer.Username,Customer.CustomerId,Stadium.slip.SlipId,Stadium.slip.TotalOddValue,Stadium.Slip.SlipStateId,
 [EntranceFee],[MaxPlayer],ActivePlayerCount,[EndDate],Parameter.Currency.Sybol,Stadium.Stadium.[IsActive],Stadium.Customers.IsWon,Stadium.Customers.StateId
 from Stadium.Customers with (nolock)
 INNER join Customer.Customer with (nolock)
 On Stadium.Customers.CustomerId=Customer.Customer.CustomerId 
 INNER JOIN Stadium.Slip with (nolock)
 On Stadium.Customers.SlipId=Stadium.Slip.SlipId INNER JOIN 
 Stadium.Stadium ON Stadium.Stadium.StadiumId=Stadium.Customers.StadiumId  INNER JOIN Parameter.Currency  with (nolock)
  On [Stadium].[Stadium].CurrencyId=Parameter.Currency.CurrencyId
 where Stadium.Customers.CustomerId=@CustomerId and Stadium.Slip.SlipStateId=2
  Order By Stadium.Slip.CreateDate
 end



END


GO
