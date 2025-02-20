USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcOpenPayOuts]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcOpenPayOuts] 
@UserId int,
@CurrencyId int,
@BranchId int,
@LangId int
AS
BEGIN
SET NOCOUNT ON;
 
 declare @table table (Total money)

 insert @table
select ISNULL(SUM(ISNULL(Amount,0)*TotalOddValue),0) As Total  from Customer.Slip with (nolock) INNER JOIN Customer.Customer with (nolock)
ON Customer.Customer.CustomerId=Customer.Slip.CustomerId
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6) --and Customer.Slip.SourceId in (3,4)
 and (BranchId=@BranchId and IsBranchCustomer=1) and Customer.Slip.SlipTypeId<3

-- insert @table
--select cast(ISNULL((Select SUM(Customer.Slip.TotalOddValue * Customer.Slip.Amount)
-- from Customer.Slip with (nolock) where Customer.Slip.SlipStateId in (3,6) and Customer.Slip.SlipTypeId=3
--  and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) as money)  from Customer.SlipSystem with (nolock) INNER JOIN Customer.Customer with (nolock)
--ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId
--where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6) 
-- and Customer.SlipSystem.SourceId in (3,4) and BranchId=@BranchId and IsBranchCustomer=1 

  insert @table
select Customer.SlipSystem.MaxGain 
   from Customer.SlipSystem with (nolock) INNER JOIN Customer.Customer  with (nolock)
ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId
INNER JOIN Customer.SlipSystemSlip with (nolock) On Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId 
INNER JOIN Customer.Slip with (nolock) ON Customer.Slip.SlipId=Customer.SlipSystemSlip.SlipId
where Customer.slip.SlipTypeId>3 and (Customer.Slip.IsPayOut=0 or Customer.Slip.IsPayOut is null) and Customer.Slip.SlipStateId in (2,3,5,6) 
-- and Customer.SlipSystem.SourceId in (3,4)
  and BranchId=@BranchId and IsBranchCustomer=1 


 insert @table
select ISNULL(SUM(ISNULL(Amount,0)*TotalOddValue),0) As Total  from Archive.Slip with (nolock) INNER JOIN Customer.Customer with (nolock)
ON Customer.Customer.CustomerId=Archive.Slip.CustomerId
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6) 
--and Archive.Slip.SourceId in (3,4) 
and BranchId=@BranchId and IsBranchCustomer=1 and Archive.Slip.SlipTypeId<3

-- insert @table
--select cast(ISNULL((Select SUM(Archive.Slip.TotalOddValue * Archive.Slip.Amount) 
--from Archive.Slip with (nolock) where Archive.Slip.SlipStateId in (3,6) and Archive.Slip.SlipTypeId=3
--and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) as money)  from Customer.SlipSystem with (nolock) INNER JOIN Customer.Customer with (nolock)
--ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId
--where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)
-- and Customer.SlipSystem.SourceId in (3,4) 
-- and BranchId=@BranchId and IsBranchCustomer=1 

  insert @table
select Customer.SlipSystem.MaxGain
   from Customer.SlipSystem with (nolock) INNER JOIN Customer.Customer  with (nolock)
ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId
INNER JOIN Customer.SlipSystemSlip with (nolock) On Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId 
INNER JOIN Archive.Slip with (nolock) ON Archive.Slip.SlipId=Customer.SlipSystemSlip.SlipId
where Archive.slip.SlipTypeId>3 and (Archive.Slip.IsPayOut=0 or Archive.Slip.IsPayOut is null) and Archive.Slip.SlipStateId in (2,3,5,6) 
 --and Customer.SlipSystem.SourceId in (3,4) 
 and BranchId=@BranchId and IsBranchCustomer=1 


-------------------------- Terminal Ödenmemiş Kuponlar -----------------------------------------------

 insert @table
select ISNULL(SUM(ISNULL(Amount,0)*TotalOddValue),0) As Total  from Customer.Slip with (nolock) INNER JOIN Customer.Customer with (nolock)
ON Customer.Customer.CustomerId=Customer.Slip.CustomerId
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6) and Customer.Slip.SourceId in (5)
 and (BranchId in (select BranchId from Parameter.Branch with (nolock) where ParentBranchId= @BranchId) and IsBranchCustomer=1) and Customer.Slip.SlipTypeId<3

 insert @table
select cast(ISNULL((Select SUM(Customer.Slip.TotalOddValue * Customer.Slip.Amount)
 from Customer.Slip with (nolock) where Customer.Slip.SlipStateId in (3,6) and Customer.Slip.SlipTypeId=3
  and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) as money)  from Customer.SlipSystem with (nolock) INNER JOIN Customer.Customer with (nolock)
ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6) 
 and Customer.SlipSystem.SourceId in (5) and (BranchId in (select BranchId from Parameter.Branch where ParentBranchId= @BranchId)) and IsBranchCustomer=1 

  insert @table
 select Customer.SlipSystem.MaxGain 
   from Customer.SlipSystem with (nolock) INNER JOIN Customer.Customer  with (nolock)
ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId
INNER JOIN Customer.SlipSystemSlip with (nolock) On Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId 
INNER JOIN Customer.Slip with (nolock) ON Customer.Slip.SlipId=Customer.SlipSystemSlip.SlipId
where Customer.slip.SlipTypeId>3 and (Customer.slip.IsPayOut=0 or Customer.slip.IsPayOut is null) and Customer.slip.SlipStateId in (2,3,5,6) 
 and Customer.SlipSystem.SourceId in (5) and (BranchId in (select BranchId from Parameter.Branch with (nolock) where ParentBranchId= @BranchId)) and IsBranchCustomer=1 


 insert @table
select ISNULL(SUM(ISNULL(Amount,0)*TotalOddValue),0) As Total  from Archive.Slip with (nolock) INNER JOIN Customer.Customer with (nolock)
ON Customer.Customer.CustomerId=Archive.Slip.CustomerId
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6) and Archive.Slip.SourceId in (5) 
and (BranchId in (select BranchId from Parameter.Branch with (nolock) where ParentBranchId= @BranchId)) and IsBranchCustomer=1 and Archive.Slip.SlipTypeId<3

 insert @table
select cast(ISNULL((Select SUM(Archive.Slip.TotalOddValue * Archive.Slip.Amount) 
from Archive.Slip with (nolock) where Archive.Slip.SlipStateId in (3,6) and Archive.Slip.SlipTypeId=3
and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) as money)  from Customer.SlipSystem with (nolock) INNER JOIN Customer.Customer with (nolock)
ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6) and Customer.SlipSystem.SourceId in (5) and (BranchId in (select BranchId from Parameter.Branch with (nolock) where ParentBranchId= @BranchId)) and IsBranchCustomer=1 


  insert @table
 select Customer.SlipSystem.MaxGain 
   from Customer.SlipSystem with (nolock) INNER JOIN Customer.Customer with (nolock)
ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId
INNER JOIN Customer.SlipSystemSlip with (nolock) On Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId 
INNER JOIN Archive.Slip with (nolock) ON Archive.Slip.SlipId=Customer.SlipSystemSlip.SlipId
where Archive.slip.SlipTypeId>3 and (Archive.slip.IsPayOut=0 or Archive.slip.IsPayOut is null) and Archive.slip.SlipStateId in (2,3,5,6) 
 and Customer.SlipSystem.SourceId in (5) and (BranchId in (select BranchId from Parameter.Branch with (nolock) where ParentBranchId= @BranchId)) and IsBranchCustomer=1 

-------------------------------------------------------------------------------------------------------



select SUM(Total) as Total from @table

 
END




GO
