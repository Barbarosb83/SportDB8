USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSlipReport_OLD]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcSlipReport_OLD] 
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(max),
@orderby nvarchar(200)
AS
BEGIN
SET NOCOUNT ON;

--insert dbo.betslip (data,CreateDate) values (@where,GETDATE())

declare @sqlcommand nvarchar(max)=''
declare @sqlcommand1 nvarchar(max)=''
declare @sqlcommand2 nvarchar(max)=''
declare @sqlcommand3 nvarchar(max)=''
declare @UserCurrencyId int
declare @BranchId int
declare @where2 nvarchar(max)=' and 1=1'
  declare @sqlcommand4 nvarchar(max)=''
  declare @sqlcommand5 nvarchar(max)=''
  declare @sqlcommand6 nvarchar(max)=''
    declare @sqlcommand55 nvarchar(max)=''
  declare @sqlcommand66 nvarchar(max)=''
   declare @sqlcommand06 nvarchar(max)=''
  declare @sqlcommand7 nvarchar(max)=''
  declare @where3 nvarchar(max)=''
select @BranchId=Users.Users.UnitCode, @UserCurrencyId=Users.Users.CurrencyId from Users.Users with (nolock) where Users.Users.UserName=@Username

if (CHARINDEX('m:',@where) > 0)
set @where=@where+')'
if (CHARINDEX('b:',@where) > 0)
set @where=@where+')'

if(@BranchId<>1)
	begin

	set @where2=' and (Customer.Customer.BranchId='+cast(@BranchId as nvarchar(7))+' or Customer.Customer.BranchId in (select BranchId from Parameter.Branch with (nolock) where Parameter.Branch.[ParentBranchId]='+cast(@BranchId as nvarchar(7))+') or Customer.Customer.BranchId in (select BranchId from Parameter.Branch with (nolock) where ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where Parameter.Branch.[ParentBranchId]='+cast(@BranchId as nvarchar(7))+')))' -- Customer.Customer.BranchId='+cast(@BranchId as nvarchar(7))

	end

	
if(@orderby='Customer.Slip.CreateDate desc')
	set @orderby=REPLACE(@orderby,'Customer.Slip.CreateDate','CreateDate')
else if(@orderby='Customer.Slip.CreateDate asc')
	set @orderby=REPLACE(@orderby,'Customer.Slip.CreateDate','CreateDate')

if (CHARINDEX('Customer.Slip',@orderby) > 0)
	set @orderby=REPLACE(@orderby,'Customer.Slip.','')


declare @sqlcommand0 nvarchar(max)=''
set @sqlcommand0=' declare @temptable table (RowNum bigint,SlipId bigint,CustomerId bigint,CustomerName nvarchar(150),Amount money,TotalOddValue float,StateId int,State nvarchar(20),CreateDate datetime,SourceId int,Source nvarchar(20),OddCount int,SlipType nvarchar(50),SlipTypeId int,SlipStateStatuColor nvarchar(20),MaxGain float,CurrencyId int,Currency nvarchar(20),SlipStatu nvarchar(20),totalrow int,AmountStatuColor nvarchar(20),EvaluateDate datetime)'

if (CHARINDEX('m:ol',@where) > 0)
begin


set @sqlcommand='declare @total int '+
' select @total=COUNT(DISTINCT Customer.Slip.SlipId) '+
'FROM Customer.Customer with (nolock) INNER JOIN '+
                      'Customer.Slip with (nolock) ON Customer.Customer.CustomerId = Customer.Slip.CustomerId INNER JOIN '+
                      --'Customer.SlipOdd ON Customer.Slip.SlipId = Customer.SlipOdd.SlipId INNER JOIN '+
                      'Parameter.SlipState with (nolock) ON Customer.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN '+
                      'Parameter.Source with (nolock) ON Customer.Slip.SourceId = Parameter.Source.SourceId INNER JOIN '+
                      'Parameter.SlipType with (nolock) ON Customer.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN '+
                       'Parameter.SlipStatu with (nolock) ON Customer.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
                      'Parameter.Currency with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+
