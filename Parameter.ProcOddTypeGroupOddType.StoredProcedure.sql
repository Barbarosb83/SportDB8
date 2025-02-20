USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Parameter].[ProcOddTypeGroupOddType]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Parameter].[ProcOddTypeGroupOddType] 
@OddTypeGroupId int,
@IsLive bit

AS

BEGIN
SET NOCOUNT ON;

if (@IsLive=1)
begin
select Live.[Parameter.OddTypeGroupOddType].OddTypeGroupOddTypeId,Live.[Parameter.OddTypeGroupOddType].OddTypeGroupId 
,Live.[Parameter.OddTypeGroupOddType].SeqNumber
,Live.[Parameter.OddType].OddTypeId
,Live.[Parameter.OddType].OddType
,Live.[Parameter.OddType].IsActive

from Live.[Parameter.OddTypeGroupOddType] INNER JOIN Live.[Parameter.OddType] ON Live.[Parameter.OddType].OddTypeId=Live.[Parameter.OddTypeGroupOddType].OddTypeId
where OddTypeGroupId=@OddTypeGroupId
Order By SeqNumber

end
else 
begin
select Parameter.OddTypeGroupOddType.OddTypeGroupOddTypeId,Parameter.OddTypeGroupOddType.OddTypeGroupId 
,Parameter.OddTypeGroupOddType.SeqNumber
,Parameter.OddsType.OddsTypeId as OddTypeId
,Parameter.OddsType.OddsType+' ('+Parameter.Sport.SportName+' )' as OddType
,Parameter.OddsType.IsActive

from Parameter.OddTypeGroupOddType INNER JOIN Parameter.OddsType  ON Parameter.OddsType.OddsTypeId=Parameter.OddTypeGroupOddType.OddTypeId INNER JOIN Parameter.Sport On Parameter.Sport.SportId=Parameter.OddsType.SportId
where OddTypeGroupId=@OddTypeGroupId
Order By SeqNumber

end

END



GO
