-- require "Module/GlobalConfManager"
-- require "Module/AddCostManager"
-- require "Module/FunctionOpenManager"
-- require "Module/PropertyKey"
-- require "Module/FormationData"
-- require "Module/HeroData"
-- require "Module/PlayerData"
-- require "Module/MineData"
-- require "Module/IconInfo"
-- require "Module/BagData"
-- require "Module/SkillData"
-- require "Module/ProjectData"
-- require "Module/SoulGemData"
-- require "Module/SoulGemData"
-- require "Module/HandbookData"
-- require "Module/ChatData"

-- require "Module/AwardCenterData"

-- require "Module/AdventureData"
-- require "Module/ShopData"

-- require "Module/CaveData"
-- require "Module/MailData"
-- require "Module/CampaignData"
-- require "Module/RecruitData"
-- require "Module/PvPData"
-- require "Module/FuncSwitchData"
-- require "Module/NewbieFuncSwitchData"
-- require "Module/AchievementData"
-- require "Module/DailyData"
-- require "Module/GuildData"
-- require "Module/MonthCardData"
-- require "Module/CommentData"
-- require "Module/RemindData"
-- require "Module/RankData"
-- require "Module/PaymentData"
-- require "Module/Activity/SevenDayData"
-- require "Module/FriendData"
-- require "Module/Activity/LimitActivityBaseData"
-- require "Module/Activity/ActivityCommonLimitData"
-- require "Module/Activity/ActivityData"
-- require "Module/Activity/LimitHeroData"
-- require "Module/Activity/ActivityNewbieData"

-- require "Module/NoviceGuideData"



local _AllModule = {
	"Module/GlobalConfManager",
	"Module/AddCostManager",
	"Module/FunctionOpenManager",
	"Module/PropertyKey",
	"Module/FormationData",
	"Module/HeroData",
	"Module/PlayerData",
	"Module/MineData",
	"Module/IconInfo",
	"Module/BagData",
	"Module/SkillData",
	"Module/ProjectData",
	"Module/SoulGemData",
	"Module/SoulGemData",
	"Module/HandbookData",
	"Module/ChatData",

	"Module/AwardCenterData",

	"Module/AdventureData",
	"Module/ChallengeData",
	"Module/ShopData",

	"Module/CaveData",
	"Module/MailData",
	"Module/CampaignData",
	"Module/RecruitData",
	"Module/PvPData",
	"Module/FuncSwitchData",
	"Module/NewbieFuncSwitchData",
	"Module/AchievementData",
	"Module/DailyData",
	"Module/GuildData",
	"Module/MonthCardData",
	"Module/CommentData",
	"Module/RemindData",
	"Module/RankData",
	"Module/PaymentData",
	"Module/Activity/SevenDayData",
	"Module/Activity/HalfMonthData",
	"Module/FriendData",
	"Module/Activity/LimitActivityBaseData",
	"Module/Activity/ActivityCommonLimitData",
	"Module/Activity/ActivityData",
	"Module/Activity/ActivityResourceData",
	"Module/Activity/LimitHeroData",
	"Module/Activity/ActivityNewbieData",
	"Module/Activity/SlotMachineData",
	"Module/RuneData",
	"Module/SoulStoneTowerData",

	"Module/NoviceGuideData",
	"Module/LimitGiftBoxData",
	"Module/DreamLandData",
	"Module/VipSystemData",
	"Module/EquipData",
	
	"Module/GuildBossData",

	"Module/TalentData",
	"Module/CollectionEpicData",
	"Module/WorldBossData",
	"Module/GlobalCampBattleData",
	"Module/GlobalGuildBattleData",
	
	"Module/ExpeditionData",
	"Module/TreasureData",
	"Module/GoldSupplyData",

	"Module/Activity/ActivityClientConfigData",

	---- 功能开启预告 ----
	"Module/OpenPreview/NextFunctionData",		-- 功能开启预告面板显示数据 
	"Module/OpenPreview/OpenPreviewManager",	-- 功能开启预告管理类 

	---- 主题关卡 ----
	"Module/ThemePass/ThemeDataManager",
	"Module/ThemePass/ThemePassData",
	"Module/ThemePass/ThemeStoryData",
	"Module/ThemePass/ThemeTaskShopData",

	"Module/SummoningMonsterData",
	"Module/PedestalData",

	---- buff ----
	"Module/BuffData",

	---- 等级奖励 ----
	"Module/Activity/LevelGiftData",

	"Module/ActivityWorldBossRankData",
	
	"Module/OpenServerRaceData",
	"Module/IdentityBindingManager",
	"Module/ComicInstanceData",
	"Module/GlobalArenaData",
	"Module/SoulStoneData",
	"Module/KillingThousandsData",

	---- 新手任务 ----
	"Module/TaskNewbieData",

	---- 购买次数验证 ----
	"Module/CashData",

	---- 矿区争夺 ----
	"Module/GMWData",
	"Module/GMWManager",

	---- 创角 ----
	"Module/CreateUserData",

	---- 战斗buff ----
	"Module/BuffBattleData",
}
return _AllModule