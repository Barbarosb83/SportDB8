USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCustomerSlip]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Retail].[ProcCustomerSlip] 
@SlipId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;


declare @TempTable table (SlipId bigint,CreateDate datetime,Amount money,TotalOddValue float,StateId int,SlipState nvarchar(50),SlipType nvarchar(50),Gain float,Bets int,SlipStatu nvarchar(50),TaxAmount money, CurrencyId int, Currency nvarchar(20),CurrencySymbol nvarchar(20),BankoCount int,IsTerminalCustomer bit,Username nvarchar(150),EventCount int)


insert @TempTable
SELECT    top 30 Customer.Slip.SlipId, Customer.Slip.CreateDate, Customer.Slip.Amount, Customer.Slip.TotalOddValue, Language.[Parameter.SlipState].SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState, Language.[Parameter.SlipType].SlipType, 
                      case when Customer.Slip.SlipStateId in (3,1) and Customer.Slip.TotalOddValue>1 then  Customer.Slip.TotalOddValue * Customer.Slip.Amount else case when Customer.Slip.SlipStateId in (2) Or Customer.Slip.TotalOddValue=1 then  Customer.Slip.Amount+ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax where SlipId=Customer.Slip.SlipId),0) else case when Customer.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut where Customer.SlipCashout.SlipId=@SlipId) else 0 end end end as  Gain,
                         1 AS Bets, Language.[Parameter.SlipStatu].SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount,
						 Parameter.Currency.CurrencyId,Parameter.Currency.Symbol3,Parameter.Currency.Sybol,0
						 ,(Select Customer.Customer.IsBranchCustomer from Customer.Customer where Customer.Customer.CustomerId=Customer.Slip.CustomerId)
						 ,(Select Customer.Customer.Username from Customer.Customer where Customer.Customer.CustomerId=Customer.Slip.CustomerId)
						 ,Customer.Slip.EventCount
                            FROM         Customer.Slip with (nolock) INNER JOIN
                      Language.[Parameter.SlipState] with (nolock) ON  Language.[Parameter.SlipState].SlipStateId=Customer.Slip.SlipStateId and Language.[Parameter.SlipState].LanguageId=@LangId INNER JOIN
                      Language.[Parameter.SlipStatu] with (nolock)  ON Language.[Parameter.SlipStatu].SlipStatuId =Customer.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId = @LangId INNER JOIN
					  Parameter.Currency ON Customer.Slip.CurrencyId=Parameter.Currency.CurrencyId INNER JOIN
					  Language.[Parameter.SlipType] ON Language.[Parameter.SlipType].[SlipTypeId]=Customer.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId LEFT OUTER JOIN
					  Customer.Tax ON Customer.Tax.SlipId=Customer.Slip.SlipId  and Customer.Tax.SlipTypeId=2
where Customer.Slip.SlipId=@SlipId and Customer.Slip.SlipStatu in (1,3) -- and MONTH(Customer.Slip.CreateDate)=MONTH(@SlipDate) and YEAR(Customer.Slip.CreateDate)=YEAR(@SlipDate)
and Customer.Slip.SlipTypeId<3
order by Customer.Slip.SlipId desc

