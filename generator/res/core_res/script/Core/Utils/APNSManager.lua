module("APNSManager", package.seeall)

local _targetPlatform = cc.Application:getInstance():getTargetPlatform()

local _className = _G.packageName .. "APNSHelper"
if (cc.PLATFORM_OS_ANDROID == _targetPlatform) then
    _className = _G.packageName .. "NotificationHelper"
end


local function _createLocalNotification( content, name, key, notificationTime )
    -- logD("content = " .. content .. "    name = " .. name .. "   key = " .. key .. "   notificationTime = " .. notificationTime)
    if (cc.PLATFORM_OS_IPHONE == _targetPlatform) or (cc.PLATFORM_OS_IPAD == _targetPlatform) then
        local args = { second = notificationTime, content = name .. content, name = name, key = "ios_" .. key}
        local method = "createLocalNotification"
        local ok, ret = LuaBridge.callStaticMethod(_className, method, args)

    elseif (cc.PLATFORM_OS_ANDROID == _targetPlatform) then
        local args = { content, name, key, tostring(notificationTime)}
        local sigs = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V"
        local method = "createLocalNotification"
        local ok, ret = LuaBridge.callStaticMethod(_className, method, args,sigs)
    else

    end
end

local function checkTime( notificationTime )
    local localTime = os.time()
    local pushTime = localTime + notificationTime

    local pushDate = os.date("*t", pushTime)

    local pushHour = pushDate.hour
    local pushMin = pushDate.min

    -- logW(pushDate)

    return pushHour >= 9 or ( pushHour == 0 and pushMin < 30 ) or( pushHour == 8 and pushMin > 30 )
end

function createLocalNotification( content, name, key, notificationTime )
    if checkTime( notificationTime ) then
        _createLocalNotification( content, name, key, notificationTime )
    end
end

function removeLocalNotication( name, key )
    if (cc.PLATFORM_OS_IPHONE == _targetPlatform) or (cc.PLATFORM_OS_IPAD == _targetPlatform) then
        local args = {name = name, key = key}
    	local method = "removeLocalNotication"
    	local ok, ret = LuaBridge.callStaticMethod(_className, method, args)

    elseif (cc.PLATFORM_OS_ANDROID == _targetPlatform) then

    else
    	
    end
end

function removeAllLocalNotifications(  )
    if (cc.PLATFORM_OS_IPHONE == _targetPlatform) or (cc.PLATFORM_OS_IPAD == _targetPlatform) then
    	local method = "removeAllLocalNotification"
    	local ok, ret = LuaBridge.callStaticMethod(_className, method)

    elseif (cc.PLATFORM_OS_ANDROID == _targetPlatform) then
        local args = {}
        local sigs = "()V"
        local method = "removeAllLocalNotification"
        local ok, ret = LuaBridge.callStaticMethod(_className, method, args,sigs)
    else
    	
    end
end