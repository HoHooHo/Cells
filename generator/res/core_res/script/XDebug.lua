module("XDebug", package.seeall)

local _init = false
local OFFSET = {w = 100, h = 70}
local ORIGIN_POS = {x = OFFSET.w/2, y = WIN_SIZE.height - OFFSET.h * 2 }

local MAX_LOG = 200
local _error = {}
local _logAll = {}
local _logD = {}
local _msg = {}

local _msgs = {}
local _msgI = 1  -- idx
local _msgM = 200 -- max

local _container = nil

-- 添加Debug 功能按钮，回调函数为 非local的function  on+名字  如：
-- State 功能按钮 回调为 function onState()
local DEBUG_KEY = {
	"State",
	"Info",
	"CopyUID",
	"Err",
	"LOG",
	"logD",
	"DELETE",
	"NetMsg",
	"Skip",
	"BossReward",
	"SaveBattle",
	"InputServer",
	"TestBattle",
	"TestPVP",
	"IAP",
	"CopyChat",
	"ComicInstance",
	"KrLogin",
}

-- 仅调试模式显示
local ONLY_DEBUG = {
	"LocalBattle",
	"Dump",
	"GuideTest",
	"SkipGuide",
	"KR_G_Login",
	"KR_G_Logout",
	"KR_FB_Login",
	"KR_PayTest",
	"KR_NaverEnter",
	"KR_NaverLogin",
	"KR_NaverLogout",
	"KR_GameCenter",
	"KR_Ach_Open",
	"KR_Ach_Complete",
	"KR_LD_Open",--LD = Leaderboard(google排行榜)
	"KR_LD_Update",
	"BattleShow",
}


local function getBtn(txt, cb, pos)
	local btn = ccui.Button:create("res/debug_btn.png", "res/debug_btn.png")
	btn:setTitleText(txt)
	btn:setTitleFontSize(20)
	btn:setPosition(pos.x, pos.y)
	btn:setTouchEnabled(true)
	btn:addClickEventListener(cb)

	btn:setPressedActionEnabled(true)
	btn:setZoomScale(-0.1)

	return btn
end

local function getTxt(txt, size, color)
	local text = ccui.Text:create()
	text:setString(txt)
	text:setFontSize(size or 24)
	text:setColor(color or cc.c3b(0, 0, 0))

	return text
end

local function getPanel()
    local layer = ccui.Layout:create()

    layer:setContentSize(_WIN_SIZE)
    layer:setAnchorPoint(cc.p(0.5, 0.5))
    layer:setPosition(_WIN_CENTER)

    layer:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    layer:setBackGroundColor(cc.c3b(255, 255, 255))
    layer:setBackGroundColorOpacity(150)


	layer:setTouchEnabled(true)

	local close = getBtn("Close", function () layer:removeFromParent() end, cc.p(_WIN_SIZE.width - OFFSET.w/2, _WIN_SIZE.height - OFFSET.h/2))
	layer:addChild(close, 99, 99)

	SceneHelper.addDebug(layer)

	return layer
end

local function getBg(parent, url, rect, s9Rect, an)
	local bg = nil
	if s9Rect then
		bg = ccui.Scale9Sprite:create(cc.rect(s9Rect[1],s9Rect[2],s9Rect[3],s9Rect[4]), url)
	else
		bg = cc.Sprite:create(url)
	end
	if an then bg:setAnchorPoint(an[1], an[2]) end
	if rect then
		if rect[1] then bg:setPosition(rect[1],rect[2]) end
		if rect[3] then
			if s9Rect then
				bg:setContentSize(cc.size(rect[3],rect[4]))
			else
				CCX.setContentSizeByScale(bg, {rect[3],rect[4]})
			end
		end
	end
	bg:setColor(cc.c3b(0, 0, 0))
	bg:setOpacity(180)

	if parent then
		parent:addChild(bg)
	end
	return bg
end

