ARMATURE_TYPE = 
{
	NONE = nil,
	DRAGON_BONES = 0,
	COCOSTUDIO = 1,
	SPINE = 2
}

local CCS_FILE_NAME_SUFFIX = ".csb"
local XML_FILE_NAME_SUFFIX = ".xml"
local PLIST_FILE_NAME_SUFFIX = ".plist"
local PNG_FILE_NAME_SUFFIX = ".png"

local ARMATURE_DEFAULT_FPS = 24.0
local CCS_DEFAULT_FPS = 60.0

ArmatureBaseLogic = class("ArmatureBaseLogic", BaseLogic)
ArmatureBaseLogic.armatureName = ""
ArmatureBaseLogic.armatureFileName = ""
ArmatureBaseLogic.plistFileName = ""
ArmatureBaseLogic.pngFileName = ""
ArmatureBaseLogic.armatureRootNode = nil
ArmatureBaseLogic.onAnimationEvent = nil
ArmatureBaseLogic.onFrameEvent = nil
-- ArmatureBaseLogic.armatureFPS = 24.0
ArmatureBaseLogic.armatureType = ARMATURE_TYPE.NONE
ArmatureBaseLogic.speedScale = 1.0

local _tempDBId = 0

function ArmatureBaseLogic:createDBLogic(armatureName, xml, plist, image )
	_tempDBId = _tempDBId + 1
	local logic = class("TempDBArmatureBaseLogic_".._tempDBId, ArmatureBaseLogic)
	logic.armatureName = armatureName
	logic.armatureFileName = xml
	logic.plistFileName = plist or xml
	logic.pngFileName = image or xml

	logic.armatureType = ARMATURE_TYPE.DRAGON_BONES

	return logic
end

local _tempCSBId = 0

function ArmatureBaseLogic:createCSBLogic( csb )
	_tempCSBId = _tempCSBId + 1
	local logic = class("TempCSBArmatureBaseLogic_".._tempCSBId, ArmatureBaseLogic)
	logic.armatureName = csb
	logic.armatureFileName = csb

	logic.armatureType = ARMATURE_TYPE.COCOSTUDIO

	return logic
end

function ArmatureBaseLogic:getArmatureType(  )
	return self.armatureType
end

function ArmatureBaseLogic:getArmatureName(  )
	return self.armatureName
end

function ArmatureBaseLogic:getArmatureFileName(  )
	return self.armatureFileName
end

function ArmatureBaseLogic:getPlistName(  )
	return self.plistFileName
end

function ArmatureBaseLogic:getPngName(  )
	return self.pngFileName
end

function ArmatureBaseLogic:openView( parent, parentLogic )
	self:openArmature( parent, parentLogic )
end

function ArmatureBaseLogic:openArmature( parent, parentLogic )
	if self.viewState == VIEW_STATE.CLOSE then

		if self.armatureType == ARMATURE_TYPE.DRAGON_BONES then
			ArmatureDataCache.addDBArmatureFileInfo( self:getArmatureFileName() .. XML_FILE_NAME_SUFFIX, self:getPlistName() .. PLIST_FILE_NAME_SUFFIX, self:getPngName() .. PNG_FILE_NAME_SUFFIX )
		elseif self.armatureType == ARMATURE_TYPE.COCOSTUDIO then
			ArmatureDataCache.addCSBArmatureFileInfo( self:getArmatureFileName() .. CCS_FILE_NAME_SUFFIX )
		else
        	error("\n***ERROR*** Armature type is invalid ***ERROR***")
		end

		self.armatureRootNode = ccs.Armature:create( self:getArmatureName() )
		self.armatureRootNode.logic = self

		self.size = self.armatureRootNode:getContentSize()

		-- self.armatureRootNode:setAnchorPoint(cc.p(0.5, 0.5))
		-- self.armatureRootNode:setPosition(cc.p(self.armatureRootNode:getContentSize().width/2, self.armatureRootNode:getContentSize().height/2))

		if self.onAnimationEvent then
	    	self.armatureRootNode:getAnimation():setMovementEventCallFunc(self.onAnimationEvent)
		end
		if self.onFrameEvent then
	    	self.armatureRootNode:getAnimation():setFrameEventCallFunc(self.onFrameEvent)
		end

		if self.pos == nil then
			self.pos = cc.p(0, 0)
		end

		self.armatureRootNode:setPosition(self.pos)
		
		self:__openView( parent, parentLogic )

		if parentLogic == nil and parent then
			parentLogic = parent.logic
		end

		self:addToParent( parent, parentLogic )

		self.viewState = VIEW_STATE.OPEN
		
		ViewStack.pushView(self)

		self:onOpen( self.armatureRootNode )

		self:setSpeedScale(self.speedScale)

		log("ArmatureBaseLogic:openView:  "..self.__cname.."   "..self.armatureFileName)
	else
		log("Armature state is already VIEW_OPEN  "..self.__cname.."   "..self.armatureFileName)
	end

	return self.armatureRootNode
end

function ArmatureBaseLogic:closeView(  )
	self:closeArmature(  )
end

