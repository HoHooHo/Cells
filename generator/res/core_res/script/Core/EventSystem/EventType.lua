module("EventType", package.seeall)

local EVENT_START = 0
local function getNext(  )
	EVENT_START = EVENT_START + 1
	return EVENT_START
end

ON_GAME_MIXLOGIN              	   = getNext()

GAME_ENTER_BACKGROUND              = getNext()


BACK_HOME                          = getNext()
BACK_VIEW                          = getNext()	-- 关闭当前的ViewLogic
BACK_TO_X_VIEW                     = getNext()	-- 返回到 某个指定的ViewLogic

BACK_VIEW_BEFORAE_LOGIN 			= getNext()

MAIN_MENU_EVENT                    = getNext()	-- 主菜单 和 其返回按钮 是否显示的计数事件

MAIN_UI_HEAD                       = getNext()

NEW_DAY                            = getNext()

ACCOUNT_OK                         = getNext()
ON_PLATFROM_ACCOUNT_LOGIN          = getNext()
ON_GOTO_ENTER_GAME				   = getNext()
ON_GAMECENTER_ACCOUNT_LOGIN        = getNext()

BG_GRAY_EVENT                      = getNext()	-- LevelX 半透背景 和 通用Dialog的半透控制

LAST_REGION                        = getNext()
REGION_LIST                        = getNext()
RECOMMAND_REGION                   = getNext()

TOURIST_BIND                       = getNext()    -- 游客绑定成功
MAIL_BIND                          = getNext()    -- 邮件绑定成功
MAIL_BIND_MODIFY                   = getNext()    -- 邮件绑定修改
MAIL_BIND_CHECK                    = getNext()    -- 邮箱绑定查询
ACCOUNT_MODIFY_PASSWORD            = getNext()    -- 修改密码

ON_LOGIN_SHOW                      = getNext()    -- 登录游戏时 可能要求按顺序显示某些界面


XDEBUG_SKIP                        = getNext()
XDEBUG_BOSS                        = getNext()
XDEBUG_SAVE_BATTLE                 = getNext()


SWALLOW_TOUCH_PANEL                = getNext()	  -- 控制吞噬触摸屏蔽层的显隐



GUIDE_TEST                         = getNext()

GUIDE_ENTER                        = getNext()		-- 在新手引导时，有些滑动需要屏蔽
GUIDE_EXIT                         = getNext()

GUIDE_TRY	                       = getNext()
GUIDE_WANNA                        = getNext()
GUIDE_NEXT                         = getNext()
GUIDE_END                          = getNext()
GUIDE_GOON                         = getNext()
GUIDE_TALK_INIT                    = getNext()
GUIDE_TALK_ENTER                   = getNext()
GUIDE_TALK_EXIT                    = getNext()
GUIDE_TALK_HIDE                    = getNext()


GUIDE_SPECIAL                      = getNext()

GUIDE_INTERRUPT                    = getNext()	-- 触发beTop后 可能会有弹框 影响引导步骤。所以 当有弹窗时，抛出中断一次的事件，不触发引导

GUIDE_INGAME						= getNext()


BATTLE_ENTER                       = getNext()
BATTLE_EXIT                        = getNext()
BATTLE_REAL_EXIT                   = getNext()		--战斗窗口完全关闭后的回调，用于通知战斗外的模块战斗已结束

BATTLE_START                       = getNext()
BATTLE_ROUND                       = getNext()
BATTLE_ACTION                      = getNext()
BATTLE_REAL_ACTION				   = getNext()
BATTLE_ATTACK                      = getNext()
BATTLE_ATTACK_END                  = getNext()
BATTLE_END                         = getNext()
BATTLE_ROUND_END                   = getNext()
BATTLE_RESULT                      = getNext()
BATTLE_START_SPINE                 = getNext()
BATTLE_STOP_SPINE                 	= getNext()
BATTLE_KR_START_SPINE				= getNext()
BATTLE_KR_STOP_SPINE                 = getNext()
BATTLE_SKIP_VISIBLE                = getNext()
BATTLE_REPLAY_VISIBLE				= getNext()
BATTLE_SPEED_UP						= getNext()
BATTLE_SPEED_REFRESH				= getNext()
BATTLE_SHOW_EXIT					= getNext()
BATTLE_SHOW_RESULT					= getNext()
BATTLE_ANIM_PLAY					= getNext()
BATTLE_ANIM_STOP					= getNext()
BATTLE_INIT_RST_INFO				= getNext()
BATTLE_SKIP_INTERRUPT				= getNext()
BATTLE_SPEC_SHOW					= getNext()		-- 特殊类型的战斗结算效果的出现
BATTLE_APPEAR						= getNext()		-- 战斗中人物出现
BATTLE_REPLACE_ROLE					= getNext()		-- 战斗中人物变身
BATTLE_CLOSE_VIEW					= getNext()
BATTLE_KR_SKILL_EFFECT				= getNext()

BATTLE_ATTACK_ANIM_START           = getNext()
BATTLE_ATTACK_FLOW_SCENE_EFFECT         = getNext()
BATTLE_ATTACK_FLOW_ROLE_CAST_ACTION     = getNext()
BATTLE_ATTACK_EFFECT_ROLE_CAST_ACTION_END = getNext()
BATTLE_ATTACK_EFFECT_BEHIT         = getNext()
BATTLE_ATTACK_FLOW_ACTION_END           = getNext()
BATTLE_ATTACK_ANIM_END             = getNext()

BATTLE_COMBO                       = getNext()
BATTLE_TARGET_STATE					= getNext()

BATTLE_REPLAY                      = getNext()
BATTLE_ON_REPLAY                   = getNext()

