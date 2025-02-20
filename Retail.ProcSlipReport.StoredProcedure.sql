USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcSlipReport]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Retail].[ProcSlipReport] 
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(max),
@orderby nvarchar(200),
@SlipId bigint
AS


BEGIN
SET NOCOUNT ON;

declare @sqlcommand nvarchar(max)=''
declare @sqlcommand1 nvarchar(max)=''
declare @sqlcommand11 nvarchar(max)=''
declare @sqlcommand111 nvarchar(max)=''

declare @sqlcommand1111 nvarchar(max)=''
declare @sqlcommand11111 nvarchar(max)=''

declare @sqlcommand2 nvarchar(max)=''
declare @sqlcommand3 nvarchar(max)=''
declare @sqlcommand33 nvarchar(max)=''
declare @UserCurrencyId int
declare @BranchId int
declare @where2 nvarchar(max)=' and 1=1'
declare @where3 nvarchar(max)=' and 1=1'
select @BranchId=Users.Users.UnitCode, @UserCurrencyId=Users.Users.CurrencyId from Users.Users where Users.Users.UserName=@Username
declare @sqlcommand5 nvarchar(max)=''
declare @sqlcommand6 nvarchar(max)=''

if(@SlipId>0)
	set @where3=' and Customer.Slip.SlipId='+cast(@SlipId as nvarchar(30))

if (CHARINDEX('m:',@where) > 0)
set @where=@where+')'

--if(@BranchId<>1)
--	begin

--	set @where2=' and (Customer.Customer.BranchId='+cast(@BranchId as nvarchar(7))+' or Customer.Customer.BranchId in (select BranchId from Parameter.Branch where Parameter.Branch.[ParentBranchId]='+cast(@BranchId as nvarchar(7))+') or Customer.Customer.BranchId in (select BranchId from Parameter.Branch where ParentBranchId in (select BranchId from Parameter.Branch where Parameter.Branch.[ParentBranchId]='+cast(@BranchId as nvarchar(7))+')))' -- Customer.Customer.BranchId='+cast(@BranchId as nvarchar(7))


--	end

	
--if(@orderby='SlipId desc')
--	set @orderby=REPLACE(@orderby,'SlipId','Customer.Slip.SlipId')
--else if(@orderby='SlipId asc')
--	set @orderby=REPLACE(@orderby,'SlipId','Customer.Slip.SlipId') 

declare @sqlcommand0 nvarchar(max)
 
set @sqlcommand0=' declare @temptable table (RowNum bigint not null,SlipId bigint not null,CustomerId bigint not null,CustomerName nvarchar(150),Amount money not null,TotalOddValue float not null,StateId int not null,State nvarchar(50),CreateDate datetime not null,SourceId int not null,Source nvarchar(50) not null,OddCount int not null,SlipType nvarchar(50) not null,SlipTypeId int not null,SlipStateStatuColor nvarchar(50) not null,MaxGain float not null,CurrencyId int not null,Currency nvarchar(50) not null,SlipStatu nvarchar(50) not null,CancelDate datetime,totalrow int not null,Paid money not null,TerminalId nvarchar(30) not null)'


set @sqlcommand='declare @total int=0 '+
' select @total=COUNT(DISTINCT Customer.Slip.SlipId) '+
'FROM Customer.Customer   with (nolock) INNER JOIN '+
                      'Customer.Slip with (nolock) ON Customer.Customer.CustomerId = Customer.Slip.CustomerId INNER JOIN '+
                      --'Customer.SlipOdd ON Customer.Slip.SlipId = Customer.SlipOdd.SlipId INNER JOIN '+
                      'Parameter.SlipState  with (nolock) ON Customer.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN '+
                      'Parameter.Source  with (nolock) ON Customer.Slip.SourceId = Parameter.Source.SourceId INNER JOIN '+
                      'Parameter.SlipType  with (nolock) ON Customer.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN '+
                       'Parameter.SlipStatu  with (nolock) ON Customer.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
                      'Parameter.Currency  with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+