local function getInputText(parent,defaultTxt,rect,fontName,fontSize, placeHolder)
	local bg = getBg(parent, "res/debug_btn.png", rect, {3,3,30,30}, {0.5,0.5})
	bg:setColor(cc.c3b(0,0,0))

	local editBoxBg = ccui.Scale9Sprite:create("res/debug_btn.png")
	editBoxBg:setColor(cc.c3b(0, 255, 0))

	local editBox = ccui.EditBox:create( cc.size(rect[3], rect[4]), editBoxBg )
	editBox:setPosition(rect[1], rect[2])
	editBox:setFontName(fontName)
	editBox:setFontSize(fontSize)
	editBox:setPlaceHolder(placeHolder or "输入吧")
	editBox:setText(defaultTxt)
	editBox.setString = editBox.setText
	editBox.getString = editBox.getText

	parent:addChild(editBox)
	return editBox
end


local SCROLL_SIZE = cc.size(_WIN_SIZE.width - 10, _WIN_SIZE.height - 10)
local function getScrollLabel(txt)
	local label = cc.Label:create()
	label:disableEffect()
	label:setAnchorPoint(cc.p(0.5, 0))
	label:setPosition(cc.p(SCROLL_SIZE.width/2, 0))

	label:setDimensions(SCROLL_SIZE.width, 0)
	label:setLineBreakWithoutSpace(true)

	label:setString(txt)
	label:setSystemFontSize(18)


	local scroll = ccui.ScrollView:create()

    scroll:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    scroll:setBackGroundColor(cc.c3b(0, 255, 0))
    scroll:setBackGroundColorOpacity(100)

	scroll:setContentSize(SCROLL_SIZE)
	scroll:setTouchEnabled(true)
	scroll:setBounceEnabled(true)
	scroll:setAnchorPoint(0.5, 0.5)
	scroll:setPosition(_WIN_CENTER)
	scroll:addChild(label)


	local inner = scroll:getInnerContainer()
	inner:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
	inner:setBackGroundColor(cc.c3b(0, 0, 255))
	inner:setBackGroundColorOpacity(100)


	scroll:setInnerContainerSize(label:getContentSize())
	if inner:getContentSize().height > scroll:getContentSize().height then
		scroll:scrollToBottom(0, false)
	else
		label:setAnchorPoint(cc.p(0.5, 1))
		label:setPosition(cc.p(SCROLL_SIZE.width/2, scroll:getContentSize().height))
	end

	logW(label:getContentSize().width .. "  " .. label:getContentSize().height)
	logW(scroll:getContentSize().width .. "  " .. scroll:getContentSize().height)
	logW(inner:getContentSize().width .. "  " .. inner:getContentSize().height)

	return scroll, label
end


-- ######################   DEBUG 功能按钮 回调 从此处开始   ######################
function onState(  )
	local show = not cc.Director:getInstance():isDisplayStats()
	cc.Director:getInstance():setDisplayStats( show )
	SceneHelper.showState( show )
end

function onInfo(  )
	local panel = getPanel()
	local str = "\n"

	if ServerConfig.GAME_LOGINED then
		str = string._format("%s OPEN_ID: %s\n", str, ServerConfig and ServerConfig.OPEN_ID or "nil")
		str = string._format("%s SERVER_IP: %s\n", str, ServerConfig and ServerConfig.SERVER_IP or "nil")
		str = string._format("%s SERVER_PORT: %s\n", str, ServerConfig and ServerConfig.SERVER_PORT or "nil")
		str = string._format("%s REGION: %s\n", str, ServerConfig and ServerConfig.REGION or "nil")
		str = string._format("%s UID: %s\n", str, ServerConfig and ServerConfig.UID or "nil")
		str = string._format("%s DISPLAY_UID: %s\n", str, ServerConfig and Global.uidToDisplay(ServerConfig.UID) or "nil")
		str = string._format("%s WEB IP: %s\n", str, WebConfig.IP or "nil")
		str = string._format("%s EVN: %s\n", str, Config.EVN)
		str = string._format("%s BundleId: %s\n", str, AppHelper.getBundleId())
		str = string._format("%s Log: %s\n", str, LogHelper._full_name)
		str = string._format("%s ApplicationName: %s\n", str, AppHelper.getApplicationName())
		str = string._format("%s PackageVersion: %s\n\n", str, AppHelper.getPackageVersion())
		str = string._format("%s Player Gold: %s\n", str, PlayerData and PlayerData.getFormatGold() or "nil")
		str = string._format("%s Player Exp: %s\n\n", str, PlayerData and PlayerData.getFormatExp() or "nil")

		str = string._format("%s Player Power List\n", str)
		for i=1, 10 do
			str = string._format("%s Server F%d: %s     Client F%d: %s\n", str, i, FormationData and FormationData.getFormatServerPowerByFormationId(i) or "nil",i, SkillData and SkillData.getFormatClientPowerByFormationId(i) or "nil")
			
		end
	else
		str = "还没登录游戏呢，没有INFO"
	end




	local label = getTxt(str, 28)
	label:setAnchorPoint(cc.p(0, 1))
	label:setPosition(cc.p(50, panel:getContentSize().height - 50))

	panel:addChild(label)
