USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcSlipDetailOneTerminal]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Retail].[ProcSlipDetailOneTerminal]
@SlipId bigint,
@Username nvarchar(100),
@LangId int

AS

BEGIN
SET NOCOUNT ON;
declare @UserCurrencyId int
declare @BranchId int
declare @SlipBranchId int 
declare @CustomerUsername nvarchar(100)
declare @Control int=0
declare @CustomerBranchId int
select @UserCurrencyId=Users.Users.CurrencyId,@BranchId=UnitCode,@CustomerBranchId=UnitCode from Users.Users with (nolock) where Users.Users.UserName=@Username
declare @TempTable table (SlipId bigint,CustomerId bigint,CustomerName nvarchar(max),Amount money,TotalOddValue float,StateId int,State nvarchar(50),CreateDate datetime,SourceId int,Source nvarchar(50),OddCount int,SlipType nvarchar(50),SlipTypeId int,SlipStateStatuColor nvarchar(50),MaxGain money,CurrencyId int,Currency nvarchar(50),SlipStatu nvarchar(50),IsCancel int,BranchName nvarchar(150),CancelDate datetime,IsPayOut bit,RemainingPayOut money,PaidAmount money,IsBranchCustomer bit,Tax money,Winning Money)


--insert dbo.betslip values (@SlipId,@Username,GETDATE())

if exists (select Customer.Slip.SlipId from Customer.Slip with (nolock) where Customer.Slip.SlipId=@SlipId)
	begin
		if(select IsBranchCustomer from Customer.Customer with (nolock)  where CustomerId = (select Customer.Slip.CustomerId from Customer.Slip with (nolock)  where Customer.Slip.SlipId=@SlipId))=0
			begin
			select @BranchId= BranchId,@SlipBranchId=BranchId,@UserCurrencyId=CurrencyId,@CustomerUsername=Username from Customer.Customer with (nolock) where CustomerId = (select Customer.Slip.CustomerId from Customer.Slip with (nolock)  where Customer.Slip.SlipId=@SlipId)
			if(@CustomerUsername<>@Username)
				set @Control=0
			end
		else
			select @BranchId= BranchId,@UserCurrencyId=CurrencyId,@SlipBranchId=BranchId  from Customer.Customer with (nolock) where CustomerId = (select Customer.Slip.CustomerId from Customer.Slip with (nolock)  where Customer.Slip.SlipId=@SlipId)
