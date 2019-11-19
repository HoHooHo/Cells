GameVideoLogic = class("GameVideoLogic")

local VIDEO_RES = "res/core_res/video/gameVideo.mp4"

local function playComplete(self)
	if not self.removing and self.videoPlayer then
		self.removing = true

	    local delayRemove = function ()
			self.layout:removeFromParent()
			self.layout = nil
			self.videoPlayer = nil

			if BundleID.getChannelType() == BundleID.CHANNEL_TYPE.KOREA then
				if GlobalConfManager.BATTLE_SHOW_IS_OPEN == 1 then
					BattleShowManager.startShow()
				else
					self:postEvent(EventType.GUIDE_NEXT)
				end
			end
		end

	    Scheduler.scheduleOnce(delayRemove, 0.01)

		AudioManager.resumeBackgroud()
	end

end

local function playVideo( self )
	if cc.PLATFORM_OS_WINDOWS ~= cc.Application:getInstance():getTargetPlatform() then

		if self.videoPlayer == nil then
	        local function onVideoEventCallback(sener, eventType)
	            if eventType == ccexp.VideoPlayerEvent.PLAYING then
	            elseif eventType == ccexp.VideoPlayerEvent.PAUSED then
	            elseif eventType == ccexp.VideoPlayerEvent.STOPPED then
	            	playComplete(self)
	            elseif eventType == ccexp.VideoPlayerEvent.COMPLETED then
	            	playComplete(self)
	            end
	        end


		    self.layout = ccui.Layout:create()

		    self.layout:setContentSize(WIN_SIZE)
		    self.layout:setAnchorPoint(cc.p(0.5, 0.5))
		    self.layout:setPosition(WIN_CENTER)

		    self.layout:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
		    self.layout:setBackGroundColor(cc.c3b(0, 0, 0))
		    self.layout:setBackGroundColorOpacity(255)
		    self.layout:setTouchEnabled(true)

	        SceneHelper.getLayer(SceneHelper.LAYER_TYPE.TIPS_LAYER):addChild(self.layout)


	        self.videoPlayer = ccexp.VideoPlayer:create()
	        self.videoPlayer:setPosition(cc.p(WIN_SIZE.width/2,WIN_SIZE.height/2))--WIN_CENTER
	        self.videoPlayer:setAnchorPoint(cc.p(0.5, 0.5))
	        self.videoPlayer:setContentSize(WIN_SIZE)
	        self.videoPlayer:addEventListener(onVideoEventCallback)

	        self.layout:addChild(self.videoPlayer)

	        self.videoPlayer:setFullScreenEnabled(true)
	        self.videoPlayer:setKeepAspectRatioEnabled(true)
	        self.videoPlayer:setTouchEnabled(false)
	        self.videoPlayer:setShowSkipBtn(true)
		end

	    local delayPlay = function ()
		    if self.videoPlayer then
		        self.videoPlayer:setFileName( VIDEO_RES )
		        self.videoPlayer:play()
		    end
		end

		AudioManager.pauseBackgroud()
	    Scheduler.scheduleOnce(delayPlay, 0.01)
	end
end

function GameVideoLogic:play()
	playVideo( self )
end