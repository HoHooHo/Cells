-- local CCS_FILE_NAME_PREFIX = ""
local CCS_FILE_NAME_PREFIX = "csb/"
local CCS_FILE_NAME_SUFFIX = ".csb"

ViewBaseLogic = class("ViewBaseLogic", BaseLogic)
ViewBaseLogic.csbName = ""
ViewBaseLogic.fullCSBName = ""
ViewBaseLogic.csbRootNode = nil
ViewBaseLogic.csbTimeline = nil
ViewBaseLogic.parentLogic = nil
ViewBaseLogic.loaded = false

ViewBaseLogic.instanceLoaded = false

-- ViewBaseLogic.eventListeners = {}

local _tempId = 0
--某些面板不需要单独写一个viewlogic时，调用此函数创建
function ViewBaseLogic:createLogic( csbName, parentLogic )
	_tempId = _tempId + 1
	local logic = class(csbName .. "TempViewLogic_" .. _tempId, parentLogic or ViewBaseLogic)
	logic.csbName = csbName

	return logic
end

-- 配置csb文件全路径，外部切勿调用
function ViewBaseLogic:_privateInit(  )
	self.fullCSBName = (self.ccsPrefix or CCS_FILE_NAME_PREFIX) .. self.csbName .. CCS_FILE_NAME_SUFFIX
end

--初始化CSB节点
function ViewBaseLogic:initCSBNode(  )
	if self.csbRootNode == nil then
		log("will init fullCSBName = " .. self.fullCSBName)
		self.csbRootNode = cc.CSLoader:createNode(self.fullCSBName)
		self.csbRootNode.logic = self
		self.size = self.csbRootNode:getContentSize()
		-- log("csbRootNode: name = " .. self.csbRootNode:getName() .. "  width = " .. self.size.width .. "  height = " .. self.size.height)
	end
end

--初始化CSB动画
function ViewBaseLogic:initCSBTimeline(  )
	if self.csbTimeline == nil then
		self.csbTimeline = cc.CSLoader:createTimeline(self.fullCSBName)
	end
end

--初始化CSB
function ViewBaseLogic:initCSB(  )
	self:initCSBNode()
	self:initCSBTimeline()

	self.csbRootNode:runAction(self.csbTimeline)
	self.csbTimeline:gotoFrameAndPause(0)
end

-- 进行坐标变换，使居中放置
local function convertPosition( self )
	if self.pos == nil then
		self.pos = cc.p(0, 0)
		local ap = self.csbRootNode:getAnchorPoint()

		local size = self.csbRootNode:getParent():getContentSize()
		self.pos = cc.p(size.width / 2 - self.size.width * (0.5 - ap.x), size.height / 2 - self.size.height * (0.5 - ap.y))
	end
	self.csbRootNode:setPosition(self.pos)
end

-- 添加到父节点
local function addToParent( self, parent, parentLogic )
	self.customParent = parent
	if parent then
		parent:addChild( self.csbRootNode )
		self.customParentLogic = parentLogic
		parentLogic:addChildLogic( self )
	elseif parentLogic then
		self.customParentLogic = parentLogic
		parentLogic:addChildLogic( self )
	elseif self.viewLevel == SceneHelper.LAYER_TYPE.LEVEL_II_XY_LAYER then
		self.parentLogic = Level2NAViewLogic.new( self )
		self.parentLogic:openView()
		self.parentLogic:getActionNode():addChild(self.csbRootNode)
		
		self.parentLogic:addChildLogic( self )
	elseif self.viewLevel == SceneHelper.LAYER_TYPE.LEVEL_II_Y_LAYER then
		self.parentLogic = Level2NAViewLogic.new( self )
		self.parentLogic:openView()
		self.parentLogic:getActionNode():addChild(self.csbRootNode)
		
		self.parentLogic:addChildLogic( self )
	elseif self.viewLevel == SceneHelper.LAYER_TYPE.LEVEL_II_NA_LAYER then
		self.parentLogic = Level2NAViewLogic.new( self )
		self.parentLogic:openView()
		self.parentLogic:getActionNode():addChild(self.csbRootNode)
		
		self.parentLogic:addChildLogic( self )
	else
		SceneHelper.addChild(self.csbRootNode, self.viewLevel)
	end
