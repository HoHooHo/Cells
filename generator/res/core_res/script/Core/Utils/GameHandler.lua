module("GameHandler", package.seeall)

local _time = nil
local RESTART_TIME = 60 * 60 * 10

local function applicationDidEnterBackground(  )
	log("*** Game did enter background ***")
	_time = os.time()
	APNSHelper.createLocalNotifications()

	if EventSystem then
		EventSystem.dispatchEvent(EventType.GAME_ENTER_BACKGROUND)
	end

	local globalTime = HeartBeatManager.getGlobalTime()
	if globalTime then
		UserDefaultHelper.setInteger(UserDefaultHelper.KEY.LOGIN_OUT_TIME, globalTime)
	end

	if ViewStack then
		ViewStack.checkClean( true, true )
	end
end

local function applicationWillEnterForeground(  )
	log("*** Game did enter foreground ***")
	local time = os.time()
	APNSHelper.removeAllLocalNotifications()
	
	UserDefaultHelper.setInteger(UserDefaultHelper.KEY.LOGIN_OUT_TIME, 0)
	if _time == nil then
		_time = time
	end
	
	if time - _time > RESTART_TIME then
		restartGame()
	else
	end
	
end


AppHandler:getInstance():registerHandler(applicationDidEnterBackground, applicationWillEnterForeground)