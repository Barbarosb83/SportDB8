USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSlipMultiCalculateWining]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcSlipMultiCalculateWining] 
 
@Counter int,
@Index int,
@ArrayOdd nvarchar(max),
@EventPerBet int,
@MultiOdds nvarchar(max),
@StakePerBet money,
@Wining1 money
 
 AS

Begin
  select @Counter,@EventPerBet
--declare @Winning money =@Wining1
declare @EventPerBet1 int=@EventPerBet
declare @StakePerBet1 money=@StakePerBet
declare @MultiOdds1 nvarchar(300)=@MultiOdds
 



--DECLARE @Delimeter char(1)
--SET @Delimeter = ';'
--declare @sayac int=0
--DECLARE @tblMAtch TABLE(Id int,MatchId bigint)
--DECLARE @tbltemp TABLE(Id int)
--DECLARE @ak nvarchar(10)
--DECLARE @StartPos int, @Length int
--WHILE LEN(@Odds) > 0
--  BEGIN
--    SET @StartPos = CHARINDEX(@Delimeter, @Odds)
--    IF @StartPos < 0 SET @StartPos = 0
--    SET @Length = LEN(@Odds) - @StartPos - 1
--    IF @Length < 0 SET @Length = 0
--    IF @StartPos > 0
--      BEGIN
--        SET @ak = SUBSTRING(@Odds, 1, @StartPos - 1)
--        SET @Odds = SUBSTRING(@Odds, @StartPos + 1, LEN(@Odds) - @StartPos)
--        set @sayac=@sayac+1
--      END
--    ELSE
--      BEGIN
--        SET @ak = @Odds
--        SET @Odds = ''
--        set @sayac=@sayac+1
--      END
--    INSERT @tblMAtch (Id,MatchId) VALUES(@sayac,@ak)
--END



DECLARE @Delimeter2 char(1)
SET @Delimeter2 = ';'
declare @sayac2 int=0
DECLARE @tblMultiOdd TABLE(Id int,oddvalue nvarchar(50))
DECLARE @tbltemp2 TABLE(Id int)
DECLARE @ak2 nvarchar(10)
DECLARE @StartPos2 int, @Length2 int
WHILE LEN(@MultiOdds) > 0
  BEGIN
    SET @StartPos2 = CHARINDEX(@Delimeter2, @MultiOdds)
    IF @StartPos2 < 0 SET @StartPos2 = 0
    SET @Length2 = LEN(@MultiOdds) - @StartPos2 - 1
    IF @Length2 < 0 SET @Length2 = 0
    IF @StartPos2 > 0
      BEGIN
        SET @ak2 = SUBSTRING(@MultiOdds, 1, @StartPos2 - 1)
        SET @MultiOdds = SUBSTRING(@MultiOdds, @StartPos2 + 1, LEN(@MultiOdds) - @StartPos2)
        set @sayac2=@sayac2+1
      END
    ELSE
      BEGIN
        SET @ak2 = @MultiOdds
        SET @MultiOdds = ''
        set @sayac2=@sayac2+1
      END
    INSERT @tblMultiOdd (Id,oddvalue) VALUES(@sayac2,@ak2)
END
 


DECLARE @Delimeter3 char(1)
SET @Delimeter3 = ','
declare @sayac3 int=0
DECLARE @tblArrayOdd TABLE(Id int,oddvalue float)
DECLARE @tbltemp3 TABLE(Id int)
DECLARE @ak3 nvarchar(10)
DECLARE @StartPos3 int, @Length3 int
WHILE LEN(@ArrayOdd) > 0
  BEGIN
    SET @StartPos3 = CHARINDEX(@Delimeter3, @ArrayOdd)
    IF @StartPos3 < 0 SET @StartPos3 = 0
    SET @Length3 = LEN(@ArrayOdd) - @StartPos3 - 1
    IF @Length3 < 0 SET @Length3 = 0
    IF @StartPos3 > 0
      BEGIN
        SET @ak3 = SUBSTRING(@ArrayOdd, 1, @StartPos3 - 1)
        SET @ArrayOdd = SUBSTRING(@ArrayOdd, @StartPos3 + 1, LEN(@ArrayOdd) - @StartPos3)
        set @sayac3=@sayac3+1
      END
    ELSE
      BEGIN
        SET @ak3 = @ArrayOdd
        SET @ArrayOdd = ''
        set @sayac3=@sayac3+1
      END
    INSERT @tblArrayOdd (Id,oddvalue) VALUES(@sayac3,@ak3)
END

  


--select * from @tblMAtch
declare @ArrayOdd1 nvarchar(300)=''
declare @ArrayOdd2 nvarchar(300)=''
--declare @Odd1 float =@Odd
declare @index1 int=@Index


select (select  COUNT(*) from @tblMultiOdd),@EventPerBet,@Counter
 
