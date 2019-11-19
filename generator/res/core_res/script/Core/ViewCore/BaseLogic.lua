-- 界面的基础类
-- noted by baofeng 20180104

-- 界面状态
VIEW_STATE = 
{
    OPEN = 0,
    CLOSE = 1,
    -- HIDE = 2,
}

BaseLogic = class("BaseLogic")
BaseLogic.pos = nil 					-- 位置坐标
BaseLogic.size = cc.size(0, 0)			-- 大小尺寸
BaseLogic.viewState = VIEW_STATE.CLOSE 	-- 状态
BaseLogic.fullScreen = true				-- 全屏显示，默认为true
BaseLogic.coverd = {					-- 自身显示状态，默认显示
	visible = true,
}
BaseLogic.viewLevel = SceneHelper.LAYER_TYPE.TEMP_LAYER	-- 显示层级
BaseLogic.customParent = nil 							
BaseLogic.childLogics = {}								-- 子节点逻辑集合
BaseLogic.netListenerCache = {}							-- socket消息注册集合
BaseLogic.webListenerCache = {}							-- web消息注册集合
BaseLogic.eventListenerCache = {}						-- 时间消息注册集合
BaseLogic.schedulerCache = {}							-- 任务事件集合

local _logicId = 0	-- 计数值


--logic 唯一标识
function BaseLogic:getLogicId(  )
	return self._logicId
end

function BaseLogic:_privateInit(  )
	-- log("**********  BaseLogic:_privateInit **********")
end

--初始化相关 自动调用
function BaseLogic:autoInit(  )
	-- log("**********  " .. self.__cname .. "  ctor **********")
	self.__newed = true
	_logicId = _logicId + 1
	self._logicId = _logicId
	self.childLogics = {}
	self.netListenerCache = {}
	self.webListenerCache = {}
	self.eventListenerCache = {}
	self.schedulerCache = {}

	self.coverd = {
		visible = true,
	}
	
	self:_privateInit()
end

--网络监听 写在此函数中
function BaseLogic:initNetListener(  )
	-- log("======BaseLogic:initNetListener=======")
end

--Web网络监听 写在此函数中
function BaseLogic:initWebListener(  )
	-- log("======BaseLogic:initWebListener=======")
end

--消息事件监听 写在此函数中
function BaseLogic:initEventListener(  )
	-- log("======BaseLogic:initEventListener=======")
end

--释放网络监听  写在此函数中
function BaseLogic:uninitNetListener(  )
	-- log("======BaseLogic:uninitNetListener=======")
end

--释放Web网络监听  写在此函数中
function BaseLogic:uninitWebListener(  )
	-- log("======BaseLogic:uninitWebListener=======")
end

--释放消息事件监听  写在此函数中
function BaseLogic:uninitEventListener(  )
	-- log("======BaseLogic:uninitEventListener=======")
end

--注册网络监听
function BaseLogic:registerNetListener( messageType, listener, priority )
	local function closure_callback( data )
		listener(self, data)
	end

	if self.netListenerCache[messageType] == nil then
		self.netListenerCache[messageType] = {}
	else
		for _, v in ipairs(self.netListenerCache[messageType]) do
			if v.lis == listener then
				logW("BaseLogic:registerNetListener: cannot repeat registered message")
				return
			end
		end
	end

	table.insert(self.netListenerCache[messageType], {closure = closure_callback, lis = listener, priority = priority})
end

--注册Web网络监听
function BaseLogic:registerWebListener( messageType, listener )
	local function closure_callback( data )
		listener(self, data)
	end
	
	if self.webListenerCache[messageType] == nil then
		self.webListenerCache[messageType] = {}
	else
		for _, v in ipairs(self.webListenerCache[messageType]) do
			if v.lis == listener then
				logW("BaseLogic:registerWebListener: cannot repeat registered web message")
				return
			end
		end
	end

	table.insert(self.webListenerCache[messageType], {closure = closure_callback, lis = listener})
end

--注册消息事件监听
function BaseLogic:registerEventListener( eventType, listener, priority )
	local function closure_callback( data )
		listener(self, data)
	end
	 
	if self.eventListenerCache[eventType] == nil then
		self.eventListenerCache[eventType] = {}
	else
		for _, v in ipairs(self.eventListenerCache[eventType]) do
			if v.lis == listener then
				logW("BaseLogic:registerEventListener: cannot repeat registered event")
				return
			end
		end
	end

	table.insert(self.eventListenerCache[eventType], {closure = closure_callback, lis = listener, priority = priority})
