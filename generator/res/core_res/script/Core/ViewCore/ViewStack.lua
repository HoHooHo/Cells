-- 界面栈，用于控制界面的层级和回溯
-- noted by baofeng 20180104
module("ViewStack", package.seeall)

-- 平台
local _targetPlatform = cc.Application:getInstance():getTargetPlatform()

-- 所有界面实例
--[[
	内部结构：
		{
			value1,		-- 界面实例1
			...
			valueN		-- 界面实例N
		}
--]]
_allViewStackCache = {}

-- 界面层级关系实例
--[[
	内部结构：
		{
			{
				value1,		-- 界面实例1（该层底层）
				...
				valueN		-- 界面实例N（该层顶层）
			},			-- 层级1上的所有界面
			...
			{	
				value1,		-- 界面实例1（该层底层）
				...
				valueN		-- 界面实例N（该层顶层）
			}			-- 顶层的所有界面实例
		}
--]]
_viewStackCache = {}

-- 是否需要初始化，初始为true
local _init = true

-- 通过记录打开的csb类型数量，决定是否进行Global.cleanCache()
local _csbNameCache = {name = {}, csbCount = 0}
local MAX_CSB_COUNT = 15

----- 内部接口 -----
-- 缓存csb名称，计算总数量
local function cacheCSBName( name )
	if not _csbNameCache.name[name] then
		_csbNameCache.name[name] = true
		_csbNameCache.csbCount = _csbNameCache.csbCount + 1
	end
end