BATTLE_SPEED                       = getNext()
BATTLE_UI_ROUND                    = getNext()
BATTLE_UI_POWER                    = getNext()
BATTLE_UI_SHIELD				   = getNext()
ON_HIT_STATE                   	   = getNext()
REFRESH_PROP						= getNext()
ON_END_STATE            		   = getNext()
ON_ROUND_END            		   = getNext()
SUMMONING_MONSTER_ROUND            = getNext()
SUMMONING_MONSTER_ACTION           = getNext()
SUMMONING_MONSTER_ANIM             = getNext()

BATTLE_SHAKE                       = getNext()

BATTLE_HERO_ATT_DEF_UP				= getNext() -- 战斗中英雄的攻击和防御提升

BATTLE_DEBUG                       = getNext()	-- 当服务器与客户端战斗过程数据不一致时，抛出此事件，方便打印log

BATTLE_BG_PLAY						= getNext()	-- 战斗背景变换 开始
BATTLE_BG_STOP						= getNext()	-- 战斗背景变换 结束
BATTLE_HEAL_UNDER_PLAY				= getNext() -- 战斗位于英雄下层的回血技能 播放

BATTLE_SPINE_EVENT_MOVE            = getNext()
BATTLE_SPINE_EVENT_BEATEN          = getNext()
BATTLE_SPINE_EVENT_FINISH          = getNext()

BATTLE_COMBINATION_SKILL_END		= getNext()

BATTLE_HERO_PROP_UP_ACTION			= getNext()

BATTLE_RUN_ACTION					= getNext()

BATTLE_HERO_CLEAR_CD 				= getNext()

ENTER_EQUIP_LIST                  = getNext()

ON_EQUIP_SET_OK                    = getNext()
ON_EQUIP_DATA_UPDATE               = getNext()	-- 装备数据有变化时 抛出此事件

ON_EQUIP_MATERIALS_UPDATE          = getNext()	-- 装备锻造材料数量有变化时 抛出此事件


-- 某些情况，菜单栏顶部的金币、经验、钻石 需要等某些操作完成之后再执行刷新操作
-- 所以先抛出 MAIN_MENU_TOP_BAR_DELAY_REFRESH 使其在接收到ID_DsePlayerData消息时不刷新数据
-- 等操作完成之后 抛出 MAIN_MENU_TOP_BAR_REFRESH 进行刷新 同时解除对ID_DsePlayerData消息的屏蔽
MAIN_MENU_TOP_BAR_DELAY_REFRESH = getNext()
MAIN_MENU_TOP_BAR_REFRESH       = getNext()


HERO_DEVELOPER_ROLE_SELECT         = getNext()
HERO_DEVELOPER_ROLE_TIPS			= getNext()

BAG_ITEM_SELL_EVENT 				= getNext()


ADVENTURE_COLLECT                  = getNext()
ON_GET_ADVENTURE_PROP_DROP                  = getNext()

POWER_CHANGED                      = getNext()
REFRESH_POWER_KPS                  = getNext()
COLLECT_EFFECIENCY_CHANGED		   = getNext()	--金币经验采集效率改变
ONLINE_TIME_LIMIT_TIP			   = getNext()	--防沉迷在线时间提醒

MAIN_MENU                          = getNext()
MAIN_TAB                           = getNext()

PLAYER_HEAD_CHANGED 			= getNext() --修改头像


AD_IDLE_HERO_ATTACK              = getNext()
AD_IDLE_MONSTER_BEATEN              = getNext()
AD_IDLE_MONSTER_DEAD              = getNext()


CHAT_LAYER_VISIBLE                 = getNext()
ON_CHAT_LAYER_VISIBLE_EVENT        = getNext()
CHAT_MSG 						   = getNext() --聊天数据
CHAT_MSG_LOG 					   = getNext() --上线推送过来的聊天数据

CHAT_BUBBLE 					   = getNext()
CHAT_TIPS						   = getNext()
CHAT_REFRESH_BLACKLIST			   = getNext()

RECRUIT_LIST_TO_TOP				   = getNext()
RECRUIT_LIST_TO_BOTTOM			   = getNext()


EXPEDITION_REFRESH				   = getNext()
EXPEDITION_SEARCH 				   = getNext()
EXPEDITION_ENTER_REFRESH		   = getNext()


CARDS_CELL_TOUCH                   = getNext()
CARDS_MERCENARY_FOLLOW_DRAG        = getNext()
CARDS_CELL_MOVEING                 = getNext()
CARDS_CELL_TOUCHEND                = getNext()
CARDS_POSITION_RESET               = getNext()
CARDS_FORMATION_TOP_REFRESH        = getNext()
CARDS_DRAG_NODE                    = getNext()
CARDS_CELL_EQUIP                   = getNext()
CARDS_FORMATION_DSEREFRESH         = getNext()
CARDS_CELL_SELECT_IMG              = getNext()
FORMATION_RENAME                   = getNext()
FORMATION_FIRE_CELL_CLICK          = getNext()
FORMATION_FIRE_REFRESH             = getNext()
FORMATION_TIPS_VISIBLE             = getNext()
FORMATION_PAGE_CHANGE              = getNext()
FORMATION_NODE_TXT_VISIBLE         = getNext()
FORMATION_NODE_REFFRESH            = getNext()
FORMATION_NODE_CAN_TOUCH           = getNext()

FATALISM_WEAPON_CLICK              = getNext()
FATALISM_WEAPON_UPDATE             = getNext() -- 传说武器更新
JUMP_TO_VIEWLOGIC                  = getNext() -- 界面跳转
MERCENARY_BASE_UPDATE              = getNext() -- 英雄养成更新
TRANSMIGRATION_CHOOSE              = getNext() -- 英雄能力转换
TEMPLE_UPDATE                      = getNext() -- 英雄神殿数据更新
TRANSMIGRATION_SUCCESS             = getNext() -- 能力转化成功
LEADER_FATALISM_WEAPON_ADD         = getNext() -- 传说武器增加
PLAYER_DATA_UPDATE                 = getNext() -- 玩家信息更新

