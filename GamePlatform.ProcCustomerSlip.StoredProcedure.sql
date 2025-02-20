USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerSlip]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 

CREATE PROCEDURE [GamePlatform].[ProcCustomerSlip] 
@CustomerId bigint,
@StateId int,
@SlipDate datetime,
@LangId int
AS

BEGIN
SET NOCOUNT ON;

--set @SlipDate=DATEADD(HOUR,-2,@SlipDate)
declare @TempTable table (SlipId bigint,CreateDate datetime,Amount money,TotalOddValue float,StateId int,SlipState nvarchar(20),SlipType nvarchar(50),Gain float,Bets int,SlipStatu nvarchar(50),TaxAmount money,PossibleGain float,IsLive bit)


if(@StateId=0)
begin
insert @TempTable
SELECT     TOP 30 Customer.Slip.SlipId, Customer.Slip.CreateDate, Customer.Slip.Amount, Customer.Slip.TotalOddValue, Language.[Parameter.SlipState].SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState,Language.[Parameter.SlipType].SlipType, 
					 case when Customer.Slip.SlipStateId in (3) then   Customer.Slip.TotalOddValue * Customer.Slip.Amount else case when Customer.Slip.SlipStateId in (2) then   Customer.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock)  where SlipId=Customer.Slip.SlipId),0) else case when Customer.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashout.SlipId=Customer.Slip.SlipId) else 0 end end end as Gain,
                         Customer.Slip.EventCount AS Bets, Language.[Parameter.SlipStatu].SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount,(Customer.Slip.TotalOddValue * Customer.Slip.Amount) as PossibleGain,Customer.Slip.IsLive
FROM         Customer.Slip with (nolock) INNER JOIN
                      Language.[Parameter.SlipState] with (nolock)  ON   Language.[Parameter.SlipState].SlipStateId=Customer.Slip.SlipStateId and (Language.[Parameter.SlipState].LanguageId = @LangId) INNER JOIN
                      Language.[Parameter.SlipStatu] with (nolock)  ON  Language.[Parameter.SlipStatu].SlipStatuId=Customer.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId=@LangId INNER JOIN
					  Language.[Parameter.SlipType] with (nolock)  ON Language.[Parameter.SlipType].[SlipTypeId]=Customer.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId LEFT OUTER JOIN

					  Customer.Tax with (nolock)  ON Customer.Tax.SlipId=Customer.Slip.SlipId  and Customer.Tax.SlipTypeId=2
where Customer.Slip.CustomerId=@CustomerId and Language.[Parameter.SlipState].SlipStateId not in (1) and Customer.Slip.SlipStatu in (1,3) -- and MONTH(Customer.Slip.CreateDate)=MONTH(@SlipDate) and YEAR(Customer.Slip.CreateDate)=YEAR(@SlipDate)
and Customer.Slip.SlipTypeId<3
order by Customer.Slip.SlipId desc

insert @TempTable
SELECT     TOP 30 Archive.Slip.SlipId, Archive.Slip.CreateDate, Archive.Slip.Amount, Archive.Slip.TotalOddValue, Language.[Parameter.SlipState].SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState,Language.[Parameter.SlipType].SlipType, 
                     case when Archive.Slip.SlipStateId in (3) then   Archive.Slip.TotalOddValue * Archive.Slip.Amount  else case when Archive.Slip.SlipStateId in (2) then   Archive.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock) where SlipId=Archive.Slip.SlipId and SlipTypeId=Archive.Slip.SlipTypeId),0) else case when Archive.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashout.SlipId=Archive.Slip.SlipId) else 0 end end end AS Gain,
                          Archive.Slip.EventCount AS Bets, Language.[Parameter.SlipStatu].SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount,(Archive.Slip.TotalOddValue * Archive.Slip.Amount) as PossibleGain,Archive.Slip.IsLive
FROM         Archive.Slip with (nolock) INNER JOIN
                          Language.[Parameter.SlipState] with (nolock)  ON   Language.[Parameter.SlipState].SlipStateId=Archive.Slip.SlipStateId and (Language.[Parameter.SlipState].LanguageId = @LangId) INNER JOIN
                      Language.[Parameter.SlipStatu] with (nolock)  ON  Language.[Parameter.SlipStatu].SlipStatuId=Archive.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId=@LangId INNER JOIN
					  Language.[Parameter.SlipType] with (nolock)  ON Language.[Parameter.SlipType].[SlipTypeId]=Archive.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId LEFT OUTER JOIN

					  Customer.Tax ON Customer.Tax.SlipId=Archive.Slip.SlipId  and Customer.Tax.SlipTypeId=2
where Archive.Slip.CustomerId=@CustomerId and Language.[Parameter.SlipState].SlipStateId not in (1) and Archive.Slip.SlipStatu in (1,3) --and MONTH(Archive.Slip.CreateDate)=MONTH(@SlipDate) and YEAR(Archive.Slip.CreateDate)=YEAR(@SlipDate)
and Archive.Slip.SlipTypeId<3
order by Archive.Slip.SlipId desc



insert @TempTable
select (select Max(SlipId) from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,case when Customer.SlipSystem.NewSlipTypeId in (3,4) then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else 'Multiway' end as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip with (nolock)  where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip with (nolock)  where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0) end end as Gain
,Customer.SlipSystem.EventCount as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount
,Customer.SlipSystem.MaxGain as PossibleGain,0 as IsLive
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState with (nolock)  ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId
where Customer.SlipSystem.NewSlipTypeId in (3) and  Customer.SlipSystem.CustomerId=@CustomerId and Customer.SlipSystem.SlipStateId not in (1) 

insert @TempTable
select (select Max(SlipId) from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,case when Customer.SlipSystem.NewSlipTypeId in (4) then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else 'Multiway' end as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else Customer.SlipSystem.MaxGain end end as Gain
,Customer.SlipSystem.EventCount as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount
,Customer.SlipSystem.MaxGain as PossibleGain,0 as IsLive
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState with (nolock)  ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId
where Customer.SlipSystem.NewSlipTypeId in (4,5) and  Customer.SlipSystem.CustomerId=@CustomerId and Customer.SlipSystem.SlipStateId not in (1) 

end
else if(@StateId=1)
begin
insert @TempTable
SELECT    top 30 Customer.Slip.SlipId, Customer.Slip.CreateDate, Customer.Slip.Amount, Customer.Slip.TotalOddValue,Language.[Parameter.SlipState].SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState, Language.[Parameter.SlipType].SlipType, 
					  case when Customer.Slip.SlipStateId in (3) then   Customer.Slip.TotalOddValue * Customer.Slip.Amount else case when Customer.Slip.SlipStateId in (2) then   Customer.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock)  where SlipId=Customer.Slip.SlipId),0) else case when Customer.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashout.SlipId=Customer.Slip.SlipId) else 0 end end end as Gain,
                         Customer.Slip.EventCount AS Bets, Language.[Parameter.SlipStatu].SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount
						 ,(Customer.Slip.TotalOddValue * Customer.Slip.Amount) as PossibleGain,Customer.Slip.IsLive
                            FROM         Customer.Slip with (nolock) INNER JOIN
                             Language.[Parameter.SlipState] with (nolock)  ON   Language.[Parameter.SlipState].SlipStateId=Customer.Slip.SlipStateId and (Language.[Parameter.SlipState].LanguageId = @LangId) INNER JOIN
                      Language.[Parameter.SlipStatu] with (nolock)  ON  Language.[Parameter.SlipStatu].SlipStatuId=Customer.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId=@LangId INNER JOIN
					  Language.[Parameter.SlipType] with (nolock)  ON Language.[Parameter.SlipType].[SlipTypeId]=Customer.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId LEFT OUTER JOIN
					  Customer.Tax with (nolock)  ON Customer.Tax.SlipId=Customer.Slip.SlipId  and Customer.Tax.SlipTypeId=2