' WHERE Customer.Slip.SlipStateId=1  and Customer.Slip.SlipTypeId<3  and  Customer.Slip.SlipId in (select SlipId from Customer.SlipOdd where BetTypeId<>2  and EventDate<DATEADD(MINUTE,-120,GETDATE()) and StateId=1); '+
' WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.Slip.SlipId) AS RowNum, '+
'  Customer.Slip.SlipId, Customer.Slip.CustomerId, '+
                      'Customer.Customer.CustomerName + '' '' + Customer.Customer.CustomerSurname + '' ( '' + case when (Customer.Customer.IsTerminalCustomer=1 or Customer.Customer.IsBranchCustomer=1) then (select BrancName From Parameter.Branch with (nolock) where BranchId = (Select ParentBranchId from Parameter.Branch with (nolock) where BranchId=Customer.Customer.BranchId)) else Customer.Customer.Username end + '' ) '' AS CustomerName, '+
                      ' Customer.Slip.Amount  as Amount, Customer.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.Slip.CreateDate  as CreateDate, Parameter.Source.SourceId, '+
                      'Parameter.Source.Source, ISNULL(Customer.Slip.EventCount,0) AS OddCount,case when Customer.Slip.IsLive=1 then '' * '' else '''' end+'' ''+ Parameter.SlipType.SlipType as SlipType, Customer.Slip.SlipTypeId, '+
                      'Parameter.SlipState.StatuColor AS SlipStateStatuColor,cast( Customer.Slip.Amount * Customer.Slip.TotalOddValue as float) AS MaxGain, Customer.Customer.CurrencyId, '+
                      'Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,Customer.Slip.EvaluateDate '
set @sqlcommand1='FROM  Customer.Customer with (nolock) INNER JOIN '+
                      ' Customer.Slip with (nolock) ON Customer.Customer.CustomerId = Customer.Slip.CustomerId INNER JOIN '+
                     -- ' Customer.SlipOdd ON Customer.Slip.SlipId = Customer.SlipOdd.SlipId INNER JOIN '+
                      'Parameter.SlipState with (nolock) ON Customer.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN '+
                      'Parameter.Source with (nolock) ON Customer.Slip.SourceId = Parameter.Source.SourceId INNER JOIN '+
                      'Parameter.SlipType with (nolock) ON Customer.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN '+
                       'Parameter.SlipStatu with (nolock) ON Customer.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
                      'Parameter.Currency with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+
'WHERE  Customer.Slip.SlipStateId=1 and Customer.Slip.SlipTypeId<3  and  Customer.Slip.SlipId in (select SlipId from Customer.SlipOdd where BetTypeId<>2  and EventDate<DATEADD(MINUTE,-120,GETDATE()) and StateId=1)'+
' GROUP BY Customer.Slip.SlipId, Customer.Slip.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, '+
                      'Customer.Slip.Amount, Customer.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.Slip.CreateDate, Parameter.Source.SourceId, '+
                      'Parameter.Source.Source, Customer.Slip.SlipTypeId, Customer.Slip.SourceId, Parameter.SlipType.SlipType, '+
                      'Parameter.SlipState.StatuColor,  Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.SlipStatu.SlipStatu,Customer.Slip.EventCount,Customer.Slip.IsLive,Customer.Customer.IsTerminalCustomer,Customer.Customer.BranchId,Customer.Customer.IsBranchCustomer,Customer.Slip.EvaluateDate '+
 ') '+ 
  ' insert @temptable'+
' SELECT RowNum,
 SlipId, CustomerId, '+
                      'CustomerName, '+
                      'Amount, TotalOddValue, StateId, State,  CreateDate, SourceId, '+
                      'Source,cast(OddCount as int) as OddCount,SlipType, SlipTypeId, '+
                      'SlipStateStatuColor,MaxGain,CurrencyId, '+
                      'Currency,SlipStatu
,@total as totalrow,case when Amount>=2000 then 3 else 1 end as AmountStatuColor,EvaluateDate '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '




   
set @sqlcommand5=' select @total+=COUNT(DISTINCT Customer.SlipSystem.SystemSlipId) '+
'from Customer.SlipSystem  with (nolock) INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN '+
'Customer.Customer  with (nolock) ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN '+
'Parameter.Source  with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN '+
'Parameter.SlipType  with (nolock) ON Customer.SlipSystem.SlipTypeId = Parameter.SlipType.Id  INNER JOIN '+
'Parameter.SlipStatu  with (nolock) ON Customer.SlipSystem.SlipStatuId = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
'Parameter.Currency  with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+   
' WHERE Customer.SlipSystem.SlipStateId=1 and Customer.SlipSystem.NewSlipTypeId in (4,5) and Customer.SlipSystem.SystemSlipId in  (select SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId in (select SlipId from Customer.SlipOdd where EventDate<DATEADD(MINUTE,-120,GETDATE()) and StateId=1 and MatchId<>1154142)) and 1=1  ;' +
' WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.SlipSystem.SystemSlipId desc) AS RowNum, '+
'  (select Min(SlipId) from Customer.SlipSystemSlip  with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId , Customer.SlipSystem.CustomerId, '+
                      'Customer.Customer.CustomerName + '' '' + Customer.Customer.CustomerSurname + '' ( '' + case when (Customer.Customer.IsTerminalCustomer=1 or Customer.Customer.IsBranchCustomer=1) then (select BrancName From Parameter.Branch with (nolock) where BranchId = (Select ParentBranchId from Parameter.Branch with (nolock) where BranchId=Customer.Customer.BranchId)) else Customer.Customer.Username end + '' ) '' AS CustomerName, '+
                      ' Customer.SlipSystem.Amount  as Amount, Customer.SlipSystem.TotalOddValue , Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipSystem.CreateDate  as CreateDate, Parameter.Source.SourceId, '+
                      'Parameter.Source.Source, Customer.SlipSystem.EventCount AS OddCount, case when CHARINDEX(''Multi'',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+'' System'' else Customer.SlipSystem.[System] end as SlipType,Parameter.SlipType.Id as SlipTypeId, '+
                      'Parameter.SlipState.StatuColor AS SlipStateStatuColor,case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId=2 then Customer.SlipSystem.Amount+ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and SlipTypeId=3),0) else case when (Select Count(*) from Customer.Slip where Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId))>0 then  ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip where Customer.Slip.SlipStateId in (3,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0) else ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip where Archive.Slip.SlipStateId in (3,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0) end end end as MaxGain , Customer.Customer.CurrencyId, '+
                      'Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,Customer.SlipSystem.EvaluateDate '
set @sqlcommand6='from Customer.SlipSystem  with (nolock) INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN '+
'Customer.Customer  with (nolock) ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN '+
'Parameter.Source  with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN '+
'Parameter.SlipType  with (nolock) ON Customer.SlipSystem.SlipTypeId = Parameter.SlipType.Id  INNER JOIN '+
'Parameter.SlipStatu  with (nolock) ON Customer.SlipSystem.SlipStatuId = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
'Parameter.Currency  with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+   
' WHERE Customer.SlipSystem.SlipStateId=1 and Customer.SlipSystem.NewSlipTypeId in (4,5) and Customer.SlipSystem.SystemSlipId in  (select SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId in (select SlipId from Customer.SlipOdd where  EventDate<DATEADD(MINUTE,-120,GETDATE()) and MatchId<>1154142 and StateId=1)) and 1=1  '+
' GROUP BY   Customer.SlipSystem.MaxGain,Customer.SlipSystem.SlipStateId,Customer.SlipSystem.[System],Customer.SlipSystem.SystemSlipId,Customer.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, Customer.SlipSystem.Amount, Customer.SlipSystem.TotalOddValue,
				   Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipSystem.CreateDate, Parameter.Source.SourceId, Parameter.Source.Source, Parameter.SlipType.Id,  Parameter.Source.SourceId, Parameter.Source.Source
				   , Parameter.SlipType.SlipType, Parameter.SlipState.StatuColor,  Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.SlipStatu.SlipStatu,Customer.SlipSystem.EventCount,Customer.Customer.IsTerminalCustomer,Customer.Customer.BranchId,Customer.Customer.IsBranchCustomer,Customer.SlipSystem.EvaluateDate '+
 ') '+ 
  ' insert @temptable'+
' SELECT RowNum+(select ISNULL(Count(RowNum),0) from @temptable),
 SlipId, CustomerId, '+
                      'CustomerName, '+
                      'Amount, TotalOddValue, StateId, State,  CreateDate, SourceId, '+
                      'Source,cast(OddCount as int) as OddCount,SlipType, SlipTypeId, '+
                      'SlipStateStatuColor,MaxGain,CurrencyId, '+
                      'Currency,SlipStatu
,@total as totalrow,case when Amount>=2000 then 3 else 1 end as AmountStatuColor,EvaluateDate '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


  set @sqlcommand06 ='declare @maxcount int select @maxcount=MAX(totalrow) from @temptable   update @temptable set totalrow=@maxcount '

   set @sqlcommand7 =' select RowNum ,SlipId ,CustomerId ,CustomerName ,Amount as Amount 
  ,TotalOddValue ,StateId ,State ,dbo.UserTimeZoneDate('''+@Username+''',CreateDate,0) as CreateDate ,SourceId ,Source ,OddCount ,SlipType ,SlipTypeId ,SlipStateStatuColor 
  ,cast(MaxGain as float) AS MaxGain ,CurrencyId,Currency ,SlipStatu ,totalrow,AmountStatuColor,dbo.UserTimeZoneDate('''+@Username+''',EvaluateDate,0) as EvaluateDate from @temptable'+
   ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) Order By  '+@orderby+''



end
else if (CHARINDEX('s:risk',@where) > 0)
begin


set @sqlcommand='declare @total int '+
' select @total=COUNT(DISTINCT Customer.Slip.SlipId) '+
'FROM Customer.Customer with (nolock) INNER JOIN '+
                      'Customer.Slip with (nolock) ON Customer.Customer.CustomerId = Customer.Slip.CustomerId INNER JOIN '+
                      --'Customer.SlipOdd ON Customer.Slip.SlipId = Customer.SlipOdd.SlipId INNER JOIN '+
                      'Parameter.SlipState with (nolock) ON Customer.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN '+
                      'Parameter.Source with (nolock) ON Customer.Slip.SourceId = Parameter.Source.SourceId INNER JOIN '+
                      'Parameter.SlipType with (nolock) ON Customer.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN '+
                       'Parameter.SlipStatu with (nolock) ON Customer.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
                      'Parameter.Currency with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+
' WHERE Customer.Slip.SlipTypeId<3  and SlipStateId in (3,7) and DATEDIFF(MINUTE,Customer.Slip.CreateDate,Customer.Slip.EvaluateDate)<5 and cast(Customer.Slip.CreateDate as date)=cast(GETDATE() as date) ; '+
' WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.Slip.SlipId) AS RowNum, '+
'  Customer.Slip.SlipId, Customer.Slip.CustomerId, '+
                      'Customer.Customer.CustomerName + '' '' + Customer.Customer.CustomerSurname + '' ( '' + case when (Customer.Customer.IsTerminalCustomer=1 or Customer.Customer.IsBranchCustomer=1) then (select BrancName From Parameter.Branch with (nolock) where BranchId = (Select ParentBranchId from Parameter.Branch with (nolock) where BranchId=Customer.Customer.BranchId)) else Customer.Customer.Username end + '' ) '' AS CustomerName, '+
                      ' Customer.Slip.Amount  as Amount, Customer.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.Slip.CreateDate  as CreateDate, Parameter.Source.SourceId, '+
                      'Parameter.Source.Source, ISNULL(Customer.Slip.EventCount,0) AS OddCount,case when Customer.Slip.IsLive=1 then '' * '' else '''' end+'' ''+ Parameter.SlipType.SlipType as SlipType, Customer.Slip.SlipTypeId, '+
                      'Parameter.SlipState.StatuColor AS SlipStateStatuColor,case when SlipStateId<>7 then cast( Customer.Slip.Amount * Customer.Slip.TotalOddValue as float) else cast((Select CashOutValue from Customer.SlipCashOut with (nolock) where SlipId=Customer.Slip.SlipId) as float) end AS MaxGain, Customer.Customer.CurrencyId, '+
                      'Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,Customer.Slip.EvaluateDate '