UPDATE_REMIND_TIP                  = getNext() -- 绿点提醒

MODEL_CHANGE_SELECTED              = getNext() -- 点击更换形象 
MODEL_UPDATE_SUCCESS               = getNext() -- 更换形象成功
HERO_PROMOTION_LEVELUP             = getNext() -- 英雄升级
HERO_PROMOTION_LEVELUP_CLIENT      = getNext() -- 客户端处理的 英雄升级

MINE_REFRESHALL                    = getNext()	--刷新全部矿的数据
MINE_REFRESHUPDATE                 = getNext()	--刷新矿的数据, 只刷新修改了的部分
MINE_DIG                           = getNext()
MINE_COLLECT                       = getNext()	
MINE_PIXAXE_CHANGE                 = getNext()	--矿稿数量变化
MINE_PIXAXE_CHANGE_SERVER 	       = getNext()	--服务端推来的矿稿数据变化，本地计算增长时不抛出此事件
MINE_USETNT                        = getNext()
MINE_REFRESHAREA                   = getNext()
MINE_CLOSEREFRESH                  = getNext()
MINE_CURRENTBLOCK 				= getNext()
MINE_GOLEM_DATA = getNext()
MINE_CHEST_DATA = getNext()
MINE_JUMP_POSITION = getNext()					--让地图跳转到某个坐标
MINE_SHAKE_GOLEM = getNext()					--有怪没打时晃动
MINE_MAX_DEPTH = getNext()	
MINE_PIXAXE_FULL = getNext()	--矿稿有没有满	
MINE_DIG_TIMEOUT				= getNext()	-- 矿石挖掘完成
MINE_THUMBNAIL_FILTER = getNext()
MINE_ROLE_DIG			= getNext()
MINE_ROLE_IDLE			= getNext()
MINE_TNT_LEFT			= getNext()
MINE_TNT_RIGHT			= getNext()
MINE_TIME_UP			= getNext()
MINE_TIME_DOWN			= getNext()
MINE_TASK_REFRESH		= getNext()
MINE_TASK_CLOSE			= getNext()
MINE_TASK_TIPS			= getNext()

PROJECT_DATA_CHANGED = getNext()
PROJECT_VIEW_TOUCH_NODE = getNext()
PROJECT_FINISHED = getNext() --工程有没有有可以收的

BAG_UPDATE        		= getNext()	--更新背包数据；
BAG_SELECTNODE     		= getNext()	--背包选择物品；
ON_BAG_EXTEND     		= getNext()	--背包选择物品；

UPDATE_MAIL_TIPS  		= getNext()	--邮件绿点 更新状态
UPDATE_MAIL_NODE		= getNext()	--刷新邮件数据

NOTICE_MAINUI_UPDATE = getNext()    --控制主界面绿点显示
NOTICE_ACTIVITY_UPDATE = getNext()  --控制活动页绿点显示
BUTTON_MAINUI_UPDATE = getNext()	--控制主界面按钮显示
BUTTON_ACTIVITY_UPDATE = getNext()	--控制活动按钮显示

ON_ACTIVITY_TAB = getNext()	--活动按钮点击后 刷新状态

SHOP_DATA_UPDATE = getNext() --商店数据更新；


AWARD_CENTER_RELOAD = getNext() --领奖中心 刷新TableView

CHANGE_BATTLE_FORMATION = getNext() --不同玩法切换阵容
QUICK_EXPLORE_REFRESH = getNext() --快速探索次数刷新
ADVENTURE_BATTLE_WIN = getNext() --推图战斗胜利
ADVENTURE_EVENTVIEW_COST_UPDATE = getNext() --战斗事件界面消耗刷新
ADVENTURE_EXPLORE_DROP_REFRESH = getNext() --探索结果界面刷新
ADVENTURE_DATA_REFRESH = getNext() --冒险数据刷新
ADVENTURE_CHALLENGE_UPDATE = getNext() --精英挑战数据刷新
ADVENTURE_EXP_GOLD_UPDATE = getNext()
ADVENTURE_BUTTON_SPINE	= getNext()	-- 推图界面，按钮播放动画

DAILY_REFRESH_MISSION = getNext() -- 日常任务刷新
DAILY_REFRESH_GIFTNODE = getNext()	-- 刷新活动度node
DAILY_REFRESH_CHECKIN = getNext() -- 刷新签到
DAILY_REFRESH_PRAY	= getNext() -- 刷新祈祷界面
DAILY_REFRESH_AUTO = getNext() -- 自动刷新

COMMENT_OPEN = getNext() -- 打开评论
COMMENT_REFRESH = getNext() -- 刷新评论
CAVE_DATA_CHANGED = getNext()
FRIEND_REFRESH = getNext()
FRIEND_REFRESH_NOTICE = getNext()

SOUL_STONE_TOWER_EVENT = getNext()

GOLD_SUPPLY_REFRESH = getNext()
GOLD_SUPPLY_REFRESH_NOTICE = getNext()
GOLD_SUPPLY_REFRESH_DIG = getNext()

ACTIVITY_REFRESH = getNext() -- 活动刷新
YOU_CHOOSE_REFRESH = getNext() --你选我送刷新
BOX_SUPER_REFRESH = getNext() -- 宝箱/超级 大兑换
CHARGE_GIFT_REFRSH = getNext() -- 超值礼包
TREASURE_CALL_UPDATE = getNext() -- 宝具召唤
HIGH_CONTRACT_REFRSH = getNext() -- 高级进阶
LIMTI_CHARGE_GIFT_REFRSH = getNext() -- 限定礼包