end

function onCopyUID(  )
	if ServerConfig.GAME_LOGINED then
		DeviceHelper.setClipboardText(PlayerData.getPlayerUid())
		Global.showTips("复制UID成功")
	else
		Global.showTips("还没登录游戏呢，没有UID")
	end
end

function onComicInstance()
	ComicInstanceData.openMainView()
end

function onErr(  )
	local panel = getPanel()
	local label = getScrollLabel("ERROR:\n" .. table.concat(_error, "\n"))
	panel:addChild(label)
end

function onLOG(  )
	local panel = getPanel()
	local label = getScrollLabel(table.concat(_logAll, "\n"))
	panel:addChild(label)
end

function onlogD(  )
	local panel = getPanel()
	local label = getScrollLabel(table.concat(_logD, "\n"))
	panel:addChild(label)
end

function onDELETE(  )
    local resDir = cc.FileUtils:getInstance():getWritablePath() .. "res/"
    if cc.FileUtils:getInstance():isDirectoryExist( resDir ) then
        local ret = cc.FileUtils:getInstance():removeDirectory(resDir)
    end

    restartGame()
end

function onKR_G_Login()
	local cb = function ()
		xlog("onKR_G_Login SUCCESS")
	end
    LoginHelperLogic.loginPlatformAccount({cb = cb},BundleID.CHANNEL_NAME.GOOGLEPLAY)
end
function onKR_G_Logout()
	SDKManager.loginOut()
end
function onKR_FB_Login()
	local cb = function ()
		xlog("onKR_FB_Login SUCCESS")
	end
    LoginHelperLogic.loginPlatformAccount({cb = cb},BundleID.CHANNEL_NAME.FACEBOOK)
end
function onKR_PayTest()
	local cashID = 1
	SDKManager.buy(cashID)
end

function onKR_NaverEnter()
    EventSystem.dispatchEvent(EventType.NaverCafe_Update,{state="popup"})
end
function onKR_NaverLogin()
	local cb = function ()
		xlog("onKR_NaverLogin SUCCESS")
	end
    LoginHelperLogic.loginPlatformAccount({cb = cb},BundleID.CHANNEL_NAME.NAVERCAFE)
end
function onKR_NaverLogout()
    EventSystem.dispatchEvent(EventType.NaverCafe_Update,{state="logout"})
end
function onKR_GameCenter()
	local cb = function ()
		xlog("onKR_GameCenter SUCCESS")
	end
    LoginHelperLogic.loginPlatformAccount({cb = cb},BundleID.CHANNEL_NAME.GAMECENTER)
end

function onKR_Ach_Open()
	EventSystem.dispatchEvent(EventType.KR_Achievements_OpenView)
end

function onKR_Ach_Complete()
	EventSystem.dispatchEvent(EventType.KR_Achievements_Complete,10)
end

function onKR_LD_Open()
	EventSystem.dispatchEvent(EventType.KR_Leaderboard_OpenView)
end

function onKR_LD_Update()
	EventSystem.dispatchEvent(EventType.KR_Leaderboard_UpdateScore,{id=1,score=math.ceil(math.random()*1000)})
end