set @sqlcommand1='FROM  Customer.Customer with (nolock) INNER JOIN '+
                      ' Customer.Slip with (nolock) ON Customer.Customer.CustomerId = Customer.Slip.CustomerId INNER JOIN '+
                     -- ' Customer.SlipOdd ON Customer.Slip.SlipId = Customer.SlipOdd.SlipId INNER JOIN '+
                      'Parameter.SlipState with (nolock) ON Customer.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN '+
                      'Parameter.Source with (nolock) ON Customer.Slip.SourceId = Parameter.Source.SourceId INNER JOIN '+
                      'Parameter.SlipType with (nolock) ON Customer.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN '+
                       'Parameter.SlipStatu with (nolock) ON Customer.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
                      'Parameter.Currency with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+
'WHERE  Customer.Slip.SlipTypeId<3  and  SlipStateId in (3,7) and DATEDIFF(MINUTE,Customer.Slip.CreateDate,Customer.Slip.EvaluateDate)<5  and cast(Customer.Slip.CreateDate as date)=cast(GETDATE() as date)'+
' GROUP BY SlipStateId,Customer.Slip.SlipId, Customer.Slip.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, '+
                      'Customer.Slip.Amount, Customer.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.Slip.CreateDate, Parameter.Source.SourceId, '+
                      'Parameter.Source.Source, Customer.Slip.SlipTypeId, Customer.Slip.SourceId, Parameter.SlipType.SlipType, '+
                      'Parameter.SlipState.StatuColor,  Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.SlipStatu.SlipStatu,Customer.Slip.EventCount,Customer.Slip.IsLive,Customer.Customer.BranchId,Customer.Customer.IsTerminalCustomer,Customer.Customer.IsBranchCustomer,Customer.Slip.EvaluateDate '+
 ') '+ 
  ' insert @temptable'+