SDK_Facebook_Login = getNext() -- facebook 登录
SDK_NativePlatform_Login = getNext() -- googleplay

ARENA_LIST_REFRESH = getNext() --竞技场列表刷新
ARENA_NODE_REFRESH = getNext() --PVP-竞技场节点重置时间刷新
ARENA_NOTICE_UPDATE = getNext() --PVP-竞技场节点绿点提示
FUNCSWITCH_CHANGED = getNext()	--funcswitch数据改变
FUNCSWITCH_OPEND = getNext()	--某个活动开始
FUNCSWITCH_CLOSED = getNext()	--某个活动结束
NEWBIE_FUNCSWITCH_CLOSED = getNext()	--某个新手活动结束
ROLLHERO_CHANGED = getNext()	--召唤数据改变
RECRUIT_ITEM_DROP = getNext()	--使用英雄包的掉落结果
RECRUIT_DROP = getNext() 		--打开抽卡界面
RECRUIT_CLOSE_NEW_DIALOG = getNext()	--关闭抽卡结果框
RECRUIT_MAGIC_SHOW = getNext()	--关卡足够开启秘术召唤
RECRUIT_GENRN_REFRESH = getNext() -- 流派抽卡刷新
HEROBAR_DATA = getNext()		--英雄酒馆数据
HEROBAR_NODESELECT = getNext()

CAMPAIGN_DATA = getNext()			--空岛之战数据改变
CAMPAIGN_RANK_DATA = getNext()		--空岛之战排行榜数据改变 
CAMPAIGN_BUY_BUFF = getNext()		--空岛之战购买buff成功
CAMPAIGN_SEASON_CHANGED = getNext()	--空岛之战赛季状态改变

ACHIEVEMENT_DATA = getNext()		--成就数据改变
ACHIEVEMENT_TOTALREWARD = getNext()		--成就总奖励数据改变

JUMP_REBIRTH_BOSS = getNext()		--挖矿菜单页跳转到重生boss位置
JUMP_CAVE_EXPLORE = getNext()		--挖矿菜单页跳转到地下探险位置
JUMP_AUTOBATTLE = getNext()			--冒险打开自动战斗
JUMP_ADVENTURE_EXPLORE = getNext()			--冒险打开探索结果
JUMP_RECRUIT_TAB = getNext() --跳转到英雄召唤或者宝具召唤页签

GUILD_DATA_CHANGED = getNext()	--公会数据改变
GUILD_MEMBER_CHANGED = getNext()	--公会成员改变
GUILD_ROLE_CHANGED = getNext()		--自己的公会身份改变
GUILD_AUDIT_CHANGED = getNext()
GUILD_LIST_CHANGED = getNext()
GUILD_APPLY_CHANGED = getNext()
GUILD_LOG_CHANGED = getNext()
GUILD_CONTRIBUTION_LOG_CHANGED = getNext()
GUILD_CREATE = getNext()
GUILD_NEWLOG_CHANGED = getNext()		--最新一条公会通知改变
GUILD_JOINED = getNext()				--加入公会成功

FIRSET_RECHARGE_CHANGED = getNext()		--首冲
PLAYER_NAME_CHANGED = getNext()		--玩家改名
PEDESTAL_CHANGE_REFRESH	= getNext() -- 底座修改
MONTH_CARD_UPDATE_UI	= getNext()	-- 月卡周卡刷新
PAYMENT_UI_CLOSE	= getNext()
CHAT_FRAME_CHANGE_REFRESH	= getNext() -- 聊天背景框修改

RANK_DIALOG_SHOW = getNext()		--排行界面限时或隐藏
REWARD_DIALOG_SHOW = getNext()		--奖励界面显示或隐藏
LIMIT_HERO_DATA = getNext()
LIMIT_GODBLESS_DATA = getNext()
LIMIT_GODBLESS_AGAIN = getNext()
DIV_HERO_CAL_UPDATE = getNext()     -- 神将召唤
LIMIT_WORKSHOP_DATA = getNext()
LIMIT_WORKSHOP_AGAIN = getNext()
LIMIT_WISH_REFRESH = getNext()

SEVENDAY_REWARD_DATA = getNext()		
SEVENDAY_LABEL_GREENPOINT = getNext()		
COMMON_LIMIT_DATA = getNext()
COMMON_EXCHANGE_DATA = getNext()
COMMON_LIMIT_NEWBIE_DATA = getNext()
EVERYDAY_PAY_DATA = getNext()
CYCLE_RECHAREGE_DATA = getNext()
HALFMONTH_REWARD_DATA = getNext()
HALFMONTH_LABEL_GREENPOINT = getNext()

RANK_BATTLE_VIEW_REFRESH = getNext() --排位赛界面刷新
RANK_BATTLE_TIME_UPDATE = getNext() --排位赛倒计时刷新
RANK_BATTLE_CHALLENGE_TIME = getNext() --排位赛挑战次数
RANK_BATTLE_TOPTEN_REFRESH = getNext() --排位赛世界排名刷新
HERO_UPGRADE_REFRESH = getNext() --英雄数据发生变化时，刷新出阵阵容界面显示

TRY_HERO_WAKEUP_GUIDE = getNext()	-- 英雄升到30级的时候 有可能需要触发新手引导

LIMIT_SHOP_DATA_REFRESH = getNext() --限时商城数据刷新
CARNIVAL_RICH_DATA_REFRESH = getNext() --大富翁数据刷新
CARNIVAL_RICH_CELL_MOVE = getNext() --大富翁摇一次
CARNIVAL_RICH_CELL_MOVE_EXTRAL = getNext() --大富翁摇一次额外前进几步
CARNIVAL_RICH_NUM_REFRESH = getNext() --次数刷新
CARNIVAL_RICH_EIGHT = getNext() --大富翁摇8次
CARNIVAL_DOUBLE_CLOSE = getNext()
CARNIVAL_CHARGE_REGRESH = getNext() --大富翁奖励预览充值刷新