end

function ViewBaseLogic:retain(  )
	self.loaded = true
	self.csbRootNode:retain()
	self.csbTimeline:retain()
end

function ViewBaseLogic:release(  )
	self.csbTimeline:release()
	self.csbRootNode:release()
	
	self.loaded = false
end

-- 界面预加载
function ViewBaseLogic:preload()
	if not self.loaded then

		self:initCSB()

		self:retain()

		ViewStack.preloadView(self)
	end
end

-- 是否需要load
local function needLoad( self )
	return not self._isSingleton or not self.instanceLoaded
end

function ViewBaseLogic:tryNoviceGuide()
	self:postEvent( EventType.GUIDE_TRY, self.csbName )
end

-- 显示界面
function ViewBaseLogic:openView( parent, parentLogic )
	local logStr = "View state is already VIEW_STATE.OPEN: "

	if self.viewState == VIEW_STATE.CLOSE then
		local startTime = socket.gettime()

		self:preload()
		
		self:__openView(parent, parentLogic)

		if parentLogic == nil and parent ~= nil then
			parentLogic = parent.logic
		end

		addToParent(self, parent, parentLogic)
		convertPosition(self)

		self.viewState = VIEW_STATE.OPEN
		
		local inStack = ViewStack.pushView(self)

		if needLoad(self) then
			self.instanceLoaded = true
			self:onFirstOpen( self.csbRootNode )
		end

		self:onOpen( self.csbRootNode )

		if parent == nil then
			self:tryNoviceGuide()
		end

		if parent == nil then
			if MusicHelper then
				MusicHelper.tryPlayBackgroud( self.__cname )
			end
			self:beTop()
		end

		logStr = "ViewBaseLogic:openView():  "
		local endTime = socket.gettime()
		self.useTime = endTime - startTime
	end

	log(logStr .. self.__cname .. "  " .. self.csbName .. "  " .. self:getLogicId() .. " parse use time: " .. self.useTime)

	return self.csbRootNode
end

--辅助动画的私有类，外部请勿调用
function ViewBaseLogic:realCloseView(  )
	log("ViewBaseLogic:realCloseView():  " .. self.__cname .. "   " .. self.csbName)

	ViewStack.popView(self)

	if not self._isSingleton then
		self:clearChildLogic()
	end

	if self.customParentLogic then
		self.customParentLogic:removeChildLogic(self)
	end

	self.csbRootNode:removeFromParent(not self._isSingleton)

	self:onClose(self.csbRootNode)

	if not self._isSingleton then
		self:release()
		self.csbRootNode = nil
		self.csbTimeline = nil
		-- self.pos = cc.p(0, 0)
		self.pos = nil
	end

	self.viewState = VIEW_STATE.CLOSE

	self:__closeView(  )

	if self.parentLogic and self.closeCB then
		self.parentLogic.closeCB = self.closeCB
	elseif self.closeCB and type(self.closeCB) == "function" then
		self.closeCB()
	end
end

-- ESC键回调
function ViewBaseLogic:onESCClicked( data )
	self:closeView(data)
end


-- 关闭界面回调
function ViewBaseLogic:closeView( cb )
	-- local function delayCloseView()
		if self.viewState == VIEW_STATE.OPEN then
			log("ViewBaseLogic:closeView():  "..self.__cname.."   "..self.csbName)

			if self.__itemTips__ then
				self.__itemTips__:closeView()
			end
			self.__itemTips__  = nil

			self.closeCB = cb

			if self.parentLogic then
				self.parentLogic.onSubCloseData = cb
				self.parentLogic:closeView(  )
			else
				self:realCloseView(  )
			end

		else
			log("View state is already VIEW_STATE.CLOSE: " .. self.__cname .. "  " .. self.csbName)
		end
	-- end
	-- Scheduler.scheduleOnce( delayCloseView, 0.00001)
