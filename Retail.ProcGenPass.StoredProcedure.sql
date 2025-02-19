USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcGenPass]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [Retail].[ProcGenPass]

 @RndNumber float

AS
 
BEGIN
 declare  @output varchar(50)
 


     declare @ch varchar (8000), @ps  varchar (10)

select @ps = '', @ch =
replicate('ABCDEFGHJKLMNPQURSUVWXYZ',8)+replicate('23456789',9)+
replicate('abcdefghjkmnpqursuvwxyz',8)+replicate('@@!!!!@@',8)

while len(@ps)<8 begin set @ps=@ps+substring(@ch,convert(int,rand()*len(@ch)-1),1) end


set @output=@ps


 
	select @output

END


GO
