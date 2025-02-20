TabloAdi	SemaAdi	IndexAdi	IndexTipi	PrimaryKey	Unique_Index	IndexDurumu	IndexKolonlari	KayitSayisi	ToplamBoyutMB
Account	Customer	PK_Account	CLUSTERED	Evet	Evet	Aktif	CustomerAccountId	0	0.00
AccountType	Parameter	PK_AccountType	CLUSTERED	Evet	Evet	Aktif	AccountTypeId	0	0.00
AcountLockDay	Parameter	PK_AcountLockDay	CLUSTERED	Evet	Evet	Aktif	AcountLockDayId	114	0.07
AcountLockReason	Parameter	PK_AcountLockReason	CLUSTERED	Evet	Evet	Aktif	AcountLockId	114	0.07
Activity	Archive	PK_Login	CLUSTERED	Evet	Evet	Aktif	CustomerActivityId	0	0.00
Activity	Customer	IX_BBCA	NONCLUSTERED	Hayir	Hayir	Aktif	ActivtyId, CustomerId	893148	36.88
Activity	Customer	PK_Login	CLUSTERED	Evet	Evet	Aktif	CustomerActivityId	893148	132.01
Activity	Parameter	PK_Activity	CLUSTERED	Evet	Evet	Aktif	LoginActivityId	2	0.02
AddHour	Parameter	NULL	HEAP	Hayir	Hayir	Aktif	NULL	1	0.07
Bank	Parameter	PK_Bank	CLUSTERED	Evet	Evet	Aktif	BankId	4434	0.45
BankAccount	Parameter	PK_BankAccount	CLUSTERED	Evet	Evet	Aktif	BankAccountId	4437	0.20
BankList	Parameter	PK_BankList	CLUSTERED	Evet	Evet	Aktif	BankId	15788	1.45
BetFair	Match	PK_BetFair	CLUSTERED	Evet	Evet	Aktif	BetFairId	0	0.16
betslip	dbo	NULL	HEAP	Hayir	Hayir	Aktif	NULL	55	0.07
BetTransferDate	Parameter	IX_BetTransferDate	NONCLUSTERED	Hayir	Hayir	Aktif	TransferType	3	0.07
BetTransferDate	Parameter	PK_BetTransferDate	CLUSTERED	Evet	Evet	Aktif	BetTransferId	3	0.07
BetType	Parameter	PK_BetType	CLUSTERED	Evet	Evet	Aktif	BetTypeId	4	0.02
Bitcoin	Customer	PK_Bitcoin	CLUSTERED	Evet	Evet	Aktif	BitcoinId	0	0.00
BitcoinTransaction	Customer	PK_BitcoinTransaction	CLUSTERED	Evet	Evet	Aktif	BitcoinTransactionId	0	0.00
BitcoinTransaction2	Customer	PK_BitcoinTransaction2	CLUSTERED	Evet	Evet	Aktif	BitcoinTransactionId	0	0.00
Bonus	Customer	IX_Bonus	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId, IsUsed, IsActive	0	0.00
Bonus	Customer	PK_Bonus	CLUSTERED	Evet	Evet	Aktif	CustomerBonusId	0	0.00
BonusControl	Customer	PK_BonusControl	CLUSTERED	Evet	Evet	Aktif	CustomerBonusContId	0	0.00
BonusRequest	Customer	IX_BonusRequest	NONCLUSTERED	Hayir	Evet	Aktif	CustomerId, BonusId	4037	0.33
BonusRequest	Customer	PK_BonusRequest	CLUSTERED	Evet	Evet	Aktif	BonusRequestId	4037	0.56
BonusRequest2	Customer	PK_BonusRequest2	CLUSTERED	Evet	Evet	Aktif	BonusRequestId	128	0.07
BonusRequest3	Customer	PK_BonusRequest3	CLUSTERED	Evet	Evet	Aktif	BonusRequestId	238	0.07
BonusRequest4	Customer	PK_BonusRequest4	CLUSTERED	Evet	Evet	Aktif	BonusRequestId	371	0.07
BonusRequest5	Customer	PK_BonusRequest5	CLUSTERED	Evet	Evet	Aktif	BonusRequestId	815	0.20
BonusRequest6	Customer	PK_BonusRequest6	CLUSTERED	Evet	Evet	Aktif	BonusRequestId	1243	0.20
BonusRequest7	Customer	PK_BonusRequest7	CLUSTERED	Evet	Evet	Aktif	BonusRequestId	1373	0.20
BonusRequest8	Customer	PK_BonusRequest8	CLUSTERED	Evet	Evet	Aktif	BonusRequestId	1540	0.26
BonusType	Parameter	PK_BonusType	CLUSTERED	Evet	Evet	Aktif	BonusTypeId	5	0.02
Branch	Parameter	IX_Branch	NONCLUSTERED	Hayir	Hayir	Aktif	ParentBranchId	1441	0.14
Branch	Parameter	IX_Branch_1	NONCLUSTERED	Hayir	Hayir	Aktif	BranchId, IsTerminal	1441	0.13
Branch	Parameter	PK_Branch	CLUSTERED	Evet	Evet	Aktif	BranchId	1441	1.12
BranchBetTypeCommision	RiskManagement	PK_BranchBetTypeCommision	CLUSTERED	Evet	Evet	Aktif	BranchBetTypeCommisionId	0	0.00
BranchCloseBoxReport	RiskManagement	PK_BranchCloseBoxReport	CLUSTERED	Evet	Evet	Aktif	BranchCloseBoxId	47644	10.61
BranchCommisionType	Parameter	PK_BranchCommisionType	CLUSTERED	Evet	Evet	Aktif	BranchCommisionTypeId	2	0.07
BranchCommission	Report	PK_BranchCommission	CLUSTERED	Evet	Evet	Aktif	BranchCommissionId	109247	9.97
BranchCommissionBalance	Report	PK_BranchCommissionBalance	CLUSTERED	Evet	Evet	Aktif	BranchCommissionBalanceId	0	0.00
BranchDepositRequest	RiskManagement	NULL	HEAP	Hayir	Hayir	Aktif	NULL	457	0.14
BranchForbiddenOddType	Parameter	IX_BranchForbiddenOddType	NONCLUSTERED	Hayir	Hayir	Aktif	BranchId, ParameterOddTypeId, BetTypeId	317	0.07
BranchForbiddenOddType	Parameter	PK_BranchForbiddenOddType	CLUSTERED	Evet	Evet	Aktif	ForbiddenOddId	317	0.07
BranchMoneyTransaction	RiskManagement	IX_BranchMoneyTransaction	NONCLUSTERED	Hayir	Evet	Aktif	Id, BranchId, TransTypeId, TransId	0	0.00
BranchMoneyTransaction	RiskManagement	PK_BranchMoneyTransaction	CLUSTERED	Evet	Evet	Aktif	Id	0	0.00
Branchstatus	Parameter	NULL	HEAP	Hayir	Hayir	Aktif	NULL	2	0.02
BranchTransaction	Archive	PK_BranchTransaction	CLUSTERED	Evet	Evet	Aktif	BranchTransactionId	0	0.00
BranchTransaction	RiskManagement	IX_BranchTransaction	NONCLUSTERED	Hayir	Hayir	Aktif	BranchId, TransactionTypeId	0	0.00
BranchTransaction	RiskManagement	IX_BranchTransaction_1	NONCLUSTERED	Hayir	Hayir	Aktif	SlipId, TransactionTypeId	0	0.00
BranchTransaction	RiskManagement	IX_BranchTransaction_2	NONCLUSTERED	Hayir	Hayir	Aktif	UserId, TransactionTypeId	0	0.00
BranchTransaction	RiskManagement	IX_BranchTransaction_3	NONCLUSTERED	Hayir	Hayir	Aktif	BranchId, Amount, TransactionTypeId, CreateDate, IsView	0	0.00
BranchTransaction	RiskManagement	IX_BranchTransaction_4	NONCLUSTERED	Hayir	Hayir	Aktif	UserId, CreateDate	0	0.00
BranchTransaction	RiskManagement	PK_BranchTransaction	CLUSTERED	Evet	Evet	Aktif	BranchTransactionId	0	0.00
BranchTransactionPass	Archive	PK_BranchTransactionPass	CLUSTERED	Evet	Evet	Aktif	TransactionPassId	228512	62.66
BranchTransactionPass	RiskManagement	IX_BranchTransactionPass	NONCLUSTERED	Hayir	Hayir	Aktif	BranchTransactionId, IsPaid	0	0.00
BranchTransactionPass	RiskManagement	IX_BranchTransactionPass_1	NONCLUSTERED	Hayir	Hayir	Aktif	BranchTransactionId, Password, IsPaid	0	0.00
BranchTransactionPass	RiskManagement	PK_BranchTransactionPass	CLUSTERED	Evet	Evet	Aktif	TransactionPassId	0	0.00
BranchValueCommission	RiskManagement	PK_BranchValueCommission	CLUSTERED	Evet	Evet	Aktif	BranchValueCommissionId	7	0.02
Card	Archive	PK_Card_1	CLUSTERED	Evet	Evet	Aktif	CardId, BetradarCardId	0	0.00
Card	Customer	IX_Card_2	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId	0	0.00
Card	Customer	PK_Card_2	CLUSTERED	Evet	Evet	Aktif	CustomerCardId	0	0.00
Card	Match	IX_Card	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarCardId	682	0.30
Card	Match	IX_Card_1	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId	682	0.30
Card	Match	PK_Card	CLUSTERED	Evet	Evet	Aktif	CardId, MatchId	682	0.30
CardBarcode	Customer	IX_CardBarcode	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId, CreateDate	1	0.07
CardBarcode	Customer	IX_CardBarcode_1	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId	1	0.07
CardBarcode	Customer	IX_CardBarcode_2	NONCLUSTERED	Hayir	Hayir	Aktif	Barcode	1	0.07
CardBarcode	Customer	IX_CardBarcode_3	NONCLUSTERED	Hayir	Hayir	Aktif	Barcode, PIN	1	0.07
CardBarcode	Customer	PK_CardBarcode	CLUSTERED	Evet	Evet	Aktif	CardBarcodeId	1	0.07
CardBarcode	Parameter	IX_CardBarcode_4	NONCLUSTERED	Hayir	Hayir	Aktif	BarcodeNumber, IsUsed	20979	1.08
CardBarcode	Parameter	PK_CardBarcode_1	CLUSTERED	Evet	Evet	Aktif	BarcodeId	20979	0.89
CardType	Parameter	PK_CardType	CLUSTERED	Evet	Evet	Aktif	CardTypeId	5	0.02
CashoutKey	Parameter	PK_CashoutKey	CLUSTERED	Evet	Evet	Aktif	CashOutId	26	0.07
CashoutKey2	Parameter	PK_CashoutKey2	CLUSTERED	Evet	Evet	Aktif	CashOutId	26	0.07
CashoutKey3	Parameter	PK_CashoutKey3	CLUSTERED	Evet	Evet	Aktif	TicketValueFactor	23	0.07
CashoutKeyMulti	Parameter	PK_CashoutKeyMulti	CLUSTERED	Evet	Evet	Aktif	TicketValueFactor	23	0.07
CashoutKeySystem	Parameter	PK_CashoutKeySystem	CLUSTERED	Evet	Evet	Aktif	TicketValueFactor	23	0.07
CashoutProfitFactor	Parameter	PK_CashoutProfitFactor	CLUSTERED	Evet	Evet	Aktif	CashOutId	20	0.02
CashType	Parameter	PK_CashType	CLUSTERED	Evet	Evet	Aktif	CashTypeId	2	0.02
Category	Cache	IX_Category_SportEndDay	NONCLUSTERED	Hayir	Hayir	Aktif	SportId, EndDay	0	0.00
Category	Cache	PK_Category_1	CLUSTERED	Evet	Evet	Aktif	CacheCategoryId	0	0.00
Category	CasinoGame	PK_Category_3	CLUSTERED	Evet	Evet	Aktif	CategoryId	0	0.00
Category	Parameter	IX_Category	NONCLUSTERED	Hayir	Evet	Aktif	CategoryId, SportId	974	0.20
Category	Parameter	PK_Category	CLUSTERED	Evet	Evet	Aktif	CategoryId, BetradarCategoryId	974	0.20
Category	Stadium	PK_StadiumCategory	CLUSTERED	Evet	Evet	Aktif	StadiumCategoryId	144	0.07
Category	Virtual	PK_Category_2	CLUSTERED	Evet	Evet	Aktif	CategoryId	3	0.02
CepBank	Parameter	PK_CepBank	CLUSTERED	Evet	Evet	Aktif	CepBankId	6	0.02
Chat	Telegram	IX_Chat	NONCLUSTERED	Hayir	Evet	Aktif	TelegramId, IsActive	19	0.07
Chat	Telegram	PK_Chat	CLUSTERED	Evet	Evet	Aktif	ChatId	19	0.07
Code	Archive	NULL	HEAP	Hayir	Hayir	Aktif	NULL	135355	9.48
Code	Archive	IX_Code	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId, BetTypeId	135355	9.85
Code	Archive	IX_Code_4	NONCLUSTERED	Hayir	Hayir	Aktif	MatchCodeId	135355	8.54
Code	Archive	IX_Code2	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarMatchId, BetTypeId	135355	9.73
Code	Match	IX_BBMC	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId, Code, BetTypeId	1234	0.13
Code	Match	IX_Code_1	NONCLUSTERED	Hayir	Hayir	Aktif	Code, MatchId	1234	0.13
Code	Match	IX_Code_2	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId, BetTypeId	1234	0.13
Code	Match	IX_Code_3	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarMatchId, BetTypeId	1234	0.13
Code	Match	PK_Code	CLUSTERED	Evet	Evet	Aktif	MatchCodeId, BetradarMatchId, MatchId, BetTypeId	1234	4.80
Competitor	Outrights	IX_Competitor_1	NONCLUSTERED	Hayir	Hayir	Aktif	EventId	55157	5.18
Competitor	Outrights	IX_Competitor_2	NONCLUSTERED	Hayir	Hayir	Aktif	CompetitorBetradarId	55157	5.48
Competitor	Outrights	IX_Competitor_3	NONCLUSTERED	Hayir	Hayir	Aktif	CompetitorId	55157	8.11
Competitor	Outrights	PK_Competitor_1	CLUSTERED	Evet	Evet	Aktif	EventCompetitorId	55157	18.80
Competitor	Parameter	IX_Competitor	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarSuperId	262088	13.11
Competitor	Parameter	IX_Competitor_4	NONCLUSTERED	Hayir	Hayir	Aktif	CompetitorName	262088	35.38
Competitor	Parameter	PK_Competitor	CLUSTERED	Evet	Evet	Aktif	CompetitorId, BetradarSuperId	262088	23.71
Controls	Users	PK_Controls	CLUSTERED	Evet	Evet	Aktif	ControlId	105	0.10
ControlTypes	Users	PK_ControlTypes	CLUSTERED	Evet	Evet	Aktif	ControlTypeId	4	0.02
Corner	Archive	PK_Corner_1	CLUSTERED	Evet	Evet	Aktif	CornerId	0	0.00
Corner	Match	IX_Corner	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId	0	0.00
Corner	Match	PK_Corner	CLUSTERED	Evet	Evet	Aktif	CornerId, MatchId	0	0.00
Country	Parameter	PK_Country	CLUSTERED	Evet	Evet	Aktif	CountryId	237	0.11
CreditCard	Customer	PK_CreditCard	CLUSTERED	Evet	Evet	Aktif	CreditCardId	0	0.00
CupRound	Parameter	PK_CupRound	CLUSTERED	Evet	Evet	Aktif	CupRoundId	28	0.02
Currency	Parameter	PK_Currency	CLUSTERED	Evet	Evet	Aktif	CurrencyId	170	0.10
CurrencyParity	Parameter	PK_CurrencyParity	CLUSTERED	Evet	Evet	Aktif	CurrencyParityId	177701	8.52
Customer	CasinoGame	PK_Provider.Customer	CLUSTERED	Evet	Evet	Aktif	CasinoGameCustomerId	1	0.07
Customer	Customer	IX_CC1	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId, BranchId, CountryId, IsBranchCustomer	0	0.00
Customer	Customer	IX_CC2	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId, CountryId, BranchId, IsBranchCustomer	0	0.00
Customer	Customer	IX_Customer	NONCLUSTERED	Hayir	Evet	Aktif	Username, Email, Password	0	0.00
Customer	Customer	IX_Customer_1	NONCLUSTERED	Hayir	Hayir	Aktif	IsBranchCustomer, IsTerminalCustomer	0	0.00
Customer	Customer	IX_Customer_2	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId, IsTerminalCustomer	0	0.00
Customer	Customer	IX_Customer_3	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId, BranchId, IsBranchCustomer	0	0.00
Customer	Customer	PK_Customer	CLUSTERED	Evet	Evet	Aktif	CustomerId	0	0.00
CustomerGroup	Parameter	PK_CustomerGroup	CLUSTERED	Evet	Evet	Aktif	CustomerGroupId	4	0.02
CustomerLimit	Parameter	PK_CustomerLimit	CLUSTERED	Evet	Evet	Aktif	ParameterLimitId	1	0.02
CustomerRule	RiskManagement	PK_CustomerRule	CLUSTERED	Evet	Evet	Aktif	CustomerRuleId	1	0.07
Customers	Stadium	PK_Customers	CLUSTERED	Evet	Evet	Aktif	StadiumCustomerId	28	0.07
DateInfoType	Parameter	PK_DateInfoType	CLUSTERED	Evet	Evet	Aktif	DateInfoTypeId	12	0.02
Days	Parameter	PK_Days	CLUSTERED	Evet	Evet	Aktif	DaysId	7	0.02
DepositCepBank	Customer	NULL	HEAP	Hayir	Hayir	Aktif	NULL	0	0.00
DepositStatu	Parameter	PK_DepositStatu	CLUSTERED	Evet	Evet	Aktif	DepositStatuId	3	0.02
DepositTransfer	Customer	NULL	HEAP	Hayir	Hayir	Aktif	NULL	0	0.00
DeviceToken	Customer	PK_DeviceToken	CLUSTERED	Evet	Evet	Aktif	TokenId	0	0.00
Document	Customer	IX_Document	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId, DocumentTypeId	20504	1.63
Document	Customer	PK_Document	CLUSTERED	Evet	Evet	Aktif	DocumentId	20504	11.05
DocumentState	Parameter	NULL	HEAP	Hayir	Hayir	Aktif	NULL	3	0.02
DocumentType	Parameter	PK_DocumentType	CLUSTERED	Evet	Evet	Aktif	DocumentTypeId	4	0.07
DoublePlayer	Archive	PK_DoublePlayer	CLUSTERED	Evet	Evet	Aktif	MatchDoublePlayerId	0	0.00
DoublePlayer	Match	PK_DoublePlayer	CLUSTERED	Evet	Evet	Aktif	MatchDoublePlayerId	31241	6.16
DownloadLink	Retail	PK_DownloadLink	CLUSTERED	Evet	Evet	Aktif	DownloadLinkId	0	0.00
EmailTemplate	General	PK_EmailTemplate	CLUSTERED	Evet	Evet	Aktif	EmailTemplateId	12	1.13
EndMonthBalance	Report	PK_EndMonthBalance	CLUSTERED	Evet	Evet	Aktif	CustomerEndId	57853	3.53
EndMonthSlip	Report	PK_EndMonthSlip	CLUSTERED	Evet	Evet	Aktif	SlipEndId	5847	0.59
Error	MTS	NULL	HEAP	Hayir	Hayir	Aktif	NULL	69	0.02
ErrorCancellation	MTS	PK_ErrorCancellation	CLUSTERED	Evet	Evet	Aktif	ErrorCancellationId	9	0.02
ErrorCodes	Log	NULL	HEAP	Hayir	Hayir	Aktif	NULL	1347	0.27
ErrorLog	Log	PK_ErrorLog	CLUSTERED	Evet	Evet	Aktif	LogId	2619	11.76
ErrorLogHistory	Log	PK_ErrorLogHistory	CLUSTERED	Evet	Evet	Aktif	LogId	0	0.00
Event	Live	IX_Event_2	NONCLUSTERED	Hayir	Evet	Aktif	TournamentId, ConnectionStatu, IsActive, BetradarMatchId	12870	0.88
Event	Live	IX_Event_5	NONCLUSTERED	Hayir	Evet	Aktif	TournamentId, BetradarMatchId	12870	0.76
Event	Live	IX_Event_6	NONCLUSTERED	Hayir	Hayir	Aktif	EventDate, EventId	12870	0.70
Event	Live	IX_Event_7	NONCLUSTERED	Hayir	Hayir	Aktif	EventId, ConnectionStatu	12870	0.63
Event	Live	IX_Event_8	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarMatchId	12870	0.70
Event	Live	IX_LEBB	NONCLUSTERED	Hayir	Hayir	Aktif	EventId, BetradarMatchId, TournamentId, HomeTeam, AwayTeam, ConnectionStatu, EventDate	12870	1.07
Event	Live	PK_Event_2	CLUSTERED	Evet	Evet	Aktif	EventId	12870	1.51
Event	Outrights	IX_Event_3	NONCLUSTERED	Hayir	Hayir	Aktif	EventBetradarId	1449	0.21
Event	Outrights	IX_Event_4	NONCLUSTERED	Hayir	Hayir	Aktif	TournamentId	1449	0.30
Event	Outrights	PK_Event_1	CLUSTERED	Evet	Evet	Aktif	EventId	1449	0.35
Event	Virtual	IX_Event	NONCLUSTERED	Hayir	Evet	Aktif	BetradarMatchId	0	0.00
Event	Virtual	IX_Event_1	NONCLUSTERED	Hayir	Hayir	Aktif	TournamentName, MatchDay	0	0.00
Event	Virtual	PK_Event	CLUSTERED	Evet	Evet	Aktif	EventId	0	0.00
EventCoverageInfo	Live	PK_EventCoverageInfo	CLUSTERED	Evet	Evet	Aktif	CoverageInfoId	7	0.05
EventDetail	Live	<Name of Missing Index, sysname,>	NONCLUSTERED	Hayir	Hayir	Aktif	IsActive, EventStatu, Bases, BetStatus, BetStopReasonId, LegScore, MatchTime, MatchTimeExtended, RedCardsTeam1, RedCardsTeam2, Score, MatchServer, YellowRedCardsTeam1, YellowRedCardsTeam2, TimeStatu, BetradarTimeStamp	12866	65.24
EventDetail	Live	IX_BBL	NONCLUSTERED	Hayir	Hayir	Aktif	EventId, BetStatus, TimeStatu, UpdatedDate, BetradarMatchIds, IsActive	12866	1.07
EventDetail	Live	IX_EventDetail_1	NONCLUSTERED	Hayir	Evet	Aktif	BetradarMatchIds	12866	0.82
EventDetail	Live	IX_EventDetail_2	NONCLUSTERED	Hayir	Evet	Aktif	IsActive, TimeStatu, EventId, BetStatus	12866	0.95
EventDetail	Live	IX_EventDetail_3	NONCLUSTERED	Hayir	Evet	Aktif	EventId, TimeStatu	12866	0.88
EventDetail	Live	IX_EventDetail_4	NONCLUSTERED	Hayir	Evet	Aktif	IsActive, TimeStatu, BetradarMatchIds	12866	0.88
EventDetail	Live	IX_EventDetail_5	NONCLUSTERED	Hayir	Hayir	Aktif	EventId, BetStatus	12866	0.88
EventDetail	Live	IXBB3	NONCLUSTERED	Hayir	Hayir	Aktif	EventDetailId, EventId, EventStatu, BetStatus, BetStopReasonId, GameScore, LegScore, MatchTime, MatchTimeExtended, RedCardsTeam1, RedCardsTeam2, Score, YellowRedCardsTeam1, YellowRedCardsTeam2, TimeStatu, BetradarMatchIds, IsActive	12866	32.99
EventDetail	Live	PK_EventDetail	CLUSTERED	Evet	Evet	Aktif	EventDetailId, BetradarMatchIds, EventId	12866	12.77
EventDetail	Virtual	IX_EventDetail	NONCLUSTERED	Hayir	Evet	Aktif	EventId	0	0.09
EventDetail	Virtual	PK_EventDetail	CLUSTERED	Evet	Evet	Aktif	EventDetailId	0	0.09
EventExtraInfo	Live	PK_EventExtraInfo	CLUSTERED	Evet	Evet	Aktif	ExtraInfoId	4	0.29
EventLiveStreaming	Live	NULL	HEAP	Hayir	Hayir	Aktif	NULL	0	0.00
EventName	Outrights	IX_BBOE	NONCLUSTERED	Hayir	Hayir	Aktif	EventId, EventName, LanguageId	27550	7.05
EventName	Outrights	IX_EventName	NONCLUSTERED	Hayir	Hayir	Aktif	EventId	27550	1.98
EventName	Outrights	IX_EventName_1	NONCLUSTERED	Hayir	Evet	Aktif	EventId, LanguageId	27550	2.05
EventName	Outrights	PK_EventName	CLUSTERED	Evet	Evet	Aktif	EventNameId	27550	6.11
EventOdd	Live	IX_EventOdd_10	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarMatchId, BetradarPlayerId, BettradarOddId	5419	0.52
EventOdd	Live	IX_EventOdd_11	NONCLUSTERED	Hayir	Hayir	Aktif	OddId, BetradarTimeStamp	5419	0.59
EventOdd	Live	IX_EventOdd_2	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarMatchId, BettradarOddId	5419	0.45
EventOdd	Live	IX_EventOdd_3	NONCLUSTERED	Hayir	Evet	Aktif	OddId	5419	0.46
EventOdd	Live	IX_EventOdd_4	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarMatchId	5419	0.39
EventOdd	Live	IX_EventOdd_5	NONCLUSTERED	Hayir	Hayir	Aktif	OddValue, IsActive, MatchId	5419	0.59
EventOdd	Live	IX_EventOdd_6	NONCLUSTERED	Hayir	Hayir	Aktif	OddId, BetradarTimeStamp	5419	0.52
EventOdd	Live	IX_EventOdd_7	NONCLUSTERED	Hayir	Evet	Aktif	BettradarOddId, BetradarMatchId, OutCome, SpecialBetValue	5419	0.59
EventOdd	Live	IX_EventOdd_8	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarMatchId, BettradarOddId, SpecialBetValue	5419	0.52
EventOdd	Live	IX_EventOdd_9	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarMatchId, BetradarPlayerId	5419	0.45
EventOdd	Live	PK_Odd	CLUSTERED	Evet	Evet	Aktif	OddId, BetradarMatchId	5419	8.87
EventOdd	Virtual	IX_EventOdd	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId	0	0.00
EventOdd	Virtual	IX_EventOdd_1	NONCLUSTERED	Hayir	Hayir	Aktif	OddsTypeId, OutCome, SpecialBetValue	0	0.00
EventOdd	Virtual	PK_Odd	CLUSTERED	Evet	Evet	Aktif	OddId	0	0.00
EventOddHistory	Live	PK_EventOddHistory	CLUSTERED	Evet	Evet	Aktif	OddHistoryId	0	0.00
EventOddHistory	Virtual	PK_EventOddHistory	CLUSTERED	Evet	Evet	Aktif	OddHistoryId	0	0.00
EventOddProb	Live	IX_EventOddProb_1	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarMatchId	0	0.00
EventOddProb	Live	IX_EventOddProb_2	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarMatchId, BetradarOddsTypeId, BetradarOddsSubTypeId, SpecialBetValue, CashoutStatus	0	0.00
EventOddProb	Live	IX_EventOddProb_3	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarMatchId, BetradarOddsTypeId, BetradarOddsSubTypeId, OutCome, SpecialBetValue	0	0.00
EventOddProb	Live	PK_OddProb	CLUSTERED	Evet	Evet	Aktif	OddId	0	0.00
EventOddProbHistory	Live	NULL	HEAP	Hayir	Hayir	Aktif	NULL	889220	1581.87
EventOddResult	Live	IX_EventOddResult	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarOddId, BetradarMatchId, OutCome, SpecialBetValue	0	0.00
EventOddResult	Live	IX_EventOddResult_1	NONCLUSTERED	Hayir	Hayir	Aktif	OddId, IsCanceled	0	0.00
EventOddResult	Live	IX_EventOddResult_2	NONCLUSTERED	Hayir	Hayir	Aktif	IsEvaluated, IsCanceled, OddId	0	0.00
EventOddResult	Live	IX_EventOddResult_3	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarMatchId, BetradarOddsSubTypeId, BetradarOddsTypeId	0	0.00
EventOddResult	Live	IX_EventOddResult_4	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarMatchId, OddsTypeId, OddResult, SpecialBetValue	0	0.00
EventOddResult	Live	IX_EventOddResult_5	NONCLUSTERED	Hayir	Hayir	Aktif	OddId	0	0.00
EventOddResult	Live	PK_EventOddResult	CLUSTERED	Evet	Evet	Aktif	OddresultId	0	0.30
EventOddSetting	Live	IX_EventOddSetting	NONCLUSTERED	Hayir	Evet	Aktif	OddId	159	0.14
EventOddSetting	Live	PK_OddSetting	CLUSTERED	Evet	Evet	Aktif	OddSettingId, OddId	159	0.23
EventOddSetting	Virtual	PK_OddSetting	CLUSTERED	Evet	Evet	Aktif	OddSettingId	0	0.00
EventOddTypeSetting	Live	IX_EventOddTypeSetting	NONCLUSTERED	Hayir	Evet	Aktif	MatchId, OddTypeId	604	0.07
EventOddTypeSetting	Live	IX_EventOddTypeSetting_1	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarMatchId, OddTypeId	604	0.07
EventOddTypeSetting	Live	PK_OddTypeSetting	CLUSTERED	Evet	Evet	Aktif	OddTypeSettingId, OddTypeId	604	0.80
EventOddTypeSetting	Virtual	PK_OddTypeSetting	CLUSTERED	Evet	Evet	Aktif	OddTypeSettingId	0	0.00
Events	Stadium	PK_Events	CLUSTERED	Evet	Evet	Aktif	StadiumEventId	144	0.07
EventSetting	Live	IX_EventSetting	NONCLUSTERED	Hayir	Evet	Aktif	MatchId, StateId	12841	0.76
EventSetting	Live	PK_Setting	CLUSTERED	Evet	Evet	Aktif	SettingId, MatchId	12841	14.24
EventSetting	Virtual	PK_Setting	CLUSTERED	Evet	Evet	Aktif	SettingId	0	0.00
EventStreamingChannel	Live	IX_EventStreamingChannel	NONCLUSTERED	Hayir	Evet	Aktif	EventId, StreamingChannelId	1	0.07
EventStreamingChannel	Live	PK_EventStreamingChannel	CLUSTERED	Evet	Evet	Aktif	StreamingChannelId	1	0.14
EventTopOdd	Live	IX_EventTopOdd	NONCLUSTERED	Hayir	Evet	Aktif	BetradarMatchId	12870	7.73
EventTopOdd	Live	IX_EventTopOdd_1	NONCLUSTERED	Hayir	Evet	Aktif	EventId	12870	7.61
EventTopOdd	Live	IX_EventTopOdd_2	NONCLUSTERED COLUMNSTORE	Hayir	Hayir	Aktif	EventId, ThreeWay1	12870	0.26
EventTopOdd	Live	PK_EventTopOdd	CLUSTERED	Evet	Evet	Aktif	EventTopOddId	12870	23.93
EventTopOdd	Virtual	PK_EventTopOdd	CLUSTERED	Evet	Evet	Aktif	EventTopOddId	0	0.00
EventTvChannel	Live	IX_EventTvChannel	NONCLUSTERED	Hayir	Hayir	Aktif	EventId	66	0.48
EventTvChannel	Live	PK_EventTvChannel	CLUSTERED	Evet	Evet	Aktif	TvChannelId	66	0.93
FavGames	CasinoGame	PK_FavGames	CLUSTERED	Evet	Evet	Aktif	FavGamesId	0	0.00
Fixture	Archive	NonClusteredIndex-20241127-113811	NONCLUSTERED	Hayir	Hayir	Aktif	FixtureId, MatchId	73329	3.68
Fixture	Archive	PK_Fixture_2	CLUSTERED	Evet	Evet	Aktif	FixtureId, MatchId	73329	12.13
Fixture	Cache	IX_BBCF	NONCLUSTERED	Hayir	Hayir	Aktif	OddValue1, OddValue2, OddValue3, MatchId	1940	0.26
Fixture	Cache	IX_Fixture	NONCLUSTERED	Hayir	Hayir	Aktif	MatchDate, TournamentId	1940	0.26
Fixture	Cache	IX_Fixture_1	NONCLUSTERED COLUMNSTORE	Hayir	Hayir	Aktif	MatchId, MatchDate, SportId	1940	0.20
Fixture	Cache	IX_Fixture_2	NONCLUSTERED	Hayir	Hayir	Aktif	SportId, MatchDate	1940	0.26
Fixture	Cache	IX_Fixture_3	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId, MatchDate	1940	0.26
Fixture	Cache	IX_Fixture_4	NONCLUSTERED	Hayir	Hayir	Aktif	MatchDate	1940	0.26
Fixture	Cache	PK_Fixture_1	CLUSTERED	Evet	Evet	Aktif	CacheMatchId, BetradarMatchId, MatchId	1940	0.51
Fixture	Match	BB_FX	NONCLUSTERED	Hayir	Hayir	Aktif	FixtureId, MatchId	11723	0.63
Fixture	Match	PK_Fixture	CLUSTERED	Evet	Evet	Aktif	FixtureId, MatchId	11723	16.74
FixtureCompetitor	Archive	IX_FixtureCompetitor_3	NONCLUSTERED	Hayir	Evet	Aktif	FixtureId, CompetitorId, TypeId	139084	9.69
FixtureCompetitor	Archive	PK_FixtureCompetitor_1	CLUSTERED	Evet	Evet	Aktif	FixtureCompetitorId, FixtureId	139084	10.38
FixtureCompetitor	Match	IX_FixtureCompetitor	NONCLUSTERED	Hayir	Hayir	Aktif	FixtureId, TypeId	23443	1.07
FixtureCompetitor	Match	IX_FixtureCompetitor_2	NONCLUSTERED	Hayir	Evet	Aktif	FixtureId, CompetitorId, TypeId	23443	1.26
FixtureCompetitor	Match	PK_FixtureCompetitor	CLUSTERED	Evet	Evet	Aktif	FixtureCompetitorId	23443	14.99
FixtureDateInfo	Archive	IX_FixtureDateInfo	NONCLUSTERED	Hayir	Hayir	Aktif	MatchDate, FixtureId	69542	4.19
FixtureDateInfo	Archive	IX_FixtureDateInfo_3	NONCLUSTERED	Hayir	Hayir	Aktif	MatchDate	69542	4.31
FixtureDateInfo	Archive	PK_FixtureDateInfo_1	CLUSTERED	Evet	Evet	Aktif	FixtureDateInfoId, FixtureId	69542	6.38
FixtureDateInfo	Match	IX_FixtureDateInfo_1	NONCLUSTERED	Hayir	Evet	Aktif	FixtureId, LanguageId, MatchDate	11722	0.70
FixtureDateInfo	Match	IX_FixtureDateInfo_2	NONCLUSTERED	Hayir	Hayir	Aktif	FixtureId, MatchDate	11722	0.63
FixtureDateInfo	Match	PK_FixtureDateInfo	CLUSTERED	Evet	Evet	Aktif	FixtureDateInfoId, FixtureId	11722	11.24
FixtureProgramme	Cache	IX_FixtureProgramme	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId	699	0.07
FixtureProgramme	Cache	IX_FixtureProgramme_1	NONCLUSTERED	Hayir	Hayir	Aktif	MatchDate	699	0.07
FixtureProgramme	Cache	PK_FixtureProgramme_1	CLUSTERED	Evet	Evet	Aktif	CacheMatchId, BetradarMatchId, MatchId	699	0.26
FixtureProgramme2	Cache	IX_FixtureProgramme2_1	NONCLUSTERED	Hayir	Hayir	Aktif	MatchDate	1936	0.26
FixtureProgramme2	Cache	PK_FixtureProgramme2_1	CLUSTERED	Evet	Evet	Aktif	CacheMatchId, MatchId, BetradarMatchId	1936	0.51
Form	Match	NULL	HEAP	Hayir	Hayir	Aktif	NULL	4982	1.09
Game	CasinoGame	PK_Game	CLUSTERED	Evet	Evet	Aktif	GameId	0	0.00
GameType	Parameter	PK_GameType	CLUSTERED	Evet	Evet	Aktif	GameTypeId	4	0.02
Goal	Archive	PK_Goal_1	CLUSTERED	Evet	Evet	Aktif	GoalId	0	0.00
Goal	Match	IX_Goal	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId	0	0.16
Goal	Match	IX_Goal_1	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarGoalId	0	0.16
Goal	Match	PK_Goal	CLUSTERED	Evet	Evet	Aktif	GoalId	0	0.16
GoldenBox.Customer	Casino	PK_GoldenBox.Customer	CLUSTERED	Evet	Evet	Aktif	GoldenBoxCustomerId	67	0.02
GoldenBox.Customertransaction	Casino	PK_GoldenBox.Customertransaction	CLUSTERED	Evet	Evet	Aktif	GoldenBoxTransactionId	74244	5.20
Information	Archive	PK_Information	CLUSTERED	Evet	Evet	Aktif	InformationId	0	0.00
Information	Match	IX_Information	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId	12287	1.79
Information	Match	PK_Information_1	CLUSTERED	Evet	Evet	Aktif	InformationId	12287	6.86
Ip	Archive	PK_Ip	CLUSTERED	Evet	Evet	Aktif	CustomerIpId	0	0.00
Ip	Customer	IX_Ip	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId, LoginDate	0	0.00
Ip	Customer	PK_Ip	CLUSTERED	Evet	Evet	Aktif	CustomerIpId	0	0.00
Ip	Users	PK_Ip	CLUSTERED	Evet	Evet	Aktif	UserIpId	802982	59.17
Iso	Parameter	IX_Iso	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarIsoId	250	0.02
Iso	Parameter	PK_Iso	CLUSTERED	Evet	Evet	Aktif	IsoId	250	0.09
LandingPage	CMS	NULL	HEAP	Hayir	Hayir	Aktif	NULL	35	0.02
Language	Language	PK_Language	CLUSTERED	Evet	Evet	Aktif	LanguageId, Language	20	0.07
Limit	Customer	IX_Limit	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId	0	0.00
Limit	Customer	PK_Limit	CLUSTERED	Evet	Evet	Aktif	CustomerLimitId	0	0.00
Live.Event	Archive	IX_Live.Event	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarMatchId, IsActive	63480	4.20
Live.Event	Archive	PK_Event	CLUSTERED	Evet	Evet	Aktif	EventId, BetradarMatchId	63480	9.58
Live.EventDetail	Archive	IX_Live.EventDetail_1	NONCLUSTERED	Hayir	Evet	Aktif	EventId, TimeStatu	63491	5.45
Live.EventDetail	Archive	IX_Live.EventDetail_2	NONCLUSTERED	Hayir	Evet	Aktif	BetradarMatchIds, TimeStatu	63491	5.45
Live.EventDetail	Archive	PK_EventDetail	CLUSTERED	Evet	Evet	Aktif	EventDetailId, EventId, BetradarMatchIds	63491	74.45
Live.EventOdd	Archive	IX_EventOdd_7	NONCLUSTERED	Hayir	Hayir	Aktif	BettradarOddId, BetradarMatchId, OutCome, SpecialBetValue	2396752	235.21
Live.EventOdd	Archive	IX_Live.EventOdd	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId, OddsTypeId, OutCome, SpecialBetValue	2396752	198.59
Live.EventOdd	Archive	IX_Live.EventOdd_1	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId, OddsTypeId	2396752	148.46
Live.EventOdd	Archive	PK_Odd	CLUSTERED	Evet	Evet	Aktif	OddId	2396752	693.15
Live.EventOddProb	Archive	PK_OddProb	CLUSTERED	Evet	Evet	Aktif	OddId	0	0.00
Live.EventOddResult	Archive	IX_Live.EventOddResult	NONCLUSTERED	Hayir	Hayir	Aktif	OddresultId	2406004	74.08
Live.EventOddResult	Archive	IX_Live.EventOddResult_1	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarMatchId, OddsTypeId, OddResult, SpecialBetValue	2406004	171.83
Live.EventOddResult	Archive	PK_Live.EventOddResult	CLUSTERED	Evet	Evet	Aktif	OddresultId	2406004	356.77
Live.EventOddSetting	Archive	NULL	HEAP	Hayir	Hayir	Aktif	NULL	0	0.00
Live.EventOddSetting	Archive	IX_Live.EventOddSetting	NONCLUSTERED	Hayir	Hayir	Aktif	OddId, StateId	0	0.00
Live.EventOddTypeSetting	Archive	IX_Live.EventOddTypeSetting	NONCLUSTERED	Hayir	Hayir	Aktif	OddTypeId, MatchId	409055	23.46
Live.EventOddTypeSetting	Archive	PK_OddTypeSetting	CLUSTERED	Evet	Evet	Aktif	OddTypeSettingId	409055	49.77
Live.EventSetting	Archive	IX_Live.EventSetting	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId	63535	4.09
Live.EventSetting	Archive	PK_Setting	CLUSTERED	Evet	Evet	Aktif	SettingId	63535	9.46
Live.ScoreCardSummary	Archive	IX_Live.ScoreCardSummary	NONCLUSTERED	Hayir	Hayir	Aktif	EventId, ScoreCardType	0	0.00
Live.ScoreCardSummary	Archive	PK_ScoreCardSummary	CLUSTERED	Evet	Evet	Aktif	ScoreCardId	0	0.00
LuckyStreak.Customer	Casino	NULL	HEAP	Hayir	Hayir	Aktif	NULL	0	0.00
LuckyStreak.Game	Casino	PK_LuckyStreak.Game	CLUSTERED	Evet	Evet	Aktif	Id	9	0.02
LuckyStreak.GameDealer	Casino	PK_LuckyStreak.GameDealer	CLUSTERED	Evet	Evet	Aktif	GameDealerId	11830	3.01
LuckyStreak.Limit	Casino	PK_LuckyStreak.Limit	CLUSTERED	Evet	Evet	Aktif	LimitId	16	0.02
LuckyStreak.LimitGroup	Casino	PK_LuckyStreak.LimitGroup	CLUSTERED	Evet	Evet	Aktif	LimitGroupId	10	0.02
LuckyStreak.LimitValue	Casino	PK_LuckyStreak.LimitValue	CLUSTERED	Evet	Evet	Aktif	LimitValueId	32	0.02
LuckyStreak.ParameterGameType	Casino	NULL	HEAP	Hayir	Hayir	Aktif	NULL	3	0.02
LuckyStreak.ParameterLimitType	Casino	PK_LuckyStreak.ParameterLimitType	CLUSTERED	Evet	Evet	Aktif	LimitTypeId	5	0.02
LuckyStreak.Setting	Casino	NULL	HEAP	Hayir	Hayir	Aktif	NULL	1	0.02
LuckyStreak.Transaction	Casino	PK_LuckyStreak.Transaction	CLUSTERED	Evet	Evet	Aktif	LuckyStreakTransactionId	0	0.00
LuckyStreak.TransactionAbort	Casino	PK_LuckyStreak.TransactionAbort	CLUSTERED	Evet	Evet	Aktif	LuckyStreakTransactionAbortId	0	0.00
Match	Archive	IX_Match_3	NONCLUSTERED	Hayir	Evet	Aktif	BetradarMatchId	54038	2.99
Match	Archive	PK_Match_1	CLUSTERED	Evet	Evet	Aktif	MatchId	54038	5.06
Match	Match	IX_Match	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarMatchId	11625	0.63
Match	Match	IX_Match_2	NONCLUSTERED	Hayir	Evet	Aktif	TournamentId, BetradarMatchId	11625	0.70
Match	Match	PK_Match_2	CLUSTERED	Evet	Evet	Aktif	MatchId	11625	9.37
MatchAvailability	Parameter	PK_MatchAvailability	CLUSTERED	Evet	Evet	Aktif	AvailabilityId	15	0.02
MatchCode	Parameter	PK_MatchCode	CLUSTERED	Evet	Evet	Aktif	MatchCodeId	9947	0.64
MatchOdd	Cache	IX_MatchOdd	NONCLUSTERED	Hayir	Evet	Aktif	MatchId, OddsTypeId, OutCome, SpecialBetValue	75492	4.82
MatchOdd	Cache	PK_MatchOdd	CLUSTERED	Evet	Evet	Aktif	Id, MatchId	75492	6.51
MatchOdd_Daily	Cache	IX_MatchOdd_Daily	NONCLUSTERED	Hayir	Hayir	Aktif	StateId	13330	0.70
MatchOdd_Daily	Cache	IX_MatchOdd_Daily_1	NONCLUSTERED	Hayir	Evet	Aktif	MatchId, OddsTypeId, OutCome, SpecialBetValue	13330	1.07
MatchOdd_Daily	Cache	IX_MatchOdd_Daily_2	NONCLUSTERED	Hayir	Hayir	Aktif	OddsTypeId, MatchId, OutCome	13330	1.01
MatchOdd_Daily	Cache	PK_MatchOdd_Daily	CLUSTERED	Evet	Evet	Aktif	Id, MatchId	13330	1.38
MatchState	Parameter	PK_MatchState	CLUSTERED	Evet	Evet	Aktif	StateId	7	0.02
MatchTimeType	Parameter	PK_MatchTimeType	CLUSTERED	Evet	Evet	Aktif	MatchTimeTypeId	26	0.02
Message	Users	IX_Message	NONCLUSTERED	Hayir	Hayir	Aktif	FromUserId, ToUserId, IsRead	34456	2.01
Message	Users	IX_Message_1	NONCLUSTERED	Hayir	Hayir	Aktif	ToUserId	34456	1.49
Message	Users	IX_Message_2	NONCLUSTERED	Hayir	Hayir	Aktif	ToUserId, IsRead, IsDeleted	34456	1.61
Message	Users	IX_Message_3	NONCLUSTERED	Hayir	Hayir	Aktif	ToUserId, IsDeleted, IsFavorite	34456	1.55
Message	Users	PK_Message	CLUSTERED	Evet	Evet	Aktif	UserMessageId	34456	20.55
MobileHomeMenu	CMS	PK_MobileHomeMenu	CLUSTERED	Evet	Evet	Aktif	MobileHomeMenuId	276	0.15
NewCompetitor	Language	NULL	HEAP	Hayir	Hayir	Aktif	NULL	43988	3.88
NewOddType	Language	NULL	HEAP	Hayir	Hayir	Aktif	NULL	38408	5.63
News	RiskManagement	PK_News	CLUSTERED	Evet	Evet	Aktif	NewsId	15	0.07
News.Guardian	CMS	NULL	HEAP	Hayir	Hayir	Aktif	NULL	0	0.00
NewTournament	Language	NULL	HEAP	Hayir	Hayir	Aktif	NULL	116330	7.32
Notes	Customer	NULL	HEAP	Hayir	Hayir	Aktif	NULL	958	0.30
Notice	CMS	NULL	HEAP	Hayir	Hayir	Aktif	NULL	0	0.02
NotificationAuthority	Users	PK_NotificationAuthority	CLUSTERED	Evet	Evet	Aktif	NotificationAuthorityId	0	0.00
NotificationForm	Users	PK_NotificationForm	CLUSTERED	Evet	Evet	Aktif	NotificationFormId	9	0.02
Notifications	Users	IX_BBUN	NONCLUSTERED	Hayir	Hayir	Aktif	FromUserId, NotificationFormId, ControlId, Notification, CreateDate, CustomerId, ToUserId, IsNotyRead	826169	86.23
Notifications	Users	IX_Notifications	NONCLUSTERED	Hayir	Hayir	Aktif	ToUserId, IsNotyRead	826169	25.13
Notifications	Users	IX_UN	NONCLUSTERED	Hayir	Hayir	Aktif	FromUserId, ControlId, Notification, CreateDate, CustomerId, ToUserId, NotificationFormId, IsNotyRead	826169	86.17
Notifications	Users	PK_Notifications	CLUSTERED	Evet	Evet	Aktif	NotificationId	826169	102.01
Odd	Archive	IX_Odd	NONCLUSTERED	Hayir	Hayir	Aktif	OddsTypeId, MatchId, OutCome, SpecialBetValue	2624108	274.44
Odd	Archive	IX_Odd_1	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId	2624108	135.50
Odd	Archive	IX_Odd_8	NONCLUSTERED	Hayir	Evet	Aktif	OddId	2624108	130.13
Odd	Archive	PK_Odd_2	CLUSTERED	Evet	Evet	Aktif	OddId	2624108	648.26
Odd	Match	BB_INDEX1	NONCLUSTERED	Hayir	Hayir	Aktif	OddId, OddValue, OddsTypeId, MatchId	399170	24.61
Odd	Match	IX_BBM	NONCLUSTERED	Hayir	Hayir	Aktif	OddId, OddsTypeId, OutCome, SpecialBetValue, ParameterOddId, MatchId, StateId, OddValue	399170	48.36
Odd	Match	IX_Odd_10	NONCLUSTERED	Hayir	Hayir	Aktif	OddId, OddsTypeId, OutCome, SpecialBetValue, MatchId, ParameterOddId, StateId, OddValue	399170	37.64
Odd	Match	IX_Odd_11	NONCLUSTERED	Hayir	Hayir	Aktif	ParameterOddId, MatchId, OddsTypeId, StateId	399170	24.59
Odd	Match	IX_Odd_13	NONCLUSTERED	Hayir	Hayir	Aktif	OutCome, SpecialBetValue, OddValue, BetradarOddTypeId, OutComeId, StateId, MatchId	399170	40.19
Odd	Match	IX_Odd_2	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId, ParameterOddId	399170	20.92
Odd	Match	IX_Odd_3	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarOddTypeId	399170	18.70
Odd	Match	IX_Odd_4	NONCLUSTERED	Hayir	Hayir	Aktif	OddsTypeId	399170	16.89
Odd	Match	IX_Odd_7	NONCLUSTERED	Hayir	Evet	Aktif	MatchId, ParameterOddId, OutCome, SpecialBetValue	399170	31.19
Odd	Match	IX_Odd_9	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId, BetradarOddTypeId, SpecialBetValue	399170	25.46
Odd	Match	IX_Odd_BB1	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarMatchId, BetradarOddTypeId, OutCome	399170	30.94
Odd	Match	IX_Odd_BB2	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarMatchId, BetradarOddTypeId, OutCome, SpecialBetValue	399170	32.98
Odd	Match	PK_Odd_1	CLUSTERED	Evet	Evet	Aktif	OddId	399170	148.02
Odd	Match	XX_BBM	NONCLUSTERED	Hayir	Hayir	Aktif	OddId, OutCome, SpecialBetValue, MatchId, ParameterOddId, OddsTypeId, StateId, OddValue	399170	181.30
Odd	Outrights	<Name of Missing Index, sysname,>	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId, OddValue, SwCode	61758	6.80
Odd	Outrights	IX_Odd_10	NONCLUSTERED	Hayir	Hayir	Aktif	OddId	61758	2.42
Odd	Outrights	IX_Odd_11	NONCLUSTERED	Hayir	Evet	Aktif	MatchId, BettradarOddId	61758	3.80
Odd	Outrights	IX_Odd_5	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId, CompetitorId, ParameterOddId	61758	4.61
Odd	Outrights	IX_Odd_6	NONCLUSTERED	Hayir	Hayir	Aktif	OddsTypeId, MatchId	61758	3.61
Odd	Outrights	PK_Odd_3	CLUSTERED	Evet	Evet	Aktif	OddId	61758	11.67
Odd2	Match	PK_Odd_2	CLUSTERED	Evet	Evet	Aktif	OddId	7910	2.07
OddData	Parameter	NULL	HEAP	Hayir	Hayir	Aktif	NULL	3	1.50
OddResult	Live	PK_OddResult_1	CLUSTERED	Evet	Evet	Aktif	OddResultId	867	1.05
OddResult	Outrights	IX_OddResult	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId, CompetitorId	0	0.00
OddResult	Outrights	IX_OddResult_1	NONCLUSTERED	Hayir	Hayir	Aktif	OddId, RankNo	0	0.00
OddResult	Outrights	PK_OddResult	CLUSTERED	Evet	Evet	Aktif	OddsResultId	0	0.00
Odds	Parameter	IX_Odds	NONCLUSTERED	Hayir	Evet	Aktif	OddTypeId, Outcomes	2012	0.20
Odds	Parameter	IX_Odds_1	NONCLUSTERED	Hayir	Evet	Aktif	OddTypeId, Outcomes, SpecialBetValue	2012	0.20
Odds	Parameter	IX_Odds_2	NONCLUSTERED	Hayir	Hayir	Aktif	OddsId, LiveOddId	2012	0.20
Odds	Parameter	IX_Odds_3	NONCLUSTERED	Hayir	Hayir	Aktif	OddTypeId, LiveOddId	2012	0.20
Odds	Parameter	PK_ParameterOdds	CLUSTERED	Evet	Evet	Aktif	OddsId	2012	0.32
OddSetting	Archive	IX_OddSetting	NONCLUSTERED	Hayir	Hayir	Aktif	OddId	0	0.00
OddSetting	Archive	PK_OddSetting_1	CLUSTERED	Evet	Evet	Aktif	OddSettingId, OddId	0	0.00
OddSetting	Match	IX_OddSetting_1	NONCLUSTERED	Hayir	Evet	Aktif	OddId, StateId	0	0.16
OddSetting	Match	PK_OddSetting	CLUSTERED	Evet	Evet	Aktif	OddSettingId, OddId	0	0.23
OddSetting	Outrights	IX_OddSetting_2	NONCLUSTERED	Hayir	Hayir	Aktif	OddId	1	0.07
OddSetting	Outrights	PK_OddSetting_2	CLUSTERED	Evet	Evet	Aktif	OddSettingId	1	0.07
OddsFormat	Parameter	PK_OddsFormat	CLUSTERED	Evet	Evet	Aktif	OddsFormatId	3	0.02
OddsResult	Archive	IX_OddsResult_2	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId, OddsTypeId, Outcome, SpecialBetValue	0	0.00
OddsResult	Archive	PK_OddsResult_1	CLUSTERED	Evet	Evet	Aktif	OddsResultId	0	0.00
OddsResult	Match	PK_OddsResult	CLUSTERED	Evet	Evet	Aktif	OddsResultId	0	0.00
OddsType	Parameter	IX_OddsType	NONCLUSTERED	Hayir	Evet	Aktif	BetradarOddsTypeId, SportId, OddsTypeId	554	0.20
OddsType	Parameter	IX_OddsType_1	NONCLUSTERED	Hayir	Hayir	Aktif	OddsTypeId, BetradarOddsTypeId, SportId, IsActive	554	0.20
OddsType	Parameter	IX_OddsType_2	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarOddsTypeId, IsActive	554	0.20
OddsType	Parameter	PK_OddsType	CLUSTERED	Evet	Evet	Aktif	OddsTypeId	554	0.20
OddsTypeCode	Parameter	PK_OddsTypeCode	CLUSTERED	Evet	Evet	Aktif	OddTypeCodeId	204	0.11
OddsTypeCode2	Parameter	PK_OddsTypeCode2	CLUSTERED	Evet	Evet	Aktif	OddTypeCodeId	207	0.20
OddsTypeOutrights	Parameter	PK_OddsTypeOutrights	CLUSTERED	Evet	Evet	Aktif	OddsTypeId	0	0.00
OddTypeGroup	Parameter	PK_OddGroupType	CLUSTERED	Evet	Evet	Aktif	OddTypeGroupId	15	0.07
OddTypeGroupOddType	Parameter	IX_OddTypeGroupOddType	NONCLUSTERED	Hayir	Evet	Aktif	OddTypeGroupOddTypeId	517	0.07
OddTypeGroupOddType	Parameter	IX_OddTypeGroupOddType_1	NONCLUSTERED	Hayir	Hayir	Aktif	OddTypeGroupId, OddTypeId	517	0.20
OddTypeGroupOddType	Parameter	PK_OddTypeGroupOddType	CLUSTERED	Evet	Evet	Aktif	OddTypeGroupOddTypeId	517	0.20
OddTypeSetting	Archive	IX_OddTypeSetting	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId, OddTypeId	655562	41.65
OddTypeSetting	Archive	PK_OddTypeSetting_1	CLUSTERED	Evet	Evet	Aktif	OddTypeSettingId	655562	103.21
OddTypeSetting	Match	IX_BBO	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId, IsPopular, OddTypeId, StateId	81593	4.47
OddTypeSetting	Match	IX_OddTypeSetting_2	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId, OddTypeId, StateId, IsPopular	81593	4.41
OddTypeSetting	Match	IX_OddTypeSetting_5	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId, OddTypeId	81593	3.91
OddTypeSetting	Match	IX_OddTypeSetting_6	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId, OddTypeId, StateId	81593	4.42
OddTypeSetting	Match	PK_OddTypeSetting	CLUSTERED	Evet	Evet	Aktif	OddTypeSettingId, OddTypeId	81593	21.99
OddTypeSetting	Outrights	IX_OddTypeSetting_4	NONCLUSTERED	Hayir	Hayir	Aktif	OddTypeId, MatchId	1042	0.29
OddTypeSetting	Outrights	PK_OddTypeSetting_2	CLUSTERED	Evet	Evet	Aktif	OddTypeSettingId	1042	0.33
Outrights.Competitor	Archive	PK_Competitor_1	CLUSTERED	Evet	Evet	Aktif	EventCompetitorId	0	0.00
Outrights.Event	Archive	PK_Event_1	CLUSTERED	Evet	Evet	Aktif	EventId	0	0.00
Outrights.EventName	Archive	PK_EventName	CLUSTERED	Evet	Evet	Aktif	EventNameId	0	0.00
Outrights.Odd	Archive	PK_Odd_3	CLUSTERED	Evet	Evet	Aktif	OddId	0	0.00
Outrights.OddResult	Archive	PK_OddResult	CLUSTERED	Evet	Evet	Aktif	OddsResultId	0	0.00
Outrights.OddSetting	Archive	PK_OddSetting_2	CLUSTERED	Evet	Evet	Aktif	OddSettingId	0	0.00
Outrights.OddTypeSetting	Archive	PK_OddTypeSetting_2	CLUSTERED	Evet	Evet	Aktif	OddTypeSettingId	0	0.00
Page	CMS	PK_Page	CLUSTERED	Evet	Evet	Aktif	PageId	4	0.11
Parameter.BetStatu	Live	PK_Parameter.BetStatu	CLUSTERED	Evet	Evet	Aktif	BetStatuId	3	0.02
Parameter.BetStatu	Virtual	PK_Parameter.BetStatu	CLUSTERED	Evet	Evet	Aktif	BetStatuId	3	0.02
Parameter.BetStopReason	Live	IX_BBLPC	NONCLUSTERED	Hayir	Hayir	Aktif	StopReason, StopReasonId	92	0.07
Parameter.BetStopReason	Live	PK_Parameter.BetStopReason	CLUSTERED	Evet	Evet	Aktif	StopReasonId	92	0.07
Parameter.CardType	Language	PK_Parameter.CardType	CLUSTERED	Evet	Evet	Aktif	ParameterCardTypeId	3	0.02
Parameter.Category	Language	IX_BBLPC	NONCLUSTERED	Hayir	Hayir	Aktif	CategoryId, CategoryName, LanguageId	22760	1.99
Parameter.Category	Language	IX_Parameter.Category	NONCLUSTERED	Hayir	Hayir	Aktif	CategoryId, LanguageId	22760	1.23
Parameter.Category	Language	PK_Parameter.Category	CLUSTERED	Evet	Evet	Aktif	ParameterCategoryId, CategoryId, LanguageId	22760	2.21
Parameter.ConnectionStatu	Live	PK_Parameter.ConnectionStatu	CLUSTERED	Evet	Evet	Aktif	ConnectionStatuId	2	0.02
Parameter.ConnectionStatu	Virtual	PK_Parameter.ConnectionStatu	CLUSTERED	Evet	Evet	Aktif	ConnectionStatuId	2	0.02
Parameter.CupRound	Language	PK_Parameter.CupRound	CLUSTERED	Evet	Evet	Aktif	ParameterCupRoundId	270	0.04
Parameter.DateInfoType	Language	PK_Parameter.DateInfoType	CLUSTERED	Evet	Evet	Aktif	ParameterDateInfoTypeId	0	0.00
Parameter.Day	Language	NULL	HEAP	Hayir	Hayir	Aktif	NULL	14	0.02
Parameter.EventStatu	Live	PK_Parameter.EventStatu	CLUSTERED	Evet	Evet	Aktif	EventStatuId	3	0.02
Parameter.EventStatu	Virtual	PK_Parameter.EventStatu	CLUSTERED	Evet	Evet	Aktif	EventStatuId	3	0.02
Parameter.FeedStatu	Live	PK_Parameter.FeedStatu	CLUSTERED	Evet	Evet	Aktif	FeedStatuId	2	0.02
Parameter.FeedStatu	Virtual	PK_Parameter.FeedStatu	CLUSTERED	Evet	Evet	Aktif	FeedStatuId	2	0.02
Parameter.GamePlatformTopOdd	GamePlatform	IX_Parameter.GamePlatformTopOdd	NONCLUSTERED	Hayir	Evet	Aktif	ParameterOddId, SportId, OutCome	105	0.07
Parameter.GamePlatformTopOdd	GamePlatform	PK_Parameter.GamePlatformTopOdd	CLUSTERED	Evet	Evet	Aktif	GamePlatformOddId, ParameterOddId	105	0.07
Parameter.GameSource	Casino	NULL	HEAP	Hayir	Hayir	Aktif	NULL	3	0.02
Parameter.GameType	Casino	NULL	HEAP	Hayir	Hayir	Aktif	NULL	7	0.02
Parameter.LandingPagePosition	CMS	NULL	HEAP	Hayir	Hayir	Aktif	NULL	7	0.02
Parameter.LiveBetStopReason	Language	IX_BBMC	NONCLUSTERED	Hayir	Hayir	Aktif	ReasonT, ParameterReasonId, LanguageId	1848	0.27
Parameter.LiveBetStopReason	Language	IX_BBMC0	NONCLUSTERED	Hayir	Hayir	Aktif	ParameterReasonId, ReasonT, LanguageId	1848	0.20
Parameter.LiveBetStopReason	Language	IX_BBMC2	NONCLUSTERED	Hayir	Hayir	Aktif	Reason, ParameterReasonId, LanguageId	1848	0.33
Parameter.LiveBetStopReason	Language	IX_Parameter.LiveBetStopReason	NONCLUSTERED	Hayir	Hayir	Aktif	ParameterReasonId, LanguageId	1848	0.20
Parameter.LiveBetStopReason	Language	PK_Parameter.LiveBetStopreason	CLUSTERED	Evet	Evet	Aktif	BetStopReasonId	1848	0.68
Parameter.LiveBetStopReasonCashout	Language	IX_BBMC2	NONCLUSTERED	Hayir	Hayir	Aktif	Reason, ParameterReasonId, LanguageId	240	0.20
Parameter.LiveBetStopReasonCashout	Language	PK_Parameter.LiveBetStopReasonCashout	CLUSTERED	Evet	Evet	Aktif	BetStopReasonId	240	0.07
Parameter.LiveOdds	Language	IX_Parameter.LiveOdds	NONCLUSTERED	Hayir	Evet	Aktif	OddsId, LanguageId, OutComes	138840	12.01
Parameter.LiveOdds	Language	PK_Parameter.LiveOdds	CLUSTERED	Evet	Evet	Aktif	ParameterLiveOddId	138840	7.90
Parameter.LiveOddType	Language	IX_LPBB	NONCLUSTERED	Hayir	Hayir	Aktif	OddTypeId, OddsType, ShortOddType, LanguageId	17340	3.83
Parameter.LiveOddType	Language	IX_Parameter.LiveOddType	NONCLUSTERED	Hayir	Evet	Aktif	OddTypeId, LanguageId	17340	0.98
Parameter.LiveOddType	Language	PK_Parameter.LiveOddType	CLUSTERED	Evet	Evet	Aktif	ParametersLiveOddTypeId	17340	3.18
Parameter.LiveTimeStatu	Language	IX_Parameter.LiveTimeStatu	NONCLUSTERED	Hayir	Evet	Aktif	ParameterTimeStatuId, LanguageId	2089	0.20
Parameter.LiveTimeStatu	Language	PK_Parameter.LiveTimeStatu	CLUSTERED	Evet	Evet	Aktif	TimeStatuId	2089	0.27
Parameter.MatchState	Language	PK_Language.Parameter.MatchState	CLUSTERED	Evet	Evet	Aktif	ParameterMatchStateId	133	0.02
Parameter.Odds	Language	IX_Parameter.Odds_1	NONCLUSTERED	Hayir	Evet	Aktif	LanguageId, OddsId, OutComes	39733	2.10
Parameter.Odds	Language	IX_Parameter.Odds_2	NONCLUSTERED	Hayir	Hayir	Aktif	OddsId, LanguageId	39733	1.39
Parameter.Odds	Language	PK_Parameter.Odds_1	CLUSTERED	Evet	Evet	Aktif	ParameterOddId	39733	2.39
Parameter.Odds	Live	IX_Parameter.Odds	NONCLUSTERED	Hayir	Evet	Aktif	OddTypeId, Outcomes	6942	0.38
Parameter.Odds	Live	PK_Parameter.Odds	CLUSTERED	Evet	Evet	Aktif	OddsId, OddTypeId	6942	0.58
Parameter.Odds	Virtual	PK_Parameter.Odds	CLUSTERED	Evet	Evet	Aktif	OddsId	3834	0.26
Parameter.OddsFormat	Language	PK_Parameter.OddsFormat	CLUSTERED	Evet	Evet	Aktif	ParameterOddsFormatId	30	0.02
Parameter.OddsType	Language	BB_LANGDX	NONCLUSTERED	Hayir	Hayir	Aktif	OddsTypeId, OddsType, LanguageId	10858	0.90
Parameter.OddsType	Language	BB_LANGDX1	NONCLUSTERED	Hayir	Hayir	Aktif	OddsTypeId, OddsType, ShortOddType, LanguageId	10858	1.34
Parameter.OddsType	Language	IX_Parameter.OddsType	NONCLUSTERED	Hayir	Evet	Aktif	OddsTypeId, LanguageId	10858	0.59
Parameter.OddsType	Language	PK_Parameter.OddsType	CLUSTERED	Evet	Evet	Aktif	ParameterOddsTypeId	10858	1.50
Parameter.OddType	Live	IX_Parameter.OddType_2	NONCLUSTERED	Hayir	Evet	Aktif	BetradarOddsTypeId, BetradarOddsSubTypeId, OddTypeId	867	0.20
Parameter.OddType	Live	IX_Parameter.OddType_3	NONCLUSTERED	Hayir	Hayir	Aktif	OddTypeId, IsActive	867	0.20
Parameter.OddType	Live	IX_Parameter.OddType_4	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarOddsTypeId, BetradarOddsSubTypeId, IsActive	867	0.20
Parameter.OddType	Live	PK_Parameter.OddType	CLUSTERED	Evet	Evet	Aktif	OddTypeId	867	0.30
Parameter.OddType	Virtual	IX_Parameter.OddType	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarOddsTypeId	747	0.04
Parameter.OddType	Virtual	IX_Parameter.OddType_1	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarOddsSubTypeId	747	0.04
Parameter.OddType	Virtual	PK_Parameter.OddType	CLUSTERED	Evet	Evet	Aktif	OddTypeId	747	0.13
Parameter.OddTypeGroupOddType	Live	IX_Parameter.OddTypeGroupOddType	NONCLUSTERED	Hayir	Evet	Aktif	OddTypeGroupOddTypeId	844	0.20
Parameter.OddTypeGroupOddType	Live	IX_Parameter.OddTypeGroupOddType_1	NONCLUSTERED	Hayir	Hayir	Aktif	OddTypeGroupId	844	0.20
Parameter.OddTypeGroupOddType	Live	PK_Parameter.OddTypeGroupOddType	CLUSTERED	Evet	Evet	Aktif	OddTypeGroupOddTypeId	844	0.20
Parameter.PasswordQuestion	Language	PK_Parameter.PasswordQuestion	CLUSTERED	Evet	Evet	Aktif	ParameterPasswordQuestionId	85	0.02
Parameter.Salutation	Language	PK_Parameter.Salutation	CLUSTERED	Evet	Evet	Aktif	ParameterSalutationId	57	0.02
Parameter.ScoreCardType	Live	PK_Parameter.ScoreCardType	CLUSTERED	Evet	Evet	Aktif	ScoreCardTypeId	4	0.02
Parameter.ScoreCardType	Virtual	PK_Parameter.ScoreCardType	CLUSTERED	Evet	Evet	Aktif	ScoreCardTypeId	2	0.02
Parameter.SideBannerPosition	CMS	NULL	HEAP	Hayir	Hayir	Aktif	NULL	11	0.02
Parameter.SlipState	Language	IX_Parameter.SlipState	NONCLUSTERED	Hayir	Evet	Aktif	SlipStateId, LanguageId	118	0.07
Parameter.SlipState	Language	PK_Parameter.SlipState	CLUSTERED	Evet	Evet	Aktif	ParameterSlipStateId	118	0.02
Parameter.SlipStatu	Language	IX_Parameter.SlipStatu	NONCLUSTERED	Hayir	Hayir	Aktif	SlipStatuId, LanguageId	80	0.07
Parameter.SlipStatu	Language	PK_Parameter.SlipStatu	CLUSTERED	Evet	Evet	Aktif	ParameterSlipStatuId	80	0.02
Parameter.SlipType	Language	IX_Parameter.SlipType	NONCLUSTERED	Hayir	Evet	Aktif	SlipTypeId, LanguageId	60	0.07
Parameter.SlipType	Language	PK_Parameter.SlipType	CLUSTERED	Evet	Evet	Aktif	ParameterSlipTypeId	60	0.07
Parameter.Sport	Language	IX_Parameter.Sport	NONCLUSTERED	Hayir	Hayir	Aktif	SportId, LanguageId	2237	0.13
Parameter.Sport	Language	PK_Parameter.Sport	CLUSTERED	Evet	Evet	Aktif	ParameterSportId, SportId	2237	0.27
Parameter.TennisRound	Virtual	PK_Parameter.TennisRound	CLUSTERED	Evet	Evet	Aktif	TennisRoundId	4	0.02
Parameter.TimeStatu	Live	PK_Parameter.TimeStatu	CLUSTERED	Evet	Evet	Aktif	TimeStatuId	107	0.20
Parameter.TimeStatu	Virtual	PK_Parameter.TimeStatu	CLUSTERED	Evet	Evet	Aktif	TimeStatuId	89	0.02
Parameter.Tournament	Language	IX_Parameter.Tournament	NONCLUSTERED	Hayir	Hayir	Aktif	TournamentId, LanguageId	719134	38.87
Parameter.Tournament	Language	IX_Parameter.Tournament_1	NONCLUSTERED	Hayir	Hayir	Aktif	TournamentName, LanguageId	719134	119.98
Parameter.Tournament	Language	IX_Tournament	NONCLUSTERED	Hayir	Hayir	Aktif	TournamentId, TournamentName, LanguageId	719134	61.11
Parameter.Tournament	Language	PK_Parameter.Tournament	CLUSTERED	Evet	Evet	Aktif	ParameterTournamentId, TournamentId	719134	104.73
Parameter.TournamentOutrights	Language	IX_Parameter.TournamentOutrights	NONCLUSTERED	Hayir	Hayir	Aktif	TournamentId, LanguageId	585809	36.22
Parameter.TournamentOutrights	Language	PK_Parameter.TournamentOutrights	CLUSTERED	Evet	Evet	Aktif	ParameterTournamentId	585809	84.63
Parameter.TransactionType	Language	PK_Parameter.TransactionType	CLUSTERED	Evet	Evet	Aktif	ParameterTranscationTypeId	1014	0.19
Parameter.TransactionTypeBranch	Language	IX_Parameter.TransactionTypeBranch	NONCLUSTERED	Hayir	Hayir	Aktif	BranchTransactionTypeId, LanguageId	340	0.07
Parameter.TransactionTypeBranch	Language	PK_Parameter.TransactionTypeBranch	CLUSTERED	Evet	Evet	Aktif	ParamTransTypeBranchId	340	0.09
Parameter.Venue	Language	PK_Parameter.Venue	CLUSTERED	Evet	Evet	Aktif	ParameterVenueId	0	0.00
ParameterCompetitor	Language	BbLp	NONCLUSTERED	Hayir	Hayir	Aktif	CompetitorId, LanguageId, CompetitorName	5213647	707.99
ParameterCompetitor	Language	IX_ParameterCompetitor	NONCLUSTERED	Hayir	Evet	Aktif	CompetitorId, LanguageId	5213647	334.18
ParameterCompetitor	Language	IX_ParameterCompetitor2	NONCLUSTERED	Hayir	Hayir	Aktif	CompetitorId, CompetitorName, LanguageId	5213647	716.68
ParameterCompetitor	Language	PK_ParameterCompetitor	CLUSTERED	Evet	Evet	Aktif	ParameterCompetitorId	5213647	424.05
PasswordQuestion	Parameter	PK_PasswordQuestion	CLUSTERED	Evet	Evet	Aktif	PasswordQuestionId	5	0.02
PaymentSetting	Parameter	PK_PaymentSetting	CLUSTERED	Evet	Evet	Aktif	PaymentSettingId	12	0.02
PaymentSystemSetting	General	PK_PaymentSystemSetting	CLUSTERED	Evet	Evet	Aktif	PaymentSystemSettingId	1	0.02
PaymentType	Parameter	PK_PaymentType	CLUSTERED	Evet	Evet	Aktif	PaymentTypeId	19	0.02
PaymentTypeDescription	Parameter	IX_PaymentTypeDescription	NONCLUSTERED	Hayir	Hayir	Aktif	PaymentTypeId	153	0.07
PaymentTypeDescription	Parameter	PK_PaymentTypeDescription	CLUSTERED	Evet	Evet	Aktif	PaymentDescId	153	0.07
PEPControl	Customer	PK_PEPControl	CLUSTERED	Evet	Evet	Aktif	CustomerPepId	13701	1.39
PhoneCode	Parameter	PK_PhoneCode	CLUSTERED	Evet	Evet	Aktif	PhoneCodeId	206	0.04
Pitcher	Match	IX_Pitcher	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId	0	0.00
Pitcher	Match	PK_Pitcher	CLUSTERED	Evet	Evet	Aktif	PitcherId	0	0.00
Probability	Archive	PK_Probability_1	CLUSTERED	Evet	Evet	Aktif	ProbabilityId	0	0.00
Probability	Match	IX_Probability_1	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId, OddsTypeId, OutCome, SpecialBetValue	0	0.00
Probability	Match	PK_Probability	CLUSTERED	Evet	Evet	Aktif	ProbabilityId	0	0.00
Programme	Cache	IX_Programme	NONCLUSTERED	Hayir	Hayir	Aktif	SportId, MatchDate, TournamentId	699	0.07
Programme	Cache	IX_Programme_1	NONCLUSTERED	Hayir	Hayir	Aktif	SportId, MatchDate	699	0.07
Programme	Cache	IXBBCP	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId, BetradarMatchId, HomeTeam , AwayTeam , TournamentId, SportId, OddId1, OddId2, OddId3, OddIdBasketFirstHalf_1, OddIdBasketFirstHalf_2, OddIdBasketFirstHalf_x, OddIdBoth_N, OddIdBoth_Y, OddIdDouble_1, OddIdDouble_2, OddIdDouble_X, OddIdFirstHalf_1, OddIdFirstHalf_2, OddIdFirstHalf_X, OddIdFirstHalfTotalsO_0_5, OddIdFirstHalfTotalsO_1_5, OddIdFirstHalfTotalsU_0_5, OddIdFirstHalfTotalsU_1_5, OddIdFirstScore_1, OddIdFirstScore_2, OddIdFirstScore_None, OddIdHadicap01_1, OddIdHadicap01_2, OddIdHadicap01_X, OddIdHadicap02_1, OddIdHadicap02_2, OddIdHadicap02_X, OddIdHadicap10_1, OddIdHadicap10_2, OddIdHadicap10_X, OddIdHadicap20_1, OddIdHadicap20_2, OddIdHadicap20_X, OddIdTennisFirstSet_1, OddIdTennisFirstSet_2, OddIdTennisScore_02, OddIdTennisScore_12, OddIdTennisScore_20, OddIdTennisScore_21, OddIdTennisTotal_O, OddIdTennisTotal_U, OddIdTotals_O1_5, OddIdTotals_O2_5, OddIdTotals_O3_5, OddIdTotals_O4_5, OddIdTotals_U1_5, OddIdTotals_U2_5, OddIdTotals_U3_5, OddIdTotals_U4_5, OddIdTotalSpread_O, OddIdTotalSpread_U, OddSpecialBetValueFirstHalfTotalsO_0_5, OddSpecialBetValueFirstHalfTotalsO_1_5, OddSpecialBetValueHadicap01_1, OddSpecialBetValueHadicap02_1, OddSpecialBetValueHadicap10_1, OddSpecialBetValueHadicap20_1, OddSpecialBetValueTennisTotal_O, OddSpecialBetValueTotals_O1_5, OddSpecialBetValueTotals_O2_5, OddSpecialBetValueTotals_O3_5, OddSpecialBetValueTotals_O4_5, OddSpecialBetValueTotalSpread_O, OddValueBasketFirstHalf_1, OddValueBasketFirstHalf_2, OddValueBasketFirstHalf_x, OddValueBoth_N, OddValueBoth_Y, OddValueDouble_1, OddValueDouble_2, OddValueDouble_X, OddValueFirstHalf_1, OddValueFirstHalf_2, OddValueFirstHalf_X, OddValueFirstHalfTotalsO_0_5, OddValueFirstHalfTotalsO_1_5, OddValueFirstHalfTotalsU_0_5, OddValueFirstHalfTotalsU_1_5, OddValueFirstScore_1, OddValueFirstScore_2, OddValueFirstScore_None, OddValueHadicap01_1, OddValueHadicap01_2, OddValueHadicap01_X, OddValueHadicap02_1, OddValueHadicap02_2, OddValueHadicap02_X, OddValueHadicap10_1, OddValueHadicap10_2, OddValueHadicap10_X, OddValueHadicap20_1, OddValueHadicap20_2, OddValueHadicap20_X, OddValueTennisFirstSet_1, OddValueTennisFirstSet_2, OddValueTennisScore_02, OddValueTennisScore_12, OddValueTennisScore_20, OddValueTennisScore_21, OddValueTennisTotal_O, OddValueTennisTotal_U, OddValueTotals_O1_5, OddValueTotals_O2_5, OddValueTotals_O3_5, OddValueTotals_O4_5, OddValueTotals_U1_5, OddValueTotals_U2_5, OddValueTotals_U3_5, OddValueTotals_U4_5, OddValueTotalSpread_O, OddValueTotalSpread_U, OutComeTennisScore_02, OutComeTennisScore_12, OutComeTennisScore_20, OutComeTennisScore_21, MatchDate	699	0.82
Programme	Cache	PK_Programme_1	CLUSTERED	Evet	Evet	Aktif	ProgrammeId, BetradarMatchId, MatchId	699	3.26
Programme2	Cache	IX_BCP2	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarMatchId, HomeTeam , AwayTeam , TournamentId, SportId, OddId1, OddId2, OddId3, OddIdBasketFirstHalf_1, OddIdBasketFirstHalf_2, OddIdBasketFirstHalf_x, OddIdBoth_N, OddIdBoth_Y, OddIdDouble_1, OddIdDouble_2, OddIdDouble_X, OddIdFirstHalf_1, OddIdFirstHalf_2, OddIdFirstHalf_X, OddIdFirstHalfTotalsO_0_5, OddIdFirstHalfTotalsO_1_5, OddIdFirstHalfTotalsU_0_5, OddIdFirstHalfTotalsU_1_5, OddIdFirstScore_1, OddIdFirstScore_2, OddIdFirstScore_None, OddIdHadicap01_1, OddIdHadicap01_2, OddIdHadicap01_X, OddIdHadicap02_1, OddIdHadicap02_2, OddIdHadicap02_X, OddIdHadicap10_1, OddIdHadicap10_2, OddIdHadicap10_X, OddIdHadicap20_1, OddIdHadicap20_2, OddIdHadicap20_X, OddIdTennisFirstSet_1, OddIdTennisFirstSet_2, OddIdTennisScore_02, OddIdTennisScore_12, OddIdTennisScore_20, OddIdTennisScore_21, OddIdTennisTotal_O, OddIdTennisTotal_U, OddIdTotals_O1_5, OddIdTotals_O2_5, OddIdTotals_O3_5, OddIdTotals_O4_5, OddIdTotals_U1_5, OddIdTotals_U2_5, OddIdTotals_U3_5, OddIdTotals_U4_5, OddIdTotalSpread_O, OddIdTotalSpread_U, OddSpecialBetValueFirstHalfTotalsO_0_5, OddSpecialBetValueFirstHalfTotalsO_1_5, OddSpecialBetValueHadicap01_1, OddSpecialBetValueHadicap02_1, OddSpecialBetValueHadicap10_1, OddSpecialBetValueHadicap20_1, OddSpecialBetValueTennisTotal_O, OddSpecialBetValueTotals_O1_5, OddSpecialBetValueTotals_O2_5, OddSpecialBetValueTotals_O3_5, OddSpecialBetValueTotals_O4_5, OddSpecialBetValueTotalSpread_O, OddValueBasketFirstHalf_1, OddValueBasketFirstHalf_2, OddValueBasketFirstHalf_x, OddValueBoth_N, OddValueBoth_Y, OddValueDouble_1, OddValueDouble_2, OddValueDouble_X, OddValueFirstHalf_1, OddValueFirstHalf_2, OddValueFirstHalf_X, OddValueFirstHalfTotalsO_0_5, OddValueFirstHalfTotalsO_1_5, OddValueFirstHalfTotalsU_0_5, OddValueFirstHalfTotalsU_1_5, OddValueFirstScore_1, OddValueFirstScore_2, OddValueFirstScore_None, OddValueHadicap01_1, OddValueHadicap01_2, OddValueHadicap01_X, OddValueHadicap02_1, OddValueHadicap02_2, OddValueHadicap02_X, OddValueHadicap10_1, OddValueHadicap10_2, OddValueHadicap10_X, OddValueHadicap20_1, OddValueHadicap20_2, OddValueHadicap20_X, OddValueTennisFirstSet_1, OddValueTennisFirstSet_2, OddValueTennisScore_02, OddValueTennisScore_12, OddValueTennisScore_20, OddValueTennisScore_21, OddValueTennisTotal_O, OddValueTennisTotal_U, OddValueTotals_O1_5, OddValueTotals_O2_5, OddValueTotals_O3_5, OddValueTotals_O4_5, OddValueTotals_U1_5, OddValueTotals_U2_5, OddValueTotals_U3_5, OddValueTotals_U4_5, OddValueTotalSpread_O, OddValueTotalSpread_U, OutComeTennisScore_02, OutComeTennisScore_12, OutComeTennisScore_20, OutComeTennisScore_21, MatchId, MatchDate	1936	2.07
Programme2	Cache	IX_Programme2	NONCLUSTERED	Hayir	Hayir	Aktif	SportId, MatchDate, TournamentId	1936	0.26
Programme2	Cache	IX_Programme2_1	NONCLUSTERED	Hayir	Hayir	Aktif	SportId, MatchDate	1936	0.26
Programme2	Cache	IXBBCP	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId, BetradarMatchId, HomeTeam , AwayTeam , TournamentId, SportId, OddId1, OddId2, OddId3, OddIdBasketFirstHalf_1, OddIdBasketFirstHalf_2, OddIdBasketFirstHalf_x, OddIdBoth_N, OddIdBoth_Y, OddIdDouble_1, OddIdDouble_2, OddIdDouble_X, OddIdFirstHalf_1, OddIdFirstHalf_2, OddIdFirstHalf_X, OddIdFirstHalfTotalsO_0_5, OddIdFirstHalfTotalsO_1_5, OddIdFirstHalfTotalsU_0_5, OddIdFirstHalfTotalsU_1_5, OddIdFirstScore_1, OddIdFirstScore_2, OddIdFirstScore_None, OddIdHadicap01_1, OddIdHadicap01_2, OddIdHadicap01_X, OddIdHadicap02_1, OddIdHadicap02_2, OddIdHadicap02_X, OddIdHadicap10_1, OddIdHadicap10_2, OddIdHadicap10_X, OddIdHadicap20_1, OddIdHadicap20_2, OddIdHadicap20_X, OddIdTennisFirstSet_1, OddIdTennisFirstSet_2, OddIdTennisScore_02, OddIdTennisScore_12, OddIdTennisScore_20, OddIdTennisScore_21, OddIdTennisTotal_O, OddIdTennisTotal_U, OddIdTotals_O1_5, OddIdTotals_O2_5, OddIdTotals_O3_5, OddIdTotals_O4_5, OddIdTotals_U1_5, OddIdTotals_U2_5, OddIdTotals_U3_5, OddIdTotals_U4_5, OddIdTotalSpread_O, OddIdTotalSpread_U, OddSpecialBetValueFirstHalfTotalsO_0_5, OddSpecialBetValueFirstHalfTotalsO_1_5, OddSpecialBetValueHadicap01_1, OddSpecialBetValueHadicap02_1, OddSpecialBetValueHadicap10_1, OddSpecialBetValueHadicap20_1, OddSpecialBetValueTennisTotal_O, OddSpecialBetValueTotals_O1_5, OddSpecialBetValueTotals_O2_5, OddSpecialBetValueTotals_O3_5, OddSpecialBetValueTotals_O4_5, OddSpecialBetValueTotalSpread_O, OddValueBasketFirstHalf_1, OddValueBasketFirstHalf_2, OddValueBasketFirstHalf_x, OddValueBoth_N, OddValueBoth_Y, OddValueDouble_1, OddValueDouble_2, OddValueDouble_X, OddValueFirstHalf_1, OddValueFirstHalf_2, OddValueFirstHalf_X, OddValueFirstHalfTotalsO_0_5, OddValueFirstHalfTotalsO_1_5, OddValueFirstHalfTotalsU_0_5, OddValueFirstHalfTotalsU_1_5, OddValueFirstScore_1, OddValueFirstScore_2, OddValueFirstScore_None, OddValueHadicap01_1, OddValueHadicap01_2, OddValueHadicap01_X, OddValueHadicap02_1, OddValueHadicap02_2, OddValueHadicap02_X, OddValueHadicap10_1, OddValueHadicap10_2, OddValueHadicap10_X, OddValueHadicap20_1, OddValueHadicap20_2, OddValueHadicap20_X, OddValueTennisFirstSet_1, OddValueTennisFirstSet_2, OddValueTennisScore_02, OddValueTennisScore_12, OddValueTennisScore_20, OddValueTennisScore_21, OddValueTennisTotal_O, OddValueTennisTotal_U, OddValueTotals_O1_5, OddValueTotals_O2_5, OddValueTotals_O3_5, OddValueTotals_O4_5, OddValueTotals_U1_5, OddValueTotals_U2_5, OddValueTotals_U3_5, OddValueTotals_U4_5, OddValueTotalSpread_O, OddValueTotalSpread_U, OutComeTennisScore_02, OutComeTennisScore_12, OutComeTennisScore_20, OutComeTennisScore_21, MatchDate	1936	2.07
Programme2	Cache	PK_Programme_2	CLUSTERED	Evet	Evet	Aktif	ProgrammeId, MatchId, BetradarMatchId	1936	10.76
ProgrammeConfig	Retail	PK_ProgrammeConfig	CLUSTERED	Evet	Evet	Aktif	Id	34830	2.70
Provider	CasinoGame	PK_Provider	CLUSTERED	Evet	Evet	Aktif	ProviderId	0	0.00
Provider.Customer	Casino	PK_Provider.Customer	CLUSTERED	Evet	Evet	Aktif	ProviderCustomerId	0	0.00
QrCode	Customer	IX_QrCode	NONCLUSTERED	Hayir	Hayir	Aktif	BranchId	3	0.07
QrCode	Customer	IX_QrCode_1	NONCLUSTERED	Hayir	Evet	Aktif	BranchId, CustomerId	3	0.07
QrCode	Customer	PK_QrCode	CLUSTERED	Evet	Evet	Aktif	QrCodeId	3	0.07
QrCodeLog	Customer	PK_QrCodeLog	CLUSTERED	Evet	Evet	Aktif	QrCodeId	736160	56.87
RealGaming.AmaticGame	Casino	NULL	HEAP	Hayir	Hayir	Aktif	NULL	40	0.02
RealGaming.AmaticGameCustomer	Casino	NULL	HEAP	Hayir	Hayir	Aktif	NULL	12240	1.39
RealGaming.AmaticGameSetting	Casino	NULL	HEAP	Hayir	Hayir	Aktif	NULL	1	0.02
RealGaming.AmaticGameTransaction	Casino	PK_RealGaming.AmaticGameTransaction	CLUSTERED	Evet	Evet	Aktif	AmaticGameTransactionId	1792855	297.87
RealGaming.NetentGame	Casino	NULL	HEAP	Hayir	Hayir	Aktif	NULL	139	0.05
RealGaming.ParameterCurrency	Casino	NULL	HEAP	Hayir	Hayir	Aktif	NULL	4	0.02
RealGaming.PlayTech	Casino	NULL	HEAP	Hayir	Hayir	Aktif	NULL	96	0.04
RegisterScreen	Parameter	NULL	HEAP	Hayir	Hayir	Aktif	NULL	27	0.02
Result	Cache	PK_Result	CLUSTERED	Evet	Evet	Aktif	ResultId, SportId, CategoryId, TournamentId	1357	0.20
RiskLevel	Parameter	PK_RiskLevel	CLUSTERED	Evet	Evet	Aktif	RiskLevelId	3	0.02
RiskManagement.Rule	Live	IX_RiskManagement.Rule	NONCLUSTERED	Hayir	Hayir	Aktif	SportId, CategoryId, StopDate, IsActive	860	0.20
RiskManagement.Rule	Live	IX_RiskManagement.Rule_1	NONCLUSTERED	Hayir	Hayir	Aktif	TournamentId, CompetitorId, StopDate, IsActive	860	0.20
RiskManagement.Rule	Live	IX_RiskManagement.Rule_2	NONCLUSTERED	Hayir	Hayir	Aktif	CategoryId, TournamentId, StopDate, IsActive	860	0.20
RiskManagement.Rule	Live	IX_RiskManagement.Rule_3	NONCLUSTERED	Hayir	Hayir	Aktif	CompetitorId	860	0.20
RiskManagement.Rule	Live	IX_RiskManagement.Rule_4	NONCLUSTERED	Hayir	Evet	Aktif	SportId, CategoryId, TournamentId, CompetitorId	860	0.20
RiskManagement.Rule	Live	PK_Rule	CLUSTERED	Evet	Evet	Aktif	RuleId	860	0.34
RiskManagement.Rule	Virtual	PK_Rule	CLUSTERED	Evet	Evet	Aktif	RuleId	1	0.02
RiskManagement.RuleOddType	Live	IX_RiskManagement.RuleOddType	NONCLUSTERED	Hayir	Evet	Aktif	OddTypeId, RuleId	737497	33.51
RiskManagement.RuleOddType	Live	PK_RuleOddType	CLUSTERED	Evet	Evet	Aktif	RuleOddTypeId	737497	74.29
RiskManagement.RuleOddType	Virtual	PK_RuleOddType	CLUSTERED	Evet	Evet	Aktif	RuleOddTypeId	681	0.13
RoleControls	Users	PK_RoleControls	CLUSTERED	Evet	Evet	Aktif	RoleControlId	559	0.19
Roles	Users	PK_Roles	CLUSTERED	Evet	Evet	Aktif	RoleId	21	0.02
Rule	Bonus	PK_Rule_1	CLUSTERED	Evet	Evet	Aktif	BonusRuleId	3	0.02
Rule	RiskManagement	IX_Rule	NONCLUSTERED	Hayir	Hayir	Aktif	TournamentId, StopDate, CompetitorId, IsActive	579	0.20
Rule	RiskManagement	IX_Rule_1	NONCLUSTERED	Hayir	Hayir	Aktif	CategoryId, TournamentId, StopDate, IsActive	579	0.20
Rule	RiskManagement	IX_Rule_2	NONCLUSTERED	Hayir	Evet	Aktif	SportId, CategoryId, TournamentId, CompetitorId	579	0.20
Rule	RiskManagement	NonClusteredIndex-20210921-124446	NONCLUSTERED	Hayir	Hayir	Aktif	SportId, CategoryId, StopDate, IsActive	579	0.20
Rule	RiskManagement	NonClusteredIndex-20210921-124523	NONCLUSTERED	Hayir	Hayir	Aktif	SportId, StopDate, IsActive	579	0.20
Rule	RiskManagement	PK_Rule	CLUSTERED	Evet	Evet	Aktif	RuleId	579	0.21
Rule	Stadium	NULL	HEAP	Hayir	Hayir	Aktif	NULL	2	0.07
RuleCashType	Bonus	PK_RuleCashType	CLUSTERED	Evet	Evet	Aktif	RuleCashTypeId	2	0.02
RuleCategory	Stadium	PK_RuleCategory	CLUSTERED	Evet	Evet	Aktif	RuleCategoryId	2	0.07
RuleCompareType	Parameter	PK_RuleCompareType	CLUSTERED	Evet	Evet	Aktif	CompareTypeId	5	0.02
RuleDays	Bonus	NULL	HEAP	Hayir	Hayir	Aktif	NULL	14	0.02
RuleOddType	RiskManagement	IX_RuleOddType	NONCLUSTERED	Hayir	Hayir	Aktif	RuleOddTypeId	83942	4.32
RuleOddType	RiskManagement	IX_RuleOddType_1	NONCLUSTERED	Hayir	Hayir	Aktif	RuleOddTypeId, OddTypeId	83942	4.32
RuleOddType	RiskManagement	IX_RuleOddType_2	NONCLUSTERED	Hayir	Hayir	Aktif	RuleId, OddTypeId	83942	4.51
RuleOddType	RiskManagement	PK_RuleOddType	CLUSTERED	Evet	Evet	Aktif	RuleOddTypeId, RuleId, OddTypeId	83942	10.59
RuleSports	Stadium	PK_RuleSports	CLUSTERED	Evet	Evet	Aktif	RuleSportsId	2	0.07
RuleTime	Parameter	PK_RuleTime	CLUSTERED	Evet	Evet	Aktif	RuleTimeId	4	0.02
RuleTournament	Stadium	PK_RuleTournament	CLUSTERED	Evet	Evet	Aktif	RuleTournamentId	2	0.07
RuleValueType	Parameter	PK_RuleValueType	CLUSTERED	Evet	Evet	Aktif	ValueTypeId	10	0.02
Salutation	Parameter	PK_Salutation	CLUSTERED	Evet	Evet	Aktif	SalutationId	3	0.02
Score	Live	IX_Score	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarMatchId, Score	0	0.09
Score	Live	IX_Score_1	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarMatchId	0	0.09
Score	Live	PK_Score	CLUSTERED	Evet	Evet	Aktif	ScoreId	0	0.19
Score	Match	PK_Score_1	CLUSTERED	Evet	Evet	Aktif	ScoreId	0	0.00
ScoreCardSummary	Live	IX_ScoreCardSummary	NONCLUSTERED	Hayir	Hayir	Aktif	EventId, ScoreCardType	76	0.13
ScoreCardSummary	Live	IX_ScoreCardSummary_1	NONCLUSTERED	Hayir	Hayir	Aktif	EventId, ScoreCardType, AffectedTeam, IsCanceled, CardType	76	0.22
ScoreCardSummary	Live	IX_ScoreCardSummary_2	NONCLUSTERED	Hayir	Evet	Aktif	EventId, BetradarId	76	0.20
ScoreCardSummary	Live	IX_ScoreCardSummary_3	NONCLUSTERED	Hayir	Evet	Aktif	EventId, BetradarId, CardType, ScoreCardType, AffectedTeam, Time	76	0.18
ScoreCardSummary	Live	IX_ScoreCardSummary_4	NONCLUSTERED	Hayir	Hayir	Aktif	EventId, AffectedTeam, ScoreCardType, CardType	76	0.19
ScoreCardSummary	Live	PK_ScoreCardSummary	CLUSTERED	Evet	Evet	Aktif	ScoreCardId	76	0.22
ScoreCardSummary	Virtual	PK_ScoreCardSummary	CLUSTERED	Evet	Evet	Aktif	ScoreCardId	0	0.00
ScoreComment	Archive	PK_ScoreComment_1	CLUSTERED	Evet	Evet	Aktif	ScoreCommentId	0	0.00
ScoreComment	Match	IX_ScoreComment	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId	95	0.15
ScoreComment	Match	PK_ScoreComment	CLUSTERED	Evet	Evet	Aktif	ScoreCommentId, MatchId	95	0.24
ScoreInfo	Archive	IX_ScoreInfo_1	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId, MatchTimeTypeId	0	0.18
ScoreInfo	Archive	PK_ScoreInfo_1	CLUSTERED	Evet	Evet	Aktif	ScoreInfoId, MatchId	0	0.18
ScoreInfo	Match	IX_ScoreInfo_2	NONCLUSTERED	Hayir	Evet	Aktif	MatchId, MatchTimeTypeId	1643	1.88
ScoreInfo	Match	PK_ScoreInfo	CLUSTERED	Evet	Evet	Aktif	ScoreInfoId, MatchId	1643	3.38
Selection	MTS	PK_Selection	CLUSTERED	Evet	Evet	Aktif	SelectionId	0	0.00
Setting	Archive	IX_Setting	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId	52270	3.26
Setting	Archive	PK_Setting_2	CLUSTERED	Evet	Evet	Aktif	SettingId, MatchId	52270	7.76
Setting	General	PK_Setting_1	CLUSTERED	Evet	Evet	Aktif	SettingId	1	0.02
Setting	Match	IX_Setting_1	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId	11639	0.63
Setting	Match	IX_Setting_2	NONCLUSTERED	Hayir	Hayir	Aktif	StateId	11639	0.63
Setting	Match	IX_Setting_3	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId, StateId	11639	0.63
Setting	Match	PK_Setting	CLUSTERED	Evet	Evet	Aktif	SettingId, MatchId	11639	12.80
SideBanner	CMS	NULL	HEAP	Hayir	Hayir	Aktif	NULL	16	0.09
Slider	CasinoGame	PK_Slider_1	CLUSTERED	Evet	Evet	Aktif	SliderId	0	0.00
Slider	CMS	PK_Slider	CLUSTERED	Evet	Evet	Aktif	SliderId	15	0.14
Slip	Archive	IX_BBARS	NONCLUSTERED	Hayir	Hayir	Aktif	SlipId, CustomerId, TotalOddValue, Amount, SourceId, SlipStatu, EventCount, IsLive, IsPayOut, SlipStateId, CreateDate, SlipTypeId	0	0.00
Slip	Archive	IX_Slip	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId	0	0.00
Slip	Archive	IX_Slip_1	NONCLUSTERED	Hayir	Hayir	Aktif	SlipStateId, CreateDate, CustomerId, SourceId, SlipStatu	0	0.00
Slip	Archive	IX_Slip_3	NONCLUSTERED COLUMNSTORE	Hayir	Hayir	Aktif	SlipTypeId, CustomerId	0	0.20
Slip	Archive	IX_Slip_5	NONCLUSTERED	Hayir	Hayir	Aktif	SlipId, SlipTypeId, IsPayOut	0	0.00
Slip	Archive	PK_Slip_1	CLUSTERED	Evet	Evet	Aktif	SlipId	0	0.00
Slip	Customer	IX_Slip_1	NONCLUSTERED	Hayir	Hayir	Aktif	SlipStateId, CreateDate, SlipStatu	0	0.00
Slip	Customer	IX_Slip_2	NONCLUSTERED	Hayir	Hayir	Aktif	SlipId, SlipStateId	0	0.00
Slip	Customer	IX_Slip_4	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId	0	0.00
Slip	Customer	IX_Slip_6	NONCLUSTERED	Hayir	Hayir	Aktif	SlipId, SlipTypeId, IsPayOut	0	0.00
Slip	Customer	IX_Slip_7	NONCLUSTERED	Hayir	Hayir	Aktif	SlipId, SlipTypeId, SlipStateId	0	0.00
Slip	Customer	PK_Slip	CLUSTERED	Evet	Evet	Aktif	SlipId	0	0.00
Slip	Stadium	PK_Slip	CLUSTERED	Evet	Evet	Aktif	SlipId	28	0.07
SlipActionType	Parameter	PK_SlipActionType	CLUSTERED	Evet	Evet	Aktif	ActionTypeId	2	0.02
SlipCashOut	Archive	PK_SlipCashOut_1	CLUSTERED	Evet	Evet	Aktif	SlipCashoutId	0	0.00
SlipCashOut	Customer	IX_SlipCashOut	NONCLUSTERED	Hayir	Evet	Aktif	SlipId	0	0.00
SlipCashOut	Customer	PK_SlipCashOut	CLUSTERED	Evet	Evet	Aktif	SlipCashoutId	0	0.00
SlipCashoutHistory	Customer	PK_SlipCashoutHistory	CLUSTERED	Evet	Evet	Aktif	HistoryId	433645	34.82
SlipHistory	Customer	PK_SlipHistory	CLUSTERED	Evet	Evet	Aktif	SlipHistoryId	0	0.00
SlipManuelEvo	RiskManagement	PK_SlipManuelEvo	CLUSTERED	Evet	Evet	Aktif	SlipEvoId	0	0.13
SlipOdd	Archive	<Name of Missing Index, sysname,>	NONCLUSTERED	Hayir	Hayir	Aktif	SlipId, MatchId	0	0.00
SlipOdd	Archive	IX_SlipOdd_3	NONCLUSTERED	Hayir	Hayir	Aktif	SlipId, BetTypeId	0	0.00
SlipOdd	Archive	PK_SlipOdd_1	CLUSTERED	Evet	Evet	Aktif	SlipOddId, SlipId	0	0.00
SlipOdd	Customer	IX_CS5	NONCLUSTERED	Hayir	Hayir	Aktif	SlipId, MatchId, BetTypeId	0	0.00
SlipOdd	Customer	IX_SlipOdd	NONCLUSTERED	Hayir	Hayir	Aktif	OddId, BetTypeId	0	0.00
SlipOdd	Customer	IX_SlipOdd_1	NONCLUSTERED	Hayir	Evet	Aktif	SlipOddId, SlipId, MatchId	0	0.00
SlipOdd	Customer	IX_SlipOdd_2	NONCLUSTERED	Hayir	Hayir	Aktif	SlipId, BetTypeId	0	0.00
SlipOdd	Customer	IX_SlipOdd_4	NONCLUSTERED	Hayir	Hayir	Aktif	SlipId, StateId	0	0.00
SlipOdd	Customer	IX_SlipOdd_5	NONCLUSTERED	Hayir	Hayir	Aktif	SlipId	0	0.00
SlipOdd	Customer	IX_SlipOdd_6	NONCLUSTERED	Hayir	Hayir	Aktif	OddsTypeId, MatchId, BetTypeId, StateId	0	0.00
SlipOdd	Customer	IX_SlipOdd_7	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId	0	0.00
SlipOdd	Customer	IX_SlipOdd_8	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarMatchId, BetTypeId	0	0.00
SlipOdd	Customer	PK_SlipOdd	CLUSTERED	Evet	Evet	Aktif	SlipOddId	0	0.00
SlipOdd	Stadium	PK_SlipOdd	CLUSTERED	Evet	Evet	Aktif	SlipOddId	29	0.07
SlipOddCancel	Customer	PK_SlipOddCancel	CLUSTERED	Evet	Evet	Aktif	SlipOddCancelId	0	0.00
SlipOddHistory	Customer	NULL	HEAP	Hayir	Hayir	Aktif	NULL	0	0.00
SlipOddOld	Archive	IX_SlipOddOld	NONCLUSTERED	Hayir	Hayir	Aktif	SlipId, BetTypeId	0	0.00
SlipOddOld	Archive	PK_SlipOddOld_1	CLUSTERED	Evet	Evet	Aktif	SlipOddId	0	0.00
SlipOddTemp	Customer	PK_SlipOddTemp	CLUSTERED	Evet	Evet	Aktif	SlipOddId	1825	0.62
SlipOld	Archive	IX_SlipOld	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId	0	0.00
SlipOld	Archive	IX_SlipOld_1	NONCLUSTERED	Hayir	Hayir	Aktif	SlipId, SlipTypeId, IsPayOut	0	0.00
SlipOld	Archive	IX_SlipOld_2	NONCLUSTERED	Hayir	Hayir	Aktif	SlipTypeId, SlipStatu	0	0.00
SlipOld	Archive	PK_SlipOld_1	CLUSTERED	Evet	Evet	Aktif	SlipId	0	0.00
SlipPassword	Archive	PK_SlipPassword	CLUSTERED	Evet	Evet	Aktif	SlipPasswordId	0	0.00
SlipPassword	Customer	IX_SlipPassword	NONCLUSTERED	Hayir	Hayir	Aktif	SlipId, Password	0	0.00
SlipPassword	Customer	IX_SlipPassword_1	NONCLUSTERED	Hayir	Hayir	Aktif	SlipId, TryCount	0	0.13
SlipPassword	Customer	PK_SlipPassword	CLUSTERED	Evet	Evet	Aktif	SlipPasswordId	0	0.00
SlipPasswords	Parameter	NULL	HEAP	Hayir	Hayir	Aktif	NULL	17	0.07
SlipState	Parameter	PK_SlipState	CLUSTERED	Evet	Evet	Aktif	StateId	7	0.02
SlipStatu	Parameter	PK_SlipStatu	CLUSTERED	Evet	Evet	Aktif	SlipStatuId	4	0.02
SlipSystem	Archive	PK_SystemSlip	CLUSTERED	Evet	Evet	Aktif	SystemSlipId	0	0.00
SlipSystem	Customer	IX_BBB	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId, SlipStateId, SlipTypeId, SourceId, SlipStatuId, CreateDate, NewSlipTypeId	0	0.00
SlipSystem	Customer	IX_BBCS	NONCLUSTERED	Hayir	Hayir	Aktif	SystemSlipId, CustomerId, EvaluateDate, SlipStateId, IsPayOut	0	0.00
SlipSystem	Customer	IX_CSSSN	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId, MaxGain, Amount, CreateDate, SourceId, SlipStateId, SlipStatuId, NewSlipTypeId	0	0.00
SlipSystem	Customer	IX_SlipSystem	NONCLUSTERED	Hayir	Hayir	Aktif	SystemSlipId, IsPayOut	0	0.00
SlipSystem	Customer	IX_SlipSystem_1	NONCLUSTERED	Hayir	Hayir	Aktif	NewSlipTypeId	0	0.00
SlipSystem	Customer	IX_SlipSystem_2	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId, NewSlipTypeId, SlipStateId	0	0.13
SlipSystem	Customer	PK_SystemSlip	CLUSTERED	Evet	Evet	Aktif	SystemSlipId	0	0.00
SlipSystemSlip	Archive	IX_ARSL	NONCLUSTERED	Hayir	Hayir	Aktif	SlipId	0	0.00
SlipSystemSlip	Archive	PK_SlipSystemSlip	CLUSTERED	Evet	Evet	Aktif	SlipSystemSlip	0	0.00
SlipSystemSlip	Customer	IX_SlipSystemSlip	NONCLUSTERED	Hayir	Evet	Aktif	SlipId	0	0.00
SlipSystemSlip	Customer	IX_SlipSystemSlip_1	NONCLUSTERED	Hayir	Hayir	Aktif	SystemSlipId	0	0.00
SlipSystemSlip	Customer	PK_SlipSystemSlip	CLUSTERED	Evet	Evet	Aktif	SlipSystemSlip	0	0.00
SlipSystemSlipTemp	Customer	PK_SlipSystemSlipTemp	CLUSTERED	Evet	Evet	Aktif	SlipSystemSlip	0	0.07
SlipSystemTemp	Customer	PK_SystemSlipTemp	CLUSTERED	Evet	Evet	Aktif	SystemSlipId	0	0.07
SlipTemp	Customer	PK_SlipTemp	CLUSTERED	Evet	Evet	Aktif	SlipId	0	0.07
SlipType	Parameter	PK_SlipType	CLUSTERED	Evet	Evet	Aktif	Id	6	0.02
Source	Parameter	PK_Source	CLUSTERED	Evet	Evet	Aktif	SourceId	5	0.02
SpDescription	Log	PK_SpDescription	CLUSTERED	Evet	Evet	Aktif	SpDescriptionId	41	0.02
Spinmatic.Game	Casino	NULL	HEAP	Hayir	Hayir	Aktif	NULL	8	0.02
Spinmatic.Player	Casino	NULL	HEAP	Hayir	Hayir	Aktif	NULL	2	0.02
Spinmatic.Transaction	Casino	PK_Spinmatic.Transaction	CLUSTERED	Evet	Evet	Aktif	TransactionId	555	0.21
spintest	dbo	NULL	HEAP	Hayir	Hayir	Aktif	NULL	17	0.07
Sport	Cache	PK_Sport_1	CLUSTERED	Evet	Evet	Aktif	CacheSportId, EndDay	0	0.00
Sport	Parameter	PK_Sport	CLUSTERED	Evet	Evet	Aktif	SportId, BetRadarSportId	113	0.07
Sports	Stadium	PK_StadiumSports	CLUSTERED	Evet	Evet	Aktif	StadiumSportId	144	0.07
Stadium	Stadium	NULL	HEAP	Hayir	Hayir	Aktif	NULL	83	0.14
StakeLimit	Customer	IX_StakeLimit	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId	0	0.00
StakeLimit	Customer	IX_StakeLimit_1	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId, UpdateUser	0	0.00
StakeLimit	Customer	PK_StakeLimit	CLUSTERED	Evet	Evet	Aktif	CustomerStakeId	0	0.00
Standings	Match	IX_Standings	NONCLUSTERED	Hayir	Hayir	Aktif	TournamentId, TeamId, Name	27516	5.48
Standings	Match	PK_Standings	CLUSTERED	Evet	Evet	Aktif	Id	27516	11.80
Status	Customer	IX_Status	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId, StatusId	53881	3.86
Status	Customer	PK_Status	CLUSTERED	Evet	Evet	Aktif	CustomerStatusId	53881	3.16
Status	Parameter	PK_Status_1	CLUSTERED	Evet	Evet	Aktif	StatusId	0	0.00
StatusInfo	Parameter	PK_StatusInfo	CLUSTERED	Evet	Evet	Aktif	StatusInfoId	2	0.02
SummaryBonusSportBetting	Report	PK_SummaryBonusSportBetting	CLUSTERED	Evet	Evet	Aktif	SummaryBonusSportBettingId	32	0.02
SummaryCash	Report	IX_SummaryCash	NONCLUSTERED	Hayir	Hayir	Aktif	ReportDate, TransactionTypeId	2574937	82.45
SummaryCash	Report	PK_SummaryCash	CLUSTERED	Evet	Evet	Aktif	SummaryCashId	2574937	140.23
SummaryCasinoBetting	Archive	PK_SummaryCasinoBetting	CLUSTERED	Evet	Evet	Aktif	SummaryCasinoBettingId	0	0.00
SummaryCasinoBetting	Report	PK_SummaryCasinoBetting	CLUSTERED	Evet	Evet	Aktif	SummaryCasinoBettingId	0	0.00
SummaryCasinoBetting2	Report	PK_SummaryCasinoBetting2	CLUSTERED	Evet	Evet	Aktif	SummaryCasinoBettingId	1978	0.69
SummaryCasinoBettingCreate	Report	PK_SummaryCasinoBettingCreate	CLUSTERED	Evet	Evet	Aktif	ID	1	0.07
SummarySportBetting	Archive	PK_SummarySportBetting	CLUSTERED	Evet	Evet	Aktif	SummarySportBettingId	0	0.00
SummarySportBetting	Report	IX_BBR	NONCLUSTERED	Hayir	Hayir	Aktif	SlipCount, OrgSlipAmount, BranchId, ReportDate, Isview	0	0.00
SummarySportBetting	Report	IX_BBRP	NONCLUSTERED	Hayir	Hayir	Aktif	WonSlipCount, OrgWonSlipAmount, OrgWonSlipPayOut, BranchId, ReportDate, Isview	0	0.00
SummarySportBetting	Report	IX_SummarySportBetting	NONCLUSTERED	Hayir	Hayir	Aktif	ReportDate	0	0.00
SummarySportBetting	Report	IX_SummarySportBetting_1	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId, ReportDate, Isview	0	0.00
SummarySportBetting	Report	PK_SummarySportBetting	CLUSTERED	Evet	Evet	Aktif	SummarySportBettingId	0	0.00
SummarySportBetting2	Report	IX_SummarySportBetting2	NONCLUSTERED	Hayir	Hayir	Aktif	ReportDate	1088926	30.63
SummarySportBetting2	Report	PK_SummarySportBetting2	CLUSTERED	Evet	Evet	Aktif	SummarySportBettingId	1088926	278.76
SummarySportBettingCreate	Report	PK_SummarySportBettingCreate	CLUSTERED	Evet	Evet	Aktif	ID	1	0.07
SummaryTax	Report	PK_SummaryTax	CLUSTERED	Evet	Evet	Aktif	ReportTaxId	0	0.00
SummaryVirtualBetting	Report	PK_SummaryVirtualBetting	CLUSTERED	Evet	Evet	Aktif	SummaryVirtualBettingId	1214	0.48
SummaryVirtualBetting2	Report	PK_SummaryVirtualBetting2	CLUSTERED	Evet	Evet	Aktif	SummaryVirtualBettingId	1980	0.61
SwCode	Parameter	IX_SwCode	NONCLUSTERED	Hayir	Hayir	Aktif	SCCode	36	0.07
SwCode	Parameter	PK_SwCode	CLUSTERED	Evet	Evet	Aktif	SWCodeId	36	0.07
SwissSoft.Customer	Casino	PK_SwissSoft.Customer	CLUSTERED	Evet	Evet	Aktif	SwisssoftCustomerId	71	0.02
SwissSoft.CustomerTransaction	Casino	PK_SwissSoft.CustomerTransaction	CLUSTERED	Evet	Evet	Aktif	SwissSoftTransactionId	113059	14.20
SwissSoft.GameList	Casino	NULL	HEAP	Hayir	Hayir	Aktif	NULL	141	0.04
Tax	Archive	NULL	HEAP	Hayir	Hayir	Aktif	NULL	0	0.00
Tax	Customer	IX_Tax	NONCLUSTERED	Hayir	Evet	Aktif	SlipId, SlipTypeId	0	0.00
Tax	Customer	IX_Tax_1	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId, SlipAmount, CreateDate, TaxStatusId	0	0.00
Tax	Customer	IX_Tax_2	NONCLUSTERED	Hayir	Hayir	Aktif	SlipId	0	0.00
Tax	Customer	PK_Tax	CLUSTERED	Evet	Evet	Aktif	TaxId	0	0.00
TaxCountry	Parameter	IX_TaxCountry	NONCLUSTERED	Hayir	Evet	Aktif	CountryId	237	0.07
TaxCountry	Parameter	PK_TaxCountry	CLUSTERED	Evet	Evet	Aktif	CountryTaxId	237	0.09
TaxStatus	Parameter	PK_TaxStatus	CLUSTERED	Evet	Evet	Aktif	TaxStatusId	3	0.02
TaxTest	dbo	NULL	HEAP	Hayir	Hayir	Aktif	NULL	2314	0.14
Team	Virtual	PK_Team	CLUSTERED	Evet	Evet	Aktif	TeamId	64	0.02
TeamPlayer	Parameter	IX_TeamPlayer	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarPlayerId	200243	4.17
TeamPlayer	Parameter	IX_TeamPlayer_1	NONCLUSTERED	Hayir	Hayir	Aktif	CompetitorId	200243	4.23
TeamPlayer	Parameter	PK_TeamPlayer	CLUSTERED	Evet	Evet	Aktif	TeamPlayerId	200243	13.20
tempLiveEvent	dbo	NULL	HEAP	Hayir	Hayir	Aktif	NULL	49	0.07
tempodd	dbo	NULL	HEAP	Hayir	Hayir	Aktif	NULL	1273	0.06
temptabl	dbo	NULL	HEAP	Hayir	Hayir	Aktif	NULL	37893	3.23
TerminalCloseBoxReport	RiskManagement	PK_TerminalCloseBoxReport	CLUSTERED	Evet	Evet	Aktif	TerminalCloseBoxId	709814	138.37
testslip	dbo	NULL	HEAP	Hayir	Hayir	Aktif	NULL	1181379	80.12
Ticket	MTS	PK_Ticket	CLUSTERED	Evet	Evet	Aktif	TicketId	0	0.00
Ticket	RiskManagement	PK_Ticket_1	CLUSTERED	Evet	Evet	Aktif	TicketId	4831	2.72
TicketAnswers	RiskManagement	PK_TicketAnswers	CLUSTERED	Evet	Evet	Aktif	TicketAnswerId	15591	5.68
TicketStatus	Parameter	PK_TicketStatus	CLUSTERED	Evet	Evet	Aktif	TicketStatusId	2	0.02
TimeRange	CMS	PK_TimeRange	CLUSTERED	Evet	Evet	Aktif	TimeRangeId	3	0.02
TimeZone	Parameter	PK_TimeZone	CLUSTERED	Evet	Evet	Aktif	TimeZoneId	47	0.02
Title	CMS	PK_Title	CLUSTERED	Evet	Evet	Aktif	TitleId	0	0.02
Tournament	Cache	IX_Tournament_CategoryEndDay	NONCLUSTERED	Hayir	Hayir	Aktif	CategoryId, EndDay	0	0.00
Tournament	Cache	PK_Tournament_1	CLUSTERED	Evet	Evet	Aktif	CacheTournamentId	0	0.00
Tournament	Parameter	IX_BBPT	NONCLUSTERED	Hayir	Hayir	Aktif	NewBetradarId	35944	1.77
Tournament	Parameter	IX_Tournament	NONCLUSTERED	Hayir	Evet	Aktif	TournamentId, CategoryId, IsPopularTerminal	35944	2.02
Tournament	Parameter	IX_Tournament_1	NONCLUSTERED	Hayir	Hayir	Aktif	TerminalTournamentId	35944	1.83
Tournament	Parameter	IX_Tournamentt	NONCLUSTERED	Hayir	Hayir	Aktif	TournamentId, SequenceNumber, CategoryId	35944	1.77
Tournament	Parameter	PK_Tournament	CLUSTERED	Evet	Evet	Aktif	TournamentId, BetradarTournamentId	35944	10.92
Tournament	Stadium	PK_Tournament_3	CLUSTERED	Evet	Evet	Aktif	StadiumTournamentId	144	0.07
Tournament	Virtual	PK_Tournament_2	CLUSTERED	Evet	Evet	Aktif	TournamentId	378	0.07
TournamentOutrights	Parameter	IX_BBPTO	NONCLUSTERED	Hayir	Hayir	Aktif	TournamentId, CategoryId, IsActive	29280	0.77
TournamentOutrights	Parameter	IX_TournamentOutrights	NONCLUSTERED	Hayir	Hayir	Aktif	TournamentId, BetradarTournamentId	29280	0.65
TournamentOutrights	Parameter	IX_TournamentOutrights_1	NONCLUSTERED	Hayir	Hayir	Aktif	CategoryId	29280	1.41
TournamentOutrights	Parameter	PK_TournamentOutrights	CLUSTERED	Evet	Evet	Aktif	TournamentId, BetradarTournamentId	29280	4.17
Transaction	Archive	PK_Transaction	CLUSTERED	Evet	Evet	Aktif	TransactionId, CustomerId	0	0.00
Transaction	Customer	IX_Transaction	NONCLUSTERED	Hayir	Hayir	Aktif	TransactionTypeId	0	0.00
Transaction	Customer	IX_Transaction_1	NONCLUSTERED	Hayir	Hayir	Aktif	TransactionTypeId, TransactionDate, Amount	0	0.00
Transaction	Customer	IX_Transaction_2	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId, TransactionTypeId, TransactionSourceId, TransactionComment	0	0.00
Transaction	Customer	IX_Transaction_3	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId, TransactionTypeId, TransactionDate	0	0.00
Transaction	Customer	IX_Transaction_4	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId, TransactionTypeId, TransactionComment	0	0.00
Transaction	Customer	PK_Transaction	CLUSTERED	Evet	Evet	Aktif	TransactionId, CustomerId	0	0.00
Transaction	Stadium	PK_Transaction_1	CLUSTERED	Evet	Evet	Aktif	StadiumTransactionId	0	0.00
TransactionLog	Archive	PK_TransactionLog	CLUSTERED	Evet	Evet	Aktif	TransactionLogId	19116842	7168.61
TransactionLog	Log	PK_TransactionLog	CLUSTERED	Evet	Evet	Aktif	TransactionLogId	2115418	423.80
TransactionLogHistory	Log	PK_TransactionLogHistory	CLUSTERED	Evet	Evet	Aktif	TransactionLogId	0	0.00
TransactionSource	Parameter	NULL	HEAP	Hayir	Hayir	Aktif	NULL	5	0.02
TransactionType	Log	PK_TransactionType	CLUSTERED	Evet	Evet	Aktif	TransactionTypeId	4	0.02
TransactionType	Parameter	PK_TransactionType_1	CLUSTERED	Evet	Evet	Aktif	TransactionTypeId	75	0.07
TransactionTypeBranch	Parameter	NULL	HEAP	Hayir	Hayir	Aktif	NULL	17	0.02
TransferSource	Parameter	PK_TransferSource	CLUSTERED	Evet	Evet	Aktif	TransferSourceId	2	0.02
TVChannel	Archive	NULL	HEAP	Hayir	Hayir	Aktif	NULL	365	2.63
TVChannel	Match	IX_TVChannel	NONCLUSTERED	Hayir	Hayir	Aktif	MatchId	93027	5.99
TVChannel	Match	PK_TVChannel_3	CLUSTERED	Evet	Evet	Aktif	MatchTVChannelId	93027	23.00
TVChannel	Parameter	PK_TVChannel_1	CLUSTERED	Evet	Evet	Aktif	TVChannelId	0	0.00
TVVersion	Parameter	NULL	HEAP	Hayir	Hayir	Aktif	NULL	1	0.02
UserRoles	Users	PK_UserRoles	CLUSTERED	Evet	Evet	Aktif	UserRolesId	1825	0.23
Users	Users	IX_BBUU	NONCLUSTERED	Hayir	Hayir	Aktif	UnitCode	1824	0.20
Users	Users	IX_Users	NONCLUSTERED	Hayir	Hayir	Aktif	UserName, Email, Password	1824	0.72
Users	Users	IX_Users_1	NONCLUSTERED	Hayir	Hayir	Aktif	UserName, TimeZoneId	1824	0.20
Users	Users	IX_Users_2	NONCLUSTERED	Hayir	Hayir	Aktif	UserId, IsLockedOut	1824	0.20
Users	Users	PK_Users	CLUSTERED	Evet	Evet	Aktif	UserId	1824	1.69
ValidatorTransaction	Retail	PK_ValidatorTransaction	CLUSTERED	Evet	Evet	Aktif	TransactionId	0	0.00
Venue	Parameter	IX_Venue	NONCLUSTERED	Hayir	Hayir	Aktif	BetradarVenueId	11858	0.52
Venue	Parameter	PK_Venue	CLUSTERED	Evet	Evet	Aktif	VenueId	11858	2.24
VFLReport	Report	NULL	HEAP	Hayir	Hayir	Aktif	NULL	1803	0.21
VirtualReportTemp	Report	NULL	HEAP	Hayir	Hayir	Aktif	NULL	0	0.00
WithDrawRequest	Customer	IX_WithDrawRequest	NONCLUSTERED	Hayir	Evet	Aktif	CustomerId, TransactionTypeId	77	0.07
WithDrawRequest	Customer	PK_WithDrawRequest_1	CLUSTERED	Evet	Evet	Aktif	CustomerWithdrawId	77	0.07
WithdrawRequest	RiskManagement	IX_WithdrawRequest_1	NONCLUSTERED	Hayir	Hayir	Aktif	CustomerId, TransactionType, CurrencyId, BankId	4657	0.40
WithdrawRequest	RiskManagement	IX_WithdrawRequest_2	NONCLUSTERED	Hayir	Hayir	Aktif	WithdrawRequestId, IsApproved	4657	0.20
WithdrawRequest	RiskManagement	PK_WithdrawRequest	CLUSTERED	Evet	Evet	Aktif	WithdrawRequestId	4657	2.93
WithdrawRequestAuto	RiskManagement	PK_WithdrawRequestAuto	CLUSTERED	Evet	Evet	Aktif	WithdrawRequestId	144	0.07
XProGaming.Transaction	Casino	PK_XProGaming.Transaction	CLUSTERED	Evet	Evet	Aktif	TransactionId	6	0.07
XprressGaming.Game	Casino	PK_XprressGaming.Game	CLUSTERED	Evet	Evet	Aktif	Id	348	0.13
XprressGaming.Player	Casino	PK_XprressGaming.Player	CLUSTERED	Evet	Evet	Aktif	Id	38	0.02
XprressGaming.Transaction	Casino	PK_XprressGaming.Transaction	CLUSTERED	Evet	Evet	Aktif	TransactionId	6853	1.00
ZipCode	Parameter	PK_ZipCode	CLUSTERED	Evet	Evet	Aktif	ZipCodeId	11538	1.13