AUTO_INCREASE_GOLDEXP = getNext() --金币和经验自然增长
PAUSE_RESUME_MAINAUDIO = getNext() --暂停或重新播放主界面音效

DREAMLAND_ENTER = getNext()	-- 进入
DREAMLAND_VIEW_REFRESH = getNext() -- 秘境刷新界面
DREAMLAND_CHANGE_PAGE = getNext() -- 秘境关卡切换
DREAMLAND_THROW_DICE  = getNext() -- 投掷骰子
DREAMLAND_REFRESH_LIST = getNext()-- 刷新事件列表
DREAMLAND_AUTO = getNext()	-- 自动行走
DREAMLAND_NEXT_AUTO = getNext() -- 下一关自动
DREAMLAND_CLOSE = getNext() -- 关闭
DREAMLAND_EVENTHANDLE_CLOSE = getNext() -- 事件处理关闭
DREAMLAND_TIPS	= getNext() -- 绿点
DREAMLAND_SWEEP = getNext() -- 扫荡刷新
DREAMLAND_SWEEP_CLOSE = getNext() -- 扫荡关闭

MARCH_REFRESH = getNext()
MARCH_THROW = getNext()

WORLDBOSS_REFRESH_BASEDATA = getNext() -- 刷新基础数据
WORLDBOSS_REFRESH_BOSSDATA = getNext() -- 刷新boss数据
WORLDBOSS_REFRESH_NOTICE = getNext() -- 刷新绿点
WORLDBOSS_ENTER = getNext() -- 进入

LIMIT_LUCKY_WHEEL = getNext() --幸运大转盘

-- zhaolu
SLOT_MACHINE_ROLL = getNext() --【活动】幸运老虎机抽奖后刷新页面
SLOT_MACHINE_REFRESH = getNext() --【活动】幸运老虎机刷新页面
SLOT_MACHINE_ANI_END = getNext() --【活动】幸运老虎机转动画面结束回调
HERO_CHIP_FILTER_REFRESH = getNext() -- 关闭背包英雄碎片筛选

RUNE_ROLL_UPDATE_SCENE = getNext() -- 符文场景刷新
RUNE_ROLL_ADD = getNext() -- 符文刷新横划背包
RUNE_REMOULD = getNext() -- 符文改造通知刷新
RUNE_REFRESH_LEVEL_BY_SELECT_RUNE = getNext() -- 符文升级页面，选择符文，刷新绿色加成值
-- RUNE_LVLUP_ITEM_SELECT = getNext() -- 符文升级页面，选择符文，刷新绿色加成值
RUNE_LEVELUP = getNext() -- 符文升级返回刷新页面
RUNE_ORIGINAL = getNext() -- 符文还原
RUNE_SELL = getNext() -- 符文出售
RUNE_SELL_NUM = getNext() --刷新符文出售界面数量
RUNE_BAG_FILTER = getNext() -- 符文背包筛选
RUNE_EQUIP = getNext() -- 符文装备发送消息
RUNE_EQUIP_REFRESH = getNext() -- 符文装备服务器成功返回后刷新装备页面
RUNE_CALL_POPVIEW_CLOSE = getNext() -- 关闭符文多抽弹出框
RUNE_PROMO_UPDATE = getNext() --英雄是否可装备绿点提示 队伍强化
RUNE_CLIENT_LEVELUP_UPDATE = getNext()
RUNE_CHANGE_PAGE = getNext()

--统计相关事件 begin --
TUNE_STATISTICS_LOGIN_SUCCESS = getNext()
TUNE_STATISTICS_PURCHASE = getNext()
TUNE_STATISTICS_REGIST = getNext()
TUNE_STATISTICS_TUTORIAL_COMPLETE = getNext()
TUNE_STATISTICS_DOWNLOAD_COMPLETE = getNext()


ADJUST_STATISTICS_PURCHASE = getNext()            -- 充值
ADJUST_STATISTICS_REGIST = getNext()              -- 注册
ADJUST_STATISTICS_DOWNLOAD_COMPLETE = getNext()   -- cdn加载完成
ADJUST_STATISTICS_CREATE_ROLE = getNext()         -- 创角
ADJUST_STATISTICS_LEVEL_UP = getNext()            -- 升级
ADJUST_STATISTICS_OPEN_PAY = getNext()            -- 打开充值界面
ADJUST_STATISTICS_ClOSE_PAY = getNext()           -- 关闭充值界面
ADJUST_STATISTICS_CLICKED_PAY = getNext()         -- 点击充值档位
--统计相关事件 end --

CHALLENGE_RUSH_VIEW_UPDATE = getNext() --英雄试炼扫荡界面刷新

LIST_FILTER = getNext()

COMMON_COST_UPDATE = getNext()

RANDOMGIFT_OPEN = getNext()
RANDOMGIFT_CLOSE = getNext()
RANDOMGIFT_NEW_OPEN = getNext()
RANDOMGIFT_NEW_CLOSE = getNext()
RANDOM_GIFT_CHANGED= getNext()

EQUIP_TIPS_VISIBLE = getNext()
LIBRARY_TIPS_VISIBLE = getNext()
VIP_SYSTEM_BUYRESULT = getNext()
VIP_SYSTEM_CHARGE_CHANGED = getNext()
VIP_SYSTEM_VIPLEVEL_CHANGED = getNext()
VIP_SYSTEM_VIPDAILY_REWARD = getNext()
VIP_SYSTEM_NEWDAY_CHANGED = getNext()
ONLINE_STRENGTH_REFRESH	= getNext()	--整点体力刷新
MONEY_FLY_UPDATE = getNext() --让红包飞刷新
ACTIVITY_LEVELUP_UPDATE = getNext() -- 升级折扣
LIMIT_GOBLIN_SHOP_REFRESH = getNext()

