USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchCodeCreate]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Betradar].[ProcMatchCodeCreate]
@BetradarMatchId bigint,
@MatchId bigint,
@BetTypeId int
AS
BEGIN

declare @Code nvarchar(6)=''

if(@BetTypeId<2)
begin
if not exists (select Match.Code.MatchCodeId  from Match.Code with (nolock)  where BetradarMatchId=@BetradarMatchId and BetTypeId=@BetTypeId)
		begin

			select top 1 @Code=Parameter.MatchCode.Code from Parameter.MatchCode  with (nolock)  where IsUsed=0 --ORDER BY LEN(Parameter.MatchCode.Code) 
			if(@Code<>'' and @Code is not null)
			begin
				insert Match.Code(BetradarMatchId,[MatchId],[Code],BetTypeId)
			values(@BetradarMatchId,@MatchId,@Code,@BetTypeId)

			update Parameter.MatchCode set IsUsed=1 where Parameter.MatchCode.Code=@Code
			end
		


		end
else
	begin
	if not exists (select Match.Code.MatchCodeId  from Match.Code  with (nolock)  where BetradarMatchId=@BetradarMatchId and [MatchId]=@MatchId  and BetTypeId=@BetTypeId)
		begin 
			select top 1 @Code=Match.Code.Code  from Match.Code  with (nolock)  where BetradarMatchId=@BetradarMatchId 
				if(@Code<>'' and @Code is not null)
			begin
				insert Match.Code(BetradarMatchId,[MatchId],[Code],BetTypeId)
			values(@BetradarMatchId,@MatchId,@Code,@BetTypeId)

			update Parameter.MatchCode set IsUsed=1 where Parameter.MatchCode.Code=@Code
			end
		

		end

	end
end
else
begin
if not exists (select Match.Code.MatchCodeId  from Match.Code  with (nolock)  where BetradarMatchId=@BetradarMatchId and BetTypeId=2)
		begin

			select top 1 @Code=Parameter.MatchCode.Code from Parameter.MatchCode with (nolock)  where IsUsed=0 --ORDER BY LEN(Parameter.MatchCode.Code) desc
			if(@Code<>'' and @Code is not null)
			begin
				insert Match.Code(BetradarMatchId,[MatchId],[Code],BetTypeId)
			values(@BetradarMatchId,@MatchId,@Code,@BetTypeId)

			update Parameter.MatchCode set IsUsed=1 where Parameter.MatchCode.Code=@Code
			end
		


		end
else
	begin
	if not exists (select Match.Code.MatchCodeId  from Match.Code  with (nolock)  where BetradarMatchId=@BetradarMatchId and [MatchId]=@MatchId and BetTypeId=2)
		begin 
			select top 1 @Code=Match.Code.Code  from Match.Code  with (nolock)  where BetradarMatchId=@BetradarMatchId and [MatchId]=@MatchId  and BetTypeId=2
				if(@Code<>'' and @Code is not null)
			begin
				insert Match.Code(BetradarMatchId,[MatchId],[Code],BetTypeId)
			values(@BetradarMatchId,@MatchId,@Code,@BetTypeId)

			update Parameter.MatchCode set IsUsed=1 where Parameter.MatchCode.Code=@Code
			end
		

		end

	end
end

END



GO
