
-- 通过cocos2dx的class生成的类 放在此处
local VIEW_LOGIC_TABLE = {
	LevelViewLogic              = "ViewLogic/Common/LevelViewLogic",
	Level2XYViewLogic           = "ViewLogic/Common/Level2XYViewLogic",
	Level2YViewLogic            = "ViewLogic/Common/Level2YViewLogic",
	Level2NAViewLogic           = "ViewLogic/Common/Level2NAViewLogic",

	CommonDialogViewLogic       = "ViewLogic/Common/CommonDialogViewLogic",
	TipsNodeLogic               = "ViewLogic/Common/TipsNodeLogic",
	CommonCostDialog            = "ViewLogic/Common/CommonCostDialog",
	CommonRewardDialog          = "ViewLogic/Common/CommonRewardDialog",
	CommonRewardTips		 	= "ViewLogic/Common/CommonRewardTips",
	CommonItemDesTips           = "ViewLogic/Common/CommonItemDesTips",
	CommonOverviewLogic         = "ViewLogic/Common/CommonOverviewLogic",
	CommonOverviewNode          = "ViewLogic/Common/CommonOverviewNode",
	CommonRewardPreviewViewLogic          = "ViewLogic/Common/CommonRewardPreviewViewLogic",

	ResourceSeekViewLogic       = "ViewLogic/Common/ResourceSeekViewLogic",
	ItemNodeBaseLogic           = "ViewLogic/Common/ItemNodeBaseLogic",
	ItemNode                    = "ViewLogic/Common/ItemNode",
	BigItemNode                 = "ViewLogic/Common/BigItemNode",
	BigItemNodeEx               = "ViewLogic/Common/BigItemNodeEx",
	BigItemCostNode             = "ViewLogic/Common/BigItemCostNode",
	RuneItemNode                = "ViewLogic/Common/RuneItemNode",
	WebViewLogic                = "ViewLogic/Common/WebViewLogic",
	OffLineDropLogic            = "ViewLogic/Common/OffLineDropLogic",
	HelpViewLogic		 		= "ViewLogic/Common/HelpViewLogic",
	CountUpNode                 = "ViewLogic/Common/CountUpNode",
	CommonFormationBtnList      = "ViewLogic/Common/CommonFormationBtnList",

	RoleAnimNode                = "ViewLogic/Entity/RoleAnimNode",
	BattleRoleAnimNode          = "ViewLogic/Entity/BattleRoleAnimNode",
	BattleRoleBuffNode          = "ViewLogic/Entity/BattleRoleBuffNode",
	BattleRoleTreasureNode      = "ViewLogic/Entity/BattleRoleTreasureNode",
	UIRoleAnimNode          	= "ViewLogic/Entity/UIRoleAnimNode",
	UIRoleIconNode          	= "ViewLogic/Entity/UIRoleIconNode",
	UIRoleDeveloperIconNode     = "ViewLogic/Entity/UIRoleDeveloperIconNode",
	UIRoleHandBookIconNode      = "ViewLogic/Entity/UIRoleHandBookIconNode",
	UIRoleTransformIconNode     = "ViewLogic/Entity/UIRoleTransformIconNode",
	HeroTransformIcon     		= "ViewLogic/Entity/HeroTransformIcon",
	AdventureIdleHeroAnimNode   = "ViewLogic/Entity/AdventureIdleHeroAnimNode",
	AdventureIdleMonsterAnimNode   = "ViewLogic/Entity/AdventureIdleMonsterAnimNode",
	MainViewRoleAnimNode          	= "ViewLogic/Entity/MainViewRoleAnimNode",

	SettingHeadViewLogic          	= "ViewLogic/Setting/SettingHeadViewLogic",
	SettingHeadFrameNode          	= "ViewLogic/Setting/SettingHeadFrameNode",


	NoviceGuideViewLogic        = "ViewLogic/NoviceGuide/NoviceGuideViewLogic",
	NoviceGuideHeadLogic        = "ViewLogic/NoviceGuide/NoviceGuideHeadLogic",
	NoviceGuideTalkLogic        = "ViewLogic/NoviceGuide/NoviceGuideTalkLogic",
	NoviceGuideFingerLogic      = "ViewLogic/NoviceGuide/NoviceGuideFingerLogic",
	
	BattleUIViewLogic           = "ViewLogic/Battle/BattleUIViewLogic",
	BattleViewLogic             = "ViewLogic/Battle/BattleViewLogic",
	BattleResultViewLogic       = "ViewLogic/Battle/BattleResultViewLogic",
	BattleChallengeResultLogic  = "ViewLogic/Battle/BattleChallengeResultLogic",
	BattleExpeditionResultLogic = "ViewLogic/Battle/BattleExpeditionResultLogic",
	BattleGBTResultLogic        = "ViewLogic/Battle/BattleGBTResultLogic",
	BattleStartViewLogic        = "ViewLogic/Battle/BattleStartViewLogic",
	CombinationSkillSpine		= "ViewLogic/Battle/CombinationSkillSpine",

	BattleKrFrontSpine			= "ViewLogic/Battle/BattleKrFrontSpine",
	BattleKrFrontViewLogic		= "ViewLogic/Battle/BattleKrFrontViewLogic",

	BattleEventBaseLogic		= "ViewLogic/BattleEvent/BattleEventBaseLogic",
	AdventureEventViewLogic 	= "ViewLogic/BattleEvent/AdventureEventViewLogic",
	MineEventViewLogic			= "ViewLogic/BattleEvent/MineEventViewLogic",
	BattleEventDetailViewLogic	= "ViewLogic/BattleEvent/BattleEventDetailViewLogic",
	CampaignEventViewLogic		= "ViewLogic/BattleEvent/CampaignEventViewLogic",
	WorldBossEventViewLogic		= "ViewLogic/BattleEvent/WorldBossEventViewLogic",
	RebirthBossEventViewLogic	= "ViewLogic/BattleEvent/RebirthBossEventViewLogic",
	GuildBossEventViewLogic		= "ViewLogic/BattleEvent/GuildBossEventViewLogic",
	AdventureEliteChallengeEventView = "ViewLogic/BattleEvent/AdventureEliteChallengeEventView",

	LoginViewLogic              = "ViewLogic/Login/LoginViewLogic",
	AccountViewLogic            = "ViewLogic/Login/AccountViewLogic",
	
	MainViewLogic          		= "ViewLogic/MainView/MainViewLogic",
	MainViewMoveLogic           = "ViewLogic/MainView/MainViewMoveLogic",
	MainViewMoveLogicKr         = "ViewLogic/MainView/MainViewMoveLogicKr",
	MainViewRoleLogic           = "ViewLogic/MainView/MainViewRoleLogic",
	MainViewSpineLogic          = "ViewLogic/MainView/MainViewSpineLogic",
	MainViewUIBtnLogic    		= "ViewLogic/MainView/MainViewUIBtnLogic",
	MainMenuViewLogic           = "ViewLogic/MainView/MainMenuViewLogic",
	AdventureViewLogic          = "ViewLogic/MainView/AdventureViewLogic",
	AdventureBottomViewLogic    = "ViewLogic/MainView/AdventureBottomViewLogic",
	MercenaryViewLogic          = "ViewLogic/MainView/MercenaryViewLogic",
	MercenaryNode    	        = "ViewLogic/MainView/MercenaryNode",
	MainArrowViewLogic			= "ViewLogic/MainView/MainArrowViewLogic",
	MainViewKRAchiveLogic		= "ViewLogic/MainView/MainViewKRAchiveLogic",

	ChatViewHelper              = "ViewLogic/Chat/ChatViewHelper",
	ChatRollingHelper           = "ViewLogic/Chat/ChatRollingHelper",
	ChatNode                    = "ViewLogic/Chat/ChatNode",
	ChatCommonBubbleNode        = "ViewLogic/Chat/ChatCommonBubbleNode",
	ChatViewLogic        		= "ViewLogic/Chat/ChatViewLogic",
	ChatBlackListViewLogic      = "ViewLogic/Chat/ChatBlackListViewLogic",
	-- ChatPersonNode              = "ViewLogic/Chat/ChatPersonNode",
	PlayerInfoViewLogic         = "ViewLogic/Chat/PlayerInfoViewLogic",
	PlayerFormationViewLogic    = "ViewLogic/Chat/PlayerFormationViewLogic",
	PlayerFormationSoulStoneNode = "ViewLogic/Chat/PlayerFormationSoulStoneNode", -- 玩家阵容中的节点

	MonthCardViewLogic          = "ViewLogic/MainView/MonthCardViewLogic",
	RoleSettingViewLogic		= "ViewLogic/Setting/RoleSettingViewLogic",
	StrategyViewLogic           = "ViewLogic/Setting/StrategyViewLogic",
	PersonalSettingViewLogic    = "ViewLogic/Setting/PersonalSettingViewLogic",
	AccountSettingViewLogic     = "ViewLogic/Setting/AccountSettingViewLogic",
	DeveloperListViewLogic      = "ViewLogic/Setting/DeveloperListViewLogic",
	RemindViewLogic             = "ViewLogic/Setting/RemindViewLogic",
	RemindNode                  = "ViewLogic/Setting/RemindNode",
	IdentityBindingViewLogic    = "ViewLogic/Setting/IdentityBindingViewLogic",
	SettingContactCerviceKRViewLogic    = "ViewLogic/Setting/SettingContactCerviceKRViewLogic",
	SettingResourcesDetailViewLogic = "ViewLogic/Setting/SettingResourcesDetailViewLogic",

	SettingChatBubbleViewLogic = "ViewLogic/Setting/SettingChatBubbleViewLogic",
	SettingChatDubbleNode = "ViewLogic/Setting/SettingChatDubbleNode",
	SellFrameItemViewLogic = "ViewLogic/Setting/SellFrameItemViewLogic",

	AwardCenterViewLogic        = "ViewLogic/AwardCenter/AwardCenterViewLogic",
	AwardCenterNodeLogic        = "ViewLogic/AwardCenter/AwardCenterNodeLogic",


	AdventureQuickBattleLogic   = "ViewLogic/AdventureView/AdventureQuickBattleLogic",
	AdventureExploreReward      = "ViewLogic/AdventureView/AdventureExploreReward",
	AdventureQuickDropLogic     = "ViewLogic/AdventureView/AdventureQuickDropLogic",
	AdventureSpecialDropLogic   = "ViewLogic/AdventureView/AdventureSpecialDropLogic",
	AdventureExploreRewardPrev = "ViewLogic/AdventureView/AdventureExploreRewardPrev",
	AdventureChallengeViewLogic = "ViewLogic/AdventureView/AdventureChallengeViewLogic",
	AdventureChallengeNode = "ViewLogic/AdventureView/AdventureChallengeNode",
	AdventureChallengeRewardTips = "ViewLogic/AdventureView/AdventureChallengeRewardTips",


	HeroCoopSkillHelper   = "ViewLogic/HerosDeveloper/HeroCoopSkillHelper",
	HerosDeveloperViewLogic   = "ViewLogic/HerosDeveloper/HerosDeveloperViewLogic",
	HerosDeveloperHeroNodeHelper   = "ViewLogic/HerosDeveloper/HerosDeveloperHeroNodeHelper",
	HerosDeveloperStrengthenHelper   = "ViewLogic/HerosDeveloper/HerosDeveloperStrengthenHelper",
	HerosDeveloperAdvanceHelper   = "ViewLogic/HerosDeveloper/HerosDeveloperAdvanceHelper",
	HerosDeveloperTreasureHelper   = "ViewLogic/HerosDeveloper/HerosDeveloperTreasureHelper",
	HerosDeveloperEquipHelper   = "ViewLogic/HerosDeveloper/HerosDeveloperEquipHelper",
	HerosDeveloperRuneHelper   = "ViewLogic/HerosDeveloper/HerosDeveloperRuneHelper",
	HerosDeveloperSoulStoneHelper   = "ViewLogic/HerosDeveloper/HerosDeveloperSoulStoneHelper",

	
	
	AdventureIdleNodeLogic   = "ViewLogic/AdventureIdle/AdventureIdleNodeLogic",
	AdventureIdleBGHelper   = "ViewLogic/AdventureIdle/AdventureIdleBGHelper",
	AdventureIdleRoleHelper   = "ViewLogic/AdventureIdle/AdventureIdleRoleHelper",
	AdventureIdleBladeHelper   = "ViewLogic/AdventureIdle/AdventureIdleBladeHelper",
	AdventureIdleDropHelper   = "ViewLogic/AdventureIdle/AdventureIdleDropHelper",

    ChallengeViewLogic          = "ViewLogic/ChallengeView/ChallengeViewLogic",
    ChallengeNode               = "ViewLogic/ChallengeView/ChallengeNode",
    ChallengeLevelDetailViewLogic = "ViewLogic/ChallengeView/ChallengeLevelDetailViewLogic",
    ChallengeBuffViewLogic      = "ViewLogic/ChallengeView/ChallengeBuffViewLogic",
    ChallengeBuffNode           = "ViewLogic/ChallengeView/ChallengeBuffNode",
    ChallengeRushViewLogic      = "ViewLogic/ChallengeView/ChallengeRushViewLogic",
    ChallengeRushNode           = "ViewLogic/ChallengeView/ChallengeRushNode",

	BlockItemBase               = "ViewLogic/Mine/Block/BlockItemBase",
	BlockItem                   = "ViewLogic/Mine/Block/BlockItem",
	RichMineItem                = "ViewLogic/Mine/Block/RichMineItem",
	DigAnim                     = "ViewLogic/Mine/Block/DigAnim",

	MineCollectAnim             = "ViewLogic/Mine/Block/MineCollectAnim",
	BlockLogic                  = "ViewLogic/Mine/Block/BlockLogic",
	BlockThumbnailItem          = "ViewLogic/Mine/Block/BlockThumbnailItem",

	MineRoleEffect		        = "ViewLogic/Mine/Block/MineRoleEffect",

	MineViewLogic               = "ViewLogic/Mine/MineViewLogic",
	MineHudViewLogic            = "ViewLogic/Mine/MineHudViewLogic",
	MineRefreshBossNode         = "ViewLogic/Mine/MineRefreshBossNode",
	MineRefreshBossViewLogic    = "ViewLogic/Mine/MineRefreshBossViewLogic",
	MineThumbnailView           = "ViewLogic/Mine/MineThumbnailView",
	MineThumbnailFilterDialog   = "ViewLogic/Mine/MineThumbnailFilterDialog",
	MineRebirthBossRuleBoard    = "ViewLogic/Mine/MineRebirthBossRuleBoard",

	MineTaskViewLogic			= "ViewLogic/Mine/MineTaskViewLogic",
	MineTaskNodeLogic			= "ViewLogic/Mine/MineTaskNodeLogic",

	ProjectViewLogic            = "ViewLogic/Project/ProjectViewLogic",
	ProjectViewNode             = "ViewLogic/Project/ProjectViewNode",
	ProjectNewDialog            = "ViewLogic/Project/ProjectNewDialog",


	HerosPromotionViewLogic     = "ViewLogic/HeroBase/HerosPromotionViewLogic",
	HeroPromotionNode           = "ViewLogic/HeroBase/HeroPromotionNode",
	
	HeroWakeupViewLogic 		= "ViewLogic/HeroBase/HeroWakeupViewLogic",
	
	
	LeaderWeaponListViewLogic   = "ViewLogic/HeroBase/LeaderWeaponListViewLogic",
	LeaderWeaponListNode        = "ViewLogic/HeroBase/LeaderWeaponListNode",
	LeaderWeaponDetailViewLogic = "ViewLogic/HeroBase/LeaderWeaponDetailViewLogic",
	LeaderWeaponNode            = "ViewLogic/HeroBase/LeaderWeaponNode",
	HeroContractAnimView        = "ViewLogic/HeroBase/HeroContractAnimView",
	HeroPieceGetViewLogic       = "ViewLogic/HeroBase/HeroPieceGetViewLogic",
	HeroPieceGetNode            = "ViewLogic/HeroBase/HeroPieceGetNode",
	HeroImageViewLogic          = "ViewLogic/HeroBase/HeroImageViewLogic",
	HeroTransformViewLogic 		= "ViewLogic/HeroBase/HeroTransformViewLogic",
	HeroSelectViewLogic 		= "ViewLogic/HeroBase/HeroSelectViewLogic",


	MerFormationNode            = "ViewLogic/FormationView/MerFormationNode",
	MerFormationViewLogic       = "ViewLogic/FormationView/MerFormationViewLogic",
	MerFormationTitleHelper       = "ViewLogic/FormationView/MerFormationTitleHelper",
	MerRecommendViewLogic       = "ViewLogic/FormationView/MerRecommendViewLogic",
	MerRenameViewLogic          = "ViewLogic/FormationView/MerRenameViewLogic",
	MercenaryChooseNode         = "ViewLogic/FormationView/MercenaryChooseNode",
	MercenaryChooseViewLogic    = "ViewLogic/FormationView/MercenaryChooseViewLogic",
	MercenaryPreViewLogic       = "ViewLogic/FormationView/MercenaryPreViewLogic",
	MerFormationCoverViewLogic  = "ViewLogic/FormationView/MerFormationCoverViewLogic",
	MercenaryCoopSkillBoard     = "ViewLogic/FormationView/MercenaryCoopSkillBoard",
	MercenaryListViewLogic      = "ViewLogic/FormationView/MercenaryListViewLogic",
	MercenaryDetailViewLogic    = "ViewLogic/FormationView/MercenaryDetailViewLogic",
	MercenaryLibraryViewLogic   = "ViewLogic/FormationView/MercenaryLibraryViewLogic",
	MercenarySoulViewLogic      = "ViewLogic/FormationView/MercenarySoulViewLogic",
	MerFireResultViewLogic      = "ViewLogic/FormationView/MerFireResultViewLogic",
	BatchFilterViewLogic      = "ViewLogic/FormationView/BatchFilterViewLogic",
	MerFireResultNode           = "ViewLogic/FormationView/MerFireResultNode",
	MercenarySortViewLogicEx    = "ViewLogic/FormationView/MercenarySortViewLogicEx",
	MerSectSelectViewLogic		= "ViewLogic/FormationView/MerSectSelectViewLogic",
	MercenaryViewHelper = "ViewLogic/FormationView/MercenaryViewHelper",
	MercenaryListFireRecoverHelper = "ViewLogic/FormationView/MercenaryListFireRecoverHelper",
	RecommendFormationView      = "ViewLogic/FormationView/RecommendFormationView",
	RecommendFormationNode      = "ViewLogic/FormationView/RecommendFormationNode",
	EpicHeroNode      			= "ViewLogic/FormationView/EpicHeroNode",

	BagViewLogic                = "ViewLogic/BagView/BagViewLogic",
	BagViewItemHelper           = "ViewLogic/BagView/BagViewItemHelper",
	BagViewResHelper            = "ViewLogic/BagView/BagViewResHelper",
	BagViewOreHelper            = "ViewLogic/BagView/BagViewOreHelper",
	BagViewToolsHelper          = "ViewLogic/BagView/BagViewToolsHelper",
	BagViewHeroChipHelper       = "ViewLogic/BagView/BagViewHeroChipHelper",
	BagItemNodeView             = "ViewLogic/BagView/BagItemNodeView",
	BagNodeToolView             = "ViewLogic/BagView/BagNodeToolView",
	BagOreNodeView              = "ViewLogic/BagView/BagOreNodeView",
	BagMineViewLogic            = "ViewLogic/BagView/BagMineViewLogic",
	BagStrengthUseView			= "ViewLogic/BagView/BagStrengthUseView",


	ShopViewLogic               = "ViewLogic/Shop/ShopViewLogic",
	BuyMoreViewLogic            = "ViewLogic/Shop/BuyMoreViewLogic",
	CommonShopLogic				= "ViewLogic/Shop/CommonShopLogic",
	CommonShopNode				= "ViewLogic/Shop/CommonShopNode",
	RandomShopLogic 			= "ViewLogic/Shop/RandomShopLogic",
	RandomShopNode 				= "ViewLogic/Shop/RandomShopNode",
	SellChipViewLogic 			= "ViewLogic/Shop/SellChipViewLogic",

	CaveViewLogic               = "ViewLogic/Cave/CaveViewLogic",
	CaveTitleNode               = "ViewLogic/Cave/CaveTitleNode",
	CaveLevelViewLogic          = "ViewLogic/Cave/CaveLevelViewLogic",
	CaveViewListNode            = "ViewLogic/Cave/CaveViewListNode",

	ComicInstanceViewLogic    	= "ViewLogic/ComicInstance/ComicInstanceViewLogic",
	ComicInstanceGroupViewLogic = "ViewLogic/ComicInstance/ComicInstanceGroupViewLogic",
	ComicInstanceGroupNode 		= "ViewLogic/ComicInstance/ComicInstanceGroupNode",
	ComicInstanceHeroViewLogic 	= "ViewLogic/ComicInstance/ComicInstanceHeroViewLogic",
	ComicInstanceHeroNode 		= "ViewLogic/ComicInstance/ComicInstanceHeroNode",

	KillingThousandsViewLogic   = "ViewLogic/KillingThousands/KillingThousandsViewLogic",
	KillingThousandsNode   		= "ViewLogic/KillingThousands/KillingThousandsNode",
	KillingThousandsEventViewLogic = "ViewLogic/KillingThousands/KillingThousandsEventViewLogic",

	GlobalArenaViewLogic 		= "ViewLogic/GlobalArena/GlobalArenaViewLogic",
	GlobalArenaOneNode 			= "ViewLogic/GlobalArena/GlobalArenaOneNode",
	GlobalArenaTwoNode 			= "ViewLogic/GlobalArena/GlobalArenaTwoNode",
	GlobalArenaHeadNode 		= "ViewLogic/GlobalArena/GlobalArenaHeadNode",
	GlobalArenaTimeLogic 		= "ViewLogic/GlobalArena/GlobalArenaTimeLogic",
	GlobalArenaTimeNode 		= "ViewLogic/GlobalArena/GlobalArenaTimeNode",
	GlobalArenaSupportLogic 	= "ViewLogic/GlobalArena/GlobalArenaSupportLogic",
	GlobalArenaWorshipLogic 	= "ViewLogic/GlobalArena/GlobalArenaWorshipLogic",
	GlobalArenaWinnerLogic 		= "ViewLogic/GlobalArena/GlobalArenaWinnerLogic",
	GlobalArenaWinnerNode 		= "ViewLogic/GlobalArena/GlobalArenaWinnerNode",
	GlobalArenaPalaceLogic 		= "ViewLogic/GlobalArena/GlobalArenaPalaceLogic",
	GlobalArenaPalaceNode 		= "ViewLogic/GlobalArena/GlobalArenaPalaceNode",
	GlobalArenaRewardLogic 		= "ViewLogic/GlobalArena/GlobalArenaRewardLogic",
	GlobalArenaRewardNode 		= "ViewLogic/GlobalArena/GlobalArenaRewardNode",
	GlobalArenaReportOwnLogic 	= "ViewLogic/GlobalArena/GlobalArenaReportOwnLogic",
	GlobalArenaReportOwnNode 	= "ViewLogic/GlobalArena/GlobalArenaReportOwnNode",
	GlobalArenaReportOtherLogic = "ViewLogic/GlobalArena/GlobalArenaReportOtherLogic",
	GlobalArenaReportOtherNode  = "ViewLogic/GlobalArena/GlobalArenaReportOtherNode",


	MailViewLogic  				= "ViewLogic/Mail/MailViewLogic",
	MailNode  					= "ViewLogic/Mail/MailNode",

	DailyViewLogic				= "ViewLogic/Daily/DailyViewLogic",
	DailyTaskNode               = "ViewLogic/Daily/DailyTaskNode",
	DailyGiftNode               = "ViewLogic/Daily/DailyGiftNode",
	DailyCheckInNode			= "ViewLogic/Daily/DailyCheckInNode",
	TaskViewLogic 				= "ViewLogic/Daily/TaskViewLogic",
	TaskGiftNode				= "ViewLogic/Daily/TaskGiftNode",

	CommentViewLogic			= "ViewLogic/Comment/CommentViewLogic",
	CommentInput				= "ViewLogic/Comment/CommentInput",
	CommentNode					= "ViewLogic/Comment/CommentNode",
	CreateRoleViewLogic			= "ViewLogic/Role/CreateRoleViewLogic",
	ChangeRoleModelViewLogic    = "ViewLogic/Role/ChangeRoleModelViewLogic",
	ChangeRoleModelNode         = "ViewLogic/Role/ChangeRoleModelNode",
	ChangeRoleNameViewLogic     = "ViewLogic/Role/ChangeRoleNameViewLogic",
	ChangePedestalViewLogic		= "ViewLogic/Role/ChangePedestalViewLogic",
	ChangePedestalNode			= "ViewLogic/Role/ChangePedestalNode",

	ItemSelectBag				= "ViewLogic/Common/ItemSelectBag",
	ItemSelectMultiBag			= "ViewLogic/Common/ItemSelectMultiBag",
	ItemSelectNode				= "ViewLogic/Common/ItemSelectNode",
	GameEvaluationViewLogic		= "ViewLogic/Common/GameEvaluationViewLogic",
	ADViewLogic					= "ViewLogic/Common/ADViewLogic",
	CommonAutoBuyViewLogic 		= "ViewLogic/Common/CommonAutoBuyViewLogic",

	FriendViewLogic				= "ViewLogic/Friend/FriendViewLogic",
	FriendNode					= "ViewLogic/Friend/FriendNode",
	FriendNotice				= "ViewLogic/Friend/FriendNotice",
	FriendNoticeNode			= "ViewLogic/Friend/FriendNoticeNode",

	GoldSupplyViewLogic			= "ViewLogic/Supply/GoldSupplyViewLogic",
	GoldSupplyDigInfoViewLogic	= "ViewLogic/Supply/GoldSupplyDigInfoViewLogic",
	GoldStrongSupplyViewLogic	= "ViewLogic/Supply/GoldStrongSupplyViewLogic",
	GoldSupplyNode				= "ViewLogic/Supply/GoldSupplyNode",
	GoldSupplyLogNode			= "ViewLogic/Supply/GoldSupplyLogNode",

	DreamLandViewLogic			= "ViewLogic/DreamLand/DreamLandViewLogic",
	DreamEventNode				= "ViewLogic/DreamLand/DreamEventNode",
	EventAnimHelper				= "ViewLogic/DreamLand/EventAnimHelper",
	DreamMapLogic				= "ViewLogic/DreamLand/DreamMapLogic",
	DreamMonster				= "ViewLogic/DreamLand/DreamMonster",
	DreamLandEndDialog			= "ViewLogic/DreamLand/DreamLandEndDialog",
	DreamLandEventHandle		= "ViewLogic/DreamLand/DreamLandEventHandle",
	DreamLandDiceDialog			= "ViewLogic/DreamLand/DreamLandDiceDialog",
	DreamLandAutoReward			= "ViewLogic/DreamLand/DreamLandAutoReward",
	DreamLandBG					= "ViewLogic/DreamLand/DreamLandBG",

	PvPMainViewLogic            = "ViewLogic/ArenaView/PvPMainViewLogic",
	ArenaViewLogic              = "ViewLogic/ArenaView/ArenaViewLogic",
	ArenaRuleViewLogic          = "ViewLogic/ArenaView/ArenaRuleViewLogic",
	ArenaListNode               = "ViewLogic/ArenaView/ArenaListNode",
	ArenaOneKeyViewLogic        = "ViewLogic/ArenaView/ArenaOneKeyViewLogic",

	CampaignViewLogic 			= "ViewLogic/Campaign/CampaignViewLogic",
	-- CampaignTestViewLogic 		= "ViewLogic/Campaign/CampaignTestViewLogic",
	CampaignNode 			= "ViewLogic/Campaign/CampaignNode",
	CampaignBuffDialog 			= "ViewLogic/Campaign/CampaignBuffDialog",
	CampaignRuleDialog 			= "ViewLogic/Campaign/CampaignRuleDialog",
	CampaignExchangeDialog 		= "ViewLogic/Campaign/CampaignExchangeDialog",
	CampaignBuffNode			= "ViewLogic/Campaign/CampaignBuffNode",
	CampaignRewardNode			= "ViewLogic/Campaign/CampaignRewardNode",

	RecruitBaseDialog 		= "ViewLogic/Recruit/RecruitBaseDialog",
	RecruitDiamondDialog 		= "ViewLogic/Recruit/RecruitDiamondDialog",
	RecruitFriendDialog 		= "ViewLogic/Recruit/RecruitFriendDialog",
	RecruitNewHeroNode			= "ViewLogic/Recruit/RecruitNewHeroNode",
	RecruitNewHeroDialog 		= "ViewLogic/Recruit/RecruitNewHeroDialog",
	RecruitViewLogic 			= "ViewLogic/Recruit/RecruitViewLogic",
	RecruitTempleViewLogic      = "ViewLogic/Recruit/RecruitTempleViewLogic",
	RecruitTreasureDiamondDialog = "ViewLogic/Recruit/RecruitTreasureDiamondDialog",
	RecruitTreasureFriendDialog = "ViewLogic/Recruit/RecruitTreasureFriendDialog",
	RecruitMagicViewLogic		= "ViewLogic/Recruit/RecruitMagicViewLogic",			-- 英雄秘术召唤新布局 
	RecruitTreasureMagicViewLogic = "ViewLogic/Recruit/RecruitTreasureMagicViewLogic",  -- 宝具秘术召唤新布局
	RecruitTreasureNode			= "ViewLogic/Recruit/RecruitTreasureNode",				-- 秘宝召唤显示节点
	RecruitGenreViewLogic		= "ViewLogic/Recruit/RecruitGenreViewLogic",
	RecruitAnimationNode		= "ViewLogic/Recruit/RecruitAnimationNode",
	RecruitGiftNode				= "ViewLogic/Recruit/RecruitGiftNode",
	NodeHerocall				= "ViewLogic/Recruit/NodeHerocall",
	NodeTreasurecall			= "ViewLogic/Recruit/NodeTreasurecall",

	AchievementNode 			= "ViewLogic/Achievement/AchievementNode",
	AchievementGiftNode 	    = "ViewLogic/Achievement/AchievementGiftNode",


	EquipNodeLogic 				= "ViewLogic/Equip/EquipNodeLogic",
	EquipOperateViewLogic 		= "ViewLogic/Equip/EquipOperateViewLogic",
	EquipListNodeLogic 			= "ViewLogic/Equip/EquipListNodeLogic",
	EquipListViewLogic 			= "ViewLogic/Equip/EquipListViewLogic",
	EquipDetailViewLogic 		= "ViewLogic/Equip/EquipDetailViewLogic",
	EquipSortViewLogic 			= "ViewLogic/Equip/EquipSortViewLogic",
	EquipGetMultiViewLogic 		= "ViewLogic/Equip/EquipGetMultiViewLogic",
	EquipDreamLandNodeLogic 	= "ViewLogic/Equip/EquipDreamLandNodeLogic",
	EquipDecomposeViewLogic 	= "ViewLogic/Equip/EquipDecomposeViewLogic",
	EquipGuideNodeLogic 		= "ViewLogic/Equip/EquipGuideNodeLogic",
	EquipGuideViewLogic 		= "ViewLogic/Equip/EquipGuideViewLogic",
	EquipExchangeViewLogic 		= "ViewLogic/Equip/EquipExchangeViewLogic",
	EquipExchangeNodeLogic 		= "ViewLogic/Equip/EquipExchangeNodeLogic",
	EquipLevelUpShowLogic 		= "ViewLogic/Equip/EquipLevelUpShowLogic",
	EquipLevelUpShowNode 		= "ViewLogic/Equip/EquipLevelUpShowNode",

	GuildViewLogic 				= "ViewLogic/Guild/GuildViewLogic",
	GuildScienceViewLogic 		= "ViewLogic/Guild/GuildScienceViewLogic",
	GuildEditDialog 			= "ViewLogic/Guild/GuildEditDialog",
	GuildFoundDialog 			= "ViewLogic/Guild/GuildFoundDialog",
	GuildListViewLogic 			= "ViewLogic/Guild/GuildListViewLogic",
	GuildListNode 				= "ViewLogic/Guild/GuildListNode",
	GuildMemberNode 			= "ViewLogic/Guild/GuildMemberNode",
	GuildMemberViewLogic 		= "ViewLogic/Guild/GuildMemberViewLogic",
	GuildOperateDialog 			= "ViewLogic/Guild/GuildOperateDialog",
	GuildSettingDialog 			= "ViewLogic/Guild/GuildSettingDialog",
	GuildAnnounceDialog 		= "ViewLogic/Guild/GuildAnnounceDialog",
	GuildAuditViewLogic 		= "ViewLogic/Guild/GuildAuditViewLogic",
	GuildAuditNode 				= "ViewLogic/Guild/GuildAuditNode",
	GuildNoticeDialog 			= "ViewLogic/Guild/GuildNoticeDialog",
	GuildNoticeNode 			= "ViewLogic/Guild/GuildNoticeNode",
	GuildEditFastDialog			= "ViewLogic/Guild/GuildEditFastDialog",
	GuildDetailDialog			= "ViewLogic/Guild/GuildDetailDialog",
	GuildDissolutionDialog      = "ViewLogic/Guild/GuildDissolutionDialog",
	GuildContributionViewLogic  = "ViewLogic/Guild/GuildContributionViewLogic",
	GuildLevelupViewLogic  		= "ViewLogic/Guild/GuildLevelupViewLogic",
	GuildContributionNode		= "ViewLogic/Guild/GuildContributionNode",
	
	GuildBossMapViewLogic		= "ViewLogic/Guild/GuildBossMapViewLogic",
	GuildBossMapNodeLogic		= "ViewLogic/Guild/GuildBossMapNodeLogic",
	GuildBossDetailViewLogic	= "ViewLogic/Guild/GuildBossDetailViewLogic",
	GuildBossDetailNodeLogic	= "ViewLogic/Guild/GuildBossDetailNodeLogic",
	GuildBossRewardViewLogic	= "ViewLogic/Guild/GuildBossRewardViewLogic",
	GuildBossRewardNodeLogic	= "ViewLogic/Guild/GuildBossRewardNodeLogic",
	GuildBossRankRwardViewLogic	= "ViewLogic/Guild/GuildBossRankRwardViewLogic",
	GuildBossCloudNodeLogic		= "ViewLogic/Guild/GuildBossCloudNodeLogic",
	GuildBossDonateViewLogic	= "ViewLogic/Guild/GuildBossDonateViewLogic",

	RankViewLogic				= "ViewLogic/Rank/RankViewLogic",
	RankNode					= "ViewLogic/Rank/RankNode",
	GlobalRankViewLogic     	= "ViewLogic/Rank/GlobalRankViewLogic", 
	GlobalGuildRankNode    		= "ViewLogic/Rank/GlobalGuildRankNode", 
	GlobalPlayerRankNode    	= "ViewLogic/Rank/GlobalPlayerRankNode", 

	PaymentViewLogic   			= "ViewLogic/Payment/PaymentViewLogic",
	PaymentViewNode   			= "ViewLogic/Payment/PaymentViewNode",

	RankBattleViewLogic         = "ViewLogic/RankBattleView/RankBattleViewLogic",
	RankBattleRuleView          = "ViewLogic/RankBattleView/RankBattleRuleView",
	RankBattleListNode          = "ViewLogic/RankBattleView/RankBattleListNode",
	RankBattleResultViewLogic   = "ViewLogic/RankBattleView/RankBattleResultViewLogic",

	SevenDayViewLogic			= "ViewLogic/Activity/SevenDay/SevenDayViewLogic",
	SevenDayNode				= "ViewLogic/Activity/SevenDay/SevenDayNode",
	SevenDayPreviewLogic		= "ViewLogic/Activity/SevenDay/SevenDayPreviewLogic",
	SevenDayPreviewNode			= "ViewLogic/Activity/SevenDay/SevenDayPreviewNode",
	SevenDayDiscountHelper		= "ViewLogic/Activity/SevenDay/SevenDayDiscountHelper",
	SevenDayManager				= "ViewLogic/Activity/SevenDay/SevenDayManager",
	SevenDayGiftNode			= "ViewLogic/Activity/SevenDay/SevenDayGiftNode",
	HalfMonthViewLogic			= "ViewLogic/Activity/SevenDay/HalfMonthViewLogic",
	HalfMonthNode				= "ViewLogic/Activity/SevenDay/HalfMonthNode",
	HalfMonthPreviewLogic		= "ViewLogic/Activity/SevenDay/HalfMonthPreviewLogic",

	ActivityLoginGiftKRViewLogic = "ViewLogic/Activity/LoginGift/ActivityLoginGiftKRViewLogic",

	FirstRechargeLogic			= "ViewLogic/Activity/FirstRecharge/FirstRechargeLogic",
	RebateFundViewLogic         = "ViewLogic/Activity/RebateFund/RebateFundViewLogic",
	RebateFundNode         = "ViewLogic/Activity/RebateFund/RebateFundNode",
	RebateFundPreNode         = "ViewLogic/Activity/RebateFund/RebateFundPreNode",
	RebateFundPreViewLogic         = "ViewLogic/Activity/RebateFund/RebateFundPreViewLogic",
	RebateFundRewardNodeLogic   = "ViewLogic/Activity/RebateFund/RebateFundRewardNodeLogic",

	RenewalLogic			= "ViewLogic/Activity/FirstRecharge/RenewalLogic",
	FirstRechargeNotice			= "ViewLogic/Activity/FirstRecharge/FirstRechargeNotice",

	ExpeditionMainViewLogic		= "ViewLogic/Expedition/ExpeditionMainViewLogic",
	ExpeditionBoxViewLogic		= "ViewLogic/Expedition/ExpeditionBoxViewLogic",
	ExpeditionBuffViewLogic		= "ViewLogic/Expedition/ExpeditionBuffViewLogic",
	ExpeditionResetViewLogic	= "ViewLogic/Expedition/ExpeditionResetViewLogic",

	WorldBossViewLogic			= "ViewLogic/WorldBoss/WorldBossViewLogic",
	WorldBossRankNode			= "ViewLogic/WorldBoss/WorldBossRankNode",
	WorldBossBuffDiaLog			= "ViewLogic/WorldBoss/WorldBossBuffDiaLog",
	WorldBossBattleLog			= "ViewLogic/WorldBoss/WorldBossBattleLog",
	WorldBossBattleLogNode		= "ViewLogic/WorldBoss/WorldBossBattleLogNode",
	WorldBossRewardViewLogic	= "ViewLogic/WorldBoss/WorldBossRewardViewLogic",
	WorldBossRewardNode			= "ViewLogic/WorldBoss/WorldBossRewardNode",
	WorldBossResultViewLogic	= "ViewLogic/WorldBoss/WorldBossResultViewLogic",
	WorldBossGiftNode			= "ViewLogic/WorldBoss/WorldBossGiftNode",
	WorldBossSkillNode			= "ViewLogic/WorldBoss/WorldBossSkillNode",
	WorldBossHeroNode			= "ViewLogic/WorldBoss/WorldBossHeroNode",

	LimitGiftBoxLogic			= "ViewLogic/LimitGiftbox/LimitGiftBoxLogic",
	LimitGiftBoxLogicNotice		= "ViewLogic/LimitGiftbox/LimitGiftBoxLogicNotice",

	VipSystemViewLogic          ="ViewLogic/Vip/VipSystemViewLogic",
    VipSystemViewNodeLogic      ="ViewLogic/Vip/VipSystemViewNodeLogic",

	ActivityMainViewLogic       = "ViewLogic/Activity/ActivityMainViewLogic",
	ActivityTabNode       		= "ViewLogic/Activity/ActivityTabNode",
	ActivityCDKeyViewLogic		= "ViewLogic/Activity/ActivityCDKeyViewLogic",
	ActivityRewardViewLogic		= "ViewLogic/Activity/ActivityRewardViewLogic",
	ActivityRankViewLogic		= "ViewLogic/Activity/ActivityRankViewLogic",
	ActivityRewardNode			= "ViewLogic/Activity/ActivityRewardNode",
	ActivityRewardItemNode		= "ViewLogic/Activity/ActivityRewardItemNode",
	ActivityRankNode			= "ViewLogic/Activity/ActivityRankNode",
	ActivityGrowupViewLogic     = "ViewLogic/Activity/ActivityGrowupViewLogic",
	ActivityGrowupNode			= "ViewLogic/Activity/ActivityGrowupNode",
	ActivityCLBaseViewLogic 	= "ViewLogic/Activity/CommonLimit/ActivityCLBaseViewLogic",
	ActivityCLBaseNode 			= "ViewLogic/Activity/CommonLimit/ActivityCLBaseNode",
	ActivityMagicRecruitViewLogic = "ViewLogic/Activity/CommonLimit/ActivityMagicRecruitViewLogic",
	ActivityMagicRecruitNode 	= "ViewLogic/Activity/CommonLimit/ActivityMagicRecruitNode",
	ActivityTreasureMagicViewLogic = "ViewLogic/Activity/CommonLimit/ActivityTreasureMagicViewLogic",	-- 秘宝召唤，活动列表中的界面
	ActivityTreasureMagicNode 	= "ViewLogic/Activity/CommonLimit/ActivityTreasureMagicNode",			-- 秘宝召唤，活动列表中的listnode
	FirstRechargeResetViewLogic = "ViewLogic/Activity/FirstRechargeResetViewLogic",
	
	ActivityLuckyCatViewLogic 	= "ViewLogic/Activity/LuckyCat/ActivityLuckyCatViewLogic",			-- 秘宝召唤，活动列表中的listnode
	LA_LuckyCatViewLogic 	= "ViewLogic/Activity/LuckyCat/LA_LuckyCatViewLogic",	
	LA_LuckyCatNode 	= "ViewLogic/Activity/LuckyCat/LA_LuckyCatNode",
	EffectLuckCat 	= "ViewLogic/Activity/LuckyCat/EffectLuckCat",
	
	ActivityCommonLimitLogic    = "ViewLogic/Activity/CommonLimit/ActivityCommonLimitLogic",
	ActivityCommonLimitNode     = "ViewLogic/Activity/CommonLimit/ActivityCommonLimitNode",
	ActivityCommonExchangeLogic  = "ViewLogic/Activity/CommonLimit/ActivityCommonExchangeLogic",
	ActivityCommonExchangeNode  = "ViewLogic/Activity/CommonLimit/ActivityCommonExchangeNode",
	ActivityGemLoftLogic  = "ViewLogic/Activity/CommonLimit/ActivityGemLoftLogic",
	ActivityGemLoftNode  = "ViewLogic/Activity/CommonLimit/ActivityGemLoftNode",
	
	ActivityYouChooseViewLogic  = "ViewLogic/Activity/YouChoose/ActivityYouChooseViewLogic",
	ActivityGiveDiamondLogic    = "ViewLogic/Activity/ActivityGiveDiamondLogic",
	LimitHeroViewLogic			= "ViewLogic/Activity/LimitHero/LimitHeroViewLogic",
	ActivityLimitShopViewLogic  = "ViewLogic/Activity/LimitShop/ActivityLimitShopViewLogic",
	ActivityLimitShopNode  = "ViewLogic/Activity/LimitShop/ActivityLimitShopNode",
	CycleRechargeViewLogic      = "ViewLogic/Activity/CycleRecharge/CycleRechargeViewLogic",
	ActivityExchangeViewLogic	= "ViewLogic/Activity/Exchange/ActivityExchangeViewLogic",
	ActivityBoxExchangeViewLogic	= "ViewLogic/Activity/Exchange/ActivityBoxExchangeViewLogic",
	ActivityBoxExchangeNode	= "ViewLogic/Activity/Exchange/ActivityBoxExchangeNode",
	ActivityExchangeNode		= "ViewLogic/Activity/Exchange/ActivityExchangeNode",
	ActivityGiftNode			= "ViewLogic/Activity/ActivityGiftNode",
	CarnivalRichViewLogic       = "ViewLogic/Activity/CarnivalRich/CarnivalRichViewLogic",
	CarnivalRichRankNode        = "ViewLogic/Activity/CarnivalRich/CarnivalRichRankNode",
	CarnivalRichEightViewLogic  = "ViewLogic/Activity/CarnivalRich/CarnivalRichEightViewLogic",
	CarnivalRichResultViewLogic = "ViewLogic/Activity/CarnivalRich/CarnivalRichResultViewLogic",
	CarnivalRichDiceNode        = "ViewLogic/Activity/CarnivalRich/CarnivalRichDiceNode",
	CarnivalRichFlashDiceEight  = "ViewLogic/Activity/CarnivalRich/CarnivalRichFlashDiceEight",
	CarnivalRichDoubleViewLogic  = "ViewLogic/Activity/CarnivalRich/CarnivalRichDoubleViewLogic",
	CarnivalRichRechargeListNode  = "ViewLogic/Activity/CarnivalRich/CarnivalRichRechargeListNode",
	ActivityNewbieMainViewLogic   = "ViewLogic/Activity/Newbie/ActivityNewbieMainViewLogic",
	ActivityCommonNewbieLogic   = "ViewLogic/Activity/Newbie/ActivityCommonNewbieLogic",
	ActivityEverydayPayNode     = "ViewLogic/Activity/Newbie/ActivityEverydayPayNode",
	ActivityEverydayPayLogic     = "ViewLogic/Activity/Newbie/ActivityEverydayPayLogic",
	ActivityNewEverydayPayLogic     = "ViewLogic/Activity/Newbie/ActivityNewEverydayPayLogic",
	OpenServerRaceLogic     = "ViewLogic/Activity/OpenServerRaceLogic",
	OpenServerRaceNode     = "ViewLogic/Activity/OpenServerRaceNode",
	LimitGlobinShopViewLogic     = "ViewLogic/Activity/LimitGlobinShopViewLogic",
	LimitGlobinShopViewNode     = "ViewLogic/Activity/LimitGlobinShopViewNode",
	ActivityWorldBossRankLogic     = "ViewLogic/Activity/ActivityWorldBossRankLogic",
	ActivityWorldBossRankNode     = "ViewLogic/Activity/ActivityWorldBossRankNode",
	VipDailyRewardNode     = "ViewLogic/Activity/vip/VipDailyRewardNode",
	VipDailyRewardViewLogic     = "ViewLogic/Activity/vip/VipDailyRewardViewLogic",
	OnlineGiftViewLogic			=	"ViewLogic/Activity/OnlineGift/OnlineGiftViewLogic",
	MoneyFlyViewLogic			=	"ViewLogic/Activity/MoneyFly/MoneyFlyViewLogic",
	MoneyFlyNodeLogic			=	"ViewLogic/Activity/MoneyFly/MoneyFlyNodeLogic",
	ActivityLimitEverydayPayLogic = "ViewLogic/Activity/CommonLimit/ActivityLimitEverydayPayLogic",
	LimitBlessingViewLogic		= "ViewLogic/Activity/LimitHero/LimitBlessingViewLogic",
	LimitMarchViewLogic			= "ViewLogic/Activity/March/LimitMarchViewLogic",
	LimitMarchRewardViewLogic	= "ViewLogic/Activity/March/LimitMarchRewardViewLogic",
	LimitMarchDiceFlash			= "ViewLogic/Activity/March/LimitMarchDiceFlash",
	DivineHeroCalledViewLogic 	= "ViewLogic/Activity/LimitHero/DivineHeroCalledViewLogic",
	LimitHeroExchangeViewLogic 	= "ViewLogic/Activity/LimitHero/LimitHeroExchangeViewLogic",
	LimitHeroExchangeNode 		= "ViewLogic/Activity/LimitHero/LimitHeroExchangeNode",
	TreasureLGViewLogic 		= "ViewLogic/Activity/LimitTreasureLG/TreasureLGViewLogic",
	ActivityWorkShopViewLogic	= "ViewLogic/Activity/WorkShop/ActivityWorkShopViewLogic",
	ActivityHeader 				= "ViewLogic/Activity/ActivityHeader",
	ActivityProbabilityViewLogic = "ViewLogic/Activity/ActivityProbabilityViewLogic",
	ActivityProbabilityNode     = "ViewLogic/Activity/ActivityProbabilityNode",
	ActivityMilitarySupplyLogic =  "ViewLogic/Activity/MilitarySupply/ActivityMilitarySupplyLogic",
	MilitarySupplyHelper = "ViewLogic/Activity/MilitarySupply/MilitarySupplyHelper",
	MilitarySupplyNode = "ViewLogic/Activity/MilitarySupply/MilitarySupplyNode",
	ActivityWishViewLogic = "ViewLogic/Activity/Wish/ActivityWishViewLogic",
	ActivityWishResultViewLogic = "ViewLogic/Activity/Wish/ActivityWishResultViewLogic",
	ActivityWishComment = "ViewLogic/Activity/Wish/ActivityWishComment",
	ActivityWishGiftNode = "ViewLogic/Activity/Wish/ActivityWishGiftNode",
	ActivityChargeGiftViewLogic = "ViewLogic/Activity/ChargeGift/ActivityChargeGiftViewLogic",
	ActivityChargeGiftNode = "ViewLogic/Activity/ChargeGift/ActivityChargeGiftNode",
	TreasureCallViewLogic = "ViewLogic/Activity/Treasure/TreasureCallViewLogic",
	ActivitySeniorContractViewLogic = "ViewLogic/Activity/Contract/ActivitySeniorContractViewLogic",
	ActivitySeniorContractNode = "ViewLogic/Activity/Contract/ActivitySeniorContractNode",
	ActivityArenaDoubleViewLogic = "ViewLogic/Activity/ActivityArenaDoubleViewLogic",
	LimitChargeGiftViewLogic = "ViewLogic/Activity/ChargeGift/LimitChargeGiftViewLogic",
	LimitChargeGiftNode = "ViewLogic/Activity/ChargeGift/LimitChargeGiftNode",
	ActivityEliteDoubleViewLogic = "ViewLogic/Activity/ActivityEliteDoubleViewLogic",
	ActivityLevelUpViewLogic = "ViewLogic/Activity/ActivityLevelUpViewLogic",

	ActivityLockyWheelLogic = "ViewLogic/Activity/LuckyWheel/ActivityLockyWheelLogic",
	ActivityLockyWheelExchangeViewLogic = "ViewLogic/Activity/LuckyWheel/ActivityLockyWheelExchangeViewLogic",
	ActivityLuckyWheelExchangeNode = "ViewLogic/Activity/LuckyWheel/ActivityLuckyWheelExchangeNode",

	ActivityLoginGiftViewLogic 		= "ViewLogic/Activity/LoginGift/ActivityLoginGiftViewLogic",
	ActivityLoginGiftNode			= "ViewLogic/Activity/LoginGift/ActivityLoginGiftNode",
	ActivityLoginGiftADLogic		= "ViewLogic/Activity/LoginGift/ActivityLoginGiftADLogic",
	ActivitySpiritTempleViewLogic	= "ViewLogic/Activity/SpiritTemple/ActivitySpiritTempleViewLogic",

	TalentViewLogic = "ViewLogic/Talent/TalentViewLogic",
	TalentNode = "ViewLogic/Talent/TalentNode",
	TalentDetailDialog = "ViewLogic/Talent/TalentDetailDialog",
	
	WearListViewBaseLogic 			= "ViewLogic/Rune/WearListViewBaseLogic",

	----------------------------- 幸运老虎机相关页面 zhaolu -----------------------------
	ActivitySlotMachineLogic 		= "ViewLogic/Activity/SlotMachine/ActivitySlotMachineLogic",
	ActivitySlotMachineRollOneLogic = "ViewLogic/Activity/SlotMachine/ActivitySlotMachineRollOneLogic",
	ActivitySlotMachineRollTenLogic = "ViewLogic/Activity/SlotMachine/ActivitySlotMachineRollTenLogic",
	ActivitySlotMachineRewardNode 	= "ViewLogic/Activity/SlotMachine/ActivitySlotMachineRewardNode",
	ActivitySlotMachineNodeLogic 	= "ViewLogic/Activity/SlotMachine/ActivitySlotMachineNodeLogic",
	----------------------------- 符文系统页面 zhaolu -----------------------------
	RuneViewLogic 					= "ViewLogic/Rune/RuneViewLogic",
	RuneViewPutHelper 				= "ViewLogic/Rune/RuneViewPutHelper",
	RuneViewBagHelper 				= "ViewLogic/Rune/RuneViewBagHelper",
	RuneViewOriginalHelper 			= "ViewLogic/Rune/RuneViewOriginalHelper",
	RuneViewSellHelper 				= "ViewLogic/Rune/RuneViewSellHelper",
	RuneCallPopLogic 				= "ViewLogic/Rune/RuneCallPopLogic",
	RuneListNode 					= "ViewLogic/Rune/RuneListNode",
	RuneDetailLogic 				= "ViewLogic/Rune/RuneDetailLogic",
	RuneTableViewHelper 			= "ViewLogic/Rune/RuneTableViewHelper",
	RuneRemouldLogic 				= "ViewLogic/Rune/RuneRemouldLogic",
	RuneLevelupLogicEx              = "ViewLogic/Rune/RuneLevelupLogicEx",
	RuneCallRewardLogic 			= "ViewLogic/Rune/RuneCallRewardLogic",
	RuneConfirmLogic 				= "ViewLogic/Rune/RuneConfirmLogic",
	RuneCallPopNode 				= "ViewLogic/Rune/RuneCallPopNode",
	RuneEquipListViewLogic 			= "ViewLogic/Rune/RuneEquipListViewLogic",
	RuneQuickLevelUpLogicEx         = "ViewLogic/Rune/RuneQuickLevelUpLogicEx",
	RuneSellSortViewLogic           = "ViewLogic/Rune/RuneSellSortViewLogic",
	
	--------------------------世界大战-----------------------------------------------------
	GlobalCampBattleMsgDialog      = "ViewLogic/GlobalCampBattle/GlobalCampBattleMsgDialog",
	GlobalCampBattleRankViewLogic	= "ViewLogic/GlobalCampBattle/GlobalCampBattleRankViewLogic",
	GlobalCampBattleViewLogic   ="ViewLogic/GlobalCampBattle/GlobalCampBattleViewLogic",
	GlobalCampBattleMapNodeLogic         = "ViewLogic/GlobalCampBattle/GlobalCampBattleMapNodeLogic",
	GlobalCampBattleMapLogic    = "ViewLogic/GlobalCampBattle/GlobalCampBattleMapLogic",
	GlobalCampBattleResultDialog          = "ViewLogic/GlobalCampBattle/GlobalCampBattleResultDialog",
	GlobalCampCombatProcessDialog = "ViewLogic/GlobalCampBattle/GlobalCampCombatProcessDialog",
	GolbalCampTipsDialog = "ViewLogic/GlobalCampBattle/GolbalCampTipsDialog",
	GlobalCampBattleRankDialog="ViewLogic/GlobalCampBattle/GlobalCampBattleRankDialog",
	GlobalCampBattleRankNode = "ViewLogic/GlobalCampBattle/GlobalCampBattleRankNode",
	GlobalCampBattleEndDialog = "ViewLogic/GlobalCampBattle/GlobalCampBattleEndDialog",
	GlobalCampBattleRewardDialog = "ViewLogic/GlobalCampBattle/GlobalCampBattleRewardDialog",
	GlobalCampBattleRewardNode = "ViewLogic/GlobalCampBattle/GlobalCampBattleRewardNode",

	TreasureViewLogic = "ViewLogic/TreasureView/TreasureViewLogic",
	TreasureListHelper = "ViewLogic/TreasureView/TreasureListHelper",
	TreasureSoulComposeHelper = "ViewLogic/TreasureView/TreasureSoulComposeHelper",
	TreasureSoulDeComposeHelper = "ViewLogic/TreasureView/TreasureSoulDeComposeHelper",
	TreasureListNode = "ViewLogic/TreasureView/TreasureListNode",
	TreasureDetailViewLogic = "ViewLogic/TreasureView/TreasureDetailViewLogic",
	TreasureDeComposeNode = "ViewLogic/TreasureView/TreasureDeComposeNode",
	TreasureDeComposeConfirmViewLogic = "ViewLogic/TreasureView/TreasureDeComposeConfirmViewLogic",
	TreasureDeComposeBatchViewLogic = "ViewLogic/TreasureView/TreasureDeComposeBatchViewLogic",
	TreasurePrevViewLogic = "ViewLogic/TreasureView/TreasurePrevViewLogic",
	TreasureInfoViewLogic = "ViewLogic/TreasureView/TreasureInfoViewLogic",
	TreasureTransformViewLogic = "ViewLogic/TreasureView/TreasureTransformViewLogic",
	TreasureExchangeNode = "ViewLogic/TreasureView/TreasureExchangeNode",
	TreasureExchangeViewLogic = "ViewLogic/TreasureView/TreasureExchangeViewLogic",
	TreasurePieceGetViewLogic = "ViewLogic/TreasureView/TreasurePieceGetViewLogic",
	TreasurePieceGetNode = "ViewLogic/TreasureView/TreasurePieceGetNode",
	TreasureStrongAnimView = "ViewLogic/TreasureView/TreasureStrongAnimView",

	---- 功能开启预告 ----
	AdventureNextFunctionLogic = "ViewLogic/OpenPreview/AdventureNextFunctionLogic",	-- 即将开启界面

	SoulStoneTowerViewLogic = "ViewLogic/SoulStoneTower/SoulStoneTowerViewLogic",
	SoulStoneTowerNode = "ViewLogic/SoulStoneTower/SoulStoneTowerNode",
	SoulStoneTowerBattleEventViewLogic = "ViewLogic/BattleEvent/SoulStoneTowerBattleEventViewLogic",


	---  公会战  --- 
	GlobalGuildBattleFieldLogic 		= "ViewLogic/GlobalGuildBattle/GlobalGuildBattleFieldLogic",
	GlobalGuildBattleHeroLogic 			= "ViewLogic/GlobalGuildBattle/GlobalGuildBattleHeroLogic",
	GlobalGuildBattleInfoDialog 		= "ViewLogic/GlobalGuildBattle/GlobalGuildBattleInfoDialog",
	GlobalGuildBattleGuildNode 			= "ViewLogic/GlobalGuildBattle/GlobalGuildBattleGuildNode",
	GlobalGuildBattlePalaceLogic 		= "ViewLogic/GlobalGuildBattle/GlobalGuildBattlePalaceLogic",
	GlobalGuildBattleReportLogic 		= "ViewLogic/GlobalGuildBattle/GlobalGuildBattleReportLogic",
	GlobalGuildBattleScheduleLogic 		= "ViewLogic/GlobalGuildBattle/GlobalGuildBattleScheduleLogic",
	GlobalGuildBattleViewLogic 			= "ViewLogic/GlobalGuildBattle/GlobalGuildBattleViewLogic",
	GlobalGuildBattleWorshipDialog 		= "ViewLogic/GlobalGuildBattle/GlobalGuildBattleWorshipDialog",
	GlobalGuildBattlePalaceNode 		= "ViewLogic/GlobalGuildBattle/GlobalGuildBattlePalaceNode",
	GlobalGuildBattleScheduleNode 		= "ViewLogic/GlobalGuildBattle/GlobalGuildBattleScheduleNode",
	GlobalGuildBattleReportNode 		= "ViewLogic/GlobalGuildBattle/GlobalGuildBattleReportNode", 
	GlobalGuildBattlePromoLogDialog 	= "ViewLogic/GlobalGuildBattle/GlobalGuildBattlePromoLogDialog", 
	GlobalGuildBattleRewardLogic    	= "ViewLogic/GlobalGuildBattle/GlobalGuildBattleRewardLogic", 
	GlobalGuildBattleRewardNode     	= "ViewLogic/GlobalGuildBattle/GlobalGuildBattleRewardNode",  
	GlobalGuildBattlePromoProgressNode  = "ViewLogic/GlobalGuildBattle/GlobalGuildBattlePromoProgressNode",  
	GlobalGuildBattleTacticDialog		= "ViewLogic/GlobalGuildBattle/GlobalGuildBattleTacticDialog",
	---  资源双倍活动  --- 
	UndergroundDoubleViewLogic      = "ViewLogic/Activity/ResourceDouble/UndergroundDoubleViewLogic", 
	NestDoubleViewLogic			    = "ViewLogic/Activity/ResourceDouble/NestDoubleViewLogic", 

	SummoningMonsterViewLogic = "ViewLogic/SummoningMonsterView/SummoningMonsterViewLogic",
	SummoningMonsterItemNode = "ViewLogic/SummoningMonsterView/SummoningMonsterItemNode",
	SummoningMonsterDetailViewLogic = "ViewLogic/SummoningMonsterView/SummoningMonsterDetailViewLogic",
	SummoningMonsterTotalViewLogic = "ViewLogic/SummoningMonsterView/SummoningMonsterTotalViewLogic",

	SoulStoneViewLogic 					= "ViewLogic/SoulStone/SoulStoneViewLogic",
	SoulStoneSuitNode 					= "ViewLogic/SoulStone/SoulStoneSuitNode",
	SoulStoneShapeNode 					= "ViewLogic/SoulStone/SoulStoneShapeNode",
	SoulStoneBigNode 					= "ViewLogic/SoulStone/SoulStoneBigNode",
	SoulStoneNode 						= "ViewLogic/SoulStone/SoulStoneNode",
	SoulStoneDecomposeViewLogic 		= "ViewLogic/SoulStone/SoulStoneDecomposeViewLogic",
	SoulStoneSellSortViewLogic 			= "ViewLogic/SoulStone/SoulStoneSellSortViewLogic",
	SoulStoneDetailViewLogic 			= "ViewLogic/SoulStone/SoulStoneDetailViewLogic",
	SoulStoneEquipViewLogic 			= "ViewLogic/SoulStone/SoulStoneEquipViewLogic",
	SoulStoneSuitViewLogic 				= "ViewLogic/SoulStone/SoulStoneSuitViewLogic",
	SoulStoneStrongAnimViewLogic 		= "ViewLogic/SoulStone/SoulStoneStrongAnimViewLogic",
	SoulStoneOneKeyViewLogic 			= "ViewLogic/SoulStone/SoulStoneOneKeyViewLogic",
	

	-- 等级系统
	LevelUpViewLogic 					= "ViewLogic/LevelUp/LevelUpViewLogic",
	LevelUpSpineLogic					= "ViewLogic/LevelUp/LevelUpSpineLogic",
	LevelGiftViewLogic					= "ViewLogic/Activity/LevelGift/LevelGiftViewLogic",
	LevelGiftNode						= "ViewLogic/Activity/LevelGift/LevelGiftNode",

	-- 矿区争夺
	GMWDetailViewLogic					= "ViewLogic/GlobalMiningWar/GMWDetailViewLogic",
	GMWNodeView							= "ViewLogic/GlobalMiningWar/GMWNodeView",
	GMWReportNodeView					= "ViewLogic/GlobalMiningWar/GMWReportNodeView",
	GMWViewLogic						= "ViewLogic/GlobalMiningWar/GMWViewLogic",
	GMWReportViewLogic					= "ViewLogic/GlobalMiningWar/GMWReportViewLogic",
	GMWSpecialRewardView				= "ViewLogic/GlobalMiningWar/GMWSpecialRewardView",

	-- GM推送消息
	TrumpetViewLogic = "ViewLogic/Trumpet/TrumpetViewLogic",
}