ACTIVITY_KR_LOGINGIFT_UPDATE = getNext() -- 韩服登录奖励

ARENA_ONE_KEY_CHALLENGE = getNext() --竞技场一键挑战
ARENA_ONE_KEY_STOP_COROU = getNext()

ACTIVITY_EVERYDAY_PAY_DATA = getNext()

ACTIVITY_LOGIN_GIFT_UPDATE = getNext()	--七日登陆ui刷新
ACTIVITY_LOGIN_GIFT_AD_SHOW = getNext()	--七日登陆 等级达成弹广告界面
LEVELUP_VIEW_CLOSE = getNext()	--升级界面关闭

ACTIVITY_MAGIC_HERO_EXCHANGE_UPDATE = getNext()	--奥术抽卡兑换
ACTIVITY_MAGIC_TREASURE_EXCHANGE_UPDATE = getNext()	--神铸之藏兑换

TALENT_DATA_UPDATE = getNext() -- 天赋数据更新

CHALLENGE_OPEN = getNext() --英雄试炼是否开启
STRENGTH_COIN = getNext() --挑战币刷新
CHALLENGE_TIMES = getNext() --挑战次数刷新
CHALLENGE_NODE_UPDATE = getNext() --英雄试炼node刷新
CHALLENGE_BUFF_UPDATE = getNext() --英雄试炼buff刷新
CHALLENGE_GOTO_NEXT = getNext() --英雄试炼人物走到下一关卡
CHALLENGE_DETAIL_UPDATE = getNext() --英雄试炼详情界面刷新
CHALLENGE_NOTICE_UPDATE = getNext() --英雄试炼有可领取三星奖励绿点
CHALLENGE_MAP_UPDATE = getNext() --英雄试炼主界面刷新
CHALLENGE_ENTER = getNext()
CHALLENGE_MAP_SCROLL_TO = getNext() --英雄试炼地图滚动到指定位置
MERCENARY_VIEW_UPDATE = getNext() -- 英雄功能界面更新

COLLECTION_EPIC_UPDATE = getNext() -- 史诗图鉴数据更新
MERC_COLLECT_EPIC_TIPS = getNext() --MercenaryView 界面 史诗图鉴绿点
COLLECTION_EPIC_TIPS = getNext()	-- 史诗图鉴 绿点
COLLE_EPIC_CHECK_TIP = getNext() -- 史诗图鉴检查绿点

ACTIVITY_WORLDBOSS_RANK = getNext() --世界boss排行榜

GLO_CAMP_BAT_M_DATA_UP = getNext() -- 世界大战主数据更新
GLO_CAMP_BAT_ENTER     = getNext() -- 加入世界大战
GLO_CAMP_BAT_AUTO     = getNext() -- 世界大战托管
GLO_CAMP_BAT_SHOW_CD   = getNext() -- 世界大战显示CD
GLO_CAMP_BAT_LOCATION  = getNext() -- 世界大战定位
GLO_CAMP_BAT_DETECT    = getNext() -- 世界大战侦查
GLO_CAMP_SHOW_COMBAT   = getNext() -- 世界大战显示战斗
GLO_CAMP_BAT_RANK      = getNext() -- 世界大战排行榜
GLO_CAMP_BAT_MAIN_MSG  = getNext() -- 世界大战主界面战报
GLO_CAMP_BAT_REFRESH_MSG  = getNext() -- 世界大战刷新战报
GLO_CAMP_BAT_TIME_OUT  = getNext() -- 世界大战活动时间到
GLO_CAMP_BAT_END_ACTI  = getNext() -- 世界大战活动结束
GLO_CAMP_BAT_START_T   = getNext() -- 世界大战下一级比赛开始倒计时事件
GLO_CAMP_BAT_DEA_TIPS  = getNext() -- 世界大战士气为0,回到大本营提示弹窗
GLO_CAMP_BAT_NOTICE_UPDATE = getNext() --世界大战pvp绿点

MILITARY_SUPPLY_UPDATE = getNext() --狂欢派对刷新
MILITARY_SUPPLY_NOTICE = getNext() --狂欢派对绿点
MILITARY_SUPPLY_CARD_UPDATE = getNext() --符文令刷新
MILITARY_SUPPLY_EXCHANGE_NOTICE = getNext() --狂欢派对 限时兑换绿点

TREASURE_FORMATION_UPDATE = getNext() --英雄上下阵、推荐阵容、调整阵容时，刷新对应阵容所有英雄的宝具列表
TREASURE_DETAIL_UPDATE = getNext() --宝具详情界面刷新
TREASURE_DECOMPOSE_UPDATE = getNext() --宝具之魂分解界面刷新
TREASURE_DECOMPOSE_NODE_UPDATE = getNext() --宝具之魂分解界面 node刷新
TREASURE_DECOMPOSE_BATCH_SELECT = getNext() --宝具之魂分解批量勾选
ROLL_TREASURE_CHANGED = getNext()
TREASURE_DECOMPOSE_SELECTED_UPDATE = getNext() --宝具之魂分解界面 选择数量刷新
CLOSE_TREASURE_VIEW = getNext()
CLOSE_TREASURE_DETAIL_VIEW = getNext()
RECRUIT_TREASURE_DROP = getNext()
TREASURE_LEVELUP_CLIENT_UPDATE = getNext()
TREASURE_HERO_UPDATE = getNext() --英雄养成后，刷新该英雄的缓存