if((@SlipBranchId=@CustomerBranchId) or (@SlipBranchId in (select BranchId from Parameter.Branch wih (nolock) where ParentBranchId in (Select ParentBranchId from Parameter.Branch with (nolock) where BranchId=@CustomerBranchId))) or (@SlipBranchId in (  (Select ParentBranchId from Parameter.Branch  with (nolock) where BranchId=@CustomerBranchId))))
	begin
		if exists(select  Customer.Slip.SlipId  from Customer.Slip with (nolock)  where Customer.Slip.SlipId=@SlipId and Customer.Slip.SlipTypeId<3)
		begin
		insert @TempTable
		select  Customer.Slip.SlipId, Customer.Slip.CustomerId, 
							  Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName, 
							 Customer.Slip.Amount  as Amount, Customer.Slip.TotalOddValue, Parameter.SlipState.StateId, [Language].[Parameter.SlipState].SlipState as State
							  ,Customer.Slip.CreateDate as CreateDate, Parameter.Source.SourceId, 
							  Parameter.Source.Source, 1 AS OddCount, [Language].[Parameter.SlipType].SlipType, Customer.Slip.SlipTypeId, 
							  Parameter.SlipState.StatuColor AS SlipStateStatuColor
							  ,  Customer.Slip.TotalOddValue * Customer.Slip.Amount AS MaxGain
							  , Parameter.Currency.CurrencyId, 
							  Parameter.Currency.Currency
							  ,Parameter.SlipStatu.SlipStatu
							  ,case when DATEDIFF(MINUTE,Customer.Slip.CreateDate,GETDATE())>10 or Customer.Slip.IsLive=1 
							  or Customer.Slip.SlipStateId in (2,7)   then 0 else 1 end as IsCancel
							  , Parameter.Branch.BrancName,DATEADD(MINUTE,10,Customer.Slip.CreateDate) as CancelDate
							  ,Customer.Slip.IsPayOut
							  ,case when Customer.Slip.IsPayOut=1 then 0 else case when Customer.Slip.SlipStateId in (3) and Customer.slip.TotalOddValue>1  then  Customer.Slip.Amount *Customer.Slip.TotalOddValue else case when (Customer.Slip.SlipStateId in (2) or (Customer.Slip.SlipStateId=3 and Customer.slip.TotalOddValue=1) ) then  Customer.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock)  where SlipId=Customer.Slip.SlipId),0)  else 0 end end end as RemainingPayOut
							  ,case when Customer.Slip.IsPayOut=0 or Customer.Slip.IsPayOut is null  then 0 else case when Customer.Slip.SlipStateId in (3) and Customer.slip.TotalOddValue>1 then  Customer.Slip.Amount *Customer.Slip.TotalOddValue else case when (Customer.Slip.SlipStateId in (2) or (Customer.Slip.SlipStateId=3 and Customer.slip.TotalOddValue=1) ) then  Customer.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock)  where SlipId=Customer.Slip.SlipId),0)  else 0 end end end as PaidAmount,
							  Customer.Customer.IsBranchCustomer,
							  case when (Select Count(*) from Customer.Tax with (nolock)  where SlipId=Customer.Slip.SlipId and SlipTypeId=2)>0 Then (Select Customer.Tax.TaxAmount from Customer.Tax with (nolock)  where SlipId=Customer.Slip.SlipId and SlipTypeId=2) else 0 end as Tax
							  ,case when Customer.Slip.SlipStateId in (3) and Customer.slip.TotalOddValue>1 then   Customer.Slip.TotalOddValue * Customer.Slip.Amount else case when (Customer.Slip.SlipStateId in (2) or (Customer.Slip.SlipStateId=3 and Customer.slip.TotalOddValue=1) ) then   Customer.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock)  where SlipId=Customer.Slip.SlipId),0) else case when Customer.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashout.SlipId=Customer.Slip.SlipId) else 0 end end end AS Winning
		FROM         Customer.Customer with (nolock)  INNER JOIN
							  Customer.Slip with (nolock)  ON Customer.Customer.CustomerId = Customer.Slip.CustomerId INNER JOIN
							 -- Customer.SlipOdd with (nolock)  ON Customer.Slip.SlipId = Customer.SlipOdd.SlipId INNER JOIN
							  Parameter.SlipState with (nolock)  ON Customer.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN
							  Language.[Parameter.SlipState] with (nolock) On [Language].[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].[LanguageId]=2 INNER JOIN
							  Parameter.Source with (nolock)  ON Customer.Slip.SourceId = Parameter.Source.SourceId INNER JOIN
							  Parameter.SlipType with (nolock)  ON Customer.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN
							  [Language].[Parameter.SlipType] with (nolock) ON [Language].[Parameter.SlipType].[SlipTypeId]=Parameter.SlipType.Id and  [Language].[Parameter.SlipType].LanguageId=@LangId INNER JOIN
							  Parameter.SlipStatu with (nolock)  ON Customer.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN
							  Parameter.Currency with (nolock)  ON Parameter.Currency.CurrencyId  = @UserCurrencyId INNER JOIN
							  Parameter.Branch with (nolock)  On Parameter.Branch.BranchId=Customer.Customer.BranchId
		WHERE Customer.Slip.SlipId=@SlipId  
		and 		Customer.Customer.BranchId in  (select BranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId or ParentBranchId=@BranchId or BranchId in (select ParentBranchId from Parameter.Branch with (nolock)   where (BranchId=@BranchId or ParentBranchId=@BranchId)) or ParentBranchId in (select ParentBranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId))))
		--GROUP BY Customer.Slip.SlipId, Customer.Slip.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
		--					  Customer.Slip.Amount, Customer.Slip.TotalOddValue, Parameter.SlipState.StateId, [Language].[Parameter.SlipState].SlipState, Customer.Slip.CreateDate, Parameter.Source.SourceId, 
		--					  Parameter.Source.Source, Customer.Slip.SlipTypeId, Customer.Slip.SourceId, [Language].[Parameter.SlipType].SlipType, 
		--					  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,Customer.Customer.CurrencyId,Parameter.Branch.BrancName ,Customer.Slip.IsPayOut,Customer.Slip.SlipStateId,Customer.Customer.IsBranchCustomer,Customer.Slip.IsLive
		end
		else if exists (select  Customer.Slip.SlipId  from Customer.Slip with (nolock)  where Customer.Slip.SlipId=@SlipId and Customer.Slip.SlipTypeId=3) 
		begin
		insert @TempTable
			select (select Min(SlipId) from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
, Customer.SlipSystem.CustomerId, 
Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName
,  Customer.SlipSystem.Amount   as Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,[Language].[Parameter.SlipState].[SlipState] as State
,Customer.SlipSystem.CreateDate
, Parameter.Source.SourceId
,Parameter.Source.Source
,(Select Count([Customer].[SlipSystemSlip].SlipId) from [Customer].[SlipSystemSlip] with (nolock)  where [SystemSlipId]=Customer.SlipSystem.SystemSlipId ) as OddCount
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else Customer.SlipSystem.[System] end as SlipType
,Customer.SlipSystem.SlipTypeId
,Parameter.SlipState.StatuColor AS SlipStateStatuColor
, Customer.SlipSystem.MaxGain as MaxGain
, Parameter.Currency.CurrencyId
, Parameter.Currency.Currency
,'Normal' as SlipStatu
,case when DATEDIFF(MINUTE,Customer.SlipSystem.CreateDate,GETDATE())>10 or (select Count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where Customer.Slip.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.Slip.IsLive=1)>0 or (select Count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where Customer.Slip.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.Slip.SlipStateId in (2,7))>0 then 0 else 1 end as IsCancel
, Parameter.Branch.BrancName
,DATEADD(MINUTE,10,Customer.SlipSystem.CreateDate) as CancelDate
	  ,Customer.SlipSystem.IsPayOut
							  ,case when Customer.SlipSystem.IsPayOut=1 then 0 else case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId=3 then cast( ISNULL((Select  SUM(Customer.Slip.TotalOddValue * Customer.Slip.Amount) from Customer.Slip with (nolock) where Customer.Slip.SlipStateId in (3,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) as money) else 0 end end end as RemainingPayOut
							  ,case when Customer.SlipSystem.IsPayOut=0 or Customer.SlipSystem.IsPayOut is null then 0 else case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else ISNULL((Select  cast(SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) as money) from Customer.Slip with (nolock) where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip with (nolock) where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)  end end end as PaidAmount
							  ,Customer.Customer.IsBranchCustomer
							  ,case when (Select Count(Customer.Tax.TaxId) from Customer.Tax with (nolock) where SlipId =Customer.SlipSystem.SystemSlipId and SlipTypeId=3 )>0 Then (Select SUM(TaxAmount) from Customer.Tax with (nolock) where SlipId=Customer.SlipSystem.SystemSlipId and SlipTypeId=3) else 0 end as Tax
							  ,case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId =7 then cast((Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) as money) else cast( ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip with (nolock) where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip with (nolock) where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0) as money)  end end as Winning
from Customer.SlipSystem with (nolock)  INNER JOIN Parameter.SlipState with (nolock)  ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
  Language.[Parameter.SlipState] with (nolock) On [Language].[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].[LanguageId]=2 INNER JOIN
 Customer.Customer with (nolock)  ON Customer.Customer.CustomerId = Customer.SlipSystem.CustomerId INNER JOIN
							  Parameter.Source with (nolock)  ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN
							  Parameter.Currency with (nolock)  ON Parameter.Currency.CurrencyId  =@UserCurrencyId 
							   INNER JOIN  Parameter.Branch with (nolock)  On Parameter.Branch.BranchId=Customer.Customer.BranchId
where Customer.SlipSystem.SystemSlipId = (select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock)  where SlipId=@SlipId)
and 		Customer.Customer.BranchId in   (select BranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId or ParentBranchId=@BranchId or BranchId in (select ParentBranchId from Parameter.Branch with (nolock)   where (BranchId=@BranchId or ParentBranchId=@BranchId)) or ParentBranchId in (select ParentBranchId from Parameter.Branch with (nolock)   where (BranchId=@BranchId))))
--GROUP BY Customer.SlipSystem.SystemSlipId, Customer.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
--							  Customer.SlipSystem.Amount, Customer.SlipSystem.TotalOddValue, Parameter.SlipState.StateId, [Language].[Parameter.SlipState].[SlipState], Customer.SlipSystem.CreateDate, Parameter.Source.SourceId, 
--							  Parameter.Source.Source, Customer.SlipSystem.SlipTypeId, Customer.SlipSystem.SourceId, 
--							  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.Branch.BrancName,Customer.SlipSystem.SlipStateId,Customer.SlipSystem.EventCount,Customer.SlipSystem.[System]
--							  ,Customer.SlipSystem.MaxGain,Customer.Customer.CurrencyId  ,Customer.SlipSystem.IsPayOut,Customer.Customer.IsBranchCustomer

		end
		else if exists (select  Customer.Slip.SlipId  from Customer.Slip with (nolock)  where Customer.Slip.SlipId=@SlipId and Customer.Slip.SlipTypeId=4) 
		begin
		insert @TempTable
			select (select Min(SlipId) from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
, Customer.SlipSystem.CustomerId, 
Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName
,  Customer.SlipSystem.Amount   as Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,[Language].[Parameter.SlipState].[SlipState] as State
,Customer.SlipSystem.CreateDate
, Parameter.Source.SourceId
,Parameter.Source.Source
,ISNULL(Customer.SlipSystem.CouponCount,1) as OddCount
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else Customer.SlipSystem.[System] end as SlipType
,Customer.SlipSystem.SlipTypeId
,Parameter.SlipState.StatuColor AS SlipStateStatuColor
, Customer.SlipSystem.MaxGain as MaxGain
, Parameter.Currency.CurrencyId
, Parameter.Currency.Currency
,'Normal' as SlipStatu
,case when DATEDIFF(MINUTE,Customer.SlipSystem.CreateDate,GETDATE())>10 or (select Count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where Customer.Slip.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.Slip.IsLive=1)>0 or (select Count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where Customer.Slip.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.Slip.SlipStateId in (2,7))>0 then 0 else 1 end as IsCancel
, Parameter.Branch.BrancName
,DATEADD(MINUTE,10,Customer.SlipSystem.CreateDate) as CancelDate
	  ,Customer.SlipSystem.IsPayOut
							  ,case when Customer.SlipSystem.IsPayOut=1 then 0 else case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId=3 then Customer.SlipSystem.MaxGain*cast(1 as float) else 0 end end end as RemainingPayOut
							  ,case when Customer.SlipSystem.IsPayOut=0 or Customer.SlipSystem.IsPayOut is null then 0 else case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else Customer.SlipSystem.MaxGain*cast(1 as float)  end end end as PaidAmount
							  ,Customer.Customer.IsBranchCustomer
							  ,case when (Select Count(Customer.Tax.TaxId) from Customer.Tax with (nolock) where SlipId =Customer.SlipSystem.SystemSlipId and SlipTypeId=3 )>0 Then (Select SUM(TaxAmount) from Customer.Tax with (nolock) where SlipId=Customer.SlipSystem.SystemSlipId and SlipTypeId=3) else 0 end as Tax
							  ,case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId =7 then cast((Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) as money) else Customer.SlipSystem.MaxGain*cast(1 as float)  end end as Winning
from Customer.SlipSystem with (nolock)  INNER JOIN Parameter.SlipState with (nolock)  ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
  Language.[Parameter.SlipState] with (nolock) On [Language].[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].[LanguageId]=2 INNER JOIN
 Customer.Customer with (nolock)  ON Customer.Customer.CustomerId = Customer.SlipSystem.CustomerId INNER JOIN
							  Parameter.Source with (nolock)  ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN
							  Parameter.Currency with (nolock)  ON Parameter.Currency.CurrencyId  =@UserCurrencyId 
							   INNER JOIN  Parameter.Branch with (nolock)  On Parameter.Branch.BranchId=Customer.Customer.BranchId
where Customer.SlipSystem.SystemSlipId = (select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock)  where SlipId=@SlipId)
and 		Customer.Customer.BranchId in   (select BranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId or ParentBranchId=@BranchId or BranchId in (select ParentBranchId from Parameter.Branch with (nolock)   where (BranchId=@BranchId or ParentBranchId=@BranchId)) or ParentBranchId in (select ParentBranchId from Parameter.Branch with (nolock)   where (BranchId=@BranchId))))
--GROUP BY Customer.SlipSystem.SystemSlipId, Customer.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
--							  Customer.SlipSystem.Amount, Customer.SlipSystem.TotalOddValue, Parameter.SlipState.StateId, [Language].[Parameter.SlipState].[SlipState], Customer.SlipSystem.CreateDate, Parameter.Source.SourceId, 
--							  Parameter.Source.Source, Customer.SlipSystem.SlipTypeId, Customer.SlipSystem.SourceId, 
--							  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.Branch.BrancName,Customer.SlipSystem.SlipStateId,Customer.SlipSystem.EventCount,Customer.SlipSystem.[System]
--							  ,Customer.SlipSystem.MaxGain,Customer.Customer.CurrencyId  ,Customer.SlipSystem.IsPayOut,Customer.Customer.IsBranchCustomer

		end
		else if exists (select  Customer.Slip.SlipId  from Customer.Slip with (nolock)  where Customer.Slip.SlipId=@SlipId and Customer.Slip.SlipTypeId=5) 
		begin
		insert @TempTable
			select (select Min(SlipId) from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
, Customer.SlipSystem.CustomerId, 
Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName
,  Customer.SlipSystem.Amount   as Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,[Language].[Parameter.SlipState].[SlipState] as State
,Customer.SlipSystem.CreateDate
, Parameter.Source.SourceId
,Parameter.Source.Source
,ISNULL(Customer.SlipSystem.CouponCount,1) as OddCount
,'Multiway Ticket' as SlipType
,Customer.SlipSystem.SlipTypeId
,Parameter.SlipState.StatuColor AS SlipStateStatuColor
, Customer.SlipSystem.MaxGain as MaxGain
, Parameter.Currency.CurrencyId
, Parameter.Currency.Currency
,'Normal' as SlipStatu
,case when DATEDIFF(MINUTE,Customer.SlipSystem.CreateDate,GETDATE())>10 or (select Count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where Customer.Slip.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.Slip.IsLive=1)>0 or (select Count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where Customer.Slip.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.Slip.SlipStateId in (2,7))>0 then 0 else 1 end as IsCancel
, Parameter.Branch.BrancName
,DATEADD(MINUTE,10,Customer.SlipSystem.CreateDate) as CancelDate
	  ,Customer.SlipSystem.IsPayOut
							  ,case when Customer.SlipSystem.IsPayOut=1 then 0 else case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId=3 then Customer.SlipSystem.MaxGain*cast(1 as float) else 0 end end end as RemainingPayOut
							  ,case when Customer.SlipSystem.IsPayOut=0 or Customer.SlipSystem.IsPayOut is null then 0 else case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else Customer.SlipSystem.MaxGain*cast(1 as float)  end end end as PaidAmount
							  ,Customer.Customer.IsBranchCustomer
							  ,case when (Select Count(Customer.Tax.TaxId) from Customer.Tax with (nolock) where SlipId =Customer.SlipSystem.SystemSlipId and SlipTypeId=3 )>0 Then (Select SUM(TaxAmount) from Customer.Tax with (nolock) where SlipId=Customer.SlipSystem.SystemSlipId and SlipTypeId=3) else 0 end as Tax
							  ,case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId =7 then cast((Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) as money) else Customer.SlipSystem.MaxGain*cast(1 as float)  end end as Winning
from Customer.SlipSystem with (nolock)  INNER JOIN Parameter.SlipState with (nolock)  ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
  Language.[Parameter.SlipState] with (nolock) On [Language].[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].[LanguageId]=2 INNER JOIN
 Customer.Customer with (nolock)  ON Customer.Customer.CustomerId = Customer.SlipSystem.CustomerId INNER JOIN
							  Parameter.Source with (nolock)  ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN
							  Parameter.Currency with (nolock)  ON Parameter.Currency.CurrencyId  =@UserCurrencyId 
							   INNER JOIN  Parameter.Branch with (nolock)  On Parameter.Branch.BranchId=Customer.Customer.BranchId
where Customer.SlipSystem.SystemSlipId = (select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock)  where SlipId=@SlipId)
and 		Customer.Customer.BranchId in   (select BranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId or ParentBranchId=@BranchId or BranchId in (select ParentBranchId from Parameter.Branch with (nolock)   where (BranchId=@BranchId or ParentBranchId=@BranchId)) or ParentBranchId in (select ParentBranchId from Parameter.Branch with (nolock)   where (BranchId=@BranchId))))
--GROUP BY Customer.SlipSystem.SystemSlipId, Customer.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
--							  Customer.SlipSystem.Amount, Customer.SlipSystem.TotalOddValue, Parameter.SlipState.StateId, [Language].[Parameter.SlipState].[SlipState], Customer.SlipSystem.CreateDate, Parameter.Source.SourceId, 
--							  Parameter.Source.Source, Customer.SlipSystem.SlipTypeId, Customer.SlipSystem.SourceId, 
--							  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.Branch.BrancName,Customer.SlipSystem.SlipStateId,Customer.SlipSystem.EventCount,Customer.SlipSystem.[System]
--							  ,Customer.SlipSystem.MaxGain,Customer.Customer.CurrencyId  ,Customer.SlipSystem.IsPayOut,Customer.Customer.IsBranchCustomer

		end
	end
	end