function onNetMsg()
	local panel = getPanel()

	local s = ""
	local v = nil
	local i = _msgI
	for t=1,_msgM do
		v = _msgs[i]
		if v then
			s = s .. "\n" .. v
		end
		i = i+1
		if i > _msgM then i = 1 end
	end
	local label = getScrollLabel(s)
	panel:addChild(label)

	local clear = getBtn("Clear", function () 
		_msgs = {}
		_msgI = 1
		panel:removeFromParent()
	end, cc.p(_WIN_SIZE.width - OFFSET.w/2, _WIN_SIZE.height - OFFSET.h/2 - 100))
	panel:addChild(clear)
end

local _inputLayer = nil
function onInputServer(  )
	if _inputLayer then return end
	if not ServerConfig then return end

	_inputLayer = cc.Layer:create()
	SceneHelper.addDebug(_inputLayer)

	local sprite = cc.Sprite:create()
	local bg = getBg(sprite, "res/debug_btn.png", {0,0,WIN_SIZE.width, WIN_SIZE.height}, {3,3,30,30}, {0.5,0.5})
	local function clearParent()
		_inputLayer:removeFromParent()
		_inputLayer = nil
	end
	CCX.addTapEvent(bg, clearParent)

	local vail = {0,0,WIN_SIZE.width*0.8, WIN_SIZE.height*0.8}
	local untap = ccui.Layout:create()
	untap:setTouchEnabled(true)
	untap:setPosition(-vail[3]*0.5, -vail[4]*0.5)
	untap:setContentSize(vail[3], vail[4])
	untap:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
	untap:setBackGroundColor(cc.c3b(99,99,99))
	sprite:addChild(untap)

	local tfIP = getInputText(sprite,"输入IP地址", {0,200,400,30}, ResConfig.FONT_NAME, 28)
	local tfID = getInputText(sprite,"输入ID",	   {0,100,400,30}, ResConfig.FONT_NAME, 28)
	local tfPort = getInputText(sprite,"输入端口", {0,0,  400,30}, ResConfig.FONT_NAME, 28)

	local kIP   = UserDefaultHelper.getString({str = "XDebug_M_IP"}, "192.168.2.177")
	local kUID  = UserDefaultHelper.getString({str = "XDebug_M_UID"}, "72339073309606090")
	local kPORT = UserDefaultHelper.getString({str = "XDebug_M_PORT"}, "15443")
	if kIP then tfIP:setString(kIP) end
	if kUID then tfID:setString(kUID) end
	if kPORT then tfPort:setString(kPORT) end

	local reqServer = function ()
		if tfID:getString() == "" or tfIP:getString() == "" then return end 

		ServerConfig.UID = tfID:getString()
		ServerConfig.SERVER_IP = tfIP:getString()
		if tfPort:getString() ~= "" then
			ServerConfig.SERVER_PORT = tfPort:getString()
		end
		UserDefaultHelper.setString({str = "XDebug_M_IP"}, ServerConfig.SERVER_IP)
		UserDefaultHelper.setString({str = "XDebug_M_UID"}, ServerConfig.UID)
		UserDefaultHelper.setString({str = "XDebug_M_PORT"}, ServerConfig.SERVER_PORT)

		clearParent()
		NetMessageSystem.init()
    	-- NetMessageSystem.sendRequest(ID_DceNewDay)
	end
	-- local btn = getBtn(sprite,"确定",reqServer,{0, -100})
	local btn = getBtn("确定",reqServer,{x=0, y=-100})
	sprite:addChild(btn)
	btn:getVirtualRenderer():setColor(cc.c3b(66,66,66))

	sprite:setPosition(cc.p(WIN_SIZE.width/2, WIN_SIZE.height/2))
	_inputLayer:addChild(sprite)
end

function onSkip(  )
	ReadOnly.lookContent(Config).Skip = true
	EventSystem.dispatchEvent(EventType.XDEBUG_SKIP)
end

function onBossReward(  )
	ReadOnly.lookContent(Config).ShowGuildBossReward = true
	EventSystem.dispatchEvent(EventType.XDEBUG_BOSS)
end

function onSaveBattle(  )
	EventSystem.dispatchEvent(EventType.XDEBUG_SAVE_BATTLE)
end

