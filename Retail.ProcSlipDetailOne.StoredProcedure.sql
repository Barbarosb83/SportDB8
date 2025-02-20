USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcSlipDetailOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
 
CREATE PROCEDURE [Retail].[ProcSlipDetailOne]
@SlipId bigint,
@Username nvarchar(50)


AS




BEGIN
SET NOCOUNT ON;
declare @UserCurrencyId int
declare @BranchId int
select @UserCurrencyId=Users.Users.CurrencyId,@BranchId=UnitCode from Users.Users where Users.Users.UserName=@Username

--insert dbo.betslip (data,CreateDate) values (cast(@SlipId as nvarchar(50)),GETDATE())

if exists (select Customer.Slip.SlipId from Customer.Slip with (nolock) where Customer.Slip.SlipId=@SlipId)
	begin
		if(select count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where Customer.Slip.SlipId=@SlipId and Customer.Slip.SlipTypeId<3)>0
		begin
		select  Customer.Slip.SlipId, Customer.Slip.CustomerId, 
							  Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName, 
							  Customer.Slip.Amount as Amount, Customer.Slip.TotalOddValue, Parameter.SlipState.StateId, Language.[Parameter.SlipState].SlipState as State
							  , Customer.Slip.CreateDate  as CreateDate, Parameter.Source.SourceId, 
							  Parameter.Source.Source, Customer.Slip.EventCount AS OddCount, Parameter.SlipType.SlipType, Customer.Slip.SlipTypeId, 
							  Parameter.SlipState.StatuColor AS SlipStateStatuColor
							  ,case when Customer.Slip.SlipStateId in (3) and Customer.Slip.TotalOddValue>1 then  cast(Customer.Slip.TotalOddValue * Customer.Slip.Amount as money) else case when Customer.Slip.SlipStateId in (2) Or   Customer.Slip.TotalOddValue=1 then Customer.Slip.Amount+ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax where SlipId=Customer.Slip.SlipId),0) else case when Customer.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashout.SlipId=@SlipId) else 0 end end end AS MaxGain
							  , Parameter.Currency.CurrencyId, 
							  Parameter.Currency.Currency
							  ,Parameter.SlipStatu.SlipStatu
							  ,case when DATEDIFF(MINUTE,Customer.Slip.CreateDate,GETDATE())>10 
							  or (Select COUNT(Live.EventDetail.EventId) from Live.EventDetail with (nolock ) where EventId in (select (Customer.SlipOdd.MatchId) from Customer.SlipOdd with (nolock) where Customer.SlipOdd.SlipId=@SlipId and Customer.SlipOdd.BetTypeId=1) and Live.EventDetail.TimeStatu>1)>0 
							  or (select Count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where Customer.Slip.SlipId=@SlipId and Customer.Slip.SlipStateId in (2,7))>0   then 0 else case when ISNULL(IsTerminalCustomer,0)=1 OR ISNULL(IsBranchCustomer,0)=1 then 1 else 0 end end as IsCancel
							  , Parameter.Branch.BrancName,DATEADD(MINUTE,10,dbo.UserTimeZoneDate(@Username,Customer.Slip.CreateDate,0)) as CancelDate
							  ,Customer.Slip.IsPayOut
							  ,case when Customer.Slip.IsPayOut=1 then 0 else case when Customer.Slip.SlipStateId in (3)  and Customer.Slip.TotalOddValue>1 then Customer.Slip.Amount*Customer.Slip.TotalOddValue  else case when Customer.Slip.SlipStateId in (2) Or   Customer.Slip.TotalOddValue=1  then Customer.Slip.Amount+ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax where SlipId=Customer.Slip.SlipId),0) else 0 end end end as RemainingPayOut
							  ,case when Customer.Slip.IsPayOut=0 or Customer.Slip.IsPayOut is null  then 0 else case when Customer.Slip.SlipStateId in (3) and Customer.Slip.TotalOddValue>1 then Customer.Slip.Amount*Customer.Slip.TotalOddValue  else case when Customer.Slip.SlipStateId in (2) Or   Customer.Slip.TotalOddValue=1  then Customer.Slip.Amount+ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock) where SlipId=Customer.Slip.SlipId),0)  else 0 end end end as PaidAmount,
							  cast(1 as bit) as IsBranchCustomer,
							  case when (Select Count(*) from Customer.Tax where SlipId=Customer.Slip.SlipId and SlipTypeId=2)>0 Then (Select Customer.Tax.TaxAmount from Customer.Tax with (nolock) where SlipId=Customer.Slip.SlipId and SlipTypeId=2) else 0 end as Tax
							   ,Customer.Slip.EvaluateDate
							   ,(Select top 1 CreateDate from RiskManagement.BranchTransaction with (nolock) where SlipId=Customer.Slip.SlipId and TransactionTypeId in (8,12)) as PaidDate
		FROM         Customer.Customer with (nolock) INNER JOIN
							  Customer.Slip with (nolock) ON Customer.Customer.CustomerId = Customer.Slip.CustomerId INNER JOIN
							  Parameter.SlipState with (nolock) ON Customer.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN
							  Parameter.Source with (nolock) ON Customer.Slip.SourceId = Parameter.Source.SourceId INNER JOIN
							  Parameter.SlipType with (nolock) ON Customer.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN
							  Parameter.SlipStatu with (nolock) ON Customer.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN
							   Language.[Parameter.SlipState] On Language.[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].LanguageId=6 INNER JOIN 
							  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  = @UserCurrencyId 
							  INNER JOIN
							  Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
		WHERE Customer.Slip.SlipId=@SlipId  
	and 		(Customer.Customer.BranchId in  (select BranchId from Parameter.Branch where ParentBranchId in   (select distinct BranchId from Parameter.Branch with (nolock) where (BranchId=@BranchId or ParentBranchId=@BranchId or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId or ParentBranchId=@BranchId) )))) or Customer.Customer.BranchId=@BranchId)
		--GROUP BY Customer.Slip.SlipId, Customer.Slip.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
		--					  Customer.Slip.Amount, Customer.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.Slip.CreateDate, Parameter.Source.SourceId, 
		--					  Parameter.Source.Source, Customer.Slip.SlipTypeId, Customer.Slip.SourceId, Parameter.SlipType.SlipType, 
		--					  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,Customer.Customer.CurrencyId,Parameter.Branch.BrancName ,Customer.Slip.IsPayOut,Customer.Slip.SlipStateId,Customer.Customer.IsBranchCustomer,Language.[Parameter.SlipState].SlipState
		end
		else if(select count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where Customer.Slip.SlipId=@SlipId and Customer.Slip.SlipTypeId=3)>0
		begin
			select (select Min(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
, Customer.SlipSystem.CustomerId, 
Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName
, Customer.SlipSystem.Amount as Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Language.[Parameter.SlipState].SlipState as State
,Customer.SlipSystem.CreateDate
, Parameter.Source.SourceId
,Parameter.Source.Source
,Customer.SlipSystem.EventCount as OddCount
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else Customer.SlipSystem.[System] end as SlipType
,Customer.SlipSystem.SlipTypeId
,Parameter.SlipState.StatuColor AS SlipStateStatuColor
,case when Customer.SlipSystem.SlipStateId not in (3,7) then 0 else   Customer.SlipSystem.MaxGain end  as MaxGain
--,case when Customer.SlipSystem.SlipStateId not in (5) then 0 else case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip with (nolock) where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip with (nolock) where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)  end end end as MaxGain
, Parameter.Currency.CurrencyId
, Parameter.Currency.Currency
,'Normal' as SlipStatu
,case when DATEDIFF(MINUTE,Customer.SlipSystem.CreateDate,GETDATE())>10 
or (Select COUNT(Live.EventDetail.EventId) from Live.EventDetail with (nolock ) where EventId in (select Customer.SlipOdd.MatchId from Customer.SlipOdd with (nolock) where Customer.SlipOdd.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.SlipOdd.BetTypeId=1) and Live.EventDetail.TimeStatu>1)>0 
or (select Count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where Customer.Slip.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.Slip.SlipStateId in (2,7))>0 then 0 else 1 end as IsCancel
, Parameter.Branch.BrancName
,DATEADD(MINUTE,10,dbo.UserTimeZoneDate(@Username,Customer.SlipSystem.CreateDate,0)) as CancelDate
	  ,Customer.SlipSystem.IsPayOut
							  ,case when Customer.SlipSystem.IsPayOut=1 then 0 else case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId=3 then ISNULL((Select SUM(Customer.Slip.TotalOddValue * Customer.Slip.Amount) from Customer.Slip with (nolock) where Customer.Slip.SlipStateId in (3,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) else 0 end end end as RemainingPayOut
							  ,case when Customer.SlipSystem.IsPayOut=0 or Customer.SlipSystem.IsPayOut is null then 0 else case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else case when Customer.SlipSystem.SlipStateId=2 then Customer.SlipSystem.Amount else  ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip with (nolock) where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip with (nolock) where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0) end end end end as PaidAmount
							  ,cast(1 as bit) as IsBranchCustomer
							  ,case when (Select Count(*) from Customer.Tax where SlipId =Customer.SlipSystem.SystemSlipId and SlipTypeId=3 )>0 Then (Select SUM(TaxAmount) from Customer.Tax where SlipId=Customer.SlipSystem.SystemSlipId and SlipTypeId=3) else 0 end as Tax
							    ,Customer.SlipSystem.EvaluateDate 
							   ,(Select top 1 CreateDate from RiskManagement.BranchTransaction with (nolock) where SlipId=(select Min(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) and TransactionTypeId in (8,12)) as PaidDate
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
 Customer.Customer with (nolock) ON Customer.Customer.CustomerId = Customer.SlipSystem.CustomerId INNER JOIN
							  Parameter.Source with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN
							  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  =@UserCurrencyId  INNER JOIN
							  	   Language.[Parameter.SlipState] On Language.[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].LanguageId=6 INNER JOIN 
							  Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
where Customer.SlipSystem.SystemSlipId = (select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)
and 		(Customer.Customer.BranchId in  (select BranchId from Parameter.Branch where ParentBranchId in   (select distinct BranchId from Parameter.Branch with (nolock) where (BranchId=@BranchId or ParentBranchId=@BranchId or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId or ParentBranchId=@BranchId) )))) or Customer.Customer.BranchId=@BranchId)
--GROUP BY Customer.SlipSystem.SystemSlipId, Customer.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
--							  Customer.SlipSystem.Amount, Customer.SlipSystem.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipSystem.CreateDate, Parameter.Source.SourceId, 
--							  Parameter.Source.Source, Customer.SlipSystem.SlipTypeId, Customer.SlipSystem.SourceId, 
--							  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.Branch.BrancName,Customer.SlipSystem.SlipStateId,Customer.SlipSystem.EventCount,Customer.SlipSystem.[System]
--							  ,Customer.SlipSystem.MaxGain,Customer.Customer.CurrencyId  ,Customer.SlipSystem.IsPayOut,Customer.Customer.IsBranchCustomer,Language.[Parameter.SlipState].SlipState

		end
			else if(select count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where Customer.Slip.SlipId=@SlipId and Customer.Slip.SlipTypeId=4)>0
		begin
		if(@BranchId<>1 and @BranchId<>31767)
				begin
			select (select Min(SlipId) from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
, Customer.SlipSystem.CustomerId, 
Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName
, Customer.SlipSystem.Amount as Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Language.[Parameter.SlipState].SlipState as State
,Customer.SlipSystem.CreateDate
, Parameter.Source.SourceId
,Parameter.Source.Source
,Customer.SlipSystem.EventCount as OddCount
,  SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System'  as SlipType
,Customer.SlipSystem.SlipTypeId
,Parameter.SlipState.StatuColor AS SlipStateStatuColor
,case when Customer.SlipSystem.SlipStateId not in (3,7) then 0 else   Customer.SlipSystem.MaxGain end  as MaxGain
, Parameter.Currency.CurrencyId
, Parameter.Currency.Currency
,'Normal' as SlipStatu
,case when DATEDIFF(MINUTE,Customer.SlipSystem.CreateDate,GETDATE())>10
 or (Select COUNT(Live.EventDetail.EventId) from Live.EventDetail with (nolock ) where EventId in (select  Customer.SlipOdd.MatchId from Customer.SlipOdd with (nolock) where Customer.SlipOdd.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.SlipOdd.BetTypeId=1) and Live.EventDetail.TimeStatu>1)>0 
 or (select Count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where Customer.Slip.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.Slip.SlipStateId in (2,7))>0 then 0 else case when ISNULL(IsTerminalCustomer,0)=1 OR ISNULL(IsBranchCustomer,0)=1 then 1 else 0 end end as IsCancel
, Parameter.Branch.BrancName
,DATEADD(MINUTE,10,dbo.UserTimeZoneDate(@Username,Customer.SlipSystem.CreateDate,0)) as CancelDate
	  ,Customer.SlipSystem.IsPayOut
							  ,case when Customer.SlipSystem.IsPayOut=1 then 0 else case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId=3 then  Customer.SlipSystem.MaxGain*cast(1 as float) else 0 end end end as RemainingPayOut
							  ,case when Customer.SlipSystem.IsPayOut=0 or Customer.SlipSystem.IsPayOut is null then 0 else case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else case when Customer.SlipSystem.SlipStateId=2 then Customer.SlipSystem.Amount else Customer.SlipSystem.MaxGain*cast(1 as float) end end end end as PaidAmount
							  ,cast(1 as bit) as IsBranchCustomer
							  ,case when (Select Count(*) from Customer.Tax with (nolock) where SlipId =Customer.SlipSystem.SystemSlipId and SlipTypeId=3 )>0 Then (Select SUM(TaxAmount) from Customer.Tax where SlipId=Customer.SlipSystem.SystemSlipId and SlipTypeId=3) else 0 end as Tax
							  ,Customer.SlipSystem.EvaluateDate 
,(Select top 1 CreateDate from RiskManagement.BranchTransaction with (nolock) where SlipId=(select Min(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) and TransactionTypeId in (8,12)) as PaidDate
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
 Customer.Customer with (nolock) ON Customer.Customer.CustomerId = Customer.SlipSystem.CustomerId INNER JOIN
							  Parameter.Source with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN
							  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  =@UserCurrencyId  INNER JOIN
							  	   Language.[Parameter.SlipState] On Language.[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].LanguageId=6 INNER JOIN 
							  Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
where Customer.SlipSystem.SystemSlipId = (select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)
and 		(Customer.Customer.BranchId in  (select BranchId from Parameter.Branch where ParentBranchId in   (select distinct BranchId from Parameter.Branch with (nolock) where (BranchId=@BranchId or ParentBranchId=@BranchId or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId or ParentBranchId=@BranchId) )))) or Customer.Customer.BranchId=@BranchId)
--GROUP BY Customer.SlipSystem.SystemSlipId, Customer.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
--							  Customer.SlipSystem.Amount, Customer.SlipSystem.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipSystem.CreateDate, Parameter.Source.SourceId, 
--							  Parameter.Source.Source, Customer.SlipSystem.SlipTypeId, Customer.SlipSystem.SourceId, 
--							  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.Branch.BrancName,Customer.SlipSystem.SlipStateId,Customer.SlipSystem.EventCount,Customer.SlipSystem.[System]
--							  ,Customer.SlipSystem.MaxGain,Customer.Customer.CurrencyId  ,Customer.SlipSystem.IsPayOut,Customer.Customer.IsBranchCustomer,Language.[Parameter.SlipState].SlipState
					end
					else
						begin
			select (select Min(SlipId) from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
, Customer.SlipSystem.CustomerId, 
Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName
, Customer.SlipSystem.Amount  as Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Language.[Parameter.SlipState].SlipState as State
,Customer.SlipSystem.CreateDate
, Parameter.Source.SourceId
,Parameter.Source.Source
,Customer.SlipSystem.EventCount as OddCount
,  SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System'  as SlipType
,Customer.SlipSystem.SlipTypeId
,Parameter.SlipState.StatuColor AS SlipStateStatuColor
,case when Customer.SlipSystem.SlipStateId not in (3,7) then 0 else   Customer.SlipSystem.MaxGain end  as MaxGain
, Parameter.Currency.CurrencyId
, Parameter.Currency.Currency
,'Normal' as SlipStatu
,case when DATEDIFF(MINUTE,Customer.SlipSystem.CreateDate,GETDATE())>10 
or (Select COUNT(Live.EventDetail.EventId) from Live.EventDetail with (nolock ) where EventId in (select  Customer.SlipOdd.MatchId from Customer.SlipOdd with (nolock) where Customer.SlipOdd.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.SlipOdd.BetTypeId=1) and Live.EventDetail.TimeStatu>1)>0 
or (select Count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where Customer.Slip.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.Slip.SlipStateId in (2,7))>0 then 0 else 1 end as IsCancel
, Parameter.Branch.BrancName
,DATEADD(MINUTE,10,dbo.UserTimeZoneDate(@Username,Customer.SlipSystem.CreateDate,0)) as CancelDate
	  ,Customer.SlipSystem.IsPayOut
							  ,case when Customer.SlipSystem.IsPayOut=1 then 0 else case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId=3 then  Customer.SlipSystem.MaxGain*cast(1 as float) else 0 end end end as RemainingPayOut
							  ,case when Customer.SlipSystem.IsPayOut=0 or Customer.SlipSystem.IsPayOut is null then 0 else case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else case when Customer.SlipSystem.SlipStateId=2 then Customer.SlipSystem.Amount else Customer.SlipSystem.MaxGain*cast(1 as float) end end end end as PaidAmount
							  ,cast(1 as bit) as IsBranchCustomer
							  ,case when (Select Count(*) from Customer.Tax with (nolock) where SlipId =Customer.SlipSystem.SystemSlipId and SlipTypeId=3 )>0 Then (Select SUM(TaxAmount) from Customer.Tax where SlipId=Customer.SlipSystem.SystemSlipId and SlipTypeId=3) else 0 end as Tax
							  ,Customer.SlipSystem.EvaluateDate 
,(Select top 1 CreateDate from RiskManagement.BranchTransaction with (nolock) where SlipId=(select Min(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) and TransactionTypeId in (8,12)) as PaidDate
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
 Customer.Customer with (nolock) ON Customer.Customer.CustomerId = Customer.SlipSystem.CustomerId INNER JOIN
							  Parameter.Source with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN
							  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  =@UserCurrencyId  INNER JOIN
							  	   Language.[Parameter.SlipState] On Language.[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].LanguageId=6 INNER JOIN 
							  Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
where Customer.SlipSystem.SystemSlipId = (select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)
--and 		(Customer.Customer.BranchId in  (select BranchId from Parameter.Branch where ParentBranchId in   (select distinct BranchId from Parameter.Branch with (nolock) where (BranchId=@BranchId or ParentBranchId=@BranchId or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId or ParentBranchId=@BranchId) )))) or Customer.Customer.BranchId=@BranchId)
--GROUP BY Customer.SlipSystem.SystemSlipId, Customer.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
--							  Customer.SlipSystem.Amount, Customer.SlipSystem.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipSystem.CreateDate, Parameter.Source.SourceId, 
--							  Parameter.Source.Source, Customer.SlipSystem.SlipTypeId, Customer.SlipSystem.SourceId, 
--							  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.Branch.BrancName,Customer.SlipSystem.SlipStateId,Customer.SlipSystem.EventCount,Customer.SlipSystem.[System]
--							  ,Customer.SlipSystem.MaxGain,Customer.Customer.CurrencyId  ,Customer.SlipSystem.IsPayOut,Customer.Customer.IsBranchCustomer,Language.[Parameter.SlipState].SlipState
					end
		end
			else if(select count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where Customer.Slip.SlipId=@SlipId and Customer.Slip.SlipTypeId=5)>0
		begin
			if(@BranchId<>1 and @BranchId<>31767)
				begin
			select (select Min(SlipId) from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
, Customer.SlipSystem.CustomerId, 
Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName
, Customer.SlipSystem.Amount as Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Language.[Parameter.SlipState].SlipState as State
,Customer.SlipSystem.CreateDate
, Parameter.Source.SourceId
,Parameter.Source.Source
,Customer.SlipSystem.EventCount as OddCount
,'Multiway Ticket' as SlipType
,Customer.SlipSystem.SlipTypeId
,Parameter.SlipState.StatuColor AS SlipStateStatuColor
,case when Customer.SlipSystem.SlipStateId not in (3,7) then 0 else   Customer.SlipSystem.MaxGain end  as MaxGain
, Parameter.Currency.CurrencyId
, Parameter.Currency.Currency
,'Normal' as SlipStatu
,case when DATEDIFF(MINUTE,Customer.SlipSystem.CreateDate,GETDATE())>10 
or (Select COUNT(Live.EventDetail.EventId) from Live.EventDetail with (nolock ) where EventId in (select Customer.SlipOdd.MatchId from Customer.SlipOdd with (nolock) where Customer.SlipOdd.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.SlipOdd.BetTypeId=1) and Live.EventDetail.TimeStatu>1)>0 
or (select Count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where Customer.Slip.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.Slip.SlipStateId in (2,7))>0 then 0 else case when ISNULL(IsTerminalCustomer,0)=1 OR ISNULL(IsBranchCustomer,0)=1 then 1 else 0 end end as IsCancel
, Parameter.Branch.BrancName
,DATEADD(MINUTE,10,dbo.UserTimeZoneDate(@Username,Customer.SlipSystem.CreateDate,0)) as CancelDate
	  ,Customer.SlipSystem.IsPayOut
							  ,case when Customer.SlipSystem.IsPayOut=1 then 0 else case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId=3 then Customer.SlipSystem.MaxGain*cast(1 as float) else 0 end end end as RemainingPayOut
							  ,case when Customer.SlipSystem.IsPayOut=0 or Customer.SlipSystem.IsPayOut is null then 0 else case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain*cast(1 as float) else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else case when Customer.SlipSystem.SlipStateId=2 then Customer.SlipSystem.Amount else Customer.SlipSystem.MaxGain*cast(1 as float)  end end end end as PaidAmount
							  ,cast(1 as bit) as IsBranchCustomer
							  ,case when (Select Count(*) from Customer.Tax with (nolock) where SlipId =Customer.SlipSystem.SystemSlipId and SlipTypeId=3 )>0 Then (Select SUM(TaxAmount) from Customer.Tax where SlipId=Customer.SlipSystem.SystemSlipId and SlipTypeId=3) else 0 end as Tax
							  ,Customer.SlipSystem.EvaluateDate 
,(Select top 1 CreateDate from RiskManagement.BranchTransaction with (nolock) where SlipId=(select Min(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) and TransactionTypeId in (8,12,9)) as PaidDate
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
 Customer.Customer with (nolock) ON Customer.Customer.CustomerId = Customer.SlipSystem.CustomerId INNER JOIN
							  Parameter.Source with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN
							  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  =@UserCurrencyId  INNER JOIN
							  	   Language.[Parameter.SlipState] On Language.[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].LanguageId=6 INNER JOIN 
							  Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
where Customer.SlipSystem.SystemSlipId = (select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)
and 		(Customer.Customer.BranchId in  (select BranchId from Parameter.Branch where ParentBranchId in   (select distinct BranchId from Parameter.Branch with (nolock) where (BranchId=@BranchId or ParentBranchId=@BranchId or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId or ParentBranchId=@BranchId) )))) or Customer.Customer.BranchId=@BranchId)
--GROUP BY Customer.SlipSystem.SystemSlipId, Customer.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
--							  Customer.SlipSystem.Amount, Customer.SlipSystem.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipSystem.CreateDate, Parameter.Source.SourceId, 
--							  Parameter.Source.Source, Customer.SlipSystem.SlipTypeId, Customer.SlipSystem.SourceId, 
--							  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.Branch.BrancName,Customer.SlipSystem.SlipStateId,Customer.SlipSystem.EventCount,Customer.SlipSystem.[System]
--							  ,Customer.SlipSystem.MaxGain,Customer.Customer.CurrencyId  ,Customer.SlipSystem.IsPayOut,Customer.Customer.IsBranchCustomer,Language.[Parameter.SlipState].SlipState
				end
			else
				begin
					select (select Min(SlipId) from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
, Customer.SlipSystem.CustomerId, 
Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName
, Customer.SlipSystem.Amount as Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Language.[Parameter.SlipState].SlipState as State
,Customer.SlipSystem.CreateDate
, Parameter.Source.SourceId
,Parameter.Source.Source
,Customer.SlipSystem.EventCount as OddCount
,'Multiway Ticket' as SlipType
,Customer.SlipSystem.SlipTypeId
,Parameter.SlipState.StatuColor AS SlipStateStatuColor
,case when Customer.SlipSystem.SlipStateId not in (3,7) then 0 else   Customer.SlipSystem.MaxGain end  as MaxGain
, Parameter.Currency.CurrencyId
, Parameter.Currency.Currency
,'Normal' as SlipStatu
,case when DATEDIFF(MINUTE,Customer.SlipSystem.CreateDate,GETDATE())>10 
or (select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where Customer.SlipOdd.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.SlipOdd.BetTypeId=1)>0 
or (select Count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where Customer.Slip.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.Slip.SlipStateId in (2,7))>0 then 0 else 1 end as IsCancel
, Parameter.Branch.BrancName
,DATEADD(MINUTE,10,dbo.UserTimeZoneDate(@Username,Customer.SlipSystem.CreateDate,0)) as CancelDate
	  ,Customer.SlipSystem.IsPayOut
							  ,case when Customer.SlipSystem.IsPayOut=1 then 0 else case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId=3 then Customer.SlipSystem.MaxGain*cast(1 as float) else 0 end end end as RemainingPayOut
							  ,case when Customer.SlipSystem.IsPayOut=0 or Customer.SlipSystem.IsPayOut is null then 0 else case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain*cast(1 as float) else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else case when Customer.SlipSystem.SlipStateId=2 then Customer.SlipSystem.Amount else Customer.SlipSystem.MaxGain*cast(1 as float)  end end end end as PaidAmount
							  ,cast(1 as bit) as IsBranchCustomer
							  ,case when (Select Count(*) from Customer.Tax with (nolock) where SlipId =Customer.SlipSystem.SystemSlipId and SlipTypeId=3 )>0 Then (Select SUM(TaxAmount) from Customer.Tax where SlipId=Customer.SlipSystem.SystemSlipId and SlipTypeId=3) else 0 end as Tax
							  ,Customer.SlipSystem.EvaluateDate 
,(Select top 1 CreateDate from RiskManagement.BranchTransaction with (nolock) where SlipId=(select Min(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) and TransactionTypeId in (8,12)) as PaidDate
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
 Customer.Customer with (nolock) ON Customer.Customer.CustomerId = Customer.SlipSystem.CustomerId INNER JOIN
							  Parameter.Source with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN
							  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  =@UserCurrencyId  INNER JOIN
							  	   Language.[Parameter.SlipState] On Language.[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].LanguageId=6 INNER JOIN 
							  Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
where Customer.SlipSystem.SystemSlipId = (select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)
				end
		end
	end
else if exists (select Archive.Slip.SlipId from Archive.Slip with (nolock) where Archive.Slip.SlipId=@SlipId)
	begin
	if(select count(Archive.Slip.SlipId) from Archive.Slip with (nolock) where Archive.Slip.SlipId=@SlipId and Archive.Slip.SlipTypeId<3)>0
		begin
		select  Archive.Slip.SlipId, Archive.Slip.CustomerId, 
							  Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName, 
							  Archive.Slip.Amount as Amount, Archive.Slip.TotalOddValue, Parameter.SlipState.StateId, Language.[Parameter.SlipState].SlipState as State
							  , Archive.Slip.CreateDate as CreateDate, Parameter.Source.SourceId, 
							  Parameter.Source.Source, Archive.Slip.EventCount AS OddCount, Parameter.SlipType.SlipType, Archive.Slip.SlipTypeId, 
							  Parameter.SlipState.StatuColor AS SlipStateStatuColor
							 ,case when Archive.Slip.SlipStateId in (3) and Archive.Slip.TotalOddValue>1 then  cast(Archive.Slip.TotalOddValue * Archive.Slip.Amount as money) else case when Archive.Slip.SlipStateId in (2) OR Archive.Slip.TotalOddValue=1 then  Archive.Slip.Amount+ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock) where SlipId=Archive.Slip.SlipId),0) else case when Archive.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashout.SlipId=@SlipId) else 0 end end end AS MaxGain
							  , Parameter.Currency.CurrencyId, 
							  Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,0 as IsCancel, Parameter.Branch.BrancName,GETDATE() as CancelDate
							   ,Archive.Slip.IsPayOut
							  ,case when Archive.Slip.IsPayOut=1 then 0 else case when Archive.Slip.SlipStateId in (3)  and Archive.Slip.TotalOddValue>1 then Archive.Slip.Amount*Archive.Slip.TotalOddValue  else case when Archive.Slip.SlipStateId in (2) OR Archive.Slip.TotalOddValue=1 then Archive.Slip.Amount+ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock) where SlipId=Archive.Slip.SlipId),0) else 0 end end end as RemainingPayOut
							  ,case when Archive.Slip.IsPayOut=0 or Archive.Slip.IsPayOut is null  then 0 else case when Archive.Slip.SlipStateId in (3) and Archive.Slip.TotalOddValue>1 then Archive.Slip.Amount*Archive.Slip.TotalOddValue else case when Archive.Slip.SlipStateId in (2) OR Archive.Slip.TotalOddValue=1 then Archive.Slip.Amount+ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock) where SlipId=Archive.Slip.SlipId),0)  else 0 end end end as PaidAmount
							  ,cast(1 as bit) as IsBranchCustomer,
							  case when (Select Count(*) from Customer.Tax with (nolock) where SlipId=Archive.Slip.SlipId)>0 Then (Select Customer.Tax.TaxAmount from Customer.Tax with (nolock) where SlipId=Archive.Slip.SlipId) else 0 end as Tax
							  	,Archive.Slip.EvaluateDate
		 ,(Select top 1 CreateDate from RiskManagement.BranchTransaction with (nolock) where SlipId=Archive.Slip.SlipId and TransactionTypeId in (8,12)) as PaidDate
		FROM         Customer.Customer with (nolock) INNER JOIN
							  Archive.Slip with (nolock) ON Customer.Customer.CustomerId = Archive.Slip.CustomerId INNER JOIN
							  Parameter.SlipState with (nolock) ON Archive.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN
							  Parameter.Source with (nolock) ON Archive.Slip.SourceId = Parameter.Source.SourceId INNER JOIN
							  Parameter.SlipType with (nolock) ON Archive.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN
							  Parameter.SlipStatu with (nolock) ON Archive.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN
							  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  = @UserCurrencyId INNER JOIN
							  Language.[Parameter.SlipState] On Language.[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].LanguageId=6 INNER JOIN 
							  	  Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
		WHERE Archive.Slip.SlipId=@SlipId
		and 		(Customer.Customer.BranchId in  (select BranchId from Parameter.Branch with (nolock) where ParentBranchId in   (select distinct BranchId from Parameter.Branch with (nolock) where (BranchId=@BranchId or ParentBranchId=@BranchId or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId or ParentBranchId=@BranchId) )))) or Customer.Customer.BranchId=@BranchId)
		--GROUP BY Archive.Slip.SlipId, Archive.Slip.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
		--					  Archive.Slip.Amount, Archive.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Archive.Slip.CreateDate, Parameter.Source.SourceId, 
		--					  Parameter.Source.Source, Archive.Slip.SlipTypeId, Archive.Slip.SourceId, Parameter.SlipType.SlipType, 
		--					  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,Customer.Customer.CurrencyId    ,Parameter.Branch.BrancName      ,Archive.Slip.IsPayOut 
		--					  ,Archive.Slip.SlipStateId,Customer.Customer.IsBranchCustomer     ,Language.[Parameter.SlipState].SlipState 
		end
		else  if(select count(Archive.Slip.SlipId) from Archive.Slip with (nolock) where Archive.Slip.SlipId=@SlipId and Archive.Slip.SlipTypeId=3)>0
		begin
			select (select Min(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
, Customer.SlipSystem.CustomerId, 
Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName
, Customer.SlipSystem.Amount as Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Language.[Parameter.SlipState].SlipState as State
,Customer.SlipSystem.CreateDate
, Parameter.Source.SourceId
,Parameter.Source.Source
,Customer.SlipSystem.EventCount as OddCount
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else Customer.SlipSystem.[System] end as SlipType
,Customer.SlipSystem.SlipTypeId
,Parameter.SlipState.StatuColor AS SlipStateStatuColor
,Customer.SlipSystem.MaxGain  as MaxGain
, Parameter.Currency.CurrencyId
, Parameter.Currency.Currency
,'Normal' as SlipStatu
,case when DATEDIFF(MINUTE,Customer.SlipSystem.CreateDate,GETDATE())>10 or (select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where Customer.SlipOdd.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.SlipOdd.BetTypeId=1)>0 or (select Count(Archive.Slip.SlipId) from Archive.Slip with (nolock) where Archive.Slip.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Archive.Slip.SlipStateId=2)>0 then 0 else 1 end as IsCancel
, Parameter.Branch.BrancName
,DATEADD(MINUTE,10,dbo.UserTimeZoneDate(@Username,Customer.SlipSystem.CreateDate,0)) as CancelDate
	  ,Customer.SlipSystem.IsPayOut
							  ,case when Customer.SlipSystem.IsPayOut=1 then 0 else case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId=3 then ISNULL((Select cast(SUM(Archive.Slip.TotalOddValue * Archive.Slip.Amount) as money) from Archive.Slip with (nolock) where Archive.Slip.SlipStateId in (3,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) else 0 end end end as RemainingPayOut
							  ,case when Customer.SlipSystem.IsPayOut=0 or Customer.SlipSystem.IsPayOut is null then 0 else case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else case when Customer.SlipSystem.SlipStateId=2 then Customer.SlipSystem.Amount else ISNULL((Select cast(SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) as money) from Customer.Slip with (nolock) where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)+ISNULL((Select cast(SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) as money) from Archive.Slip with (nolock) where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)  end end end end as PaidAmount
							  ,cast(1 as bit) as IsBranchCustomer
							  ,case when (Select Count(*) from Customer.Tax with (nolock) where SlipId =Customer.SlipSystem.SystemSlipId and SlipTypeId=3 )>0 Then (Select SUM(TaxAmount) from Customer.Tax with (nolock) where SlipId=Customer.SlipSystem.SystemSlipId and SlipTypeId=3) else 0 end as Tax
							  ,Customer.SlipSystem.EvaluateDate 
,(Select top 1 CreateDate from RiskManagement.BranchTransaction with (nolock) where SlipId=(select Min(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) and TransactionTypeId in (8,12)) as PaidDate
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
 Customer.Customer with (nolock) ON Customer.Customer.CustomerId = Customer.SlipSystem.CustomerId INNER JOIN
							  Parameter.Source with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN
							  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  =@UserCurrencyId  INNER JOIN
							  Language.[Parameter.SlipState] On Language.[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].LanguageId=6 INNER JOIN 
							  Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
where Customer.SlipSystem.SystemSlipId = (select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)
and 		(Customer.Customer.BranchId in  (select BranchId from Parameter.Branch where ParentBranchId in   (select distinct BranchId from Parameter.Branch with (nolock) where (BranchId=@BranchId or ParentBranchId=@BranchId or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId or ParentBranchId=@BranchId) )))) or Customer.Customer.BranchId=@BranchId)
--GROUP BY Customer.SlipSystem.SystemSlipId, Customer.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
--							  Customer.SlipSystem.Amount, Customer.SlipSystem.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipSystem.CreateDate, Parameter.Source.SourceId, 
--							  Parameter.Source.Source, Customer.SlipSystem.SlipTypeId, Customer.SlipSystem.SourceId, 
--							  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.Branch.BrancName,Customer.SlipSystem.SlipStateId,Customer.SlipSystem.EventCount,Customer.SlipSystem.[System]
--							  ,Customer.SlipSystem.MaxGain,Customer.Customer.CurrencyId  ,Customer.SlipSystem.IsPayOut,Customer.Customer.IsBranchCustomer,Language.[Parameter.SlipState].SlipState
		end 
			else if(select count(Archive.Slip.SlipId) from Archive.Slip with (nolock) where Archive.Slip.SlipId=@SlipId and Archive.Slip.SlipTypeId=4)>0
		begin
			select (select Min(SlipId) from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
, Customer.SlipSystem.CustomerId, 
Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName
, Customer.SlipSystem.Amount as Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Language.[Parameter.SlipState].SlipState as State
,Customer.SlipSystem.CreateDate
, Parameter.Source.SourceId
,Parameter.Source.Source
,Customer.SlipSystem.EventCount as OddCount
,  SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System'  as SlipType
,Customer.SlipSystem.SlipTypeId
,Parameter.SlipState.StatuColor AS SlipStateStatuColor
,case when Customer.SlipSystem.SlipStateId not in (3,7) then 0 else   Customer.SlipSystem.MaxGain end  as MaxGain
, Parameter.Currency.CurrencyId
, Parameter.Currency.Currency
,'Normal' as SlipStatu
,case when DATEDIFF(MINUTE,Customer.SlipSystem.CreateDate,GETDATE())>10 or (select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where Customer.SlipOdd.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.SlipOdd.BetTypeId=1)>0 or (select Count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where Customer.Slip.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.Slip.SlipStateId in (2,7))>0 then 0 else 1 end as IsCancel
, Parameter.Branch.BrancName
,DATEADD(MINUTE,10,dbo.UserTimeZoneDate(@Username,Customer.SlipSystem.CreateDate,0)) as CancelDate
	  ,Customer.SlipSystem.IsPayOut
							  ,case when Customer.SlipSystem.IsPayOut=1 then 0 else case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId=3 then  Customer.SlipSystem.MaxGain*cast(1 as float) else 0 end end end as RemainingPayOut
							  ,case when Customer.SlipSystem.IsPayOut=0 or Customer.SlipSystem.IsPayOut is null then 0 else case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else case when Customer.SlipSystem.SlipStateId=2 then Customer.SlipSystem.Amount else Customer.SlipSystem.MaxGain*cast(1 as float) end end end end as PaidAmount
							  ,cast(1 as bit) as IsBranchCustomer
							  ,case when (Select Count(*) from Customer.Tax where SlipId =Customer.SlipSystem.SystemSlipId and SlipTypeId=3 )>0 Then (Select SUM(TaxAmount) from Customer.Tax where SlipId=Customer.SlipSystem.SystemSlipId and SlipTypeId=3) else 0 end as Tax
							  ,Customer.SlipSystem.EvaluateDate 
,(Select top 1 CreateDate from RiskManagement.BranchTransaction with (nolock) where SlipId=(select Min(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) and TransactionTypeId in (8,12,9)) as PaidDate
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
 Customer.Customer with (nolock) ON Customer.Customer.CustomerId = Customer.SlipSystem.CustomerId INNER JOIN
							  Parameter.Source with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN
							  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  =@UserCurrencyId  INNER JOIN
							  	   Language.[Parameter.SlipState] On Language.[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].LanguageId=6 INNER JOIN 
							  Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
where Customer.SlipSystem.SystemSlipId = (select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)
and 		(Customer.Customer.BranchId in  (select BranchId from Parameter.Branch where ParentBranchId in   (select distinct BranchId from Parameter.Branch with (nolock) where (BranchId=@BranchId or ParentBranchId=@BranchId or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId or ParentBranchId=@BranchId) )))) or Customer.Customer.BranchId=@BranchId)
--GROUP BY Customer.SlipSystem.SystemSlipId, Customer.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
--							  Customer.SlipSystem.Amount, Customer.SlipSystem.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipSystem.CreateDate, Parameter.Source.SourceId, 
--							  Parameter.Source.Source, Customer.SlipSystem.SlipTypeId, Customer.SlipSystem.SourceId, 
--							  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.Branch.BrancName,Customer.SlipSystem.SlipStateId,Customer.SlipSystem.EventCount,Customer.SlipSystem.[System]
--							  ,Customer.SlipSystem.MaxGain,Customer.Customer.CurrencyId  ,Customer.SlipSystem.IsPayOut,Customer.Customer.IsBranchCustomer,Language.[Parameter.SlipState].SlipState

		end
			else if(select count(Archive.Slip.SlipId) from Archive.Slip with (nolock) where Archive.Slip.SlipId=@SlipId and Archive.Slip.SlipTypeId=5)>0
		begin
			select (select Min(SlipId) from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
, Customer.SlipSystem.CustomerId, 
Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName
, Customer.SlipSystem.Amount as Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Language.[Parameter.SlipState].SlipState as State
,Customer.SlipSystem.CreateDate
, Parameter.Source.SourceId
,Parameter.Source.Source
,Customer.SlipSystem.EventCount as OddCount
,'Multiway Ticket' as SlipType
,Customer.SlipSystem.SlipTypeId
,Parameter.SlipState.StatuColor AS SlipStateStatuColor
,case when Customer.SlipSystem.SlipStateId not in (3,7) then 0 else   Customer.SlipSystem.MaxGain end  as MaxGain
, Parameter.Currency.CurrencyId
, Parameter.Currency.Currency
,'Normal' as SlipStatu
,case when DATEDIFF(MINUTE,Customer.SlipSystem.CreateDate,GETDATE())>10 or (select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where Customer.SlipOdd.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.SlipOdd.BetTypeId=1)>0 or (select Count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where Customer.Slip.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId) and Customer.Slip.SlipStateId in (2,7))>0 then 0 else 1 end as IsCancel
, Parameter.Branch.BrancName
,DATEADD(MINUTE,10,dbo.UserTimeZoneDate(@Username,Customer.SlipSystem.CreateDate,0)) as CancelDate
	  ,Customer.SlipSystem.IsPayOut
							  ,case when Customer.SlipSystem.IsPayOut=1 then 0 else case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId=3 then Customer.SlipSystem.MaxGain*cast(1 as float) else 0 end end end as RemainingPayOut
							  ,case when Customer.SlipSystem.IsPayOut=0 or Customer.SlipSystem.IsPayOut is null then 0 else case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain*cast(1 as float) else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else case when Customer.SlipSystem.SlipStateId=2 then Customer.SlipSystem.Amount else Customer.SlipSystem.MaxGain*cast(1 as float) end end end end as PaidAmount
							  ,cast(1 as bit) as IsBranchCustomer
							  ,case when (Select Count(*) from Customer.Tax where SlipId =Customer.SlipSystem.SystemSlipId and SlipTypeId=3 )>0 Then (Select SUM(TaxAmount) from Customer.Tax where SlipId=Customer.SlipSystem.SystemSlipId and SlipTypeId=3) else 0 end as Tax
							  ,Customer.SlipSystem.EvaluateDate 
,(Select top 1 CreateDate from RiskManagement.BranchTransaction with (nolock) where SlipId=(select Min(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) and TransactionTypeId in (8,12,9)) as PaidDate
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
 Customer.Customer with (nolock) ON Customer.Customer.CustomerId = Customer.SlipSystem.CustomerId INNER JOIN
							  Parameter.Source with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN
							  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  =@UserCurrencyId  INNER JOIN
							  	   Language.[Parameter.SlipState] On Language.[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].LanguageId=6 INNER JOIN 
							  Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
where Customer.SlipSystem.SystemSlipId = (select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)
and 		(Customer.Customer.BranchId in  (select BranchId from Parameter.Branch where ParentBranchId in   (select distinct BranchId from Parameter.Branch with (nolock) where (BranchId=@BranchId or ParentBranchId=@BranchId or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId or ParentBranchId=@BranchId) )))) or Customer.Customer.BranchId=@BranchId)
--GROUP BY Customer.SlipSystem.SystemSlipId, Customer.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
--							  Customer.SlipSystem.Amount, Customer.SlipSystem.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipSystem.CreateDate, Parameter.Source.SourceId, 
--							  Parameter.Source.Source, Customer.SlipSystem.SlipTypeId, Customer.SlipSystem.SourceId, 
--							  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.Branch.BrancName,Customer.SlipSystem.SlipStateId,Customer.SlipSystem.EventCount,Customer.SlipSystem.[System]
--							  ,Customer.SlipSystem.MaxGain,Customer.Customer.CurrencyId  ,Customer.SlipSystem.IsPayOut,Customer.Customer.IsBranchCustomer,Language.[Parameter.SlipState].SlipState

		end
	end
else  if exists (select Archive.SlipOld.SlipId from Archive.SlipOld with (nolock) where Archive.SlipOld.SlipId=@SlipId)
	begin
	if(select count(Archive.SlipOld.SlipId) from Archive.SlipOld with (nolock) where Archive.SlipOld.SlipId=@SlipId and Archive.SlipOld.SlipTypeId<3)>0
		begin
		select  Archive.SlipOld.SlipId, Archive.SlipOld.CustomerId, 
							  Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName, 
							  Archive.SlipOld.Amount as Amount, Archive.SlipOld.TotalOddValue, Parameter.SlipState.StateId, Language.[Parameter.SlipState].SlipState as State
							  , Archive.SlipOld.CreateDate as CreateDate, Parameter.Source.SourceId, 
							  Parameter.Source.Source, Archive.SlipOld.EventCount AS OddCount, Parameter.SlipType.SlipType, Archive.SlipOld.SlipTypeId, 
							  Parameter.SlipState.StatuColor AS SlipStateStatuColor
							 ,case when Archive.SlipOld.SlipStateId in (3) and Archive.SlipOld.TotalOddValue>1 then  cast(Archive.SlipOld.TotalOddValue * Archive.SlipOld.Amount as money) else case when Archive.SlipOld.SlipStateId in (2) OR Archive.SlipOld.TotalOddValue=1 then  Archive.SlipOld.Amount+ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock) where SlipId=Archive.SlipOld.SlipId),0) else case when Archive.SlipOld.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashout.SlipId=@SlipId) else 0 end end end AS MaxGain
							  , Parameter.Currency.CurrencyId, 
							  Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,0 as IsCancel, Parameter.Branch.BrancName,GETDATE() as CancelDate
							   ,Archive.SlipOld.IsPayOut
							  ,case when Archive.SlipOld.IsPayOut=1 then 0 else case when Archive.SlipOld.SlipStateId in (3)  and Archive.SlipOld.TotalOddValue>1 then Archive.SlipOld.Amount*Archive.SlipOld.TotalOddValue  else case when Archive.SlipOld.SlipStateId in (2) OR Archive.SlipOld.TotalOddValue=1 then Archive.SlipOld.Amount+ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock) where SlipId=Archive.SlipOld.SlipId),0) else 0 end end end as RemainingPayOut
							  ,case when Archive.SlipOld.IsPayOut=0 or Archive.SlipOld.IsPayOut is null  then 0 else case when Archive.SlipOld.SlipStateId in (3) and Archive.SlipOld.TotalOddValue>1 then Archive.SlipOld.Amount*Archive.SlipOld.TotalOddValue else case when Archive.SlipOld.SlipStateId in (2) OR Archive.SlipOld.TotalOddValue=1 then Archive.SlipOld.Amount+ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock) where SlipId=Archive.SlipOld.SlipId),0)  else 0 end end end as PaidAmount
							  ,cast(1 as bit) as IsBranchCustomer,
							  case when (Select Count(*) from Customer.Tax with (nolock) where SlipId=Archive.SlipOld.SlipId)>0 Then (Select Customer.Tax.TaxAmount from Customer.Tax with (nolock) where SlipId=Archive.SlipOld.SlipId) else 0 end as Tax
							  	,Archive.SlipOld.EvaluateDate
		 ,(Select top 1 CreateDate from RiskManagement.BranchTransaction with (nolock) where SlipId=Archive.SlipOld.SlipId and TransactionTypeId in (8,12)) as PaidDate
		FROM         Customer.Customer with (nolock) INNER JOIN
							  Archive.SlipOld with (nolock) ON Customer.Customer.CustomerId = Archive.SlipOld.CustomerId INNER JOIN
							  Parameter.SlipState with (nolock) ON Archive.SlipOld.SlipStateId = Parameter.SlipState.StateId INNER JOIN
							  Parameter.Source with (nolock) ON Archive.SlipOld.SourceId = Parameter.Source.SourceId INNER JOIN
							  Parameter.SlipType with (nolock) ON Archive.SlipOld.SlipTypeId = Parameter.SlipType.Id INNER JOIN
							  Parameter.SlipStatu with (nolock) ON Archive.SlipOld.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN
							  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  = @UserCurrencyId INNER JOIN
							  Language.[Parameter.SlipState] On Language.[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].LanguageId=6 INNER JOIN 
							  	  Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
		WHERE Archive.SlipOld.SlipId=@SlipId
		and 		(Customer.Customer.BranchId in  (select BranchId from Parameter.Branch with (nolock) where ParentBranchId in   (select distinct BranchId from Parameter.Branch with (nolock) where (BranchId=@BranchId or ParentBranchId=@BranchId or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId or ParentBranchId=@BranchId) )))) or Customer.Customer.BranchId=@BranchId)
		--GROUP BY Archive.SlipOld.SlipId, Archive.SlipOld.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
		--					  Archive.SlipOld.Amount, Archive.SlipOld.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Archive.SlipOld.CreateDate, Parameter.Source.SourceId, 
		--					  Parameter.Source.Source, Archive.SlipOld.SlipTypeId, Archive.SlipOld.SourceId, Parameter.SlipType.SlipType, 
		--					  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,Customer.Customer.CurrencyId    ,Parameter.Branch.BrancName      ,Archive.SlipOld.IsPayOut 
		--					  ,Archive.SlipOld.SlipStateId,Customer.Customer.IsBranchCustomer     ,Language.[Parameter.SlipState].SlipState 
		end
		else  if(select count(Archive.SlipOld.SlipId) from Archive.SlipOld with (nolock) where Archive.SlipOld.SlipId=@SlipId and Archive.SlipOld.SlipTypeId=3)>0
		begin
			select (select Min(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Archive.SlipSystem.SystemSlipId) as SlipId
, Archive.SlipSystem.CustomerId, 
Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName
, Archive.SlipSystem.Amount as Amount
,Archive.SlipSystem.TotalOddValue  as TotalOddValue
,Archive.SlipSystem.SlipStateId as StateId
,Language.[Parameter.SlipState].SlipState as State
,Archive.SlipSystem.CreateDate
, Parameter.Source.SourceId
,Parameter.Source.Source
,Archive.SlipSystem.EventCount as OddCount
,case when CHARINDEX('Multi',Archive.SlipSystem.[System]) = 0  then SUBSTRING(Archive.SlipSystem.[System],0,LEN(Archive.SlipSystem.[System]))+' System' else Archive.SlipSystem.[System] end as SlipType
,Archive.SlipSystem.SlipTypeId
,Parameter.SlipState.StatuColor AS SlipStateStatuColor
,Archive.SlipSystem.MaxGain  as MaxGain
, Parameter.Currency.CurrencyId
, Parameter.Currency.Currency
,'Normal' as SlipStatu
,case when DATEDIFF(MINUTE,Archive.SlipSystem.CreateDate,GETDATE())>10 or (select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where Customer.SlipOdd.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Archive.SlipSystem.SystemSlipId) and Customer.SlipOdd.BetTypeId=1)>0 or (select Count(Archive.SlipOld.SlipId) from Archive.SlipOld with (nolock) where Archive.SlipOld.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Archive.SlipSystem.SystemSlipId) and Archive.SlipOld.SlipStateId=2)>0 then 0 else 1 end as IsCancel
, Parameter.Branch.BrancName
,DATEADD(MINUTE,10,dbo.UserTimeZoneDate(@Username,Archive.SlipSystem.CreateDate,0)) as CancelDate
	  ,Archive.SlipSystem.IsPayOut
							  ,case when Archive.SlipSystem.IsPayOut=1 then 0 else case when Archive.SlipSystem.SlipStateId in (1) then 0 else case when Archive.SlipSystem.SlipStateId=3 then ISNULL((Select cast(SUM(Archive.SlipOld.TotalOddValue * Archive.SlipOld.Amount) as money) from Archive.SlipOld with (nolock) where Archive.SlipOld.SlipStateId in (3,6) and Archive.SlipOld.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Archive.SlipSystem.SystemSlipId) ),0) else 0 end end end as RemainingPayOut
							  ,case when Archive.SlipSystem.IsPayOut=0 or Archive.SlipSystem.IsPayOut is null then 0 else case when Archive.SlipSystem.SlipStateId in (1) then Archive.SlipSystem.MaxGain else case when Archive.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Archive.SlipSystem.SystemSlipId)) else ISNULL((Select cast(SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) as money) from Customer.Slip with (nolock) where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Archive.SlipSystem.SystemSlipId)),0)+ISNULL((Select cast(SUM(Archive.SlipOld.TotalOddValue*Archive.SlipOld.Amount) as money) from Archive.SlipOld with (nolock) where Archive.SlipOld.SlipStateId in (3,2,6) and Archive.SlipOld.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Archive.SlipSystem.SystemSlipId)),0)  end end end as PaidAmount
							  ,cast(1 as bit) as IsBranchCustomer
							  ,case when (Select Count(*) from Customer.Tax with (nolock) where SlipId =Archive.SlipSystem.SystemSlipId and SlipTypeId=3 )>0 Then (Select SUM(TaxAmount) from Customer.Tax with (nolock) where SlipId=Archive.SlipSystem.SystemSlipId and SlipTypeId=3) else 0 end as Tax
							  ,Archive.SlipSystem.EvaluateDate 
