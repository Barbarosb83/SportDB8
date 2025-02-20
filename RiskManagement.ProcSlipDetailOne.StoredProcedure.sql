USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSlipDetailOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcSlipDetailOne]
@SlipId bigint,
@Username nvarchar(50)


AS




BEGIN
SET NOCOUNT ON;
declare @UserCurrencyId int

select @UserCurrencyId=Users.Users.CurrencyId from Users.Users where Users.Users.UserName=@Username


if exists (select Customer.Slip.SlipId from Customer.Slip where Customer.Slip.SlipId=@SlipId)
	begin
		if exists (select Customer.Slip.SlipId from Customer.Slip where Customer.Slip.SlipId=@SlipId and SlipTypeId<3)
			begin
				select  Customer.Slip.SlipId, Customer.Slip.CustomerId, 
									  Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + case when (Customer.Customer.IsTerminalCustomer=1 or Customer.Customer.IsBranchCustomer=1) 
									  then (select BrancName From Parameter.Branch with (nolock) where BranchId = (Select ParentBranchId from Parameter.Branch with (nolock) where BranchId=Customer.Customer.BranchId)) 
									  else Customer.Customer.Username end + ' ) ' AS CustomerName, 
									  dbo.FuncCurrencyConverter(Customer.Slip.Amount,Customer.Customer.CurrencyId,@UserCurrencyId) as Amount, Customer.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State
									  ,dbo.UserTimeZoneDate(@Username,Customer.Slip.CreateDate,0) as CreateDate, Parameter.Source.SourceId, 
									  Parameter.Source.Source, COUNT(Customer.SlipOdd.SlipOddId) AS OddCount, Parameter.SlipType.SlipType, Customer.Slip.SlipTypeId, 
									  Parameter.SlipState.StatuColor AS SlipStateStatuColor
									  , cast( (Customer.Slip.TotalOddValue * Customer.Slip.Amount) as money)
									  AS MaxGain
									  , Parameter.Currency.CurrencyId, 
									  Parameter.Currency.Sybol as Currency,
									  case when Parameter.SlipState.StateId=3 then cast(cast(Customer.Slip.TotalOddValue * Customer.Slip.Amount AS float) AS nvarchar(50))
									  else case when Parameter.SlipState.StateId=7 then (select cast( SUM(CashOutValue) as nvarchar(50))
									  from Customer.SlipCashOut where SlipId=Customer.Slip.SlipId) else '0' end end AS SlipStatu
									  ,dbo.UserTimeZoneDate(@Username,Customer.slip.EvaluateDate,0) as EvaluateDate
									  ,  case when Parameter.SlipState.StateId=3 then Customer.Slip.TotalOddValue * Customer.Slip.Amount
									  else case when Parameter.SlipState.StateId=7 then (select  SUM(CashOutValue)
									  from Customer.SlipCashOut with (nolock) where SlipId=Customer.Slip.SlipId) else 0 end end MaxGain2
									  ,CAST(1 as int) as CouponCount,Customer.Slip.Amount as CouponAmount
				FROM         Customer.Customer INNER JOIN
									  Customer.Slip ON Customer.Customer.CustomerId = Customer.Slip.CustomerId INNER JOIN
									  Customer.SlipOdd ON Customer.Slip.SlipId = Customer.SlipOdd.SlipId INNER JOIN
									  Parameter.SlipState ON Customer.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN
									  Parameter.Source ON Customer.Slip.SourceId = Parameter.Source.SourceId INNER JOIN
									  Parameter.SlipType ON Customer.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN
									  Parameter.SlipStatu ON Customer.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN
									  Parameter.Currency ON Parameter.Currency.CurrencyId  = @UserCurrencyId
				WHERE Customer.Slip.SlipId=@SlipId
				GROUP BY Parameter.Currency.Sybol,Customer.Slip.SlipId, Customer.Slip.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
									  Customer.Slip.Amount, Customer.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.Slip.CreateDate, Parameter.Source.SourceId, 
									  Parameter.Source.Source, Customer.Slip.SlipTypeId, Customer.Slip.SourceId, Parameter.SlipType.SlipType, 
									  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,Customer.Customer.CurrencyId,Customer.slip.EvaluateDate,Customer.Customer.IsTerminalCustomer,Customer.Customer.BranchId,Customer.Customer.IsBranchCustomer
			end
		else if exists (select Customer.Slip.SlipId from Customer.Slip where Customer.Slip.SlipId=@SlipId and SlipTypeId=4)
			begin
				select Customer.SlipSystemSlip.SlipId as SlipId
					, Customer.SlipSystem.CustomerId, 
					Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + case when (Customer.Customer.IsTerminalCustomer=1 or Customer.Customer.IsBranchCustomer=1) then (select BrancName From Parameter.Branch with (nolock) where BranchId = (Select ParentBranchId from Parameter.Branch with (nolock) where BranchId=Customer.Customer.BranchId)) else Customer.Customer.Username end + ' ) ' AS CustomerName
					, dbo.FuncCurrencyConverter(Customer.SlipSystem.Amount ,Customer.Customer.CurrencyId,@UserCurrencyId) as Amount
					,Customer.SlipSystem.TotalOddValue  as TotalOddValue
					,Customer.SlipSystem.SlipStateId as StateId
					,Parameter.SlipState.[State] as State
					,dbo.UserTimeZoneDate(@Username,Customer.SlipSystem.CreateDate,0) as CreateDate
					, Parameter.Source.SourceId
					,Parameter.Source.Source
					,Customer.SlipSystem.EventCount as OddCount
					,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' / '+cast(Customer.SlipSystem.EventCount as nvarchar(10))+' System' else Customer.SlipSystem.[System] end as SlipType
					,Customer.SlipSystem.SlipTypeId
					,Parameter.SlipState.StatuColor AS SlipStateStatuColor
					,     Customer.SlipSystem.MaxGain   as MaxGain
					, Parameter.Currency.CurrencyId
					, Parameter.Currency.Sybol as Currency
					,case when Customer.SlipSystem.SlipStateId =3
					then   cast(Customer.SlipSystem.MaxGain2 AS nvarchar(50))  else case when Customer.SlipSystem.SlipStateId =7 then cast((select CashoutValue from Customer.SlipCashOut where SlipId=@SlipId) AS nvarchar(50)) else '0' end end as SlipStatu
					,dbo.UserTimeZoneDate(@Username,Customer.SlipSystem.EvaluateDate,0) as EvaluateDate
					,case when Customer.SlipSystem.SlipStateId =3
					then  cast(Customer.SlipSystem.MaxGain2 AS float)   else case when Customer.SlipSystem.SlipStateId =7 then (select CashoutValue from Customer.SlipCashOut where SlipId=@SlipId) else 0 end end as MaxGain2
					,Customer.SlipSystem.CouponCount,(Select Amount from Customer.Slip with (nolock) where Customer.Slip.SlipId=Customer.SlipSystemSlip.SlipId) as CouponAmount
					from Customer.SlipSystem with (nolock) INNER JOIN Customer.SlipSystemSlip with (nolock) On Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
					 Customer.Customer with (nolock) ON Customer.Customer.CustomerId = Customer.SlipSystem.CustomerId INNER JOIN
												  Parameter.Source with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN
												  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  =@UserCurrencyId  INNER JOIN
												  Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
					where Customer.SlipSystem.NewSlipTypeId=4 and Customer.SlipSystem.SystemSlipId = (select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)
					GROUP BY Parameter.Currency.Sybol,Customer.SlipSystem.CouponCount,Customer.SlipSystemSlip.SlipId,Customer.SlipSystem.SystemSlipId, Customer.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
												  Customer.SlipSystem.Amount, Customer.SlipSystem.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipSystem.CreateDate, Parameter.Source.SourceId, 
												  Parameter.Source.Source, Customer.SlipSystem.SlipTypeId, Customer.SlipSystem.SourceId, 
												  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Customer.Customer.CurrencyId, Customer.SlipSystem.SlipStateId,Customer.SlipSystem.EventCount,Customer.SlipSystem.[System]
												  ,Customer.SlipSystem.MaxGain2,Customer.SlipSystem.MaxGain,Customer.Customer.CurrencyId  ,Customer.SlipSystem.EvaluateDate,Customer.Customer.IsTerminalCustomer,Customer.Customer.BranchId,Customer.Customer.IsBranchCustomer
			end 
				else if exists (select Customer.Slip.SlipId from Customer.Slip where Customer.Slip.SlipId=@SlipId and SlipTypeId=5)
			begin
				select Customer.SlipSystemSlip.SlipId as SlipId
					, Customer.SlipSystem.CustomerId, 
					Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + case when (Customer.Customer.IsTerminalCustomer=1 or Customer.Customer.IsBranchCustomer=1) then (select BrancName From Parameter.Branch with (nolock) where BranchId = (Select ParentBranchId from Parameter.Branch with (nolock) where BranchId=Customer.Customer.BranchId)) else Customer.Customer.Username end + ' ) ' AS CustomerName
					, dbo.FuncCurrencyConverter(Customer.SlipSystem.Amount ,Customer.Customer.CurrencyId,@UserCurrencyId) as Amount
					,Customer.SlipSystem.TotalOddValue  as TotalOddValue
					,Customer.SlipSystem.SlipStateId as StateId
					,Parameter.SlipState.[State] as State
					,dbo.UserTimeZoneDate(@Username,Customer.SlipSystem.CreateDate,0) as CreateDate
					, Parameter.Source.SourceId
					,Parameter.Source.Source
					,Customer.SlipSystem.EventCount as OddCount
					,'Multiway' as SlipType
					,Customer.SlipSystem.SlipTypeId
					,Parameter.SlipState.StatuColor AS SlipStateStatuColor
					,    Customer.SlipSystem.MaxGain   as MaxGain
					, Parameter.Currency.CurrencyId
					,Parameter.Currency.Sybol  as Currency
					,case when Customer.SlipSystem.SlipStateId =3
					then   cast(Customer.SlipSystem.MaxGain2 AS nvarchar(50))  else case when Customer.SlipSystem.SlipStateId =7 then cast((select CashoutValue from Customer.SlipCashOut where SlipId=@SlipId) AS nvarchar(50)) else '0' end end as SlipStatu
					,dbo.UserTimeZoneDate(@Username,Customer.SlipSystem.EvaluateDate,0) as EvaluateDate
					,case when Customer.SlipSystem.SlipStateId =3
					then cast(Customer.SlipSystem.MaxGain2 AS float)   else case when Customer.SlipSystem.SlipStateId =7 then (select CashoutValue from Customer.SlipCashOut where SlipId=@SlipId) else 0 end end as MaxGain2
					,Customer.SlipSystem.CouponCount,(Select Amount from Customer.Slip with (nolock) where Customer.Slip.SlipId=Customer.SlipSystemSlip.SlipId) as CouponAmount
					from Customer.SlipSystem with (nolock)  INNER JOIN Customer.SlipSystemSlip with (nolock) On Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
					 Customer.Customer with (nolock) ON Customer.Customer.CustomerId = Customer.SlipSystem.CustomerId INNER JOIN
												  Parameter.Source with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN
												  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  =@UserCurrencyId  INNER JOIN
												  Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
					where Customer.SlipSystem.NewSlipTypeId=5 and Customer.SlipSystem.SystemSlipId = (select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)
					GROUP BY Parameter.Currency.Sybol,Customer.SlipSystem.CouponCount,Customer.SlipSystemSlip.SlipId,Customer.SlipSystem.SystemSlipId, Customer.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
												  Customer.SlipSystem.Amount, Customer.SlipSystem.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipSystem.CreateDate, Parameter.Source.SourceId, 
												  Parameter.Source.Source, Customer.SlipSystem.SlipTypeId, Customer.SlipSystem.SourceId, 
												  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Customer.Customer.CurrencyId, Customer.SlipSystem.SlipStateId,Customer.SlipSystem.EventCount,Customer.SlipSystem.[System]
												  ,Customer.SlipSystem.MaxGain2,Customer.SlipSystem.MaxGain,Customer.Customer.CurrencyId  ,Customer.SlipSystem.EvaluateDate,Customer.Customer.IsTerminalCustomer,Customer.Customer.BranchId,Customer.Customer.IsBranchCustomer
			end                
	end
