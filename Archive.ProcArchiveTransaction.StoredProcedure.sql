USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Archive].[ProcArchiveTransaction]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Archive].[ProcArchiveTransaction]


AS

BEGIN TRAN 

-----Customer Transaction Archive---------------------
--declare @tmpcustomertransaction table (transactionId bigint)

--insert @tmpcustomertransaction
--Select TransactionId from Customer.[Transaction] with (nolock)   where cast(TransactionDate as date)<cast('20210601' as date)


--Begin TRY

--	insert Archive.[Transaction]
--		select * from Customer.[Transaction] with (nolock)  where TransactionId in (select transactionId from @tmpcustomertransaction)

--end try
--BEGIN CATCH 

--	delete from   Archive.[Transaction]   where TransactionId in (select transactionId from @tmpcustomertransaction)

--		insert Archive.[Transaction]
--		select * from Customer.[Transaction]   where TransactionId in (select transactionId from @tmpcustomertransaction)


--END CATCH 
 
--delete from Customer.[Transaction]   where TransactionId in (select transactionId from @tmpcustomertransaction)

 -------------------------------------------------------------------------------------------------------------------------------------------------


 ----------------------------------Branch Transaction Archive --------------------------------------------------------------------------------------

-- declare @tmpbranchtransaction table (branchtransactionId bigint)

--insert @tmpbranchtransaction
--Select BranchTransactionId from  RiskManagement.BranchTransaction with (nolock)     where cast(CreateDate as date)<cast('20210601' as date)



--Begin TRY

--	insert Archive.BranchTransaction
--		select * from RiskManagement.BranchTransaction with (nolock) where BranchTransactionId in (select branchtransactionId from @tmpbranchtransaction)

--end try
--BEGIN CATCH 

--	delete from   Archive.BranchTransaction    where BranchTransactionId in (select branchtransactionId from @tmpbranchtransaction)

--		insert Archive.BranchTransaction
--		select * from RiskManagement.BranchTransaction with (nolock) where BranchTransactionId in (select branchtransactionId from @tmpbranchtransaction)


--END CATCH 
 
--delete from RiskManagement.BranchTransaction  where BranchTransactionId in (select branchtransactionId from @tmpbranchtransaction)


 declare @tmpbranchtransactionpass table ( transactionId bigint)

 insert @tmpbranchtransactionpass
Select TransactionPassId from  RiskManagement.BranchTransactionPass with (nolock)     where cast(CreateDate as date)<cast('20210801' as date)



Begin TRY

	insert Archive.BranchTransactionPass
		select * from RiskManagement.BranchTransactionPass with (nolock) where TransactionPassId in (select transactionId from @tmpbranchtransactionpass)

end try
BEGIN CATCH 

	delete from   Archive.BranchTransactionPass    where TransactionPassId in (select transactionId from @tmpbranchtransactionpass)

		insert Archive.BranchTransactionPass
		select * from RiskManagement.BranchTransactionPass with (nolock) where TransactionPassId in (select transactionId from @tmpbranchtransactionpass)


END CATCH 
 
delete from RiskManagement.BranchTransactionPass  where TransactionPassId in (select transactionId from @tmpbranchtransactionpass)

-----------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------- Archive Summary Betting ------------------------------------------------------------------------------------------------


declare @tmpsummarybetting table (Id bigint)


insert @tmpsummarybetting
select SummarySportBettingId from Report.SummarySportBetting  
where cast(ReportDate as date)<cast('20210701' as date)  

Begin TRY

	insert [Archive].[SummarySportBetting]
		select * from Report.SummarySportBetting   with (nolock)  where SummarySportBettingId in (select Id from @tmpsummarybetting)

end try
BEGIN CATCH 

	delete from   [Archive].[SummarySportBetting]    where SummarySportBettingId in (select Id from @tmpsummarybetting)

		insert [Archive].[SummarySportBetting]
		select * from Report.SummarySportBetting   with (nolock)  where SummarySportBettingId in (select Id from @tmpsummarybetting)


END CATCH 
 
delete from  Report.SummarySportBetting     where SummarySportBettingId in (select Id from @tmpsummarybetting)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------ Archive Summary Casino ---------------------------------------------------------------------------------------------


declare @tmpsummarycasino table (Id bigint)


insert @tmpsummarycasino
select SummaryCasinoBettingId from Report.SummaryCasinoBetting  
where cast(ReportDate as date)<cast('20210701' as date)  

Begin TRY

	insert [Archive].[SummaryCasinoBetting]
		select * from Report.SummaryCasinoBetting   with (nolock)  where SummaryCasinoBettingId in (select Id from @tmpsummarycasino)

end try
BEGIN CATCH 

	delete from   [Archive].[SummaryCasinoBetting]    where SummaryCasinoBettingId in (select Id from @tmpsummarycasino)

		insert [Archive].[SummaryCasinoBetting]
		select * from Report.SummaryCasinoBetting   with (nolock)  where SummaryCasinoBettingId in (select Id from @tmpsummarycasino)


END CATCH 
 
delete from  Report.SummaryCasinoBetting     where SummaryCasinoBettingId in (select Id from @tmpsummarycasino)


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------



COMMIT TRAN
GO
