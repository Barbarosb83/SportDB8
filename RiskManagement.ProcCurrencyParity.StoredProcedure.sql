USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCurrencyParity]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcCurrencyParity]
@CurrencySymbol nvarchar(3),
@Parity float



AS




BEGIN
SET NOCOUNT ON;

declare @CurrencyId int
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'


select @CurrencyId=ISNULL(Parameter.Currency.CurrencyId,0) from
Parameter.Currency 
where Parameter.Currency.Symbol3=@CurrencySymbol

--if(@CurrencyId=70)
--set @Parity=1190

if(@CurrencyId<>0)
	begin
		if( select COUNT(*) from Parameter.CurrencyParity where CurrencyId=@CurrencyId and cast(ParityDate as Date)=CAST(GETDATE() as date) )=0
			begin
			
				insert Parameter.CurrencyParity(ParityDate,Parity,CurrencyId)
				values (GETDATE(),@Parity,@CurrencyId)
			
			end
		else
			begin
				update Parameter.CurrencyParity set Parity=@Parity where CurrencyId=@CurrencyId and cast(ParityDate as Date)=CAST(GETDATE() as date)
			end

	end

	select @resultcode as resultcode,@resultmessage as resultmessage

END



GO