for k,v in pairs(VIEW_LOGIC_TABLE) do
	_G[k] = {
		new = function ( ... )
			_G[k] = nil
			require(v)

			return _G[k].new( ... )
		end,
		
		getInstance = function ( ... )
			_G[k] = nil
			require(v)

			return _G[k].getInstance( ... )
		end,
		
        -- 某些界面可能同时只存在一个，又不需要用单例（单例会常驻内存，在关闭界面的时候不会释放），调用此方法吧
		createIns = function ( ... )
			_G[k] = nil
			require(v)

			return _G[k].createIns( ... )
		end,

		_realrequire_ = function ( ... )
			_G[k] = nil
			require(v)

			return _G[k]
		end
	}
end


-- 非cocos2dx class生成的在此处require
-- require "ViewLogic/NoviceGuide/NoviceGuideManager"

-- require "ViewLogic/Common/BGGrayManager"
-- require "ViewLogic/Common/TipsManager"
-- require "ViewLogic/Common/BroadcastManager"
-- require "ViewLogic/Common/SensitiveWordManager"
-- require "ViewLogic/Common/ViewLogicRouteManager"
-- require "ViewLogic/Common/GameEvaluation"
-- require "ViewLogic/Battle/BattleManager"
-- require "ViewLogic/Battle/BattleLogic"
-- require "ViewLogic/Battle/BattleAttackLogic"
-- require "ViewLogic/Battle/BattleDamageLogic"
-- require "ViewLogic/Battle/TroopLogic"
-- require "ViewLogic/MainView/MainViewManager"
-- require "ViewLogic/MainView/OnLoginManager"
-- require "ViewLogic/Mine/Block/BlockManager"
-- require "ViewLogic/Mine/MineManager"
-- require "ViewLogic/Mine/MineGolemTipsHelper"
-- require "ViewLogic/Project/ProjectManager"
-- require "ViewLogic/Cave/CaveManager"
-- require "ViewLogic/Campaign/CampaignManager"
-- require "ViewLogic/Recruit/RecruitManager"
-- require "ViewLogic/FormationView/MercenaryCoopSkillBoardEx"
-- require "ViewLogic/Daily/DailyActivityHelper"
-- require "ViewLogic/Daily/DailyPrayHelper"
-- require "ViewLogic/Achievement/AchievementManager"
-- require "ViewLogic/Guild/GuildManager"
-- require "ViewLogic/FormationView/MercenaryViewHelper"
-- require "ViewLogic/Role/NameCheck"
-- require "ViewLogic/Activity/RewardManager"