end

--发送网络请求
function BaseLogic:sendRequest( msgType, data, onlySend, force, delayShow )
	NetMessageSystem.sendRequest( msgType, data, onlySend, force, delayShow )
end

--发送Web网络请求
function BaseLogic:sendWebRequest( msgType, data, onlySend, autoRetry )
	WebMessageSystem.sendRequest( msgType, data, onlySend, autoRetry )
end

--派发事件
function BaseLogic:postEvent( eventType, data )
	EventSystem.dispatchEvent(eventType, data)
end

-- 向网络消息中心注册
local function realRegisterNetListener( self )
	for mt, v in pairs(self.netListenerCache) do
		for _, lis in ipairs(v) do
			NetMessageSystem.registerMessageListener(mt, lis.closure, lis.priority)
		end
	end
end

-- 从网络消息中心注销
local function realUnRegisterNetListener( self )
	for mt, v in pairs(self.netListenerCache) do
		for _, lis in ipairs(v) do
			NetMessageSystem.unregisterMessageListener(mt, lis.closure, lis.priority)
		end
	end
end

-- 向Web消息中心注册
local function realRegisterWebListener( self )
	for mt, v in pairs(self.webListenerCache) do
		for _, lis in ipairs(v) do
			WebMessageSystem.registerMessageListener(mt, lis.closure)
		end
	end
end

-- 从Web消息中心注销
local function realUnRegisterWebListener( self )
	for mt, v in pairs(self.webListenerCache) do
		for _, lis in ipairs(v) do
			WebMessageSystem.unregisterMessageListener(mt, lis.closure)
		end
	end
end

-- 向事件消息中心注册
local function realRegisterEventListener( self )
	for et, v in pairs(self.eventListenerCache) do
		for _, lis in ipairs(v) do
			EventSystem.registerEventListener(et, lis.closure, lis.priority)
		end
	end
end

-- 从事件消息中心注销
local function realUnRegisterEventListener( self )
	for et, v in pairs(self.eventListenerCache) do
		for _, lis in ipairs(v) do
			EventSystem.unregisterEventListener(et, lis.closure, lis. priority)
		end
	end
end

-- 执行调度器
function BaseLogic:schedule( nHandler, fInterval, data )
	local function closure_callback( data, dt )
		nHandler( self, data, dt )
	end

	local entryId = Scheduler.schedule(closure_callback, fInterval, data)
	self.schedulerCache[entryId] = true

	return entryId
end

-- 执行一次调度器
function BaseLogic:scheduleOnce( nHandler, fInterval, data )
	local entryId = nil
	
	local function closure_callback( data, dt )
		self.schedulerCache[entryId] = nil
		nHandler( self, data, dt )
	end

	entryId = Scheduler.scheduleOnce(closure_callback, fInterval, data)
	self.schedulerCache[entryId] = true

	return entryId
end

-- 执行N次调度器
function BaseLogic:scheduleForRepeat( nHandler, fInterval, data, nRepeat )
	local entryId = nil
	
	local function closure_callback( data, count, dt )
		if count >= nRepeat then
			self.schedulerCache[entryId] = nil
		end
		nHandler( self, data, count, dt )
	end

	entryId = Scheduler.scheduleForRepeat(closure_callback, fInterval, data, nRepeat)
	self.schedulerCache[entryId] = true

	return entryId
end

-- 停止指定定时器
function BaseLogic:unschedule( entryId )
	Scheduler.unschedule(entryId)
	self.schedulerCache[entryId] = nil
end

-- 停止所有定时器
function BaseLogic:unscheduleAll(  )
	for k, v in pairs(self.schedulerCache) do
		if v then
			Scheduler.unschedule(k)
			self.schedulerCache[k] = nil
		end
	end

	self.schedulerCache = {}
end

-- 获得界面对象
function BaseLogic:getView(  )
	error("\n*****  ERROR  getView() should be override  ERROR  *****")
	return nil
end

function BaseLogic:setVisible( visible )
	self:getView():setVisible( visible )
end

function BaseLogic:retain(  )
	
end

function BaseLogic:release(  )
	
end

