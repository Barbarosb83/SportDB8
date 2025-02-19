USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSlipSystemEvaluate]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcSlipSystemEvaluate] 
@EventPerBet int,
@Odds nvarchar(300),
@StakePerBet money
as 
 
--declare @EventPerBet int=3
--declare @Odds nvarchar(300)='2.7;
--2.8;
--3.7;
--3.95'
--declare @StakePerBet money=0.056



begin 

 declare @Win money
    select @Win= [RiskManagement].[FuncSlipSystemCalculateWining] ( 1,0,1,@EventPerBet,@Odds,@StakePerBet,0)
 
 
 select @win

end
 
GO