-- 非cocos2dx class生成的在此处require
local _AllViewLogic = {
	"ViewLogic/NoviceGuide/NoviceGuideManager",

	"ViewLogic/Common/BGGrayManager",
	"ViewLogic/Common/TipsManager",
	"ViewLogic/Common/BroadcastManager",
	"ViewLogic/Common/SensitiveWordManager",
	"ViewLogic/Common/ViewLogicRouteManager",
	"ViewLogic/Common/GameEvaluation",
	"ViewLogic/Entity/AnimationCache",
	"ViewLogic/Entity/ResourceHelper",
	"ViewLogic/Battle/BattleManager",
	"ViewLogic/Battle/BattleLogic",
	"ViewLogic/Battle/BattleAttackLogic",
	"ViewLogic/Battle/BattleDamageLogic",
	"ViewLogic/Battle/BattleBuffLogic",
	"ViewLogic/Battle/TroopLogic",
	"ViewLogic/Battle/BattleEffectLogic",
	"ViewLogic/Battle/BattleResultSpine",
	"ViewLogic/Battle/BattleStartSpine",
	"ViewLogic/Battle/BattleComboSpine",
	"ViewLogic/Battle/BattleBgSpine",
	"ViewLogic/Battle/BattleEffectSpine",
	"ViewLogic/Battle/BattleEffectBgSpine",
	"ViewLogic/Battle/BattleShowEndingViewLogic",
	"ViewLogic/Battle/BattleFrontSpine",
	"ViewLogic/Battle/BattleDamageStatisticViewLogic",
	"ViewLogic/Battle/BattleDamageStatisticNodeLogic",
	"ViewLogic/MainView/MainViewManager",
	"ViewLogic/MainView/OnLoginManager",
	"ViewLogic/Mine/Block/BlockManager",
	"ViewLogic/Mine/MineManager",
	"ViewLogic/Mine/MineGolemTipsHelper",
	"ViewLogic/Project/ProjectManager",
	"ViewLogic/Cave/CaveManager",
	"ViewLogic/Campaign/CampaignManager",
	"ViewLogic/Recruit/RecruitManager",
	"ViewLogic/FormationView/MercenaryCoopSkillBoardEx",
	"ViewLogic/Daily/DailyActivityHelper",
	"ViewLogic/Daily/DailyPrayHelper",
	"ViewLogic/Daily/DailyAchievementHelper",
	"ViewLogic/Daily/DailyNewbieHelper",
	"ViewLogic/Daily/DailyNewbieTipsViewLogic",
	"ViewLogic/Achievement/AchievementManager",
	"ViewLogic/Guild/GuildManager",
	"ViewLogic/Role/NameCheck",
	"ViewLogic/Activity/RewardManager",
	"ViewLogic/Talent/TalentManager",
	"ViewLogic/ChallengeView/ChallengeManager",
	"ViewLogic/WorldBoss/WorldBossManager",
	"ViewLogic/GlobalCampBattle/GlobalCampBattleManager",
	"ViewLogic/Shop/ShopManager",
	"ViewLogic/SoulStoneTower/SoulStoneTowerManager",

	-- 主题关卡
	"ViewLogic/ThemePass/ThemePassTaskShopViewLogic",
	"ViewLogic/ThemePass/ThemePassManager",
	"ViewLogic/ThemePass/ThemeMapViewLogic",
	"ViewLogic/ThemePass/ThemeMapNode",
	"ViewLogic/ThemePass/ThemeStageNode",
	"ViewLogic/ThemePass/ThemeLevelViewLogic",
	"ViewLogic/ThemePass/ThemeLevelNormalNode",
	"ViewLogic/ThemePass/ThemeLevelBossNode",
	"ViewLogic/ThemePass/ThemeLevelDetailLogic",
	"ViewLogic/ThemePass/ThemeChapterShowLogic",
	"ViewLogic/ThemePass/ThemePassTalkingManager",
	"ViewLogic/ThemePass/ThemeTaskShopHelper",
	"ViewLogic/ThemePass/ThemeTaskShopNode",
	"ViewLogic/ThemePass/UseMoreViewLogic",

	-- 战斗对话
	"ViewLogic/PassTalk/PassTalkViewLogic",
	"ViewLogic/PassTalk/PassTalkHeadNode",
	"ViewLogic/PassTalk/PassTalkTextNode",

	-- 推图对话
	"ViewLogic/AdventureView/AdventureTalkingManager",
	"ViewLogic/AdventureView/AdventureChallengeTalkingManager",
	"ViewLogic/Battle/BattleMidwayTalkingManager",
	"ViewLogic/Battle/ComicInstanceTalkingManager",

	"ViewLogic/GlobalGuildBattle/GlobalGuildBattleManager",

	-- 战斗事件面板
	"ViewLogic/BattleEvent/BattleEventManager",

	-- 战斗首秀
	"ViewLogic/Battle/BattleShowManager",

	-- GM推送消息
	"ViewLogic/Trumpet/TrumpetManager",
}
return _AllViewLogic