function BaseLogic:isVisible(  )
	return self:getView():isVisible()
end

function BaseLogic:setScale( x, y )
	if x then
		self:getView():setScaleX(x)
	end

	if y then
		self:getView():setScaleY(y)
	end
end

function BaseLogic:isFullScreen(  )
	return self.fullScreen
end

function BaseLogic:setCovered( visible )
	if visible then
		self:setVisible(self.coverd.visible)
	else
		self.coverd.visible = self:isVisible()
		self:setVisible(false)
	end
end

function BaseLogic:addToParent( parent, parentLogic )
	self.customParent = parent
	if parent then
		parent:addChild(self:getView())
		self.customParentLogic = parentLogic
		parentLogic:addChildLogic(self)
	else
		SceneHelper.addChild(self:getView(), self.viewLevel)
	end
end

function BaseLogic:beTop(  )
	-- log("**********  " .. self.__cname .. "  beTop **********")
end

function BaseLogic:beNotTop(  )
	-- log("**********  " .. self.__cname .. "  beNotTop **********")
end

-- 完成所有消息的注册
function BaseLogic:__openView( parent, parentLogic )
	if not self.__newed then
		logW("===========   WARNNING: Logic should run the 'new()' function   ===========")
	end
	self:initNetListener()
	self:initWebListener()
	self:initEventListener()
	realRegisterNetListener( self )
	realRegisterWebListener( self )
	realRegisterEventListener( self )
end

function BaseLogic:openView( parent )
	-- log(" ***   BaseLogic:openView   *** ")
end

-- 注销所有消息，停止所有定时器
function BaseLogic:__closeView(  )
	self:unscheduleAll()

	realUnRegisterEventListener( self )
	realUnRegisterNetListener( self )
	realUnRegisterWebListener( self )

	self:uninitEventListener()
	self:uninitWebListener()
	self:uninitNetListener()

	self.netListenerCache = {}
	self.webListenerCache = {}
	self.eventListenerCache = {}

	self._createIns_ = nil
end

function BaseLogic:closeView(  )
	-- log(" ***   BaseLogic:closeView   *** ")
end

-- 刷新界面
function BaseLogic:refreshView( data )
	-- log(" ***   BaseLogic:refreshView   *** ")
	self:onRefresh( self:getView(), data )
end

-- 获得界面状态
function BaseLogic:isOpen(  )
	return self.viewState == VIEW_STATE.OPEN
end

-- 单例模式 只有第一次的时候需要创建一些东西
function BaseLogic:onFirstOpen( view )
	-- log(" ***   BaseLogic:onFirstOpen   *** ")
end

function BaseLogic:onOpen( view )
	-- log(" ***   BaseLogic:onOpen   *** ")
end

function BaseLogic:onClose( view )
	-- log(" ***   BaseLogic:onClose   *** ")
end

function BaseLogic:onRefresh( view, data )
	-- log(" ***   BaseLogic:onRefresh   *** ")
end

--坐标
function BaseLogic:setPosition( pos )
	self.pos = pos
	if self:isOpen() then
		self:getView():setPosition( pos )
	end
end

function BaseLogic:getPosition(  )
	return self.pos
end

function BaseLogic:getContentSize(  )
	return self.size
end

function BaseLogic:addChild( child )
	self:getView():addChild(child)
end

function BaseLogic:getParent(  )
	return self:getView():getParent()
end

-- 复制指定节点的参数到目标节点
-- input: srcNode 指定节点
--		  desNode 目标节点
function BaseLogic:cloneProps( srcNode, desNode )
	local nodeX, nodeY = srcNode:getPosition()

	desNode:setAnchorPoint(srcNode:getAnchorPoint())
	desNode:setPosition(cc.p(nodeX, nodeY))
	desNode:setLocalZOrder(srcNode:getLocalZOrder())
	desNode:setScaleX(srcNode:getScaleX())
	desNode:setScaleY(srcNode:getScaleY())
	desNode:setRotationSkewX(srcNode:getRotationSkewX())
	desNode:setRotationSkewY(srcNode:getRotationSkewY())
	desNode:setVisible(srcNode:isVisible())
end

