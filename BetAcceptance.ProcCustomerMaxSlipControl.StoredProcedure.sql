USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[ProcCustomerMaxSlipControl]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [BetAcceptance].[ProcCustomerMaxSlipControl] 
@CustomerId bigint,
@OddId nvarchar(max)


AS

declare @IsBranchCustomer bit

select @IsBranchCustomer = ISNULL(Customer.Customer.IsBranchCustomer,0) from Customer.Customer with (nolock) where Customer.Customer.CustomerId=@CustomerId

if(@IsBranchCustomer=0 )
begin
DECLARE @Delimeter char(1)
SET @Delimeter = ','
declare @sayac int=0
DECLARE @tblOdd TABLE(oddId bigint)
DECLARE @tbltemp TABLE(Id int)
DECLARE @ak nvarchar(10)
DECLARE @StartPos int, @Length int
WHILE LEN(@OddId) > 0
  BEGIN
    SET @StartPos = CHARINDEX(@Delimeter, @OddId)
    IF @StartPos < 0 SET @StartPos = 0
    SET @Length = LEN(@OddId) - @StartPos - 1
    IF @Length < 0 SET @Length = 0
    IF @StartPos > 0
      BEGIN
        SET @ak = SUBSTRING(@OddId, 1, @StartPos - 1)
        SET @OddId = SUBSTRING(@OddId, @StartPos + 1, LEN(@OddId) - @StartPos)
        set @sayac=@sayac+1
      END
    ELSE
      BEGIN
        SET @ak = @OddId
        SET @OddId = ''
        set @sayac=@sayac+1
      END
    INSERT @tblOdd (oddId) VALUES(@ak)
END

declare @tblOddOrder table (oddId bigint)

insert @tblOddOrder
select * from @tblOdd order by oddId


insert @tbltemp
SELECT SlipId from Customer.SlipOdd with (nolock)
where  SlipId in (select Customer.SlipOdd.SlipId from Customer.SlipOdd with (nolock) 
inner join Customer.Slip with (nolock) on Customer.Slip.SlipId=Customer.SlipOdd.SlipId 
where Customer.SlipOdd.OddId in (Select OddId from @tblOdd) and Customer.Slip.CustomerId=@CustomerId and SlipStateId<>2 and Customer.Slip.TotalOddValue>1)  
group by SlipId
having COUNT(DISTINCT OddId)=@sayac

declare @AyniKuponControl int=0
declare @SlipsId int
declare @Table2  TABLE(oddId bigint)
declare @FarkTable TABLE(oddId bigint)
set nocount on
					declare cur111 cursor local for(
					select Id from @tbltemp

						)

					open cur111
					fetch next from cur111 into @SlipsId
					while @@fetch_status=0
						begin
							begin
							
							--insert @Table2
							--SELECT OddId from Customer.SlipOdd with (nolock)
							--where  SlipId =@SlipsId Order by OddId
							if(@AyniKuponControl=0)
							begin
									insert @FarkTable
									select oddId from @tblOddOrder
									EXCEPT
									SELECT OddId from Customer.SlipOdd with (nolock)
									where  SlipId =@SlipsId Order by OddId
								

									if(select COUNT(*) from @FarkTable)=0
										set @AyniKuponControl=1
								
									delete from @FarkTable
							end
								--delete @Table2
							
							end
							fetch next from cur111 into @SlipsId
			
						end
					close cur111
					deallocate cur111	
			 
if(@AyniKuponControl)=1 
	select COUNT(*) from @tbltemp
else
	select 0
	
end
else
	select 0

GO
