USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerSlip]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [RiskManagement].[ProcCustomerSlip] 
@CustomerId bigint,
@StateId int,
@SlipDate datetime,
@LangId int,
@PageSize  INT,
@PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(200)
AS

BEGIN
SET NOCOUNT ON;

declare @UserCurrencyId int

select @UserCurrencyId=Users.Users.CurrencyId from Users.Users with (nolock) where Users.Users.UserName=@Username

--declare @total int
--select @total=COUNT( Customer.Slip.SlipId) 
--FROM         Customer.Slip INNER JOIN
--                      Parameter.SlipState ON Customer.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN
--                       Parameter.SlipStatu ON Customer.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN
--                      Parameter.SlipType ON Customer.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN
--                      Parameter.Currency ON Parameter.Currency.CurrencyId  = @UserCurrencyId  INNER JOIN
--                       Customer.Customer ON Customer.Customer.CustomerId = Customer.Slip.CustomerId 
--WHERE (1 = 1) ; 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.Slip.SlipId) AS RowNum, 
--	Customer.Slip.SlipId, Customer.Slip.CreateDate,dbo.FuncCurrencyConverter(Customer.Slip.Amount,Customer.Customer.CurrencyId,@UserCurrencyId) as Amount, Customer.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, 
--                      Parameter.SlipType.SlipType, CASE WHEN SlipStateId <> 4 THEN dbo.FuncCurrencyConverter(Customer.Slip.TotalOddValue * Customer.Slip.Amount,Customer.Customer.CurrencyId,'+cast(@UserCurrencyId as nvarchar(2))+') ELSE 0 END AS Gain,(Select COUNT(CSlip.SlipId) from Customer.Slip as CSlip where CSlip.GroupId=Customer.Slip.GroupId) As Bets
--                      ,Parameter.SlipStatu.SlipStatu,Parameter.SlipState.StatuColor AS SlipStateStatuColor,Parameter.Currency.Currency 
--FROM         Customer.Slip INNER JOIN
--                      Parameter.SlipState ON Customer.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN
--                       Parameter.SlipStatu ON Customer.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN
--                      Parameter.SlipType ON Customer.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN
--                      Parameter.Currency ON Parameter.Currency.CurrencyId  =@UserCurrencyId  INNER JOIN
--                       Customer.Customer ON Customer.Customer.CustomerId = Customer.Slip.CustomerId 
--WHERE (1 = 1) 
-- )  
--SELECT *,@total as totalrow 
--  FROM OrdersRN 
--  WHERE RowNum BETWEEN ((@PageNum-1 )*(@PageSize))+1 AND (@PageNum * @PageSize ) 

declare @sqlcommand0 nvarchar(max)
declare @sqlcommand nvarchar(max)

set @sqlcommand0=' declare @temptable table (RowNum bigint,SlipId bigint,CreateDate datetime,Amount money,TotalOddValue float,StateId int,[State] nvarchar(20),SlipType nvarchar(20),Gain money,Bets int,SlipStatu nvarchar(50),SlipStateStatuColor nvarchar(20),Currency nvarchar(20),totalrow int)'
										
set @sqlcommand='declare @total int '+
'select @total=COUNT( Customer.Slip.SlipId) '+
'FROM         Customer.Slip with (nolock) INNER JOIN '+
                      'Parameter.SlipState with (nolock) ON Customer.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN '+
                       'Parameter.SlipStatu with (nolock) ON Customer.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
                      'Parameter.SlipType with (nolock) ON Customer.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN '+
                      'Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  = '+cast(@UserCurrencyId as nvarchar(2))+'  INNER JOIN '+
                       'Customer.Customer with (nolock) ON Customer.Customer.CustomerId = Customer.Slip.CustomerId '+
