USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Archive].[ProcSlip]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Archive].[ProcSlip]


AS

BEGIN TRAN 


declare @TempTable table (SlipID bigint)

declare @TempSlip table (SlipId bigint)

insert @TempTable
SELECT  SlipId From Customer.Slip with (nolock) where SlipStateId not in (1) and cast(CreateDate as date)<=cast(DATEADD(DAY,-2,GETDATE()) as date) and SlipTypeId<3

insert @TempTable
SELECT  SlipId From Customer.Slip with (nolock) where SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId in (select SystemSlipId from Customer.SlipSystem with (nolock) where SlipStateId<>1)) and cast(CreateDate as date)<=cast(DATEADD(DAY,-2,GETDATE()) as date) and SlipTypeId>=3

insert @TempSlip
SELECT  SlipId From Customer.SlipTemp with (nolock) where   cast(CreateDate as date)<=cast(DATEADD(DAY,-1,GETDATE()) as date) and SlipTypeId<3

insert @TempSlip
SELECT  SlipId From Customer.SlipTemp with (nolock) where SlipId in (select SlipId from Customer.SlipSystemSlipTemp with (nolock) where Customer.SlipSystemSlipTemp.SystemSlipId in (select SystemSlipId from Customer.SlipSystemTemp with (nolock))) and cast(CreateDate as date)<=cast(DATEADD(DAY,-1,GETDATE()) as date) and SlipTypeId>=3


insert Archive.Slip
SELECT    Customer.Slip.*
FROM         Customer.Slip with (nolock)
where Customer.Slip.SlipId in (select SlipID from @TempTable)

insert Archive.SlipOdd
SELECT     Customer.SlipOdd.*
FROM         Customer.SlipOdd with (nolock)
where Customer.SlipOdd.SlipId in (select SlipID from @TempTable)

----------------------------------- DELETE ------------------------------

delete  from     Customer.SlipOdd where Customer.SlipOdd.SlipId in (select SlipID from @TempTable)

delete  from     Customer.Slip where Customer.Slip.SlipId in (select SlipID from @TempTable)


delete  from     Customer.SlipOddTemp where Customer.SlipOddTemp.SlipId in (select SlipID from @TempSlip)

delete  from     Customer.SlipTemp where Customer.SlipTemp.SlipId in (select SlipID from @TempSlip)



delete from Customer.SlipSystemSlipTemp where SystemSlipId in (Select SystemSlipId from Customer.SlipSystemTemp where cast(CreateDate as date)<=cast(DATEADD(DAY,-1,GETDATE()) as date))

delete from Customer.SlipSystemTemp where cast(CreateDate as date)<=cast(DATEADD(DAY,-1,GETDATE()) as date)

declare @tempsystem table (SystemSlipId bigint)

insert @tempsystem
SELECT        SystemSlipId 
FROM            Customer.SlipSystem  with (nolock) 
where cast(CreateDate as Date)<cast(DATEADD(MONTH,-3,GETDATE()) as date) 

if(select Count(*) from @tempsystem)>0
begin
insert into Archive.SlipSystemSlip
select * from Customer.SlipSystemSlip with (nolock) where SystemSlipId in (select SystemSlipId from @tempsystem)


insert into Archive.SlipSystem
select *  FROM            Customer.SlipSystem with (nolock) where SystemSlipId in (select SystemSlipId from @tempsystem)




--------------------------------------------------------------------DELETE-------------------------------
delete from  Customer.SlipSystemSlip where SystemSlipId in (select SystemSlipId from @tempsystem)
delete from  Customer.SlipSystem where SystemSlipId in (select SystemSlipId from @tempsystem)
end


COMMIT TRAN




GO
