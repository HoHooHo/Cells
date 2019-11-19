module("APNSHelper", package.seeall)
-- 推送类型
-- 1.定时推送
-- 2.满矿镐推送
-- 3.矿石开采完成
-- 4.所有工坊开采完成
-- 5.特定日期推送
-- 6.特定星期推送
-- 7.战利品收取满8小时

local APNS_TYPE = {
	NORMAL  = 1,
	DIG     = 2,
	MINE    = 3,
	PROJECT = 4,
	DATE    = 5,
	WEEK    = 6,
	EXPLORE = 7,
}


-- ID 必须是数字字符串
local ID = {
    TEST1 = "10",
    TEST2 = "20",
}

-- date
--{year = 1998, month = 9, day = 16, yday = 259, wday = 4,
 -- hour = 23, min = 48, sec = 10, isdst = false}
 --yday 一年第几天 wday 一周第几天(星期日为1 星期六为7)

local function getTimeByStr( str )
	local hour, min, sec = string.match(str, "(%d+):(%d+):(%d+)")
	return tonumber(hour), tonumber(min), tonumber(sec)
end

-- 以配表ID 推送日期 和  序列号（矿石和工程可能会同时开几个）  组合KEY
-- ID 1或2位
-- day、idx 2位
-- 确保推送key 唯一
local function getKey( data, date, idx )
	return string._format("%d%02d%02d", data.id, date.day, idx or 0)
end

local function createNormal( data )
	for i=0,6 do
		local hour, min, sec = getTimeByStr( data.time )

		-- date 和 now 都以服务器时区为准
		local now  = HeartBeatManager.getServerZoneTime()
		local date = HeartBeatManager.getDate(now + 24*60*60*i)

		date.hour  = hour
		date.min   = min
		date.sec   = sec

		local time = os.time(date)
		if time > now then
		    APNSManager.createLocalNotification(data.desc, data.title, getKey( data, date ), math.ceil(time - now))
		end
	end
end

local function createDig( data )
	local time = MineManager.getPickaxeRecoveryMaxTime(data.para1/100)

	if time > 0 then
	    APNSManager.createLocalNotification(data.desc, data.title, getKey( data, os.date("*t") ), math.ceil(time))
	end
end

local function createGems( data )
	for i,v in ipairs(MineManager.getGemFinishTime(data.para3)) do
		if v > 0 then
		    APNSManager.createLocalNotification(data.desc, data.title, getKey( data, os.date("*t"), i ), math.ceil(v))
		end
	end
end

local function createMineProjects( data )
	local time = MineManager.getProjectFinishTime()

	if time > 0 then
	    APNSManager.createLocalNotification(data.desc, data.title, getKey( data, os.date("*t") ), math.ceil(time))
	end
end

local function createDate( data )
	local year, month, day, hour, min, sec = string.match(data.time, "(%d+)-(%d+)-(%d+)-(%d+):(%d+):(%d+)")
	local date = {year = year, month = month, day = day, hour = hour, min = min, sec = sec}

    local time = os.time( date )
	local now  = HeartBeatManager.getServerZoneTime()

	if time > now then
	    APNSManager.createLocalNotification(data.desc, data.title, getKey( data, date ), math.ceil(time - now))
	end
end


local WEEK_TIME = 60 * 60 * 24 * 7

local function createWeek( data )
	local weekParam = data.para3
	local hour, min, sec = getTimeByStr( data.time )

	-- date 和 now 都以服务器时区为准
	local date = HeartBeatManager.getDate()
	local now  = HeartBeatManager.getServerZoneTime()

	date.hour  = hour
	date.min   = min
	date.sec   = sec

	local day = date.day
	local wday = date.wday

	for i,v in ipairs(weekParam) do
		date.day = day + v + 1 - wday

		local time = os.time(date)
		if time > now then
		    APNSManager.createLocalNotification(data.desc, data.title, getKey( data, date ), math.ceil(time - now))
		else
		    APNSManager.createLocalNotification(data.desc, data.title, getKey( data, date ), math.ceil(WEEK_TIME + time - now))
		end
	end
end

-- 战利品收取满8小时后 推送相关消息
local function createExplore( data )
	local lastTime = UserDefaultHelper.getInteger(UserDefaultHelper.KEY.ADVENTURE_EXPLORE_GET_TIME, 0)
	local time = HeartBeatManager.getTime()

	local totalTime = data.para1 * 60 * 60
	local remainingTime = totalTime - (time - lastTime)

	if lastTime > 0 and remainingTime > 0 then
	    APNSManager.createLocalNotification(data.desc, data.title, getKey( data, os.date("*t") ), math.ceil(remainingTime))
	end
end

local function test()
    APNSManager.createLocalNotification(ID.TEST1 .. "_Test_Content", ID.TEST1 .. "_Test_Title", ID.TEST1 .. "1" .. "1", 30)
    APNSManager.createLocalNotification(ID.TEST1 .. "_Test_Content", ID.TEST1 .. "_Test_Title", ID.TEST1 .. "1" .. "2", 40)
end

function createLocalNotifications(  )
	if not ServerConfig.GAME_LOGINED then return end

	-- test()

	for i,v in ipairs(TemplateManager.getLookContentTemplate("MessageDataTemplate")) do
		if APNS_TYPE.NORMAL == v.type then
			if (v.id ~= 1 and v.id ~= 2 and v.id ~= 3) or RemindData.isPushWorldBossAvailable() then
				createNormal(v)
			end
		elseif APNS_TYPE.DIG == v.type and RemindData.isPushPickaxeAvailable() then
			createDig(v)
		elseif APNS_TYPE.MINE == v.type and RemindData.isPushOreMiningAvailable() then
			createGems(v)
		elseif APNS_TYPE.PROJECT == v.type and RemindData.isPushWorkshopMiningAvailable() then
			createMineProjects(v)
		elseif APNS_TYPE.DATE == v.type then
			createDate(v)
		elseif APNS_TYPE.WEEK == v.type then
			createWeek(v)
		elseif APNS_TYPE.EXPLORE == v.type then
			createExplore( v )
		end
	end
end


function removeAllLocalNotifications(  )
    APNSManager.removeAllLocalNotifications()
end