,(Select top 1 CreateDate from RiskManagement.BranchTransaction with (nolock) where SlipId=(select Min(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Archive.SlipSystem.SystemSlipId) and TransactionTypeId in (8,12)) as PaidDate
from Archive.SlipSystem with (nolock) INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Archive.SlipSystem.SlipStateId INNER JOIN
 Customer.Customer with (nolock) ON Customer.Customer.CustomerId = Archive.SlipSystem.CustomerId INNER JOIN
							  Parameter.Source with (nolock) ON Archive.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN
							  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  =@UserCurrencyId  INNER JOIN
							  Language.[Parameter.SlipState] On Language.[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].LanguageId=6 INNER JOIN 
							  Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
where Archive.SlipSystem.SystemSlipId = (select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)
and 		(Customer.Customer.BranchId in  (select BranchId from Parameter.Branch where ParentBranchId in   (select distinct BranchId from Parameter.Branch with (nolock) where (BranchId=@BranchId or ParentBranchId=@BranchId or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId or ParentBranchId=@BranchId) )))) or Customer.Customer.BranchId=@BranchId)
--GROUP BY Archive.SlipSystem.SystemSlipId, Archive.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
--							  Archive.SlipSystem.Amount, Archive.SlipSystem.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Archive.SlipSystem.CreateDate, Parameter.Source.SourceId, 
--							  Parameter.Source.Source, Archive.SlipSystem.SlipTypeId, Archive.SlipSystem.SourceId, 
--							  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.Branch.BrancName,Archive.SlipSystem.SlipStateId,Archive.SlipSystem.EventCount,Archive.SlipSystem.[System]
--							  ,Archive.SlipSystem.MaxGain,Customer.Customer.CurrencyId  ,Archive.SlipSystem.IsPayOut,Customer.Customer.IsBranchCustomer,Language.[Parameter.SlipState].SlipState
		end 
			else if(select count(Archive.SlipOld.SlipId) from Archive.SlipOld with (nolock) where Archive.SlipOld.SlipId=@SlipId and Archive.SlipOld.SlipTypeId=4)>0
		begin
			select (select Min(SlipId) from Archive.SlipSystemSlip where Archive.SlipSystemSlip.SystemSlipId=Archive.SlipSystem.SystemSlipId) as SlipId
