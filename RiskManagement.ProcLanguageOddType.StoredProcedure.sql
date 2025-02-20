USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcLanguageOddType]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcLanguageOddType]
@OddId bigint,
@OddType nvarchar(250),
@OddTypeId int,
@SubOddTypeId int,
@OutComeId nvarchar(250),
@OutCome nvarchar(250),
@Sport nvarchar(250),
@Language nvarchar(50)
 
AS



BEGIN
SET NOCOUNT ON;

INSERT INTO [Language].[NewOddType]
           ([OddId]
           ,[OddType]
           ,[OddTypeId]
           ,[SubOddTypeId]
           ,[OutComeId]
           ,[OutCome]
           ,[Sport]
           ,[Language])
     VALUES
           (@OddId ,
@OddType ,
@OddTypeId ,
@SubOddTypeId ,
@OutComeId ,
@OutCome ,
@Sport,
@Language)


END


GO
