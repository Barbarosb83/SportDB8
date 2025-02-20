USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcSlipControl]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Retail].[ProcSlipControl]
@SlipId bigint,
@BranchId int


AS




BEGIN
 
 declare @results int=0


if exists (select Customer.Slip.SlipId from Customer.Slip with (nolock) INNER JOIN Customer.Customer with (nolock)  ON Customer.Slip.CustomerId=Customer.Customer.CustomerId where Customer.Slip.SlipId=@SlipId and Customer.Customer.BranchId in (select BranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId or ParentBranchId=@BranchId or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)   where (BranchId=@BranchId or ParentBranchId=@BranchId) ))) )
		set @results=1

else if exists (Select Customer.SlipSystem.SystemSlipId From Customer.SlipSystem with (nolock)  Inner Join Customer.Customer with (nolock)  ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId where  Customer.SlipSystem.SystemSlipId = (select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock)  where SlipId=@SlipId) and Customer.Customer.BranchId in (select BranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId or ParentBranchId=@BranchId or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)   where (BranchId=@BranchId or ParentBranchId=@BranchId) ))) )
			set @results=1
else if exists (select Archive.Slip.SlipId from Archive.Slip with (nolock)  INNER JOIN Customer.Customer with (nolock)  ON Archive.Slip.CustomerId=Customer.Customer.CustomerId where Archive.Slip.SlipId=@SlipId and Customer.Customer.BranchId in (select BranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId or ParentBranchId=@BranchId or ParentBranchId in (select BranchId from Parameter.Branch  with (nolock)  where (BranchId=@BranchId or ParentBranchId=@BranchId) ))) )
		set @results=1



		select @results as results

END




GO