, Archive.SlipSystem.CustomerId, 
Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName
, Archive.SlipSystem.Amount as Amount
,Archive.SlipSystem.TotalOddValue  as TotalOddValue
,Archive.SlipSystem.SlipStateId as StateId
,Language.[Parameter.SlipState].SlipState as State
,Archive.SlipSystem.CreateDate
, Parameter.Source.SourceId
,Parameter.Source.Source
,Archive.SlipSystem.EventCount as OddCount
,  SUBSTRING(Archive.SlipSystem.[System],0,LEN(Archive.SlipSystem.[System]))+' System'  as SlipType
,Archive.SlipSystem.SlipTypeId
,Parameter.SlipState.StatuColor AS SlipStateStatuColor
,case when Archive.SlipSystem.SlipStateId not in (3,7) then 0 else   Archive.SlipSystem.MaxGain end  as MaxGain
, Parameter.Currency.CurrencyId
, Parameter.Currency.Currency
,'Normal' as SlipStatu
,case when DATEDIFF(MINUTE,Archive.SlipSystem.CreateDate,GETDATE())>10 or (select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where Customer.SlipOdd.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Archive.SlipSystem.SystemSlipId) and Customer.SlipOdd.BetTypeId=1)>0 or (select Count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where Customer.Slip.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Archive.SlipSystem.SystemSlipId) and Customer.Slip.SlipStateId in (2,7))>0 then 0 else 1 end as IsCancel
, Parameter.Branch.BrancName
,DATEADD(MINUTE,10,dbo.UserTimeZoneDate(@Username,Archive.SlipSystem.CreateDate,0)) as CancelDate
	  ,Archive.SlipSystem.IsPayOut
							  ,case when Archive.SlipSystem.IsPayOut=1 then 0 else case when Archive.SlipSystem.SlipStateId in (1) then 0 else case when Archive.SlipSystem.SlipStateId=3 then  Archive.SlipSystem.MaxGain*cast(1 as float) else 0 end end end as RemainingPayOut
							  ,case when Archive.SlipSystem.IsPayOut=0 or Archive.SlipSystem.IsPayOut is null then 0 else case when Archive.SlipSystem.SlipStateId in (1) then Archive.SlipSystem.MaxGain else case when Archive.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Archive.SlipSystem.SystemSlipId)) else Archive.SlipSystem.MaxGain*cast(1 as float) end end end as PaidAmount
							  ,cast(1 as bit) as IsBranchCustomer
							  ,case when (Select Count(*) from Customer.Tax where SlipId =Archive.SlipSystem.SystemSlipId and SlipTypeId=3 )>0 Then (Select SUM(TaxAmount) from Customer.Tax where SlipId=Archive.SlipSystem.SystemSlipId and SlipTypeId=3) else 0 end as Tax
							  ,Archive.SlipSystem.EvaluateDate 
