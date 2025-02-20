USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerBonusTracker]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerBonusTracker] 
@CustomerId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;



declare @TempTable table (comments nvarchar(250))
declare @BonusId int
declare @BonusBalance nvarchar(250)
declare @Balance nvarchar(250)
declare @BonusOccurences int
if exists( select Customer.Bonus.BonusId from Customer.Bonus INNER JOIN Bonus.[Rule] ON Customer.Bonus.BonusId=Bonus.[Rule].BonusRuleId  where CustomerId=@CustomerId and Bonus.[Rule].BonusTypeId<>5 and Customer.Bonus.IsActive=1 and cast(Bonus.[Rule].BonusStartDate as date)<=CAST(GETDATE() as date) and CAST(Bonus.[Rule].BonusEndDate as date)>CAST(GETDATE() as date) )
	begin
		select top 1 @BonusId=Customer.Bonus.BonusId,@BonusOccurences=BonusOccurences from Customer.Bonus INNER JOIN Bonus.[Rule] ON Customer.Bonus.BonusId=Bonus.[Rule].BonusRuleId  where CustomerId=@CustomerId and Bonus.[Rule].BonusTypeId<>5 and Customer.Bonus.IsActive=1 and cast(Bonus.[Rule].BonusStartDate as date)<=CAST(GETDATE() as date) and CAST(Bonus.[Rule].BonusEndDate as date)>CAST(GETDATE() as date)
		
		
		if @LangId=3
			begin
				insert @TempTable  select  N'BONUS TARIH VE SAAT ' + CAST(CreateDate as nvarchar(100)) from Customer.Bonus where Customer.Bonus.CustomerId=@CustomerId and BonusId=@BonusId
				
				select @BonusBalance=  N'BONUS BAKİYESİ : ' + CAST(BonusAmount as nvarchar(100))+'€' from Customer.Bonus where Customer.Bonus.CustomerId=@CustomerId and BonusId=@BonusId
				select @Balance=  N' BAKİYE : ' + CAST(Balance as nvarchar(100))+'€' from Customer.Customer where Customer.Customer.CustomerId=@CustomerId 

				insert @TempTable values (@BonusBalance+@Balance)

				--while @BonusOccurences>0
				--	begin
				--		insert @TempTable values (@BonusBalance+@Balance)
				--	end




			end
		else if @LangId=6
			begin
				insert @TempTable  select  N'BONUS DATUM UND UHRZEIT ' + CAST(CreateDate as nvarchar(100)) from Customer.Bonus where Customer.Bonus.CustomerId=@CustomerId and BonusId=@BonusId
				select @BonusBalance=  N'Bonusguthaben : ' + CAST(BonusAmount as nvarchar(100))+'€' from Customer.Bonus where Customer.Bonus.CustomerId=@CustomerId and BonusId=@BonusId
				select @Balance=  N' Balance : ' + CAST(Balance as nvarchar(100))+'€' from Customer.Customer where Customer.Customer.CustomerId=@CustomerId 
			
				insert @TempTable values (@BonusBalance+@Balance)
			end
		else if @LangId=2
			begin
				insert @TempTable  select  N'BONUS DATE AND TIME ' + CAST(CreateDate as nvarchar(100)) from Customer.Bonus where Customer.Bonus.CustomerId=@CustomerId and BonusId=@BonusId
					select @BonusBalance=  N'BONUS BALANCE : ' + CAST(BonusAmount as nvarchar(100))+'€' from Customer.Bonus where Customer.Bonus.CustomerId=@CustomerId and BonusId=@BonusId
				select @Balance=  N' BALANCE : ' + CAST(Balance as nvarchar(100))+'€' from Customer.Customer where Customer.Customer.CustomerId=@CustomerId 

				insert @TempTable values (@BonusBalance+@Balance)
			end
		else
			begin  
				insert @TempTable  select  N'BONUS DATUM UND UHRZEIT ' + CAST(CreateDate as nvarchar(100)) from Customer.Bonus where Customer.Bonus.CustomerId=@CustomerId and BonusId=@BonusId
				select @BonusBalance=  N'Bonusguthaben : ' + CAST(BonusAmount as nvarchar(100))+'€' from Customer.Bonus where Customer.Bonus.CustomerId=@CustomerId and BonusId=@BonusId
				select @Balance=  N' Balance : ' + CAST(Balance as nvarchar(100))+'€' from Customer.Customer where Customer.Customer.CustomerId=@CustomerId 

				insert @TempTable values (@BonusBalance+@Balance)
			end




	end
	

	select * from @TempTable


END



GO