' SELECT RowNum,
 SlipId, CustomerId, '+
                      'CustomerName, '+
                      'Amount, TotalOddValue, StateId, State,  CreateDate, SourceId, '+
                      'Source,cast(OddCount as int) as OddCount,SlipType, SlipTypeId, '+
                      'SlipStateStatuColor,MaxGain,CurrencyId, '+
                      'Currency,SlipStatu
,@total as totalrow,case when Amount>=2000 then 3 else 1 end as AmountStatuColor,EvaluateDate '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '




   
set @sqlcommand5=' select @total+=COUNT(DISTINCT Customer.SlipSystem.SystemSlipId) '+
'from Customer.SlipSystem  with (nolock) INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN '+
'Customer.Customer  with (nolock) ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN '+
'Parameter.Source  with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN '+
'Parameter.SlipType  with (nolock) ON Customer.SlipSystem.SlipTypeId = Parameter.SlipType.Id  INNER JOIN '+
'Parameter.SlipStatu  with (nolock) ON Customer.SlipSystem.SlipStatuId = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
'Parameter.Currency  with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+   
' WHERE SlipStateId in (3,7) and DATEDIFF(MINUTE,Customer.SlipSystem.CreateDate,Customer.SlipSystem.EvaluateDate)<5  and cast(Customer.SlipSystem.CreateDate as date)=cast(GETDATE() as date)  ;' +
' WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.SlipSystem.SystemSlipId desc) AS RowNum, '+
'  (select Min(SlipId) from Customer.SlipSystemSlip  with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId , Customer.SlipSystem.CustomerId, '+
                      'Customer.Customer.CustomerName + '' '' + Customer.Customer.CustomerSurname + '' ( '' + case when (Customer.Customer.IsTerminalCustomer=1 or Customer.Customer.IsBranchCustomer=1) then (select BrancName From Parameter.Branch with (nolock) where BranchId = (Select ParentBranchId from Parameter.Branch with (nolock) where BranchId=Customer.Customer.BranchId)) else Customer.Customer.Username end + '' ) '' AS CustomerName, '+
                      ' Customer.SlipSystem.Amount  as Amount, Customer.SlipSystem.TotalOddValue , Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipSystem.CreateDate  as CreateDate, Parameter.Source.SourceId, '+
                      'Parameter.Source.Source, Customer.SlipSystem.EventCount AS OddCount, case when CHARINDEX(''Multi'',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+'' System'' else Customer.SlipSystem.[System] end as SlipType,Parameter.SlipType.Id as SlipTypeId, '+
                      'Parameter.SlipState.StatuColor AS SlipStateStatuColor,case when SlipStateId<>7 then Customer.SlipSystem.MaxGain else cast((Select CashOutValue from Customer.SlipCashOut with (nolock) where SlipId=(select Min(SlipId) from Customer.SlipSystemSlip  with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) as float) end as MaxGain , Customer.Customer.CurrencyId, '+
                      'Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,Customer.SlipSystem.EvaluateDate '
set @sqlcommand6='from Customer.SlipSystem  with (nolock) INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN '+
'Customer.Customer  with (nolock) ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN '+
'Parameter.Source  with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN '+
'Parameter.SlipType  with (nolock) ON Customer.SlipSystem.SlipTypeId = Parameter.SlipType.Id  INNER JOIN '+
'Parameter.SlipStatu  with (nolock) ON Customer.SlipSystem.SlipStatuId = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
'Parameter.Currency  with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+   
' WHERE SlipStateId in (3,7) and DATEDIFF(MINUTE,Customer.SlipSystem.CreateDate,Customer.SlipSystem.EvaluateDate)<5 and cast(Customer.SlipSystem.CreateDate as date)=cast(GETDATE() as date)  '+
' GROUP BY   SlipStateId,Customer.SlipSystem.MaxGain,Customer.SlipSystem.SlipStateId,Customer.SlipSystem.[System],Customer.SlipSystem.SystemSlipId,Customer.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, Customer.SlipSystem.Amount, Customer.SlipSystem.TotalOddValue,
				   Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipSystem.CreateDate, Parameter.Source.SourceId, Parameter.Source.Source, Parameter.SlipType.Id,  Parameter.Source.SourceId, Parameter.Source.Source
				   , Parameter.SlipType.SlipType, Parameter.SlipState.StatuColor,  Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.SlipStatu.SlipStatu,Customer.SlipSystem.EventCount,Customer.Customer.BranchId,Customer.Customer.IsTerminalCustomer,Customer.Customer.IsBranchCustomer,Customer.SlipSystem.EvaluateDate '+
 ') '+ 
  ' insert @temptable'+