,(Select top 1 CreateDate from RiskManagement.BranchTransaction with (nolock) where SlipId=(select Min(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Archive.SlipSystem.SystemSlipId) and TransactionTypeId in (8,12)) as PaidDate
from Archive.SlipSystem with (nolock) INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Archive.SlipSystem.SlipStateId INNER JOIN
 Customer.Customer with (nolock) ON Customer.Customer.CustomerId = Archive.SlipSystem.CustomerId INNER JOIN
							  Parameter.Source with (nolock) ON Archive.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN
							  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  =@UserCurrencyId  INNER JOIN
							  	   Language.[Parameter.SlipState] On Language.[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].LanguageId=6 INNER JOIN 
							  Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
where Archive.SlipSystem.SystemSlipId = (select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)
and 		(Customer.Customer.BranchId in  (select BranchId from Parameter.Branch where ParentBranchId in   (select distinct BranchId from Parameter.Branch with (nolock) where (BranchId=@BranchId or ParentBranchId=@BranchId or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId or ParentBranchId=@BranchId) )))) or Customer.Customer.BranchId=@BranchId)
--GROUP BY Archive.SlipSystem.SystemSlipId, Archive.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
--							  Archive.SlipSystem.Amount, Archive.SlipSystem.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Archive.SlipSystem.CreateDate, Parameter.Source.SourceId, 
--							  Parameter.Source.Source, Archive.SlipSystem.SlipTypeId, Archive.SlipSystem.SourceId, 
--							  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.Branch.BrancName,Archive.SlipSystem.SlipStateId,Archive.SlipSystem.EventCount,Archive.SlipSystem.[System]
--							  ,Archive.SlipSystem.MaxGain,Customer.Customer.CurrencyId  ,Archive.SlipSystem.IsPayOut,Customer.Customer.IsBranchCustomer,Language.[Parameter.SlipState].SlipState

		end
			else if(select count(Archive.SlipOld.SlipId) from Archive.SlipOld with (nolock) where Archive.SlipOld.SlipId=@SlipId and Archive.SlipOld.SlipTypeId=5)>0
		begin
			select (select Min(SlipId) from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Archive.SlipSystem.SystemSlipId) as SlipId