else
	begin
		if exists (select Archive.Slip.SlipId from Archive.Slip where Archive.Slip.SlipId=@SlipId and SlipTypeId<3)
			begin
			select  Archive.Slip.SlipId, Archive.Slip.CustomerId, 
								  Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + case when (Customer.Customer.IsTerminalCustomer=1 or Customer.Customer.IsBranchCustomer=1) then (select BrancName From Parameter.Branch with (nolock) where BranchId = (Select ParentBranchId from Parameter.Branch with (nolock) where BranchId=Customer.Customer.BranchId)) else Customer.Customer.Username end + ' ) ' AS CustomerName, 
								  dbo.FuncCurrencyConverter(Archive.Slip.Amount,Customer.Customer.CurrencyId,@UserCurrencyId) as Amount, Archive.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State
								  ,dbo.UserTimeZoneDate(@Username,Archive.Slip.CreateDate,0) as CreateDate, Parameter.Source.SourceId, 
								  Parameter.Source.Source, COUNT(Archive.SlipOdd.SlipOddId) AS OddCount, Parameter.SlipType.SlipType, Archive.Slip.SlipTypeId, 
								  Parameter.SlipState.StatuColor AS SlipStateStatuColor
								    , cast( (Archive.Slip.TotalOddValue * Archive.Slip.Amount) as money)
									  AS MaxGain
									  , Parameter.Currency.CurrencyId, 
									  Parameter.Currency.Sybol as Currency,
									  case when Parameter.SlipState.StateId=3 then cast(cast(Archive.Slip.TotalOddValue * Archive.Slip.Amount AS float) AS nvarchar(50))
									  else case when Parameter.SlipState.StateId=7 then (select  cast( SUM(CashOutValue) as nvarchar(50))
									  from Customer.SlipCashOut where SlipId=Archive.Slip.SlipId) else '0' end end AS SlipStatu
									  ,dbo.UserTimeZoneDate(@Username,Archive.Slip.EvaluateDate,0) as EvaluateDate
									    ,  case when Parameter.SlipState.StateId=3 then Archive.Slip.TotalOddValue * Archive.Slip.Amount
									  else case when Parameter.SlipState.StateId=7 then (select  SUM(CashOutValue)
									  from Customer.SlipCashOut with (nolock) where SlipId=Archive.Slip.SlipId) else 0 end end MaxGain2
									   ,CAST(1 as int) as CouponCount,Archive.Slip.Amount as CouponAmount
			FROM         Customer.Customer INNER JOIN
								  Archive.Slip ON Customer.Customer.CustomerId = Archive.Slip.CustomerId INNER JOIN
								  Archive.SlipOdd ON Archive.Slip.SlipId = Archive.SlipOdd.SlipId INNER JOIN
								  Parameter.SlipState ON Archive.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN
								  Parameter.Source ON Archive.Slip.SourceId = Parameter.Source.SourceId INNER JOIN
								  Parameter.SlipType ON Archive.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN
								  Parameter.SlipStatu ON Archive.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN
								  Parameter.Currency ON Parameter.Currency.CurrencyId  = @UserCurrencyId
			WHERE Archive.Slip.SlipId=@SlipId
			GROUP BY Parameter.Currency.Sybol,Archive.Slip.SlipId, Archive.Slip.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
								  Archive.Slip.Amount, Archive.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Archive.Slip.CreateDate, Parameter.Source.SourceId, 
								  Parameter.Source.Source, Archive.Slip.SlipTypeId, Archive.Slip.SourceId, Parameter.SlipType.SlipType, 
								  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,Customer.Customer.CurrencyId,Archive.Slip.EvaluateDate,Customer.Customer.IsTerminalCustomer,Customer.Customer.BranchId,Customer.Customer.IsBranchCustomer
			end
		else if exists (select Archive.Slip.SlipId from Archive.Slip where Archive.Slip.SlipId=@SlipId and SlipTypeId=3)
			begin
				select Customer.SlipSystemSlip.SlipId as SlipId
					, Customer.SlipSystem.CustomerId, 
					Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + case when (Customer.Customer.IsTerminalCustomer=1 or Customer.Customer.IsBranchCustomer=1) then (select BrancName From Parameter.Branch with (nolock) where BranchId = (Select ParentBranchId from Parameter.Branch with (nolock) where BranchId=Customer.Customer.BranchId)) else Customer.Customer.Username end + ' ) ' AS CustomerName
					, dbo.FuncCurrencyConverter(Customer.SlipSystem.Amount ,Customer.Customer.CurrencyId,@UserCurrencyId) as Amount
					,Customer.SlipSystem.TotalOddValue  as TotalOddValue
					,Customer.SlipSystem.SlipStateId as StateId
					,Parameter.SlipState.[State] as State
					,dbo.UserTimeZoneDate(@Username,Customer.SlipSystem.CreateDate,0) as CreateDate
					, Parameter.Source.SourceId
					,Parameter.Source.Source
					,Customer.SlipSystem.EventCount as OddCount
					,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' / '+cast(Customer.SlipSystem.EventCount as nvarchar(10))+' System' else Customer.SlipSystem.[System] end as SlipType
					,Customer.SlipSystem.SlipTypeId
					,Parameter.SlipState.StatuColor AS SlipStateStatuColor
					,     Customer.SlipSystem.MaxGain   as MaxGain
					, Parameter.Currency.CurrencyId
					, Parameter.Currency.Sybol as Currency
					,case when Customer.SlipSystem.SlipStateId =3
					then   cast(Customer.SlipSystem.MaxGain2 AS nvarchar(50))  else case when Customer.SlipSystem.SlipStateId =7 then cast((select CashoutValue from Customer.SlipCashOut where SlipId=@SlipId) AS nvarchar(50)) else '0' end end as SlipStatu
					,dbo.UserTimeZoneDate(@Username,Customer.SlipSystem.EvaluateDate,0) as EvaluateDate
					,case when Customer.SlipSystem.SlipStateId =3
					then  cast(Customer.SlipSystem.MaxGain2 AS float)   else case when Customer.SlipSystem.SlipStateId =7 then (select CashoutValue from Customer.SlipCashOut where SlipId=@SlipId) else 0 end end as MaxGain2
					,Customer.SlipSystem.CouponCount,(Select Amount from Archive.Slip with (nolock) where Archive.Slip.SlipId=Customer.SlipSystemSlip.SlipId) as CouponAmount
					from Customer.SlipSystem with (nolock)   INNER JOIN Customer.SlipSystemSlip with (nolock) On Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
					 Customer.Customer with (nolock) ON Customer.Customer.CustomerId = Customer.SlipSystem.CustomerId INNER JOIN
												  Parameter.Source with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN
												  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  =@UserCurrencyId  INNER JOIN
												  Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
					where Customer.SlipSystem.SystemSlipId = (select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)
					GROUP BY Parameter.Currency.Sybol,Customer.SlipSystem.CouponCount,Customer.SlipSystemSlip.SlipId,Customer.SlipSystem.SystemSlipId, Customer.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
												  Customer.SlipSystem.Amount, Customer.SlipSystem.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipSystem.CreateDate, Parameter.Source.SourceId, 
												  Parameter.Source.Source, Customer.SlipSystem.SlipTypeId, Customer.SlipSystem.SourceId, 
												  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Customer.Customer.CurrencyId, Customer.SlipSystem.SlipStateId,Customer.SlipSystem.EventCount,Customer.SlipSystem.[System]
												  ,Customer.SlipSystem.MaxGain2,Customer.SlipSystem.MaxGain,Customer.Customer.CurrencyId  ,Customer.SlipSystem.EvaluateDate,Customer.Customer.IsTerminalCustomer,Customer.Customer.BranchId,Customer.Customer.IsBranchCustomer
			end
			else if exists (select Archive.Slip.SlipId from Archive.Slip where Archive.Slip.SlipId=@SlipId and SlipTypeId=4)
			begin
				select Customer.SlipSystemSlip.SlipId as SlipId
					, Customer.SlipSystem.CustomerId, 
					Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + case when (Customer.Customer.IsTerminalCustomer=1 or Customer.Customer.IsBranchCustomer=1) then (select BrancName From Parameter.Branch with (nolock) where BranchId = (Select ParentBranchId from Parameter.Branch with (nolock) where BranchId=Customer.Customer.BranchId)) else Customer.Customer.Username end + ' ) ' AS CustomerName
					, dbo.FuncCurrencyConverter(Customer.SlipSystem.Amount ,Customer.Customer.CurrencyId,@UserCurrencyId) as Amount
					,Customer.SlipSystem.TotalOddValue  as TotalOddValue
					,Customer.SlipSystem.SlipStateId as StateId
					,Parameter.SlipState.[State] as State
					,dbo.UserTimeZoneDate(@Username,Customer.SlipSystem.CreateDate,0) as CreateDate
					, Parameter.Source.SourceId
					,Parameter.Source.Source
					,Customer.SlipSystem.EventCount as OddCount
					,case when CHARINDEX('Multi',Customer.SlipSystem.[System]) = 0  then SUBSTRING(Customer.SlipSystem.[System],0,LEN(Customer.SlipSystem.[System]))+' / '+cast(Customer.SlipSystem.EventCount as nvarchar(10))+' System' else Customer.SlipSystem.[System] end as SlipType
					,Customer.SlipSystem.SlipTypeId
					,Parameter.SlipState.StatuColor AS SlipStateStatuColor
				,     Customer.SlipSystem.MaxGain   as MaxGain
					, Parameter.Currency.CurrencyId
					, Parameter.Currency.Sybol as Currency
					,case when Customer.SlipSystem.SlipStateId =3
					then   cast(Customer.SlipSystem.MaxGain2 AS nvarchar(50))  else case when Customer.SlipSystem.SlipStateId =7 then cast((select CashoutValue from Customer.SlipCashOut where SlipId=@SlipId) AS nvarchar(50)) else '0' end end as SlipStatu
					,dbo.UserTimeZoneDate(@Username,Customer.SlipSystem.EvaluateDate,0) as EvaluateDate
					,case when Customer.SlipSystem.SlipStateId =3
					then  cast(Customer.SlipSystem.MaxGain2 AS float)  else case when Customer.SlipSystem.SlipStateId =7 then (select CashoutValue from Customer.SlipCashOut where SlipId=@SlipId) else 0 end end as MaxGain2
					,Customer.SlipSystem.CouponCount,(Select Amount from Archive.Slip with (nolock) where Archive.Slip.SlipId=Customer.SlipSystemSlip.SlipId) as CouponAmount
					from Customer.SlipSystem with (nolock)   INNER JOIN Customer.SlipSystemSlip with (nolock) On Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId  INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
					 Customer.Customer with (nolock) ON Customer.Customer.CustomerId = Customer.SlipSystem.CustomerId INNER JOIN
												  Parameter.Source with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN
												  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  =@UserCurrencyId  INNER JOIN
												  Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
					where Customer.SlipSystem.NewSlipTypeId=4 and Customer.SlipSystem.SystemSlipId = (select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)
					GROUP BY Parameter.Currency.Sybol,Customer.SlipSystem.CouponCount,Customer.SlipSystemSlip.SlipId,Customer.SlipSystem.SystemSlipId, Customer.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
												  Customer.SlipSystem.Amount, Customer.SlipSystem.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipSystem.CreateDate, Parameter.Source.SourceId, 
												  Parameter.Source.Source, Customer.SlipSystem.SlipTypeId, Customer.SlipSystem.SourceId, 
												  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Customer.Customer.CurrencyId, Customer.SlipSystem.SlipStateId,Customer.SlipSystem.EventCount,Customer.SlipSystem.[System]
												  ,Customer.SlipSystem.MaxGain2,Customer.SlipSystem.MaxGain,Customer.Customer.CurrencyId  ,Customer.SlipSystem.EvaluateDate,Customer.Customer.IsTerminalCustomer,Customer.Customer.BranchId,Customer.Customer.IsBranchCustomer
			end 
			else if exists (select Archive.Slip.SlipId from Archive.Slip where Archive.Slip.SlipId=@SlipId and SlipTypeId=5)
			begin
				select Customer.SlipSystemSlip.SlipId as SlipId
					, Customer.SlipSystem.CustomerId, 
					Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + case when (Customer.Customer.IsTerminalCustomer=1 or Customer.Customer.IsBranchCustomer=1) then (select BrancName From Parameter.Branch with (nolock) where BranchId = (Select ParentBranchId from Parameter.Branch with (nolock) where BranchId=Customer.Customer.BranchId)) else Customer.Customer.Username end + ' ) ' AS CustomerName
					, dbo.FuncCurrencyConverter(Customer.SlipSystem.Amount ,Customer.Customer.CurrencyId,@UserCurrencyId) as Amount
					,Customer.SlipSystem.TotalOddValue  as TotalOddValue
					,Customer.SlipSystem.SlipStateId as StateId
					,Parameter.SlipState.[State] as State
					,dbo.UserTimeZoneDate(@Username,Customer.SlipSystem.CreateDate,0) as CreateDate
					, Parameter.Source.SourceId
					,Parameter.Source.Source
					,Customer.SlipSystem.EventCount as OddCount
					,'Multiway'   as SlipType
					,Customer.SlipSystem.SlipTypeId
					,Parameter.SlipState.StatuColor AS SlipStateStatuColor
					,    Customer.SlipSystem.MaxGain   as MaxGain
					, Parameter.Currency.CurrencyId
					, Parameter.Currency.Sybol as  Currency
					,case when Customer.SlipSystem.SlipStateId =3
					then   cast(Customer.SlipSystem.MaxGain2 AS nvarchar(50))  else case when Customer.SlipSystem.SlipStateId =7 then cast((select CashoutValue from Customer.SlipCashOut where SlipId=@SlipId) AS nvarchar(50)) else '0' end end as SlipStatu
					,dbo.UserTimeZoneDate(@Username,Customer.SlipSystem.EvaluateDate,0) as EvaluateDate
					,case when Customer.SlipSystem.SlipStateId =3
					then  cast(Customer.SlipSystem.MaxGain2 AS float)   else case when Customer.SlipSystem.SlipStateId =7 then (select CashoutValue from Customer.SlipCashOut where SlipId=@SlipId) else 0 end end as MaxGain2
					,Customer.SlipSystem.CouponCount,(Select Amount from Archive.Slip with (nolock) where Archive.Slip.SlipId=Customer.SlipSystemSlip.SlipId) as CouponAmount
					from Customer.SlipSystem with (nolock)   INNER JOIN Customer.SlipSystemSlip with (nolock) On Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId  INNER JOIN Parameter.SlipState with (nolock) ON Parameter.SlipState.StateId=Customer.SlipSystem.SlipStateId INNER JOIN
					 Customer.Customer with (nolock) ON Customer.Customer.CustomerId = Customer.SlipSystem.CustomerId INNER JOIN
												  Parameter.Source with (nolock) ON Customer.SlipSystem.SourceId = Parameter.Source.SourceId INNER JOIN
												  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId  =@UserCurrencyId  INNER JOIN
												  Parameter.Branch with (nolock) On Parameter.Branch.BranchId=Customer.Customer.BranchId
					where Customer.SlipSystem.NewSlipTypeId=5 and Customer.SlipSystem.SystemSlipId = (select Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)
					GROUP BY Parameter.Currency.Sybol,Customer.SlipSystem.CouponCount,Customer.SlipSystemSlip.SlipId,Customer.SlipSystem.SystemSlipId, Customer.SlipSystem.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
												  Customer.SlipSystem.Amount, Customer.SlipSystem.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipSystem.CreateDate, Parameter.Source.SourceId, 
												  Parameter.Source.Source, Customer.SlipSystem.SlipTypeId, Customer.SlipSystem.SourceId, 
												  Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Customer.Customer.CurrencyId, Customer.SlipSystem.SlipStateId,Customer.SlipSystem.EventCount,Customer.SlipSystem.[System]
												  ,Customer.SlipSystem.MaxGain2,Customer.SlipSystem.MaxGain,Customer.Customer.CurrencyId  ,Customer.SlipSystem.EvaluateDate,Customer.Customer.IsTerminalCustomer,Customer.Customer.BranchId,Customer.Customer.IsBranchCustomer
			end                     
	end

END




GO