' SELECT RowNum+(select ISNULL(Count(RowNum),0) from @temptable),
 SlipId, CustomerId, '+
                      'CustomerName, '+
                      'Amount, TotalOddValue, StateId, State,  CreateDate, SourceId, '+
                      'Source,cast(OddCount as int) as OddCount,SlipType, SlipTypeId, '+
                      'SlipStateStatuColor,MaxGain,CurrencyId, '+
                      'Currency,SlipStatu
,@total as totalrow,case when Amount>=2000 then 3 else 1 end as AmountStatuColor,EvaluateDate '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


  set @sqlcommand06 ='declare @maxcount int select @maxcount=MAX(totalrow) from @temptable   update @temptable set totalrow=@maxcount '

   set @sqlcommand7 =' select RowNum ,SlipId ,CustomerId ,CustomerName ,Amount as Amount 
  ,TotalOddValue ,StateId ,State ,dbo.UserTimeZoneDate('''+@Username+''',CreateDate,0) as CreateDate ,SourceId ,Source ,OddCount ,SlipType ,SlipTypeId ,SlipStateStatuColor 
  ,cast(MaxGain as float) AS MaxGain ,CurrencyId,Currency ,SlipStatu ,totalrow,AmountStatuColor,dbo.UserTimeZoneDate('''+@Username+''',EvaluateDate,0) as EvaluateDate from @temptable'+
   ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) Order By CreateDate desc'


end
else
begin



set @sqlcommand='declare @total int=0 '+
' select @total+=COUNT(DISTINCT Customer.Slip.SlipId) '+
'FROM Customer.Customer with (nolock) INNER JOIN '+
                      'Customer.Slip with (nolock) ON Customer.Customer.CustomerId = Customer.Slip.CustomerId INNER JOIN '+
                      --'Customer.SlipOdd ON Customer.Slip.SlipId = Customer.SlipOdd.SlipId INNER JOIN '+
                      'Parameter.SlipState with (nolock) ON Customer.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN '+
                      'Parameter.Source with (nolock) ON Customer.Slip.SourceId = Parameter.Source.SourceId INNER JOIN '+
                      'Parameter.SlipType with (nolock) ON Customer.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN '+
                       'Parameter.SlipStatu with (nolock) ON Customer.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
                      'Parameter.Currency with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+
