USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcMatchForm]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcMatchForm]
	@TournamentId bigint ,
	@TeamId bigint,
	@Season nvarchar(50) ,
	@TeamName nvarchar(150) ,
	@Form nvarchar(100)

AS
BEGIN
SET NOCOUNT ON;
--declare @OldValues nvarchar(max)
--declare @resultcode int=113
--declare @resultmessage nvarchar(max)='Hata oluştu'
--declare @AvailabityId int=0
--declare @matchId bigint
--declare @OddTypeId bigint
declare @Win int 
	declare @Draw int 
	declare @Loss int 
	declare 	@Points int =0
		set @Form=REVERSE(@Form)
	if(LEN(@Form)>0)
		begin
			if(LEN(@Form)>6)
				set @Form=SUBSTRING(@Form,0,7)
			
			select @Win= ISNULL( LEN(REPLACE(REPLACE(@Form,'D',''),'L','')),0)
			select @Draw= ISNULL( LEN(REPLACE(REPLACE(@Form,'W',''),'L','')),0)
			select @Loss= ISNULL( LEN(REPLACE(REPLACE(@Form,'W',''),'D','')),0)

			select @Points=@Points+ (ISNULL( LEN(REPLACE(REPLACE(@Form,'D',''),'L','')),0)*3)
			select @Points=@Points+ (ISNULL( LEN(REPLACE(REPLACE(@Form,'W',''),'L','')),0)*1)
				

		end
	

	
			set @Form=REPLACE(@Form,'W','3-')
		set @Form=REPLACE(@Form,'D','1-')
		set @Form=REPLACE(@Form,'L','0-')
--select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId

 declare @Id bigint

 declare @trnmtId int

 select  top 1 @trnmtId=Parameter.Tournament.TournamentId from Parameter.Tournament with (nolock) INNER JOIN Parameter.Category with (nolock) On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId 
 where Parameter.Tournament.NewBetradarId=@TournamentId and Parameter.Category.SportId=1
 if (@trnmtId is not null)
 begin
	if exists (Select [Match].Form.Id from [Match].Form where  [Match].Form.TournamentId=@trnmtId and TeamId=@TeamId  )	
		begin
		delete  from [Match].Form  where  [Match].Form.TournamentId=@trnmtId and TeamId=@TeamId
		end

			INSERT INTO [Match].[Form]
           ([TournamentId]
           ,[TeamId]
           ,[TeamName]
           ,[Form]
           ,[Win]
           ,[Draw]
           ,[Lost]
           ,[Points]           )
     VALUES
	 (
		@trnmtId,@TeamId,@TeamName,SUBSTRING(@Form,0,LEN(@Form)),@Win,@Draw,@Loss,@Points
	 )

	 end

 select 1 as result


END


GO
