USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCustomerCardBalance]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcCustomerCardBalance] 
@UserId int,
@CurrencyId int,
@BranchId int,
@LangId int
AS
BEGIN
SET NOCOUNT ON;
 


select ISNULL(SUM(ISNULL(Balance,0)),0) As Total  from Customer.Customer with (nolock)
where BranchId=@BranchId  and Customer.Customer.IsBranchCustomer<>1 



 
END




GO