while @index1<(((select COUNT(*) from @tblMultiOdd) -@EventPerBet)+(@Counter))
begin
	select @index1
	 		declare @x int=0
			while @x<(select COUNT(*) from @tblArrayOdd  )
				begin
				declare @y int=0

				---
				declare @OddParam nvarchar(50) 
			 
				select @OddParam= oddvalue from @tblMultiOdd where Id=@index1+1

				DECLARE @Delimeter33 char(1)
				SET @Delimeter33 = ','
				declare @sayac33 int=0
				DECLARE @tblyOddParam TABLE(Id int,oddvalue float)
				DECLARE @tbltemp33 TABLE(Id int)
				DECLARE @ak33 nvarchar(10)
				DECLARE @StartPos33 int, @Length33 int
				WHILE LEN(@OddParam) > 0
				  BEGIN
					SET @StartPos33 = CHARINDEX(@Delimeter33, @OddParam)
					IF @StartPos33 < 0 SET @StartPos33 = 0
					SET @Length33 = LEN(@OddParam) - @StartPos33 - 1
					IF @Length33 < 0 SET @Length33 = 0
					IF @StartPos33 > 0
					  BEGIN
						SET @ak33 = SUBSTRING(@OddParam, 1, @StartPos33 - 1)
						SET @OddParam = SUBSTRING(@OddParam, @StartPos33 + 1, LEN(@OddParam) - @StartPos33)
						set @sayac33=@sayac33+1
					  END
					ELSE
					  BEGIN
						SET @ak33 = @OddParam
						SET @OddParam = ''
						set @sayac33=@sayac33+1
					  END
					INSERT @tblyOddParam (Id,oddvalue) VALUES(@sayac33,@ak33)
				ENd
				---
		 
					while @y<(select COUNT(*) from @tblyOddParam)
					begin
						
						set @ArrayOdd1=@ArrayOdd1+cast((ISNULL((Select oddvalue from @tblArrayOdd where Id=@x+1),1)*(Select oddvalue from @tblyOddParam where Id=@y+1)) as nvarchar(100))+','
						  select @ArrayOdd2
					set @y=@y+1	
					end
				delete from @tblyOddParam
				 set @x=@x+1
				end
		 
	 
	if(@Counter<@EventPerBet)
	begin
			declare @Counter_p int =@Counter+1
			declare @Index_p int =@index1+1
			set @ArrayOdd2 =SUBSTRING(@ArrayOdd1,1,LEN(@ArrayOdd1)-1)
			
			--select  'ProcSlipSystemCalculateWining' as SP,  @Counter as Counter1,@index1 as Index1,@Odd1 as Odd1,@EventPerBet as EventPerBet,@Odds1 as Odds,@StakePerBet as StaketPerbet,@Wining1 as Wining
			--select @Counter_p, @Odd1
			exec @Wining1=[RiskManagement].[ProcSlipMultiCalculateWining]    @Counter_p,@Index_p,@ArrayOdd2,@EventPerBet1,@MultiOdds1,@StakePerBet1,@Wining1
			
	end
	else
		begin
		set @ArrayOdd2 =SUBSTRING(@ArrayOdd1,1,LEN(@ArrayOdd1)-1)

		DECLARE @Delimeter333 char(1)
				SET @Delimeter333 = ','
				declare @sayac333 int=0
				DECLARE @tblOddEnd TABLE(Id int,oddvalue float)
				DECLARE @tbltemp333 TABLE(Id int)
				DECLARE @ak333 nvarchar(10)
				DECLARE @StartPos333 int, @Length333 int
				WHILE LEN(@ArrayOdd2) > 0
				  BEGIN
					SET @StartPos333 = CHARINDEX(@Delimeter333, @ArrayOdd2)
					IF @StartPos333 < 0 SET @StartPos333 = 0
					SET @Length333 = LEN(@ArrayOdd2) - @StartPos333 - 1
					IF @Length333 < 0 SET @Length333 = 0
					IF @StartPos333 > 0
					  BEGIN
						SET @ak333 = SUBSTRING(@ArrayOdd2, 1, @StartPos333 - 1)
						SET @ArrayOdd2 = SUBSTRING(@ArrayOdd2, @StartPos333 + 1, LEN(@ArrayOdd2) - @StartPos333)
						set @sayac333=@sayac333+1
					  END
					ELSE
					  BEGIN
						SET @ak333 = @ArrayOdd2
						SET @ArrayOdd2 = ''
						set @sayac333=@sayac333+1
					  END
					INSERT @tblOddEnd (Id,oddvalue) VALUES(@sayac333,@ak333)
				ENd


		declare @z int=0
		while @z<(select COUNT(*) from @tblOddEnd)
				begin
				 
		set @Wining1=@Wining1+((Select oddvalue from @tblOddEnd where Id=@z+1)*@StakePerBet)
 
		set @z=@z+1
				end
				delete from @tblOddEnd
		--select 'Else',@Counter,@Odd1
		end

	set @index1=@index1+1
end

return @Wining1


End
GO