function ArmatureBaseLogic:closeArmature(  )
	if self.viewState == VIEW_STATE.OPEN then
		log("ArmatureBaseLogic:closeView:  "..self.__cname.."   "..self.armatureFileName)
		
		self:clearChildLogic()
		
		if self.customParentLogic then
			self.customParentLogic:removeChildLogic(self)
		end
		
		self:onClose( self.armatureRootNode )
		ViewStack.popView( self )
		self.armatureRootNode:removeFromParent()
		self.armatureRootNode = nil
		self.pos = nil
		self.viewState = VIEW_STATE.CLOSE

		self:__closeView(  )

		if self.armatureType == ARMATURE_TYPE.DRAGON_BONES then
			ArmatureDataCache.removeArmatureFileInfo( self:getArmatureFileName() .. XML_FILE_NAME_SUFFIX )
		elseif self.armatureType == ARMATURE_TYPE.COCOSTUDIO then
			ArmatureDataCache.removeArmatureFileInfo( self:getArmatureFileName() .. CCS_FILE_NAME_SUFFIX )
		else
        	error("\n***ERROR*** Armature type is invalid ***ERROR***")
		end
	else
		log("Armature state is already VIEW_CLOSE  "..self.__cname.."   "..self.armatureFileName)
	end
end

function ArmatureBaseLogic:getArmature(  )
	-- body
	return self.armatureRootNode
end

function ArmatureBaseLogic:getView(  )

	return self:getArmature(  )
end

function ArmatureBaseLogic:getAnimation(  )
	return self.armatureRootNode:getAnimation()
end

function ArmatureBaseLogic:play( animationName, durationTo, loop )
	if not self:isOpen() then
		self:openArmature()
	end

	self.armatureRootNode:getAnimation():play( animationName, durationTo or -1, loop or -1 )
	-- if self.armatureType == ARMATURE_TYPE.COCOSTUDIO then
		-- self.armatureRootNode:getAnimation():gotoAndPlay( 0 )
	-- end
end

function ArmatureBaseLogic:playWithIndex( animationIndex, durationTo, loop )
	if not self:isOpen() then
		self:openArmature()
	end

	self.armatureRootNode:getAnimation():playWithIndex( animationIndex, durationTo or -1, loop or -1 )
end

function ArmatureBaseLogic:pause(  )
	self.armatureRootNode:getAnimation():pause(  )
end

function ArmatureBaseLogic:resume(  )
	self.armatureRootNode:getAnimation():resume(  )
end

function ArmatureBaseLogic:gotoAndPause( frameIndex, movementName )
	if movementName == nil and self:getCurrentMovementID() == "" then
        error("\n***ERROR***  Animation need to play first  ***ERROR***")
    elseif movementName and movementName ~= self:getCurrentMovementID() then
		self:play( movementName )
	end

	self.armatureRootNode:getAnimation():gotoAndPause( frameIndex )
end

function ArmatureBaseLogic:getCurrentMovementID(  )
	return self:getAnimation():getCurrentMovementID()
end

function ArmatureBaseLogic:getMovement( movementName )
	return self.armatureRootNode:getAnimation():getAnimationData():getMovement( movementName or self:getCurrentMovementID() )
end

function ArmatureBaseLogic:getMovementDuration( movementName )
	return self:getMovement( movementName ).duration
end

function ArmatureBaseLogic:gotoEnd( movementName )
	self:gotoAndPause( self:getMovement( movementName ).duration - 1, movementName )
end

function ArmatureBaseLogic:stop(  )
	if self.armatureRootNode then
		self.armatureRootNode:getAnimation():stop(  )
	end
end

function ArmatureBaseLogic:setSpeedScale(speedScale)
	self.speedScale = speedScale
	if self:isOpen() then
		local fps = self.armatureFPS or CCS_DEFAULT_FPS
		self.armatureRootNode:getAnimation():setSpeedScale(speedScale * fps / CCS_DEFAULT_FPS)
		-- self.armatureRootNode:getAnimation():setSpeedScale(speedScale)
	end
end

function ArmatureBaseLogic:setAnimationEvent( onAnimationEvent, data )
	local closure_callback = function ( armatureBack, movementType, movementID )
		onAnimationEvent( data or self, armatureBack, movementType, movementID )
	end

	self.onAnimationEvent = closure_callback
	if self:isOpen() then
    	self.armatureRootNode:getAnimation():setMovementEventCallFunc(closure_callback)
	end
end

function ArmatureBaseLogic:setFrameEvent( onFrameEvent, data )
	local closure_callback = function ( bone, evt, originFrameIndex, currentFrameIndex )
		onFrameEvent( data or self, bone, evt, originFrameIndex, currentFrameIndex )
	end

	self.onFrameEvent = closure_callback
	if self:isOpen() then
    	self.armatureRootNode:getAnimation():setFrameEventCallFunc(closure_callback)
	end
end

function ArmatureBaseLogic:getBone( boneName )
	return self:getView():getBone(boneName)
end

function ArmatureBaseLogic:removeBone( bone )
	self:getView():removeBone(bone, true)
end

function ArmatureBaseLogic:removeBoneByName( boneName )
	self:removeBone(self:getBone( boneName ))
end

function ArmatureBaseLogic:setBoneVisible( bone, visible )
	-- local displayManager = bone:getDisplayManager()
	-- displayManager:setVisible(visible)
	bone:setVisible(visible)
end

function ArmatureBaseLogic:setBoneVisibleByName( boneName, visible )
	local bone = self:getView():getBone(boneName)
	self:setBoneVisible( bone, visible )
end