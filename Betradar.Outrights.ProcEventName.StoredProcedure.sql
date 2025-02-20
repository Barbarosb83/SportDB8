USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Outrights.ProcEventName]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [Betradar].[Outrights.ProcEventName]
@EventId bigint,
@EventName nvarchar(250),
@Language nvarchar(10)
AS

BEGIN

Declare @ParameterLangId int=0
declare @LanId int=6

if not exists (select [Language].[Language].LanguageId from [Language].[Language] with (nolock) where [Language].[Language].[Language]=@Language)
			begin
				insert [Language].[Language] values(@Language,'',1)
				set @LanId=SCOPE_IDENTITY()
			end
		else
			select @LanId= [Language].[Language].LanguageId from [Language].[Language] with (nolock) where [Language].[Language].[Language]=@Language


if exists (SELECT [EventId] FROM  [Outrights].[EventName] with (nolock) where [Outrights].[EventName].EventId=@EventId and [Outrights].[EventName].LanguageId=@LanId)
begin
	UPDATE [Outrights].[EventName]
   SET [EventId] = @EventId
      ,[EventName] = @EventName
      ,[LanguageId] = @LanId
 WHERE [Outrights].[EventName].EventId=@EventId and [Outrights].[EventName].LanguageId=@LanId

end
else
begin
	
	insert [Outrights].[EventName]
		select @EventId,@EventName,[Language].[Language].LanguageId
		from [Language].[Language] where LanguageId not in (SELECT LanguageId FROM  [Outrights].[EventName] with (nolock) where [Outrights].[EventName].EventId=@EventId)
 
end


END


GO