-- 用目标对象替换指定节点，并复制其参数
-- input: tempNode: 指定节点
--		  newNodeLogic: 目标对象
function BaseLogic:replaceWithLogicByNode( tempNode, newNodeLogic )
	local tempNodeX, tempNodeY = tempNode:getPosition()
	local parent = tempNode:getParent()

	newNodeLogic:openView( parent, self )
	newNodeLogic:setPosition(cc.p(tempNodeX, tempNodeY))

	local newNode = newNodeLogic:getView()
	newNode:setLocalZOrder(tempNode:getLocalZOrder())
	newNode:setScaleX(tempNode:getScaleX())
	newNode:setScaleY(tempNode:getScaleY())
	newNode:setTag(tempNode:getTag())
	newNode:setName(tempNode:getName())

	if tempNode.logic then
		tempNode.logic:closeView()
	else
		tempNode:removeFromParent()
	end

	return newNodeLogic
end

-- 用目标对象来替换指定名称的节点，并复制其参数
-- input: name 指定节点的名称
--		  newNodeLogic 目标对象
--		  parent 指定节点的父节点
function BaseLogic:replaceWithLogicByName( name, newNodeLogic, parent )
	local tempNode = self:getChildByName(name, parent)
	return self:replaceWithLogicByNode(tempNode, newNodeLogic)
end

-- 用目标节点来替换指定名称的节点，并复制其参数
-- input: tempNode 指定节点
--		  newNode 目标节点
function BaseLogic:replaceWithNodeByNode( tempNode, newNode )
	local tempNodeX, tempNodeY = tempNode:getPosition()
	local parent = tempNode:getParent()

	self:cloneProps( tempNode, newNode )
	newNode:setName(tempNode:getName())

	tempNode:removeFromParent()
	parent:addChild(newNode)

	return newNode
end


-- 只是把源节点隐藏 并不删除
-- 用目标节点来替换指定名称的节点，并复制其参数
-- input: tempNode 指定节点
--		  newNode 目标节点
function BaseLogic:weakReplaceWithNodeByNode( tempNode, newNode )
	local tempNodeX, tempNodeY = tempNode:getPosition()
	local parent = tempNode:getParent()
	tempNode:setVisible(false)

	self:cloneProps( tempNode, newNode )

	parent:addChild(newNode)
	newNode:setVisible(true)

	return newNode
end

-- 用目标节点来替换指定名称的节点，并复制其参数
-- input: name 指定节点的名称
--		  newNode 目标节点
--		  parent 指定节点的父节点
function BaseLogic:replaceWithNodeByName( name, newNode, parent )
	local tempNode = self:getChildByName(name, parent)
	return self:replaceWithNodeByNode(tempNode, newNode)
end

-- 当查找的child不存在时，返回一个table，防止崩溃的发送
local nilChildMetatable = {
    __index = function ( t, k )
        error("\n***ERROR***  " .. t.viewLogicName .. "(csb:" .. t.csbName .. ") dosen't have child node " .. t.childName .. "  ***ERROR***")
    end,
    __newindex = function ( t, k, v )
        error("\n***ERROR***  " .. t.viewLogicName .. "(csb:" .. t.csbName .. ") dosen't have child node " .. t.childName .. "  ***ERROR***")
    end
}


local function getNilChild( self, name )
	local t = { viewLogicName = self.__cname, csbName = self.csbName, childName = name, isNodeExist = false }
	setmetatable(t, nilChildMetatable)
	return t
end

--Node相关
function BaseLogic:getChildByName( name, baseNode )
	local node = ccui.Helper:seekNodeByName(baseNode or self:getView(), name)
	if node then
		node.isNodeExist = true
		return node
	else
		return getNilChild(self, name)
	end
end

function BaseLogic:getChildByTag( tag, baseNode )
	local node = ccui.Helper:seekNodeByTag( baseNode or self:getView(), tag )
	if node then
		node.isNodeExist = true
		return node
	else
		return getNilChild( self, tag )
	end
end

function BaseLogic:addChildLogic( logic )
	self.childLogics[#self.childLogics + 1] = logic
end 

function BaseLogic:removeChildLogic( logic )
	for i,v in pairs(self.childLogics) do
		if v == logic then
			self.childLogics[i] = nil
			break
		end
	end
end

function BaseLogic:clearChildLogic(  )
	for i,v in pairs(self.childLogics) do
		if v.parentLogic then
			v:realCloseView()
		else
			v:closeView()
		end
	end

	self.childLogics = {}
end