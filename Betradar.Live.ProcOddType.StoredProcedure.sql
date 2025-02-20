USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcOddType]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Betradar].[Live.ProcOddType]
	@BetradarOddsTypeId bigint
    ,@BetradarOddsSubTypeId bigint
    ,@OddType nvarchar(250)
    ,@ShortSign nvarchar(20)
    ,@Language nvarchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


declare @LanId int
declare @OddTypeId int

if not exists (select [Language].[Language].LanguageId from [Language].[Language] with (nolock)  where [Language].[Language].Language=@Language)
			begin
				insert [Language].[Language](Language,Comments,IsActive) values(@Language,'',1)
				set @LanId=SCOPE_IDENTITY()
			end
		else
			select @LanId= [Language].[Language].LanguageId from [Language].[Language]  with (nolock) where [Language].[Language].Language=@Language

	
	if(@BetradarOddsSubTypeId is not null)
	begin
		if not exists (select  OddTypeId from [Live].[Parameter.OddType] with (nolock)  where [Live].[Parameter.OddType].[BetradarOddsTypeId]=@BetradarOddsTypeId
				and [Live].[Parameter.OddType].[BetradarOddsSubTypeId]= @BetradarOddsSubTypeId)
				begin
				
				
					INSERT INTO [Live].[Parameter.OddType]
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
						   
					set @OddTypeId=SCOPE_IDENTITY()	   
				
				 insert Language.[Parameter.LiveOddType] (OddTypeId,LanguageId,OddsType)
				 select @OddTypeId,[Language].[Language].LanguageId,@OddType
					from [Language].[Language] with (nolock) 

				end
		else
		begin
		if  exists(select[Live].[Parameter.OddType].OddTypeId from [Live].[Parameter.OddType] with (nolock)  where [Live].[Parameter.OddType].[BetradarOddsTypeId]=@BetradarOddsTypeId	and [Live].[Parameter.OddType].[BetradarOddsSubTypeId]=@BetradarOddsSubTypeId)
					begin
						select @OddTypeId=[Live].[Parameter.OddType].OddTypeId  
						from [Live].[Parameter.OddType]  with (nolock) 
						where [Live].[Parameter.OddType].[BetradarOddsTypeId]=@BetradarOddsTypeId
						and [Live].[Parameter.OddType].[BetradarOddsSubTypeId]=@BetradarOddsSubTypeId
					end
		else
			select @OddTypeId=[Live].[Parameter.OddType].OddTypeId  
						from [Live].[Parameter.OddType]  with (nolock) 
						where [Live].[Parameter.OddType].[BetradarOddsTypeId]=@BetradarOddsTypeId
	if(@OddTypeId is not null)
		begin
		if not exists (select Language.[Parameter.LiveOddType].OddTypeId from Language.[Parameter.LiveOddType] with (nolock)  where Language.[Parameter.LiveOddType].OddTypeId=@OddTypeId and Language.[Parameter.LiveOddType].LanguageId=@LanId)
			begin

				insert Language.[Parameter.LiveOddType] (OddTypeId,LanguageId,OddsType,ShortOddType)
				select @OddTypeId,Language.Language.LanguageId,@OddType,@OddType
			from Language.Language with (nolock) 
			where Language.Language.LanguageId not in (select Language.[Parameter.LiveOddType].LanguageId from Language.[Parameter.LiveOddType] with (nolock)  where Language.[Parameter.LiveOddType].OddTypeId=@OddTypeId)
			end
		else if (@LanId=5 or @LanId>10)
			begin
				update Language.[Parameter.LiveOddType] set OddsType=@OddType,ShortOddType=@OddType where Language.[Parameter.LiveOddType].OddTypeId=@OddTypeId and Language.[Parameter.LiveOddType].LanguageId=@LanId
			end
		end
		end
	end
	else
		begin
			if not exists(select OddTypeId from [Live].[Parameter.OddType] with (nolock)  where [Live].[Parameter.OddType].[BetradarOddsTypeId]=@BetradarOddsTypeId)
					begin
					
					
						INSERT INTO [Live].[Parameter.OddType]
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
							   
						set @OddTypeId=SCOPE_IDENTITY()	   
					
					 insert Language.[Parameter.LiveOddType] (OddTypeId,LanguageId,OddsType)
					 select @OddTypeId,Language.Language.LanguageId,@OddType
						from Language.Language with (nolock) 

					end
			else
			begin
						select @OddTypeId=[Live].[Parameter.OddType].OddTypeId  
						from [Live].[Parameter.OddType]  with (nolock) 
						where [Live].[Parameter.OddType].[BetradarOddsTypeId]=@BetradarOddsTypeId
						
			if not exists (select Language.[Parameter.LiveOddType].OddTypeId from Language.[Parameter.LiveOddType] with (nolock)  where Language.[Parameter.LiveOddType].OddTypeId=@OddTypeId and Language.[Parameter.LiveOddType].LanguageId=@LanId)
				begin

					insert Language.[Parameter.LiveOddType] (OddTypeId,LanguageId,OddsType,ShortOddType)
					select @OddTypeId,Language.Language.LanguageId,@OddType,@OddType
				from Language.Language with (nolock) 
				where Language.Language.LanguageId not in (select Language.[Parameter.LiveOddType].LanguageId from Language.[Parameter.LiveOddType] with (nolock)  where Language.[Parameter.LiveOddType].OddTypeId=@OddTypeId)
				end
			else
				begin
					if(@LanId=5 or @LanId>10)
					update Language.[Parameter.LiveOddType] set OddsType=@OddType,ShortOddType=@OddType where Language.[Parameter.LiveOddType].OddTypeId=@OddTypeId and Language.[Parameter.LiveOddType].LanguageId=@LanId
				end
				
			end			
	end
END



GO