end

-- 获取csb名称
function ViewBaseLogic:getCSBName(  )
	return self.csbName
end

-- 获取root节点对象
function ViewBaseLogic:getView(  )
	if self.csbRootNode == nil then
		self:initCSBNode()
	end

	return self.csbRootNode
end

-- 获取timeline对象
function ViewBaseLogic:getCSBTimeline(  )
	if self.csbTimeline == nil then
		self:initCSBTimeline()
	end

	return self.csbTimeline
end

--二级面板 或 三级面板 等 打开 或 关闭 动画结束的监听
function ViewBaseLogic:openActionListener(  )
	-- log(" ***   ViewBaseLogic:openActionListener   *** ")
end

function ViewBaseLogic:closeActionListener(  )
	-- log(" ***   ViewBaseLogic:closeActionListener   *** ")
end

-- local function cacheListener( self, listener )
-- 	self.eventListeners[#self.eventListeners + 1] = listener
-- end

--触摸事件
function ViewBaseLogic:addClickEventListener( uiWidget, callback )
	if uiWidget == nil then
        error("\n\n***ERROR*** uiWidget is nil  ***ERROR***")
    elseif callback == nil then
        error("\n\n***ERROR*** callback is nil  ***ERROR***")
	end

	if uiWidget.addClickEventListener then 	--uiWidget
		local closure_callback = function ( sender )
			callback(self, sender)							-- 注意，这里是回调的参数模板
		end
		uiWidget:addClickEventListener(closure_callback)
	else 	--a node, but not uiWidget
		if uiWidget.setOwnAudioName == nil then
			uiWidget.setOwnAudioName = function ( uiWidget, audioName )
				uiWidget._ownAudioName = audioName
			end
		end
		
	    local function onTouchBegan( touch, event )
	        local target = event:getCurrentTarget()

	        if not Global.isAncestorsVisible(target) then
	        	return false
	        end
	        
	        local locationInNode = target:convertToNodeSpace(touch:getLocation())
	        local s = target:getContentSize()
	        local rect = cc.rect(0, 0, s.width, s.height)

		    if cc.rectContainsPoint(rect, locationInNode) then
		    	-- log(event:getEventCode())
		        return true
		    end

	    	return false
	    end

	    local function onTouchMoved( touch, event )
	    	-- log(event:getEventCode())
	    end

	    local function onTouchEnded( touch, event )
	        local target = event:getCurrentTarget()
	        
	        local locationInNode = target:convertToNodeSpace(touch:getLocation())
	        local s = target:getContentSize()
	        local rect = cc.rect(0, 0, s.width, s.height)

		    if cc.rectContainsPoint(rect, locationInNode) then
		    	-- log(event:getEventCode())
		    	AudioManager.play(target._ownAudioName)
				callback(self, target)
			else
		    	-- log(event:getEventCode() + 1)
		    end
	    end

	    local listener = cc.EventListenerTouchOneByOne:create()
	    listener:setSwallowTouches(true)
	    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
	    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
	    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )

	    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
	    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, uiWidget)

	    uiWidget.clickListener = listener

	    -- cacheListener(self, listener)
	end
end