, Archive.SlipSystem.CustomerId, 
Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName
, Archive.SlipSystem.Amount as Amount
,Archive.SlipSystem.TotalOddValue  as TotalOddValue
,Archive.SlipSystem.SlipStateId as StateId
,Language.[Parameter.SlipState].SlipState as State
,Archive.SlipSystem.CreateDate
, Parameter.Source.SourceId
,Parameter.Source.Source
,Archive.SlipSystem.EventCount as OddCount
,'Multiway Ticket' as SlipType
,Archive.SlipSystem.SlipTypeId
,Parameter.SlipState.StatuColor AS SlipStateStatuColor
,case when Archive.SlipSystem.SlipStateId not in (3,7) then 0 else   Archive.SlipSystem.MaxGain end  as MaxGain
, Parameter.Currency.CurrencyId
, Parameter.Currency.Currency
,'Normal' as SlipStatu
,case when DATEDIFF(MINUTE,Archive.SlipSystem.CreateDate,GETDATE())>10 or (select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where Customer.SlipOdd.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Archive.SlipSystem.SystemSlipId) and Customer.SlipOdd.BetTypeId=1)>0 or (select Count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where Customer.Slip.SlipId in (select CS.SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Archive.SlipSystem.SystemSlipId) and Customer.Slip.SlipStateId in (2,7))>0 then 0 else 1 end as IsCancel
, Parameter.Branch.BrancName
,DATEADD(MINUTE,10,dbo.UserTimeZoneDate(@Username,Archive.SlipSystem.CreateDate,0)) as CancelDate
	  ,Archive.SlipSystem.IsPayOut
							  ,case when Archive.SlipSystem.IsPayOut=1 then 0 else case when Archive.SlipSystem.SlipStateId in (1) then 0 else case when Archive.SlipSystem.SlipStateId=3 then Archive.SlipSystem.MaxGain*cast(1 as float) else 0 end end end as RemainingPayOut
							  ,case when Archive.SlipSystem.IsPayOut=0 or Archive.SlipSystem.IsPayOut is null then 0 else case when Archive.SlipSystem.SlipStateId in (1) then Archive.SlipSystem.MaxGain*cast(1 as float) else case when Archive.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Archive.SlipSystem.SystemSlipId)) else Archive.SlipSystem.MaxGain*cast(1 as float)  end end end as PaidAmount
							  ,cast(1 as bit) as IsBranchCustomer
							  ,case when (Select Count(*) from Customer.Tax where SlipId =Archive.SlipSystem.SystemSlipId and SlipTypeId=3 )>0 Then (Select SUM(TaxAmount) from Customer.Tax where SlipId=Archive.SlipSystem.SystemSlipId and SlipTypeId=3) else 0 end as Tax
							  ,Archive.SlipSystem.EvaluateDate 
