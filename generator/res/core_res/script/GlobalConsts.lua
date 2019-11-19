CHAT_MAX_LEN = 45 --聊天输入最大的字符长度
ROLENAME_MAX_LEN = 8 -- 名字的最大长度


MAX_POWER_VALUE = 9999999999999

TAB_BUTTON_DATA = {
    TAB_WIDTH = 134,
    TAB_PADDING = 30
}

BATTLE_WIN = 1
BATTLE_LOSE = 0

HERO_QUALITY_MAX = 8

-- 装备占位符，即无装备时 ID为"0"
EMPTY_EQUIP = "0"

-- 装备 buff 最大数量
EQUIP_BUFF_MAX_COUNT = 6

-- 兑换一个英雄的碎片数量，即 30个英雄碎片可兑换一个英雄
COMPOSE_PIECE_NUM = 30

-- ItemData 表中  强化石的id
ITEM_STRENGTH_STONE_ID = 103398

-- 高级宝箱 用于引导获取宝箱
ADVANCED_TREASURE_BOX_ID = 200004

FORMATION_HERO_GAP = cc.p(25, 5)
FORMATION_HERO_CELL_COUNT = {row = 4, col = 4}

-- LG  神卡
-- SSR+    高级闪金
-- SSR 闪金
-- SR  金卡
-- R   紫卡
-- HN  蓝卡
-- N   绿卡
-- N   白卡
QUALITY_NAME =
{
    [1] = "N",
    [2] = "N",
    [3] = "HN",
    [4] = "R",
    [5] = "SR",
    [6] = "SSR",
    [7] = "SSR+",
    [8] = "LG",
}

ROLE_ANIM = {
    IDLE   = "idle",
    WALK   = "walk",
    ATTACK = "attack",
    BEATEN = "beaten",
    WIN    = "celebrate",
    LOSE   = "death",
}

BATTLE_ROLE_STATE = {
    ACTIVATED   = 1,
    NORMAL      = 2,
    INACTIVATED = 3,
    DEAD = 4,
}

NODE_SWITCH_DIRECTION = {
    LEFT = -1,
    RIGHT = 1
}


HERO_DEVELOPER_VIEW_TYPE = {
    HERO_NODE  = 1,
    STRENGTHEN = 2,
    ADVANCE    = 3,
    TREASURE   = 4,
    EQUIP      = 5,
    RUNE       = 6,
    SOUL_STONE = 7
}


-- MercenaryDetailViewLogic
HERO_DETAIL_VIEW_MODE = {
    FORMATION = 1,      -- 阵容
    HEROLIST  = 2,      -- 英雄列表
    HANDBOOK  = 3,      -- 图鉴
    WINESHOE  = 4,      -- 酒馆
    RECRUIT   = 5,      -- 召唤 需要播动画
    PREVIEW   = 6,      -- 预览
    ENDVIEW   = 7,      -- 无跳转 final
    TRANSFORM = 8,      -- 英雄转换
}


MER_PREVIEW_MODE = 
{
    FORMATION       = 1,
    CONTRACT        = 2,
    FORMATION_TOP   = 3,    -- 出阵阵容上方复用这个界面
    LIST_TOP        = 4,    -- 英雄列表上方复用这个界面
    TRANSMIGRATION  = 5,    -- 能力转换
    FIRE_TOP        = 6,    -- 批量解雇
    ALL_CHANGE      = 7,    -- 批量更换
    COLLECTION_EPIC = 8,    -- 史诗图鉴
    RECOVER_TOP     = 9,    -- 英雄还原
    HERO_TRANSFORM  = 10,   -- 英雄转换
}


BATCH_FILTER_TYPE = {
    NORMAL = 1,
    FIRE = 2,
    RECRUIT = 3,
    HERO = 4,
}

HERO_LIST_VIEW_TYPE = {
    LIST_VIEW = 1,
    FIRE_VIEW = 2,
    RESTORE_VIEW = 3,
}

HERO_QUALITY = 
{
    LG      = 8, --神卡
    SSRPLUS = 7, --高级闪金
    SSR     = 6, --闪金
    SR      = 5, --金
    R       = 4, --紫
    HN      = 3, --蓝
    N       = 2, --绿
    N1      = 1, --白
}

