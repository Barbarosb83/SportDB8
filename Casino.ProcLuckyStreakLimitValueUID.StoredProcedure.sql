USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcLuckyStreakLimitValueUID]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Casino].[ProcLuckyStreakLimitValueUID]
@LimitId bigint,
@Currency nvarchar(3),
@MinValue money,
@MaxValue money

AS


BEGIN
SET NOCOUNT ON;

declare @LimitValueId bigint
declare @CurrencyId int


select @CurrencyId =Parameter.Currency.CurrencyId from Parameter.Currency
where Parameter.Currency.Symbol3=@Currency

if exists (select Casino.[LuckyStreak.LimitValue].LimitValueId from Casino.[LuckyStreak.LimitValue] where Casino.[LuckyStreak.LimitValue].LimitId=@LimitId and Casino.[LuckyStreak.LimitValue].CurrencyId=@CurrencyId)
begin
	update Casino.[LuckyStreak.LimitValue] set 
	MinValue=@MinValue,
	MaxValue=@MaxValue
	where LimitId=@LimitId and CurrencyId=@CurrencyId
end
else
begin

insert Casino.[LuckyStreak.LimitValue] (LimitId,CurrencyId,MinValue,MaxValue)
values (@LimitId,@CurrencyId,@MinValue,@MaxValue)


set @LimitValueId=SCOPE_IDENTITY()
end
select @LimitValueId as LimitValueId

END





GO