' WHERE 1=1 and Customer.Slip.SlipTypeId in (1,2)   '+@where2+ ' and '+@where + @where3 +' ; ' +
' WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.Slip.SlipId desc) AS RowNum, '+
'  Customer.Slip.SlipId, Customer.Slip.CustomerId, '+
                      'Customer.Customer.CustomerName + '' '' + Customer.Customer.CustomerSurname + '' ( '' + Customer.Customer.Username + '' ) '' AS CustomerName, '+
                      ' Customer.Slip.Amount  as Amount, Customer.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.Slip.CreateDate  as CreateDate, Parameter.Source.SourceId, '+
                      'Parameter.Source.Source, ISNULL(Customer.Slip.EventCount,0) AS OddCount,case when Customer.Slip.IsLive=1 then '' * '' else '''' end+'' ''+ Parameter.SlipType.SlipType as SlipType, Customer.Slip.SlipTypeId, '+
                      'Parameter.SlipState.StatuColor AS SlipStateStatuColor,cast( Customer.Slip.Amount * Customer.Slip.TotalOddValue as float) AS MaxGain, Customer.Customer.CurrencyId, '+
                      'Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,DATEADD(MINUTE,10,Customer.Slip.CreateDate) as CancelDate,case when Customer.Slip.IsPayOut=0 or Customer.Slip.IsPayOut is null  then 0 else case when Customer.Slip.SlipStateId in (3) then  Customer.Slip.Amount*Customer.Slip.TotalOddValue else case when Customer.Slip.SlipStateId in (2) then Customer.Slip.Amount+ISNULL((Select Customer.Tax.TaxAmount from Customer.Tax with (nolock) where SlipId=Customer.Slip.SlipId),0)  else case when Customer.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashout.SlipId=Customer.Slip.SlipId) else 0 end end end end as PaidAmount '+
					  ' ,Case when Customer.Customer.IsTerminalCustomer=1 and  Customer.Customer.BranchId>0 then Customer.Customer.BranchId else '''' end as TerminalId '
set @sqlcommand1='FROM  Customer.Customer with (nolock) INNER JOIN '+
                      ' Customer.Slip  with (nolock) ON Customer.Customer.CustomerId = Customer.Slip.CustomerId INNER JOIN '+
                     -- ' Customer.SlipOdd ON Customer.Slip.SlipId = Customer.SlipOdd.SlipId INNER JOIN '+
                      'Parameter.SlipState  with (nolock) ON Customer.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN '+
                      'Parameter.Source  with (nolock) ON Customer.Slip.SourceId = Parameter.Source.SourceId INNER JOIN '+
                      'Parameter.SlipType  with (nolock) ON Customer.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN '+
                       'Parameter.SlipStatu  with (nolock) ON Customer.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
                      'Parameter.Currency  with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+
'WHERE 1=1 and Customer.Slip.SlipTypeId<3 and Customer.Slip.SlipStatu in (1,3) '+@where2+ ' and '+@where + @where3 +
' GROUP BY Customer.Slip.SlipId, Customer.Slip.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, '+
                      'Customer.Slip.Amount, Customer.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.Slip.CreateDate, Parameter.Source.SourceId, '+
                      'Parameter.Source.Source, Customer.Slip.SlipTypeId, Customer.Slip.SourceId, Parameter.SlipType.SlipType, '+
                      'Parameter.SlipState.StatuColor,  Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.SlipStatu.SlipStatu,Customer.Slip.EventCount,Customer.Slip.IsLive,Customer.Slip.IsPayOut,Customer.Slip.SlipStateId,Customer.Customer.IsTerminalCustomer,Customer.Customer.BranchId '+
 ') '+ 
 ' insert @temptable'+ 
' SELECT RowNum,
 SlipId, CustomerId, '+
                      'CustomerName, '+
                      'Amount, TotalOddValue, StateId, State,  CreateDate, SourceId, '+
                      'Source,OddCount,SlipType, SlipTypeId, '+
                      'SlipStateStatuColor,MaxGain,CurrencyId, '+
                      'Currency,SlipStatu,CancelDate
,@total as totalrow,PaidAmount,TerminalId '+
  'FROM OrdersRN '


  if(@SlipId>0)
	set @where3=' and (Customer.SlipSystem.SystemSlipId in (select SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId in (   '+cast(@SlipId as nvarchar(30))+')) )'

    
