USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerBonusTrackerInsert]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [GamePlatform].[ProcCustomerBonusTrackerInsert] 
@CustomerId bigint 
AS

BEGIN
SET NOCOUNT ON;



declare @TempTable table (IsOk bit,comments nvarchar(250))
declare @BonusId int
declare @BonusBalance nvarchar(250)
declare @Balance money
declare @BonusOccurences int
declare @BonusCreateDate datetime
declare @Sayac int=1
declare @Isok bit=0
declare @BonusOddValue float



if exists( select Customer.Bonus.BonusId from Customer.Bonus with (nolock) INNER JOIN Bonus.[Rule] with (nolock) ON Customer.Bonus.BonusId=Bonus.[Rule].BonusRuleId  where CustomerId=@CustomerId and (Customer.Bonus.IsUsed=0 or Customer.Bonus.IsUsed is null)  and Bonus.[Rule].BonusTypeId<>5 and Customer.Bonus.IsActive=1 and cast(Bonus.[Rule].BonusStartDate as date)<=CAST(GETDATE() as date) and CAST(Bonus.[Rule].BonusEndDate as date)>CAST(GETDATE() as date) )
	begin
		select top 1 @BonusId=Customer.Bonus.BonusId,@BonusOccurences=BonusOccurences,@BonusBalance=Customer.Bonus.BonusAmount,@BonusCreateDate=Customer.Bonus.CreateDate ,@BonusOddValue=Bonus.[Rule].BonusMinOddValue
		from Customer.Bonus with (nolock)  INNER JOIN Bonus.[Rule] with (nolock)  ON Customer.Bonus.BonusId=Bonus.[Rule].BonusRuleId  
		where CustomerId=@CustomerId and Bonus.[Rule].BonusTypeId<>5 and Customer.Bonus.IsActive=1 and cast(Bonus.[Rule].BonusStartDate as date)<=CAST(GETDATE() as date) and CAST(Bonus.[Rule].BonusEndDate as date)>CAST(GETDATE() as date)
		
		select @Balance=Customer.Customer.Balance from Customer.Customer with (nolock)  where CustomerId=@CustomerId
	 
	if (@Balance>0 or (Select COUNT(Customer.Slip.SlipId) from Customer.Slip with (nolock) where CustomerId=@CustomerId and CreateDate>@BonusCreateDate and SlipStateId in (1))>0)
				while @BonusOccurences>0
					begin
				--	Select Customer.Slip.SlipId from Customer.Slip with (nolock) INNER JOIN Customer.SlipOdd On Customer.Slip.SlipId=Customer.SlipOdd.SlipId where Customer.Slip.CustomerId=@CustomerId and Customer.SlipOdd.OddValue<1.30 and Customer.Slip.SlipTypeId<3 and Customer.Slip.Amount>=@BonusBalance and Customer.Slip.TotalOddValue>=@BonusOddValue and Customer.Slip.CreateDate>@BonusCreateDate and Customer.Slip.SlipStateId not in (1,2)
							set @Isok=0
						  if exists( Select DISTINCT Archive.Slip.SlipId from Archive.Slip with (nolock) INNER JOIN Archive.SlipOdd On Archive.Slip.SlipId=Archive.SlipOdd.SlipId where Archive.Slip.CustomerId=@CustomerId and Archive.SlipOdd.OddValue>=1.30  and (Archive.Slip.SlipTypeId<3 or (Archive.Slip.SlipTypeId=4 and Archive.Slip.EventCount=1)) and Archive.Slip.Amount>=@BonusBalance and Archive.Slip.TotalOddValue>=@BonusOddValue and Archive.Slip.CreateDate>@BonusCreateDate and Archive.Slip.SlipStateId not in (1,2,7) and Archive.Slip.SlipId not in (Select DISTINCT Archive.Slip.SlipId from Archive.Slip with (nolock) INNER JOIN Archive.SlipOdd On Archive.Slip.SlipId=Archive.SlipOdd.SlipId where Archive.Slip.CustomerId=@CustomerId and Archive.SlipOdd.OddValue<1.30  and Archive.Slip.SlipTypeId<3 and Archive.Slip.Amount>=@BonusBalance and Archive.Slip.TotalOddValue>=@BonusOddValue and Archive.Slip.CreateDate>@BonusCreateDate and Archive.Slip.SlipStateId not in (1,2,7)))
							begin	
								 
									Select top 1 @BonusCreateDate= Archive.Slip.CreateDate from Archive.Slip with (nolock) INNER JOIN Archive.SlipOdd On Archive.Slip.SlipId=Archive.SlipOdd.SlipId where Archive.Slip.CustomerId=@CustomerId and Archive.SlipOdd.OddValue>=1.30 and (Archive.Slip.SlipTypeId<3 or (Archive.Slip.SlipTypeId=4 and Archive.Slip.EventCount=1)) and Archive.Slip.Amount>=@BonusBalance and Archive.Slip.TotalOddValue>=@BonusOddValue and Archive.Slip.CreateDate>@BonusCreateDate and Archive.Slip.SlipStateId not in (1,2,7) and Archive.Slip.SlipId not in (Select DISTINCT Archive.Slip.SlipId from Archive.Slip with (nolock) INNER JOIN Archive.SlipOdd On Archive.Slip.SlipId=Archive.SlipOdd.SlipId where Archive.Slip.CustomerId=@CustomerId and Archive.SlipOdd.OddValue<1.30  and Archive.Slip.SlipTypeId<3 and Archive.Slip.Amount>=@BonusBalance and Archive.Slip.TotalOddValue>=@BonusOddValue and Archive.Slip.CreateDate>@BonusCreateDate and Archive.Slip.SlipStateId not in (1,2,7)) order by CreateDate
									set @Isok=1
								 
							end
						else if exists( Select DISTINCT Customer.Slip.SlipId from Customer.Slip with (nolock) INNER JOIN Customer.SlipOdd On Customer.Slip.SlipId=Customer.SlipOdd.SlipId where Customer.Slip.CustomerId=@CustomerId and Customer.SlipOdd.OddValue>=1.30  and (Customer.Slip.SlipTypeId<3 or (Customer.Slip.SlipTypeId=4 and Customer.Slip.EventCount=1)) and Customer.Slip.Amount>=@BonusBalance and Customer.Slip.TotalOddValue>=@BonusOddValue and Customer.Slip.CreateDate>@BonusCreateDate and Customer.Slip.SlipStateId not in (1,2,7) and Customer.Slip.SlipId not in (Select DISTINCT Customer.Slip.SlipId from Customer.Slip with (nolock) INNER JOIN Customer.SlipOdd On Customer.Slip.SlipId=Customer.SlipOdd.SlipId where Customer.Slip.CustomerId=@CustomerId and Customer.SlipOdd.OddValue<1.30  and Customer.Slip.SlipTypeId<3 and Customer.Slip.Amount>=@BonusBalance and Customer.Slip.TotalOddValue>=@BonusOddValue and Customer.Slip.CreateDate>@BonusCreateDate and Customer.Slip.SlipStateId not in (1,2,7)))
							begin	
							 
							 		Select top 1 @BonusCreateDate= Customer.Slip.CreateDate from Customer.Slip with (nolock) INNER JOIN Customer.SlipOdd On Customer.Slip.SlipId=Customer.SlipOdd.SlipId where Customer.Slip.CustomerId=@CustomerId and Customer.SlipOdd.OddValue>=1.30 and (Customer.Slip.SlipTypeId<3 or (Customer.Slip.SlipTypeId=4 and Customer.Slip.EventCount=1)) and Customer.Slip.Amount>=@BonusBalance and Customer.Slip.TotalOddValue>=@BonusOddValue and Customer.Slip.CreateDate>@BonusCreateDate and Customer.Slip.SlipStateId not in (1,2,7) and Customer.Slip.SlipId not in (Select DISTINCT Customer.Slip.SlipId from Customer.Slip with (nolock) INNER JOIN Customer.SlipOdd On Customer.Slip.SlipId=Customer.SlipOdd.SlipId where Customer.Slip.CustomerId=@CustomerId and Customer.SlipOdd.OddValue<1.30  and Customer.Slip.SlipTypeId<3 and Customer.Slip.Amount>=@BonusBalance and Customer.Slip.TotalOddValue>=@BonusOddValue and Customer.Slip.CreateDate>@BonusCreateDate and Customer.Slip.SlipStateId not in (1,2,7)) order by CreateDate
									set @Isok=1
							end
						insert @TempTable values (@Isok,cast(@BonusBalance as nvarchar(50))+ '€ üzeri '+cast(@Sayac as nvarchar(5))+'.Kupon')
						set @Sayac=@Sayac+1
						set @BonusOccurences=@BonusOccurences-1




					end
				else
					while @BonusOccurences>0
					begin
						set @Isok=1
						 
						insert @TempTable values (@Isok,cast(@BonusBalance as nvarchar(50))+ '€ üzeri '+cast(@Sayac as nvarchar(5))+'.Kupon')
						set @Sayac=@Sayac+1
						set @BonusOccurences=@BonusOccurences-1




					end
	 

	 if not exists(select IsOk from @TempTable where IsOk=0)
		begin
			delete from [Customer].[BonusControl] where CustomerId=@CustomerId and BonusId=@BonusId
			INSERT INTO [Customer].[BonusControl] ([CustomerId],[BonusId],[IsOk],CreateDate)   VALUES (@CustomerId,@BonusId,1,GETDATE())
			update Customer.Bonus set IsActive=0,IsUsed=1 where CustomerId=@CustomerId and BonusId=@BonusId
		end
	else
		begin
			delete from [Customer].[BonusControl] where CustomerId=@CustomerId and BonusId=@BonusId
			INSERT INTO [Customer].[BonusControl] ([CustomerId],[BonusId],[IsOk],CreateDate)   VALUES (@CustomerId,@BonusId,0,GETDATE())
		end


	end
	else
	begin
	select top 1 @BonusId=Customer.Bonus.BonusId,@BonusOccurences=BonusOccurences,@BonusBalance=Customer.Bonus.BonusAmount,@BonusCreateDate=Customer.Bonus.CreateDate ,@BonusOddValue=Bonus.[Rule].BonusMinOddValue
		from Customer.Bonus with (nolock)  INNER JOIN Bonus.[Rule] with (nolock)  ON Customer.Bonus.BonusId=Bonus.[Rule].BonusRuleId  
		where CustomerId=@CustomerId and Bonus.[Rule].BonusTypeId<>5 and Customer.Bonus.IsActive=1 and cast(Bonus.[Rule].BonusStartDate as date)<=CAST(GETDATE() as date) and CAST(Bonus.[Rule].BonusEndDate as date)>CAST(GETDATE() as date)
		
		delete from [Customer].[BonusControl] where CustomerId=@CustomerId and BonusId=@BonusId
			INSERT INTO [Customer].[BonusControl] ([CustomerId],[BonusId],[IsOk],CreateDate)   VALUES (@CustomerId,@BonusId,1,GETDATE())
	end
	




END



GO