function onTestBattle(  )
	if PlayerData and PlayerData.hasData and PlayerData.hasData() then

		local layer = cc.Layer:create()
		SceneHelper.addDebug(layer)

		local bg = getBg(layer, "res/debug_btn.png", {_WIN_SIZE.width/2, _WIN_SIZE.height/2, _WIN_SIZE.width, _WIN_SIZE.height})

		local function clearParent()
			layer:removeFromParent()
		end
		CCX.addTapEvent(bg, clearParent)


		local editBox = getInputText(layer, "", {_WIN_SIZE.width/2, _WIN_SIZE.height/3*2, 400, 50}, ResConfig.FONT_NAME, 28, "输入【MonsterData】的ID")

		local requestBattle = function ()
			local levelId = editBox:getString()
			if levelId == "" then 
				Global.showTips("输入【MonsterData】的ID")
			elseif PvPData.getMonsterDataById(tonumber(levelId)) == nil then
				Global.showTips("MonsterData ID 好像输错了， 我没找到")
			else
				NetMessageSystem.sendRequest(ID_DceTestChallenge, {monsterid = tonumber(levelId)})

				clearParent()
			end 
		end

		local btn = getBtn("确定", requestBattle, {x = _WIN_SIZE.width/2, y = _WIN_SIZE.height/3})
		layer:addChild(btn)
	else
		Global.showTips("好像还没有玩家数据呢！")
	end
end

function onTestPVP(  )
	if PlayerData and PlayerData.hasData and PlayerData.hasData() then

		local layer = cc.Layer:create()
		SceneHelper.addDebug(layer)

		local bg = getBg(layer, "res/debug_btn.png", {_WIN_SIZE.width/2, _WIN_SIZE.height/2, _WIN_SIZE.width, _WIN_SIZE.height})

		local function clearParent()
			layer:removeFromParent()
		end
		CCX.addTapEvent(bg, clearParent)


		local editBox = getInputText(layer, "", {_WIN_SIZE.width/2, _WIN_SIZE.height/3*2, 400, 50}, ResConfig.FONT_NAME, 28, "输入【对手的UID】")

		local requestBattle = function ()
			local uid = editBox:getString()
			if uid == "" then 
				Global.showTips("输入【对手的UID】")
			else
				if string.find(uid, "%a") then
					uid = Global.displayToUID(uid)
				end
				NetMessageSystem.sendRequest(ID_DceTestBattle, {uid = uid})

				clearParent()
			end 
		end

		local btn = getBtn("确定", requestBattle, {x = _WIN_SIZE.width/2, y = _WIN_SIZE.height/3})
		layer:addChild(btn)
	else
		Global.showTips("好像还没有玩家数据呢！")
	end
end


function onIAP(  )
	require "TempIAPLogic"

	TempIAPLogic.tempIAP()
end