where Customer.Slip.CustomerId=@CustomerId and Language.[Parameter.SlipState].SlipStateId =@StateId and Customer.Slip.SlipStatu in (1,3) 
 --and MONTH(DATEADD(HOUR,+2,Customer.Slip.CreateDate))=MONTH(@SlipDate) and YEAR(Customer.Slip.CreateDate)=YEAR(@SlipDate)
and Customer.Slip.SlipTypeId<3
order by Customer.Slip.SlipId desc

insert @TempTable
SELECT    top 30 Archive.Slip.SlipId, Archive.Slip.CreateDate, Archive.Slip.Amount, Archive.Slip.TotalOddValue, Language.[Parameter.SlipState].SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState, Language.[Parameter.SlipType].SlipType, 
					 -- CASE WHEN Archive.Slip.SlipStateId <> 4 THEN Archive.Slip.TotalOddValue * Archive.Slip.Amount ELSE 0 END AS Gain,
					 case when Archive.Slip.SlipStateId in (3) then   Archive.Slip.TotalOddValue * Archive.Slip.Amount  else case when Archive.Slip.SlipStateId in (2) then   Archive.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock) where SlipId=Archive.Slip.SlipId and SlipTypeId=Archive.Slip.SlipTypeId),0) else case when Archive.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashout.SlipId=Archive.Slip.SlipId) else 0 end end end AS Gain,
                     Archive.Slip.EventCount AS Bets, Language.[Parameter.SlipStatu].SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount
					 ,(Archive.Slip.TotalOddValue * Archive.Slip.Amount) as PossibleGain,Archive.Slip.IsLive
                            FROM         Archive.Slip with (nolock) INNER JOIN
                         Language.[Parameter.SlipState] with (nolock)  ON   Language.[Parameter.SlipState].SlipStateId=Archive.Slip.SlipStateId and (Language.[Parameter.SlipState].LanguageId = @LangId) INNER JOIN
                      Language.[Parameter.SlipStatu] with (nolock)  ON  Language.[Parameter.SlipStatu].SlipStatuId=Archive.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId=@LangId INNER JOIN
					  Language.[Parameter.SlipType] with (nolock)  ON Language.[Parameter.SlipType].[SlipTypeId]=Archive.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId LEFT OUTER JOIN

					  Customer.Tax with (nolock)  ON Customer.Tax.SlipId=Archive.Slip.SlipId  and Customer.Tax.SlipTypeId=2
where Archive.Slip.CustomerId=@CustomerId and Language.[Parameter.SlipState].SlipStateId =@StateId and Archive.Slip.SlipStatu in (1,3)  
--and MONTH(DATEADD(HOUR,+2,Archive.Slip.CreateDate))=MONTH(@SlipDate) and YEAR(Archive.Slip.CreateDate)=YEAR(@SlipDate)
and Archive.Slip.SlipTypeId<3
order by Archive.Slip.SlipId desc

insert @TempTable
select (select Max(SlipId) from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,case when Customer.SlipSystem.NewSlipTypeId in (3,4) then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else 'Multiway' end as SlipType
--,case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0) end end as Gain
,case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip with (nolock)  where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip with (nolock)  where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0) end end as Gain
,Customer.SlipSystem.EventCount as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount
,Customer.SlipSystem.MaxGain as PossibleGain,0 as IsLive
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState  with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId
where Customer.SlipSystem.NewSlipTypeId in (3) and Customer.SlipSystem.CustomerId=@CustomerId and Customer.SlipSystem.SlipStateId=@StateId
--and MONTH(DATEADD(HOUR,+2,Customer.SlipSystem.CreateDate))=MONTH(@SlipDate) and YEAR(Customer.SlipSystem.CreateDate)=YEAR(@SlipDate)

insert @TempTable
select (select Max(SlipId) from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,case when Customer.SlipSystem.NewSlipTypeId in (3,4) then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else 'Multiway' end as SlipType
--,case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0) end end as Gain
,case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else Customer.SlipSystem.MaxGain end end as Gain
,Customer.SlipSystem.EventCount as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount
,Customer.SlipSystem.MaxGain as PossibleGain,0 as IsLive
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState with (nolock)  ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId
where Customer.SlipSystem.NewSlipTypeId in (4,5) and Customer.SlipSystem.CustomerId=@CustomerId and Customer.SlipSystem.SlipStateId=@StateId
--and MONTH(DATEADD(HOUR,+2,Customer.SlipSystem.CreateDate))=MONTH(@SlipDate) and YEAR(Customer.SlipSystem.CreateDate)=YEAR(@SlipDate)

end
else if(@StateId=-1)
begin
insert @TempTable
SELECT     top 30 Customer.Slip.SlipId, Customer.Slip.CreateDate, Customer.Slip.Amount, Customer.Slip.TotalOddValue, Language.[Parameter.SlipState].SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState, Language.[Parameter.SlipType].SlipType, 
					   case when Customer.Slip.SlipStateId in (3) then   Customer.Slip.TotalOddValue * Customer.Slip.Amount else case when Customer.Slip.SlipStateId in (2) then   Customer.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock)  where SlipId=Customer.Slip.SlipId),0) else case when Customer.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashout.SlipId=Customer.Slip.SlipId) else 0 end end end as Gain,
                     Customer.Slip.EventCount AS Bets, Language.[Parameter.SlipStatu].SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount
					 ,(Customer.Slip.TotalOddValue * Customer.Slip.Amount) as PossibleGain,Customer.Slip.IsLive
                            FROM         Customer.Slip with (nolock) INNER JOIN
                     Language.[Parameter.SlipState] with (nolock)  ON   Language.[Parameter.SlipState].SlipStateId=Customer.Slip.SlipStateId and (Language.[Parameter.SlipState].LanguageId = @LangId) INNER JOIN
                      Language.[Parameter.SlipStatu] with (nolock)  ON  Language.[Parameter.SlipStatu].SlipStatuId=Customer.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId=@LangId INNER JOIN
					  Language.[Parameter.SlipType]  with (nolock) ON Language.[Parameter.SlipType].[SlipTypeId]=Customer.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId LEFT OUTER JOIN

					  Customer.Tax ON Customer.Tax.SlipId=Customer.Slip.SlipId  and Customer.Tax.SlipTypeId=2
where Customer.Slip.CustomerId=@CustomerId  and Customer.Slip.SlipStatu in (1,3)
and Customer.Slip.SlipTypeId<3
order by Customer.Slip.SlipId desc

