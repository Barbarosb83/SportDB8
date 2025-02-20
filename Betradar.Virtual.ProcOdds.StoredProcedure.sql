USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Virtual.ProcOdds]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Betradar].[Virtual.ProcOdds]
	@BetradarOddsTypeId bigint
    ,@BetradarOddsSubTypeId bigint
    ,@Outcomes nvarchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @oddtypeid int

if (@BetradarOddsSubTypeId is not null)
begin
	select @oddtypeid=OddTypeId from [Virtual].[Parameter.OddType] 
			where [Virtual].[Parameter.OddType].[BetradarOddsTypeId]=@BetradarOddsTypeId
			and [Virtual].[Parameter.OddType].[BetradarOddsSubTypeId]=@BetradarOddsSubTypeId	
end
else
begin
	select @oddtypeid=OddTypeId from [Virtual].[Parameter.OddType] 
			where [Virtual].[Parameter.OddType].[BetradarOddsTypeId]=@BetradarOddsTypeId
	
end

if (@oddtypeid is not null)
			
			begin
			
			if not exists (select [Virtual].[Parameter.Odds].[OddTypeId] from [Virtual].[Parameter.Odds] where [Virtual].[Parameter.Odds].OddTypeId=@oddtypeid and [Virtual].[Parameter.Odds].Outcomes=@Outcomes)
				INSERT INTO [Virtual].[Parameter.Odds] ([OddTypeId],[Outcomes]) VALUES (@oddtypeid,@Outcomes)
			end

END


GO
