module("EventSystem", package.seeall)

local _eventListenerCache = {}

local KEY_EVENT_TYPE = 1
local KEY_EVENT_CALLBACK = 2

-- 消息的优先级 分三级
PRIORITY_LEVEL = {
	HIGH   = 1,
	NORMAL = 2,
	LOW    = 3,
}

local function cacheListener( eventType, callback, priority )
	if _eventListenerCache[eventType] == nil then
		_eventListenerCache[eventType] = {}

		for k,v in pairs(PRIORITY_LEVEL) do
			_eventListenerCache[eventType][v] = {}
		end
	end

	local cacheObj = {
						[KEY_EVENT_TYPE] = eventType,
						[KEY_EVENT_CALLBACK] = callback,
					 }

	local caches = _eventListenerCache[eventType]


	for i,v in ipairs(caches[priority or PRIORITY_LEVEL.NORMAL]) do
		if v[KEY_EVENT_CALLBACK] == callback then
			return false
		end
	end

	table.insert(caches[priority or PRIORITY_LEVEL.NORMAL], cacheObj)

	return true
end

function registerEventListener( eventType, callback, priority )
	if callback == nil then
        error("\n\n***ERROR*** callback is nil  ***ERROR***")
	end

	if cacheListener(eventType, callback, priority) then
		log("EventSystem: registered event " .. eventType .. " success")
	else
		log("EventSystem: cannot repeat registered event " .. tostring(eventType))
	end
end

function unregisterEventListener( eventType, callback, priority )
	if eventType == nil then
		error("\n\n####### EVENT_TYPE is nil #######\n")
	end

	if callback == nil then
		error("\n\n####### callback is nil #######\n")
	end

	local caches = _eventListenerCache[eventType]

	if caches == nil then
		log("EventSystem: nothing has registered with " .. eventType)
		return
	end

	local unregister = false

	for i,v in ipairs(caches[priority or PRIORITY_LEVEL.NORMAL]) do
		if v[KEY_EVENT_CALLBACK] == callback then
			table.remove(caches[priority or PRIORITY_LEVEL.NORMAL], i)
			unregister = true
			log("EventSystem: unregisterEventListener " .. eventType .. " success")
			break
		end
	end

	if not unregister then
		log("EventSystem: has not registered with " .. eventType)
	end
end

function dispatchEvent( eventType, data )
	local caches = _eventListenerCache[eventType]

	if caches then
		for _,prioritylist in ipairs(caches) do
			for _, v in ipairs(prioritylist) do
				if v and v[KEY_EVENT_CALLBACK] then
					v[KEY_EVENT_CALLBACK]( data )
				end
			end
		end
	end

end