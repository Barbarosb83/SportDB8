USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCashoutKeyUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCashoutKeyUID]
 @SlipType int, --1 Combi , 2 System , 3 multi
 @Id int,
 @TicketValueFactor float,
 @DeductionFactor float,
 @ActivityCode int


AS




BEGIN
SET NOCOUNT ON;

if(@ActivityCode=1)
begin
if(@SlipType=1)
begin
UPDATE [Parameter].[CashoutKey3]
   SET [DeductionFactor] =@DeductionFactor
 WHERE Id=@Id
  end
else if(@SlipType=2)
begin
UPDATE [Parameter].[CashoutKeySystem]
   SET [DeductionFactor] =@DeductionFactor
 WHERE Id=@Id
  end
else
	begin
	UPDATE [Parameter].[CashoutKeyMulti]
   SET [DeductionFactor] =@DeductionFactor
 WHERE Id=@Id
	end
end

	select 1 as ResultCode

END



GO