function ViewBaseLogic:addTouchEventListener( uiWidget, callback, needTouch )
	if uiWidget == nil then
        error("\n\n***ERROR*** uiWidget is nil  ***ERROR***")
    elseif callback == nil then
        error("\n\n***ERROR*** callback is nil  ***ERROR***")
	end
	
	if uiWidget.addClickEventListener and not needTouch then 	--uiWidget
		local closure_callback = function ( sender, eventType )
			callback(self, sender, eventType)
		end
		uiWidget:addTouchEventListener(closure_callback)
	else 	--a node, but not uiWidget
		if uiWidget.addTouchEventListener then
			uiWidget:setTouchEnabled(false)
		end
		
	    local function onTouchBegan(touch, event)
	        local target = event:getCurrentTarget()

	        if not Global.isAncestorsVisible(target) then
	        	return false
	        end
	        
	        local locationInNode = target:convertToNodeSpace(touch:getLocation())
	        local s = target:getContentSize()
	        local rect = cc.rect(0, 0, s.width, s.height)

		    if cc.rectContainsPoint(rect, locationInNode) then
		    	-- log(event:getEventCode())
		    	callback(self, target, event:getEventCode(), touch)
		        return true
		    end

	    	return false
	    end

	    local function onTouchMoved(touch, event)
	    	-- log(event:getEventCode())
	        local target = event:getCurrentTarget()
	    	callback(self, target, event:getEventCode(), touch)
	    end

	    local function onTouchEnded(touch, event)
	        local target = event:getCurrentTarget()
	        
	        local locationInNode = target:convertToNodeSpace(touch:getLocation())
	        local s = target:getContentSize()
	        local rect = cc.rect(0, 0, s.width, s.height)

		    if cc.rectContainsPoint(rect, locationInNode) then
		    	-- log(event:getEventCode())
				callback(self, target, event:getEventCode(), touch)
			else
		    	-- log(event:getEventCode() + 1)
				callback(self, target, event:getEventCode() + 1, touch)
		    end
	    end

	    local listener = cc.EventListenerTouchOneByOne:create()
	    listener:setSwallowTouches(true)
	    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
	    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
	    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )

	    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
	    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, uiWidget)

	    uiWidget.touchListener = listener

	    -- cacheListener(self, listener)
	end
end

-- 类似按钮 有 点击响应事件
-- 但是 当按住或滑动时 在有效区域内 特殊显示（类似按钮的按住状态）时，可以使用此函数
function ViewBaseLogic:addTouchActiveListener( uiWidget, activeCallback, clickCallback )
	if uiWidget == nil then
        error("\n\n***ERROR*** uiWidget is nil  ***ERROR***")
    elseif activeCallback == nil then
        error("\n\n***ERROR*** activeCallback is nil  ***ERROR***")
    elseif clickCallback == nil then
        error("\n\n***ERROR*** clickCallback is nil  ***ERROR***")
	end

	if uiWidget.addTouchEventListener then
		uiWidget:setTouchEnabled(false)
	end

	uiWidget.____WidgetActiveState____ = false
	
    local function onTouchBegan(touch, event)
        local target = event:getCurrentTarget()

        if not Global.isAncestorsVisible(target) then
        	return false
        end
        
        local locationInNode = target:convertToNodeSpace(touch:getLocation())
        local s = target:getContentSize()
        local rect = cc.rect(0, 0, s.width, s.height)

	    if cc.rectContainsPoint(rect, locationInNode) then
	    	target.____WidgetActiveState____ = true
	    	activeCallback(self, target, target.____WidgetActiveState____)
	        return true
	    end

    	return false
    end

    local function onTouchMoved(touch, event)
        local target = event:getCurrentTarget()
        
        local locationInNode = target:convertToNodeSpace(touch:getLocation())
        local s = target:getContentSize()
        local rect = cc.rect(0, 0, s.width, s.height)
        local isContains = cc.rectContainsPoint(rect, locationInNode)

        if target.____WidgetActiveState____ ~= isContains then
        	target.____WidgetActiveState____ = isContains
	    	activeCallback(self, target, target.____WidgetActiveState____)
        end
    end

    local function onTouchEnded(touch, event)
        local target = event:getCurrentTarget()
        
        local locationInNode = target:convertToNodeSpace(touch:getLocation())
        local s = target:getContentSize()
        local rect = cc.rect(0, 0, s.width, s.height)

        if target.____WidgetActiveState____ then
	    	target.____WidgetActiveState____ = false
	    	activeCallback(self, target, target.____WidgetActiveState____)
        end

        if cc.rectContainsPoint(rect, locationInNode) then
	    	-- 按钮声音 统一处理
			AudioManager.play(AUDIO_NORMAL_CLICK)
        	clickCallback(self, target)
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )

    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, uiWidget)

    uiWidget.touchListener = listener
end