insert @TempTable
SELECT     top 30 Archive.Slip.SlipId, Archive.Slip.CreateDate, Archive.Slip.Amount, Archive.Slip.TotalOddValue, Language.[Parameter.SlipState].SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState, Language.[Parameter.SlipType].SlipType, 
                      --CASE WHEN Archive.Slip.SlipStateId not in (4,7) THEN Archive.Slip.TotalOddValue * Archive.Slip.Amount ELSE case when Archive.Slip.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId=Archive.Slip.SlipId) else 0 end END AS Gain,
					  case when Archive.Slip.SlipStateId in (3) then   Archive.Slip.TotalOddValue * Archive.Slip.Amount  else case when Archive.Slip.SlipStateId in (2) then   Archive.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock) where SlipId=Archive.Slip.SlipId and SlipTypeId=Archive.Slip.SlipTypeId),0) else case when Archive.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashout.SlipId=Archive.Slip.SlipId) else 0 end end end AS Gain,
                          Archive.Slip.EventCount AS Bets, Language.[Parameter.SlipStatu].SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount
						  ,(Archive.Slip.TotalOddValue * Archive.Slip.Amount) as PossibleGain,Archive.Slip.IsLive
                            FROM         Archive.Slip with (nolock) INNER JOIN
                         Language.[Parameter.SlipState] with (nolock)  ON   Language.[Parameter.SlipState].SlipStateId=Archive.Slip.SlipStateId and (Language.[Parameter.SlipState].LanguageId = @LangId) INNER JOIN
                      Language.[Parameter.SlipStatu] with (nolock)  ON  Language.[Parameter.SlipStatu].SlipStatuId=Archive.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId=@LangId INNER JOIN
					  Language.[Parameter.SlipType] with (nolock)  ON Language.[Parameter.SlipType].[SlipTypeId]=Archive.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId LEFT OUTER JOIN
					  Customer.Tax with (nolock)  ON Customer.Tax.SlipId=Archive.Slip.SlipId  and Customer.Tax.SlipTypeId=2
where Archive.Slip.CustomerId=@CustomerId  and Archive.Slip.SlipStatu in (1,3)
and Archive.Slip.SlipTypeId<3
order by Archive.Slip.SlipId desc


insert @TempTable
select (select Max(SlipId) from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,case when Customer.SlipSystem.NewSlipTypeId in (3,4) then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else 'Multiway' end as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip with (nolock)  where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip with (nolock)  where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0) end end as Gain
,Customer.SlipSystem.EventCount as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount
,Customer.SlipSystem.MaxGain  as PossibleGain,0 as Islive
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState with (nolock)  ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId
where Customer.SlipSystem.NewSlipTypeId in (3 ) and Customer.SlipSystem.CustomerId=@CustomerId  

insert @TempTable
select (select Max(SlipId) from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,case when Customer.SlipSystem.NewSlipTypeId in (3,4) then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else 'Multiway' end as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip  with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else Customer.SlipSystem.MaxGain end end as Gain
,Customer.SlipSystem.EventCount as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax  with (nolock) where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount
,Customer.SlipSystem.MaxGain  as PossibleGain,0 as Islive
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState with (nolock)  ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId
where  Customer.SlipSystem.NewSlipTypeId in (4,5 ) and Customer.SlipSystem.CustomerId=@CustomerId  




end
else if(@StateId=-2)
begin
insert @TempTable
SELECT     top 30 Customer.Slip.SlipId, Customer.Slip.CreateDate, Customer.Slip.Amount, Customer.Slip.TotalOddValue, Language.[Parameter.SlipState].SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState, Language.[Parameter.SlipType].SlipType, 
					 case when Customer.Slip.SlipStateId in (3) then   Customer.Slip.TotalOddValue * Customer.Slip.Amount else case when Customer.Slip.SlipStateId in (2) then   Customer.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock)  where SlipId=Customer.Slip.SlipId),0) else case when Customer.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashout.SlipId=Customer.Slip.SlipId) else 0 end end end as Gain,
                        Customer.Slip.EventCount AS Bets, Language.[Parameter.SlipStatu].SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount
						,(Customer.Slip.TotalOddValue * Customer.Slip.Amount) as PossibleGain,Customer.Slip.IsLive
                            FROM         Customer.Slip with (nolock) INNER JOIN
                       Language.[Parameter.SlipState] with (nolock)  ON   Language.[Parameter.SlipState].SlipStateId=Customer.Slip.SlipStateId and (Language.[Parameter.SlipState].LanguageId = @LangId) INNER JOIN
                      Language.[Parameter.SlipStatu] with (nolock)  ON  Language.[Parameter.SlipStatu].SlipStatuId=Customer.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId=@LangId INNER JOIN
					  Language.[Parameter.SlipType] with (nolock)  ON Language.[Parameter.SlipType].[SlipTypeId]=Customer.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId LEFT OUTER JOIN
					  Customer.Tax  with (nolock) ON Customer.Tax.SlipId=Customer.Slip.SlipId  and Customer.Tax.SlipTypeId=2
where Customer.Slip.CustomerId=@CustomerId  and Customer.Slip.SlipStatu in (2,4)
order by Customer.Slip.SlipId desc

insert @TempTable
SELECT     top 30 Archive.Slip.SlipId, Archive.Slip.CreateDate, Archive.Slip.Amount, Archive.Slip.TotalOddValue, Language.[Parameter.SlipState].SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState, Language.[Parameter.SlipType].SlipType, 
					 case when Archive.Slip.SlipStateId in (3) then   Archive.Slip.TotalOddValue * Archive.Slip.Amount  else case when Archive.Slip.SlipStateId in (2) then   Archive.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock) where SlipId=Archive.Slip.SlipId and SlipTypeId=Archive.Slip.SlipTypeId),0) else case when Archive.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashout.SlipId=Archive.Slip.SlipId) else 0 end end end AS Gain,
                          Archive.Slip.EventCount AS Bets, Language.[Parameter.SlipStatu].SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount
						  ,(Archive.Slip.TotalOddValue * Archive.Slip.Amount) as PossibleGain,Archive.Slip.IsLive
                            FROM         Archive.Slip with (nolock) INNER JOIN
                      Language.[Parameter.SlipState] with (nolock)  ON   Language.[Parameter.SlipState].SlipStateId=Archive.Slip.SlipStateId and (Language.[Parameter.SlipState].LanguageId = @LangId) INNER JOIN
                      Language.[Parameter.SlipStatu] with (nolock)  ON  Language.[Parameter.SlipStatu].SlipStatuId=Archive.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId=@LangId INNER JOIN
					  Language.[Parameter.SlipType] with (nolock)  ON Language.[Parameter.SlipType].[SlipTypeId]=Archive.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId  LEFT OUTER JOIN
					  Customer.Tax  with (nolock) ON Customer.Tax.SlipId=Archive.Slip.SlipId  and Customer.Tax.SlipTypeId=2
where Archive.Slip.CustomerId=@CustomerId  and Archive.Slip.SlipStatu in (2,4)
order by Archive.Slip.SlipId desc




end
else if(@StateId=-10)--all
begin