set @sqlcommand1111=' select @total+=COUNT(DISTINCT Customer.SlipSystem.SystemSlipId) '+
'from Customer.SlipSystem  with (nolock) INNER JOIN Parameter.SlipState ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN '+
'Customer.Customer  with (nolock) ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN '+
'Parameter.Source  with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN '+
'Parameter.SlipType  with (nolock) ON Customer.SlipSystem.SlipTypeId = Parameter.SlipType.Id  INNER JOIN '+
'Parameter.SlipStatu  with (nolock) ON Customer.SlipSystem.SlipStatuId = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
'Parameter.Currency  with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+   
' WHERE  Customer.SlipSystem.NewSlipTypeId in (4,5) and 1=1  '+@where2+ ' and '+Replace(REPLACE(@where,'Customer.Slip.SlipId','CUstomer.SlipSystem.SystemSlipId'),'.Slip.','.SlipSystem.') + @where3 +' ; ' +
' WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.SlipSystem.SystemSlipId desc) AS RowNum, '+
'  Customer.SlipSystemSlip.SlipId as SlipId '+
  ',Customer.SlipSystem.CustomerId '+
  ', Customer.Customer.CustomerName + '' '' + Customer.Customer.CustomerSurname + '' ( '' + Customer.Customer.Username + '' ) '' AS CustomerName '+
