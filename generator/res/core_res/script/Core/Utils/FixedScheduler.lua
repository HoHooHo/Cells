module("FixedScheduler", package.seeall)
--保证一定会在xx时间后执行的scheduler，切到后台不影响时间流失
--每秒检测一次
--适用于恢复体力，到时间收矿等计时
--或者每天定时执行

--按触发时间从小到大排列
local _scheduleList = {}
local _id = 0

local _scheduleID = nil

local function _insertSchedule(info)
	local index = 1
	for i = #_scheduleList, 1, -1 do
		local theInfo = _scheduleList[i]
		if theInfo.time <= info.time then
			index = i + 1
			break
		end
	end
	table.insert(_scheduleList, index, info)
end

local function _tick()
	local time = HeartBeatManager.getGlobalTime() -- socket.gettime()
	local maxRunTimes = 0
    while #_scheduleList > 0 and maxRunTimes < 10000 do
    	maxRunTimes = maxRunTimes + 1
    	local info = _scheduleList[1]
    	if info.time <= time then
    		table.remove(_scheduleList, 1)

    		local times = 1
    		if info.callbackTimes and time - info.time >= info.interval then
    			times = times + math.floor((time - info.time) / info.interval)
    			if info.nRepeat and info.times + times > info.nRepeat then
    				times = info.nRepeat - info.times
    			end
    		end
    		if not info.nRepeat or info.times + times < info.nRepeat then
    			info.times = info.times + times
    			info.time = info.time + info.interval * times
    			_insertSchedule(info)
    		end
    		info.handler(info.data, times)
    	else
    		break
    	end
    end
end

local function _schedule( nHandler, fInterval, data, nRepeat, firstInterval, callbackTimes)
	firstInterval = firstInterval or fInterval
	if not _scheduleID then
		_scheduleID = Scheduler.schedule( _tick, 1)
	end

	if firstInterval <= 0 then
		--如果第一次执行时间为0，则立刻执行一次
		nHandler(data)
		firstInterval = fInterval
	end
	local time = HeartBeatManager.getGlobalTime() + firstInterval
	_id = _id + 1
	local info = {time = time, handler = nHandler, data = data, id = _id, nRepeat = nRepeat, times = 0, interval = fInterval, callbackTimes = callbackTimes}
	_insertSchedule(info)
	return _id
end

function scheduleOnce( nHandler, fInterval, data )
	return _schedule(nHandler, fInterval, data, 1)
end

--firstInterval，第一次的间隔时间，可以和后面的间隔时间不同
--例如现在为7点，每天8点定时执行，那么第一次间隔就是1小时，后面为1天
--callbackTimes,当一个tick执行会触发多次回调时，如果callbackTimes为true，则会改为只触发一次回调，并将触发次数传递给回调
function schedule(nHandler, fInterval, data, firstInterval, callbackTimes)
	return _schedule(nHandler, fInterval, data, nil, firstInterval, callbackTimes)
end

function scheduleForRepeat(nHandler, fInterval, data, nRepeat, firstInterval, callbackTimes)
	return _schedule( nHandler, fInterval, data, nRepeat, firstInterval, callbackTimes)
end

--每天定时执行
--timeStr, 配表或服务端传递过来的时间，例如 15|20|00 每天15:20执行
function scheduleEveryDay(nHandler, timeStr, data)
	local time = HeartBeatManager.getPeriodByData(timeStr) 
	if time < 0 then
		time = time + 86400
	end
	schedule(nHandler, 86400, data, time)
end

function unschedule( entryId )
   	for i,info in ipairs(_scheduleList) do 
        if info.id == entryId then 
            table.remove(_scheduleList,i) 
            return
        end 
    end 
end