ITEM_SELECT_BAG = {
    PREVIEW = 1,
    SELECT = 2,
}



GUILD_BOSS_MAP_NODE_STATE = {
    UNOPENED = 1,
    FIGHTING = 2,
    CLEARED  = 3,
}

--角色动画方向
TROOP_TYPE = {
	LEFT = -1,
	RIGHT = 1
}

--掉落类型
-- 14.增加探索上限（品质5）  15.增加矿镐上限（品质5）

DROPDATA_TYPE = {
    GOLD = 1,          --金币
    EXP = 2,           --经验
    CASH = 3,          --免费钻石
    ITEM = 4,          --道具
    MERCENARY = 5,     --英雄(卡牌)
    PICKAXE = 6,       --矿稿
    POWER = 7,          --提升战斗力
    MAX_MERCENARY = 8,  --英雄列表上限
    MAX_FORMATION = 9,  --出战人数
    LEADERWEAPON = 10,  --传说武器
    CAMPAIGN_POINT = 11,  --当季赛点
    CAMPAIGN_EXP = 12,    --空岛之战经验
    CAMPAIGN_SEASON_POINT = 13,    --空岛之战当季赛点
    EXPLORE_LIMIT = 14,   --探索上限；
    PICKAXE_LIMIT = 15,   --增加矿镐上限；
    FRIEND_POINT = 16, --友情点
    LOCALRANKBATTLE = 17, --排位战攻击次数
    MONTH_CARD = 18, --月卡天数
    GUILD_HONOUR = 19,  --公会荣誉
    TALENT_POINT = 20, -- 天赋点
    EQUIP = 21,  --装备
    EXPEDITION_GLOD = 22,  --远征币
    RUNE_POINT = 23, -- 符文碎片
    RUNE = 24, -- 符文
    REPUTATION = 25, -- 声望
    TREASURESOUL = 26,    --宝具之魂
    MILITARY_EXPLOITS = 27,    --公会战战功
    RUNE_EXP = 28, --符文经验，用于符文升级
    PLAYER_EXP = 29, --玩家经验
    VIP_EXP = 30, --VIP经验
    STRENGTH_COIN = 31,    --精力
    SOUL_STONE_TOWER_STRENGTH_COIN = 38,--魔塔精力

    RMB_CASH = 32,    -- 付费钻石
    ETHERIC_ENERGY = 34,    -- 以太能源
    COMIC_ENERGY = 35,    -- 漫画体力
    SOUL_STONE = 36,        -- 魂石
    SOUL_STONE_EXP = 37,    -- 魂石经验
    
    GUILD_BOSS_RESET_RESOURCE = 1000,   --公会重置 需要的资源
    SOUL_GEM = 1001,   --灵魂石
    SOUL_GEM_COMMON = 1002, --灵魂石,不显示具体是哪个英雄的
    TREASURE = 1003, --宝具，只用来标识一种类型
    SUMMONING_MONSTER = 1004, --召唤兽
}

--ItemNode数字显示方式
ITEMNODE_SHOWTYPE = {
    NEED = 1,		--1 显示需要的数量，数量充足为绿色，不足为红色
    OWN_NEED = 2,	--2 显示拥有数量/需要的数量, 数量充足为绿色，不足为红色
    NORMAL = 3,		--3 显示传入的数量，颜色为白色
    NONE = 4,		--4 不显示数字
    BIG_OWN_NEED = 5,       --5 显示加大的数字
    AUTO = 6,               --根据不同类型自动选择格式
    OWN = 7,
    COST = 8,       -- 消耗类型，处理方式同OWN_NEED，仅英雄类型有区别
}

--ItemNode响应事件类型
ITEMNODE_CLICKTYPE = 
{
    CLICK_AND_TOUCH = 1, --响应click和touch事件，没有选中状态
    CLICK_ONLY = 2, --响应click，没有选中状态
    TOUCH_ONLY = 3, --响应touch，没有选中状态
    CLICK_AND_SELECT = 4, --响应click，有选中状态
}