insert @TempTable
SELECT    top 30 Customer.Slip.SlipId, Customer.Slip.CreateDate, Customer.Slip.Amount, Customer.Slip.TotalOddValue, Language.[Parameter.SlipState].SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState, Language.[Parameter.SlipType].SlipType, 
                      --CASE WHEN Customer.Slip.SlipStateId not in (4,7) THEN Customer.Slip.TotalOddValue * Customer.Slip.Amount ELSE case when Customer.Slip.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId=Customer.Slip.SlipId) else 0 end END AS Gain,
					 case when Customer.Slip.SlipStateId in (3) then   Customer.Slip.TotalOddValue * Customer.Slip.Amount else case when Customer.Slip.SlipStateId in (2) then   Customer.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock)  where SlipId=Customer.Slip.SlipId),0) else case when Customer.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashout.SlipId=Customer.Slip.SlipId) else 0 end end end as Gain,
                         Customer.Slip.EventCount AS Bets, Language.[Parameter.SlipStatu].SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount
						 ,(Customer.Slip.TotalOddValue * Customer.Slip.Amount) as PossibleGain,Customer.Slip.IsLive
                            FROM         Customer.Slip with (nolock) INNER JOIN
                      Language.[Parameter.SlipState] with (nolock)  ON   Language.[Parameter.SlipState].SlipStateId=Customer.Slip.SlipStateId and (Language.[Parameter.SlipState].LanguageId = @LangId) INNER JOIN
                      Language.[Parameter.SlipStatu] with (nolock)  ON  Language.[Parameter.SlipStatu].SlipStatuId=Customer.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId=@LangId INNER JOIN
					  Language.[Parameter.SlipType] with (nolock)  ON Language.[Parameter.SlipType].[SlipTypeId]=Customer.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId LEFT OUTER JOIN
					  Customer.Tax with (nolock)  ON Customer.Tax.SlipId=Customer.Slip.SlipId  and Customer.Tax.SlipTypeId=2
where Customer.Slip.CustomerId=@CustomerId and Customer.Slip.SlipStatu in (1,3)  and MONTH(DATEADD(HOUR,+2,Customer.Slip.CreateDate))=MONTH(@SlipDate) and YEAR(Customer.Slip.CreateDate)=YEAR(@SlipDate)
and Customer.Slip.SlipTypeId<3
order by Customer.Slip.SlipId desc

insert @TempTable
SELECT    top 30 Archive.Slip.SlipId, Archive.Slip.CreateDate, Archive.Slip.Amount, Archive.Slip.TotalOddValue, Language.[Parameter.SlipState].SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState, Language.[Parameter.SlipType].SlipType, 
					 --  CASE WHEN Archive.Slip.SlipStateId not in (4,7) THEN Archive.Slip.TotalOddValue * Archive.Slip.Amount ELSE case when Archive.Slip.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId=Archive.Slip.SlipId) else 0 end END AS Gain,
					 case when Archive.Slip.SlipStateId in (3) then   Archive.Slip.TotalOddValue * Archive.Slip.Amount  else case when Archive.Slip.SlipStateId in (2) then   Archive.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock) where SlipId=Archive.Slip.SlipId and SlipTypeId=Archive.Slip.SlipTypeId),0) else case when Archive.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashout.SlipId=Archive.Slip.SlipId) else 0 end end end AS Gain,
                      Archive.Slip.EventCount AS Bets, Language.[Parameter.SlipStatu].SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount
					  ,(Archive.Slip.TotalOddValue * Archive.Slip.Amount) as PossibleGain,Archive.Slip.IsLive
                            FROM         Archive.Slip with (nolock) INNER JOIN
                      Language.[Parameter.SlipState] with (nolock)  ON   Language.[Parameter.SlipState].SlipStateId=Archive.Slip.SlipStateId and (Language.[Parameter.SlipState].LanguageId = @LangId) INNER JOIN
                      Language.[Parameter.SlipStatu] with (nolock)  ON  Language.[Parameter.SlipStatu].SlipStatuId=Archive.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId=@LangId INNER JOIN
					  Language.[Parameter.SlipType]  with (nolock) ON Language.[Parameter.SlipType].[SlipTypeId]=Archive.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId  LEFT OUTER JOIN
					  Customer.Tax with (nolock)  ON Customer.Tax.SlipId=Archive.Slip.SlipId  and Customer.Tax.SlipTypeId=2
where Archive.Slip.CustomerId=@CustomerId and Archive.Slip.SlipStatu in (1,3) -- and MONTH(Archive.Slip.CreateDate)=MONTH(@SlipDate) and YEAR(Archive.Slip.CreateDate)=YEAR(@SlipDate)
and Archive.Slip.SlipTypeId<3
order by Archive.Slip.SlipId desc

insert @TempTable
select (select Max(SlipId) from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,case when Customer.SlipSystem.NewSlipTypeId in (3,4) then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else 'Multiway' end as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip with (nolock)  where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip with (nolock)  where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0) end end as Gain
,Customer.SlipSystem.EventCount as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount
,Customer.SlipSystem.MaxGain  as PossibleGain,0 as IsLive
from Customer.SlipSystem  with (nolock) INNER JOIN Parameter.SlipState with (nolock)  ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId
where Customer.SlipSystem.NewSlipTypeId in (3) and Customer.SlipSystem.CustomerId=@CustomerId  and (select Max(SlipId) from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) is not null

insert @TempTable
select (select Max(SlipId) from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,case when Customer.SlipSystem.NewSlipTypeId in (3,4) then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else 'Multiway' end as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else Customer.SlipSystem.MaxGain end end as Gain
,Customer.SlipSystem.EventCount as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount
,Customer.SlipSystem.MaxGain  as PossibleGain,0 as IsLive
from Customer.SlipSystem  with (nolock) INNER JOIN Parameter.SlipState with (nolock)  ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId
where Customer.SlipSystem.NewSlipTypeId in (4,5) and Customer.SlipSystem.CustomerId=@CustomerId  and (select Max(SlipId) from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) is not null


end
else if(@StateId=-20)--all terminal view
begin

insert @TempTable
SELECT    top 30 Customer.Slip.SlipId, Customer.Slip.CreateDate, Customer.Slip.Amount, Customer.Slip.TotalOddValue, Language.[Parameter.SlipState].SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState, Language.[Parameter.SlipType].SlipType, 
                      --CASE WHEN Customer.Slip.SlipStateId not in (4,7) THEN Customer.Slip.TotalOddValue * Customer.Slip.Amount ELSE case when Customer.Slip.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId=Customer.Slip.SlipId) else 0 end END AS Gain,
					 case when Customer.Slip.SlipStateId in (3) then   Customer.Slip.TotalOddValue * Customer.Slip.Amount else case when Customer.Slip.SlipStateId in (2) then   Customer.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock)  where SlipId=Customer.Slip.SlipId),0) else case when Customer.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashout.SlipId=Customer.Slip.SlipId) else 0 end end end as Gain,
                         Customer.Slip.EventCount AS Bets, Language.[Parameter.SlipStatu].SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount
						 ,(Customer.Slip.TotalOddValue * Customer.Slip.Amount) as PossibleGain,Customer.Slip.IsLive
                            FROM         Customer.Slip with (nolock) INNER JOIN
                     Language.[Parameter.SlipState] with (nolock)  ON   Language.[Parameter.SlipState].SlipStateId=Customer.Slip.SlipStateId and (Language.[Parameter.SlipState].LanguageId = @LangId) INNER JOIN
                      Language.[Parameter.SlipStatu] with (nolock)  ON  Language.[Parameter.SlipStatu].SlipStatuId=Customer.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId=@LangId INNER JOIN
					  Language.[Parameter.SlipType] with (nolock)  ON Language.[Parameter.SlipType].[SlipTypeId]=Customer.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId LEFT OUTER JOIN
					  Customer.Tax with (nolock)  ON Customer.Tax.SlipId=Customer.Slip.SlipId  and Customer.Tax.SlipTypeId=2
