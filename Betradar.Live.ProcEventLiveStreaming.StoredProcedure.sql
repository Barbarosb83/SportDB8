USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventLiveStreaming]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [Betradar].[Live.ProcEventLiveStreaming]
@BetradarMatchId bigint,
@StartTime datetime,
@HomeTeam nvarchar(250),
@AwayTeam nvarchar(250),
@Competition nvarchar(250),
@Sport nvarchar(150),
@Court nvarchar(150),
@IsActive bit,
@IsLive bit,
@Mobil bit,
@Web bit,
@Country nvarchar(150)


AS
BEGIN


declare @EventLiveId bigint

--if exists (select EventLiveId from Live.EventLiveStreaming  with (nolock)  where BetradarMatchId=@BetradarMatchId)
--	begin
		
--		select @EventLiveId=EventLiveId from Live.EventLiveStreaming  with (nolock)  where BetradarMatchId=@BetradarMatchId

--		update Live.EventLiveStreaming set
--		StartTime=@StartTime,
--		HomeTeam=@HomeTeam,
--		AwayTeam=@AwayTeam,
--		Competition=@Competition,
--		Sport=@Sport,
--		Court=@Court,
--		IsActive=@IsActive,
--		IsLive=@IsLive,
--		Mobil=@Mobil,
--		Web=@Web,
--		Country=@Country
--		where EventLiveId=@EventLiveId

--	end
--else
--	begin
		
--		insert Live.EventLiveStreaming (BetradarMatchId,StartTime,HomeTeam,AwayTeam,Competition,Sport,Court,IsActive,IsLive,Mobil,Web,Country)
--		values (@BetradarMatchId,@StartTime,@HomeTeam,@AwayTeam,@Competition,@Sport,@Court,@IsActive,@IsLive,@Mobil,@Web,@Country)

--		set @EventLiveId=SCOPE_IDENTITY()

--	end

	select @EventLiveId as EvenLiveStreamId


END





GO
