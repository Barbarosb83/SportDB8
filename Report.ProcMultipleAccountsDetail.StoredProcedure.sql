USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Report].[ProcMultipleAccountsDetail]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Report].[ProcMultipleAccountsDetail] 
@CustomerId bigint,
@MultipleType int --1 Surname,2 Phone Number,3 PassportNumber,4 Id Number
AS

BEGIN
SET NOCOUNT ON;

if(@MultipleType=1)
begin
	

	select * from Customer.Customer with (nolock) where CustomerSurname in (select CustomerSurname from Customer.Customer with (nolock) where CustomerId=@CustomerId)
end
else if(@MultipleType=2)
begin
	

	select * from Customer.Customer with (nolock) where PhoneNumber in (select PhoneNumber from Customer.Customer with (nolock) where CustomerId=@CustomerId)
end
else if(@MultipleType=3)
begin
	

	select * from Customer.Customer with (nolock) where PassportNumber in (select PassportNumber from Customer.Customer with (nolock) where CustomerId=@CustomerId)
end
else if(@MultipleType=4)
begin
	

	select * from Customer.Customer with (nolock) where IdNumber in (select IdNumber from Customer.Customer with (nolock) where CustomerId=@CustomerId)
end

END


GO