,(Select top 1 CreateDate from RiskManagement.BranchTransaction with (nolock) where SlipId=(select Min(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Archive.SlipSystem.SystemSlipId) and TransactionTypeId in (8,12)) as PaidDate
from Archive.SlipSystem with (nolock) INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Archive.SlipSystem.SlipStateId INNER JOIN
 Customer.Customer with (nolock) ON Customer.Customer.CustomerId = Archive.SlipSystem.CustomerId INNER JOIN
							  Parameter.Source with (nolock) ON Archive.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN
							  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  =@UserCurrencyId  INNER JOIN
							  	   Language.[Parameter.SlipState] On Language.[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].LanguageId=6 INNER JOIN 
							  Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
where Archive.SlipSystem.SystemSlipId = (select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)
and 		(Customer.Customer.BranchId in  (select BranchId from Parameter.Branch where ParentBranchId in   (select distinct BranchId from Parameter.Branch with (nolock) where (BranchId=@BranchId or ParentBranchId=@BranchId or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where (BranchId=@BranchId or ParentBranchId=@BranchId) )))) or Customer.Customer.BranchId=@BranchId)
--GROUP BY Archive.SlipSystem.SystemSlipId, Archive.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
--							  Archive.SlipSystem.Amount, Archive.SlipSystem.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Archive.SlipSystem.CreateDate, Parameter.Source.SourceId, 
--							  Parameter.Source.Source, Archive.SlipSystem.SlipTypeId, Archive.SlipSystem.SourceId, 
--							  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.Branch.BrancName,Archive.SlipSystem.SlipStateId,Archive.SlipSystem.EventCount,Archive.SlipSystem.[System]
--							  ,Archive.SlipSystem.MaxGain,Customer.Customer.CurrencyId  ,Archive.SlipSystem.IsPayOut,Customer.Customer.IsBranchCustomer,Language.[Parameter.SlipState].SlipState

		end
	end
END




GO
