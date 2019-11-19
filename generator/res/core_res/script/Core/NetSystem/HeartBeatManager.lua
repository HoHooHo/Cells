module("HeartBeatManager",package.seeall)

local DELTA = 10

local _time = 0
local _init = false
local _entryId = nil


local globalTime = nil
local localTime = nil
local serverTime = nil

local DEVIATION = 60
local _oldDay = nil
local _newDay = nil


local _lastHeartBeat = 0
local HEART_BEAT_TIME = 30

local hasHeartBeat = false

local PM_TIME = 18
function isNight()
	return getSystemDate().hour >= PM_TIME or getSystemDate().hour < PM_TIME - 12
end

-- 到达某个时间点后触发回调
local _timeEvent = {}


local KEY_EVENT_CALLBACK = 1
local KEY_EVENT_DATA = 2

local function cacheListener( timeKey, callback, data )
	if _timeEvent[timeKey] == nil then
		_timeEvent[timeKey] = {}
	end

	local caches = _timeEvent[timeKey]

	for i,v in ipairs(caches) do
		if v[KEY_EVENT_CALLBACK] == callback then
			return false
		end
	end

	local cacheObj = {
						[KEY_EVENT_CALLBACK] = callback,
						[KEY_EVENT_DATA] = data,
					 }

	table.insert(caches, cacheObj)

	return true
end

-- timeKey为 时间戳
-- callback为 回调函数
-- data 为回调时 回传的参数
function registerTimeEvent( timeKey, callback, data )
	if timeKey == nil then
        error("\n\n***ERROR*** timeKey is nil  ***ERROR***")
    elseif callback == nil then
        error("\n\n***ERROR*** callback is nil  ***ERROR***")
	end

	timeKey = math.floor(timeKey)

	if cacheListener(timeKey, callback, data) then
		log("HeartBeatManager: registerTimeEvent " .. timeKey .. " success")
	else
		log("HeartBeatManager: cannot repeat registerTimeEvent " .. tostring(timeKey))
	end
end

function unregisterTimeEvent( timeKey, callback )
	if timeKey == nil then
        error("\n\n***ERROR*** timeKey is nil  ***ERROR***")
    elseif callback == nil then
        error("\n\n***ERROR*** callback is nil  ***ERROR***")
	end

	timeKey = math.floor(timeKey)

	local caches = _timeEvent[timeKey]

	if caches == nil then
		log("HeartBeatManager: nothing has registered with " .. timeKey)
		return
	end

	local unregister = false

	for i, v in ipairs(caches) do
		if v[KEY_EVENT_CALLBACK] == callback then
			table.remove(caches, i)
			unregister = true
			log("HeartBeatManager: unregisterTimeEvent " .. timeKey .. " success")
			break
		end
	end

	if not unregister then
		log("HeartBeatManager: has not registered with " .. timeKey)
	end
end


local function tryDispatchEvent()
	local time = math.floor(globalTime)

	if _timeEvent[time] then
		for i,v in ipairs(_timeEvent[time]) do
			if v[KEY_EVENT_CALLBACK] then
				v[KEY_EVENT_CALLBACK]( globalTime, v[KEY_EVENT_DATA] )
			end
		end

		_timeEvent[time] = nil
	end
end

-- local function checkNewDay( time )
-- 	if _oldDay ~= nil then
-- 		_newDay = getSystemDate().day

-- 		if _oldDay ~= _newDay then
-- 			_oldDay = _newDay
-- 			-- NetMessageSystem.sendRequest(ID_DceNewDay)
-- 		end
-- 	end
-- end

-- 保证心跳 不被服务器T掉
local function checkHeartBeat()
	if ServerConfig.GAME_LOGINED and ( (globalTime < _lastHeartBeat) or (globalTime - _lastHeartBeat > HEART_BEAT_TIME) ) then
		heartBeat()
	end
end

-- 非奇酷日文版 不需要update心跳，只需跟随消息请求 同步时间即可
function tryHeartBeat()
	checkHeartBeat()
end

local function update( data, delta )
	if serverTime ~= nil then
		local now = socket.gettime()
		globalTime = serverTime + now - localTime

		tryDispatchEvent()

		-- checkHeartBeat()
		-- checkNewDay(globalTime - 1)
	end
end

local function init(  )
	if not _init then
		_init = true
		_entryId = Scheduler.schedule( update, 0.1 )
	end
end

local function onHeartBeat( pkg )
	if pkg and pkg.time then
		init()
		local newTime = tonumber(pkg.time)

		if globalTime == nil then
			globalTime = newTime
		end

		if _oldDay == nil then
			_oldDay = getSystemDate().day
		end

		_lastHeartBeat = newTime

		if globalTime and newTime < globalTime and globalTime - newTime < DEVIATION then
			return
		end

		serverTime = newTime
		globalTime = serverTime
		localTime = socket.gettime()

		if not hasHeartBeat then
			hasHeartBeat = true
			ChatData.startQQSchedule()
			-- ChatData.onQQEnd()
		end
	end