-- Widget控件 使用C++原生实现addTouchActiveListener的效果
-- 类似按钮 有 点击响应事件
-- 但是 当按住或滑动时 在有效区域内 特殊显示（类似按钮的按住状态）时，可以使用此函数
-- 当该控件的某个父节点可滑动，且按住该控件滑动一定像素后，认为是滑动，取消点击响应
function ViewBaseLogic:addWidgetTouchActiveListener( uiWidget, activeCallback, clickCallback )
	if uiWidget == nil then
        error("\n\n***ERROR*** uiWidget is nil  ***ERROR***")
    elseif activeCallback == nil then
        error("\n\n***ERROR*** activeCallback is nil  ***ERROR***")
    elseif clickCallback == nil then
        error("\n\n***ERROR*** clickCallback is nil  ***ERROR***")
	end

	uiWidget.____WidgetActiveState____ = false
	uiWidget.____WidgetIsMoveAction____ = false

	local offsetDis = 10
	
    local function onTouchBegan(sender)
    	local touchBeganPosition = sender:getTouchBeganPosition()
        local locationInNode = sender:convertToNodeSpace(touchBeganPosition)
        local s = sender:getContentSize()
        local rect = cc.rect(0, 0, s.width, s.height)

	    if cc.rectContainsPoint(rect, locationInNode) then
	    	sender.____WidgetActiveState____ = true
	    	activeCallback(self, sender, sender.____WidgetActiveState____)
	        return true
	    end

    	return false
    end

    local function onTouchMoved(sender)
    	if not sender.____WidgetIsMoveAction____ then
	    	local touchBeganPosition = sender:getTouchBeganPosition()
	    	local touchMovePosition = sender:getTouchMovePosition()
	    	if not NoviceGuideManager.isGuide() and (math.abs(touchMovePosition.x - touchBeganPosition.x) > offsetDis or math.abs(touchMovePosition.y - touchBeganPosition.y) > offsetDis) then
	    		sender.____WidgetIsMoveAction____ = true
	    		if sender.____WidgetActiveState____ then
			    	sender.____WidgetActiveState____ = false
			    	activeCallback(self, sender, sender.____WidgetActiveState____)
	    		end
		    else
		        local locationInNode = sender:convertToNodeSpace(touchMovePosition)
		        local s = sender:getContentSize()
		        local rect = cc.rect(0, 0, s.width, s.height)
		        local isContains = cc.rectContainsPoint(rect, locationInNode)

		        if sender.____WidgetActiveState____ ~= isContains then
		        	sender.____WidgetActiveState____ = isContains
			    	activeCallback(self, sender, sender.____WidgetActiveState____)
		        end
	    	end
    	end
    end

    local function onTouchEnded(sender)
        sender.____WidgetIsMoveAction____ = false

        if sender.____WidgetActiveState____ then
	    	sender.____WidgetActiveState____ = false
	    	activeCallback(self, sender, sender.____WidgetActiveState____)
	    	-- 按钮声音 统一处理
			AudioManager.play(AUDIO_NORMAL_CLICK)
        	clickCallback(self, sender)
        end
    end

    local function onTouchCancelled(sender)
        sender.____WidgetIsMoveAction____ = false

        if sender.____WidgetActiveState____ then
	    	sender.____WidgetActiveState____ = false
	    	activeCallback(self, sender, sender.____WidgetActiveState____)
        end
    end

    local function onTouch( sender, eventType )
		if eventType == cc.EventCode.BEGAN then
			onTouchBegan(sender)
		elseif eventType == cc.EventCode.MOVED then
			onTouchMoved(sender)
		elseif eventType == cc.EventCode.ENDED then
			onTouchEnded(sender)
		elseif eventType == cc.EventCode.CANCELLED then
			onTouchCancelled(sender)
		end
	end

	uiWidget:addTouchEventListener(onTouch)
end