AdventureEventViewLogic_Type = {
    Adventure = 1,      -- 推图
    Mine = 2,           -- 挖矿
    Campaign = 3,       -- 空岛之战
    RebirthBoss = 4,    -- 重生首领
    WorldBoss = 5,      -- 世界Boss
    GuildBoss = 6,      -- 公会Boss
    Elite = 7,          -- 精英关卡
    KillingThousands = 8, -- 千人斩
}

CaveBattleDialog_Type = {
    Cave = 1,
    Campaign = 2,
    Boss = 3,      -- 重生首领
}

-- 批量兑换类型
EXCHANGE_MORE_TYPE = {
    SCORE = 1, -- 积分兑换
    ITEM  = 2, -- 道具兑换
}

SHOP_TYPE = {
    ARENA_SHOP = 1, --竞技场商店
    QUALIFY_SHOP = 2, --排位赛商店
    CAMPAIGN_SHOP = 3, --空岛之战商店
    DIAMOND_SHOP = 4, --钻石商店
    GUILD_SHOP = 5,      --公会
    PRESTIGE = 6, -- 声望商店
    VIP_SHOP = 7, -- VIP商店
    GMW_TYPE = 8, -- 矿区争夺商店
    EXPEDITION_SHOP = 1, --远征商店
}

-- 随机商店ID (ShopRandomBaseData的id)
RANDOM_SHOP_ID = {
    EXPEDITION = 1, --远征商店
    EX_RANDOM  = 2, --主界面兑换的随机商店
}

LOGIN_VIEW_TYPE = {
    LOGIN_BTN = 1,
    ACCOUNT = 2,
    ENTER_GAME = 3,
    REGION_LIST = 4
}

ACCOUNT_VIEW_TYPE = {
    LOGIN = 1,
    FORGET = 2,
    REGISTER = 3,
    ACCOUNTS = 4
}

SOUL_CHIP = 102014 --荣誉碎片ID
KING_MEDAL = 102015 --王者之章ID
HERO_MEDAL = 103351 --英雄徽章ID
CONTRACT_STONE = 102006 --进阶石ID
TREAURE_TRANSFORM_SOUL = 103527 --宝具重铸精华ID，用于宝具转换
HERO_TRANSFORM_SOUL = 200001 --英雄重生之魂ID，用于英雄转换
TREASURE_SOUL_CHIP = 103474 --宝具精华，兑换宝具
STRENGTH_ITEM_ID = 200044 --精力丹ID
COMIC_ENERGY_ID = 200076 -- 漫画体力丹

SKILL_LIMIT_DESC = 
{
    ["skill_limit1"] = getLang("普通攻击"),
    ["skill_limit2"] = getLang("狂暴类技能"),
    ["skill_limit3"] = getLang("大伤害类技能"),
    ["skill_limit4"] = getLang("根据己方损失生命给予伤害类技能"),
    ["skill_limit5"] = getLang("根据敌方当前生命给予伤害类技能"),
    ["skill_limit6"] = getLang("根据敌方总生命给予伤害类技能"),
    ["skill_limit7"] = getLang("根据敌方损失生命给予伤害类技能"),
    ["skill_limit8"] = getLang("吸血类技能"),
    ["skill_limit9"] = getLang("根据己方当前生命治愈类技能"),
    ["skill_limit10"] = getLang("根据己方总生命治愈类技能"),
    ["skill_limit11"] = getLang("根据敌方当前生命治愈类技能"),
    ["skill_limit12"] = getLang("根据敌方总生命治愈类技能"),
    ["skill_limit13"] = getLang("神圣类技能"),
    ["skill_limit14"] = getLang("复制类技能"),
}

-- 背包类型
-- 1：道具  
-- 2：资源  
-- 3：矿石  
-- 4：矿工道具
BAG_VIEW_TYPE = {
    ITEM  = 1,
    RES   = 2,
    ORE   = 3,
    TOOLS = 4,
    HERO_CHIP = 5,
    NO_DISPLAY = 6
}

--背包扩充类型
BAG_EXTEND_TYPE = {
    NORMAL = 1, --普通背包
    ADVENTURE = 2 --冒险背包
}

MONOPOLY_DICE_ID = 103331 --骰子id