' WHERE 1=1 and Customer.Slip.SlipTypeId<3 and Customer.Slip.SlipStatu in (1,3) '+@where2+ ' and '+@where +' ; ' +
' WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.Slip.SlipId desc) AS RowNum, '+
'  Customer.Slip.SlipId, Customer.Slip.CustomerId, '+
                      'Customer.Customer.CustomerName + '' '' + Customer.Customer.CustomerSurname + '' ( '' + case when (Customer.Customer.IsTerminalCustomer=1 or Customer.Customer.IsBranchCustomer=1) then (select BrancName From Parameter.Branch with (nolock) where BranchId = (Select ParentBranchId from Parameter.Branch with (nolock) where BranchId=Customer.Customer.BranchId)) else Customer.Customer.Username end + '' ) '' AS CustomerName, '+
                      ' Customer.Slip.Amount  as Amount, Customer.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.Slip.CreateDate  as CreateDate, Parameter.Source.SourceId, '+
                      'Parameter.Source.Source, ISNULL(Customer.Slip.EventCount,0) AS OddCount,case when Customer.Slip.IsLive=1 then '' * '' else '''' end+'' ''+ Parameter.SlipType.SlipType as SlipType, Customer.Slip.SlipTypeId, '+
                      'Parameter.SlipState.StatuColor AS SlipStateStatuColor, case when Parameter.SlipState.StateId<>7 then cast( Customer.Slip.Amount * Customer.Slip.TotalOddValue as float) else (select SUM(CashOutValue) from Customer.SlipCashOut where SlipId=Customer.Slip.SlipId) end AS MaxGain, Customer.Customer.CurrencyId, '+
                      'Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,Customer.Slip.EvaluateDate  '
set @sqlcommand1='FROM  Customer.Customer with (nolock) INNER JOIN '+
                      ' Customer.Slip with (nolock) ON Customer.Customer.CustomerId = Customer.Slip.CustomerId INNER JOIN '+
                     -- ' Customer.SlipOdd ON Customer.Slip.SlipId = Customer.SlipOdd.SlipId INNER JOIN '+
                      'Parameter.SlipState with (nolock) ON Customer.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN '+
                      'Parameter.Source with (nolock) ON Customer.Slip.SourceId = Parameter.Source.SourceId INNER JOIN '+
                      'Parameter.SlipType with (nolock) ON Customer.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN '+
                       'Parameter.SlipStatu with (nolock) ON Customer.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
                      'Parameter.Currency with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+
'WHERE 1=1 and Customer.Customer.CustomerId<>1192 and Customer.Slip.SlipTypeId<3 and Customer.Slip.SlipStatu in (1,3) '+@where2+ ' and '+@where+
' GROUP BY Customer.Slip.SlipId, Customer.Slip.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, '+
                      'Customer.Slip.Amount, Customer.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.Slip.CreateDate, Parameter.Source.SourceId, '+
                      'Parameter.Source.Source, Customer.Slip.SlipTypeId, Customer.Slip.SourceId, Parameter.SlipType.SlipType, '+
                      'Parameter.SlipState.StatuColor,  Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.SlipStatu.SlipStatu,Customer.Slip.EventCount,Customer.Slip.IsLive,Customer.Customer.BranchId,Customer.Customer.IsTerminalCustomer,Customer.Customer.IsBranchCustomer,Customer.Slip.EvaluateDate  '+
 ') '+ 
 ' insert @temptable'+ 
' SELECT RowNum,
 SlipId, CustomerId, '+
                      'CustomerName, '+
                      'Amount, TotalOddValue, StateId, State,  CreateDate, SourceId, '+
                      'Source,OddCount,SlipType, SlipTypeId, '+
                      'SlipStateStatuColor,MaxGain,CurrencyId, '+
                      'Currency,SlipStatu
,@total as totalrow,case when Amount>=2000 then 3 else 1 end as AmountStatuColor,EvaluateDate '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

 if(CHARINDEX('Customer.Slip.SlipId in (Select Customer.SlipOdd.SlipId from Customer.SlipOdd where MatchId=',@where))=0
 begin
 declare @where4 nvarchar(max)=''
	 if(CHARINDEX('Customer.Slip.SlipId in',@where))>	0
		begin
		set @where4=Replace(@where,'(Customer.Slip.SlipId in','Customer.SlipSystem.SystemSlipId in ( select SystemSlipId from  Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SlipId in')
			 
		set @where4=REPLACE(@where4,'Customer.Slip.','Customer.SlipSystem.')
		end
	else
		set @where4=REPLACE(@where,'Customer.Slip.','Customer.SlipSystem.')

	set @where4=REPLACE(@where4,'Customer.SlipSystem.SlipId','Customer.SlipSystem.SystemSlipId')
		

set @sqlcommand5=' select @total+=COUNT(DISTINCT Customer.SlipSystem.SystemSlipId) '+
'from Customer.SlipSystem  with (nolock) INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN '+
'Customer.Customer  with (nolock) ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN '+
'Parameter.Source  with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN '+
'Parameter.SlipType  with (nolock) ON Customer.SlipSystem.SlipTypeId = Parameter.SlipType.Id  INNER JOIN '+
'Parameter.SlipStatu  with (nolock) ON Customer.SlipSystem.SlipStatuId = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
'Parameter.Currency  with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+   
' WHERE  Customer.SlipSystem.NewSlipTypeId=3 and  (select Max(SlipId) from Customer.SlipSystemSlip  with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) is not null and 1=1  '+@where2+ ' and '+@where4+' ; ' +
' WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.SlipSystem.SystemSlipId desc) AS RowNum, '+
'  (select Min(SlipId) from Customer.SlipSystemSlip  with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId , Customer.SlipSystem.CustomerId, '+
                      'Customer.Customer.CustomerName + '' '' + Customer.Customer.CustomerSurname + '' ( '' + case when (Customer.Customer.IsTerminalCustomer=1 or Customer.Customer.IsBranchCustomer=1) then (select BrancName From Parameter.Branch with (nolock) where BranchId = (Select ParentBranchId from Parameter.Branch with (nolock) where BranchId=Customer.Customer.BranchId)) else Customer.Customer.Username end + '' ) '' AS CustomerName, '+
                      ' Customer.SlipSystem.Amount  as Amount, Customer.SlipSystem.TotalOddValue , Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipSystem.CreateDate  as CreateDate, Parameter.Source.SourceId, '+
                      'Parameter.Source.Source, Customer.SlipSystem.EventCount AS OddCount, case when CHARINDEX(''Multi'',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+'' System'' else Customer.SlipSystem.[System] end as SlipType,Parameter.SlipType.Id as SlipTypeId, '+
                      'Parameter.SlipState.StatuColor AS SlipStateStatuColor,case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId=2 then Customer.SlipSystem.Amount+ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and SlipTypeId=3),0) else case when (Select Count(*) from Customer.Slip with (nolock) where Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId))>0 then  ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip with (nolock) where Customer.Slip.SlipStateId in (3,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0) else ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip with (nolock) where Archive.Slip.SlipStateId in (3,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0) end end end as MaxGain , Customer.Customer.CurrencyId, '+
                      'Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,Customer.SlipSystem.EvaluateDate '
set @sqlcommand6='from Customer.SlipSystem  with (nolock) INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN '+
'Customer.Customer  with (nolock) ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN '+
'Parameter.Source  with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN '+
'Parameter.SlipType  with (nolock) ON Customer.SlipSystem.SlipTypeId = Parameter.SlipType.Id  INNER JOIN '+
'Parameter.SlipStatu  with (nolock) ON Customer.SlipSystem.SlipStatuId = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
'Parameter.Currency  with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+   
' WHERE  Customer.SlipSystem.NewSlipTypeId=3 and  (select Max(SlipId) from Customer.SlipSystemSlip  with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) is not null and (Select Count(*) from Customer.slip where SlipId in ((select Min(SlipId) from Customer.SlipSystemSlip  with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) and Customer.slip.SlipTypeId=3)>0  and 1=1  '+@where2+ ' and '+@where4 +
' GROUP BY   Customer.SlipSystem.MaxGain,Customer.SlipSystem.SlipStateId,Customer.SlipSystem.[System],Customer.SlipSystem.SystemSlipId,Customer.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, Customer.SlipSystem.Amount, Customer.SlipSystem.TotalOddValue,
				   Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipSystem.CreateDate, Parameter.Source.SourceId, Parameter.Source.Source, Parameter.SlipType.Id,  Parameter.Source.SourceId, Parameter.Source.Source
				   , Parameter.SlipType.SlipType, Parameter.SlipState.StatuColor,  Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.SlipStatu.SlipStatu,Customer.SlipSystem.EventCount,Customer.Customer.BranchId,Customer.Customer.IsTerminalCustomer,Customer.Customer.IsBranchCustomer,Customer.SlipSystem.EvaluateDate  '+
 ') '+ 
  ' insert @temptable'+
' SELECT RowNum,
 SlipId, CustomerId, '+
                      'CustomerName, '+
                      'Amount, TotalOddValue, StateId, State,  CreateDate, SourceId, '+
                      'Source,cast(OddCount as int) as OddCount,SlipType, SlipTypeId, '+
                      'SlipStateStatuColor,MaxGain,CurrencyId, '+
                      'Currency,SlipStatu
,@total as totalrow,case when Amount>=2000 then 3 else 1 end as AmountStatuColor,EvaluateDate '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

 set @sqlcommand55=' select @total+=COUNT(DISTINCT Customer.SlipSystem.SystemSlipId) '+
'from Customer.SlipSystem  with (nolock) INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN '+
'Customer.Customer  with (nolock) ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN '+
'Parameter.Source  with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN '+
'Parameter.SlipType  with (nolock) ON Customer.SlipSystem.SlipTypeId = Parameter.SlipType.Id  INNER JOIN '+
'Parameter.SlipStatu  with (nolock) ON Customer.SlipSystem.SlipStatuId = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
'Parameter.Currency  with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+   
' WHERE  Customer.SlipSystem.NewSlipTypeId in (4,5) and 1=1  '+@where2+ ' and '+@where4+' ; ' +
' WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.SlipSystem.SystemSlipId desc) AS RowNum, '+
'  (select Min(SlipId) from Customer.SlipSystemSlip  with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) as SlipId , Customer.SlipSystem.CustomerId, '+
                      'Customer.Customer.CustomerName + '' '' + Customer.Customer.CustomerSurname + '' ( '' + case when (Customer.Customer.IsTerminalCustomer=1 or Customer.Customer.IsBranchCustomer=1) then (select BrancName From Parameter.Branch with (nolock) where BranchId = (Select ParentBranchId from Parameter.Branch with (nolock) where BranchId=Customer.Customer.BranchId)) else Customer.Customer.Username end + '' ) '' AS CustomerName, '+
                      ' Customer.SlipSystem.Amount  as Amount, Customer.SlipSystem.TotalOddValue , Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipSystem.CreateDate  as CreateDate, Parameter.Source.SourceId, '+
                      'Parameter.Source.Source, Customer.SlipSystem.EventCount AS OddCount, case when Customer.SlipSystem.NewSlipTypeId=4  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+'' System'' else '' Multiway''  end as SlipType,Parameter.SlipType.Id as SlipTypeId, '+
                      'Parameter.SlipState.StatuColor AS SlipStateStatuColor,case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId=2 then Customer.SlipSystem.Amount+ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax where Customer.Tax.SlipId =Customer.SlipSystem.SystemSlipId and SlipTypeId=3),0) else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)) else Customer.SlipSystem.MaxGain end end end as MaxGain , Customer.Customer.CurrencyId, '+
                      'Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,Customer.SlipSystem.EvaluateDate '
set @sqlcommand66='from Customer.SlipSystem  with (nolock) INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN '+
'Customer.Customer  with (nolock) ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN '+
'Parameter.Source  with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN '+
'Parameter.SlipType  with (nolock) ON Customer.SlipSystem.SlipTypeId = Parameter.SlipType.Id  INNER JOIN '+
'Parameter.SlipStatu  with (nolock) ON Customer.SlipSystem.SlipStatuId = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
'Parameter.Currency  with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+   
' WHERE  Customer.SlipSystem.NewSlipTypeId in (4,5)  and 1=1  '+@where2+ ' and '+@where4 +
' GROUP BY   Customer.SlipSystem.NewSlipTypeId,Customer.SlipSystem.MaxGain,Customer.SlipSystem.SlipStateId,Customer.SlipSystem.[System],Customer.SlipSystem.SystemSlipId,Customer.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, Customer.SlipSystem.Amount, Customer.SlipSystem.TotalOddValue,
				   Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipSystem.CreateDate, Parameter.Source.SourceId, Parameter.Source.Source, Parameter.SlipType.Id,  Parameter.Source.SourceId, Parameter.Source.Source
				   , Parameter.SlipType.SlipType, Parameter.SlipState.StatuColor,  Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.SlipStatu.SlipStatu,Customer.SlipSystem.EventCount,Customer.Customer.BranchId,Customer.Customer.IsTerminalCustomer,Customer.Customer.IsBranchCustomer,Customer.SlipSystem.EvaluateDate '+
 ') '+ 
  ' insert @temptable'+
' SELECT RowNum,
 SlipId, CustomerId, '+
                      'CustomerName, '+
                      'Amount, TotalOddValue, StateId, State,  CreateDate, SourceId, '+
                      'Source,cast(OddCount as int) as OddCount,SlipType, SlipTypeId, '+
                      'SlipStateStatuColor,MaxGain,CurrencyId, '+
                      'Currency,SlipStatu
,@total as totalrow,case when Amount>=2000 then 3 else 1 end as AmountStatuColor,EvaluateDate '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '



 end

if (CHARINDEX('m:',@where) = 0 and CHARINDEX('Customer.Slip.SlipStateId=''1''',@where) = 0)
begin
 set @where=REPLACE(@where,'Customer.Slip','Archive.Slip')
 
 
 --select @where