-- 按钮 可以任意拖拽 改变其位置
function ViewBaseLogic:addDragClickEventListener( uiWidget, dragEndCallback, clickCallback, moveNode, moveRect )
	if uiWidget == nil then
        error("\n\n***ERROR*** uiWidget is nil  ***ERROR***")
    elseif clickCallback == nil then
        error("\n\n***ERROR*** clickCallback is nil  ***ERROR***")
	end

	moveNode = moveNode or uiWidget

	local offsetDis = 10
	uiWidget.____WidgetIsMoveAction____ = false
	moveNode.____nodePos____ = cc.p(0, 0)

	moveRect = moveRect or {x = 0, y = 0, width = WIN_SIZE.width, height = WIN_SIZE.height}
	
    local function onTouchBegan(sender)
    	local touchBeganPosition = sender:getTouchBeganPosition()

		local x, y = moveNode:getPosition()
		moveNode.____nodePos____ = cc.p(x, y)

        local locationInNode = sender:convertToNodeSpace(touchBeganPosition)
        local s = sender:getContentSize()
        local rect = cc.rect(0, 0, s.width, s.height)

	    if cc.rectContainsPoint(rect, locationInNode) then
	        return true
	    end

    	return false
    end

    local function onTouchMoved(sender)
    	local touchBeganPosition = sender:getTouchBeganPosition()
    	local touchMovePosition = sender:getTouchMovePosition()

    	if math.abs(touchMovePosition.x - touchBeganPosition.x) > offsetDis or math.abs(touchMovePosition.y - touchBeganPosition.y) > offsetDis then
    		sender.____WidgetIsMoveAction____ = true
    	end

    	local pos = cc.pAdd(moveNode.____nodePos____, cc.pSub(touchMovePosition, touchBeganPosition))
    	pos.x = math.max(pos.x, moveRect.x)
    	pos.x = math.min(pos.x, moveRect.x + moveRect.width)

    	pos.y = math.max(pos.y, moveRect.y)
    	pos.y = math.min(pos.y, moveRect.y + moveRect.height)

		moveNode:setPosition(pos)
    end

    local function onTouchEnded(sender)
    	if sender.____WidgetIsMoveAction____ then
    		if dragEndCallback then
	        	dragEndCallback(self, sender)
    		end
    	else
	        local locationInNode = sender:convertToNodeSpace(sender:getTouchEndPosition())
	        local s = sender:getContentSize()
	        local rect = cc.rect(0, 0, s.width, s.height)

	        if cc.rectContainsPoint(rect, locationInNode) then
		    	-- 按钮声音 统一处理
				AudioManager.play(AUDIO_NORMAL_CLICK)
	        	clickCallback(self, sender)
	        end
        end
        
        sender.____WidgetIsMoveAction____ = false
    end

    local function onTouchCancelled(sender)
        sender.____WidgetIsMoveAction____ = false
    end

    local function onTouch( sender, eventType )
		if eventType == cc.EventCode.BEGAN then
			onTouchBegan(sender)
		elseif eventType == cc.EventCode.MOVED then
			onTouchMoved(sender)
		elseif eventType == cc.EventCode.ENDED then
			onTouchEnded(sender)
		elseif eventType == cc.EventCode.CANCELLED then
			onTouchCancelled(sender)
		end
	end

	uiWidget:addTouchEventListener(onTouch)
end

function ViewBaseLogic:addCheckBoxEventListener( checkBox, callback )
	checkBox:addEventListener(function ( sender, type )
		-- 安装包已经发布，不能在C++统一处理了，放在这里统一处理
		AudioManager.play(AUDIO_NORMAL_CLICK)
		callback(self, sender, type == ccui.CheckBoxEventType.selected)
	end)
end

function ViewBaseLogic:addClickEventListenerByName( name, callback )
	self:addClickEventListener(self:getChildByName(name), callback)
end

function ViewBaseLogic:addClickEventListenerByTag( tag, callback )
	self:addClickEventListener(self:getChildByTag(tag), callback)
end

function ViewBaseLogic:addTouchEventListenerByName( name, callback, needTouch )
	self:addTouchEventListener(self:getChildByName(name), callback, needTouch)
end

function ViewBaseLogic:addCheckBoxEventListenerByName( name, callback )
	self:addCheckBoxEventListener(self:getChildByName(name), callback)
