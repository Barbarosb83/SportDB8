USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Report].[ProcVFLReportFill]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Report].[ProcVFLReportFill] 
AS

BEGIN
SET NOCOUNT ON;


declare @StartDate date
declare @EndDate date
declare @SystemCurrencyId int




select top 1 @StartDate=ISNULL(DATEADD(D,1,Report.VFLReport.ReportDate),DATEADD(DAY,-1,GETDATE())) from Report.VFLReport 
order by  Report.VFLReport.ReportDate desc

if(@StartDate is null)
		set @StartDate=DATEADD(DAY,-1,GETDATE())

if(@StartDate>=GETDATE())
	set @StartDate=DATEADD(DAY,-1,GETDATE())





set @SystemCurrencyId=3

IF EXISTS (select  Report.VFLReport.VSReportId from  Report.VFLReport where  Report.VFLReport.ReportDate=@StartDate)
		delete from Report.VFLReport where ReportDate=@StartDate

insert Report.VFLReport (TurnOver,BetsCount,VFLSeason,SourceId,ReportDate,BetGain,IsSingle)
SELECT  ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.SlipOdd.Amount),Customer.SlipOdd.CurrencyId,3),0) 
, COUNT(Customer.SlipOdd.SlipOddId) 
, Virtual.Event.TournamentName 
, Customer.Slip.SourceId,cast(Customer.Slip.CreateDate as date),
ISNULL((SELECT  ISNULL(dbo.FuncCurrencyConverter(SUM(cso.Amount*cso.OddValue),cso.CurrencyId,3),0)
FROM         Customer.Slip as cs with (nolock) INNER JOIN
                      Customer.SlipOdd as cso with (nolock) ON cs.SlipId = cso.SlipId INNER JOIN
                      Virtual.Event as VET ON cso.MatchId = VET.EventId
    where cs.SlipId in (select Customer.SlipOdd.SlipId
FROM         Customer.SlipOdd with (nolock)
                      where Customer.SlipOdd.BetTypeId=3
                      GROUP BY Customer.SlipOdd.SlipId
HAVING COUNT(Customer.SlipOdd.SlipId)<2 ) and cast(cs.CreateDate as date)=CAST(@StartDate as date) and cs.SlipStateId=3 and VET.TournamentName=Virtual.Event.TournamentName
GROUP BY VET.TournamentName,cso.CurrencyId),0), 1

FROM         Customer.Slip with (nolock) INNER JOIN
                      Customer.SlipOdd with (nolock) ON Customer.Slip.SlipId = Customer.SlipOdd.SlipId INNER JOIN
                      Virtual.Event ON Customer.SlipOdd.MatchId = Virtual.Event.EventId
    where Customer.Slip.SlipId in (select Customer.SlipOdd.SlipId
FROM         Customer.SlipOdd
                      where Customer.SlipOdd.BetTypeId=3
                      GROUP BY Customer.SlipOdd.SlipId
HAVING COUNT(Customer.SlipOdd.SlipId)<2 ) and cast(Customer.Slip.CreateDate as date)=CAST(@StartDate as date)
GROUP BY Virtual.Event.TournamentName
, Customer.Slip.SourceId  ,Customer.SlipOdd.CurrencyId,cast(Customer.Slip.CreateDate as date)




insert Report.VFLReport (TurnOver,BetsCount,VFLSeason,SourceId,ReportDate,BetGain,IsSingle)
SELECT  ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.SlipOdd.Amount),Customer.SlipOdd.CurrencyId,3),0) 
, COUNT(Customer.SlipOdd.SlipOddId) 
, Virtual.Event.TournamentName 
, Customer.Slip.SourceId,cast(Customer.Slip.CreateDate as date),
ISNULL((SELECT  ISNULL(dbo.FuncCurrencyConverter(SUM(cso.Amount*cso.OddValue),cso.CurrencyId,3),0)
FROM         Customer.Slip as cs with (nolock) INNER JOIN
                      Customer.SlipOdd as cso with (nolock) ON cs.SlipId = cso.SlipId INNER JOIN
                      Virtual.Event as VET ON cso.MatchId = VET.EventId
    where cs.SlipId in (select Customer.SlipOdd.SlipId
FROM         Customer.SlipOdd with (nolock)
                      where Customer.SlipOdd.BetTypeId=3
                      GROUP BY Customer.SlipOdd.SlipId
HAVING COUNT(Customer.SlipOdd.SlipId)>1 ) and cast(cs.CreateDate as date)=CAST(@StartDate as date) and cs.SlipStateId=3 and VET.TournamentName=Virtual.Event.TournamentName
GROUP BY VET.TournamentName,cso.CurrencyId),0), 0

FROM         Customer.Slip with (nolock) INNER JOIN
                      Customer.SlipOdd with (nolock) ON Customer.Slip.SlipId = Customer.SlipOdd.SlipId INNER JOIN
                      Virtual.Event ON Customer.SlipOdd.MatchId = Virtual.Event.EventId
    where Customer.Slip.SlipId in (select Customer.SlipOdd.SlipId
FROM         Customer.SlipOdd with (nolock)
                      where Customer.SlipOdd.BetTypeId=3
                      GROUP BY Customer.SlipOdd.SlipId
HAVING COUNT(Customer.SlipOdd.SlipId)>1 ) and cast(Customer.Slip.CreateDate as date)=CAST(@StartDate as date)
GROUP BY Virtual.Event.TournamentName
, Customer.Slip.SourceId  ,Customer.SlipOdd.CurrencyId,cast(Customer.Slip.CreateDate as date)



if(@@ROWCOUNT=0)
begin
insert Report.VFLReport (ReportDate)
select @StartDate

end

END


GO
