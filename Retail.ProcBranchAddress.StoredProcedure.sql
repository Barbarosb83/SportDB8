USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBranchAddress]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Retail].[ProcBranchAddress]
 @BranchId int


AS




BEGIN
SET NOCOUNT ON;

select ISNULL(Parameter.Branch.[Address],'')+case when Parameter.Branch.IsTerminal=1 then ' (Terminal :' else ' (Kasse :' end +cast(Parameter.Branch.BranchId as nvarchar(20))+') ' as BranhAddress,(select Top 1 Address from General.Setting)+'                                 18+ Glücksspiel kann süchtig machen. Suchtgefahr! Hilfe unter www.bzga.de Bescheid vom 9. Oktober 2020, Aktenzeichen RPDA – Dez. III 34-73 c 38.01/87-2020/2 Bei Fragen zu ihrem Wettschein: support@ibc-betting.com' as CompAddress ,Api_url as LogoUrl from Parameter.Branch with (nolock) where BranchId=@BranchId


END





GO