where Customer.Slip.CustomerId=@CustomerId and Customer.Slip.SlipStatu in (1,3)  
and cast(DATEADD(HOUR,+2,Customer.Slip.CreateDate) as Date)>=cast(@SlipDate as Date) 
and Customer.Slip.SlipTypeId<3
order by Customer.Slip.SlipId desc

insert @TempTable
SELECT    top 30 Archive.Slip.SlipId, Archive.Slip.CreateDate, Archive.Slip.Amount, Archive.Slip.TotalOddValue, Language.[Parameter.SlipState].SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState, Language.[Parameter.SlipType].SlipType, 
					 --  CASE WHEN Archive.Slip.SlipStateId not in (4,7) THEN Archive.Slip.TotalOddValue * Archive.Slip.Amount ELSE case when Archive.Slip.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId=Archive.Slip.SlipId) else 0 end END AS Gain,
					 case when Archive.Slip.SlipStateId in (3) then   Archive.Slip.TotalOddValue * Archive.Slip.Amount  else case when Archive.Slip.SlipStateId in (2) then   Archive.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock) where SlipId=Archive.Slip.SlipId and SlipTypeId=Archive.Slip.SlipTypeId),0) else case when Archive.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashout.SlipId=Archive.Slip.SlipId) else 0 end end end AS Gain,
                      Archive.Slip.EventCount AS Bets, Language.[Parameter.SlipStatu].SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount
					  ,(Archive.Slip.TotalOddValue * Archive.Slip.Amount) as PossibleGain,Archive.Slip.IsLive
                            FROM         Archive.Slip with (nolock) INNER JOIN
                       Language.[Parameter.SlipState] with (nolock)  ON   Language.[Parameter.SlipState].SlipStateId=Archive.Slip.SlipStateId and (Language.[Parameter.SlipState].LanguageId = @LangId) INNER JOIN
                      Language.[Parameter.SlipStatu]  with (nolock) ON  Language.[Parameter.SlipStatu].SlipStatuId=Archive.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId=@LangId INNER JOIN
					  Language.[Parameter.SlipType]  with (nolock) ON Language.[Parameter.SlipType].[SlipTypeId]=Archive.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId  LEFT OUTER JOIN
					  Customer.Tax  with (nolock) ON Customer.Tax.SlipId=Archive.Slip.SlipId  and Customer.Tax.SlipTypeId=2
where Archive.Slip.CustomerId=@CustomerId and Archive.Slip.SlipStatu in (1,3)  
and  cast(DATEADD(HOUR,+2,Archive.Slip.CreateDate) as Date)>=cast(@SlipDate as Date) 
and Archive.Slip.SlipTypeId<3
order by Archive.Slip.SlipId desc

insert @TempTable
select (select Max(SlipId) from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,case when Customer.SlipSystem.NewSlipTypeId in (3,4) then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else 'Multiway' end as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip with (nolock)  where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip  with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip  with (nolock) where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip  with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0) end end as Gain
,Customer.SlipSystem.EventCount as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount
,Customer.SlipSystem.MaxGain as PossibleGain,0 as IsLive
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState with (nolock)  ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId
where Customer.SlipSystem.NewSlipTypeId in (3) and Customer.SlipSystem.CustomerId=@CustomerId   and  cast(DATEADD(HOUR,+2,Customer.SlipSystem.CreateDate) as Date)>=cast(@SlipDate as Date) 
and (select Max(SlipId) from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) is not null

insert @TempTable
select (select Max(SlipId) from Customer.SlipSystemSlip  with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,case when Customer.SlipSystem.NewSlipTypeId in (3,4) then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else 'Multiway' end as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else Customer.SlipSystem.MaxGain end end as Gain
,Customer.SlipSystem.EventCount as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount
,Customer.SlipSystem.MaxGain as PossibleGain,0 as IsLive
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState with (nolock)  ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId
where Customer.SlipSystem.NewSlipTypeId in (4,5)  and Customer.SlipSystem.CustomerId=@CustomerId   and  cast(DATEADD(HOUR,+2,Customer.SlipSystem.CreateDate) as Date)>=cast(@SlipDate as Date) 
and (select Max(SlipId) from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) is not null


end
else if(@StateId=3)
begin

insert @TempTable
SELECT     TOP 30 Customer.Slip.SlipId, Customer.Slip.CreateDate, Customer.Slip.Amount, Customer.Slip.TotalOddValue, Language.[Parameter.SlipState].SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState, Language.[Parameter.SlipType].SlipType, 
					  -- CASE WHEN Customer.Slip.SlipStateId not in (4,7) THEN Customer.Slip.TotalOddValue * Customer.Slip.Amount ELSE case when Customer.Slip.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId=Customer.Slip.SlipId) else 0 end END AS Gain,
					  case when Customer.Slip.SlipStateId in (3) then   Customer.Slip.TotalOddValue * Customer.Slip.Amount else case when Customer.Slip.SlipStateId in (2) then   Customer.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock)  where SlipId=Customer.Slip.SlipId),0) else case when Customer.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashout.SlipId=Customer.Slip.SlipId) else 0 end end end as Gain,
                     Customer.Slip.EventCount AS Bets, Language.[Parameter.SlipStatu].SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount
					 ,(Customer.Slip.TotalOddValue * Customer.Slip.Amount) as PossibleGain,Customer.Slip.IsLive
                            FROM         Customer.Slip with (nolock) INNER JOIN
                             Language.[Parameter.SlipState]  with (nolock) ON   Language.[Parameter.SlipState].SlipStateId=Customer.Slip.SlipStateId and (Language.[Parameter.SlipState].LanguageId = @LangId) INNER JOIN
                      Language.[Parameter.SlipStatu] with (nolock)  ON  Language.[Parameter.SlipStatu].SlipStatuId=Customer.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId=@LangId INNER JOIN
					  Language.[Parameter.SlipType] with (nolock)  ON Language.[Parameter.SlipType].[SlipTypeId]=Customer.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId LEFT OUTER JOIN
					  Customer.Tax with (nolock)  ON Customer.Tax.SlipId=Customer.Slip.SlipId  and Customer.Tax.SlipTypeId=2
where Customer.Slip.CustomerId=@CustomerId and Language.[Parameter.SlipState].SlipStateId in (3,7) and Customer.Slip.SlipStatu in (1,3) and MONTH(DATEADD(HOUR,+2,Customer.Slip.CreateDate))=MONTH(@SlipDate) and YEAR(Customer.Slip.CreateDate)=YEAR(@SlipDate)
and Customer.Slip.SlipTypeId<3
order by Customer.Slip.SlipId desc


