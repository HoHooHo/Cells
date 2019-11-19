-- spine动画操作接口
-- noted by baofeng 20180117

SpineBaseLogic = class("SpineBaseLogic", BaseLogic)
SpineBaseLogic.armatureName = ""
SpineBaseLogic.armatureFileName = ""
SpineBaseLogic.atlasFileName = ""
SpineBaseLogic.jsonFileName = ""
SpineBaseLogic.armatureRootNode = nil
SpineBaseLogic.armatureType = ARMATURE_TYPE.SPINE
SpineBaseLogic.isBinary = true

SpineBaseLogic._timeScale = 0.98

SpineBaseLogic.EVENT_TYPE = {
	START = 0, 
	END = 1, 
	COMPLETE = 2, 
	EVENT = 3
}

local _tempId = 0

-- 构造函数接口组 --
function SpineBaseLogic:createWithName(armatureName, isBinary, customPath)
	isBinary = isBinary == nil and true or isBinary
	return SpineBaseLogic:create(armatureName, armatureName, armatureName, isBinary, customPath)
end

function SpineBaseLogic:create(armatureName, skel, atlas, isBinary, customPath)
	isBinary = isBinary == nil and true or isBinary
	local cls = SpineBaseLogic:createLogic(armatureName, skel, atlas, isBinary, customPath)
	return cls.new()
end

function SpineBaseLogic:createLogic(armatureName, json, atlas, isBinary, customPath)
	isBinary = isBinary == nil and true or isBinary
	_tempId = _tempId + 1
	local logic = class("TempSpineBaseLogic_" .. _tempId, SpineBaseLogic)
	logic.armatureName = armatureName
	logic.armatureFileName = armatureName
	logic.jsonFileName = json
	logic.atlasFileName = atlas
	logic.isBinary = isBinary
	logic.customPath = customPath
	return logic
end

-- 获取参数接口组 --
function SpineBaseLogic:getArmatureType(  )
	return self.armatureType
end

function SpineBaseLogic:getArmatureName(  )
	return self.armatureName
end

function SpineBaseLogic:getJsonFileName(  )
	return self.jsonFileName
end

function SpineBaseLogic:getAtlasFileName(  )
	return self.atlasFileName
end

function SpineBaseLogic:openView( parent, parentLogic )
	self:openArmature( parent, parentLogic )
end

function SpineBaseLogic:openArmature( parent, parentLogic )
	if self.viewState == VIEW_STATE.CLOSE then
		self.armatureRootNode = SpineDataCache.createSpine(self.jsonFileName, self.atlasFileName, self.isBinary, self.customPath)
		self.armatureRootNode:setName(self.armatureName)
		
		self.armatureRootNode:setTimeScale(self._timeScale)

		if self.scaleX then
			self.armatureRootNode:setScaleX(self.scaleX)
		end

		if self.scaleY then
			self.armatureRootNode:setScaleY(self.scaleY)
		end
		
		self.armatureRootNode.logic = self
		self.eventCache = {}

		self.size = self.armatureRootNode:getContentSize()

		if self.pos == nil then
			self.pos = cc.p(0, 0)
		end

		self.armatureRootNode:setPosition(self.pos)
		
		self:__openView(parent, parentLogic)

		if parentLogic == nil and parent then
			parentLogic = parent.logic
		end

		self:addToParent(parent, parentLogic)

		self.viewState = VIEW_STATE.OPEN
		
		ViewStack.pushView(self)

		self:onOpen(self.armatureRootNode)

		log("SpineBaseLogic:openView: " .. self.__cname .. " " .. self.armatureFileName)
	else
		log("Armature state is already VIEW_OPEN " .. self.__cname .. " " .. self.armatureFileName)
	end

	return self.armatureRootNode
end

function SpineBaseLogic:closeView(  )
	self:stopUISchedule()
	self:closeArmature()
end

function SpineBaseLogic:closeArmature(  )
	if self.viewState == VIEW_STATE.OPEN then
		log("SpineBaseLogic:closeView: " .. self.__cname .. " " .. self.armatureFileName)
		
		self:clearChildLogic()
		
		if self.customParentLogic then
			self.customParentLogic:removeChildLogic(self)
		end
		self:unregisterAllSpineEventHandler()
		self:onClose( self.armatureRootNode )
		ViewStack.popView( self )
		self.armatureRootNode:removeFromParent()
		self.armatureRootNode = nil
		self.pos = nil
		self.viewState = VIEW_STATE.CLOSE

		self:__closeView(  )

		SpineDataCache.disposeSpine(self.jsonFileName, self.atlasFileName)
	else
		log("Armature state is already VIEW_CLOSE " .. self.__cname .. " " .. self.armatureFileName)
	end
end

function SpineBaseLogic:getArmature(  )
	-- body
	return self.armatureRootNode
