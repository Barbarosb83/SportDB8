USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Dashboard].[ProcTop10FraudIp]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Dashboard].[ProcTop10FraudIp] 
@Username nvarchar(50)
AS

BEGIN
SET NOCOUNT ON;


declare @UserCurrencyId int
declare @UserBranchId int
select @UserCurrencyId=Users.Users.CurrencyId,
@UserBranchId=Users.Users.UnitCode
from Users.Users 
 where Users.Users.UserName=@Username


declare @temptable table (IpAdress nvarchar(50),CustomerCount int)
declare @temptable2 table (IpAdress nvarchar(50),CustomerCount int,LastLoginDate datetime)


--if(@UserBranchId=1)
--	begin
		insert @temptable
		select top 10 Customer.Ip.IpAddress,1 from Customer.Ip with (nolock)
		--where LoginDate>DATEADD(DAY,-7,GETDATE())
		--GROUP BY Customer.Ip.IpAddress
--		--HAVING COUNT(Customer.Ip.IpAddress)>1


--		insert @temptable2
--		select IpAdress,CustomerCount,(select top 1 Customer.Ip.LoginDate from Customer.Ip with (nolock) where Customer.Ip.IpAddress=IpAdress order by  Customer.Ip.LoginDate desc)
--		from @temptable
--		where CustomerCount>1


--	end
--else
--	begin
--		insert @temptable
--		select Customer.Ip.IpAddress,COUNT(DISTINCT Customer.Ip.CustomerId) 
--		from Customer.Ip  with (nolock) INNER JOIN Customer.Customer with (nolock) on Customer.Ip.CustomerId=Customer.Customer.CustomerId
--		where Customer.Customer.BranchId=@UserBranchId and LoginDate>DATEADD(DAY,-7,GETDATE())
--		GROUP BY Customer.Ip.IpAddress
--		HAVING COUNT(Customer.Ip.IpAddress)>1


--		insert @temptable2
--		select IpAdress,CustomerCount,(select top 1 Customer.Ip.LoginDate from Customer.Ip with (nolock) where Customer.Ip.IpAddress=IpAdress order by  Customer.Ip.LoginDate desc)
--		from @temptable
--		where CustomerCount>1

--end

		SELECT top 10 IpAdress,CustomerCount,LastLoginDate
		from @temptable2
		WHERE     CustomerCount>1 and (IpAdress<>'::1' or IpAdress<>' ' or IpAdress is not null)
		ORDER BY CustomerCount desc

END



GO
