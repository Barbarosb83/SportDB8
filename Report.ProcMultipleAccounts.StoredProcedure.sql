USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Report].[ProcMultipleAccounts]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Report].[ProcMultipleAccounts] 
@UserId int
AS

BEGIN
SET NOCOUNT ON;

 
declare @TempCustomer table(CustomerId bigint,Username nvarchar(150),Email nvarchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS,Surname nvarchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS,PhoneNumber nvarchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS,PassportNumber nvarchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS,IdNumber nvarchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS,BirthDay Datetime,Country int,CustomerFullName nvarchar(250) COLLATE SQL_Latin1_General_CP1_CI_AS,CustomerAddres nvarchar(250) COLLATE SQL_Latin1_General_CP1_CI_AS)

declare @TempMultiple table (Id nvarchar(50),CustomerId bigint,Username nvarchar(150),Email nvarchar(150),Comments nvarchar(150))

insert @TempCustomer 
select CustomerId,Username,SUBSTRING(email, CHARINDEX('@',Email)+1,LEN(email)),CustomerSurname,PhoneNumber,PassportNumber,IdNumber,Birthday,CountryId,CustomerName+CustomerSurname
,SUBSTRING(Address,0, CHARINDEX(' ',Address))
from Customer.Customer where CreateDate>=DATEADD(DAY,-2,GETDATE())






 insert @TempMultiple
select '1-'+cast(CustomerId as nvarchar(30)),CustomerId,Username,Email,'Surname and BirthDay Alert' from @TempCustomer as TC  where 
  TC.Surname in (Select CustomerSurname  from  Customer.Customer where CustomerSurname is not null and CustomerSurname<>'' and CustomerId not in (select CustomerId from @TempCustomer)) 
  and TC.BirthDay in (Select Customer.Customer.Birthday  from  Customer.Customer where Customer.Customer.Birthday  is not null  and CustomerId not in (select CustomerId from @TempCustomer where 
  TC.Surname in (Select CustomerSurname  from  Customer.Customer where CustomerSurname is not null and CustomerSurname<>'' and CustomerId not in (select CustomerId from @TempCustomer)) )) 


insert @TempMultiple
select '2-'+cast(CustomerId as nvarchar(30)),CustomerId,Username,Email,'PhoneNumber Alert' from @TempCustomer as TC  where 
  TC.PhoneNumber   in (Select PhoneNumber  from Customer.Customer where PhoneNumber is not null and PhoneNumber<>'' and CustomerId not in (select CustomerId from @TempCustomer)) 

  insert @TempMultiple
select '3-'+cast(CustomerId as nvarchar(30)),CustomerId,Username,Email,'PassportNumber Alert' from @TempCustomer as TC  where 
  PassportNumber COLLATE SQL_Latin1_General_CP1_CI_AS in (Select PassportNumber COLLATE SQL_Latin1_General_CP1_CI_AS from Customer.Customer where PassportNumber is not null and PassportNumber<>'' and CustomerId not in (select CustomerId from @TempCustomer)) 

  insert @TempMultiple
select '4-'+cast(CustomerId as nvarchar(30)),CustomerId,Username,Email,'IdNumber Alert' from @TempCustomer as TC  where 
 IdNumber COLLATE SQL_Latin1_General_CP1_CI_AS in (Select IdNumber COLLATE SQL_Latin1_General_CP1_CI_AS from Customer.Customer where IdNumber is not null and IdNumber<>'' and CustomerId not in (select CustomerId from @TempCustomer)) 


  insert @TempMultiple
select '5-'+cast(CustomerId as nvarchar(30)),CustomerId,Username,Email,'Email Domain,Surname and Country Alert' from @TempCustomer as TC  where 
 TC.Surname in (Select CustomerSurname  from  Customer.Customer where CustomerSurname is not null and CustomerSurname<>'' and CustomerId not in (select CustomerId from @TempCustomer)) 
 and TC.Country in (Select CountryId  from  Customer.Customer where CountryId is not null  and CustomerId not in (select CustomerId from @TempCustomer where 
 TC.Surname in (Select CustomerSurname  from  Customer.Customer where CustomerSurname is not null and CustomerSurname<>'' and CustomerId not in (select CustomerId from @TempCustomer)))) 
 and Email in (Select SUBSTRING(Email, CHARINDEX('@',Email)+1,LEN(Email))  from  Customer.Customer where Email is not null    and CustomerId not in (select CustomerId from @TempCustomer where 
 TC.Surname in (Select CustomerSurname  from  Customer.Customer where CustomerSurname is not null and CustomerSurname<>'' and CustomerId not in (select CustomerId from @TempCustomer where  TC.Country in (Select CountryId  from  Customer.Customer where CountryId is not null  and CustomerId not in (select CustomerId from @TempCustomer)))))) 

  insert @TempMultiple
select '6-'+cast(CustomerId as nvarchar(30)),CustomerId,Username,Email,'Address and Name Surname Alert' from @TempCustomer as TC  where 
  TC.CustomerFullName in (Select Customer.Customer.CustomerName+Customer.Customer.CustomerSurname  from  Customer.Customer where Customer.Customer.CustomerSurname is not null and CustomerSurname<>'' and Customer.Customer.CustomerName is not null and CustomerName<>'' and CustomerId not in (select CustomerId from @TempCustomer)) 
  and TC.CustomerAddres in (Select SUBSTRING(Address,0, CHARINDEX(' ',Address))  from  Customer.Customer where Customer.Customer.Address  is not null  and CustomerId not in (select CustomerId from @TempCustomer where
   TC.CustomerFullName in (Select Customer.Customer.CustomerName+Customer.Customer.CustomerSurname  from  Customer.Customer where Customer.Customer.CustomerSurname is not null 
   and CustomerSurname<>'' and Customer.Customer.CustomerName is not null and CustomerName<>'' and CustomerId not in (select CustomerId from @TempCustomer))))

 select * from @TempMultiple

END



GO
