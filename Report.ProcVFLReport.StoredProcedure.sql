USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Report].[ProcVFLReport]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Report].[ProcVFLReport]
 @ViewType int, --0 günlük,1 aylık , 2 yıllık
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100)

AS

BEGIN
SET NOCOUNT ON;



declare @tempTable table (ReportDate date,VFLSeason nvarchar(50),SourceId int,BetsCount int,TurnOver money,BetGain money,VFLSeasonCombi nvarchar(50),SourceIdCombi int,BetsCountCombi int,TurnOverCombi money,BetGainCombi money)


insert @tempTable (ReportDate,VFLSeason,SourceId,BetsCount,TurnOver,BetGain)
select ReportDate,VFLSeason,SourceId,BetsCount,TurnOver,BetGain
from Report.VFLReport
where IsSingle=1 and VFLSeason is not null
ORDER BY ReportDate

declare @tempTable2 table (ReportDate date,VFLSeason nvarchar(50),SourceId int,BetsCount int,TurnOver money,BetGain money,VFLSeasonCombi nvarchar(50),SourceIdCombi int,BetsCountCombi int,TurnOverCombi money,BetGainCombi money)

insert @tempTable2 (ReportDate,VFLSeason,SourceId,BetsCountCombi,TurnOverCombi,BetGainCombi)
select DISTINCT Report.VFLReport.ReportDate,Report.VFLReport.VFLSeason,Report.VFLReport.SourceId,Report.VFLReport.BetsCount,Report.VFLReport.TurnOver,Report.VFLReport.BetGain
from Report.VFLReport 
--inner join 
--	@tempTable as tmp ON Report.VFLReport.ReportDate=tmp.ReportDate and Report.VFLReport.SourceId=tmp.SourceId
where IsSingle=0 and Report.VFLReport.VFLSeason is not null and Report.VFLReport.VFLSeason not in (select VFLSeason from @tempTable where ReportDate=Report.VFLReport.ReportDate and SourceId=Report.VFLReport.SourceId )
ORDER BY ReportDate



declare @VFLSeason nvarchar(50)
declare @ReportDate date
declare @SourceId int
declare @BetsCount int
declare @TurnOver money
declare @BetGain money


declare @BetsCountCombi int
declare @TurnOverCombi money
declare @BetGainCombi money

declare @sqlcommand nvarchar(max)
declare @sqlcommand2 nvarchar(max)


set nocount on
				declare cur cursor local for(
						select ReportDate,VFLSeason,SourceId,BetsCount,TurnOver,BetGain from @temptable 

				)
				open cur
					fetch next from cur into @ReportDate,@VFLSeason,@SourceId,@BetsCount,@TurnOver,@BetGain
						while @@fetch_status=0
							begin
								begin
								
								select 	@BetsCountCombi=ISNULL(BetsCount,0)
								,@TurnOverCombi=ISNULL(TurnOver,0),@BetGainCombi=ISNULL(BetGain,0)
								from Report.VFLReport
								where ReportDate=@ReportDate and VFLSeason=@VFLSeason
								and SourceId=@SourceId and IsSingle=0
								
								update @tempTable set BetsCountCombi=@BetsCountCombi,TurnOverCombi=@TurnOverCombi,BetGainCombi=@BetGainCombi
								where ReportDate=@ReportDate and VFLSeason=@VFLSeason
								and SourceId=@SourceId 
								
								
								
								end
							fetch next from cur into  @ReportDate,@VFLSeason,@SourceId,@BetsCount,@TurnOver,@BetGain
							end
				close cur
				deallocate cur

--declare @virtualreporttable table(ReportDate date,VFLSeason nvarchar(50),SourceId int,BetsCount int,TurnOver money,HouseHold money,Margin float,BetsCountSingle int,TurnOverSingle money,HouseHoldSingle money,MarginSingle float,BetsCountCombi int,TurnOverCombi money,HouseHoldCombi money,MarginCombi float)

