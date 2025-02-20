USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcPaymentTypeOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcPaymentTypeOne]
@Id int,
@LangId int


AS

BEGIN


select  [PaymentTypeId]
      ,[PaymentType]
      ,TypeId
	  	  ,case when TypeId=1 then 'Deposit' else 'Withdraw' end as TransType
	  ,TransactionTypeId
      ,MinValue
      ,MaxValue
      ,[IsActive]
      ,Parameter.RiskLevel.RiskLevelId
	  ,Parameter.RiskLevel.RiskLevel
      ,[Description]
from Parameter.PaymentType INNER JOIN Parameter.RiskLevel On Parameter.RiskLevel.RiskLevelId=Parameter.PaymentType.RiskLevelId
WHERE  [PaymentTypeId]=@Id

END



GO