insert @TempTable
SELECT     TOP 30 Archive.Slip.SlipId, Archive.Slip.CreateDate, Archive.Slip.Amount, Archive.Slip.TotalOddValue, Language.[Parameter.SlipState].SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState, Language.[Parameter.SlipType].SlipType, 
					 --  CASE WHEN Archive.Slip.SlipStateId not in (4,7) THEN Archive.Slip.TotalOddValue * Archive.Slip.Amount ELSE case when Archive.Slip.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId=Archive.Slip.SlipId) else 0 end END AS Gain,
					 case when Archive.Slip.SlipStateId in (3) then   Archive.Slip.TotalOddValue * Archive.Slip.Amount  else case when Archive.Slip.SlipStateId in (2) then   Archive.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock) where SlipId=Archive.Slip.SlipId and SlipTypeId=Archive.Slip.SlipTypeId),0) else case when Archive.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashout.SlipId=Archive.Slip.SlipId) else 0 end end end AS Gain,
                      Archive.Slip.EventCount AS Bets, Language.[Parameter.SlipStatu].SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount
					  ,(Archive.Slip.TotalOddValue * Archive.Slip.Amount) as PossibleGain,Archive.Slip.IsLive
                            FROM         Archive.Slip with (nolock) INNER JOIN
                      Language.[Parameter.SlipState] with (nolock)  ON   Language.[Parameter.SlipState].SlipStateId=Archive.Slip.SlipStateId and (Language.[Parameter.SlipState].LanguageId = @LangId) INNER JOIN
                      Language.[Parameter.SlipStatu] with (nolock)  ON  Language.[Parameter.SlipStatu].SlipStatuId=Archive.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId=@LangId INNER JOIN
					  Language.[Parameter.SlipType]  with (nolock) ON Language.[Parameter.SlipType].[SlipTypeId]=Archive.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId  LEFT OUTER JOIN
					  Customer.Tax with (nolock)  ON Customer.Tax.SlipId=Archive.Slip.SlipId  and Customer.Tax.SlipTypeId=2
where Archive.Slip.CustomerId=@CustomerId and Language.[Parameter.SlipState].SlipStateId in (3,7) and Archive.Slip.SlipStatu in (1,3) and MONTH(DATEADD(HOUR,+2,Archive.Slip.CreateDate))=MONTH(@SlipDate) and YEAR(Archive.Slip.CreateDate)=YEAR(@SlipDate)
and Archive.Slip.SlipTypeId<3
order by Archive.Slip.SlipId desc



insert @TempTable
select (select Max(SlipId) from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,case when Customer.SlipSystem.NewSlipTypeId in (3,4) then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else 'Multiway' end as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip  with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip with (nolock)  where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip  with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip  with (nolock) where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip  with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0) end end as Gain
,Customer.SlipSystem.EventCount as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount
,Customer.SlipSystem.MaxGain as PossibleGain,0 as IsLive
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState  with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId
where Customer.SlipSystem.NewSlipTypeId in (3) and Customer.SlipSystem.CustomerId=@CustomerId    and Customer.SlipSystem.SlipStateId in (3,7)
and MONTH(DATEADD(HOUR,+2,Customer.SlipSystem.CreateDate))=MONTH(@SlipDate) and YEAR(Customer.SlipSystem.CreateDate)=YEAR(@SlipDate)

insert @TempTable
select (select Max(SlipId) from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,case when Customer.SlipSystem.NewSlipTypeId in (3,4) then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else 'Multiway' end as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else Customer.SlipSystem.MaxGain end end as Gain
,Customer.SlipSystem.EventCount as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax  with (nolock) where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount
,Customer.SlipSystem.MaxGain as PossibleGain,0 as IsLive
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState with (nolock)  ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId
where Customer.SlipSystem.NewSlipTypeId in (4,5) and Customer.SlipSystem.CustomerId=@CustomerId    and Customer.SlipSystem.SlipStateId  in (3,7)
and MONTH(DATEADD(HOUR,+2,Customer.SlipSystem.CreateDate))=MONTH(@SlipDate) and YEAR(Customer.SlipSystem.CreateDate)=YEAR(@SlipDate)

end
else if (@StateId=-30)
begin

insert @TempTable
SELECT    top 30 Customer.Slip.SlipId, Customer.Slip.CreateDate, Customer.Slip.Amount, Customer.Slip.TotalOddValue,  Language.[Parameter.SlipState].SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState, Language.[Parameter.SlipType].SlipType, 
                    --  CASE WHEN Customer.Slip.SlipStateId not in (4,7) THEN Customer.Slip.TotalOddValue * Customer.Slip.Amount ELSE case when Customer.Slip.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId=Customer.Slip.SlipId) else 0 end END AS Gain,
					case when Customer.Slip.SlipStateId in (3) then   Customer.Slip.TotalOddValue * Customer.Slip.Amount else case when Customer.Slip.SlipStateId in (2) then   Customer.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock)  where SlipId=Customer.Slip.SlipId),0) else case when Customer.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashout.SlipId=Customer.Slip.SlipId) else 0 end end end as Gain,
                         Customer.Slip.EventCount AS Bets, Language.[Parameter.SlipStatu].SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount
						 ,(Customer.Slip.TotalOddValue * Customer.Slip.Amount) as PossibleGain,Customer.Slip.IsLive
                            FROM         Customer.Slip with (nolock) INNER JOIN
                             Language.[Parameter.SlipState] with (nolock)  ON   Language.[Parameter.SlipState].SlipStateId=Customer.Slip.SlipStateId and (Language.[Parameter.SlipState].LanguageId = @LangId) INNER JOIN
                      Language.[Parameter.SlipStatu] with (nolock)  ON  Language.[Parameter.SlipStatu].SlipStatuId=Customer.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId=@LangId INNER JOIN
					  Language.[Parameter.SlipType] with (nolock)  ON Language.[Parameter.SlipType].[SlipTypeId]=Customer.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId LEFT OUTER JOIN
					  Customer.Tax with (nolock)  ON Customer.Tax.SlipId=Customer.Slip.SlipId  and Customer.Tax.SlipTypeId=2
where Customer.Slip.CustomerId=@CustomerId 
and Customer.Slip.SlipTypeId<3
order by Customer.Slip.SlipId desc

insert @TempTable
SELECT    top 30 Archive.Slip.SlipId, Archive.Slip.CreateDate, Archive.Slip.Amount, Archive.Slip.TotalOddValue, Language.[Parameter.SlipState].SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState, Language.[Parameter.SlipType].SlipType, 
					 --  CASE WHEN Archive.Slip.SlipStateId not in (4,7) THEN Archive.Slip.TotalOddValue * Archive.Slip.Amount ELSE case when Archive.Slip.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId=Archive.Slip.SlipId) else 0 end END AS Gain,
					 case when Archive.Slip.SlipStateId in (3) then   Archive.Slip.TotalOddValue * Archive.Slip.Amount  else case when Archive.Slip.SlipStateId in (2) then   Archive.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock) where SlipId=Archive.Slip.SlipId and SlipTypeId=Archive.Slip.SlipTypeId),0) else case when Archive.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashout.SlipId=Archive.Slip.SlipId) else 0 end end end AS Gain,
                      Archive.Slip.EventCount AS Bets, Language.[Parameter.SlipStatu].SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount
					  ,(Archive.Slip.TotalOddValue * Archive.Slip.Amount) as PossibleGain,Archive.Slip.IsLive
                            FROM         Archive.Slip with (nolock) INNER JOIN
                      Language.[Parameter.SlipState]  with (nolock) ON   Language.[Parameter.SlipState].SlipStateId=Archive.Slip.SlipStateId and (Language.[Parameter.SlipState].LanguageId = @LangId) INNER JOIN
                      Language.[Parameter.SlipStatu]  with (nolock) ON  Language.[Parameter.SlipStatu].SlipStatuId=Archive.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId=@LangId INNER JOIN
					  Language.[Parameter.SlipType]  with (nolock) ON Language.[Parameter.SlipType].[SlipTypeId]=Archive.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId  LEFT OUTER JOIN
					  Customer.Tax  with (nolock) ON Customer.Tax.SlipId=Archive.Slip.SlipId  and Customer.Tax.SlipTypeId=2
