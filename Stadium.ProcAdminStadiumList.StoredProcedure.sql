USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Stadium].[ProcAdminStadiumList]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [Stadium].[ProcAdminStadiumList] 
@BranchId bigint,
@LangId int,
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(200)
AS

BEGIN
SET NOCOUNT ON;





declare @sqlcommand nvarchar(max)
declare @sqlcommand2 nvarchar(max)
declare @sqlcommand3 nvarchar(max)



--declare @total int 

--select @total=COUNT([Stadium].[Stadium].StadiumId) 
--FROM  [Stadium].[Stadium] with (nolock) INNER JOIN Parameter.Currency  with (nolock)  On [Stadium].[Stadium].CurrencyId=Parameter.Currency.CurrencyId ; 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY [Stadium].[Stadium].StadiumId) AS RowNum,
-- [StadiumId],[BranchId],[EntranceFee],Parameter.Currency.CurrencyId,Parameter.Currency.Sybol,[MaxPlayer],[MinPlayer],[MinOddValue],[MaxOddValue],[ServiceFee],[CardChangeCount]
--      ,[CardView],[CreateDate],[IsActive],[Comment],[StartDate],[EndDate],ActivePlayerCount as CustomerCount
--	  ,(ISNULL((select COUNT(*) from Stadium.Customers where Stadium.Customers.StadiumId=[Stadium].[Stadium].StadiumId),0)*[EntranceFee])-((ISNULL((select COUNT(*) from Stadium.Customers where Stadium.Customers.StadiumId=[Stadium].[Stadium].StadiumId),0)*[EntranceFee])*(ServiceFee/100)) as winamount
--	  ,case when (Select Count(*) from Stadium.Sports where Stadium.Sports.StadiumId=[Stadium].[Stadium].StadiumId and SportId=-1)>0 then 'All Sport' else (Select Language.[Parameter.Sport].SportName from Stadium.Sports INNER JOIN Language.[Parameter.Sport] ON Stadium.Sports.SportId=Language.[Parameter.Sport].SportId where Stadium.Sports.StadiumId=[Stadium].[Stadium].StadiumId and LanguageId=@LangId) end SportName
--	  ,case when (Select Count(*) from Stadium.Tournament where Stadium.Tournament.StadiumId=[Stadium].[Stadium].StadiumId and TournamentId=-1)>0 then 'All' else (Select Language.[Parameter.Tournament].TournamentName from Stadium.Tournament INNER JOIN Language.[Parameter.Tournament] ON Stadium.Tournament.TournamentId=[Parameter.Tournament].TournamentId where Stadium.Tournament.StadiumId=[Stadium].[Stadium].StadiumId and LanguageId=@LangId) end Tournament
--	  ,'All' as EventName
--FROM         [Stadium].[Stadium] with (nolock) INNER JOIN Parameter.Currency  with (nolock)  On [Stadium].[Stadium].CurrencyId=Parameter.Currency.CurrencyId 
--WHERE BranchId=@BranchId
--)  
--SELECT *,@total as totalrow 
--FROM OrdersRN 
--WHERE RowNum BETWEEN ((@PageNum-1 )*(@PageSize))+1 AND (@PageNum * @PageSize ) 




set @sqlcommand='declare @total int '+
'select @total=COUNT([Stadium].[Stadium].StadiumId)  '+
'FROM       [Stadium].[Stadium] with (nolock) INNER JOIN Parameter.Currency  with (nolock)  On [Stadium].[Stadium].CurrencyId=Parameter.Currency.CurrencyId ' +
                      'WHERE BranchId='+cast(@BranchId as nvarchar(10))+' and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'[StadiumId],[BranchId],[EntranceFee],Parameter.Currency.CurrencyId,Parameter.Currency.Sybol,[MaxPlayer],[MinPlayer],[MinOddValue],[MaxOddValue],[ServiceFee],[CardChangeCount]
      ,[CardView],[CreateDate],[IsActive],[Comment],[StartDate],[EndDate],ActivePlayerCount as CustomerCount
	  ,(ISNULL((select COUNT(*) from Stadium.Customers where Stadium.Customers.StadiumId=[Stadium].[Stadium].StadiumId),0)*[EntranceFee])-((ISNULL((select COUNT(*) from Stadium.Customers where Stadium.Customers.StadiumId=[Stadium].[Stadium].StadiumId),0)*[EntranceFee])*(ServiceFee/100)) as winamount
	  ,((ISNULL((select COUNT(*) from Stadium.Customers where Stadium.Customers.StadiumId=[Stadium].[Stadium].StadiumId),0)*[EntranceFee])*(ServiceFee/100)) as ServiceBalance
	  ,case when (Select Count(*) from Stadium.Sports where Stadium.Sports.StadiumId=[Stadium].[Stadium].StadiumId and SportId=-1)>0 then ''All Sport'' else (Select Language.[Parameter.Sport].SportName from Stadium.Sports INNER JOIN Language.[Parameter.Sport] ON Stadium.Sports.SportId=Language.[Parameter.Sport].SportId where Stadium.Sports.StadiumId=[Stadium].[Stadium].StadiumId and LanguageId='+cast(@LangId as nvarchar(3))+') end SportName
	  ,case when (Select Count(*) from Stadium.Tournament where Stadium.Tournament.StadiumId=[Stadium].[Stadium].StadiumId and TournamentId=-1)>0 then ''All'' else (Select Language.[Parameter.Tournament].TournamentName from Stadium.Tournament INNER JOIN Language.[Parameter.Tournament] ON Stadium.Tournament.TournamentId=[Parameter.Tournament].TournamentId where Stadium.Tournament.StadiumId=[Stadium].[Stadium].StadiumId and LanguageId='+cast(@LangId as nvarchar(3))+') end Tournament
	  ,''All'' as EventName
FROM         [Stadium].[Stadium] with (nolock) INNER JOIN Parameter.Currency  with (nolock)  On [Stadium].[Stadium].CurrencyId=Parameter.Currency.CurrencyId  '+
                      'WHERE  BranchId='+cast(@BranchId as nvarchar(10))+'and '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '



 

exec (@sqlcommand)




END


GO
