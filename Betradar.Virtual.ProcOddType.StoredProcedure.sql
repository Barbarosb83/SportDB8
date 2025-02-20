USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Virtual.ProcOddType]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Betradar].[Virtual.ProcOddType]
	@BetradarOddsTypeId bigint
    ,@BetradarOddsSubTypeId bigint
    ,@OddType nvarchar(250)
    ,@ShortSign nvarchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


if (@BetradarOddsSubTypeId is not null)
begin
	if not exists(select OddTypeId from [Virtual].[Parameter.OddType] 
						where [Virtual].[Parameter.OddType].[BetradarOddsTypeId]=@BetradarOddsTypeId
							and [Virtual].[Parameter.OddType].[BetradarOddsSubTypeId]=@BetradarOddsSubTypeId)			
			begin
			
				INSERT INTO [Virtual].[Parameter.OddType]
					   ([BetradarOddsTypeId]
					   ,[BetradarOddsSubTypeId]
					   ,[IsActive]
					   ,[ShortSign]
					   ,[IsPopular],
					   [OddType])
				 VALUES
					   (@BetradarOddsTypeId
					   ,@BetradarOddsSubTypeId
					   ,1
					   ,@ShortSign
					   ,0,
					   @OddType)

			end
end
else 
begin
	if not exists(select OddTypeId from [Virtual].[Parameter.OddType] 
						where [Virtual].[Parameter.OddType].[BetradarOddsTypeId]=@BetradarOddsTypeId)			
			begin
			
				INSERT INTO [Virtual].[Parameter.OddType]
					   ([BetradarOddsTypeId]
					   ,[BetradarOddsSubTypeId]
					   ,[IsActive]
					   ,[ShortSign]
					   ,[IsPopular],
					   [OddType])
				 VALUES
					   (@BetradarOddsTypeId
					   ,null
					   ,1
					   ,@ShortSign
					   ,0,
					   @OddType)

			end
end

END


GO