-- 添加新的顶层数据层
local function newTop(  )
	_viewStackCache[#_viewStackCache + 1] = {}
end

-- 删除顶层数据层
local function deleteTop(  )
	_viewStackCache[#_viewStackCache] = nil
end

-- 获取顶层数据层
local function top(  )
	if #_viewStackCache < 1 then
		newTop()
	end
	
	return _viewStackCache[#_viewStackCache]
end

-- 返回动作处理
local function backView( topLogic, isBackHome )
	if topLogic.__IS_MAIN_VIEW then	-- 主界面返回
		if not isBackHome then
			SDKManager.exit()	-- 退出
		end
	else
		log("backHome: logic Id = " .. topLogic:getLogicId() .. "   logic cname = " .. topLogic.__cname)
		topLogic:onESCClicked( isBackHome )	-- 界面关闭
	end
end

-- 返回主界面按钮回调函数
local function onBackHome(  )
	for i = #_viewStackCache, 1, -1 do
		local topCache = _viewStackCache[i]
		for j = #topCache, 1, -1 do
			local topLogic = topCache[j]
			backView(topLogic, true)
		end
	end
end

-- 返回按钮回调函数
local function onBack()
	local topCache = top()
	local topLogic = topCache[#topCache]

	backView( topLogic )
end

-- 回到固定层级
local MAX_SAFE_COUNT = 100	-- 理论上 不会有这么多界面打开
local function backToXLAYER( viewLevel )
	local bBreak = false
	-- 确保不会发生意外 造成死循环
	local safeCount = 0
	repeat
		safeCount = safeCount + 1
		local topCache = top()
		local topLogic = topCache[#topCache]
		if topLogic.viewLevel > viewLevel and not topLogic.__IS_MAIN_VIEW then
			backView( topLogic, true )
		else
			bBreak = true
		end
	until bBreak or (safeCount > MAX_SAFE_COUNT and not Config.Debug)
end

-- 回到某个已经打开的界面
local function backToXView( viewLogic )
	if not viewLogic or viewLogic.viewState ~= VIEW_STATE.OPEN then
        error("\n\n***ERROR*** viewLogic is nil  or  viewState isn't VIEW_STATE.OPEN  ***ERROR***")
	end

	local bBreak = false
	-- 确保不会发生意外 造成死循环
	local safeCount = 0
	repeat
		safeCount = safeCount + 1
		local topCache = top()
		local topLogic = topCache[#topCache]
		if topLogic:getLogicId() ~= viewLogic:getLogicId() and not topLogic.__IS_MAIN_VIEW then
			backView( topLogic, true )
		else
			bBreak = true
		end
	until bBreak or (safeCount > MAX_SAFE_COUNT and not Config.Debug)
end

local function onChatVisible( data )
	if data.visible and data.showType == ChatData.CHAT_LAYER_MODE.ONLY_CHAT and data.chatType == ChatData.CHAT_TYPE.PRIVATE then
		backToXLAYER(SceneHelper.LAYER_TYPE.UI_I_LAYER)
	end
end

-- 初始化：消息注册
local function init(  )
	_init = false
	EventSystem.registerEventListener(EventType.BACK_HOME, onBackHome)							-- 返回主界面按键消息
	EventSystem.registerEventListener(EventType.BACK_VIEW, onBack)								-- 返回按键消息
	EventSystem.registerEventListener(EventType.BACK_TO_X_VIEW, backToXView)					-- 返回到指定界面消息
	EventSystem.registerEventListener(EventType.ON_CHAT_LAYER_VISIBLE_EVENT, onChatVisible)
end

-- 发送消息，控制主界面按钮 和 返回按钮的显隐
local function postEvent( viewLogic, count, beTopLogic )
	EventSystem.dispatchEvent(EventType.MAIN_MENU_EVENT, {level = viewLogic.viewLevel, esc = count, noBack = beTopLogic and beTopLogic.noBack})
end

-- 界面入栈操作
local function push( viewLogic )
	-- 将现有的顶部界面状态置为不在顶部
	local topCache = top()
	local topLogic = topCache[#topCache]
	if topLogic then
		topLogic:beNotTop()
	end

	-- 检查新界面是否全屏显示
	-- 是，则加入新的 _viewStackCache 数据层
	-- 不是，则在现有数据层中加入界面
	if viewLogic:isFullScreen() then
		topCache = top()
		for _, v in pairs(topCache) do
			v:setCovered(false)			-- 下层界面不可见（顶层是全屏显示时）
		end

		newTop()
	end

	-- 将新界面入栈，在栈顶
	topCache = top()
	topCache[#topCache + 1] = viewLogic

	-- 控制主界面按钮 和 返回按钮的显隐
	postEvent(viewLogic, 1, viewLogic)
end

-- 界面出栈操作
local function pop( viewLogic )
	-- 获取栈顶界面实例
	local topCache = top()
	local topLogic = topCache[#topCache]

	if cc.PLATFORM_OS_WINDOWS == _targetPlatform then	-- windows，一般为调试时
		if viewLogic:getLogicId() ~= topLogic:getLogicId() then	-- 栈顶界面与需出栈界面不一致时，抛异常
	        error("\n***ERROR*** ViewStack ***ERROR***" .."\n topLogic Id = " .. topLogic:getLogicId() ..  " topLogic cname = " .. topLogic.__cname .."\n viewLogic Id = " .. viewLogic:getLogicId() .. "   viewLogic cname = " .. viewLogic.__cname)
		end
	else
		while viewLogic:getLogicId() ~= topLogic:getLogicId() do -- 站定界面与需出栈界面不一致时，弹出该界面，直到两个界面相同
			postEvent( topLogic, -1 )
			topLogic:onESCClicked(true)
			topCache = top()
			topLogic = topCache[#topCache]
		end
	end

	-- 出栈
	topCache[#topCache] = nil

	-- 该数据层无界面，则删掉该层
	if #topCache == 0 then
		deleteTop()
		topCache = top()
		for _, v in pairs(topCache) do
			v:setCovered(true)		-- 恢复显示状态
		end
	end

	-- 将当下的栈顶界面，置顶，并控制主界面按钮 和 返回按钮的显隐
	topLogic = topCache[#topCache]
	postEvent(viewLogic, -1, topLogic)
	if topLogic then
		if MusicHelper then
			MusicHelper.tryPlayBackgroud( topLogic.__cname )
		end
		topLogic:beTop()
	end
end

-- 检查界面是否需要进行出入栈操作
-- output: true 无需操作
--		   false 需要操作
local function check( viewLogic )
	if  viewLogic.customParent ~= nil or viewLogic.customParentLogic ~= nil or
		viewLogic.viewLevel == SceneHelper.LAYER_TYPE.FIGHT_BUTTON_LAYER or 
		viewLogic.viewLevel == SceneHelper.LAYER_TYPE.MAIN_UI_LAYER or 
		viewLogic.viewLevel == SceneHelper.LAYER_TYPE.CHAT_LAYER or 
		viewLogic.viewLevel == SceneHelper.LAYER_TYPE.LEVEL_II_XY_LAYER or 
		viewLogic.viewLevel == SceneHelper.LAYER_TYPE.LEVEL_II_Y_LAYER  or 
		viewLogic.viewLevel == SceneHelper.LAYER_TYPE.LEVEL_II_NA_LAYER or 
		viewLogic.viewLevel == SceneHelper.LAYER_TYPE.ITEM_TIPS_LAYER or 
		viewLogic.viewLevel == SceneHelper.LAYER_TYPE.GUIDE_LAYER or
		viewLogic.viewLevel == SceneHelper.LAYER_TYPE.NET_LOADING_LAYER or
		viewLogic.viewLevel == SceneHelper.LAYER_TYPE.TIPS_LAYER then
		
		return true
	elseif viewLogic.viewLevel == SceneHelper.LAYER_TYPE.TEMP_LAYER then
    	error("\n***ERROR*** ViewStack ***ERROR***" .. "\n viewLogic Id = " .. viewLogic:getLogicId() .. "   viewLogic cname = " .. viewLogic.__cname .. "\n***ERROR***  LAYER_TYPE is ERROR  ***ERROR***")
	end

	return false
end

----- 外部接口 -----
-- 界面预加载
function preloadView( viewLogic )
	_allViewStackCache[viewLogic:getLogicId()] = viewLogic

	cacheCSBName( viewLogic.csbName )
end

-- 压入界面
-- output: true 已入栈
--		   false 未入栈
function pushView( viewLogic )
	-- 检查是否需要入栈
	if check(viewLogic) then
		return false
	end

	log("pushView: viewLogic Id = " .. viewLogic:getLogicId() .. ", viewLogic cname = " .. viewLogic.__cname)

	-- 检查是否初始化
	if _init then
		init()
	end

	-- 压入界面
	push(viewLogic)

	return true
end

-- 弹出界面
function popView( viewLogic )
	-- 检查，不是单例，则从预加载表中移除对象
	if not viewLogic._isSingleton then
		_allViewStackCache[viewLogic:getLogicId()] = nil
	end

	-- 检查是否需要出栈
	if check(viewLogic) then
		return
	end

	log("popView: viewLogic Id = " .. viewLogic:getLogicId() .. ", viewLogic cname = " .. viewLogic.__cname)

	-- 弹出界面
	pop(viewLogic)
end

-- 释放所有界面
function releaseAll(  )
	for _, v in pairs(_allViewStackCache) do
		if v then
			v:release()
		end
	end
end

-- 检查，是否进行内存和垃圾回收
function checkClean( force, immediate )
	logE("_csbNameCache.csbCount  =  " .. _csbNameCache.csbCount)
	if force or _csbNameCache.csbCount >= MAX_CSB_COUNT then
		MAX_CSB_COUNT = 8
		_csbNameCache = {name = {}, csbCount = 0}

		Global.cleanCache( immediate )
	end
end
