USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcComboPhoneNumber]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcComboPhoneNumber] 

AS

BEGIN
SET NOCOUNT ON;


select Parameter.PhoneCode.PhoneCodeId,Parameter.PhoneCode.PhoneCode,Parameter.PhoneCode.PhoneCodeName,Parameter.PhoneCode.PhoneCodeIcon
 from Parameter.PhoneCode


END


GO