--大富翁格子类型
MONOPOLY_GRID_TYPE = {
    MONOPOLY_GRID_GOLD      = 1,    -- 金币
    MONOPOLY_GRID_CASH      = 2,    -- 钻石
    MONOPOLY_GRID_PROBLEM   = 3,    -- 问号
    MONOPOLY_GRID_GIFT      = 4,    -- 礼包
    MONOPOLY_GRID_ADVANCE   = 5,    -- 前进
    MONOPOLY_GRID_COMMON    = 6,    -- 普通
}

--大富翁积分类型
MONOPOLY_SCORE_ADD_TYPE = {
    MONOPOLY_SCORE_ADD_THROWSIEVE = 1,  -- 掷骰子
    MONOPOLY_SCORE_ADD_CIRCLE = 2,      -- 一圈
}

--奖励预览界面打开方式
ACTIVITY_PREV_TYPE = {
    LIMIT_HERO = 1, --限时英雄
    CARNIVAL_RICH = 2, --大富翁
    GODBLESS = 3,   -- 神之祝福
    DIV_HERO_CAL = 4, --神将召唤
    WORK_SHOP = 5,  --秘境工坊
    SLOT_MACHINE = 6, --幸运老虎机
    LUCKY_CAT = 7, --开运招财猫
    SPIRIT_TEMPLE = 8, --英灵殿
}

HELP_FUNC = {
    FRIEND            = 1,  -- 好友
    TEMPLE            = 2,  -- 英雄神殿
    MINING            = 3,  -- 矿区
    MERCENARY_FIRE    = 5,  -- 批量解雇
    SET_ROLE          = 6,  -- 修改主角
    SET_FEATURE       = 7,  -- 修改形象
    ACTIVITY_MONOPOLY = 8,  -- 大富翁
    PLAYER_FORMATION  = 9,  -- 其他玩家阵容界面
    WAKEUP            = 10, -- 觉醒
    STRENGHTHEN       = 12, -- 强化
    LEADERSTRENGTHEN  = 13, -- 主角强化
    TREASURE          = 14, -- 宝具
    CONTRACT          = 15, -- 进阶
    GUILD             = 17, -- 公会
    HERO_BAR          = 18, -- 英雄兑换
    EQUIPMENT_DETAIL  = 19, -- 装备详情
    DREAMLAND         = 20, -- 秘境
    EQUIPMENT         = 22, -- 装备
    TALENT            = 23, -- 天赋
    CHALLENGE         = 24, --英雄试炼
    GUILD_BOSS        = 25, -- 公会BOSS
    ACTIVITY_MARCH    = 26, -- 抽卡行军
    SLOT_MACHINE      = 27, -- 幸运老虎机
    RUNE_EQUIP        = 28, --装备符文
    WORK_SHOP         = 30, -- 秘境工坊
    GOLBAL_CAMP_BAT   = 31, -- 世界大战
    WORLD_BOSS        = 32, -- 世界boss
    RUNE_VIEW         = 33, -- 符文
    EXPEDITION        = 34, -- 远征
    LUCKY_CAT         = 35, -- 招财猫
    REBATE_FUND       = 36, --返利基金
    GOLBAL_GUILD_BAT  = 37, --公会战
    HIGH_CONTRACT     = 38, --高级进阶
    THEME_PASS        = 39, --主题关卡
    ELITE_ADVENTURE   = 40, --精英挑战
    IDENTITY_BINDING_HELP   = 42, --实名认证
    TREASURE_TRANSFORM  = 43,
    HERO_TRANSFORM      = 44,
    TREASURE_EXCHNAGE = 46, --宝具兑换
    MINING_TASK         = 47,   -- 挖矿任务
    MONEY_FLY         = 48, --让红包飞
    GMW                 = 49,   -- 矿区争霸
    GMW_RANK            = 50,   -- 矿区争霸排行榜
    SOUL_STONE          = 51,
    SOUL_STONE_TOWER            = 52,   -- 魂石魔塔
    LIMIT_MARCH         = 53,   -- 遗迹探秘
    GLOBAL_ARENA        = 54,   -- 巅峰对决
    SOUL_STONE_ONE_KEY_EQUIP = 55,   -- 魂石一键装备
    GEM_LOFT            = 56,   -- 珍宝阁
    KILLING_THOUSANDS   = 57,   -- 千人斩
}

