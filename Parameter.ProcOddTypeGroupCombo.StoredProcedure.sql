USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Parameter].[ProcOddTypeGroupCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Parameter].[ProcOddTypeGroupCombo] 
@OddTypeGroupId int,
@IsLive bit

AS

BEGIN
SET NOCOUNT ON;

if (@IsLive=1)
begin


select live.[Parameter.OddType].OddType,live.[Parameter.OddType].OddTypeId from Live.[Parameter.OddType] where Live.[Parameter.OddType].OddTypeId not in (
select Live.[Parameter.OddType].OddTypeId


from Live.[Parameter.OddTypeGroupOddType] INNER JOIN Live.[Parameter.OddType] ON Live.[Parameter.OddType].OddTypeId=Live.[Parameter.OddTypeGroupOddType].OddTypeId
where OddTypeGroupId=@OddTypeGroupId) Order By OddType

end
else 
begin

select Parameter.OddsType.OddsType+'('+Parameter.Sport.SportName+')' as OddType,Parameter.OddsType.OddsTypeId as OddTypeId from Parameter.OddsType INNER JOIN Parameter.Sport On Parameter.Sport.SportId=Parameter.OddsType.SportId where OddsTypeId not in (
select Parameter.OddsType.OddsTypeId as OddTypeId
from Parameter.OddTypeGroupOddType INNER JOIN Parameter.OddsType ON Parameter.OddsType.OddsTypeId=Parameter.OddTypeGroupOddType.OddTypeId
where OddTypeGroupId=@OddTypeGroupId) Order By OddsType

end

END



GO
