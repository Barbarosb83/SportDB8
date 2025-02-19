USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcEmailControl]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcEmailControl] 
@Email nvarchar(200)

AS

BEGIN
SET NOCOUNT ON;

declare @resultcode int=100
declare @resultmessage nvarchar(max)=''

	
if exists( Select CustomerId from Customer.Customer where Email=@Email)
		set @resultcode=-1

select @resultcode as resultcode,@resultmessage as resultmessage

End


GO