insert Report.VirtualReportTemp
select ROW_NUMBER() OVER(ORDER BY ReportDate),ReportDate ,VFLSeason ,SourceId ,(ISNULL(BetsCount,0)+ISNULL(BetsCountCombi,0)) as BetCount,ISNULL(TurnOver,0)+ISNULL(TurnOverCombi,0) as TurnOver,((ISNULL(TurnOver,0)+ISNULL(TurnOverCombi,0))-(ISNULL(BetGain,0)+ISNULL(BetGainCombi,0))) as HouseHold,(((ISNULL(TurnOver,0.0001)+ISNULL(TurnOverCombi,0.0001))-(ISNULL(BetGain,0.0001)+ISNULL(BetGainCombi,0.0001)))/(ISNULL(TurnOver,0.0001)+ISNULL(TurnOverCombi,0.0001)))*100 as Margin,ISNULL(BetsCount,0) as BetCountSingle ,ISNULL(TurnOver,0) As TurnOverSingle ,(ISNULL(TurnOver,0)-ISNULL(BetGain,0)) as HouseHoldSingle,((ISNULL(TurnOver,0.0001)-ISNULL(BetGain,0.0001))/ISNULL(TurnOver,0.0001))*100 as MarginSingle ,ISNULL(BetsCountCombi,0) as BetsCountCombi ,ISNULL(TurnOverCombi,0) as TurnOverCombi ,(ISNULL(TurnOverCombi,0)-ISNULL(BetGainCombi,0) ) as HouseHoldCombi,((ISNULL(TurnOverCombi,0.0001)-ISNULL(BetGainCombi,0.0001))/ISNULL(TurnOverCombi,0.0001))*100 as MarginSingle
from @tempTable
UNION ALL
select ROW_NUMBER() OVER(ORDER BY ReportDate),ReportDate ,VFLSeason ,SourceId ,(ISNULL(BetsCount,0)+ISNULL(BetsCountCombi,0)) as BetCount,ISNULL(TurnOver,0)+ISNULL(TurnOverCombi,0) as TurnOver,((ISNULL(TurnOver,0)+ISNULL(TurnOverCombi,0))-(ISNULL(BetGain,0)+ISNULL(BetGainCombi,0))) as HouseHold,(((ISNULL(TurnOver,0.0001)+ISNULL(TurnOverCombi,0.0001))-(ISNULL(BetGain,0.0001)+ISNULL(BetGainCombi,0.0001)))/(ISNULL(TurnOver,0.0001)+ISNULL(TurnOverCombi,0.0001)))*100 as Margin,ISNULL(BetsCount,0) as BetCountSingle ,ISNULL(TurnOver,0) As TurnOverSingle ,(ISNULL(TurnOver,0)-ISNULL(BetGain,0)) as HouseHoldSingle,((ISNULL(TurnOver,0.0001)-ISNULL(BetGain,0.0001))/ISNULL(TurnOver,0.0001))*100 as MarginSingle ,ISNULL(BetsCountCombi,0) as BetsCountCombi ,ISNULL(TurnOverCombi,0) as TurnOverCombi ,(ISNULL(TurnOverCombi,0)-ISNULL(BetGainCombi,0) ) as HouseHoldCombi,((ISNULL(TurnOverCombi,0.0001)-ISNULL(BetGainCombi,0.0001))/ISNULL(TurnOverCombi,0.0001))*100 as MarginSingle
from @tempTable2





--select ROW_NUMBER() OVER(ORDER BY ReportDate) AS RowNum,0 as totalrow,ReportDate ,VFLSeason ,Parameter.Source.Source,BetsCount ,TurnOver ,HouseHold ,Margin ,BetsCountSingle ,TurnOverSingle ,HouseHoldSingle ,MarginSingle ,BetsCountCombi ,TurnOverCombi ,HouseHoldCombi ,MarginCombi
--from @virtualreporttable as vrt INNER JOIN 
--Parameter.Source on Parameter.Source.SourceId=vrt.SourceId
--order by ReportDate