end

function ViewBaseLogic:closeTips(  )
	if self.__itemTips__ then
		self.__itemTips__:closeView()
	end
	self.__itemTips__  = nil
end

-- 添加道具的点击显示内容
function ViewBaseLogic:addTouchTips( node, callback )
	self.__itemTips__ = nil

	local function onTouchEvent( self, sender, eventType )
		if eventType == ccui.TouchEventType.began then
			if self.__itemTips__ then
				self.__itemTips__:closeView()
			end
			self.__itemTips__ = nil

			local data, detailData, offset = callback(self, sender)
			if data or detailData then
				offset = offset or cc.p(0, 0)

				local pos = sender:getTouchBeganPosition()
				pos = SceneHelper.getLayer(SceneHelper.LAYER_TYPE.ITEM_TIPS_LAYER):convertToNodeSpace(pos)

				local paramData = {}
				if detailData then
					paramData = {title = detailData.name or detailData.title, content = detailData.des or detailData.desc or detailData.content, values = detailData.values, colors = detailData.colors}
				else
					paramData = {id = data.id, type = data.type}
				end

				AudioManager.play(AUDIO_NORMAL_CLICK)
				self.__itemTips__ = CommonItemDesTips.new(paramData)
				self.__itemTips__:openView()
				self.__itemTips__:setPositionAndFitSize(pos.x + offset.x, pos.y + offset.y)
			end
		elseif eventType == ccui.TouchEventType.ended then
			if self.__itemTips__ then
				self.__itemTips__:closeView()
			end
			self.__itemTips__  = nil
		elseif eventType == ccui.TouchEventType.moved then
		elseif eventType == ccui.TouchEventType.canceled then
			self:closeTips()
		end
	end

	self:addTouchEventListener(node, onTouchEvent)
end

function ViewBaseLogic:addTouchTipsByName( name, callback )
	self:addTouchTips(self:getChildByName(name), callback)
end

function ViewBaseLogic:removeClickEventListener( uiWidget )
	if uiWidget.clickListener then
	    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
	    eventDispatcher:removeEventListener(uiWidget.clickListener)
    elseif uiWidget.addClickEventListener then
		uiWidget:setTouchEnabled(false)
	end
end

function ViewBaseLogic:removeTouchEventListener( uiWidget )
	if uiWidget.touchListener then
	    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
	    eventDispatcher:removeEventListener(uiWidget.touchListener)
    elseif uiWidget.addTouchEventListener then
		uiWidget:setTouchEnabled(false)
	end
end

function ViewBaseLogic:removeClickEventListenerByName( name )
	self:removeClickEventListener( self:getChildByName( name ) )
end

function ViewBaseLogic:removeClickEventListenerByTag( tag )
	self:removeClickEventListener( self:getChildByTag( tag ) )
end

function ViewBaseLogic:removeTouchEventListenerByName( name )
	self:removeTouchEventListener( self:getChildByName( name ))
end

function ViewBaseLogic:removeTouchEventListenerByTag( tag )
	self:removeTouchEventListener( self:getChildByTag( tag ) )
end

--动画
local function playAnim( self, timeline, from, to, loop, currentFrame )
	if self:getView():getNumberOfRunningActions() == 0 then
		self:getView():runAction(timeline)
	end
	
	timeline:gotoFrameAndPlay(from or 0, to or timeline:getDuration(  ), currentFrame or from or 0, loop or false)
end

function ViewBaseLogic:play( from, to, loop, currentFrame )
	if not self:isOpen() then
		self:openView()
	end
	playAnim( self, self:getCSBTimeline(), from, to, loop, currentFrame )
	-- self:getCSBTimeline():gotoFrameAndPlay(from or 0, to or self:getDuration(  ), currentFrame or from or 0, loop or true)
end

function ViewBaseLogic:playByName( name, loop )
	self:play( name.from, name.to, loop, name.from )
end

function ViewBaseLogic:pause(  )
	self:getCSBTimeline():pause(  )
end

