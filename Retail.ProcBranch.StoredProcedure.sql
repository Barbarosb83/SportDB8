USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBranch]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Retail].[ProcBranch]
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100),
@BranchId int,
@LangId int


AS


BEGIN
SET NOCOUNT ON;



declare @UserCurrencyId int
declare @UserBranchId int
declare @sqlcommand nvarchar(max)=''
declare @sqlcommand0 nvarchar(max)=''
declare @sqlcommand1 nvarchar(max)=''
declare @SystemCurrencyId int
select top 1 @SystemCurrencyId=SystemCurrencyId from General.Setting 
 

select @UserBranchId =UnitCode,@UserCurrencyId=Users.Users.CurrencyId from Users.Users where UserName=@Username

declare @where2 nvarchar(max)=''


if(@BranchId=0)
	set @where2=' Parameter.Branch.IsActive=1 and ( Parameter.Branch.BranchId='+cast(@UserBranchId as nvarchar(7))+' or Parameter.Branch.BranchId in (select BranchId from Parameter.Branch where Parameter.Branch.[ParentBranchId]='+cast(@UserBranchId as nvarchar(7))+') or Parameter.Branch.BranchId in (select BranchId from Parameter.Branch where ParentBranchId in (select BranchId from Parameter.Branch where Parameter.Branch.[ParentBranchId]='+cast(@UserBranchId as nvarchar(7))+')))'
else if(@BranchId>0)
	set @where2=' (Parameter.Branch.IsActive=1 and Parameter.Branch.BranchId='+cast(@BranchId as nvarchar(7))+')'
else
	set @where2='(Parameter.Branch.IsActive=1 and Parameter.Branch.ParentBranchId='+cast(@UserBranchId as nvarchar(7))+')'


 set @sqlcommand0= 'declare @TempTable table (BranchId int,BrancName nvarchar(100),Balance money, CommisionRate float,CreateDate datetime,IsActive bit,CurrencyId int,Currency nvarchar(50),BranchCommisionTypeId int,IsBonusDeducting bit,CommissionType nvarchar(50),MaxWinningLimit money
,MaxCopySlip int,BrachCode int,MinTicketLimit money,MaxEventForTicket int,ParentBranch nvarchar(100),UserName nvarchar(150),IsWebPos bit,CreditLimit money,CreditCurrent money,Address nvarchar(250) ) '



 set @sqlcommand1 += 'insert @TempTable '+
	'select Parameter.Branch.BranchId,Parameter.Branch.BrancName,Parameter.Branch.Balance,Parameter.Branch.CommisionRate '+
', Parameter.Branch.CreateDate '+
',Parameter.Branch.IsActive,Parameter.Branch.CurrencyId, '+
'Parameter.Currency.Currency,cast(0 as int) BranchCommisionTypeId, '+
'Parameter.Branch.IsBonusDeducting,'''' as CommissionType, '+
'Parameter.Branch.MaxWinningLimit,Parameter.Branch.MaxCopySlip, '+
'Parameter.Branch.BranchId as BrachCode, '+
'Parameter.Branch.MinTicketLimit, '+
'Parameter.Branch.MaxEventForTicket '+
',(Select PB.BrancName From Parameter.Branch  as  PB with (nolock) where PB.BranchId=Parameter.Branch.ParentBranchId) as ParentBranch  '+
',Users.UserName,Parameter.Branch.IsWebPos '+
',(select    SUM(Amount)  from RiskManagement.BranchDepositRequest with (nolock) where RiskManagement.BranchDepositRequest.BranchId=Parameter.Branch.BranchId and TransactionTypeId=3 and IsApproved=1 )-(select    ISNULL(SUM(Amount),0)  from RiskManagement.BranchDepositRequest with (nolock) where RiskManagement.BranchDepositRequest.BranchId=Parameter.Branch.BranchId and TransactionTypeId=5 and IsApproved=1) as CreditLimit '+
',case when ((select    SUM(Amount)  from RiskManagement.BranchDepositRequest with (nolock) where RiskManagement.BranchDepositRequest.BranchId=Parameter.Branch.BranchId and TransactionTypeId=3 and IsApproved=1 )-(select    ISNULL(SUM(Amount),0)  from RiskManagement.BranchDepositRequest with (nolock) where RiskManagement.BranchDepositRequest.BranchId=Parameter.Branch.BranchId and TransactionTypeId=5 and IsApproved=1)-Parameter.Branch.Balance)<0 then 0 else ((select    SUM(Amount)  from RiskManagement.BranchDepositRequest with (nolock) where RiskManagement.BranchDepositRequest.BranchId=Parameter.Branch.BranchId and TransactionTypeId=3 and IsApproved=1 )-(select    ISNULL(SUM(Amount),0)  from RiskManagement.BranchDepositRequest with (nolock) where RiskManagement.BranchDepositRequest.BranchId=Parameter.Branch.BranchId and TransactionTypeId=5 and IsApproved=1)-Parameter.Branch.Balance) end as CreditCurrent '+
',Parameter.Branch.Address '+
'from Parameter.Branch with (nolock) INNER JOIN '+
'Users.Users with (nolock) ON Users.UnitCode=Parameter.Branch.BranchId INNER JOIN  Users.UserRoles with (nolock) On Users.Users.UserId=Users.UserRoles.UserId and Users.UserRoles.RoleId=2 INNER JOIN '+
'Parameter.Currency on Parameter.Currency.CurrencyId=Parameter.Branch.CurrencyId  '+
' where  '+@where2+' '



set @sqlcommand= 'declare @total int '+
 'select @total=COUNT(BranchId) '+
 'from @TempTable '+
'WHERE 1=1; '+
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY BranchId) AS RowNum, '+
	 'BranchId, BrancName, Balance, CommisionRate '+
', CreateDate '+
', IsActive, CurrencyId, '+
' Currency, BranchCommisionTypeId, '+
' IsBonusDeducting, CommissionType, '+
' MaxWinningLimit, MaxCopySlip, '+
'  BrachCode, '+ 
' MinTicketLimit,  '+
' MaxEventForTicket '+
', ParentBranch  '+
', UserName, IsWebPos '+
',CreditLimit '+
',CreditCurrent,Address,cast(0 as bit) as IsCasino '+
'from @TempTable '+
'WHERE BranchId <> '+cast(@UserBranchId as nvarchar(20))+' and '+@where+
' )   '+
'SELECT *,@total as totalrow '+
'  FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '




exec (@sqlcommand0+@sqlcommand1+@sqlcommand) 



END





GO
