USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Stadium].[ProcStadiumCustomerDelete]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Stadium].[ProcStadiumCustomerDelete] 
@StadiumId bigint,
@CustomerId bigint
AS

BEGIN
SET NOCOUNT ON;


delete from Stadium.SlipOdd where SlipId in (Select SlipId from Stadium.Slip where CustomerId=@CustomerId and MTSTicketId=@StadiumId)

delete from Stadium.Slip where CustomerId=@CustomerId and MTSTicketId=@StadiumId

delete from Stadium.Customers where CustomerId=@CustomerId and StadiumId=@StadiumId

update Stadium.Stadium set ActivePlayerCount=ISNULL((select Count(*) from Stadium.Customers where StadiumId=@StadiumId),0) where StadiumId=@StadiumId

select  1 as resultcode


END


GO
