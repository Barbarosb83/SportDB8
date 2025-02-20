USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcOdds]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Betradar].[Live.ProcOdds]
	@BetradarOddsTypeId bigint
    ,@BetradarOddsSubTypeId bigint
    ,@Outcomes nvarchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @OddId int=0
	declare @oddtypeid int
	
	if(@BetradarOddsSubTypeId is not null)
	select @oddtypeid=OddTypeId from [Live].[Parameter.OddType]  with (nolock)
			where [Live].[Parameter.OddType].[BetradarOddsTypeId]=@BetradarOddsTypeId
			and [Live].[Parameter.OddType].[BetradarOddsSubTypeId]=@BetradarOddsSubTypeId
	else
		select @oddtypeid=OddTypeId from [Live].[Parameter.OddType] with (nolock) 
			where [Live].[Parameter.OddType].[BetradarOddsTypeId]=@BetradarOddsTypeId
			--and [Live].[Parameter.OddType].[BetradarOddsSubTypeId]=@BetradarOddsSubTypeId

	if (@oddtypeid is not null)
		begin
			
			if not exists (select Live.[Parameter.Odds].OddsId from Live.[Parameter.Odds] with (nolock) where Live.[Parameter.Odds].OddTypeId=@oddtypeid and Live.[Parameter.Odds].Outcomes=@Outcomes)
				begin
					INSERT INTO [Live].[Parameter.Odds]
					([OddTypeId]
					,[Outcomes])
					VALUES
					   (@oddtypeid
					   ,@Outcomes)
					   
					set @OddId=SCOPE_IDENTITY()
				end
			else
				select @OddId=Live.[Parameter.Odds].OddsId from Live.[Parameter.Odds] with (nolock) where Live.[Parameter.Odds].OddTypeId=@oddtypeid and Live.[Parameter.Odds].Outcomes=@Outcomes	
		end
		
		select @OddId as OddId
END


GO