TREASURE_EXCHANGE_SELECT_NODE = getNext() --宝具兑换选中
TREASURE_EXCHANGE_PRICE_UPDATE = getNext()	--宝具兑换价格刷新

RANDOM_SHOP_DATA = getNext() -- 随机商店数据

-- 秘宝召唤
TREASURE_MAGIC_SHOW = getNext()	-- 秘宝召唤开启

-- 主题关卡
THEME_PASS_ENTER = getNext() -- 进入主题关卡
THEME_PASS_UI_REFRESH = getNext() -- 刷新主题界面UI
THEME_PASS_LEVEL_VIEW_REFRESH = getNext()	-- 刷新节点详情界面UI
THEME_PASS_CLOSE_STAGE_DETAIL = getNext()	-- 关闭节点详情界面
THEME_PASS_NEW_STAGE_OPEN = getNext()	-- 新的节点开启
THEME_PASS_NEW_CHAPTER_OPEN = getNext()	-- 新的章节开启
THEME_PASS_CHAPTER_CLOSE = getNext()	-- 章节结束
THEME_PASS_NEW_CHAPTER_SHOW_STAGE = getNext()	-- 显示新章节的首个节点
THEME_PASS_TALK_WAIT = getNext()		-- 对话状态置为等待
THEME_TASK_SHOP_UPDATE = getNext()		-- 任务和商店列表刷新
THEME_PASS_GOTO_STAGE = getNext()		-- 前往某一关卡
THEME_PASS_PROP_CNT_REFRESH = getNext()	-- 道具显示数量刷新

-- 战斗对话
PASS_NEXT_TALK = getNext()				-- 下一句对话
PASS_SKIP_TALK = getNext()				-- 跳过对话

HERO_IMAGE_CHANGED = getNext()

REBATE_FUND_UPDATE = getNext()

-- 公会战
GLO_GUI_BAT_MB_SELECT  = getNext() -- 更新成员勾选
GLO_GUI_BAT_DATA 	   = getNext() -- 公会战数据
GLO_GUI_BAT_ENEMY_DATA = getNext() -- 查看敌人
GLO_GUI_BAT_NOTIFY     = getNext() -- 查看公告
GLO_GUI_PALACE_LIST    = getNext() -- 殿堂数据列表
GLO_GUI_BAT_HISTORY    = getNext() -- 历史数据
GLO_GUI_BAT_FIELD_UP   = getNext() -- 战场数据更新
GLO_GUI_BAT_RECORD     = getNext() -- 战报
GLO_GUI_BAT_PROMO_LOG  = getNext() -- 晋级赛战报(放大镜)
GLO_GUI_BAT_WORSHIP_SU = getNext() -- 膜拜成功
GLO_GUI_BAT_NOTICE_UP  = getNext() -- 公会战绿点
GLO_GUI_BAT_TAC_TIP_UP = getNext() -- 公会战战术绿点刷新

--------------------韩国--------------------------
KR_CHANGE_USER         = getNext() --删除角色
KR_CHANGE_ACCOUNT		= getNext() -- 删除账号
Adbrix_Statistics_Purchase = getNext() --统计支付
Adbrix_Statistics_ShowCoupon = getNext() --显示兑换券界面
NaverCafe_Update        = getNext() --NaverCafe
KR_Achievements_OpenView   = getNext() --打开成就界面
KR_Achievements_Complete   = getNext() --完成某一成就
KR_Leaderboard_OpenView   = getNext()  --排行榜打开
KR_Leaderboard_UpdateScore   = getNext() --排行榜积分刷新
BIND_WEB_CALLBACK = getNext()	     	 --kr bindlist绑定列表
--------------------------------------------------


GLOBAL_RANK_DATA_UP = getNext() -- 跨服排行榜数据更新

SUMMONING_MONSTER_DATA = getNext() --召唤兽列表刷新
SUMMONING_MONSTER_LEVELUP_UPDATE = getNext() --召唤兽升级
SUMMONING_MONSTER_CHANGED = getNext() --设置阵容召唤兽

TREASURE_TRANSFORM_NODE_UPDATE = getNext()
TREASURE_TRANSFORM_TEXT_UPDATE = getNext()
TREASURE_TRANSFORM_NODE_RESET = getNext()
TREASURE_TRANSFORM_RANDOM_CONFIRM = getNext()
TRANSFORM_CLOSE_PREV_VIEW = getNext()
TREASURE_TRANSFORM_RANDOM_SUCCESS = getNext()
TRANSFORM_OPEN_PREV_VIEW = getNext()

HERO_TRANSFORM_NODE_UPDATE = getNext()
HERO_TRANSFORM_TEXT_UPDATE = getNext()
HERO_TRANSFORM_NODE_RESET = getNext()
HERO_TRANSFORM_RANDOM_CONFIRM = getNext()
HERO_CLOSE_PREV_VIEW = getNext()
HERO_TRANSFORM_RANDOM_SUCCESS = getNext()
HERO_TRANSFORM_OPEN_PREV_VIEW = getNext()
REFRESH_RECRUIT_GIFT = getNext()


ID_IDENTITY_SUCCESS = getNext()
SET_CAN_SELECT_CELL = getNext()

-- 等级系统
PLAYER_LEVEL_UP 	     = getNext() -- 玩家等级数据更新
OPEN_SERVER_REFRESH_NODE = getNext() -- 刷新开服竞技页面
LEVELUP_SHOW_EXIT		 = getNext() -- 升级界面显示退出提示

