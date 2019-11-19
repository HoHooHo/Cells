module("Scheduler", package.seeall)

local _schedulerCache = {}
local _restarting = false

function schedule( nHandler, fInterval, data )
	if nHandler == nil then
        error("\n\n***ERROR*** nHandler is nil  ***ERROR***")
	end

	-- log("Scheduler:  schedule  fInterval = "..fInterval)

	local callback = function ( dt )
		if not _restarting then
			nHandler( data, dt )
		end
	end

	return cc.Director:getInstance():getScheduler():scheduleScriptFunc(callback, fInterval, false)
end

function scheduleOnce( nHandler, fInterval, data )
	if nHandler == nil then
        error("\n\n***ERROR*** nHandler is nil  ***ERROR***")
	end

	local entryId = nil

	local callback = function ( dt )
		if not _restarting then
			-- log("Scheduler:  scheduleOnce entryId = " .. entryId)
			unschedule(entryId)
			nHandler( data, dt )
		end
	end
	entryId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(callback, fInterval, false)
	-- log("Scheduler:  scheduleOnce  fInterval = "..fInterval .. " entryId = " .. entryId)

	return entryId
end

function scheduleForRepeat( nHandler, fInterval, data, nRepeat )
	if nHandler == nil then
        error("\n\n***ERROR*** nHandler is nil  ***ERROR***")
	end
	
	local entryId = nil
	local count = 0

	local callback = function ( dt )

		if not _restarting then
			count = count + 1
			if count >= nRepeat then
				unschedule(entryId)
			end
			
			nHandler( data, count, dt )
		end
	end

	entryId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(callback, fInterval, false)
	-- log("Scheduler:  scheduleForRepeat  fInterval = "..fInterval.." repeat = "..nRepeat .. " entryId = " .. entryId)
	
	return entryId
end


local _battleEntrys = {}

function scheduleBattleOnce( nHandler, fInterval, data )
	if nHandler == nil then
        error("\n\n***ERROR*** nHandler is nil  ***ERROR***")
	end

	local entryId = nil

	local callback = function ( dt )
		_battleEntrys[entryId] = nil

		if not _restarting then
			unschedule(entryId)
			nHandler( data, dt )
		end
	end

	entryId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(callback, fInterval, false)
	_battleEntrys[entryId] = true

	return entryId
end


function unschedule( entryId )
	-- log("Scheduler:  unschedule  entryId = "..entryId)
	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(entryId)
end

function onRestart(  )
	_restarting = true
end
setRestartListener(onRestart)


local function battleEnd()
	for k,v in pairs(_battleEntrys) do
		if v then
			unschedule( k )
		end
	end

	_battleEntrys = {}
end

EventSystem.registerEventListener(EventType.BATTLE_END, battleEnd)