where Archive.Slip.CustomerId=@CustomerId 
and Archive.Slip.SlipTypeId<3
order by Archive.Slip.SlipId desc

insert @TempTable
select (select Max(SlipId) from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,case when Customer.SlipSystem.NewSlipTypeId in (3,4) then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else 'Multiway' end as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip  with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip with (nolock)  where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip  with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip  with (nolock) where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip  with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0) end end as Gain
,Customer.SlipSystem.EventCount as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax  with (nolock) where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount
,Customer.SlipSystem.MaxGain  as PossibleGain,0 as IsLive
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState with (nolock)  ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId
where Customer.SlipSystem.NewSlipTypeId in (3) and Customer.SlipSystem.CustomerId=@CustomerId  and (select Max(SlipId) from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) is not null


insert @TempTable
select (select Max(SlipId) from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,case when Customer.SlipSystem.NewSlipTypeId in (3,4) then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else 'Multiway' end as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut  with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip  with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else Customer.SlipSystem.MaxGain end end as Gain
,Customer.SlipSystem.EventCount as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax  with (nolock) where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount
,Customer.SlipSystem.MaxGain  as PossibleGain,0 as IsLive
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState  with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId
where Customer.SlipSystem.NewSlipTypeId in (4,5) and  Customer.SlipSystem.CustomerId=@CustomerId  and (select Max(SlipId) from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) is not null

end
else if (@StateId=-40) -- New Mobile All
begin
insert @TempTable
SELECT     TOP 30 Customer.Slip.SlipId, Customer.Slip.CreateDate, Customer.Slip.Amount, Customer.Slip.TotalOddValue, Language.[Parameter.SlipState].SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState,Language.[Parameter.SlipType].SlipType, 
                     -- CASE WHEN Customer.Slip.SlipStateId not in (4,7) THEN Customer.Slip.TotalOddValue * Customer.Slip.Amount ELSE case when Customer.Slip.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId=Customer.Slip.SlipId) else 0 end END AS Gain,
					 case when Customer.Slip.SlipStateId in (3) then   Customer.Slip.TotalOddValue * Customer.Slip.Amount else case when Customer.Slip.SlipStateId in (2) then   Customer.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock)  where SlipId=Customer.Slip.SlipId),0) else case when Customer.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashout.SlipId=Customer.Slip.SlipId) else 0 end end end as Gain,
                         Customer.Slip.EventCount AS Bets, Language.[Parameter.SlipStatu].SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount,(Customer.Slip.TotalOddValue * Customer.Slip.Amount) as PossibleGain,Customer.Slip.IsLive
FROM         Customer.Slip with (nolock) INNER JOIN
                           Language.[Parameter.SlipState] with (nolock)  ON   Language.[Parameter.SlipState].SlipStateId=Customer.Slip.SlipStateId and (Language.[Parameter.SlipState].LanguageId = @LangId) INNER JOIN
                      Language.[Parameter.SlipStatu] with (nolock)  ON  Language.[Parameter.SlipStatu].SlipStatuId=Customer.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId=@LangId INNER JOIN
					  Language.[Parameter.SlipType] with (nolock)  ON Language.[Parameter.SlipType].[SlipTypeId]=Customer.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId LEFT OUTER JOIN

					  Customer.Tax  with (nolock) ON Customer.Tax.SlipId=Customer.Slip.SlipId  and Customer.Tax.SlipTypeId=2
where Customer.Slip.CustomerId=@CustomerId and  Customer.Slip.SlipStatu in (1,3)  and MONTH(DATEADD(HOUR,+2,Customer.Slip.CreateDate))=MONTH(@SlipDate) and YEAR(Customer.Slip.CreateDate)=YEAR(@SlipDate)
and Customer.Slip.SlipTypeId<3
order by Customer.Slip.SlipId desc

insert @TempTable
SELECT     TOP 30 Archive.Slip.SlipId, Archive.Slip.CreateDate, Archive.Slip.Amount, Archive.Slip.TotalOddValue, Language.[Parameter.SlipState].SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState,Language.[Parameter.SlipType].SlipType, 
                    --  CASE WHEN Archive.Slip.SlipStateId not in (4,7) THEN Archive.Slip.TotalOddValue * Archive.Slip.Amount ELSE case when Archive.Slip.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId=Archive.Slip.SlipId) else 0 end END AS Gain,
					case when Archive.Slip.SlipStateId in (3) then   Archive.Slip.TotalOddValue * Archive.Slip.Amount  else case when Archive.Slip.SlipStateId in (2) then   Archive.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock) where SlipId=Archive.Slip.SlipId and SlipTypeId=Archive.Slip.SlipTypeId),0) else case when Archive.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashout.SlipId=Archive.Slip.SlipId) else 0 end end end AS Gain,
                          Archive.Slip.EventCount AS Bets, Language.[Parameter.SlipStatu].SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount,(Archive.Slip.TotalOddValue * Archive.Slip.Amount) as PossibleGain,Archive.Slip.IsLive
FROM         Archive.Slip with (nolock) INNER JOIN
                       Language.[Parameter.SlipState]  with (nolock) ON   Language.[Parameter.SlipState].SlipStateId=Archive.Slip.SlipStateId and (Language.[Parameter.SlipState].LanguageId = @LangId) INNER JOIN
                      Language.[Parameter.SlipStatu] with (nolock)  ON  Language.[Parameter.SlipStatu].SlipStatuId=Archive.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId=@LangId INNER JOIN
					  Language.[Parameter.SlipType] with (nolock)  ON Language.[Parameter.SlipType].[SlipTypeId]=Archive.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId   LEFT OUTER JOIN

					  Customer.Tax  with (nolock) ON Customer.Tax.SlipId=Archive.Slip.SlipId  and Customer.Tax.SlipTypeId=2
where Archive.Slip.CustomerId=@CustomerId and  Archive.Slip.SlipStatu in (1,3) and MONTH(DATEADD(HOUR,+2,Archive.Slip.CreateDate))=MONTH(@SlipDate) and YEAR(Archive.Slip.CreateDate)=YEAR(@SlipDate)
and Archive.Slip.SlipTypeId<3
order by Archive.Slip.SlipId desc



insert @TempTable
select (select Max(SlipId) from Customer.SlipSystemSlip  with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,case when Customer.SlipSystem.NewSlipTypeId in (3,4) then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else 'Multiway' end as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip with (nolock)  where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip  with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip with (nolock)  where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0) end end as Gain
,Customer.SlipSystem.EventCount as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax  with (nolock) where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount
,Customer.SlipSystem.MaxGain as PossibleGain,0 as IsLive
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState  with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId
where  Customer.SlipSystem.NewSlipTypeId in (3 ) and  Customer.SlipSystem.CustomerId=@CustomerId  and MONTH(DATEADD(HOUR,+2,Customer.SlipSystem.CreateDate))=MONTH(@SlipDate) and YEAR(Customer.SlipSystem.CreateDate)=YEAR(@SlipDate)

