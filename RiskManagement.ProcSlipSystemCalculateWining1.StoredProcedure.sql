USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSlipSystemCalculateWining1]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcSlipSystemCalculateWining1] 
@Counter int,
@Index int,
@Odd float,
@EventPerBet int,
@Odds nvarchar(300),
@StakePerBet money,
@Wining1 money
as 


Begin
--select'ProcSlipSystemCalculateWining' as StartSP, @Counter,@Index,@Odd,@EventPerBet,@Odds,@StakePerBet,@Wining1
 
declare @Odds1 nvarchar(300)=@odds
--declare @Winning money =@Wining1
declare @EventPerBet1 int=@EventPerBet
declare @StakePerBet1 money=@StakePerBet

DECLARE @Delimeter char(1)
SET @Delimeter = ';'
declare @sayac int=0
DECLARE @tblOdd TABLE(Id int,oddvalue float)
DECLARE @tbltemp TABLE(Id int)
DECLARE @ak nvarchar(10)
DECLARE @StartPos int, @Length int
WHILE LEN(@Odds) > 0
  BEGIN
    SET @StartPos = CHARINDEX(@Delimeter, @Odds)
    IF @StartPos < 0 SET @StartPos = 0
    SET @Length = LEN(@Odds) - @StartPos - 1
    IF @Length < 0 SET @Length = 0
    IF @StartPos > 0
      BEGIN
        SET @ak = SUBSTRING(@Odds, 1, @StartPos - 1)
        SET @Odds = SUBSTRING(@Odds, @StartPos + 1, LEN(@Odds) - @StartPos)
        set @sayac=@sayac+1
      END
    ELSE
      BEGIN
        SET @ak = @Odds
        SET @Odds = ''
        set @sayac=@sayac+1
      END
    INSERT @tblOdd (Id,oddvalue) VALUES(@sayac,@ak)
END

declare @Odd1 float =@Odd
declare @index1 int=@Index

 
while @index1<(((select COUNT(*) from @tblOdd) -@EventPerBet)+(@Counter))
begin
	
	
	set @Odd1=@Odd*(Select oddvalue from @tblOdd  where Id=@index1+1 )
 
		
	if(@Counter<@EventPerBet)
	begin
				declare @Counter_p int =@Counter+1
			declare @Index_p int =@index1+1
			--select  'ProcSlipSystemCalculateWining' as SP,  @Counter as Counter1,@index1 as Index1,@Odd1 as Odd1,@EventPerBet as EventPerBet,@Odds1 as Odds,@StakePerBet as StaketPerbet,@Wining1 as Wining
			select @Counter_p, @Odd1
			exec @Wining1=[RiskManagement].[ProcSlipSystemCalculateWining] @Counter_p,@Index_p,@Odd1,@EventPerBet1,@Odds1,@StakePerBet1,@Wining1
			
	end
	else
		begin
		
		set @Wining1=@Wining1+(@Odd1*@StakePerBet)
		--select 'Else',@Counter,@Odd1
		end

	set @index1=@index1+1
end

select @Wining1 



End
GO