-- 英雄养成
REFRESH_DEVELOP_TAB			= getNext()	-- 设置英雄养成界面的显示tab
REFRESH_STRENGTH_NOTICE		= getNext() -- 强化页签的绿点刷新
REFRESH_ADVANCE_NOTICE		= getNext()	-- 进阶页签的绿点刷新
REFRESH_TREASURE_NOTICE		= getNext() -- 宝具页签的绿点刷新
REFRESH_EQUIP_NOTICE		= getNext() -- 装备页签的绿点刷新
REFRESH_RUNE_NOTICE			= getNext() -- 符文页签的绿点刷新
REFRESH_SOUL_STONE_NOTICE	= getNext() -- 魂石页签的绿点刷新
UPDATE_STRENGTH_TIPS		= getNext() -- HeroData缓存更新
UPDATE_ADVANCE_TIPS			= getNext()	-- HeroData缓存更新
UPDATE_TREASURE_TIPS		= getNext() -- HeroData缓存更新
UPDATE_EQUIP_TIPS			= getNext() -- HeroData缓存更新
UPDATE_RUNE_TIPS			= getNext() -- HeroData缓存更新
UPDATE_SOUL_STONE_TIPS		= getNext() -- HeroData缓存更新
REFRESH_ALL_HEROS_NOTICE	= getNext()	-- 刷新所有英雄的绿点
DELETE_HERO_TIPS			= getNext()	-- 删除英雄的绿点数据，解雇后操作

RENEWAL_RECHARGEREWARD 		= getNext() -- 刷新续充奖励数据 
DREAMLAND_THROW_DICE_SWEEP  = getNext() -- 一键扫荡投筛子 

-- 资源宝藏
MINING_RESOURCES_TIP		= getNext()	-- 资源宝藏中，绿点显示更新消息(单项和整体)
MIAN_ARROW_EFFECT_UPDATE	= getNext() -- 主界面，箭头特效显隐刷新
MAIN_ARROW_CLICKED			= getNext() -- 主界面，箭头点击
MAIN_ARROW_ROTATED			= getNext()	-- 主界面，箭头旋转
MAIN_ARROW_EFFECT 			= getNext() -- 主界面，箭头特效

PIECE_SELL_SUCCESS 			= getNext()
BOXEQUIP_SUPER_REFRESH 		= getNext() -- 新版宝箱大兑换

-- 新手任务
NEWBIE_TASK_REFRESH			= getNext()
NEWBIE_TASK_STAGE_UPDATE	= getNext()


KR_Statistics_UserFunnel 		= getNext() --韩国sdk：新增用户漏斗统计 需要传参数 firstTimeExperience [taoliang]
KR_Statistics_StageClear	= getNext() --韩国sdk：新增用户漏斗统计 需要传参数 retention [taoliang]
KR_UnityAds_AddQuickCount   = getNext() --海外韩国sdk增加快速扫荡次数的广告sdk
KR_UnityAds_AddQuickCountClick   = getNext() --海外韩国sdk增加快速扫荡次数的广告sdk
Adbrix_Statistics_ShowPopups = getNext() --海外韩国sdk 曝光弹窗通知 需要参数(popupsKey)
--招财猫
CAT_REFRESH                 = getNext()
CAT_REFRESH_EFFECT          = getNext()
LA_LUCKYCAT_ACTION          = getNext()

CIMIC_ENERGY_NUM_REFRESH    = getNext()
CIMIC_ENERGY_POS_CHANGE     = getNext()
CIMIC_VISIBLE_LIST_ITEM     = getNext()
CIMIC_BACK_TO_MAIN_PAGE     = getNext()
CIMIC_CHALLENGE_UPDATE      = getNext()

-- 千人斩
KILLLING_THOUSANDS_REFRESH  = getNext()

-- 矿区争霸
ENTER_GLOBAL_MINING			= getNext()
REFRESH_GLOBAL_MINING		= getNext()
GMW_NOTICE_UPDATE			= getNext()
GMW_REPORT_NOTICE_UPDATE			= getNext()
GMW_REPORT_CLOSE			= getNext()
GMW_REPORT_NEW_UPDATE		= getNext()
REFRESH_GEM_SHOW			= getNext()

-- 魂石
SOUL_STONE_NODE_SELECT		= getNext()
SOUL_STONE_SUIT_NODE_SELECT	= getNext()
SOUL_STONE_RESOLVE_SUCCESS	= getNext()
SOUL_STONE_STRENGTHEN		= getNext()
SOUL_STONE_EQUIP			= getNext()
SOUL_STONE_SHAPE_NODE_CLICK	= getNext()
SOUL_STONE_CLICK_EQUIP		= getNext()
SOUL_STONE_REPLACE			= getNext()
SOUL_STONE_SELL_SHOW_CHOOSE = getNext()
SOUL_STONE_EQUIP_CLOSE   	= getNext()
SOUL_STONE_TYPE_CHOOSE 		= getNext()

-- 巅峰对决
GLOBAL_ARENA_APPLY_SUCCESS  = getNext()
GLOBAL_SUPPORT_SUCCESS 		= getNext()
GLOBAL_WORSHIP_SUCCESS 		= getNext()

SPIRIT_TEMPLE_DATA_RECEIVE	= getNext()
SPIRIT_TEMPLE_BUY_SUCCESS	= getNext()
SPIRIT_TEMPLE_BUY_AGAIN	= getNext()
GEM_LOFT_NODE_REFRESH	= getNext()

-- GM推送消息
SET_SHOW_GM_MSG				= getNext()


VISIBLE_MAIN_MENU_DOWN_BUTTON = getNext()
EXPEDITION_NOTICE_UPDATE = getNext() --远征绿点

FORMATION_BTN_REFRESH		= getNext()

KR_SHOW_LOGIN_BTN			= getNext()

FORMATION_LAYER_CLOSE		= getNext()

MAIN_VIEW_VIDEO_BTN_UPDATE	= getNext()