function onCopyChat(  )
	_container:setVisible(false)

	local panel = getPanel()

	local from = getInputText(panel, "1", {_WIN_SIZE.width/2, _WIN_SIZE.height - 200, 400, 50}, ResConfig.FONT_NAME, 28, "倒数第几条开始")
	local count = getInputText(panel, "50", {_WIN_SIZE.width/2, _WIN_SIZE.height - 300, 400, 50}, ResConfig.FONT_NAME, 28, "想复制多少条")

	local function setText( chatlist )
		local chatCount = math.min(#chatlist, tonumber(count:getString()) or 50)

		if chatCount == 0 then
			Global.showTips("没有相关聊天内容")
			return
		end

		local startId = tonumber(from:getString()) or 1

		local str = ""
		for i=startId,chatCount do
			local v = chatlist[i]
			-- logW(v)
			str = str .. tostring(v.name) .. ":" .. tostring(v.content) .. "\n"
		end

		DeviceHelper.setClipboardText(str)
		Global.showTips("复制成功")
	end

	local chatMsgList = ChatData.getChatMsgList()

	local function worldChat(  )
		setText( chatMsgList[ChatData.CHAT_TYPE.WORLD] )
	end

	local function localChat(  )
		setText( chatMsgList[ChatData.CHAT_TYPE.LOCAL] )
	end

	local function guildChat(  )
		setText( chatMsgList[ChatData.CHAT_TYPE.GUILD] )
	end

	local function privateChat(  )
		setText( chatMsgList[ChatData.CHAT_TYPE.PRIVATE] )
	end

	local worldBtn = getBtn("世界", worldChat, {x = _WIN_SIZE.width/2, y = _WIN_SIZE.height/2 + 150})
	local localBtn = getBtn("本服", localChat, {x = _WIN_SIZE.width/2, y = _WIN_SIZE.height/2 + 50})
	local guildBtn = getBtn("公会", guildChat, {x = _WIN_SIZE.width/2, y = _WIN_SIZE.height/2 - 50})
	local privateBtn = getBtn("私聊", privateChat, {x = _WIN_SIZE.width/2, y = _WIN_SIZE.height/2 - 150})

	panel:addChild(worldBtn)
	panel:addChild(localBtn)
	panel:addChild(guildBtn)
	panel:addChild(privateBtn)
end










-- 此处开始 时只有debug模式下才会有的DEBUG_KEY
function onLocalBattle(  )
	-- EventSystem.dispatchEvent(EventType.BATTLE_ENTER)
	EventSystem.dispatchEvent(EventType.BATTLE_ENTER, require("ViewLogic/Battle/BattleInfoTest"))
end

function onBattleShow(  )
	BattleShowManager.startShow()
end

function onDump(  )
	cc.SpriteFrameCache:getInstance():dump()
end

function onGuideTest(  )
	EventSystem.dispatchEvent(EventType.GUIDE_TEST, true)
end

function onSkipGuide(  )
	NoviceGuideData.setNoviceStep( NoviceGuideManager.LAST_STEP )


	for i, v in ipairs(TemplateManager.getLookContentTemplate("NoviceGuideTemplate")) do
		if v.step > NoviceGuideManager.LAST_STEP and v.step%10 == 1 then
			NoviceGuideData.setNoviceStep( v.step )
		end
	end
end

function onKrLogin(  )
	EventSystem.dispatchEvent(EventType.KR_SHOW_LOGIN_BTN)
end

-- ######################   DEBUG 功能按钮 回调 从此处结束   ######################




function xTrace( err )
	table.insert(_error, err)
	if #_error > MAX_LOG then
		table.remove(_error, 1)
	end
end

function xlogD( str )
	table.insert(_logD, str)
end

function xlog( str )
	table.insert(_logAll, str)
	if #_logAll > MAX_LOG then
		table.remove(_logAll, 1)
	end
end

-- 根据DEBUG_KEY  初始化debug功能按钮
local function initDebugs( layer )
	local row = 0
	local col = 0
	for i,v in ipairs(DEBUG_KEY) do

		col = col + 1
		local x = ORIGIN_POS.x + OFFSET.w*col

		if x > _WIN_SIZE.width - OFFSET.w/2 then
			row = row + 1
			col = 1
			x = ORIGIN_POS.x + OFFSET.w*col
		end

		local y = ORIGIN_POS.y - OFFSET.h*row

		local btn = getBtn(v, function (  )  XDebug["on" .. v]()	end, {x = x, y = y})
		layer:addChild(btn)
	end

	if Config.Debug then
		for i,v in ipairs(ONLY_DEBUG) do

			col = col + 1
			local x = ORIGIN_POS.x + OFFSET.w*col

			if x > _WIN_SIZE.width - OFFSET.w/2 then
				row = row + 1
				col = 1
				x = ORIGIN_POS.x + OFFSET.w*col
			end

			local y = ORIGIN_POS.y - OFFSET.h*row

			local btn = getBtn(v, function (  )  XDebug["on" .. v]()	end, {x = x, y = y})
			layer:addChild(btn)
		end
	end
end

function init()
	if _init then
		return
	end

	_init = true

	_container = cc.Layer:create()
	SceneHelper.addDebug(_container)

	_container:setVisible(false)

	local function onDebug(  )
		_container:setVisible(not _container:isVisible())
	end

	local debug = getBtn("D", onDebug, ORIGIN_POS)

	debug:setOpacity(180)

	SceneHelper.addDebug(debug)

	initDebugs(_container)
end

-- 记录消息
function xMsg(lv, str)
	_msgs[_msgI] = os.date("%X") .. " " ..str
	--string.format("%s  %s", Time.getLogTime(), str)
	_msgI = _msgI+1
	if _msgI > _msgM then _msgI = 1 end
end