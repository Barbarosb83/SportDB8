USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Lsports].[ProcCategory]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Lsports].[ProcCategory]
@LsCategoryId bigint,
@CategoryName nvarchar(50)
AS

Declare @SportId int=0
Declare @ParameterLangId int=0
declare @IsoId int=0
declare @CategoryId int=0
declare @LanId int=0
BEGIN

	update Parameter.Category set LSId=@LsCategoryId
		 where Parameter.Category.CategoryName = @CategoryName



		 END


GO
