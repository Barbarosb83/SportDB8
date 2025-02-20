USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcLuckyStreakCustomerFindByAuthcode]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Casino].[ProcLuckyStreakCustomerFindByAuthcode]
@AuthCode nvarchar(max)


AS


BEGIN
SET NOCOUNT ON;




select Casino.[LuckyStreak.Customer].CustomerId,Casino.[LuckyStreak.Customer].GameId,
Casino.[LuckyStreak.Customer].AuthCode,Customer.Customer.Username,Parameter.Currency.Symbol3 as currency,
Language.Language.Language,Customer.Customer.Balance
from Casino.[LuckyStreak.Customer] INNER JOIN
Customer.Customer ON Customer.Customer.CustomerId=Casino.[LuckyStreak.Customer].CustomerId INNER JOIN
Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.Customer.CurrencyId INNER JOIN
Language.Language ON Language.Language.LanguageId=Customer.Customer.LanguageId
where Casino.[LuckyStreak.Customer].AuthCode=@AuthCode


END


GO