end

function SpineBaseLogic:getView(  )
	return self:getArmature(  )
end

function SpineBaseLogic:openWhenNotOpen(  )
	if not self:isOpen() then
		self:openArmature()
	end
end

function SpineBaseLogic:setToSetupPose(  )
	self:openWhenNotOpen()
	
	self.armatureRootNode:setToSetupPose()
end

--设置当前的动画
--fromSetupPose表示播放动画前先将动画还原到起始位置，否则可能动画会错乱，默认为true
function SpineBaseLogic:setAnimation( trackIndex, name, loop, fromSetupPose )
	-- fromSetupPose = fromSetupPose == nil and true or fromSetupPose
	if fromSetupPose == nil then
		fromSetupPose = true
	end
	self:openWhenNotOpen()
	if fromSetupPose then
		self.armatureRootNode:setToSetupPose()
	end
	self.armatureRootNode:setAnimation( trackIndex, name, loop )
end

--可以在当前的动画上叠加一个动画
function SpineBaseLogic:addAnimation( trackIndex, name, loop, delay )
	self:openWhenNotOpen()

	self.armatureRootNode:addAnimation( trackIndex, name, loop, delay )
end

--设置一个动画到另一个动画切换时的混合时间(只是设置混合时间，并不会播放动画)
function SpineBaseLogic:setMix( fromName, toName, duration )
	self:openWhenNotOpen()

	self.armatureRootNode:setMix( fromName, toName, duration )
end

function SpineBaseLogic:pause()
	if not self:isOpen() then
		return
	end

	self.armatureRootNode:pause()
end

function SpineBaseLogic:resume()
	if not self:isOpen() then
		return
	end

	self.armatureRootNode:resume()
end

--停止动画
function SpineBaseLogic:stop()
	if not self:isOpen() then
		return
	end
	self.armatureRootNode:clearTracks()
	self:stopUISchedule()
end

--改变动画播放速度
function SpineBaseLogic:setTimeScale( scale )
	self._timeScale = scale

	if self.armatureRootNode then
		-- logW("self._timeScale is " .. self._timeScale)
		self.armatureRootNode:setTimeScale( self._timeScale )
	end
end

function SpineBaseLogic:getTimeScale( )
	self:openWhenNotOpen()

	return self.armatureRootNode:getTimeScale(  )
end

function SpineBaseLogic:setSkin(skinName )
	self:openWhenNotOpen()

	self.armatureRootNode:setSkin( skinName )
end

--注册动画起始事件
--注意要在动画播放之前先注册
--回调函数的形式: (self, data) data的key有type, trackIndex,animation，loopCount。如果是自定义事件，还有eventData
function SpineBaseLogic:setStartListener(func)
	self:registerSpineEventHandler(SpineBaseLogic.EVENT_TYPE.START, func)
end

--似乎调用不到，没找到说明，动画完毕的事件请使用setCompleteListener
function SpineBaseLogic:setEndListener(func)
	self:registerSpineEventHandler(SpineBaseLogic.EVENT_TYPE.END, func)
end

--注册动画完成事件，每一次播放完毕都会执行
function SpineBaseLogic:setCompleteListener(func)
	self:registerSpineEventHandler(SpineBaseLogic.EVENT_TYPE.COMPLETE, func)
end

--注册自定义事件
function SpineBaseLogic:setEventListener(func)
	self:registerSpineEventHandler(SpineBaseLogic.EVENT_TYPE.EVENT, func)
end

--注册动画事件，包含起始事件，结束时间等，eventType的枚举参见SpineBaseLogic.EVENT_TYPE
--回调函数的形式: (self, data) data的key有type, trackIndex,animation，loopCount。如果是自定义事件，还有eventData
function SpineBaseLogic:registerSpineEventHandler( eventType, func)
	self:openWhenNotOpen()

	self:unregisterSpineEventHandler(eventType)
	local closure_callback = function ( data )
		func( self, data )
	end
	self.eventCache[eventType] = { t = eventType, lis = closure_callback }
	self.armatureRootNode:registerSpineEventHandler( closure_callback, eventType )
end

function SpineBaseLogic:unregisterSpineEventHandler( eventType )
	self:openWhenNotOpen()

	if self.eventCache[eventType] then
		func = self.eventCache[eventType].lis
		self.armatureRootNode:unregisterSpineEventHandler(eventType)
	end
end

function SpineBaseLogic:unregisterAllSpineEventHandler()
	for _, v in pairs(self.eventCache) do
		self.armatureRootNode:unregisterSpineEventHandler(v.t)
	end
	self.eventCache = {}
end

function SpineBaseLogic:setBlendFunc( src, dst )
	self:openWhenNotOpen()

	self.armatureRootNode:setBlendFunc(src, dst)