'WHERE (1 = 1) and Customer.Slip.CustomerId='+cast(@CustomerId as nvarchar(15)) +'  and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	Customer.Slip.SlipId, dbo.UserTimeZoneDate('''+@Username +''',Customer.Slip.CreateDate,0) as CreateDate,Customer.Slip.Amount as Amount, Customer.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, '+
                      'Parameter.SlipType.SlipType, CASE WHEN SlipStateId <> 4 THEN Customer.Slip.TotalOddValue * Customer.Slip.Amount ELSE 0 END AS Gain,(Select COUNT(CSlip.SlipId) from Customer.Slip as CSlip where CSlip.GroupId=Customer.Slip.GroupId) As Bets '+
                      ',Parameter.SlipStatu.SlipStatu,Parameter.SlipState.StatuColor AS SlipStateStatuColor,Parameter.Currency.Currency '+
'FROM         Customer.Slip with (nolock) INNER JOIN '+
                      'Parameter.SlipState with (nolock) ON Customer.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN '+
                       'Parameter.SlipStatu with (nolock) ON Customer.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
                      'Parameter.SlipType with (nolock) ON Customer.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN '+
                      'Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  = '+cast(@UserCurrencyId as nvarchar(2))+'  INNER JOIN '+
                       'Customer.Customer with (nolock) ON Customer.Customer.CustomerId = Customer.Slip.CustomerId '+
'WHERE (1 = 1) and Customer.Slip.CustomerId='+cast(@CustomerId as nvarchar(15)) +' and '+@where +
 ') '+  
 ' insert @temptable '+
' SELECT  RowNum,SlipId, CreateDate, Amount, TotalOddValue, StateId, State, '+
                      'SlipType,  Gain, Bets '+
                      ',SlipStatu,SlipStateStatuColor,Currency ,@total '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


 declare @sqlcommand1 nvarchar(max)

 set @where=REPLACE(@where,'Customer.Slip','Archive.Slip')
 set @orderby=REPLACE(@orderby,'Customer.Slip','Archive.Slip')
 								
set @sqlcommand1=' select @total=COUNT( Archive.Slip.SlipId) '+
'FROM         Archive.Slip with (nolock) INNER JOIN '+
                      'Parameter.SlipState with (nolock) ON Archive.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN '+
                       'Parameter.SlipStatu with (nolock) ON Archive.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
                      'Parameter.SlipType with (nolock) ON Archive.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN '+
                      'Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  = '+cast(@UserCurrencyId as nvarchar(2))+'  INNER JOIN '+
                       'Customer.Customer with (nolock) ON Customer.Customer.CustomerId = Archive.Slip.CustomerId '+
'WHERE (1 = 1) and Archive.Slip.CustomerId='+cast(@CustomerId as nvarchar(15)) +'  and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	Archive.Slip.SlipId, dbo.UserTimeZoneDate('''+@Username +''',Archive.Slip.CreateDate,0) as CreateDate,Archive.Slip.Amount as Amount, Archive.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, '+
                      'Parameter.SlipType.SlipType, CASE WHEN SlipStateId <> 4 THEN Archive.Slip.TotalOddValue * Archive.Slip.Amount ELSE 0 END AS Gain,(Select COUNT(CSlip.SlipId) from Archive.Slip as CSlip where CSlip.GroupId=Archive.Slip.GroupId) As Bets '+
                      ',Parameter.SlipStatu.SlipStatu,Parameter.SlipState.StatuColor AS SlipStateStatuColor,Parameter.Currency.Currency '+
'FROM         Archive.Slip with (nolock) INNER JOIN '+
                      'Parameter.SlipState with (nolock) ON Archive.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN '+
                       'Parameter.SlipStatu with (nolock)  ON Archive.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN '+
                      'Parameter.SlipType with (nolock) ON Archive.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN '+
                      'Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  = '+cast(@UserCurrencyId as nvarchar(2))+'  INNER JOIN '+
                       'Customer.Customer with (nolock) ON Customer.Customer.CustomerId = Archive.Slip.CustomerId '+
'WHERE (1 = 1) and Archive.Slip.CustomerId='+cast(@CustomerId as nvarchar(15)) +' and '+@where +
 ') '+  
 ' insert @temptable '+
' SELECT  RowNum,SlipId, CreateDate, Amount, TotalOddValue, StateId, State, '+
                      'SlipType,  Gain, Bets '+
                      ',SlipStatu,SlipStateStatuColor,Currency ,@total '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '



 declare @sqlcommand2 nvarchar(max)=' select * from @temptable'

execute (@sqlcommand0+  @sqlcommand+ @sqlcommand1+@sqlcommand2)  


END




GO