function ViewBaseLogic:gotoFrameAndPause( idx )
	self:getCSBTimeline():gotoFrameAndPause(idx)
end

function ViewBaseLogic:resume(  )
	self:getCSBTimeline():resume(  )
end

function ViewBaseLogic:stop(  )
	local endFrame = self:getEndFrame()
	if endFrame > 0 then
		self:setCurrentFrame( endFrame- 1 )
	end
	self:getCSBTimeline():stop(  )
end

function ViewBaseLogic:isPlaying(  )
	return self:getCSBTimeline():isPlaying()
end

function ViewBaseLogic:setTimeSpeed( speed )
	self:getCSBTimeline():setTimeSpeed( speed )
end

function ViewBaseLogic:getTimeSpeed(  )
	return self:getCSBTimeline():getTimeSpeed()
end

function ViewBaseLogic:getDuration(  )
	return self:getCSBTimeline():getDuration()
end

function ViewBaseLogic:getStartFrame(  )
	return self:getCSBTimeline():getStartFrame()
end

function ViewBaseLogic:setCurrentFrame( idx )
	self:getCSBTimeline():setCurrentFrame( idx )
end

function ViewBaseLogic:getCurrentFrame(  )
	return self:getCSBTimeline():getCurrentFrame()
end

function ViewBaseLogic:getEndFrame(  )
	return self:getCSBTimeline():getEndFrame()
end

function ViewBaseLogic:setFrameEventCallFunc( callback )
	local closure_callback = function ( frame )
		callback( self, frame )
	end
	self:getCSBTimeline():setFrameEventCallFunc( closure_callback )
end

function ViewBaseLogic:clearFrameEventCallFunc(  )
	self:getCSBTimeline():clearFrameEventCallFunc(  )
end

function ViewBaseLogic:setLastFrameCallFunc( callback )
	local closure_callback = function (  )
		callback( self )
	end
	self:getCSBTimeline():setLastFrameCallFunc( closure_callback )
end

function ViewBaseLogic:clearLastFrameCallFunc(  )
	self:getCSBTimeline():clearLastFrameCallFunc(  )
end

local function cloneTimelines( fromActionTimeline, toActionTimeline, fromActionNode, toActionNode )
	local timelines = fromActionTimeline:getTimelinesByNode( fromActionNode )

	local duration = fromActionTimeline:getDuration()
	if toActionTimeline:getDuration() < duration then
		toActionTimeline:setDuration(duration)
	end

	for i,v in ipairs(timelines) do
		local timeline = v:clone()
		local actionTag = toActionNode:getUserObject():getActionTag()
		timeline:setActionTag(actionTag)
		timeline:setNode( toActionNode )
		toActionTimeline:addTimeline(timeline)
	end
end

function ViewBaseLogic:copyAnimByNode( fromActionTimeline, fromActionNodes, toActionNodes )
	for i,v in ipairs(fromActionNodes) do
		cloneTimelines(fromActionTimeline, self:getCSBTimeline(), v, toActionNodes[i] )
	end
end

function ViewBaseLogic:copyAnimByName( fromActionTimeline, fromRootNode, fromActionNodeNames, toActionNodeNames )
	toActionNodeNames = toActionNodeNames or fromActionNodeNames
	for i,v in ipairs(fromActionNodeNames) do
		cloneTimelines(fromActionTimeline, self:getCSBTimeline(), BaseLogic:getChildByName(v, fromRootNode) , self:getChildByName(toActionNodeNames[i]) )
	end
end

local function removeAnim( actionTimeline, node )
	local timelines = actionTimeline:getTimelinesByNode( node )

	for i,v in ipairs(timelines) do
		actionTimeline:removeTimeline(v)
	end
end

function ViewBaseLogic:removeAnimByNodes( actionNodes )
	for i,v in ipairs(actionNodes) do
		removeAnim( self:getCSBTimeline(), v )
	end
end

function ViewBaseLogic:removeAnimByNames( actionNodeNames )
	for i,v in ipairs(actionNodeNames) do
		removeAnim( self:getCSBTimeline(), self:getChildByName(v) )
	end
end