',Customer.SlipSystem.Amount '+
',Customer.SlipSystem.TotalOddValue  as TotalOddValue '+
',Customer.SlipSystem.SlipStateId as StateId '+
',Parameter.SlipState.[State]  '+
',Customer.SlipSystem.CreateDate '+
',Parameter.Source.SourceId '+
', Parameter.Source.Source '+
',Customer.SlipSystem.EventCount as OddCount '+
',case when Customer.SlipSystem.NewSlipTypeId = 4  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+'' System'' else ''Multiway'' end as SlipType '+
', Customer.SlipSystem.SlipTypeId '+
', Parameter.SlipState.StatuColor AS SlipStateStatuColor '+
--',case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when (Select Count(*) from Customer.Slip where SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId))>0 then ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0) else ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0) end end as MaxGain '+
',case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock) where Customer.SlipCashOut.SlipId=Customer.SlipSystemSlip.SlipId ) else Customer.SlipSystem.MaxGain end end  as MaxGain  '+
',Customer.Customer.CurrencyId,  Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu '+
',DATEADD(MINUTE,10,Customer.SlipSystem.CreateDate) as CancelDate,case when Customer.SlipSystem.IsPayOut=0 or Customer.SlipSystem.IsPayOut is null 
 then 0 else case when Customer.SlipSystem.SlipStateId in (1) then Customer.SlipSystem.MaxGain else case when Customer.SlipSystem.SlipStateId =7 
 then (Select SUM(Customer.SlipCashOut.CashOutValue) from Customer.SlipCashOut with (nolock)  where Customer.SlipCashOut.SlipId=Customer.SlipSystemSlip.SlipId) else case when Customer.SlipSystem.SlipStateId=2 then Customer.SlipSystem.Amount else  Customer.SlipSystem.MaxGain*cast(1 as float) end end end end as PaidAmount '+
					  ' ,Case when Customer.Customer.IsTerminalCustomer=1 and  Customer.Customer.BranchId>0 then BranchId else '''' end as TerminalId '
set @sqlcommand11111='from Customer.SlipSystem  with (nolock) INNER JOIN Customer.SlipSystemSlip with (nolock) ON Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId  INNER JOIN Parameter.SlipState  with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN '+
'Customer.Customer  with (nolock) ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN '+
'Parameter.Source  with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN '+
'Parameter.SlipType  with (nolock) ON Customer.SlipSystem.SlipTypeId = Parameter.SlipType.Id  INNER JOIN '+
'Parameter.SlipStatu with (nolock) ON Customer.SlipSystem.SlipStatuId = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
'Parameter.Currency with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+
'WHERE   Customer.SlipSystem.NewSlipTypeId in (4,5) and 1=1   '+@where2+ ' and '+Replace(REPLACE(@where,'Customer.Slip.SlipId','CUstomer.SlipSystem.SystemSlipId'),'.Slip.','.SlipSystem.')+ @where3 +
' GROUP BY   Customer.SlipSystemSlip.SlipId ,Customer.SlipSystem.NewSlipTypeId,Customer.SlipSystem.MaxGain ,Customer.SlipSystem.[System],Customer.SlipSystem.SlipStateId,Customer.SlipSystem.SystemSlipId,Customer.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, '+
                      'Customer.SlipSystem.Amount, Customer.SlipSystem.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipSystem.CreateDate, Parameter.Source.SourceId, '+
                      'Parameter.Source.Source, Customer.SlipSystem.SlipTypeId, Customer.SlipSystem.SourceId, Parameter.SlipType.SlipType, '+
                      'Parameter.SlipState.StatuColor,  Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.SlipStatu.SlipStatu,Customer.SlipSystem.EventCount,Customer.SlipSystem.IsPayOut,Customer.Customer.IsTerminalCustomer,Customer.Customer.BranchId '+
 ') '+ 
 ' insert @temptable'+ 
' SELECT RowNum,
 SlipId, CustomerId, '+
                      'CustomerName, '+
                      'Amount, TotalOddValue, StateId, State,  CreateDate, SourceId, '+
                      'Source,OddCount,SlipType, SlipTypeId, '+
                      'SlipStateStatuColor,MaxGain,CurrencyId, '+
                      'Currency,SlipStatu,CancelDate
,@total as totalrow,PaidAmount,TerminalId '+
  'FROM OrdersRN '

if (CHARINDEX('m:',@where) = 0 and CHARINDEX('Customer.Slip.SlipStateId = 1',@where)  = 0)
begin
 set @where=REPLACE(@where,'Customer.Slip','Archive.Slip')
 set @orderby=REPLACE(@orderby,'Customer.Slip','Archive.Slip')
 
 --select @where
  
 if(@SlipId>0)
	set @where3=' and Archive.Slip.SlipId='+cast(@SlipId as nvarchar(30))

set @sqlcommand2=' select @total+=COUNT(DISTINCT Archive.Slip.SlipId) '+
'FROM Customer.Customer with (nolock) INNER JOIN '+
                      'Archive.Slip with (nolock) ON Customer.Customer.CustomerId = Archive.Slip.CustomerId INNER JOIN '+
                    -- 'Archive.SlipOdd ON Archive.Slip.SlipId = Archive.SlipOdd.SlipId INNER JOIN '+
                      'Parameter.SlipState with (nolock) ON Archive.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN '+
                      'Parameter.Source with (nolock) ON Archive.Slip.SourceId = Parameter.Source.SourceId INNER JOIN '+
                      'Parameter.SlipType with (nolock) ON Archive.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN '+
                       'Parameter.SlipStatu with (nolock) ON Archive.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
                      'Parameter.Currency with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+
' WHERE 1=1 and Archive.Slip.SlipTypeId<3   '+@where2+ ' and '+@where + @where3 +' ; ' +
' WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Archive.Slip.SlipId) AS RowNum, '+
'  Archive.Slip.SlipId, Archive.Slip.CustomerId, '+
                      'Customer.Customer.CustomerName + '' '' + Customer.Customer.CustomerSurname + '' ( '' + Customer.Customer.Username + '' ) '' AS CustomerName, '+
                      'Archive.Slip.Amount as Amount, Archive.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Archive.Slip.CreateDate  as CreateDate, Parameter.Source.SourceId, '+
                      'Parameter.Source.Source, ISNULL(Archive.Slip.EventCount,0) AS OddCount,case when Archive.Slip.IsLive=1 then '' * '' else '''' end+'' ''+ Parameter.SlipType.SlipType as SlipType, Archive.Slip.SlipTypeId, '+
                      'Parameter.SlipState.StatuColor AS SlipStateStatuColor,cast(Archive.Slip.Amount * Archive.Slip.TotalOddValue as float) AS MaxGain, Customer.Customer.CurrencyId, '+
                      'Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,GETDATE() as CancelDate,case when Archive.Slip.IsPayOut=0 or Archive.Slip.IsPayOut is null  then 0 else case when Archive.Slip.SlipStateId in (3) then  Archive.Slip.Amount*Archive.Slip.TotalOddValue else case when Archive.Slip.SlipStateId in (2) then Archive.Slip.Amount*1.05  else case when Archive.Slip.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut where Customer.SlipCashout.SlipId=Archive.Slip.SlipId) else 0 end end end end as PaidAmount '+
					  ' ,Case when Customer.Customer.IsTerminalCustomer=1 and  Customer.Customer.BranchId>0 then BranchId else '''' end as TerminalId '
set @sqlcommand3='FROM  Customer.Customer with (nolock) INNER JOIN '+
                      ' Archive.Slip with (nolock) ON Customer.Customer.CustomerId = Archive.Slip.CustomerId INNER JOIN '+
                    --  ' Archive.SlipOdd ON Archive.Slip.SlipId = Archive.SlipOdd.SlipId INNER JOIN '+
                      'Parameter.SlipState with (nolock) ON Archive.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN '+
                      'Parameter.Source with (nolock) ON Archive.Slip.SourceId = Parameter.Source.SourceId INNER JOIN '+
                      'Parameter.SlipType with (nolock) ON Archive.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN '+
                       'Parameter.SlipStatu with (nolock) ON Archive.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
                      'Parameter.Currency with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+
'WHERE 1=1 and Archive.Slip.SlipTypeId<3   '+@where2+ ' and '+@where+ @where3 +
' GROUP BY Archive.Slip.SlipId, Archive.Slip.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, '+
                      'Archive.Slip.Amount, Archive.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Archive.Slip.CreateDate, Parameter.Source.SourceId, '+
                      'Parameter.Source.Source, Archive.Slip.SlipTypeId, Archive.Slip.SourceId, Parameter.SlipType.SlipType, '+
                      'Parameter.SlipState.StatuColor,  Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.SlipStatu.SlipStatu,Archive.Slip.EventCount,Archive.Slip.IsLive,Archive.Slip.IsPayOut ,Archive.Slip.SlipStateId,Customer.Customer.IsTerminalCustomer,Customer.Customer.BranchId '+
 ') '+ 
 ' insert @temptable'+ 
' SELECT RowNum+(select ISNULL(Count(RowNum),0) from @temptable),
 SlipId, CustomerId, '+
                      'CustomerName, '+
                      'Amount, TotalOddValue, StateId, State,  CreateDate, SourceId, '+
                      'Source,OddCount,SlipType, SlipTypeId, '+
                      'SlipStateStatuColor,MaxGain,CurrencyId, '+
                      'Currency,SlipStatu,CancelDate
,@total as totalrow,PaidAmount,TerminalId '+
  'FROM OrdersRN '

   set @where=REPLACE(@where,'Archive.Slip','Archive.SlipOld')
 set @orderby=REPLACE(@orderby,'Archive.Slip','Archive.SlipOld')


--  set @sqlcommand5=' select @total+=COUNT(DISTINCT Archive.SlipOld.SlipId) '+
--'FROM Customer.Customer with (nolock) INNER JOIN '+
--                      'Archive.SlipOld with (nolock) ON Customer.Customer.CustomerId = Archive.SlipOld.CustomerId INNER JOIN '+
--                    -- 'Archive.SlipOdd ON Archive.SlipOld.SlipId = Archive.SlipOdd.SlipId INNER JOIN '+
--                      'Parameter.SlipState with (nolock) ON Archive.SlipOld.SlipStateId = Parameter.SlipState.StateId INNER JOIN '+
--                      'Parameter.Source with (nolock) ON Archive.SlipOld.SourceId = Parameter.Source.SourceId INNER JOIN '+
--                      'Parameter.SlipType with (nolock) ON Archive.SlipOld.SlipTypeId = Parameter.SlipType.Id INNER JOIN '+
--                       'Parameter.SlipStatu with (nolock) ON Archive.SlipOld.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
--                      'Parameter.Currency with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+
--' WHERE 1=1 and Archive.SlipOld.SlipTypeId<3   '+@where2+ ' and '+@where + @where3 +' ; ' +
--' WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Archive.SlipOld.SlipId) AS RowNum, '+
--'  Archive.SlipOld.SlipId, Archive.SlipOld.CustomerId, '+
--                      'Customer.Customer.CustomerName + '' '' + Customer.Customer.CustomerSurname + '' ( '' + Customer.Customer.Username + '' ) '' AS CustomerName, '+
--                      'Archive.SlipOld.Amount as Amount, Archive.SlipOld.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Archive.SlipOld.CreateDate  as CreateDate, Parameter.Source.SourceId, '+
--                      'Parameter.Source.Source, ISNULL(Archive.SlipOld.EventCount,0) AS OddCount,case when Archive.SlipOld.IsLive=1 then '' * '' else '''' end+'' ''+ Parameter.SlipType.SlipType as SlipType, Archive.SlipOld.SlipTypeId, '+
--                      'Parameter.SlipState.StatuColor AS SlipStateStatuColor,cast(Archive.SlipOld.Amount * Archive.SlipOld.TotalOddValue as float) AS MaxGain, Customer.Customer.CurrencyId, '+
--                      'Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,GETDATE() as CancelDate,case when Archive.SlipOld.IsPayOut=0 or Archive.SlipOld.IsPayOut is null  then 0 else case when Archive.SlipOld.SlipStateId in (3) then  Archive.SlipOld.Amount*Archive.SlipOld.TotalOddValue else case when Archive.SlipOld.SlipStateId in (2) then Archive.SlipOld.Amount*1.05  else case when Archive.SlipOld.SlipStateId in (7) then (Select SUM(CashOutValue) from Customer.SlipCashOut where Customer.SlipCashout.SlipId=Archive.SlipOld.SlipId) else 0 end end end end as PaidAmount '+
--					  ' ,Case when Customer.Customer.IsTerminalCustomer=1 and  Customer.Customer.BranchId>0 then BranchId else '''' end as TerminalId '
--set @sqlcommand6='FROM  Customer.Customer with (nolock) INNER JOIN '+
--                      ' Archive.SlipOld with (nolock) ON Customer.Customer.CustomerId = Archive.SlipOld.CustomerId INNER JOIN '+
--                    --  ' Archive.SlipOdd ON Archive.SlipOld.SlipId = Archive.SlipOdd.SlipId INNER JOIN '+
--                      'Parameter.SlipState with (nolock) ON Archive.SlipOld.SlipStateId = Parameter.SlipState.StateId INNER JOIN '+
--                      'Parameter.Source with (nolock) ON Archive.SlipOld.SourceId = Parameter.Source.SourceId INNER JOIN '+
--                      'Parameter.SlipType with (nolock) ON Archive.SlipOld.SlipTypeId = Parameter.SlipType.Id INNER JOIN '+
--                       'Parameter.SlipStatu with (nolock) ON Archive.SlipOld.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
--                      'Parameter.Currency with (nolock) ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(5))+' '+
--'WHERE 1=1 and Archive.SlipOld.SlipTypeId<3   '+@where2+ ' and '+@where+ @where3 +
--' GROUP BY Archive.SlipOld.SlipId, Archive.SlipOld.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, '+
--                      'Archive.SlipOld.Amount, Archive.SlipOld.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Archive.SlipOld.CreateDate, Parameter.Source.SourceId, '+
--                      'Parameter.Source.Source, Archive.SlipOld.SlipTypeId, Archive.SlipOld.SourceId, Parameter.SlipType.SlipType, '+
--                      'Parameter.SlipState.StatuColor,  Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.SlipStatu.SlipStatu,Archive.SlipOld.EventCount,Archive.SlipOld.IsLive,Archive.SlipOld.IsPayOut ,Archive.SlipOld.SlipStateId,Customer.Customer.IsTerminalCustomer,Customer.Customer.BranchId '+
-- ') '+ 
-- ' insert @temptable'+ 
--' SELECT RowNum+(select ISNULL(Count(RowNum),0) from @temptable),
-- SlipId, CustomerId, '+
--                      'CustomerName, '+
--                      'Amount, TotalOddValue, StateId, State,  CreateDate, SourceId, '+
--                      'Source,OddCount,SlipType, SlipTypeId, '+
--                      'SlipStateStatuColor,MaxGain,CurrencyId, '+
--                      'Currency,SlipStatu,CancelDate
--,@total as totalrow,ISNULL(PaidAmount,0),TerminalId '+
--  'FROM OrdersRN '


 end


  declare @sqlcommand4 nvarchar(max)=' select RowNum ,SlipId ,CustomerId ,CustomerName , Amount  as Amount 
  ,TotalOddValue ,StateId ,State , CreateDate ,SourceId ,Source ,OddCount ,SlipType ,SlipTypeId ,SlipStateStatuColor 
  , MaxGain AS MaxGain ,CurrencyId,Currency ,SlipStatu,dbo.UserTimeZoneDate('''+@Username+''',CancelDate,0) as CancelDate , @total as totalrow,cast(Paid as money) as Paid,TerminalId from @temptable'+
   ' WHERE SlipId is not null and RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) Order by ' +cast(@OrderBy as nvarchar(50))
--end
exec (@sqlcommand0+@sqlcommand+@sqlcommand1+@sqlcommand11+@sqlcommand111+@sqlcommand1111+@sqlcommand11111+@sqlcommand2+@sqlcommand3+@sqlcommand5+@sqlcommand6+@sqlcommand4)


--select @sqlcommand0,@sqlcommand,@sqlcommand1,@sqlcommand11,@sqlcommand111,@sqlcommand1111,@sqlcommand11111,@sqlcommand2,@sqlcommand3,@sqlcommand4



--declare @total int
--select @total=COUNT(DISTINCT Customer.Slip.SlipId) 
--FROM Customer.Customer INNER JOIN 
--                      Customer.Slip ON Customer.Customer.CustomerId = Customer.Slip.CustomerId INNER JOIN 
--                      --'Customer.SlipOdd ON Customer.Slip.SlipId = Customer.SlipOdd.SlipId INNER JOIN 
--                      Parameter.SlipState ON Customer.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN 
--                      Parameter.Source ON Customer.Slip.SourceId = Parameter.Source.SourceId INNER JOIN 
--                      Parameter.SlipType ON Customer.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN 
--                      Parameter.SlipStatu ON Customer.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN 
--                      Parameter.Currency ON   Parameter.Currency.CurrencyId =3
--					   WHERE Customer.Slip.SlipStateId=1  and  Customer.Slip.SlipId in (select SlipId from Customer.SlipOdd where EventDate<DATEADD(HOUR,-5,GETDATE()) and StateId=1); 
-- WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.Slip.SlipId) AS RowNum, 
-- Customer.Slip.SlipId, Customer.Slip.CustomerId, 
--                      Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName, 
--                       Customer.Slip.Amount  as Amount, Customer.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.Slip.CreateDate  as CreateDate, Parameter.Source.SourceId, 
--                      Parameter.Source.Source, ISNULL(Customer.Slip.EventCount,0) AS OddCount,case when Customer.Slip.IsLive=1 then '' else '' end+ ''+ Parameter.SlipType.SlipType as SlipType, Customer.Slip.SlipTypeId, 
--                      Parameter.SlipState.StatuColor AS SlipStateStatuColor,cast( Customer.Slip.Amount * Customer.Slip.TotalOddValue as float) AS MaxGain, Customer.Customer.CurrencyId, 
--                      Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu 
--FROM  Customer.Customer INNER JOIN 
--                      Customer.Slip ON Customer.Customer.CustomerId = Customer.Slip.CustomerId INNER JOIN 
--                     -- ' Customer.SlipOdd ON Customer.Slip.SlipId = Customer.SlipOdd.SlipId INNER JOIN 
--                      Parameter.SlipState ON Customer.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN 
--                      Parameter.Source ON Customer.Slip.SourceId = Parameter.Source.SourceId INNER JOIN 
--                      Parameter.SlipType ON Customer.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN 
--                       Parameter.SlipStatu ON Customer.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN 
--                      Parameter.Currency ON   Parameter.Currency.CurrencyId =3
--WHERE Customer.Slip.SlipStateId=1  and  Customer.Slip.SlipId in (select SlipId from Customer.SlipOdd where EventDate<DATEADD(HOUR,-5,GETDATE()) and StateId=1)
-- GROUP BY Customer.Slip.SlipId, Customer.Slip.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
--                      Customer.Slip.Amount, Customer.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.Slip.CreateDate, Parameter.Source.SourceId, 
--                      Parameter.Source.Source, Customer.Slip.SlipTypeId, Customer.Slip.SourceId, Parameter.SlipType.SlipType, 
--                      Parameter.SlipState.StatuColor,  Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.SlipStatu.SlipStatu,Customer.Slip.EventCount,Customer.Slip.IsLive 
-- ) 
-- SELECT RowNum,
-- SlipId, CustomerId, 
--                      CustomerName, 
--                      Amount, TotalOddValue, StateId, State,  CreateDate, SourceId, 
--                      Source,OddCount,SlipType, SlipTypeId, 
--                      SlipStateStatuColor,MaxGain,CurrencyId, 
--                      Currency,SlipStatu
--,@total as totalrow 
--  FROM OrdersRN 
  


END




GO