set @sqlcommand2=' select @total+=COUNT(DISTINCT Archive.Slip.SlipId) '+
'FROM Customer.Customer with (nolock) INNER JOIN '+
                      'Archive.Slip with (nolock) ON Customer.Customer.CustomerId = Archive.Slip.CustomerId INNER JOIN '+
                    -- 'Archive.SlipOdd ON Archive.Slip.SlipId = Archive.SlipOdd.SlipId INNER JOIN '+
                      'Parameter.SlipState with (nolock) ON Archive.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN '+
                      'Parameter.Source with (nolock) ON Archive.Slip.SourceId = Parameter.Source.SourceId INNER JOIN '+
                      'Parameter.SlipType with (nolock) ON Archive.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN '+
                       'Parameter.SlipStatu with (nolock) ON Archive.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
                      'Parameter.Currency with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+
' WHERE 1=1 and Archive.Slip.SlipTypeId<3 and Archive.Slip.SlipStatu in (1,3) '+@where2+ ' and '+@where +' ; ' +
' WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Archive.Slip.SlipId desc) AS RowNum, '+
'  Archive.Slip.SlipId, Archive.Slip.CustomerId, '+
                      'Customer.Customer.CustomerName + '' '' + Customer.Customer.CustomerSurname + '' ( '' + case when (Customer.Customer.IsTerminalCustomer=1 or Customer.Customer.IsBranchCustomer=1) then (select BrancName From Parameter.Branch with (nolock) where BranchId = (Select ParentBranchId from Parameter.Branch with (nolock) where BranchId=Customer.Customer.BranchId)) else Customer.Customer.Username end + '' ) '' AS CustomerName, '+
                      'Archive.Slip.Amount as Amount, Archive.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Archive.Slip.CreateDate  as CreateDate, Parameter.Source.SourceId, '+
                      'Parameter.Source.Source, ISNULL(Archive.Slip.EventCount,0) AS OddCount,case when Archive.Slip.IsLive=1 then '' * '' else '''' end+'' ''+ Parameter.SlipType.SlipType as SlipType, Archive.Slip.SlipTypeId, '+
                      'Parameter.SlipState.StatuColor AS SlipStateStatuColor,case when Parameter.SlipState.StateId<>7 then cast( Archive.Slip.Amount * Archive.Slip.TotalOddValue as float) else (select SUM(CashOutValue) from Customer.SlipCashOut where SlipId=Archive.Slip.SlipId) end AS MaxGain, Customer.Customer.CurrencyId, '+
                      'Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,Archive.Slip.EvaluateDate '
set @sqlcommand3='FROM  Customer.Customer with (nolock) INNER JOIN '+
                      ' Archive.Slip with (nolock) ON Customer.Customer.CustomerId = Archive.Slip.CustomerId INNER JOIN '+
                    --  ' Archive.SlipOdd ON Archive.Slip.SlipId = Archive.SlipOdd.SlipId INNER JOIN '+
                      'Parameter.SlipState with (nolock) ON Archive.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN '+
                      'Parameter.Source with (nolock) ON Archive.Slip.SourceId = Parameter.Source.SourceId INNER JOIN '+
                      'Parameter.SlipType with (nolock) ON Archive.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN '+
                       'Parameter.SlipStatu with (nolock) ON Archive.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
                      'Parameter.Currency with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+
'WHERE 1=1 and Archive.Slip.SlipTypeId<3 and Archive.Slip.SlipStatu in (1,3) '+@where2+ ' and '+@where+
' GROUP BY Archive.Slip.SlipId, Archive.Slip.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, '+
                      'Archive.Slip.Amount, Archive.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Archive.Slip.CreateDate, Parameter.Source.SourceId, '+
                      'Parameter.Source.Source, Archive.Slip.SlipTypeId, Archive.Slip.SourceId, Parameter.SlipType.SlipType, '+
                      'Parameter.SlipState.StatuColor,  Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.SlipStatu.SlipStatu,Archive.Slip.EventCount,Archive.Slip.IsLive,Customer.Customer.BranchId,Customer.Customer.IsTerminalCustomer,Customer.Customer.IsBranchCustomer,Archive.Slip.EvaluateDate '+
 ') '+ 
 ' insert @temptable'+ 
' SELECT RowNum,
 SlipId, CustomerId, '+
                      'CustomerName, '+
                      'Amount, TotalOddValue, StateId, State,  CreateDate, SourceId, '+
                      'Source,OddCount,SlipType, SlipTypeId, '+
                      'SlipStateStatuColor,MaxGain,CurrencyId, '+
                      'Currency,SlipStatu
,@total as totalrow,case when Amount>=2000 then 3 else 1 end as AmountStatuColor,EvaluateDate '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

 end

 set @sqlcommand06 ='declare @maxcount int select @maxcount=MAX(totalrow) from @temptable   update @temptable set totalrow=@maxcount '


 set @sqlcommand7 ='declare @total2 int=0  select @total2=COUNT(SlipId) '+
'FROM         @temptable '+
' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNumbers, '+
' SlipId ,CustomerId ,CustomerName ,Amount as Amount 
  ,TotalOddValue ,StateId ,State ,dbo.UserTimeZoneDate('''+@Username+''',CreateDate,0) as CreateDate ,SourceId ,Source ,OddCount ,SlipType ,SlipTypeId ,SlipStateStatuColor 
  ,cast(MaxGain as float) AS MaxGain ,CurrencyId,Currency ,SlipStatu ,totalrow,AmountStatuColor,RowNum,dbo.UserTimeZoneDate('''+@Username+''',EvaluateDate,0) as EvaluateDate'+
  ' FROM         @temptable '+
  ') '+  
'SELECT * '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '



end
exec (@sqlcommand0+@sqlcommand+@sqlcommand1+@sqlcommand2+@sqlcommand3+@sqlcommand4+@sqlcommand5+@sqlcommand6+@sqlcommand55+@sqlcommand66+@sqlcommand06+@sqlcommand7)
END




GO