insert @TempTable
SELECT    top 30 Archive.Slip.SlipId, Archive.Slip.CreateDate, Archive.Slip.Amount, Archive.Slip.TotalOddValue, Language.[Parameter.SlipState].SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState, Language.[Parameter.SlipType].SlipType, 
					   case when Archive.Slip.SlipStateId in (3,1) and Archive.Slip.TotalOddValue>1 then  Archive.Slip.TotalOddValue * Archive.Slip.Amount else case when Archive.Slip.SlipStateId in (2) OR  Archive.Slip.TotalOddValue=1 then  Archive.Slip.Amount+ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax where SlipId=Archive.Slip.SlipId),0) else case when Archive.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut where Customer.SlipCashout.SlipId=@SlipId) else 0 end end end as  Gain,
                     1 AS Bets, Language.[Parameter.SlipStatu].SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount,
					  Parameter.Currency.CurrencyId,Parameter.Currency.Symbol3,Parameter.Currency.Sybol,0
					  ,(Select Customer.Customer.IsBranchCustomer from Customer.Customer where Customer.Customer.CustomerId=Archive.Slip.CustomerId)
					   ,(Select Customer.Customer.Username from Customer.Customer where Customer.Customer.CustomerId=Archive.Slip.CustomerId)
					   ,Archive.Slip.EventCount
                            FROM         Archive.Slip with (nolock) INNER JOIN
                      Language.[Parameter.SlipState] with (nolock) ON  Language.[Parameter.SlipState].SlipStateId=Archive.Slip.SlipStateId and Language.[Parameter.SlipState].LanguageId=@LangId INNER JOIN
                      Language.[Parameter.SlipStatu] with (nolock) ON  Language.[Parameter.SlipStatu].SlipStatuId=Archive.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId =@LangId  INNER JOIN
					  Parameter.Currency ON Archive.Slip.CurrencyId=Parameter.Currency.CurrencyId INNER JOIN
					  Language.[Parameter.SlipType] ON Language.[Parameter.SlipType].[SlipTypeId]=Archive.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId LEFT OUTER JOIN
					  Customer.Tax ON Customer.Tax.SlipId=Archive.Slip.SlipId  and Customer.Tax.SlipTypeId=2
where Archive.Slip.SlipId=@SlipId and Archive.Slip.SlipStatu in (1,3)  
and Archive.Slip.SlipTypeId<3
order by Archive.Slip.SlipId desc

if exists(select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipTypeId=3)
insert @TempTable
select DISTINCT (select Min(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else Customer.SlipSystem.[System] end as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0) end end as Gain
,(Select Count(*) from [Customer].[SlipSystemSlip] where [SystemSlipId]=Customer.SlipSystem.SystemSlipId )  as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock) where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount,
Parameter.Currency.CurrencyId,Parameter.Currency.Symbol3,Parameter.Currency.Sybol,(select COUNT(DISTINCT Customer.SlipOdd.MatchId) from Customer.SlipOdd with (nolock) where Banko=1 and SlipId in (
select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId))
 ,(Select top 1 Customer.Customer.IsBranchCustomer from Customer.Customer with (nolock) where Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId)
 ,(Select top 1 Customer.Customer.Username from Customer.Customer with (nolock) where Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId)
 ,Customer.SlipSystem.EventCount-(select COUNT(*) from Customer.SlipOdd where SlipId=@SlipId and Banko=1)
from Customer.SlipSystem with (nolock) INNER JOIN 
Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
Parameter.Currency with (nolock) ON Customer.SlipSystem.CurrencyId=Parameter.Currency.CurrencyId 
where Customer.SlipSystem.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId )

else if exists(select SlipId from Archive.Slip with (nolock) where SlipId=@SlipId and SlipTypeId=3)
insert @TempTable
select DISTINCT (select Min(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else Customer.SlipSystem.[System] end as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0) end end as Gain
,(Select Count(*) from [Customer].[SlipSystemSlip] where [SystemSlipId]=Customer.SlipSystem.SystemSlipId )  as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock) where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount,
Parameter.Currency.CurrencyId,Parameter.Currency.Symbol3,Parameter.Currency.Sybol,(select COUNT(DISTINCT Customer.SlipOdd.MatchId) from Customer.SlipOdd with (nolock) where Banko=1 and SlipId in (
select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId))
 ,(Select top 1 Customer.Customer.IsBranchCustomer from Customer.Customer with (nolock) where Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId)
 ,(Select top 1 Customer.Customer.Username from Customer.Customer with (nolock) where Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId)
 ,Customer.SlipSystem.EventCount-(select COUNT(*) from Customer.SlipOdd where SlipId=@SlipId and Banko=1)
from Customer.SlipSystem with (nolock) INNER JOIN 
Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
Parameter.Currency with (nolock) ON Customer.SlipSystem.CurrencyId=Parameter.Currency.CurrencyId 
where Customer.SlipSystem.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId )




else if exists(select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipTypeId=4)
insert @TempTable
select DISTINCT (select Min(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,  SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System'  as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else Customer.SlipSystem.MaxGain end end as Gain
,Customer.SlipSystem.CouponCount as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock) where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount,
Parameter.Currency.CurrencyId,Parameter.Currency.Symbol3,Parameter.Currency.Sybol,(select COUNT(DISTINCT Customer.SlipOdd.MatchId) from Customer.SlipOdd with (nolock) where Banko=1 and SlipId in (
select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId))
 ,(Select top 1 Customer.Customer.IsBranchCustomer from Customer.Customer with (nolock) where Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId)
 ,(Select top 1 Customer.Customer.Username from Customer.Customer with (nolock) where Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId)
 ,Customer.SlipSystem.EventCount-(select COUNT(*) from Customer.SlipOdd where SlipId=@SlipId and Banko=1)
from Customer.SlipSystem with (nolock) INNER JOIN 
Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
Parameter.Currency with (nolock) ON Customer.SlipSystem.CurrencyId=Parameter.Currency.CurrencyId 
where Customer.SlipSystem.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId )


else if exists(select SlipId from Archive.Slip with (nolock) where SlipId=@SlipId and SlipTypeId=4)
insert @TempTable
select DISTINCT (select Min(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,  SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System'  as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else Customer.SlipSystem.MaxGain end end as Gain
,Customer.SlipSystem.CouponCount as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock) where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount,
Parameter.Currency.CurrencyId,Parameter.Currency.Symbol3,Parameter.Currency.Sybol,(select COUNT(DISTINCT Customer.SlipOdd.MatchId) from Customer.SlipOdd with (nolock) where Banko=1 and SlipId in (
select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId))
 ,(Select top 1 Customer.Customer.IsBranchCustomer from Customer.Customer with (nolock) where Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId)
 ,(Select top 1 Customer.Customer.Username from Customer.Customer with (nolock) where Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId)
 ,Customer.SlipSystem.EventCount-(select COUNT(*) from Customer.SlipOdd where SlipId=@SlipId and Banko=1)
from Customer.SlipSystem with (nolock) INNER JOIN 
Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
Parameter.Currency with (nolock) ON Customer.SlipSystem.CurrencyId=Parameter.Currency.CurrencyId 
where Customer.SlipSystem.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId )

else if exists(select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipTypeId=5)
insert @TempTable
select DISTINCT (select Min(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,'Multiway Ticket' as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else Customer.SlipSystem.MaxGain end end as Gain
,Customer.SlipSystem.CouponCount as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock) where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount,
Parameter.Currency.CurrencyId,Parameter.Currency.Symbol3,Parameter.Currency.Sybol,(select COUNT(DISTINCT Customer.SlipOdd.MatchId) from Customer.SlipOdd with (nolock) where Banko=1 and SlipId in (
select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId))
 ,(Select top 1 Customer.Customer.IsBranchCustomer from Customer.Customer with (nolock) where Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId)
 ,(Select top 1 Customer.Customer.Username from Customer.Customer with (nolock) where Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId)
 ,Customer.SlipSystem.EventCount
from Customer.SlipSystem with (nolock) INNER JOIN 
Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
Parameter.Currency with (nolock) ON Customer.SlipSystem.CurrencyId=Parameter.Currency.CurrencyId 
where Customer.SlipSystem.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId )

else if exists(select SlipId from Archive.Slip with (nolock) where SlipId=@SlipId and SlipTypeId=5)
insert @TempTable
select DISTINCT (select Min(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,'Multiway Ticket' as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else Customer.SlipSystem.MaxGain end end as Gain
,Customer.SlipSystem.CouponCount as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock) where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount,
Parameter.Currency.CurrencyId,Parameter.Currency.Symbol3,Parameter.Currency.Sybol,(select COUNT(DISTINCT Customer.SlipOdd.MatchId) from Customer.SlipOdd with (nolock) where Banko=1 and SlipId in (
select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId))
 ,(Select top 1 Customer.Customer.IsBranchCustomer from Customer.Customer with (nolock) where Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId)
 ,(Select top 1 Customer.Customer.Username from Customer.Customer with (nolock) where Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId)
 ,Customer.SlipSystem.EventCount
from Customer.SlipSystem with (nolock) INNER JOIN 
Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
Parameter.Currency with (nolock) ON Customer.SlipSystem.CurrencyId=Parameter.Currency.CurrencyId 
where Customer.SlipSystem.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId )


select *
From @TempTable order by CreateDate desc

END
GO