-- set @sqlcommand2=' declare @virtualreporttable table(ReportDate date,VFLSeason nvarchar(50),SourceId int,BetsCount int,TurnOver money,HouseHold money,Margin float,BetsCountSingle int,TurnOverSingle money,HouseHoldSingle money,MarginSingle float,BetsCountCombi int,TurnOverCombi money,HouseHoldCombi money,MarginCombi float) '+
--  'insert @virtualreporttable '+
--  'select ReportDate ,VFLSeason ,SourceId ,(ISNULL(BetsCount,0)+ISNULL(BetsCountCombi,0)) as BetCount,ISNULL(TurnOver,0)+ISNULL(TurnOverCombi,0) as TurnOver,((ISNULL(TurnOver,0)+ISNULL(TurnOverCombi,0))-(ISNULL(BetGain,0)+ISNULL(BetGainCombi,0))) as HouseHold,(((ISNULL(TurnOver,0.0001)+ISNULL(TurnOverCombi,0.0001))-(ISNULL(BetGain,0.0001)+ISNULL(BetGainCombi,0.0001)))/(ISNULL(TurnOver,0.0001)+ISNULL(TurnOverCombi,0.0001)))*100 as Margin,ISNULL(BetsCount,0) as BetCountSingle ,ISNULL(TurnOver,0) As TurnOverSingle ,(ISNULL(TurnOver,0)-ISNULL(BetGain,0)) as HouseHoldSingle,((ISNULL(TurnOver,0.0001)-ISNULL(BetGain,0.0001))/ISNULL(TurnOver,0.0001))*100 as MarginSingle ,ISNULL(BetsCountCombi,0) as BetsCountCombi ,ISNULL(TurnOverCombi,0) as TurnOverCombi ,(ISNULL(TurnOverCombi,0)-ISNULL(BetGainCombi,0) ) as HouseHoldCombi,((ISNULL(TurnOverCombi,0.0001)-ISNULL(BetGainCombi,0.0001))/ISNULL(TurnOverCombi,0.0001))*100 as MarginSingle
--from @tempTable
--UNION ALL
--select ReportDate ,VFLSeason ,SourceId ,(ISNULL(BetsCount,0)+ISNULL(BetsCountCombi,0)) as BetCount,ISNULL(TurnOver,0)+ISNULL(TurnOverCombi,0) as TurnOver,((ISNULL(TurnOver,0)+ISNULL(TurnOverCombi,0))-(ISNULL(BetGain,0)+ISNULL(BetGainCombi,0))) as HouseHold,(((ISNULL(TurnOver,0.0001)+ISNULL(TurnOverCombi,0.0001))-(ISNULL(BetGain,0.0001)+ISNULL(BetGainCombi,0.0001)))/(ISNULL(TurnOver,0.0001)+ISNULL(TurnOverCombi,0.0001)))*100 as Margin,ISNULL(BetsCount,0) as BetCountSingle ,ISNULL(TurnOver,0) As TurnOverSingle ,(ISNULL(TurnOver,0)-ISNULL(BetGain,0)) as HouseHoldSingle,((ISNULL(TurnOver,0.0001)-ISNULL(BetGain,0.0001))/ISNULL(TurnOver,0.0001))*100 as MarginSingle ,ISNULL(BetsCountCombi,0) as BetsCountCombi ,ISNULL(TurnOverCombi,0) as TurnOverCombi ,(ISNULL(TurnOverCombi,0)-ISNULL(BetGainCombi,0) ) as HouseHoldCombi,((ISNULL(TurnOverCombi,0.0001)-ISNULL(BetGainCombi,0.0001))/ISNULL(TurnOverCombi,0.0001))*100 as MarginSingle
--from @tempTable2 ; '
  
  
  
  set @sqlcommand='declare @total int '+
'select @total=COUNT(ReportDate)  '+
' from Report.VirtualReportTemp as vrt INNER JOIN 
Parameter.Source on Parameter.Source.SourceId=vrt.SourceId
 WHERE    '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
' ReportDate ,VFLSeason ,Parameter.Source.Source,BetsCount ,TurnOver ,HouseHold ,Margin ,BetsCountSingle ,TurnOverSingle ,HouseHoldSingle ,MarginSingle ,BetsCountCombi ,TurnOverCombi ,HouseHoldCombi ,MarginCombi '+
'from Report.VirtualReportTemp as vrt INNER JOIN 
Parameter.Source on Parameter.Source.SourceId=vrt.SourceId
WHERE     '+@where +' '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

  
execute (@sqlcommand2+@sqlcommand)

delete from Report.VirtualReportTemp


END


GO
