USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerPEPCustomer]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcCustomerPEPCustomer] 
@CustomerId bigint
AS

BEGIN
SET NOCOUNT ON;

select Customer.PEPControl.CustomerId
,Customer.Customer.CustomerName
,Customer.Customer.CustomerSurname
,Customer.Customer.Username
,Customer.PEPControl.CreateDate
,Customer.PepControl.ExpriedDate
,Customer.PEPControl.Description
,Customer.PEPControl.IsPep
,Customer.PepControl.IsSanction
,Customer.PepControl.IsDoc
,Customer.PepControl.UpdateDate
,(Select Username from Users.Users where UserId= Customer.PepControl.UpdateUserId) as UpdateUser
from Customer.PEPControl INNER JOIN Customer.Customer On Customer.Customer.CustomerId=Customer.PEPControl.CustomerId
where Customer.PEPControl.CustomerId=@CustomerId

END



GO
