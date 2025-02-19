USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerActivity]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerActivity] 
@CustomerId bigint,
@ActivityId int,
@Browser nvarchar(50),
@IpAddress nvarchar(50)
AS

BEGIN
SET NOCOUNT ON;



INSERT INTO [Customer].[Activity]
           ([CustomerId]
           ,[ActivtyId]
           ,[CreateDate]
           ,[Browserr]
           ,[IpAddress])
 
     VALUES (
	 @CustomerId
	 ,@ActivityId
	 ,GETDATE()
	 ,@Browser
	 ,@IpAddress
	 )

	 select 1 as result


END



GO