insert @TempTable
select (select Max(SlipId) from Customer.SlipSystemSlip  with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,case when Customer.SlipSystem.NewSlipTypeId in (3,4) then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else 'Multiway' end as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else Customer.SlipSystem.MaxGain end end as Gain
,Customer.SlipSystem.EventCount as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount
,Customer.SlipSystem.MaxGain as PossibleGain,0 as IsLive
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState  with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId
where  Customer.SlipSystem.NewSlipTypeId in (4,5) and  Customer.SlipSystem.CustomerId=@CustomerId  and MONTH(DATEADD(HOUR,+2,Customer.SlipSystem.CreateDate))=MONTH(@SlipDate) and YEAR(Customer.SlipSystem.CreateDate)=YEAR(@SlipDate)



end
else
begin

insert @TempTable
SELECT     TOP 30 Customer.Slip.SlipId, Customer.Slip.CreateDate, Customer.Slip.Amount, Customer.Slip.TotalOddValue, Language.[Parameter.SlipState].SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState, Language.[Parameter.SlipType].SlipType, 
					 --  CASE WHEN Customer.Slip.SlipStateId not in (4,7) THEN Customer.Slip.TotalOddValue * Customer.Slip.Amount ELSE case when Customer.Slip.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId=Customer.Slip.SlipId) else 0 end END AS Gain,
					case when Customer.Slip.SlipStateId in (3) then   Customer.Slip.TotalOddValue * Customer.Slip.Amount else case when Customer.Slip.SlipStateId in (2) then   Customer.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock)  where SlipId=Customer.Slip.SlipId),0) else case when Customer.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashout.SlipId=Customer.Slip.SlipId) else 0 end end end as Gain,
                     Customer.Slip.EventCount AS Bets, Language.[Parameter.SlipStatu].SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount
					 ,(Customer.Slip.TotalOddValue * Customer.Slip.Amount) as PossibleGain,Customer.Slip.IsLive
                            FROM         Customer.Slip with (nolock) INNER JOIN
                        Language.[Parameter.SlipState]  with (nolock) ON   Language.[Parameter.SlipState].SlipStateId=Customer.Slip.SlipStateId and (Language.[Parameter.SlipState].LanguageId = @LangId) INNER JOIN
                      Language.[Parameter.SlipStatu] with (nolock)  ON  Language.[Parameter.SlipStatu].SlipStatuId=Customer.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId=@LangId INNER JOIN
					  Language.[Parameter.SlipType] with (nolock)  ON Language.[Parameter.SlipType].[SlipTypeId]=Customer.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId LEFT OUTER JOIN
					  Customer.Tax with (nolock)  ON Customer.Tax.SlipId=Customer.Slip.SlipId  and Customer.Tax.SlipTypeId=2
where Customer.Slip.CustomerId=@CustomerId and Language.[Parameter.SlipState].SlipStateId =@StateId and Customer.Slip.SlipStatu in (1,3) and MONTH(Customer.Slip.CreateDate)=MONTH(@SlipDate) and YEAR(Customer.Slip.CreateDate)=YEAR(@SlipDate)
and Customer.Slip.SlipTypeId<3
order by Customer.Slip.SlipId desc


insert @TempTable
SELECT     TOP 30 Archive.Slip.SlipId, Archive.Slip.CreateDate, Archive.Slip.Amount, Archive.Slip.TotalOddValue, Language.[Parameter.SlipState].SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState, Language.[Parameter.SlipType].SlipType, 
					 --  CASE WHEN Archive.Slip.SlipStateId not in (4,7) THEN Archive.Slip.TotalOddValue * Archive.Slip.Amount ELSE case when Archive.Slip.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId=Archive.Slip.SlipId) else 0 end END AS Gain,
					 case when Archive.Slip.SlipStateId in (3) then   Archive.Slip.TotalOddValue * Archive.Slip.Amount  else case when Archive.Slip.SlipStateId in (2) then   Archive.Slip.Amount +ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock) where SlipId=Archive.Slip.SlipId and SlipTypeId=Archive.Slip.SlipTypeId),0) else case when Archive.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashout.SlipId=Archive.Slip.SlipId) else 0 end end end AS Gain,
                      Archive.Slip.EventCount AS Bets, Language.[Parameter.SlipStatu].SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount
					  ,(Archive.Slip.TotalOddValue * Archive.Slip.Amount) as PossibleGain,Archive.Slip.IsLive
                            FROM         Archive.Slip with (nolock) INNER JOIN
                      Language.[Parameter.SlipState] with (nolock)  ON   Language.[Parameter.SlipState].SlipStateId=Archive.Slip.SlipStateId and (Language.[Parameter.SlipState].LanguageId = @LangId) INNER JOIN
                      Language.[Parameter.SlipStatu] with (nolock)  ON  Language.[Parameter.SlipStatu].SlipStatuId=Archive.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId=@LangId INNER JOIN
					  Language.[Parameter.SlipType] with (nolock)  ON Language.[Parameter.SlipType].[SlipTypeId]=Archive.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId   LEFT OUTER JOIN
					  Customer.Tax  with (nolock) ON Customer.Tax.SlipId=Archive.Slip.SlipId  and Customer.Tax.SlipTypeId=2
where Archive.Slip.CustomerId=@CustomerId and Language.[Parameter.SlipState].SlipStateId =@StateId and Archive.Slip.SlipStatu in (1,3) and MONTH(Archive.Slip.CreateDate)=MONTH(@SlipDate) and YEAR(Archive.Slip.CreateDate)=YEAR(@SlipDate)
and Archive.Slip.SlipTypeId<3
order by Archive.Slip.SlipId desc



insert @TempTable
select (select Max(SlipId) from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,case when Customer.SlipSystem.NewSlipTypeId in (3,4) then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else 'Multiway' end as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip  with (nolock) where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip  with (nolock) where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip  with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0) end end as Gain
,Customer.SlipSystem.EventCount as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount
,Customer.SlipSystem.MaxGain as PossibleGain,0 as IsLive
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState with (nolock)  ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId
where Customer.SlipSystem.NewSlipTypeId in (3)  and Customer.SlipSystem.CustomerId=@CustomerId    and Customer.SlipSystem.SlipStateId=@StateId
and MONTH(DATEADD(HOUR,+2,Customer.SlipSystem.CreateDate))=MONTH(@SlipDate) and YEAR(Customer.SlipSystem.CreateDate)=YEAR(@SlipDate)


insert @TempTable
select (select Max(SlipId) from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,case when Customer.SlipSystem.NewSlipTypeId in (3,4) then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else 'Multiway' end as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then 0 else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else Customer.SlipSystem.MaxGain end end as Gain
,Customer.SlipSystem.EventCount as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax  with (nolock) where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and Customer.Tax.SlipTypeId=3),0) as TaxAmount
,Customer.SlipSystem.MaxGain as PossibleGain,0 as IsLive
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState with (nolock)  ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId
where Customer.SlipSystem.NewSlipTypeId in (4,5)  and  Customer.SlipSystem.CustomerId=@CustomerId    and Customer.SlipSystem.SlipStateId=@StateId
and MONTH(DATEADD(HOUR,+2,Customer.SlipSystem.CreateDate))=MONTH(@SlipDate) and YEAR(Customer.SlipSystem.CreateDate)=YEAR(@SlipDate)

end

select SlipId ,CreateDate ,Amount ,TotalOddValue ,StateId ,SlipState,SlipType ,Gain ,Bets ,SlipStatu ,TaxAmount ,PossibleGain ,IsLive 
From @TempTable order by CreateDate desc

END
GO
