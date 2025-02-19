USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcLanguageCompetitor]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcLanguageCompetitor]
@CompId bigint,
@Competitor nvarchar(250),
@BetradarId bigint,
@Language nvarchar(50)
 
AS



BEGIN
SET NOCOUNT ON;

INSERT INTO [Language].[NewCompetitor]
           ([CompId]
           ,[BetradarId]
           ,[Competitor]
           ,[Lang])
     VALUES
           ( 
@CompId ,
@BetradarId ,
@Competitor ,
 
@Language)


END


GO
