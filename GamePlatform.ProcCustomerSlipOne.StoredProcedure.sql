USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerSlipOne]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [GamePlatform].[ProcCustomerSlipOne] 
@SlipId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;


declare @TempTable table (SlipId bigint,CreateDate datetime,Amount money,TotalOddValue float,StateId int,SlipState nvarchar(50),SlipType nvarchar(50),Gain float,Bets int,SlipStatu nvarchar(50),TaxAmount money,PossibleGain float,IsLive bit,EvaluateDate datetime)

 
insert @TempTable
SELECT     TOP 30 Customer.Slip.SlipId, Customer.Slip.CreateDate, Customer.Slip.Amount, Customer.Slip.TotalOddValue, Language.[Parameter.SlipState].SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState,Language.[Parameter.SlipType].SlipType, 
                      CASE WHEN Customer.Slip.SlipStateId not in (4,7) THEN Customer.Slip.TotalOddValue * Customer.Slip.Amount ELSE case when Customer.Slip.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId=Customer.Slip.SlipId) else 0 end END AS Gain,
                         cast(1 as int) AS Bets, cast(Customer.Slip.Amount as nvarchar(50)) as SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount,(Customer.Slip.TotalOddValue * Customer.Slip.Amount) as PossibleGain,Customer.Slip.IsLive
						 ,Customer.Slip.EvaluateDate 
FROM         Customer.Slip with (nolock) INNER JOIN
                      Language.[Parameter.SlipState] with (nolock) ON   Language.[Parameter.SlipState].SlipStateId=Customer.Slip.SlipStateId and Language.[Parameter.SlipState].LanguageId =@LangId INNER JOIN
                      Language.[Parameter.SlipStatu] with (nolock) ON Language.[Parameter.SlipStatu].SlipStatuId=Customer.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId=@LangId INNER JOIN
					  Language.[Parameter.SlipType] ON Language.[Parameter.SlipType].[SlipTypeId]=Customer.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId LEFT OUTER JOIN
					  Customer.Tax with (nolock)  ON Customer.Tax.SlipId=Customer.Slip.SlipId and Customer.Tax.SlipTypeId=2
where Customer.Slip.SlipId=@SlipId 
and Customer.Slip.SlipTypeId<3
order by Customer.Slip.SlipId desc

insert @TempTable
SELECT     TOP 30 Archive.Slip.SlipId, Archive.Slip.CreateDate, Archive.Slip.Amount, Archive.Slip.TotalOddValue, Archive.Slip.SlipStateId as StateId, 
                      Language.[Parameter.SlipState].SlipState,Language.[Parameter.SlipType].SlipType, 
                      CASE WHEN Archive.Slip.SlipStateId not in (4,7) THEN Archive.Slip.TotalOddValue * Archive.Slip.Amount ELSE case when Archive.Slip.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId=Archive.Slip.SlipId) else 0 end END AS Gain,
                            cast(1 as int) AS Bets, cast(Archive.Slip.Amount as nvarchar(50)) as SlipStatu,ISNULL(Customer.Tax.TaxAmount,0) as TaxAmount,(Archive.Slip.TotalOddValue * Archive.Slip.Amount) as PossibleGain,Archive.Slip.IsLive
							,Archive.Slip.EvaluateDate 
FROM         Archive.Slip with (nolock) INNER JOIN
                      Language.[Parameter.SlipState] with (nolock) ON   Language.[Parameter.SlipState].SlipStateId=Archive.Slip.SlipStateId and Language.[Parameter.SlipState].LanguageId =@LangId INNER JOIN
                      Language.[Parameter.SlipStatu] with (nolock) ON Language.[Parameter.SlipStatu].SlipStatuId=Archive.Slip.SlipStatu AND Language.[Parameter.SlipStatu].LanguageId=@LangId INNER JOIN
					  Language.[Parameter.SlipType] ON Language.[Parameter.SlipType].[SlipTypeId]=Archive.Slip.SlipTypeId AND Language.[Parameter.SlipType].LanguageId= @LangId LEFT OUTER JOIN
					  Customer.Tax with (nolock) ON Customer.Tax.SlipId=Archive.Slip.SlipId  and Customer.Tax.SlipTypeId=2
where Archive.Slip.SlipId=@SlipId
and Archive.Slip.SlipTypeId<3
order by Archive.Slip.SlipId desc



insert @TempTable
select (select Max(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,case when Customer.SlipSystem.NewSlipTypeId in (3) then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else 'Multiway' end as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0) end end as Gain
,Customer.SlipSystem.CouponCount as Bets
,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System])) else Customer.SlipSystem.[System] end 
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock) where Customer.Tax.SlipId=Customer.SlipSystem.SystemSlipId and SlipTypeId=3),0) as TaxAmount
,Customer.SlipSystem.MaxGain as PossibleGain,0 as IsLive
,Customer.SlipSystem.EvaluateDate 
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId
where  Customer.SlipSystem.NewSlipTypeId in (3) and Customer.SlipSystem.SystemSlipId in (Select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)

insert @TempTable
select (select Max(SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId
,Customer.SlipSystem.CreateDate
,Customer.SlipSystem.Amount
,Customer.SlipSystem.TotalOddValue  as TotalOddValue
,Customer.SlipSystem.SlipStateId as StateId
,Parameter.SlipState.[State] as SlipState
,case when Customer.SlipSystem.NewSlipTypeId in (4) then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' System' else 'Multiway' end as SlipType
,case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else Customer.SlipSystem.MaxGain end end as Gain
,Customer.SlipSystem.CouponCount as Bets
,case when (select COUNT(*) from Customer.Slip with (nolock) where SlipId=(select top 1 SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId))>0  then cast((select Customer.Slip.Amount from Customer.Slip with (nolock) where SlipId=(select top 1 SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) as nvarchar(50)) else cast((select Archive.Slip.Amount from Archive.Slip with (nolock) where SlipId=(select top 1 SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) as nvarchar(50)) end
,ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock) where Customer.Tax.SlipId=Customer.SlipSystem.SystemSlipId and SlipTypeId=3),0) as TaxAmount
,Customer.SlipSystem.MaxGain as PossibleGain,0 as IsLive,Customer.SlipSystem.EvaluateDate 
from Customer.SlipSystem with (nolock) INNER JOIN Parameter.SlipState ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId
where Customer.SlipSystem.NewSlipTypeId in (4,5) and Customer.SlipSystem.SystemSlipId in (Select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)

 

select *
From @TempTable order by CreateDate desc

END
GO