-- 限购 描述
LIMIT_DESC = {
    [1] = getLang("剩余"),
    [2] = getLang("本日"),
    [3] = getLang("本周"),
    [4] = getLang("赛季"),
}


COMMENT_TYPE = {
    HERO = 1,
    ELITE_ADVENTURE = 2,
    CHALLENGE = 3,
    -- ADVENTRUE = 1,
}


--图鉴界面打开方式
LIBRARY_OPEN_TYPE = {
    NORMAL = 1, --默认图鉴
    RECRUIT = 2, --召唤预览
    CAMPAIGN_RULE = 3, --空岛之战
}

GODBLESS_TYPE = {
    FREE = 1,
    ONCE = 2,
    TEN = 3,
}

WORK_SHOP_TYPE = {
    ITEMONCE = 1,
    ITEMTEN = 2,
    PAYONCE = 3,
    PAYTEN = 4,
}


EQUIP_PART = {
    WEAPON   = 1,   -- 武器
    HAT      = 2,   -- 帽子
    CLOTHES  = 3,   -- 衣服
    SHOES    = 4,   -- 鞋子
    ALL      = 5,   -- 全部
}



EQUIP_PART_NAME = {
    [EQUIP_PART.WEAPON]   = getLang("武器"),
    [EQUIP_PART.HAT]      = getLang("帽子"),
    [EQUIP_PART.CLOTHES]  = getLang("衣服"),
    [EQUIP_PART.SHOES]    = getLang("鞋子"),
    [EQUIP_PART.ALL]      = getLang("全部"),
}


-- 装备的品质
EQUIP_QUALITY = {
    GREEN  = 1,
    BLUE   = 2,
    PURPLE = 3,
    GOLD   = 4,
    RED    = 5,
}


-- 装备的品质 对应的 英雄的品质
EQUIP_TO_ITEM_QULITY = {
    [EQUIP_QUALITY.GREEN]  = 2,
    [EQUIP_QUALITY.BLUE]   = 3,
    [EQUIP_QUALITY.PURPLE] = 4,
    [EQUIP_QUALITY.GOLD]   = 5,
    [EQUIP_QUALITY.RED]    = 8,
}


EQUIP_QUALITY_NAME = {
    [1] = getLang("绿色装备"),
    [2] = getLang("蓝色装备"),
    [3] = getLang("紫色装备"),
    [4] = getLang("橙色装备"),
    [5] = getLang("红色装备"),
}


EQUIP_QUALITY_COLOR_NAME = {
    [1] = getLang("绿色"),
    [2] = getLang("蓝色"),
    [3] = getLang("紫色"),
    [4] = getLang("橙色"),
    [5] = getLang("红色"),
}

EQUIP_DETAIL_VIEW_SHOW_NAME = {
    [1] = getLang("装备详情"),
    [2] = getLang("装备强化"),
    [3] = getLang("装备详情"),
    [4] = getLang("装备升级"),
    [5] = getLang("装备详情"),
    [6] = getLang("装备详情"),
}


EQUIP_DETAIL_VIEW_TYPE = {
    DETAIL   = 1,   -- 有卸下、强化、升级、更换按钮 的详情面板
    STRENGTH = 2,   -- 强化面板
    PREVIEW  = 3,   -- 只有确定按钮的详情面板
    LEVELUP  = 4,   -- 升级界面
    STRENGTHLEVELUP  = 5,   -- 有强化升级没有装备和卸下更换的面板
    ITEM     = 6,   -- 奖励预览显示
}

EQUIP_LIST_NODE_VIEW_TYPE = {
    EQUIP       = 1,  -- 装备面板
    STRENGTH    = 2,  -- 强化面板
    RESOLVE     = 3,  -- 分解面板
    REVERT      = 4,  -- 还原面板
}

EQUIP_NODE_VIEW_TYPE = {
    NORMAL           = 1,   -- 正常 显示全部
    SIMPLE           = 2,   -- 简单 只显示 背景框，Icon，星星
    SIMPLE_NAME      = 3,   -- 2的基础上 显示名字
    SIMPLE_FORMATION = 4,   -- 2的基础上 去掉闪烁的+ 查看玩家阵容使用
    EMPTY            = 5,   -- 空
    PREVIEW          = 6,   -- 预览
}

