USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcGenPass2]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Retail].[ProcGenPass2]

 @RndNumber float

AS
 
BEGIN
	-- Declare the return variable here
	declare @len int=8
 declare  @min tinyint = 48
 declare   @range tinyint = 74
 declare   @exclude varchar(50) = '0:;<=>?@O[]`^\/ABCDEFGĞHIİJKLMNOÖPRSŞTUÜVWYZX'
 declare  @output varchar(50)
 declare @rndnum float



   

    declare @char char
    set @output = ''

    while @len > 0 begin
		set @rndnum=@RndNumber/(@len+1)
	
       select @char =  ABS(CHECKSUM(NEWID()) % 9) + 1
      --if charindex(@char, @exclude) = 0 begin
           set @output +=@char --REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@char,';','5'),'=','0'),'<','9'),'>','8'),':','C'),'?','T'),'@','Q')
           set @len = @len - 1
       --end
    end

	select @output

END


GO