else
	begin
			if(select IsBranchCustomer from Customer.Customer with (nolock) where CustomerId = (select Archive.Slip.CustomerId from Archive.Slip with (nolock) where Archive.Slip.SlipId=@SlipId))=0
			begin
			select @BranchId= BranchId,@SlipBranchId=BranchId,@CustomerUsername=Username from Customer.Customer with (nolock) where CustomerId = (select Archive.Slip.CustomerId from Archive.Slip with (nolock) where Archive.Slip.SlipId=@SlipId)
			if(@CustomerUsername<>@Username)
				set @Control=1
			end
			else
			select @BranchId= BranchId,@SlipBranchId=BranchId,@UserCurrencyId=CurrencyId from Customer.Customer with (nolock) where CustomerId = (select Archive.Slip.CustomerId from Archive.Slip with (nolock)  where Archive.Slip.SlipId=@SlipId)
if(((@SlipBranchId=@CustomerBranchId) or (@SlipBranchId in (select BranchId from Parameter.Branch where ParentBranchId in (Select ParentBranchId from Parameter.Branch where BranchId=@CustomerBranchId))) or (@SlipBranchId in (  (Select ParentBranchId from Parameter.Branch where BranchId=@CustomerBranchId)))  or @CustomerBranchId is null) and @Control=0 )
	begin
	if exists (select  Archive.Slip.SlipId  from Archive.Slip with (nolock) where Archive.Slip.SlipId=@SlipId and Archive.Slip.SlipTypeId<3)
		begin
		insert @TempTable
		select  Archive.Slip.SlipId, Archive.Slip.CustomerId, 
							  Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName, 
							   Archive.Slip.Amount  as Amount
							  , Archive.Slip.TotalOddValue, Parameter.SlipState.StateId, [Language].[Parameter.SlipState].SlipState as State
							  ,Archive.Slip.CreateDate as CreateDate, Parameter.Source.SourceId, 
							  Parameter.Source.Source, Archive.Slip.EventCount AS OddCount, [Language].[Parameter.SlipType].SlipType, Archive.Slip.SlipTypeId, 
							  Parameter.SlipState.StatuColor AS SlipStateStatuColor
							 ,   Archive.Slip.Amount *Archive.Slip.TotalOddValue   AS MaxGain
							  , Parameter.Currency.CurrencyId, 
							  Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,0 as IsCancel, Parameter.Branch.BrancName,GETDATE() as CancelDate
							   ,Archive.Slip.IsPayOut
							  ,case when Archive.Slip.IsPayOut=1 then 0 else case when Archive.Slip.SlipStateId in (3) and Archive.slip.TotalOddValue>1  then  Archive.Slip.Amount *Archive.Slip.TotalOddValue else case when (Archive.Slip.SlipStateId in (2) or (Archive.Slip.SlipStateId=3 and Archive.slip.TotalOddValue=1) ) then  Archive.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock)  where SlipId=Archive.Slip.SlipId),0)  else 0 end end end as RemainingPayOut
							  ,case when Archive.Slip.IsPayOut=0 or Archive.Slip.IsPayOut is null  then 0 else case when Archive.Slip.SlipStateId in (3) and Archive.slip.TotalOddValue>1 then  Archive.Slip.Amount *Archive.Slip.TotalOddValue else case when (Archive.Slip.SlipStateId in (2) or (Archive.Slip.SlipStateId=3 and Archive.slip.TotalOddValue=1) ) then  Archive.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock)  where SlipId=Archive.Slip.SlipId),0)  else 0 end end end as PaidAmount
							  ,Customer.Customer.IsBranchCustomer,
							  case when (Select Count(*) from Customer.Tax with (nolock) where SlipId=Archive.Slip.SlipId and SlipTypeId=2)>0 Then (Select Customer.Tax.TaxAmount from Customer.Tax with (nolock) where SlipId=Archive.Slip.SlipId and SlipTypeId=2) else 0 end as Tax
							  ,case when Archive.Slip.SlipStateId in (3) and Archive.slip.TotalOddValue>1 then   Archive.Slip.TotalOddValue * Archive.Slip.Amount else case when (Archive.Slip.SlipStateId in (2) or (Archive.Slip.SlipStateId=3 and Archive.slip.TotalOddValue=1) ) then   Archive.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock)  where SlipId=Archive.Slip.SlipId),0) else case when Archive.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashout.SlipId=@SlipId) else 0 end end end AS Winning
		FROM         Customer.Customer with (nolock) INNER JOIN
							  Archive.Slip with (nolock) ON Customer.Customer.CustomerId = Archive.Slip.CustomerId INNER JOIN
							 -- Archive.SlipOdd with (nolock) ON Archive.Slip.SlipId = Archive.SlipOdd.SlipId INNER JOIN
							  Parameter.SlipState with (nolock) ON Archive.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN
							   Language.[Parameter.SlipState] with (nolock) On [Language].[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].[LanguageId]=2 INNER JOIN
							  Parameter.Source with (nolock) ON Archive.Slip.SourceId = Parameter.Source.SourceId INNER JOIN
							  Parameter.SlipType with (nolock) ON Archive.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN
							  [Language].[Parameter.SlipType] with (nolock) ON [Language].[Parameter.SlipType].[SlipTypeId]=Parameter.SlipType.Id and  [Language].[Parameter.SlipType].LanguageId=@LangId INNER JOIN
							  Parameter.SlipStatu with (nolock) ON Archive.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN
							  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  = @UserCurrencyId INNER JOIN
							  	  Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
		WHERE Archive.Slip.SlipId=@SlipId
		and 		Customer.Customer.BranchId in  (select BranchId from Parameter.Branch with (nolock) where (BranchId=@BranchId or ParentBranchId=@BranchId or BranchId in (select ParentBranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId or ParentBranchId=@BranchId)) or ParentBranchId in (select ParentBranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId))))
		--GROUP BY Archive.Slip.SlipId, Archive.Slip.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
		--					  Archive.Slip.Amount, Archive.Slip.TotalOddValue, Parameter.SlipState.StateId, [Language].[Parameter.SlipState].SlipState, Archive.Slip.CreateDate, Parameter.Source.SourceId, 
		--					  Parameter.Source.Source, Archive.Slip.SlipTypeId, Archive.Slip.SourceId, [Language].[Parameter.SlipType].SlipType, 
		--					  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,Customer.Customer.CurrencyId    ,Parameter.Branch.BrancName      ,Archive.Slip.IsPayOut 
		--					  ,Archive.Slip.SlipStateId,Customer.Customer.IsBranchCustomer      
		end
		else if exists (select  Archive.Slip.SlipId  from Archive.Slip with (nolock) where Archive.Slip.SlipId=@SlipId and Archive.Slip.SlipTypeId=3)
		begin
		insert @TempTable
			select (select Min(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
, Customer.SlipSystem.CustomerId, 
Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName
, Customer.SlipSystem.Amount  as Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,[Language].[Parameter.SlipState].[SlipState] as State
,Customer.SlipSystem.CreateDate
, Parameter.Source.SourceId
,Parameter.Source.Source
,(Select Count([Customer].[SlipSystemSlip].SlipId) from [Customer].[SlipSystemSlip] with (nolock) where [SystemSlipId]=Customer.SlipSystem.SystemSlipId ) as OddCount
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else Customer.SlipSystem.[System] end as SlipType
,Customer.SlipSystem.SlipTypeId
,Parameter.SlipState.StatuColor AS SlipStateStatuColor
, Customer.SlipSystem.MaxGain  as MaxGain
, Parameter.Currency.CurrencyId
, Parameter.Currency.Currency
,'Normal' as SlipStatu
,case when DATEDIFF(MINUTE,Customer.SlipSystem.CreateDate,GETDATE())>10 or (select Count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where Customer.Slip.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.Slip.IsLive=1)>0 or (select Count(Archive.Slip.SlipId) from Archive.Slip with (nolock) where Archive.Slip.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Archive.Slip.SlipStateId=2)>0 then 0 else 1 end as IsCancel
, Parameter.Branch.BrancName
,DATEADD(MINUTE,10,Customer.SlipSystem.CreateDate) as CancelDate
	  ,Customer.SlipSystem.IsPayOut
							  ,case when Customer.SlipSystem.IsPayOut=1 then 0 else case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId=3 then ISNULL((Select SUM(Archive.Slip.TotalOddValue * Archive.Slip.Amount) from Archive.Slip with (nolock) where Archive.Slip.SlipStateId in (3,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) else 0 end end end as RemainingPayOut
							  ,case when Customer.SlipSystem.IsPayOut=0 or Customer.SlipSystem.IsPayOut is null then 0 else case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip with (nolock) where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip with (nolock) where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)  end end end as PaidAmount
							  ,Customer.Customer.IsBranchCustomer
							  ,case when (Select Count(Customer.Tax.TaxId) from Customer.Tax with (nolock) where SlipId =Customer.SlipSystem.SystemSlipId and SlipTypeId=3 )>0 Then (Select SUM(TaxAmount) from Customer.Tax with (nolock) where SlipId=Customer.SlipSystem.SystemSlipId and SlipTypeId=3) else 0 end as Tax
							  ,case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then cast((Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) as money) else cast(ISNULL((Select cast( SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) as money) from Customer.Slip with (nolock) where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)+ISNULL((Select cast(SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) as money) from Archive.Slip with (nolock) where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)  as money) end end as Winning
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
Language.[Parameter.SlipState] with (nolock) On [Language].[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].[LanguageId]=2 INNER JOIN
 Customer.Customer with (nolock) ON Customer.Customer.CustomerId = Customer.SlipSystem.CustomerId INNER JOIN
							  Parameter.Source with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN
							  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  =@UserCurrencyId  INNER JOIN
							  Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
where Customer.SlipSystem.SystemSlipId = (select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)
and 		Customer.Customer.BranchId in   (select BranchId from Parameter.Branch with (nolock) where (BranchId=@BranchId or ParentBranchId=@BranchId or BranchId in (select ParentBranchId from Parameter.Branch  with (nolock) where (BranchId=@BranchId or ParentBranchId=@BranchId)) or ParentBranchId in (select ParentBranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId))))
--GROUP BY Customer.SlipSystem.SystemSlipId, Customer.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
--							  Customer.SlipSystem.Amount, Customer.SlipSystem.TotalOddValue, Parameter.SlipState.StateId, [Language].[Parameter.SlipState].[SlipState], Customer.SlipSystem.CreateDate, Parameter.Source.SourceId, 
--							  Parameter.Source.Source, Customer.SlipSystem.SlipTypeId, Customer.SlipSystem.SourceId, 
--							  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.Branch.BrancName,Customer.SlipSystem.SlipStateId,Customer.SlipSystem.EventCount,Customer.SlipSystem.[System]
--							  ,Customer.SlipSystem.MaxGain,Customer.Customer.CurrencyId  ,Customer.SlipSystem.IsPayOut,Customer.Customer.IsBranchCustomer
		end 
		else if exists (select  Archive.Slip.SlipId  from Archive.Slip with (nolock) where Archive.Slip.SlipId=@SlipId and Archive.Slip.SlipTypeId=4)
		begin
		insert @TempTable
			select (select Min(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
, Customer.SlipSystem.CustomerId, 
Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName
, Customer.SlipSystem.Amount  as Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,[Language].[Parameter.SlipState].[SlipState] as State
,Customer.SlipSystem.CreateDate
, Parameter.Source.SourceId
,Parameter.Source.Source
,ISNULL(Customer.SlipSystem.CouponCount,1) as OddCount
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else Customer.SlipSystem.[System] end as SlipType
,Customer.SlipSystem.SlipTypeId
,Parameter.SlipState.StatuColor AS SlipStateStatuColor
, Customer.SlipSystem.MaxGain  as MaxGain
, Parameter.Currency.CurrencyId
, Parameter.Currency.Currency
,'Normal' as SlipStatu
,case when DATEDIFF(MINUTE,Customer.SlipSystem.CreateDate,GETDATE())>10 or (select Count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where Customer.Slip.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.Slip.IsLive=1)>0 or (select Count(Archive.Slip.SlipId) from Archive.Slip with (nolock) where Archive.Slip.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Archive.Slip.SlipStateId=2)>0 then 0 else 1 end as IsCancel
, Parameter.Branch.BrancName
,DATEADD(MINUTE,10,Customer.SlipSystem.CreateDate) as CancelDate
	  ,Customer.SlipSystem.IsPayOut
							  ,case when Customer.SlipSystem.IsPayOut=1 then 0 else case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId=3 then Customer.SlipSystem.MaxGain*cast(1 as float) else 0 end end end as RemainingPayOut
							  ,case when Customer.SlipSystem.IsPayOut=0 or Customer.SlipSystem.IsPayOut is null then 0 else case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else Customer.SlipSystem.MaxGain*cast(1 as float)  end end end as PaidAmount
							  ,Customer.Customer.IsBranchCustomer
							  ,case when (Select Count(Customer.Tax.TaxId) from Customer.Tax with (nolock) where SlipId =Customer.SlipSystem.SystemSlipId and SlipTypeId=3 )>0 Then (Select SUM(TaxAmount) from Customer.Tax with (nolock) where SlipId=Customer.SlipSystem.SystemSlipId and SlipTypeId=3) else 0 end as Tax
							  ,case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then cast((Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) as money) else Customer.SlipSystem.MaxGain*cast(1 as float) end end as Winning
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
Language.[Parameter.SlipState] with (nolock) On [Language].[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].[LanguageId]=2 INNER JOIN
 Customer.Customer with (nolock) ON Customer.Customer.CustomerId = Customer.SlipSystem.CustomerId INNER JOIN
							  Parameter.Source with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN
							  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  =@UserCurrencyId  INNER JOIN
							  Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
where Customer.SlipSystem.SystemSlipId = (select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)
and 		Customer.Customer.BranchId in   (select BranchId from Parameter.Branch with (nolock) where (BranchId=@BranchId or ParentBranchId=@BranchId or BranchId in (select ParentBranchId from Parameter.Branch  with (nolock) where (BranchId=@BranchId or ParentBranchId=@BranchId)) or ParentBranchId in (select ParentBranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId))))
--GROUP BY Customer.SlipSystem.SystemSlipId, Customer.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
--							  Customer.SlipSystem.Amount, Customer.SlipSystem.TotalOddValue, Parameter.SlipState.StateId, [Language].[Parameter.SlipState].[SlipState], Customer.SlipSystem.CreateDate, Parameter.Source.SourceId, 
--							  Parameter.Source.Source, Customer.SlipSystem.SlipTypeId, Customer.SlipSystem.SourceId, 
--							  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.Branch.BrancName,Customer.SlipSystem.SlipStateId,Customer.SlipSystem.EventCount,Customer.SlipSystem.[System]
--							  ,Customer.SlipSystem.MaxGain,Customer.Customer.CurrencyId  ,Customer.SlipSystem.IsPayOut,Customer.Customer.IsBranchCustomer
		end 
		else if exists (select  Archive.Slip.SlipId  from Archive.Slip with (nolock) where Archive.Slip.SlipId=@SlipId and Archive.Slip.SlipTypeId=5)
		begin
		insert @TempTable
			select (select Min(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
, Customer.SlipSystem.CustomerId, 
Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName
, Customer.SlipSystem.Amount  as Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,[Language].[Parameter.SlipState].[SlipState] as State
,Customer.SlipSystem.CreateDate
, Parameter.Source.SourceId
,Parameter.Source.Source
,ISNULL(Customer.SlipSystem.CouponCount,1) as OddCount
,'Multiway Ticket'  as SlipType
,Customer.SlipSystem.SlipTypeId
,Parameter.SlipState.StatuColor AS SlipStateStatuColor
, Customer.SlipSystem.MaxGain  as MaxGain
, Parameter.Currency.CurrencyId
, Parameter.Currency.Currency
,'Normal' as SlipStatu
,case when DATEDIFF(MINUTE,Customer.SlipSystem.CreateDate,GETDATE())>10 or (select Count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where Customer.Slip.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.Slip.IsLive=1)>0 or (select Count(Archive.Slip.SlipId) from Archive.Slip with (nolock) where Archive.Slip.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Archive.Slip.SlipStateId=2)>0 then 0 else 1 end as IsCancel
, Parameter.Branch.BrancName
,DATEADD(MINUTE,10,Customer.SlipSystem.CreateDate) as CancelDate
	  ,Customer.SlipSystem.IsPayOut
							  ,case when Customer.SlipSystem.IsPayOut=1 then 0 else case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId=3 then Customer.SlipSystem.MaxGain*cast(1 as float) else 0 end end end as RemainingPayOut
							  ,case when Customer.SlipSystem.IsPayOut=0 or Customer.SlipSystem.IsPayOut is null then 0 else case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else Customer.SlipSystem.MaxGain*cast(1 as float)  end end end as PaidAmount
							  ,Customer.Customer.IsBranchCustomer
							  ,case when (Select Count(Customer.Tax.TaxId) from Customer.Tax with (nolock) where SlipId =Customer.SlipSystem.SystemSlipId and SlipTypeId=3 )>0 Then (Select SUM(TaxAmount) from Customer.Tax with (nolock) where SlipId=Customer.SlipSystem.SystemSlipId and SlipTypeId=3) else 0 end as Tax
							  ,case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then cast((Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) as money) else Customer.SlipSystem.MaxGain*cast(1 as float) end end as Winning
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
Language.[Parameter.SlipState] with (nolock) On [Language].[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].[LanguageId]=2 INNER JOIN
 Customer.Customer with (nolock) ON Customer.Customer.CustomerId = Customer.SlipSystem.CustomerId INNER JOIN
							  Parameter.Source with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN
							  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  =@UserCurrencyId  INNER JOIN
							  Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
where Customer.SlipSystem.SystemSlipId = (select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)
and 		Customer.Customer.BranchId in   (select BranchId from Parameter.Branch with (nolock) where (BranchId=@BranchId or ParentBranchId=@BranchId or BranchId in (select ParentBranchId from Parameter.Branch  with (nolock) where (BranchId=@BranchId or ParentBranchId=@BranchId)) or ParentBranchId in (select ParentBranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId))))
--GROUP BY Customer.SlipSystem.SystemSlipId, Customer.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
--							  Customer.SlipSystem.Amount, Customer.SlipSystem.TotalOddValue, Parameter.SlipState.StateId, [Language].[Parameter.SlipState].[SlipState], Customer.SlipSystem.CreateDate, Parameter.Source.SourceId, 
--							  Parameter.Source.Source, Customer.SlipSystem.SlipTypeId, Customer.SlipSystem.SourceId, 
--							  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.Branch.BrancName,Customer.SlipSystem.SlipStateId,Customer.SlipSystem.EventCount,Customer.SlipSystem.[System]
--							  ,Customer.SlipSystem.MaxGain,Customer.Customer.CurrencyId  ,Customer.SlipSystem.IsPayOut,Customer.Customer.IsBranchCustomer
		end 
		end
	end
	
	select * from @TempTable
END




GO
