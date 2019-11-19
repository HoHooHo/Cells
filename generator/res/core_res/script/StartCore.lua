require "RequireAll"

local INIT_FUNC = {
    {"SDKManager", "init"},

    {"LoginAuth", "init"},
    {"HeartBeatManager", "initNetListener"},
    {"GlobalConfManager", "init"},
    {"PlayerData", "init"},
    {"FuncSwitchData", "init"},
    {"ShaderManager", "init"},

    {"HeroData", "init"},
    {"FormationData", "init"},

    {"MineData", "init"},
    {"ProjectData", "init"},

    {"AwardCenterData", "init"},

    {"BagData", "init"},

    {"SoulGemData", "init"},
    {"ChatData", "init"},
    {"HandbookData", "init"},

    {"AdventureData", "init"},
    {"ShopData", "init"},
    {"CaveData", "init"},
    {"MailData", "init"},
    {"PvPData", "init"},
    {"RecruitData", "init"},
    {"CampaignData", "init"},
    {"AchievementData", "init"},
    {"DailyData", "init"},
    {"GuildData", "init"},
    {"MonthCardData", "init"},
    {"CommentData", "init"},
    {"RankData", "init"},
    {"FriendData", "init"},
    {"PaymentData", "init"},
    {"LimitActivityBaseData", "init"},
    {"SevenDayData", "init"},
    {"HalfMonthData", "init"},
    {"ActivityCommonLimitData", "init"},
    {"ActivityData", "init"},
    {"LimitHeroData", "init"},
    {"EmojiManager", "init"},
    {"NoviceGuideManager", "init"},
    {"BroadcastManager", "init"},
    {"SensitiveWordManager", "init"},
    {"FunctionOpenManager", "init"},
    {"NoviceGuideData", "init"},
    {"NewbieFuncSwitchData", "init"},
    {"ActivityNewbieData", "init"},
    {"LimitGiftBoxData", "init"},
    {"DreamLandData", "init"},
    {"VipSystemData", "init"},
    {"EquipData", "init"},
    {"GuildBossData", "init"},
    {"ChallengeData", "init"},
    {"TalentData", "init"},
    {"SlotMachineData", "init"}, -- 老虎机 zhaolu
    {"RuneData", "init"}, --符文系统 zhaolu
    {"CollectionEpicData", "init"},
    {"WorldBossData","init"},
    {"GlobalCampBattleData","init"},
    {"ExpeditionData","init"},
    {"TreasureData", "init"},
    {"GoldSupplyData", "init"},
    {"ThemeDataManager", "init"},
    {"GlobalGuildBattleData","init"},
    {"SummoningMonsterData", "init"},
    {"PedestalData", "init"},
    {"SoulStoneTowerData", "init"},

    {"ActivityWorldBossRankData", "init"},--世界boss排行榜
    --五星好评
    {"GameEvaluation", "init"},
    ---- 等级奖励 ----
    {"LevelGiftData", "init"},
    {"OpenServerRaceData", "init"},
    {"IdentityBindingManager", "init"},
    {"ComicInstanceData", "init"},
    {"GlobalArenaData", "init"},
    {"SoulStoneData", "init"},
    {"KillingThousandsData", "init"},

    {"TaskNewbieData", "init"},
    {"CashData", "init"},

    {"BuffData", "init"},

    ---- 矿区争夺 ----
    {"GMWData", "init"},
    {"GMWManager", "init"},

    {"KeypadListener", "init"}
}

--处理 数据量比较大的消息 不做lua table的解析
local function addNotParseMessge(  )
    NetMessageSystem.addNotParseMessge(ID_DseUpdateBlockData)
end


local ONLY_LOAD_IMG = {
    {png = "img/login.png", plist = "img/login.plist"},
}

-- 图集中 元素太多的话 解析plist文件效率好像有点慢，  预加载图片资源的时候适当加载plist
local IMG_LIST = {
    {png = "img/role/artifact.png", plist = "img/role/artifact.plist"},

    {png = "img/block.png", plist = "img/block.plist"},

    {png = "img/ui/bg.png", plist = "img/ui/bg.plist"},
    {png = "img/ui/button.png", plist = "img/ui/button.plist"},

    {png = "img/campaign.png"},

    {png = "img/ui/border.png"},
    {png = "img/ui/loading_bar.png"},
    {png = "img/ui/skill.png"},

    {png = "img/icon/resource.png", plist = "img/icon/resource.plist"},
    {png = "img/icon/explore.png"},
    {png = "img/icon/item.png", plist = "img/icon/item.plist"},
    {png = "img/icon/global.png", plist = "img/icon/global.plist"},
    {png = "img/icon/expression.png"},
}

local function loadImage()
    local texCache = cc.Director:getInstance():getTextureCache()

    for i,v in ipairs(ONLY_LOAD_IMG) do
        local function cb(  )
            if v.plist then
                cc.SpriteFrameCache:getInstance():addSpriteFrames(v.plist)
            end
        end
        texCache:addImageAsync(v.png, cb)
    end

    for i,v in ipairs(IMG_LIST) do
        local function cb(  )
            local sprite = cc.Sprite:create(v.png)
            sprite:setVisible(false)
            SceneHelper.addChild(sprite)

            if v.plist then
                cc.SpriteFrameCache:getInstance():addSpriteFrames(v.plist)
            end
        end
        texCache:addImageAsync(v.png, cb)
    end
end

local function showLogin(  )
    local entryId = nil
    local cb = function (  )
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(entryId)
        local login = LoginViewLogic.new()
        login:openView()
    end
    entryId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(cb, 0.01, false)

    -- 提前Load  广告网页
    WebInfo.getADWebView()
end

function realStartCore(  )
    logW("**************   realStartCore   **************")
    LogoSpine.resumeSpine()

    DownloadViewLogic.closeView()

    if _G.getShowNotice() then
        NetLoadingViewLogic.clear()
    else
        NoticeViewLogic.new(true, showLogin):openView()
        _G.setShowNotice()
    end
    addNotParseMessge(  )
end


function startCore(  )
    logW("**************   startCore   **************")
    LogoSpine.pauseSpine()
    
    loadImage()

    requireAll( realStartCore, INIT_FUNC )
end