-- 筛选用的页面类型
PAGE_TYPE = {
    ITEM_FILTER_PAGE        = 1,
    MERCENARY_FILTER_PAGE   = 2,
}
-- vip页面重构需要 zhaolu
COLOR = {
    VIP_BTN_NORMAL     = "FFEA98",
    VIP_BTN_GRAY       = "695E36",
}

-- 符文的品质
RUNE_QUILITY = {
    WHITE  = 1,
    GREEN  = 2,
    BLUE   = 3,
    PURPLE = 4,
    GOLD   = 5,
}

-- 符文的品质 对应的 英雄的品质
RUNE_TO_ITEM_QULITY = {
    [RUNE_QUILITY.WHITE]  = 1,
    [RUNE_QUILITY.GREEN]  = 2,
    [RUNE_QUILITY.BLUE]   = 3,
    [RUNE_QUILITY.PURPLE] = 4,
    [RUNE_QUILITY.GOLD]   = 5,
}

-- 符文类型
RUNE_TYPE = {
    ATTACK_FIRST    = 1,
    EARTH           = 2,
    LIFE            = 3,
    OTHER           = 4,
}

--战斗属性说明界面标签
COVER_VIEW_TYPE = {
    FIRE      = 1,
    EARTH     = 2,
    WATER     = 3,
    LIGHT     = 4,
    LIFE      = 5,
    ATTACK    = 6,
    DEFENSE   = 7,
    ONEHIT    = 8,
    TOUGHNESS = 9,
    DOUBLEHIT = 10,
    SHIELD = 11,
}

-- 召唤概率界面类型
PROBABILITY_VIEW_TYPE = {
	LIMIT_HERO     = 1, -- 神将召唤
	HERO_MAGIC     = 2, -- 英雄秘术召唤
	TREASURE       = 3, -- 宝具召唤
    TREASURE_MAGIC = 4, -- 宝具秘术召唤
}

-- 主题关卡 任务&商店 界面类型
THEME_TASK_SHOP_VIEW_TYPE = 
{
    PASS_PAGE = 1,
    DAILY_PAGE = 2,
    RECHARGE_PAGE = 3,
    CUSTOM_PAGE = 4,
    SHOP_PAGE = 5,
}

-- 战斗中目标的状态
BATTLE_STATE_TARGET = 
{
    BLEEDING = "b",     -- 流血
    POISONING = "p",    -- 中毒
    DODGE = "d",        -- 闪避
    SILENT = "s",       -- 沉默
    WEAK = "w",         -- 虚弱
    IMPRISON = "i",     -- 封印
}

-- 战斗对话类型
DIALOG_STYLE = 
{
    CHAPTER_STYLE = 1, -- 章节开始剧情
    BATTLE_BEGIN = 2,  -- 战斗开始剧情
    BATTLE_END = 3,    -- 战斗结束剧情
    CHAPTER_END = 4,   -- 章节结束剧情
    BATTLE_MIDWAY = 5, -- 战斗中间剧情
}

-- 功能开启条件类型
COMMON_REWARD_DIALOG_SPECIAL_TYPE = 
{
    DISABLE_CLICKED = 1,   -- 物品不可点击
}

-- 功能开启条件类型
FUNC_OPEN_TYPE = 
{
    PLAYER_LEVLE = 1,   -- 玩家等级
    STAGE_PASS = 2,     -- 通过关卡
}

ONE_DAY = 24 * 60 * 60

-- 活动类型
ACTIVITY_TYPE = 
{
    NEWBIE = 1,
    NORMAL = 2,
}

-- 新手活动显示类型
NEWBIE_SHOW_TYPE = {
    NO_SHOW = -1,
    ON_MAIN = 1,
    IN_ACTS = 2,
}

-- 英雄品质
QUALITY_COLOR_NAME = 
{
    [1] = getLang("白色"), 
    [2] = getLang("绿色"), 
    [3] = getLang("蓝色"), 
    [4] = getLang("紫色"), 
    [5] = getLang("橙色"),
}

NORMAL_SKILL = 
{
    [1000001] = true,
    [1000002] = true,
}