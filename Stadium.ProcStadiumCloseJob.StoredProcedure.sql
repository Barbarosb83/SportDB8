USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Stadium].[ProcStadiumCloseJob]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [Stadium].[ProcStadiumCloseJob] 
 
AS

BEGIN
SET NOCOUNT ON;


update [Stadium].[Stadium] set IsActive=0 where StadiumId in (

SELECT [StadiumId]
      
  FROM [Stadium].[Stadium] 
  where EndDate<GETDATE() and IsActive=1)




END


GO