end

function initNetListener(  )
	NetMessageSystem.registerMessageListener(ID_DseHeartbeat, onHeartBeat)
end

function uninitNetListener(  )
	NetMessageSystem.unregisterMessageListener(ID_DseHeartbeat, onHeartBeat)
end

function heartBeat(  )
	local now = os.time()
	if now - _time > DELTA or now - _time < 0 then
		_time = now
		init()
		NetMessageSystem._sendRequest(ID_DceHeartbeat, nil)
	end
end


--{year = 1998, month = 9, day = 16, yday = 259, wday = 4,
 -- hour = 23, min = 48, sec = 10, isdst = false}
 --yday 一年第几天 wday 一周第几天(星期日为1 星期六为7)
function getSystemDate()
	return os.date("*t", getServerZoneTime())
end

function isReady()
	return _init
end

-- 获取服务器时间
function getGlobalTime(  )
	return globalTime
end

-- 四舍五入 得到服务器时间 或者传入的时间
function getTime( ceil, time )
	local floor = math.floor(time or globalTime)
	local pointValue = (time or globalTime) - floor
	if pointValue < 0.5 and not ceil then
		return floor
	else
		return math.ceil(time or globalTime)
	end
end

--获取服务器时间（UTC+00:00）
function getUTCTime(  )
	return getTime() - PlayerData.getZone() * 60 * 60 --28800
end

--获取服务器所在区的时间（UTC+08:00）   ---仅限  os.date 时 使用
function getServerZoneTime( ceil, time )
	return getTime(ceil, time) - Global.getTimeZone() + PlayerData.getZone() * 60 * 60 --28800
end

function getServerZoneTimeByDate( date )
	return os.time(date) + Global.getTimeZone() - PlayerData.getZone() * 60 * 60
end

-- 获取传入时间 或者 服务器时间的日期
function getDate(time)
	return os.date("*t", time or getServerZoneTime())
end

-- 判断服务器时间是否是零点
function isServerZeroTime( time )
	local zoneTime = getServerZoneTime( nil, time )
	local zeroTime = TimeHelper.getZeroTime(zoneTime)

	-- logW({time = time})
	-- logW({zoneTime = zoneTime})
	-- logW({zeroTime = zeroTime})

	return zoneTime == zeroTime
end

-- 获取传入时间 或者 服务器时间的 秒 分 时 日
function getFormatTime( ceil, time )
	local time = os.date("*t", getServerZoneTime(ceil, time))
	return tonumber(time.sec), tonumber(time.min), tonumber(time.hour), tonumber(time.wday)
end

function getDurationToNextDay()
    return getNextDayTime() - getServerZoneTime()
end

-- 下一天 需要做时区处理
function getNextDayTime()
    return TimeHelper.getNextDayTime( getServerZoneTime() )
end

function getNextHourTime()
    return TimeHelper.getNextHourTime( globalTime )
end

function getNextMinTime()
    return TimeHelper.getNextMinTime( globalTime )
end

function getPeriod( second, minute, hour, weekdayTable )
	local currentSecond, currentMinute, currentHour, currentWeekday = getFormatTime(  )

	second = second or 0
	minute = minute or 0
	hour = hour or 0
	weekdayTable = weekdayTable or {}

	local borrow = false
	local secondValue = second - currentSecond
	if secondValue < 0 then
		borrow = true
		secondValue = secondValue + 60
	end

	if borrow then
		borrow = false
		minute = minute - 1
	end

	local minuteValue = minute - currentMinute
	if minuteValue < 0 then
		borrow = true
		minuteValue = minuteValue + 60
	end

	if borrow then
		borrow = false
		hour = hour - 1
	end

	local hourValue = hour - currentHour
	if hourValue < 0 then
		borrow = true
		hourValue = hourValue + 24
	end

	local day = 0

	if borrow then
		borrow = false
		day = day - 1
	end

	local dayValue = day

	local bBreak = false
	for week=0,1 do
		for i,v in ipairs(weekdayTable) do
			v = v + 7 * week

			dayValue = day + v - currentWeekday

			if dayValue >= 0 then
				bBreak = true
				break
			end
		end

		if bBreak then
			break
		end
	end
		
	return secondValue + minuteValue * 60 + hourValue * 60 *60 + dayValue * 60 * 60 * 24
end

--template or server data  for example: |20|20
function getPeriodByData( data )
	local timeData = Global.formatTemplateContent( data )
	return getPeriod( timeData[3] or 0, timeData[2] or 0, timeData[1] or 0 )
end

-- 判断传入时间是否是今天的时间
function isToday( lastTime )
	if lastTime ~= nil then
		local lastDate = getDate(lastTime)
		local today = getDate()
		if lastDate.year == today.year and lastDate.month == today.month and lastDate.day == today.day then
			return true
		end
	end

	return false
end