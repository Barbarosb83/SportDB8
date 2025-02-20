USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCashoutKey]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCashoutKey]
 @SlipType int --1 Combi , 2 System , 3 multi


AS




BEGIN
SET NOCOUNT ON;

if(@SlipType=1)
begin
SELECT Id,[TicketValueFactor]
      ,[DeductionFactor]
  FROM [Parameter].[CashoutKey3]
  end
else if(@SlipType=2)
begin
SELECT Id,[TicketValueFactor]
      ,[DeductionFactor]
  FROM [Parameter].[CashoutKeySystem]
  end
else
	begin
		SELECT Id,[TicketValueFactor]
      ,[DeductionFactor]
  FROM [Parameter].[CashoutKeyMulti]
	end

END



GO