end

local function _bindUIUpdate(self)
	if self._bindUI == nil then
		return
	end
	
	for _, v in ipairs(self._bindUI) do
        local x, y, scaleX, scaleY, alpha, rotationX, rotationY, r, g, b = self.armatureRootNode:getSlotTransform(v.slot)
	    if v.parentSlot then
	    	local pX, pY, pScaleX, pScaleY = self.armatureRootNode:getSlotTransform(v.parentSlot)
	    	x = (x - pX) / pScaleX
	    	y = (y - pY) / pScaleY
	    	scaleX = scaleX / pScaleX
	    	scaleY = scaleY / pScaleX
	    end
        if math._ceil(rotationX) == 180 and math._ceil(rotationY) == 90 then
        	scaleX = - scaleX
        	rotationX = 0
        	rotationY = 0
        end
        -- logW("v.slot is " .. v.slot)
        -- logW("v.offsetX is " .. v.offsetX)
        -- logW("v.offsetY is " .. v.offsetY)
    	-- logW("x is " .. x)
    	-- logW("y is " .. y)
        -- logW("scaleX is " .. scaleX)
        -- logW("scaleY is " .. scaleY)
        -- logW("v.baseScale is " .. v.baseScale)
        v.node:setPosition(cc.p(v.offsetX + x, v.offsetY + y))
        v.node:setScale(scaleX * v.baseScale, scaleY * v.baseScale)
        v.node:setOpacity(alpha)
        v.node:setRotation(rotationX)
        local color = {}
        color.r = r
        color.g = g
        color.b = b
        v.node:setColor(color)
        -- if rotationX ~= rotationY then
        	--实测node的skew效果和spine的shear还是不一样的，待调
      		-- v.node:setRotationSkewX(rotationX)
       		-- v.node:setRotationSkewY(rotationY)  	
        -- end
	end
end

function SpineBaseLogic:startUISchedule()
	self:stopUISchedule()
	self.bindUISchedule = self:schedule(_bindUIUpdate, 1 / Config.FPS)
	_bindUIUpdate(self)
end

function SpineBaseLogic:stopUISchedule()
	if self.bindUISchedule then
		self:unschedule(self.bindUISchedule)
		self.bindUISchedule = nil
	end
	if self.stopUIDelay then
		self:unschedule(self.stopUIDelay)
		self.stopUIDelay = nil
	end
end

--将UI绑定到spine某个节点
--hideSelf，默认为true,隐藏spine显示
function SpineBaseLogic:bindUI(widget, slot_name, skin, offsetX, offsetY, hideSelf, scale, parent)
	hideSelf = hideSelf == nil and true or hideSelf
	if self._bindUI == nil then
		self._bindUI = {}
	end

	table.insert(self._bindUI, {node = widget, slot = slot_name, offsetX = offsetX or 0, offsetY = offsetY or 0, baseScale = scale or 1, parentSlot = parent})
	if skin then
        self:setSkin(skin)
    end

    if hideSelf then
    	self.armatureRootNode:setOpacity(0)
    end
end

--播放spine动画，绑定的UI会跟着spine动
function SpineBaseLogic:playUIAnimation(trackIndex, name, loop, fromSetupPose)
	self:setAnimation( trackIndex, name, loop, fromSetupPose )
	self:startUISchedule()
end

--播放一次spine动画，绑定的UI会跟着spine动
function SpineBaseLogic:playUIAnimOnce(trackIndex, name, onComplete, autoHide, fromSetupPose)
	-- autoHide可能会setOpacity(0) 所以 要 setOpacity(255)
	self.armatureRootNode:setOpacity(255)

	local __onComplete = function()
		self:unregisterSpineEventHandler(SpineBaseLogic.EVENT_TYPE.COMPLETE)
		self:stopUISchedule()
		local function stopUIScheduleCallback()
			_bindUIUpdate(self)
			
			if autoHide then
				for i,v in ipairs(self._bindUI) do
					v.node:setVisible(false)	
				end
				self.armatureRootNode:setOpacity(0)
			end
			if onComplete then
				onComplete()
			end	
        end
        self.stopUIDelay = self:scheduleOnce(stopUIScheduleCallback, 0.01)
	end

	self:playUIAnimation(trackIndex, name, false, fromSetupPose)
	self:setCompleteListener(__onComplete)
end

--播放一次spine动画
function SpineBaseLogic:playAnimOnce(trackIndex, name, onComplete, fromSetupPose)
	local __onComplete = function()
		self:unregisterSpineEventHandler(SpineBaseLogic.EVENT_TYPE.COMPLETE)
		if onComplete then
			onComplete()
		end
	end
	self:setAnimation( trackIndex, name, false, fromSetupPose )
	self:setCompleteListener(__onComplete)
end